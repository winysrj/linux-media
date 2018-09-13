Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ed1-f68.google.com ([209.85.208.68]:41382 "EHLO
        mail-ed1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729719AbeIMS4C (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 13 Sep 2018 14:56:02 -0400
Received: by mail-ed1-f68.google.com with SMTP id f38-v6so4668914edd.8
        for <linux-media@vger.kernel.org>; Thu, 13 Sep 2018 06:46:28 -0700 (PDT)
Date: Thu, 13 Sep 2018 15:46:24 +0200
From: Daniel Vetter <daniel@ffwll.ch>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org
Subject: Re: [PATCH 0/5] Rename AdobeRGB to opRGB
Message-ID: <20180913134624.GG11082@phenom.ffwll.local>
References: <20180913114731.16500-1-hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180913114731.16500-1-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Sep 13, 2018 at 01:47:26PM +0200, Hans Verkuil wrote:
> From: Hans Verkuil <hans.verkuil@cisco.com>
> 
> This patch series replaces all AdobeRGB references by opRGB references.
> 
> In November last year all references to the AdobeRGB colorspace were removed
> from the CTA-861 standards (all versions) and replaced with the corresponding
> international opRGB standard (IEC 61966-2-5) due to trademark issues.
> 
> This patch series makes the same change in the kernel because:
> 
> 1) it makes sense to keep in sync with the CTA-861 standard,
> 2) using an international standard is always preferable to a company standard,
> 3) avoid possible future trademark complaints.
> 
> The first two patches can go through the media subsystem. The third patch
> changes hdmi.c/h, but since the renamed defines from hdmi.h are only used
> in the media subsystem I would prefer to merge this via the media subsystem
> as well. So if I can get an Ack, then that would be great.
> 
> The fourth patch I can push to drm-misc when it's reviewed, and the final
> patch can go through the AMD GPU maintainers.
> 
> There are only two references to the old name left since they are part of
> the V4L2 public API, so I can't remove them.

Does what it says on the tin. For the series:

Acked-by: Daniel Vetter <daniel.vetter@ffwll.ch>

But definitely needs an ack from amdgpu folks too (plus media ofc).
-Daniel

> 
> Regards,
> 
> 	Hans
> 
> 
> Hans Verkuil (5):
>   media: replace ADOBERGB by OPRGB
>   media colorspaces*.rst: rename AdobeRGB to opRGB
>   hdmi.h: rename ADOBE_RGB to OPRGB and ADOBE_YCC to OPYCC
>   drm/bridge/synopsys/dw-hdmi.h: rename ADOBE to OP
>   drm/amd: rename ADOBE to OP
> 
>  Documentation/media/uapi/v4l/biblio.rst       |  10 -
>  .../media/uapi/v4l/colorspaces-defs.rst       |   8 +-
>  .../media/uapi/v4l/colorspaces-details.rst    |  13 +-
>  .../media/videodev2.h.rst.exceptions          |   2 +
>  .../drm/amd/display/dc/core/dc_hw_sequencer.c |   4 +-
>  .../gpu/drm/amd/display/dc/core/dc_resource.c |   4 +-
>  drivers/gpu/drm/amd/display/dc/dc_hw_types.h  |   2 +-
>  .../amd/display/dc/dce/dce_stream_encoder.c   |   2 +-
>  .../amd/display/dc/dcn10/dcn10_hw_sequencer.c |   2 +-
>  .../display/dc/dcn10/dcn10_stream_encoder.c   |   2 +-
>  .../gpu/drm/amd/display/dc/inc/hw/transform.h |   4 +-
>  drivers/gpu/drm/bridge/synopsys/dw-hdmi.h     |   4 +-
>  .../media/common/v4l2-tpg/v4l2-tpg-colors.c   | 262 +++++++++---------
>  drivers/media/i2c/adv7511.c                   |   6 +-
>  drivers/media/i2c/adv7604.c                   |   2 +-
>  drivers/media/i2c/tc358743.c                  |   4 +-
>  drivers/media/platform/vivid/vivid-core.h     |   2 +-
>  drivers/media/platform/vivid/vivid-ctrls.c    |   6 +-
>  drivers/media/platform/vivid/vivid-vid-out.c  |   2 +-
>  drivers/media/v4l2-core/v4l2-dv-timings.c     |  12 +-
>  drivers/video/hdmi.c                          |   8 +-
>  include/linux/hdmi.h                          |   4 +-
>  include/uapi/linux/videodev2.h                |  16 +-
>  23 files changed, 190 insertions(+), 191 deletions(-)
> 
> -- 
> 2.18.0
> 
> _______________________________________________
> dri-devel mailing list
> dri-devel@lists.freedesktop.org
> https://lists.freedesktop.org/mailman/listinfo/dri-devel

-- 
Daniel Vetter
Software Engineer, Intel Corporation
http://blog.ffwll.ch
