Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout-de.gmx.net ([213.165.64.22]:53161 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754839Ab1KXXe5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 24 Nov 2011 18:34:57 -0500
From: Oliver Endriss <o.endriss@gmx.de>
Reply-To: linux-media@vger.kernel.org
To: linux-media@vger.kernel.org
Subject: Re: [RFC PATCH 0/4] Replace VIDEO_COMMAND with VIDIOC_DECODER_CMD
Date: Fri, 25 Nov 2011 00:20:43 +0100
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>
References: <1322046756-22870-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1322046756-22870-1-git-send-email-hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201111250020.44306@orion.escape-edv.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

no matter what that workshop discussed:
*** It is not acceptable to change the DVB kernel <-> user-space API! ***

The av7110 driver is working for years and still in use.

I hereby NACK any attempt to remove dvb/audio.h or dvb/video.h.

Nacked-by: Oliver Endriss <o.endriss@gmx.de>

On Wednesday 23 November 2011 12:12:32 Hans Verkuil wrote:
> During the 2011 workshop we discussed replacing the decoder commands in
> include/linux/dvb/video.h and audio.h by a proper V4L2 API.
> 
> This patch series is the first phase of that. It adds new VIDIOC_(TRY_)DECODER_CMD
> ioctls to the V4L2 API. These are identical to the VIDEO_(TRY_)COMMAND from
> dvb/video.h, but the names of the fields and defines now conform to the V4L2
> API conventions.
> 
> Documentation has been added and ivtv (the only V4L2 driver that used VIDEO_COMMAND)
> has been adapted to support the new V4L2 API.
> 
> I do have one question for Mauro: what do you want to do with video.h? Should it be
> removed altogether eventually?
> 
> Some of the commands defined there aren't used by any driver (e.g. VIDEO_GET_NAVI),
> some are specific to the av7110 driver (e.g. VIDEO_STILLPICTURE), some are specific
> to ivtv (VIDEO_COMMAND) and some are used by both ivtv and av7110 (e.g. VIDEO_PLAY).
> 
> My proposal would be to:
> 
> 1) remove anything that is not used by any driver from audio.h and video.h
> 2) move av7110 specific stuff to a new linux/av7110.h header
> 3) move ivtv specific stuff to the linux/ivtv.h header
> 4) shared code should be moved to the new linux/av7110.h header and also copied
>    to linux/ivtv.h. The ivtv version will rename the names (e.g. VIDEO_ becomes
>    IVTV_) but is otherwise unchanged to preserve the ABI. Comments are added
>    on how to convert the legacy ioctls to standard V4L2 API in applications.
>    Perhaps these legacy ioctls in ivtv can even be removed in a few years time.
> 5) remove linux/dvb/audio.h and video.h.
> 
> What do you think, Mauro?
> 
> Regards,
> 
> 	Hans

-- 
----------------------------------------------------------------
VDR Remote Plugin 0.4.0: http://www.escape-edv.de/endriss/vdr/
4 MByte Mod: http://www.escape-edv.de/endriss/dvb-mem-mod/
Full-TS Mod: http://www.escape-edv.de/endriss/dvb-full-ts-mod/
----------------------------------------------------------------
