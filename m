Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:55342 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727021AbeINSN4 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 14 Sep 2018 14:13:56 -0400
Date: Fri, 14 Sep 2018 15:59:32 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: petrcvekcz@gmail.com
Cc: hans.verkuil@cisco.com, jacopo@jmondi.org, mchehab@kernel.org,
        marek.vasut@gmail.com, linux-media@vger.kernel.org,
        robert.jarzmik@free.fr, slapin@ossfans.org, philipp.zabel@gmail.com
Subject: Re: [PATCH v2 0/4] media: soc_camera: ov9640: switch driver to
 v4l2_async
Message-ID: <20180914125932.gepe4g7idwyjd2t4@valkosipuli.retiisi.org.uk>
References: <cover.1534339750.git.petrcvekcz@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1534339750.git.petrcvekcz@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Petr,

On Wed, Aug 15, 2018 at 03:30:23PM +0200, petrcvekcz@gmail.com wrote:
> From: Petr Cvek <petrcvekcz@gmail.com>
> 
> This patch series transfer the ov9640 driver from the soc_camera subsystem
> into a standalone v4l2 driver. There is no changes except the required
> v4l2_async calls, GPIO allocation, deletion of now unused variables,
> a change from mdelay() to msleep() and an addition of SPDX identifiers
> (as suggested in the v1 version RFC).
> 
> The config symbol has been changed from CONFIG_SOC_CAMERA_OV9640 to
> CONFIG_VIDEO_OV9640.
> 
> Also as the drivers of the soc_camera seems to be orphaned I'm volunteering
> as a maintainer of the driver (I own the hardware).

Thanks for the set. The patches seem good to me as such but there's some
more work to do there. For one, the depedency to v4l2_clk should be
removed; the common clock framework has supported clocks from random
devices for many, many years now.

The PXA camera driver does still depend on v4l2_clk so I guess this is
better to do later on in a different patchset.

-- 
Regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi
