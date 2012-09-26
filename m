Return-path: <linux-media-owner@vger.kernel.org>
Received: from ams-iport-4.cisco.com ([144.254.224.147]:62270 "EHLO
	ams-iport-4.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752398Ab2IZIeS (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 26 Sep 2012 04:34:18 -0400
Received: from cobaltpc1.localnet (dhcp-10-54-92-107.cisco.com [10.54.92.107])
	by ams-core-1.cisco.com (8.14.5/8.14.5) with ESMTP id q8Q8YGGB031530
	for <linux-media@vger.kernel.org>; Wed, 26 Sep 2012 08:34:16 GMT
From: Hans Verkuil <hverkuil@xs4all.nl>
To: LMML <linux-media@vger.kernel.org>
Subject: Re: [GIT PULL FOR v3.7] Add missing vidioc-subdev-g-edid.xml.
Date: Wed, 26 Sep 2012 10:33:51 +0200
References: <201209251356.34176.hverkuil@xs4all.nl>
In-Reply-To: <201209251356.34176.hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201209261033.51510.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue 25 September 2012 13:56:34 Hans Verkuil wrote:
> Hi Mauro,
> 
> As requested!

I've respun this tree, fixing one documentation bug (the max value for
'blocks' is 256, not 255) and adding an overflow check in v4l2-ioctl.c as
reported by Dan Carpenter:

http://www.mail-archive.com/linux-media@vger.kernel.org/msg52640.html

Regards,

	Hans

> 
> Regards,
> 
> 	Hans
> 
> The following changes since commit 4313902ebe33155209472215c62d2f29d117be29:
> 
>   [media] ivtv-alsa, ivtv: Connect ivtv PCM capture stream to ivtv-alsa interface driver (2012-09-18 13:29:07 -0300)
> 
> are available in the git repository at:
> 
>   git://linuxtv.org/hverkuil/media_tree.git docfix
> 
> for you to fetch changes up to 369832c0cb2cd8df37d4854997d31978a286348e:
> 
>   DocBook: add missing vidioc-subdev-g-edid.xml. (2012-09-25 13:54:34 +0200)
> 
> ----------------------------------------------------------------
> Hans Verkuil (1):
>       DocBook: add missing vidioc-subdev-g-edid.xml.
> 
>  Documentation/DocBook/media/v4l/v4l2.xml                 |    1 +
>  Documentation/DocBook/media/v4l/vidioc-subdev-g-edid.xml |  152 ++++++++++++++++++++++++++++++++++++++++
>  2 files changed, 153 insertions(+)
>  create mode 100644 Documentation/DocBook/media/v4l/vidioc-subdev-g-edid.xml
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
