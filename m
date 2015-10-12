Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud3.xs4all.net ([194.109.24.30]:37137 "EHLO
	lb3-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752035AbbJLH6N (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 12 Oct 2015 03:58:13 -0400
Message-ID: <561B6798.7070909@xs4all.nl>
Date: Mon, 12 Oct 2015 09:56:08 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Antonio Ospite <ao2@ao2.it>, linux-media@vger.kernel.org
CC: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Subject: Re: v4l2-ctrl is unable to set autogain to 0 with gspca/ov534
References: <20151007100524.3fc05282628a153591f5c13e@ao2.it>
In-Reply-To: <20151007100524.3fc05282628a153591f5c13e@ao2.it>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Antonio,

On 10/07/2015 10:05 AM, Antonio Ospite wrote:
> Hi,
> 
> It looks like it is not possible to set the autogain from 1 to 0 using
> v4l2-ctrl with the driver I am using.
> 
> I am testing with the gspca/ov534 driver, and this sequence of commands
> does not change the value of the control:
> 
>   v4l2-ctl --set-ctrl=gain_automatic=1
>   v4l2-ctl --list-ctrls | grep gain_automatic
>   # The following does not work
>   v4l2-ctl --set-ctrl=gain_automatic=0
>   v4l2-ctl --list-ctrls | grep gain_automatic
> 
> The same thing happens with guvcview, but setting the control with qv4l2
> works fine.
> 
> After a little investigation I figured out some more details: in my use
> case the autogain is a master control in an auto cluster, and switching
> it from auto to manual does not work when using VIDIOC_S_CTRL i.e. when
> calling set_ctrl().
> 
> It works with qv4l2 because it uses VIDIOC_S_EXT_CTRLS.
> 
> So the difference is between v4l2-ctrls.c::v4l2_s_ctrl() and
> v4l2-ctrls.c::v4l2_s_ext_ctrls().
> 
> Wrt. auto clusters going from auto to manual the two functions do
> basically this:
> 
> 
>   v4l2_s_ctrl()
>     set_ctrl_lock()
>       user_to_new()
>       set_ctrl()
>         update_from_auto_cluster(master)
>         try_or_set_cluster()
>       cur_to_user()
>         
>     
>   v4l2_s_ext_ctrls()
>     try_set_ext_ctrls()
>       update_from_auto_cluster(master)
>       user_to_new() for each control
>       try_or_set_cluster()
>       new_to_user()
> 
> 
> I think the problem is that when update_from_auto_cluster(master) is
> called it overrides the new master control value from userspace by
> calling cur_to_new(). This also happens when calling VIDIOC_S_EXT_CTRLS
> (in try_set_ext_ctrls), but in that case, AFTER the call to
> update_from_auto_cluster(master), the code calls user_to_new() that sets
> back again the correct new value in the control before making the value
> permanent with try_or_set_cluster().
> 
> The regression may have been introduced in
> 5d0360a4f027576e5419d4a7c711c9ca0f1be8ca, in fact by just reverting
> these two interdependent commits:
> 
> 7a7f1ab37dc8f66cf0ef10f3d3f1b79ac4bc67fc
> 5d0360a4f027576e5419d4a7c711c9ca0f1be8ca
> 
> the problem goes away, so the regression is about user_to_new() not
> being called AFTER update_from_auto_cluster(master) anymore in
> set_ctrl(), as per 5d0360a4f027576e5419d4a7c711c9ca0f1be8ca.

Excellent analysis!

> 
> A quick and dirty fixup could look like this:
> 
> diff --git a/drivers/media/v4l2-core/v4l2-ctrls.c b/drivers/media/v4l2-core/v4l2-ctrls.c
> index b6b7dcc..55d78fc 100644
> --- a/drivers/media/v4l2-core/v4l2-ctrls.c
> +++ b/drivers/media/v4l2-core/v4l2-ctrls.c
> @@ -3198,8 +3198,11 @@ static int set_ctrl(struct v4l2_fh *fh, struct v4l2_ctrl *ctrl, u32 ch_flags)
>            manual mode we have to update the current volatile values since
>            those will become the initial manual values after such a switch. */
>         if (master->is_auto && master->has_volatiles && ctrl == master &&
> -           !is_cur_manual(master) && ctrl->val == master->manual_mode_value)
> +           !is_cur_manual(master) && ctrl->val == master->manual_mode_value) {
> +               s32 new_auto_val = master->val;
>                 update_from_auto_cluster(master);
> +               master->val = new_auto_val;
> +       }
> 
>         ctrl->is_new = 1;
>         return try_or_set_cluster(fh, master, true, ch_flags);
> 
> 
> However I think that calling user_to_new() after
> update_from_auto_cluster() has always been masking a bug in the latter.
> 
> Maybe this is a better fix, in place of the one above.
> 
> diff --git a/drivers/media/v4l2-core/v4l2-ctrls.c b/drivers/media/v4l2-core/v4l2-ctrls.c
> index b6b7dcc..19fc06e 100644
> --- a/drivers/media/v4l2-core/v4l2-ctrls.c
> +++ b/drivers/media/v4l2-core/v4l2-ctrls.c
> @@ -3043,7 +3043,7 @@ static void update_from_auto_cluster(struct v4l2_ctrl *master)
>  {
>         int i;
> 
> -       for (i = 0; i < master->ncontrols; i++)
> +       for (i = 1; i < master->ncontrols; i++)
>                 cur_to_new(master->cluster[i]);
>         if (!call_op(master, g_volatile_ctrl))
>                 for (i = 1; i < master->ncontrols; i++)
> 

I agree, this is the right fix.

> 
> We can assume that the master control in an auto cluster is always the
> first one, can't we? With the change above we don't override the new
> value of the master control, in this case when it's being changed from
> auto to manual.
> 
> I may be missing some details tho, so I am asking if my reasoning is
> correct before sending a proper patch. And should I CC stable on it as
> the change fixes a regression?

Just post the patch to linux-media, but add this line after your Signed-off-by:

Cc: <stable@vger.kernel.org>      # for v3.17 and up

Thanks for looking at this!

Regards,

	Hans
