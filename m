Return-path: <mchehab@gaivota>
Received: from smtp-vbr2.xs4all.nl ([194.109.24.22]:1800 "EHLO
	smtp-vbr2.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753746Ab0L0NXn (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 27 Dec 2010 08:23:43 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Re: [PATCH 3/6] Documentation/ioctl/ioctl-number.txt: Remove some now freed ioctl ranges
Date: Mon, 27 Dec 2010 14:23:26 +0100
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
References: <cover.1293449547.git.mchehab@redhat.com> <201012271301.21722.hverkuil@xs4all.nl> <4D188E87.9010700@redhat.com>
In-Reply-To: <4D188E87.9010700@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201012271423.26288.hverkuil@xs4all.nl>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

On Monday, December 27, 2010 14:03:03 Mauro Carvalho Chehab wrote:
> Em 27-12-2010 10:01, Hans Verkuil escreveu:
> > On Monday, December 27, 2010 12:38:39 Mauro Carvalho Chehab wrote:
> >> The V4L1 removal patches removed a few ioctls. Update it at the docspace.
> >>
> >> Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
> >>
> >> diff --git a/Documentation/ioctl/ioctl-number.txt b/Documentation/ioctl/ioctl-number.txt
> >> index 63ffd78..49d7f00 100644
> >> --- a/Documentation/ioctl/ioctl-number.txt
> >> +++ b/Documentation/ioctl/ioctl-number.txt
> >> @@ -260,14 +260,11 @@ Code  Seq#(hex)	Include File		Comments
> >>  't'	80-8F	linux/isdn_ppp.h
> >>  't'	90	linux/toshiba.h
> >>  'u'	00-1F	linux/smb_fs.h		gone
> >> -'v'	all	linux/videodev.h	conflict!
> >>  'v'	00-1F	linux/ext2_fs.h		conflict!
> >>  'v'	00-1F	linux/fs.h		conflict!
> >>  'v'	00-0F	linux/sonypi.h		conflict!
> >> -'v'	C0-CF	drivers/media/video/ov511.h	conflict!
> >>  'v'	C0-DF	media/pwc-ioctl.h	conflict!
> >>  'v'	C0-FF	linux/meye.h		conflict!
> >> -'v'	C0-CF	drivers/media/video/zoran/zoran.h	conflict!
> >>  'v'	D0-DF	drivers/media/video/cpia2/cpia2dev.h	conflict!
> >>  'w'	all				CERN SCI driver
> >>  'y'	00-1F				packet based user level communications
> >>
> > 
> > There is also a line for media/ovcamchip.h in this file that can be removed.
> 
> Ok, I'll do that.
> 
> > The media/rds.h line can also be removed (this is kernel internal only).
> 
> There are two rds.h, related to V4L:
> ./include/linux/rds.h

Not related to V4L, this is something from Oracle. It is this header that is public,
not the media/rds.h header.

> ./include/media/rds.h
> 
> One of them is at the public api:
> 
> include/linux/Kbuild:header-y += rds.h
> 
> Btw, that's weird:
> 
> $ git grep RDS_CMD_OPEN
> drivers/media/video/saa6588.c:    case RDS_CMD_OPEN:
> include/media/rds.h:#define RDS_CMD_OPEN  _IOW('R',1,int)
> 
> as saa6588 is a subdev.
> 
> IMO, we should remove or rename the internal header first.

media/rds.h should be renamed to media/saa6588.h. It is also included in
drivers/media/radio/si470x/radio-si470x.h, but that's obsolete and can be
removed.
 
> > Ditto for media/bt819.h.
> 
> There are also some issues there related to videodev2 stuff.
> 
> I prefer to apply the path as-is (just removing the ovcamchip.h) and,
> on some later cleanup, check and fix the remaining stuff.

I can make a patch fixing the rds.h header usage. It's all internal stuff
and the weird naming is just historical and should be changed.

> > 
> > All other patches in this series:
> > 
> > Reviewed-by: Hans Verkuil <hverkuil@xs4all.nl>
> 
> Thanks!
> > 
> > BTW, it is probably also a good idea to move the dabusb driver to staging and
> > mark it for removal in 2.6.39.
> 
> Not sure about that. I don't see any good reason to remove dabusb driver, as
> nobody reported that it is broken.

Nobody has the hardware :-)

I know you have asked the authors about a possible removal of this driver a few
months ago. Did you get any reply from them?

It seems to be a demonstration driver only and I've never seen anyone with the
hardware.

Regards,

	Hans

> > 
> > Regards,
> > 
> > 	Hans
> > 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

-- 
Hans Verkuil - video4linux developer - sponsored by Cisco
