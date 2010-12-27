Return-path: <mchehab@gaivota>
Received: from mx1.redhat.com ([209.132.183.28]:61643 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753714Ab0L0NKU (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 27 Dec 2010 08:10:20 -0500
Message-ID: <4D189037.2000506@redhat.com>
Date: Mon, 27 Dec 2010 11:10:15 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH 3/6] Documentation/ioctl/ioctl-number.txt: Remove some
 now freed ioctl ranges
References: <cover.1293449547.git.mchehab@redhat.com> <20101227093839.09aebd15@gaivota> <201012271301.21722.hverkuil@xs4all.nl>
In-Reply-To: <201012271301.21722.hverkuil@xs4all.nl>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

Em 27-12-2010 10:01, Hans Verkuil escreveu:
> On Monday, December 27, 2010 12:38:39 Mauro Carvalho Chehab wrote:
>> The V4L1 removal patches removed a few ioctls. Update it at the docspace.
>>
>> Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
>>

Reviewed version, removing also ovcamchip.h.

Cheers,
Mauro


commit 49962bb3d96c7b174198dc6fe7103426512ac2aa
Author: Mauro Carvalho Chehab <mchehab@redhat.com>
Date:   Mon Dec 27 09:13:12 2010 -0200

    Documentation/ioctl/ioctl-number.txt: Remove some now freed ioctl ranges
    
    The V4L1 removal patches removed a few ioctls. Update it at the docspace.
    
    Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

diff --git a/Documentation/ioctl/ioctl-number.txt b/Documentation/ioctl/ioctl-number.txt
index 63ffd78..b2400d7 100644
--- a/Documentation/ioctl/ioctl-number.txt
+++ b/Documentation/ioctl/ioctl-number.txt
@@ -260,14 +260,11 @@ Code  Seq#(hex)	Include File		Comments
 't'	80-8F	linux/isdn_ppp.h
 't'	90	linux/toshiba.h
 'u'	00-1F	linux/smb_fs.h		gone
-'v'	all	linux/videodev.h	conflict!
 'v'	00-1F	linux/ext2_fs.h		conflict!
 'v'	00-1F	linux/fs.h		conflict!
 'v'	00-0F	linux/sonypi.h		conflict!
-'v'	C0-CF	drivers/media/video/ov511.h	conflict!
 'v'	C0-DF	media/pwc-ioctl.h	conflict!
 'v'	C0-FF	linux/meye.h		conflict!
-'v'	C0-CF	drivers/media/video/zoran/zoran.h	conflict!
 'v'	D0-DF	drivers/media/video/cpia2/cpia2dev.h	conflict!
 'w'	all				CERN SCI driver
 'y'	00-1F				packet based user level communications
@@ -278,7 +275,6 @@ Code  Seq#(hex)	Include File		Comments
 					<mailto:oe@port.de>
 'z'	10-4F	drivers/s390/crypto/zcrypt_api.h	conflict!
 0x80	00-1F	linux/fb.h
-0x88	00-3F	media/ovcamchip.h
 0x89	00-06	arch/x86/include/asm/sockios.h
 0x89	0B-DF	linux/sockios.h
 0x89	E0-EF	linux/sockios.h		SIOCPROTOPRIVATE range

