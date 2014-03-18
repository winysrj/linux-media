Return-path: <linux-media-owner@vger.kernel.org>
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:56660 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752497AbaCRJbS (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 18 Mar 2014 05:31:18 -0400
Date: Tue, 18 Mar 2014 09:30:35 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Lothar =?iso-8859-1?Q?Wa=DFmann?= <LW@KARO-electronics.de>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Andrzej Hajda <a.hajda@samsung.com>,
	devel@driverdev.osuosl.org, Philipp Zabel <p.zabel@pengutronix.de>,
	David Airlie <airlied@linux.ie>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	dri-devel@lists.freedesktop.org,
	Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Denis Carikli <denis@eukrea.com>,
	Eric =?iso-8859-1?Q?B=E9nard?= <eric@eukrea.com>,
	Shawn Guo <shawn.guo@linaro.org>,
	Sascha Hauer <kernel@pengutronix.de>,
	linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org
Subject: Re: [PATCH 07/12] drm: drm_display_mode: add signal polarity flags
Message-ID: <20140318093035.GR21483@n2100.arm.linux.org.uk>
References: <1394731053-6118-1-git-send-email-denis@eukrea.com> <2166863.3Fn4k2rvaz@avalon> <20140317161436.06169b33@ipc1.ka-ro> <2777667.XJdaUSpRsD@avalon> <20140318085030.66db84b7@ipc1.ka-ro>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20140318085030.66db84b7@ipc1.ka-ro>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Mar 18, 2014 at 08:50:30AM +0100, Lothar Waßmann wrote:
> Hi,
> 
> Laurent Pinchart wrote:
> > Hi Lothar,
> > 
> > On Monday 17 March 2014 16:14:36 Lothar Waßmann wrote:
> > > DE is not a clock signal, but an 'Enable' signal whose value (high or
> > > low) defines the window in which the pixel data is valid.
> > > The flag defines whether data is valid during the HIGH or LOW period of
> > > DE.
> > 
> > The DRM_MODE_FLAG_POL_DE_(LOW|HIGH) do, by my impression of the proposed new 
> > DRM_MODE_FLAG_POL_DE_*EDGE flags is that they define sampling clock edges, not 
> > active levels.
> > 
> The current naming of the flags gives the impression that they describe
> the sampling edges of a clock signal. But the DE signal in fact is not
> a clock signal but a level sensitive gating signal.

+1

-- 
FTTC broadband for 0.8mile line: now at 9.7Mbps down 460kbps up... slowly
improving, and getting towards what was expected from it.
