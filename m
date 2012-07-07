Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:45173 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751081Ab2GGTU3 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 7 Jul 2012 15:20:29 -0400
Message-ID: <4FF88C1C.5010402@redhat.com>
Date: Sat, 07 Jul 2012 21:21:00 +0200
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: Mauro Carvalho Chehab <mchehab@infradead.org>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH] v4l2-ioctl: Don't assume file->private_data always points
 to a v4l2_fh
References: <1341686781-2013-1-git-send-email-hdegoede@redhat.com> <201207072111.11951.hverkuil@xs4all.nl>
In-Reply-To: <201207072111.11951.hverkuil@xs4all.nl>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On 07/07/2012 09:11 PM, Hans Verkuil wrote:
> On Sat July 7 2012 20:46:21 Hans de Goede wrote:
>> Commit efbceecd4522a41b8442c6b4f68b4508d57d1ccf, adds a number of helper
>> functions for ctrl related ioctls to v4l2-ioctl.c, these helpers assume that
>> if file->private_data != NULL, it points to a v4l2_fh, which is only the case
>> for drivers which actually use v4l2_fh.
>>
>> This breaks for example bttv which use the "filedata" pointer for its own uses,
>> and now all the ctrl ioctls try to use whatever its filedata points to as
>> v4l2_fh and think it has a ctrl_handler, leading to:
>>
>> [  142.499214] BUG: unable to handle kernel NULL pointer dereference at 0000000000000021
>> [  142.499270] IP: [<ffffffffa01cb959>] v4l2_queryctrl+0x29/0x230 [videodev]
>> [  142.514649]  [<ffffffffa01c7a77>] v4l_queryctrl+0x47/0x90 [videodev]
>> [  142.517417]  [<ffffffffa01c58b1>] __video_do_ioctl+0x2c1/0x420 [videodev]
>> [  142.520116]  [<ffffffffa01c7ee6>] video_usercopy+0x1a6/0x470 [videodev]
>> ...
>>
>> This patch adds the missing test_bit(V4L2_FL_USES_V4L2_FH, &vfd->flags) tests
>> to the ctrl ioctl helpers v4l2_fh paths, fixing the issues with for example
>> the bttv driver.
>
> Urgh, I didn't test with a 'old' driver. Thanks for catching this. But I would
> prefer a simpler patch (although effectively the same) like this:
>
> diff --git a/drivers/media/video/v4l2-ioctl.c b/drivers/media/video/v4l2-ioctl.c
> index 70e0efb..bbcb4f6 100644
> --- a/drivers/media/video/v4l2-ioctl.c
> +++ b/drivers/media/video/v4l2-ioctl.c
> @@ -1486,7 +1486,7 @@ static int v4l_queryctrl(const struct v4l2_ioctl_ops *ops,
>   {
>   	struct video_device *vfd = video_devdata(file);
>   	struct v4l2_queryctrl *p = arg;
> -	struct v4l2_fh *vfh = fh;
> +	struct v4l2_fh *vfh = test_bit(V4L2_FL_USES_V4L2_FH, &vfd->flags) ? fh : NULL;
>
>   	if (vfh && vfh->ctrl_handler)
>   		return v4l2_queryctrl(vfh->ctrl_handler, p);

<snip>

I agree that that is better, so I've added that version to my tree now, for which I
expect / hope to send a pullreq later tonight.

Regards,

Hans

