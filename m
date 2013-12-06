Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:57912 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161645Ab3LFNe3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 6 Dec 2013 08:34:29 -0500
Message-ID: <1386336562.4088.5.camel@weser.hi.pengutronix.de>
Subject: Re: [PATCHv5][ 2/8] staging: imx-drm: Add RGB666 support for
 parallel display.
From: Lucas Stach <l.stach@pengutronix.de>
To: Thierry Reding <thierry.reding@gmail.com>
Cc: Denis Carikli <denis@eukrea.com>, Marek Vasut <marex@denx.de>,
	Mark Rutland <mark.rutland@arm.com>,
	devel@driverdev.osuosl.org,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Eric =?ISO-8859-1?Q?B=E9nard?= <eric@eukrea.com>,
	Pawel Moll <pawel.moll@arm.com>,
	Stephen Warren <swarren@wwwdotorg.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Ian Campbell <ijc+devicetree@hellion.org.uk>,
	Rob Herring <rob.herring@calxeda.com>,
	devicetree@vger.kernel.org, dri-devel@lists.freedesktop.org,
	Sascha Hauer <kernel@pengutronix.de>,
	linux-media@vger.kernel.org,
	driverdev-devel@linuxdriverproject.org,
	linux-arm-kernel@lists.infradead.org,
	Mauro Carvalho Chehab <m.chehab@samsung.com>
Date: Fri, 06 Dec 2013 14:29:22 +0100
In-Reply-To: <20131206131403.GA30960@ulmo.nvidia.com>
References: <1386268092-21719-1-git-send-email-denis@eukrea.com>
	 <1386268092-21719-2-git-send-email-denis@eukrea.com>
	 <20131206131403.GA30960@ulmo.nvidia.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am Freitag, den 06.12.2013, 14:14 +0100 schrieb Thierry Reding:
> On Thu, Dec 05, 2013 at 07:28:06PM +0100, Denis Carikli wrote:
> [...]
> > diff --git a/drivers/staging/imx-drm/ipu-v3/ipu-dc.c b/drivers/staging/imx-drm/ipu-v3/ipu-dc.c
> [...]
> > @@ -155,6 +156,8 @@ static int ipu_pixfmt_to_map(u32 fmt)
> >  		return IPU_DC_MAP_BGR666;
> >  	case V4L2_PIX_FMT_BGR24:
> >  		return IPU_DC_MAP_BGR24;
> > +	case V4L2_PIX_FMT_RGB666:
> > +		return IPU_DC_MAP_RGB666;
> 
> Why is this DRM driver even using V4L2 pixel formats in the first place?
> 
Because imx-drm is actually a misnomer. The i.MX IPU is a multifunction
device, which as one part has the display controllers, but also camera
interfaces and mem-to-mem scaler devices, which are hooked up via the
V4L2 interface.

The generic IPU part, which is used for example for programming the DMA
channels is using V4L2 pixel formats as a common base. We have patches
to split this out and make this fact more visible. (The IPU core will be
placed aside the Tegra host1x driver)

Regards,
Lucas
-- 
Pengutronix e.K.                           | Lucas Stach                 |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-5076 |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |

