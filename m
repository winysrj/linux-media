Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud7.xs4all.net ([194.109.24.31]:50015 "EHLO
        lb3-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727420AbeHWLmL (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 23 Aug 2018 07:42:11 -0400
Subject: Re: [PATCHv2 0/7] vicodec improvements
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
References: <20180823073305.6518-1-hverkuil@xs4all.nl>
Message-ID: <c7f7c7c1-175b-677e-8268-2d6e7bf27f6f@xs4all.nl>
Date: Thu, 23 Aug 2018 10:13:39 +0200
MIME-Version: 1.0
In-Reply-To: <20180823073305.6518-1-hverkuil@xs4all.nl>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 08/23/2018 09:32 AM, Hans Verkuil wrote:
> From: Hans Verkuil <hans.verkuil@cisco.com>
> 
> - add support for quantization parameters
> - support many more pixel formats
> - code simplifications
> - rename source and use proper prefixes for the codec: this makes it
>   independent from the vicodec driver and easier to reuse in userspace
>   (similar to what we do for the v4l2-tpg code).
> - split off the v4l2 'frontend' code for the FWHT codec into its own
>   source for easier re-use elsewhere (i.e. v4l2-ctl/qvidcap).
> 
> I made a v4l-utils branch that uses the FWHT codec to compress video
> when streaming over the network:
> 
> https://git.linuxtv.org/hverkuil/v4l-utils.git/log/?h=qvidcap
> 
> You need to add the --stream-to-host-lossy flag to enable FWHT streaming.
> 
> Note: the FWHT codec clips R/G/B values for RGB formats. This will be
> addressed later. I might have to convert the R/G/B values from full to
> limited range before encoding them, but I want to discuss this with the
> author of the codec (Tom aan de Wiel) first.

Figured out where the problem is and posted a patch 8/7 to fix this.

Since I no longer have these artifacts I also changed the --stream-to-host-lossy
argument to --stream-lossless: by default v4l2-ctl --stream-to-host will now
use the FWHT codec (if supported for the given pixelformat), unless --stream-lossless
is given.

Still not 100% certain about this, so this might change in the future.

Regards,

	Hans

> 
> Regards,
> 
> 	Hans
> 
> Changes since v1:
> 
> - added the last patch (split off v4l2 FWHT code)
> - the GOP_SIZE and QP controls can now be set during streaming as
>   well.
> 
> Hans Verkuil (7):
>   vicodec: add QP controls
>   vicodec: add support for more pixel formats
>   vicodec: simplify flags handling
>   vicodec: simplify blocktype checking
>   vicodec: improve handling of uncompressable planes
>   vicodec: rename and use proper fwht prefix for codec
>   vicodec: split off v4l2 specific parts for the codec
> 
>  .../media/uapi/v4l/pixfmt-compressed.rst      |   2 +-
>  drivers/media/platform/vicodec/Makefile       |   2 +-
>  .../vicodec/{vicodec-codec.c => codec-fwht.c} | 148 ++++--
>  .../vicodec/{vicodec-codec.h => codec-fwht.h} |  80 ++-
>  .../media/platform/vicodec/codec-v4l2-fwht.c  | 325 ++++++++++++
>  .../media/platform/vicodec/codec-v4l2-fwht.h  |  50 ++
>  drivers/media/platform/vicodec/vicodec-core.c | 483 ++++++++----------
>  7 files changed, 723 insertions(+), 367 deletions(-)
>  rename drivers/media/platform/vicodec/{vicodec-codec.c => codec-fwht.c} (85%)
>  rename drivers/media/platform/vicodec/{vicodec-codec.h => codec-fwht.h} (64%)
>  create mode 100644 drivers/media/platform/vicodec/codec-v4l2-fwht.c
>  create mode 100644 drivers/media/platform/vicodec/codec-v4l2-fwht.h
> 
