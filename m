Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud6.xs4all.net ([194.109.24.24]:52078 "EHLO
	lb1-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S964835AbbHKNUc (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 11 Aug 2015 09:20:32 -0400
Message-ID: <55C9F611.3000902@xs4all.nl>
Date: Tue, 11 Aug 2015 15:18:09 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>,
	William Towle <william.towle@codethink.co.uk>
Subject: Re: [GIT PULL FOR v4.3] Various fixes
References: <55B749C7.4070005@xs4all.nl> <20150811100804.4cbb0ab7@recife.lan>
In-Reply-To: <20150811100804.4cbb0ab7@recife.lan>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

On 08/11/15 15:08, Mauro Carvalho Chehab wrote:
> Em Tue, 28 Jul 2015 11:22:15 +0200
> Hans Verkuil <hverkuil@xs4all.nl> escreveu:
> 
>> This pull request contains a pile of fixes/enhancements, mostly soc-camera
>> related.
>>
>> Regards,
>>
>> 	Hans
>>
>> The following changes since commit 4dc102b2f53d63207fa12a6ad49c7b6448bc3301:
>>
>>   [media] dvb_core: Replace memset with eth_zero_addr (2015-07-22 13:32:21 -0300)
>>
>> are available in the git repository at:
>>
>>   git://linuxtv.org/hverkuil/media_tree.git for-v4.3e
>>
>> for you to fetch changes up to 9a400ca65ee917dc438cb9b553c11580269b4460:
>>
>>   v4l2: export videobuf2 trace points (2015-07-28 11:15:04 +0200)
>>
>> ----------------------------------------------------------------
>> Ezequiel Garcia (1):
>>       tw68: Move PCI vendor and device IDs to pci_ids.h
>>
>> Hans Verkuil (13):
>>       sh-veu: initialize timestamp_flags and copy timestamp info
>>       tw9910: don't use COLORSPACE_JPEG
>>       tw9910: init priv->scale and update standard
>>       ak881x: simplify standard checks
>>       mt9t112: JPEG -> SRGB
>>       sh_mobile_ceu_camera: fix querycap
>>       sh_mobile_ceu_camera: set field to FIELD_NONE
>>       soc_camera: fix enum_input
>>       soc_camera: fix expbuf support
>>       soc_camera: compliance fixes
>>       soc_camera: pass on streamoff error
>>       soc_camera: always release queue for queue owner
>>       mt9v032: fix uninitialized variable warning
>>
>> Laurent Pinchart (1):
>>       v4l: subdev: Add pad config allocator and init
> 
> As explained, we won't be adding any changes at the MC while we don't fix
> the MC mess.
> 
> As I don't know what patches here are dependent of this change, I'm 
> stopping handling this patch series at patch #15, with means that the
> following patches aren't merged:
> 
> 0015-v4l-subdev-Add-pad-config-allocator-and-init.patch
> 0016-media-soc_camera-rcar_vin-Add-BT.709-24-bit-RGB888-i.patch
> 0017-media-soc_camera-pad-aware-driver-initialisation.patch
> 0018-media-rcar_vin-Use-correct-pad-number-in-try_fmt.patch
> 0019-media-soc_camera-soc_scale_crop-Use-correct-pad-numb.patch
> 0020-media-rcar_vin-fill-in-bus_info-field.patch
> 0021-media-rcar_vin-Reject-videobufs-that-are-too-small-f.patch

William, can you take a look at this? Just let me know which patches
are independent to patch 0015.

> 0022-mt9v032-fix-uninitialized-variable-warning.patch
> 0023-tw68-Move-PCI-vendor-and-device-IDs-to-pci_ids.h.patch
> 0024-v4l2-export-videobuf2-trace-points.patch
> 
> Feel free to submit the remaining fix patches from this series that
> aren't related to media controller on a separate pull request.

I actually posted a 4.3 pull request this afternoon that has patches
22 and an improved version of patch 24:

https://patchwork.linuxtv.org/patch/30810/

Especially the tracepoint patch is quite important.

Patch 23 will be part of some future pull request (no hurry with that
one).

Regards,

	Hans
