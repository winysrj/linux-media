Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp4-g21.free.fr ([212.27.42.4]:16088 "EHLO smtp4-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751419AbaFXV46 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 24 Jun 2014 17:56:58 -0400
Date: Tue, 24 Jun 2014 23:56:39 +0200
From: Eric =?ISO-8859-1?B?QuluYXJk?= <eric@eukrea.com>
To: Thierry Reding <thierry.reding@gmail.com>
Cc: Denis Carikli <denis@eukrea.com>,
	Philipp Zabel <p.zabel@pengutronix.de>,
	devel@driverdev.osuosl.org, Russell King <linux@arm.linux.org.uk>,
	David Airlie <airlied@linux.ie>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Sascha Hauer <kernel@pengutronix.de>,
	Shawn Guo <shawn.guo@linaro.org>,
	linux-arm-kernel@lists.infradead.org,
	Mauro Carvalho Chehab <m.chehab@samsung.com>
Subject: Re: [PATCH v14 08/10] drm/panel: Add Eukrea mbimxsd51 displays.
Message-ID: <20140624235639.487429ad@e6520eb>
In-Reply-To: <20140624214926.GA30039@mithrandir>
References: <1402913484-25910-1-git-send-email-denis@eukrea.com>
	<1402913484-25910-8-git-send-email-denis@eukrea.com>
	<20140624214926.GA30039@mithrandir>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Thierry,

Le Tue, 24 Jun 2014 23:49:37 +0200,
Thierry Reding <thierry.reding@gmail.com> a écrit :

> On Mon, Jun 16, 2014 at 12:11:22PM +0200, Denis Carikli wrote:
> [...]
> > diff --git a/Documentation/devicetree/bindings/panel/eukrea,mbimxsd51-dvi-svga.txt b/Documentation/devicetree/bindings/panel/eukrea,mbimxsd51-dvi-svga.txt
> [...]
> > @@ -0,0 +1,7 @@
> > +Eukrea DVI-SVGA (800x600 pixels) DVI output.
> [...]
> > diff --git a/Documentation/devicetree/bindings/panel/eukrea,mbimxsd51-dvi-vga.txt b/Documentation/devicetree/bindings/panel/eukrea,mbimxsd51-dvi-vga.txt
> [...]
> > @@ -0,0 +1,7 @@
> > +Eukrea DVI-VGA (640x480 pixels) DVI output.
> 
> DVI outputs shouldn't be using the panel framework and this binding at
> all. DVI usually has the means to determine all of this by itself. Why
> do you need to represent this as a panel in device tree?
> 
because on this very simple display board, we only have DVI LVDS signals
without the I2C to detect the display.

Best regards
Eric
