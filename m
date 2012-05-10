Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:42848 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756681Ab2EJIVa (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 10 May 2012 04:21:30 -0400
Message-ID: <4FAB7A7F.2020601@redhat.com>
Date: Thu, 10 May 2012 10:21:19 +0200
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [RFCv1 PATCH 2/5] v4l2-dev/ioctl: determine the valid ioctls
 upfront.
References: <1336633514-4972-1-git-send-email-hverkuil@xs4all.nl> <e75979b946d3934cbfb12e8b5518bcbbb891ceee.1336632433.git.hans.verkuil@cisco.com> <4FAB77ED.9000105@redhat.com>
In-Reply-To: <4FAB77ED.9000105@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On 05/10/2012 10:10 AM, Hans de Goede wrote:

<snip>

>> @@ -526,19 +518,28 @@ static long __video_do_ioctl(struct file *file,
>> return ret;
>> }
>>
>> - if ((vfd->debug& V4L2_DEBUG_IOCTL)&&
>> - !(vfd->debug& V4L2_DEBUG_IOCTL_ARG)) {
>> - v4l_print_ioctl(vfd->name, cmd);
>> - printk(KERN_CONT "\n");
>> - }
>> -
>> if (test_bit(V4L2_FL_USES_V4L2_FH,&vfd->flags)) {
>> vfh = file->private_data;
>> use_fh_prio = test_bit(V4L2_FL_USE_FH_PRIO,&vfd->flags);
>> + if (use_fh_prio)
>> + ret_prio = v4l2_prio_check(vfd->prio, vfh->prio);
>> }
>>
>> - if (use_fh_prio)
>> - ret_prio = v4l2_prio_check(vfd->prio, vfh->prio);
>> + if (v4l2_is_valid_ioctl(cmd)) {
>
> I would prefer for this check to be the first check in the function
> in the form of:
>
> if (!v4l2_is_valid_ioctl(cmd))
> return -ENOTTY;
>

Oops, sorry we cannot do that because the drv my have its own
custom ioctls handled by the default case <sigh>, so scrap this.

> This will drop an indentation level from the code below and also drop an
> indentation level from the prio check introduced in a later patch,
> making the end result much more readable IMHO.
>
>> + struct v4l2_ioctl_info *info =&v4l2_ioctls[_IOC_NR(cmd)];
>> +
>> + if (!test_bit(_IOC_NR(cmd), vfd->valid_ioctls)) {
>> + if (!(info->flags& INFO_FL_CTRL) ||
>> + !(vfh&& vfh->ctrl_handler))
>> + return -ENOTTY;
>  > + }
>  > + }
>

I still think the above can be simplified a bit, in the form of:
	if (!test_bit(_IOC_NR(cmd), vfd->valid_ioctls) &&
	    !((info->flags & INFO_FL_CTRL) && vfh && vfh->ctrl_handler))
		return -ENOTYY;

Regards,

Hans
