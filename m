Return-path: <mchehab@gaivota>
Received: from smtp-vbr7.xs4all.nl ([194.109.24.27]:4567 "EHLO
	smtp-vbr7.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753331Ab0L0MB2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 27 Dec 2010 07:01:28 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH 3/6] Documentation/ioctl/ioctl-number.txt: Remove some now freed ioctl ranges
Date: Mon, 27 Dec 2010 13:01:21 +0100
References: <cover.1293449547.git.mchehab@redhat.com> <20101227093839.09aebd15@gaivota>
In-Reply-To: <20101227093839.09aebd15@gaivota>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201012271301.21722.hverkuil@xs4all.nl>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

On Monday, December 27, 2010 12:38:39 Mauro Carvalho Chehab wrote:
> The V4L1 removal patches removed a few ioctls. Update it at the docspace.
> 
> Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
> 
> diff --git a/Documentation/ioctl/ioctl-number.txt b/Documentation/ioctl/ioctl-number.txt
> index 63ffd78..49d7f00 100644
> --- a/Documentation/ioctl/ioctl-number.txt
> +++ b/Documentation/ioctl/ioctl-number.txt
> @@ -260,14 +260,11 @@ Code  Seq#(hex)	Include File		Comments
>  't'	80-8F	linux/isdn_ppp.h
>  't'	90	linux/toshiba.h
>  'u'	00-1F	linux/smb_fs.h		gone
> -'v'	all	linux/videodev.h	conflict!
>  'v'	00-1F	linux/ext2_fs.h		conflict!
>  'v'	00-1F	linux/fs.h		conflict!
>  'v'	00-0F	linux/sonypi.h		conflict!
> -'v'	C0-CF	drivers/media/video/ov511.h	conflict!
>  'v'	C0-DF	media/pwc-ioctl.h	conflict!
>  'v'	C0-FF	linux/meye.h		conflict!
> -'v'	C0-CF	drivers/media/video/zoran/zoran.h	conflict!
>  'v'	D0-DF	drivers/media/video/cpia2/cpia2dev.h	conflict!
>  'w'	all				CERN SCI driver
>  'y'	00-1F				packet based user level communications
> 

There is also a line for media/ovcamchip.h in this file that can be removed.
The media/rds.h line can also be removed (this is kernel internal only).
Ditto for media/bt819.h.

All other patches in this series:

Reviewed-by: Hans Verkuil <hverkuil@xs4all.nl>

BTW, it is probably also a good idea to move the dabusb driver to staging and
mark it for removal in 2.6.39.

Regards,

	Hans

-- 
Hans Verkuil - video4linux developer - sponsored by Cisco
