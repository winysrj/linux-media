Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp1-g21.free.fr ([212.27.42.1]:40871 "EHLO smtp1-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751511AbaBIJV5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 9 Feb 2014 04:21:57 -0500
Date: Sun, 9 Feb 2014 10:22:19 +0100
From: Jean-Francois Moine <moinejf@free.fr>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>,
	Rob Clark <robdclark@gmail.com>
Cc: devel@driverdev.osuosl.org, dri-devel@lists.freedesktop.org,
	Takashi Iwai <tiwai@suse.de>,
	Sascha Hauer <kernel@pengutronix.de>,
	linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
	Daniel Vetter <daniel@ffwll.ch>
Subject: Re: [PATCH RFC 0/2] drivers/base: simplify simple DT-based
 components
Message-ID: <20140209102219.3ab40b5e@armhf>
In-Reply-To: <20140207202351.GH26684@n2100.arm.linux.org.uk>
References: <cover.1391793068.git.moinejf@free.fr>
	<20140207202351.GH26684@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, 7 Feb 2014 20:23:51 +0000
Russell King - ARM Linux <linux@arm.linux.org.uk> wrote:

> Here's my changes to the TDA998x driver to add support for the component
> helper.  The TDA998x driver retains support for the old way so that
> drivers can be transitioned.  For any one DRM "card" the transition to

I rewrote the tda998x as a simple encoder+connector (i.e. not a
slave_encoder) with your component helper, and the code is much clearer
and simpler: the DRM driver has nothing to do except to know that the
tda998x is a component and to set the possible_crtcs.

AFAIK, only the tilcdc drm driver is using the tda998x as a
slave_encoder. It does a (encoder+connector) conversion to
(slave_encoder). Then, in your changes in the TDA998x, you do a
(slave_encoder) translation to (encoder+connector).
This seems rather complicated!

I think it would be easier to use your component helper and rewrite
(remove?) tilcdc_slave.c.

> And yes, I'm thinking that maybe moving compare_of() into the component
> support so that drivers can share this generic function may be a good
> idea.

This function exists already in drivers/of/platform.c as
of_dev_node_match(). It just needs to be exported.

-- 
Ken ar c'hentañ	|	      ** Breizh ha Linux atav! **
Jef		|		http://moinejf.free.fr/
