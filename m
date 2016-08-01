Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:44066 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752169AbcHAJCW (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 1 Aug 2016 05:02:22 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: [PATCH 3/3] soc-camera/sh_mobile_csi2: remove unused driver
Date: Mon, 01 Aug 2016 12:01:56 +0300
Message-ID: <2111514.B3c6CcPRxt@avalon>
In-Reply-To: <4dafe85c-ec52-9460-1f1e-1d4ae8c456a4@xs4all.nl>
References: <1470038065-30789-1-git-send-email-hverkuil@xs4all.nl> <8220966.xMzG3XxcmY@avalon> <4dafe85c-ec52-9460-1f1e-1d4ae8c456a4@xs4all.nl>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On Monday 01 Aug 2016 10:56:21 Hans Verkuil wrote:
> On 08/01/2016 10:34 AM, Laurent Pinchart wrote:
> > On Monday 01 Aug 2016 09:54:25 Hans Verkuil wrote:
> >> From: Hans Verkuil <hans.verkuil@cisco.com>
> >> 
> >> The sh_mobile_csi2 isn't used anymore (was it ever?), so remove it.
> >> Especially since the soc-camera framework is being deprecated.
> >> 
> >> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> >> Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> >> Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
> > 
> > Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> > 
> >> ---
> >> 
> >>  drivers/media/platform/soc_camera/Kconfig          |   7 -
> >>  drivers/media/platform/soc_camera/Makefile         |   1 -
> >>  .../platform/soc_camera/sh_mobile_ceu_camera.c     | 229 +-----------
> >>  drivers/media/platform/soc_camera/sh_mobile_csi2.c | 400 -------------
> >>  include/media/drv-intf/sh_mobile_ceu.h             |   1 -
> >>  include/media/drv-intf/sh_mobile_csi2.h            |  48 ---
> >>  6 files changed, 10 insertions(+), 676 deletions(-)
> >>  delete mode 100644 drivers/media/platform/soc_camera/sh_mobile_csi2.c
> >>  delete mode 100644 include/media/drv-intf/sh_mobile_c
> > 
> > Any plan for the sh_mobile_ceu_camera driver by the way ?
> 
> Yes.
> 
> The idea is to replace the remaining soc-camera drivers by 'proper' drivers
> (Robert Jarzmik is working on that for the pxa_camera driver, and I am
> working on the atmel-isi driver).
> 
> Once that's done the only soc-camera driver left is the sh_mobile_ceu_camera
> driver.
> 
> At that moment the soc-camera framework will be folded into the
> sh_mobile_ceu_camera driver and it will cease to exist as a framework. It's
> just a very complex driver. I plan on refactoring it further, removing dead
> code etc.
> 
> My original plan was to replace the sh_mobile_ceu_camera driver by a
> 'proper' driver as well, but it was next to impossible to do that. The fact
> that it didn't use the device tree and the complexity with scaling and
> cropping and the close dependency on soc-camera just made this a no go (at
> least not something I was willing to spend more time on).
> 
> I think this alternative approach has the best chance of succeeding.

Are there really users of the CEU driver ? There are a few ARM-based Renesas 
platforms that include the CEU, but they're pretty old now and don't support 
the CEU in mainline. As far as I know only arch/sh still makes use of the CEU 
driver.

> I'm not sure yet what we'll do with the soc-camera sensors. I experimented
> a bit with extracting them from soc-camera, but for most it's not easy to
> do so. Something to look at later.

It would be a shame to remove them all, but it also depends on whether we can 
find hardware for testing.

-- 
Regards,

Laurent Pinchart

