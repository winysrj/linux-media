Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:42263 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753638Ab2CMNdi (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 13 Mar 2012 09:33:38 -0400
Date: Tue, 13 Mar 2012 14:33:33 +0100
From: Sascha Hauer <s.hauer@pengutronix.de>
To: Alex <alexg@meprolight.com>
Cc: linux-kernel@vger.kernel.org, g.liakhovetski@gmx.de,
	fabio.estevam@freescale.com, linux-media@vger.kernel.org
Subject: Re: [PATCH] i.MX35-PDK: Add Camera support
Message-ID: <20120313133333.GG3852@pengutronix.de>
References: <1331569731-30973-1-git-send-email-alexg@meprolight.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1331569731-30973-1-git-send-email-alexg@meprolight.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Mar 12, 2012 at 06:28:51PM +0200, Alex wrote:
> In i.MX35-PDK, OV2640  camera is populated on the
> personality board. This camera is registered as a subdevice via soc-camera interface.
> 
> Signed-off-by: Alex Gershgorin <alexg@meprolight.com>
> ---
>  arch/arm/mach-imx/mach-mx35_3ds.c |   87 +++++++++++++++++++++++++++++++++++++
>  1 files changed, 87 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/arm/mach-imx/mach-mx35_3ds.c b/arch/arm/mach-imx/mach-mx35_3ds.c

This one does not apply as it is obviously based on (an earlier version
of) the framebuffer patches of this board. Please always base your stuff
on some -rc kernel. We can resolve conflicts later upstream, but we
cannot easily apply a patch when we do not have the correct base.

Please add the linux arm kernel mailing list next time.

Sascha

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
