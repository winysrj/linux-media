Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud7.xs4all.net ([194.109.24.24]:40573 "EHLO
        lb1-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728791AbeJAQpF (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 1 Oct 2018 12:45:05 -0400
Subject: Re: [PATCH v3 00/14] imx-media: Fixes for interlaced capture
To: Steve Longerbeam <slongerbeam@gmail.com>,
        linux-media@vger.kernel.org
Cc: Steve Longerbeam <steve_longerbeam@mentor.com>
References: <1533150747-30677-1-git-send-email-steve_longerbeam@mentor.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <db3940a6-d837-9b6a-1f1e-122dda1e1650@xs4all.nl>
Date: Mon, 1 Oct 2018 12:07:57 +0200
MIME-Version: 1.0
In-Reply-To: <1533150747-30677-1-git-send-email-steve_longerbeam@mentor.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Steve,

On 08/01/2018 09:12 PM, Steve Longerbeam wrote:
> A set of patches that fixes some bugs with capturing from an
> interlaced source, and incompatibilites between IDMAC interlace
> interweaving and 4:2:0 data write reduction.

I reviewed this series and it looks fine to me.

It appears that the ipu* patches are already merged, so can you rebase and
repost?

I would also like to see the 'v4l2-compliance -f' for an interlaced source,
if at all possible.

For that matter, were you able to test all the field formats?

Regards,

	Hans

> 
> History:
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
> Philipp Zabel (1):
>   gpu: ipu-v3: Allow negative offsets for interlaced scanning
> 
> Steve Longerbeam (13):
>   media: videodev2.h: Add more field helper macros
>   gpu: ipu-csi: Check for field type alternate
>   gpu: ipu-csi: Swap fields according to input/output field types
>   gpu: ipu-v3: Fix U/V offset macros for planar 4:2:0
>   gpu: ipu-v3: Add planar support to interlaced scan
>   media: imx: Fix field negotiation
>   media: imx-csi: Double crop height for alternate fields at sink
>   media: imx: interweave and odd-chroma-row skip are incompatible
>   media: imx-csi: Allow skipping odd chroma rows for YVU420
>   media: imx: vdic: rely on VDIC for correct field order
>   media: imx-csi: Move crop/compose reset after filling default mbus
>     fields
>   media: imx: Allow interweave with top/bottom lines swapped
>   media: imx.rst: Update doc to reflect fixes to interlaced capture
> 
>  Documentation/media/v4l-drivers/imx.rst       |  93 ++++++++++-----
>  drivers/gpu/ipu-v3/ipu-cpmem.c                |  45 ++++++-
>  drivers/gpu/ipu-v3/ipu-csi.c                  | 136 ++++++++++++++-------
>  drivers/staging/media/imx/imx-ic-prpencvf.c   |  48 ++++++--
>  drivers/staging/media/imx/imx-media-capture.c |  14 +++
>  drivers/staging/media/imx/imx-media-csi.c     | 166 ++++++++++++++++++--------
>  drivers/staging/media/imx/imx-media-vdic.c    |  12 +-
>  include/uapi/linux/videodev2.h                |   7 ++
>  include/video/imx-ipu-v3.h                    |   6 +-
>  9 files changed, 377 insertions(+), 150 deletions(-)
> 
