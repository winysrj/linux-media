Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:33328 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754637Ab0CGUUf (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 7 Mar 2010 15:20:35 -0500
Date: Sun, 7 Mar 2010 21:20:33 +0100
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?=
	<u.kleine-koenig@pengutronix.de>
To: linux-media@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>,
	Valentin Longchamp <valentin.longchamp@epfl.ch>
Subject: Re: [git:v4l-dvb/master] USB: otg Kconfig: let USB_OTG_UTILS
	select USB_ULPI option
Message-ID: <20100307202033.GA25405@pengutronix.de>
References: <E1Nnuwt-0000VW-Fm@www.linuxtv.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <E1Nnuwt-0000VW-Fm@www.linuxtv.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

On Sat, Mar 06, 2010 at 03:25:47PM +0100, Patch from Valentin Longchamp wrote:
> From: Valentin Longchamp <valentin.longchamp@epfl.ch>
> MIME-Version: 1.0
> Content-Type: text/plain; charset=utf-8
> Content-Transfer-Encoding: 8bit
> 
> With CONFIG_USB_ULPI=y, CONFIG_USB<=m, CONFIG_PCI=n and
> CONFIG_USB_OTG_UTILS=n, which is the default used for mx31moboard,
> the build for all mx3 platforms fails because drivers/usb/otg/ulpi.c
> where otg_ulpi_create is defined is not compiled.
> 
> Build error:
> arch/arm/mach-mx3/built-in.o: In function `mxc_board_init':
> kzmarm11.c:(.init.text+0x73c): undefined reference to `otg_ulpi_create'
> kzmarm11.c:(.init.text+0x1020): undefined reference to `otg_ulpi_create'
> 
> This isn't a strong dependency as drivers/usb/otg/ulpi.c doesn't
> use functions defined in drivers/usb/otg/otg.o and is only needed
> to get ulpi.o linked into the kernel image.
> 
> Signed-off-by: Valentin Longchamp <valentin.longchamp@epfl.ch>
> Acked-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
> Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
> 
>  drivers/usb/otg/Kconfig |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
I wonder why I got this patch (and two others) via linux-media.  AFAIK
they go in (or maybe even are in) Linus' tree via other trees?!

Best regards
Uwe

-- 
Pengutronix e.K.                           | Uwe Kleine-König            |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
