Return-Path: <SRS0=1NWX=OQ=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 19C70C07E85
	for <linux-media@archiver.kernel.org>; Fri,  7 Dec 2018 13:36:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DD3BD20892
	for <linux-media@archiver.kernel.org>; Fri,  7 Dec 2018 13:36:03 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org DD3BD20892
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=xs4all.nl
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-media-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726013AbeLGNgD (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Fri, 7 Dec 2018 08:36:03 -0500
Received: from lb1-smtp-cloud7.xs4all.net ([194.109.24.24]:41791 "EHLO
        lb1-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726008AbeLGNgD (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 7 Dec 2018 08:36:03 -0500
Received: from [192.168.2.10] ([212.251.195.8])
        by smtp-cloud7.xs4all.net with ESMTPA
        id VGINg6vtOgJOKVGISgZ4cZ; Fri, 07 Dec 2018 14:36:00 +0100
Subject: Re: [PATCH v5 00/12] imx-media: Fixes for interlaced capture
To:     Steve Longerbeam <slongerbeam@gmail.com>,
        linux-media@vger.kernel.org
References: <20181017000027.23696-1-slongerbeam@gmail.com>
From:   Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <30f8b7b7-3c43-aefd-a37e-245996f1a7bb@xs4all.nl>
Date:   Fri, 7 Dec 2018 14:35:55 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.2.1
MIME-Version: 1.0
In-Reply-To: <20181017000027.23696-1-slongerbeam@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-CMAE-Envelope: MS4wfOWt/QRM35nvEITNMuA27qXfYyquC2qoiNrI4LAYm4nWn1dtNiB808zGsfg65nlRlOSLLfMkxW9kKSrsruB3YpwlOV9blA01pGZjH2VPF/s56dHUJf7q
 6rwDmVyUfJVaaexCTENqNE7oWN3k3OidKZXqPPUES9NwoG53cgdmp3W8o1X29EqwuM9LvjNWOewJuaR/67m3nV7LqBlDrq+cuQI=
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi Steve,

How to proceed with this w.r.t. the two gpu ipu patches? Are those going
in first through the gpu tree? Or do they have to go in through our tree?

In that case I need Acks from whoever maintains that code.

Regards,

	Hans

On 10/17/2018 02:00 AM, Steve Longerbeam wrote:
> A set of patches that fixes some bugs with capturing from an
> interlaced source, and incompatibilites between IDMAC interlace
> interweaving and 4:2:0 data write reduction.
> 
> History:
> v5:
> - Added a regression fix to allow empty endpoints to CSI (fix for imx6q
>   SabreAuto).
> - Cleaned up some convoluted code in ipu_csi_init_interface(), suggested
>   by Philipp Zabel.
> - Fixed a regression in csi_setup(), caught by Philipp.
> - Removed interweave_offset and replace with boolean interweave_swap,
>   suggested by Philipp.
> - Make clear that it is IDMAC channel that does pixel reordering and
>   interweave, not the CSI, in the imx.rst doc, caught by Philipp.
> 
> v4:
> - rebased to latest media-tree master branch.
> - Make patch author and SoB email addresses the same.
> 
> v3:
> - add support for/fix interweaved scan with YUV planar output.
> - fix bug in 4:2:0 U/V offset macros.
> - add patch that generalizes behavior of field swap in
>   ipu_csi_init_interface().
> - add support for interweaved scan with field order swap.
>   Suggested by Philipp Zabel.
> - in v2, inteweave scan was determined using field types of
>   CSI (and PRPENCVF) at the sink and source pads. In v3, this
>   has been moved one hop downstream: interweave is now determined
>   using field type at source pad, and field type selected at
>   capture interface. Suggested by Philipp.
> - make sure to double CSI crop target height when input field
>   type in alternate.
> - more updates to media driver doc to reflect above.
> 
> v2:
> - update media driver doc.
> - enable idmac interweave only if input field is sequential/alternate,
>   and output field is 'interlaced*'.
> - move field try logic out of *try_fmt and into separate function.
> - fix bug with resetting crop/compose rectangles.
> - add a patch that fixes a field order bug in VDIC indirect mode.
> - remove alternate field type from V4L2_FIELD_IS_SEQUENTIAL() macro
>   Suggested-by: Nicolas Dufresne <nicolas@ndufresne.ca>.
> - add macro V4L2_FIELD_IS_INTERLACED().
> 
> 
> Steve Longerbeam (12):
>   media: videodev2.h: Add more field helper macros
>   gpu: ipu-csi: Swap fields according to input/output field types
>   gpu: ipu-v3: Add planar support to interlaced scan
>   media: imx: Fix field negotiation
>   media: imx-csi: Input connections to CSI should be optional
>   media: imx-csi: Double crop height for alternate fields at sink
>   media: imx: interweave and odd-chroma-row skip are incompatible
>   media: imx-csi: Allow skipping odd chroma rows for YVU420
>   media: imx: vdic: rely on VDIC for correct field order
>   media: imx-csi: Move crop/compose reset after filling default mbus
>     fields
>   media: imx: Allow interweave with top/bottom lines swapped
>   media: imx.rst: Update doc to reflect fixes to interlaced capture
> 
>  Documentation/media/v4l-drivers/imx.rst       | 103 +++++++----
>  drivers/gpu/ipu-v3/ipu-cpmem.c                |  26 ++-
>  drivers/gpu/ipu-v3/ipu-csi.c                  | 119 +++++++++----
>  drivers/staging/media/imx/imx-ic-prpencvf.c   |  46 +++--
>  drivers/staging/media/imx/imx-media-capture.c |  14 ++
>  drivers/staging/media/imx/imx-media-csi.c     | 168 +++++++++++++-----
>  drivers/staging/media/imx/imx-media-vdic.c    |  12 +-
>  include/uapi/linux/videodev2.h                |   7 +
>  include/video/imx-ipu-v3.h                    |   6 +-
>  9 files changed, 354 insertions(+), 147 deletions(-)
> 

