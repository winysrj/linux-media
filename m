Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:11185 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758044Ab2C1OHg (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 28 Mar 2012 10:07:36 -0400
Message-ID: <4F731BA0.9020809@redhat.com>
Date: Wed, 28 Mar 2012 16:09:36 +0200
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH 09/10] uvcvideo: Properly report the inactive flag for
 inactive controls
References: <1332676610-14953-1-git-send-email-hdegoede@redhat.com> <1332676610-14953-10-git-send-email-hdegoede@redhat.com> <4797188.KPbmRBAMVG@avalon>
In-Reply-To: <4797188.KPbmRBAMVG@avalon>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

Thanks for the reviews!

On 03/28/2012 11:12 AM, Laurent Pinchart wrote:
> Hi Hans,
>
> Thanks for the patch.
>
> On Sunday 25 March 2012 13:56:49 Hans de Goede wrote:
>> Note the unused in this patch slave_ids addition to the mappings will get
>> used in a follow up patch to generate control change events for the slave
>> ctrls when their flags change due to the master control changing value.
>>
>> Signed-off-by: Hans de Goede<hdegoede@redhat.com>
>> ---
>>   drivers/media/video/uvc/uvc_ctrl.c |   33 +++++++++++++++++++++++++++++++++
>> drivers/media/video/uvc/uvcvideo.h |    4 ++++
>>   2 files changed, 37 insertions(+)
>>
>> diff --git a/drivers/media/video/uvc/uvc_ctrl.c
>> b/drivers/media/video/uvc/uvc_ctrl.c index 742496f..91d9007 100644
>> --- a/drivers/media/video/uvc/uvc_ctrl.c
>> +++ b/drivers/media/video/uvc/uvc_ctrl.c
>
> [snip]
>
>> @@ -943,6 +961,8 @@ static int __uvc_query_v4l2_ctrl(struct uvc_video_chain
>> *chain, struct uvc_control_mapping *mapping,
>>   	struct v4l2_queryctrl *v4l2_ctrl)
>>   {
>> +	struct uvc_control_mapping *master_map;
>> +	struct uvc_control *master_ctrl = NULL;
>>   	struct uvc_menu_info *menu;
>>   	unsigned int i;
>>   	int ret = 0;
>> @@ -958,6 +978,19 @@ static int __uvc_query_v4l2_ctrl(struct uvc_video_chain
>> *chain, if (!(ctrl->info.flags&  UVC_CTRL_FLAG_SET_CUR))
>>   		v4l2_ctrl->flags |= V4L2_CTRL_FLAG_READ_ONLY;
>>
>> +	if (mapping->master_id)
>> +		master_ctrl = uvc_find_control(chain, mapping->master_id,
>> +					&master_map);
>
> As an optimization, do you think it would make sense to add a struct
> uvc_contro *master_ctrl field to struct uvc_control_mapping, and fill it in
> uvc_ctrl_init_ctrl() ? That would require a loop over the mappings at
> initialization time, but would get rid of the search operation at runtime. The
> master_ctrl->info.flags&  UVC_CTRL_FLAG_GET_CUR check would be performed at
> initialization time as well, and master_ctrl would be left NULL it the master
> control doesn't support the GET_CUR query.

That sounds like a worthwhile optimization. I'll do that in my next revision
of this patch-set. I'm not entirely sure when I'll have time to do the next
revision, but I assume this won't go in until 3.5 so we've plenty of time
for now.

Regards,

Hans
