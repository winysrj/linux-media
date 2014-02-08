Return-path: <linux-media-owner@vger.kernel.org>
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:58160 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750868AbaBHAYO (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 7 Feb 2014 19:24:14 -0500
Date: Sat, 8 Feb 2014 00:23:54 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Jean-Francois Moine <moinejf@free.fr>
Cc: devel@driverdev.osuosl.org, alsa-devel@alsa-project.org,
	Daniel Vetter <daniel@ffwll.ch>, Takashi Iwai <tiwai@suse.de>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	dri-devel@lists.freedesktop.org,
	Sascha Hauer <kernel@pengutronix.de>,
	linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org
Subject: Re: [PATCH RFC 0/2] drivers/base: simplify simple DT-based
	components
Message-ID: <20140208002354.GI26684@n2100.arm.linux.org.uk>
References: <cover.1391793068.git.moinejf@free.fr> <20140207173326.GD26684@n2100.arm.linux.org.uk> <20140207194204.4d4326bd@armhf> <20140207185911.GG26684@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140207185911.GG26684@n2100.arm.linux.org.uk>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Feb 07, 2014 at 06:59:11PM +0000, Russell King - ARM Linux wrote:
> Sorry.  Deferred probe does work, it's been tested with imx-drm, not
> only from the master component but also the sub-components.  There's
> no problem here.

Here's the proof that it also works with the Cubox, and armada DRM:

[drm] Initialized drm 1.1.0 20060810
...
armada-drm armada-510-drm: master bind failed: -517
i2c 0-0070: Driver tda998x requests probe deferral
...
tda998x 0-0070: found TDA19988
armada-drm armada-510-drm: bound 0-0070 (ops tda998x_ops)

So, in the above sequence, the armada DRM driver was bound to its driver
initially, but the TDA998x driver wasn't.

Then, the TDA998x driver is bound, which completes the requirements for
the DRM master.  So the system attempts to bind.

In doing so, the master probe function discovers a missing clock (because
the SIL5531 driver hasn't probed) and it returns -EPROBE_DEFER.  This
causes the probe of the TDA998x to be deferred.

Later, deferred probes are run - at this time the SIL5531 driver has
probed its device, and the clocks are now available.  So when the TDA998x
driver is re-probed, it retriggers the binding attempt, and as the clock
can now be found, the system is bound and the DRM system for the device
is initialised.

I've just committed a patch locally which makes Armada DRM fully use
the component helper, which removes in totality the four armada_output.*
and armada_slave.* files since they're no longer required:

[cubox-3.13 e2713ff5ac2f] DRM: armada: remove non-component support
 7 files changed, 8 insertions(+), 437 deletions(-)
 delete mode 100644 drivers/gpu/drm/armada/armada_output.c
 delete mode 100644 drivers/gpu/drm/armada/armada_output.h
 delete mode 100644 drivers/gpu/drm/armada/armada_slave.c
 delete mode 100644 drivers/gpu/drm/armada/armada_slave.h

-- 
FTTC broadband for 0.8mile line: 5.8Mbps down 500kbps up.  Estimation
in database were 13.1 to 19Mbit for a good line, about 7.5+ for a bad.
Estimate before purchase was "up to 13.2Mbit".
