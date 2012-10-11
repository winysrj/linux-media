Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:44501 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758407Ab2JKK2V (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 11 Oct 2012 06:28:21 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: dri-devel@lists.freedesktop.org
Cc: Imre Deak <imre.deak@intel.com>,
	Daniel Vetter <daniel.vetter@ffwll.ch>,
	Chris Wilson <chris@chris-wilson.co.uk>,
	Kristian =?ISO-8859-1?Q?H=F8gsberg?= <krh@bitplanet.net>,
	intel-gfx@lists.freedesktop.org, linux-media@vger.kernel.org,
	Mario Kleiner <mario.kleiner@tuebingen.mpg.de>
Subject: Re: [RFC 0/4] drm: add raw monotonic timestamp support
Date: Thu, 11 Oct 2012 12:29:03 +0200
Message-ID: <2461348.VAb9R0RWhW@avalon>
In-Reply-To: <1349444222-22274-1-git-send-email-imre.deak@intel.com>
References: <1349444222-22274-1-git-send-email-imre.deak@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

(CC'ing linux-media)

On Friday 05 October 2012 16:36:58 Imre Deak wrote:
> This is needed to make applications depending on vblank/page flip
> timestamps independent of time ajdustments.

We're in the process to switching to CLOCK_MONOTONIC timestamps in V4L2. The 
reason why we're using CLOCK_MONOTONIC and not CLOCK_MONOTONIC_RAW is that 
ALSA uses the former. It would make sense in my opinion to unify timestamps 
across our media APIs.

> I've tested these with an updated intel-gpu-test/flip_test and will send
> the update for that once there's no objection about this patchset.
> 
> The patchset is based on danvet's dinq branch with the following
> additional patches from the intel-gfx ML applied:
>     drm/i915: paper over a pipe-enable vs pageflip race
>     drm/i915: don't frob the vblank ts in finish_page_flip
>     drm/i915: call drm_handle_vblank before finish_page_flip
> 
> Imre Deak (4):
>   time: export getnstime_raw_and_real for DRM
>   drm: make memset/calloc for _vblank_time more robust
>   drm: use raw time in drm_calc_vbltimestamp_from_scanoutpos
>   drm: add support for raw monotonic vblank timestamps
> 
>  drivers/gpu/drm/drm_crtc.c                |    2 +
>  drivers/gpu/drm/drm_ioctl.c               |    3 ++
>  drivers/gpu/drm/drm_irq.c                 |   83 ++++++++++++++------------
>  drivers/gpu/drm/i915/i915_irq.c           |    2 +-
>  drivers/gpu/drm/i915/intel_display.c      |   12 ++---
>  drivers/gpu/drm/radeon/radeon_display.c   |   10 ++--
>  drivers/gpu/drm/radeon/radeon_drv.c       |    2 +-
>  drivers/gpu/drm/radeon/radeon_kms.c       |    2 +-
>  drivers/gpu/drm/shmobile/shmob_drm_crtc.c |    9 ++--
>  include/drm/drm.h                         |    5 +-
>  include/drm/drmP.h                        |   38 +++++++++++--
>  include/drm/drm_mode.h                    |    4 +-
>  kernel/time/timekeeping.c                 |    2 +-
>  13 files changed, 113 insertions(+), 61 deletions(-)

-- 
Regards,

Laurent Pinchart

