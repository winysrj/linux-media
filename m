Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:57157 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964881AbbHKNII (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 11 Aug 2015 09:08:08 -0400
Date: Tue, 11 Aug 2015 10:08:04 -0300
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [GIT PULL FOR v4.3] Various fixes
Message-ID: <20150811100804.4cbb0ab7@recife.lan>
In-Reply-To: <55B749C7.4070005@xs4all.nl>
References: <55B749C7.4070005@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Tue, 28 Jul 2015 11:22:15 +0200
Hans Verkuil <hverkuil@xs4all.nl> escreveu:

> This pull request contains a pile of fixes/enhancements, mostly soc-camera
> related.
> 
> Regards,
> 
> 	Hans
> 
> The following changes since commit 4dc102b2f53d63207fa12a6ad49c7b6448bc3301:
> 
>   [media] dvb_core: Replace memset with eth_zero_addr (2015-07-22 13:32:21 -0300)
> 
> are available in the git repository at:
> 
>   git://linuxtv.org/hverkuil/media_tree.git for-v4.3e
> 
> for you to fetch changes up to 9a400ca65ee917dc438cb9b553c11580269b4460:
> 
>   v4l2: export videobuf2 trace points (2015-07-28 11:15:04 +0200)
> 
> ----------------------------------------------------------------
> Ezequiel Garcia (1):
>       tw68: Move PCI vendor and device IDs to pci_ids.h
> 
> Hans Verkuil (13):
>       sh-veu: initialize timestamp_flags and copy timestamp info
>       tw9910: don't use COLORSPACE_JPEG
>       tw9910: init priv->scale and update standard
>       ak881x: simplify standard checks
>       mt9t112: JPEG -> SRGB
>       sh_mobile_ceu_camera: fix querycap
>       sh_mobile_ceu_camera: set field to FIELD_NONE
>       soc_camera: fix enum_input
>       soc_camera: fix expbuf support
>       soc_camera: compliance fixes
>       soc_camera: pass on streamoff error
>       soc_camera: always release queue for queue owner
>       mt9v032: fix uninitialized variable warning
> 
> Laurent Pinchart (1):
>       v4l: subdev: Add pad config allocator and init

As explained, we won't be adding any changes at the MC while we don't fix
the MC mess.

As I don't know what patches here are dependent of this change, I'm 
stopping handling this patch series at patch #15, with means that the
following patches aren't merged:

0015-v4l-subdev-Add-pad-config-allocator-and-init.patch
0016-media-soc_camera-rcar_vin-Add-BT.709-24-bit-RGB888-i.patch
0017-media-soc_camera-pad-aware-driver-initialisation.patch
0018-media-rcar_vin-Use-correct-pad-number-in-try_fmt.patch
0019-media-soc_camera-soc_scale_crop-Use-correct-pad-numb.patch
0020-media-rcar_vin-fill-in-bus_info-field.patch
0021-media-rcar_vin-Reject-videobufs-that-are-too-small-f.patch
0022-mt9v032-fix-uninitialized-variable-warning.patch
0023-tw68-Move-PCI-vendor-and-device-IDs-to-pci_ids.h.patch
0024-v4l2-export-videobuf2-trace-points.patch

Feel free to submit the remaining fix patches from this series that
aren't related to media controller on a separate pull request.

Regards,
Mauro
