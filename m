Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:13694 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754675Ab1KWMvP (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 23 Nov 2011 07:51:15 -0500
Message-ID: <4ECCEC3E.5000202@redhat.com>
Date: Wed, 23 Nov 2011 10:51:10 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: Martin Dauskardt <martin.dauskardt@gmx.de>,
	linux-media@vger.kernel.org
Subject: Re: [RFC PATCH 4/4] ivtv: implement new decoder command ioctls.
References: <201111231254.18805.martin.dauskardt@gmx.de> <201111231314.42496.hverkuil@xs4all.nl>
In-Reply-To: <201111231314.42496.hverkuil@xs4all.nl>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 23-11-2011 10:14, Hans Verkuil escreveu:
> On Wednesday, November 23, 2011 12:54:18 Martin Dauskardt wrote:
>> Hi Hans,
>>
>> I am not sure if I understand this right. You wrote:
>>
>> "Comments are added on how to convert the legacy ioctls to standard V4L2 API 
>> in applications. Perhaps these legacy ioctls in ivtv can even be removed in a 
>> few years time."
>>
>> But the patch looks for me as if the currently used ioctls shall be removed 
>> now, which would immidiately break existing applications.
> 
> ??? I'm not removing anything. All current ioctls remain present.

I'd prefer to deprecate its usage on ivtv and remove it after a few kernel versions,
but there's no rush.

So, it would be better if the existing application(s) could detect  if the new ioctl 
is present or not, and use it instead of the legacy one.

Assuming that this patch enters into kernel 3.3, the ioctl's will be there at least
up to 3.5. So, we have some time to make sure that userspace will be ready for it,
when the old ioctl's got deprecated.

In other words, the better strategy seems to apply those patches for 3.3, change the
existing applications to work with either way, and then schedule when the existing
behavior will no longer be supported inside kernel (3.5? 3.6? 3.8?). A compat code 
might be added at libv4l, but IMO, it seems an overkill, as there are very few 
applications using this feature for ivtv.

>> This is an example of the currently used code:
>>
>> void cPvr350Device::DecoderStop(int blank)
>> {
>> 	struct video_command cmd;
>> 	memset(&cmd, 0, sizeof(cmd));
>> 	cmd.cmd = VIDEO_CMD_STOP;
>> 	if (blank) {
>> 		cmd.flags = VIDEO_CMD_STOP_TO_BLACK | VIDEO_CMD_STOP_IMMEDIATELY;
>> 	} else { //show last frame instead of a black screen
>> 		cmd.flags = VIDEO_CMD_STOP_IMMEDIATELY;
>> 	}
>> 	if (IOCTL(fd_out, VIDEO_COMMAND, &cmd) < 0) {
>> 		log(pvrERROR, "pvr350: VIDEO_CMD_STOP %s error=%d:%s", 
>> 			blank ? "(blank)" : "", errno, strerror(errno));
>> 	}
>> }
>>
>> As far as I know my pvr350-Plugin for vdr is the only application which uses 
>> the hardware decoder of the PVR350 (mythtv has dropped support some years 
>> ago). There are only a few users left in time of HDTV. 
>> I don't really understand why it is necessary to do this changes. 
> 
> It's an DVB/V4L API cleanup: these ioctls ended up in the DVB API when they
> should have been part of the V4L API. We're cleaning this up, especially
> since the decoder API might become relevant for embedded systems where decoder
> support is much more common.
> 
>> I suggest to increase the ivtv driver version number when implementing the 
>> changes. The application (which must be backward compatible) should be able to 
>> determine which ioctl it has to use.
> 
> These days the version number of all drivers is the same as the kernel version
> number, so it is easy to check when new ioctls became available.

Yes. This applies for kernel >= 3.1. Also, on those Kernels, if an ioctl is not
available, the return code is different (ENOTTY).

>> It would be much better if the ivtv driver would continue to support the old 
>> ioctl for the few years we still have any PVR350 user.
> 
> Don't worry, I won't be removing anything.
> 
> I checked the plugin code and you aren't using VIDEO_GET_EVENT. The VIDEO_GET_EVENT
> ioctl is the only one I'd really like to get rid of in ivtv in favor of the
> V4L2 event API. It's only used as far as I can tell in ivtv-ctl and ivtvplay,
> both ivtv utilities that can easily be changed.
> 
> Are you perhaps aware of any other userspace applications that use that
> ioctl?
> 
> Regards,
> 
> 	Hans
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

