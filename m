Return-path: <linux-media-owner@vger.kernel.org>
Received: from devils.ext.ti.com ([198.47.26.153]:43323 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423341AbbEOAy7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 14 May 2015 20:54:59 -0400
Date: Thu, 14 May 2015 19:52:10 -0500
From: Felipe Balbi <balbi@ti.com>
To: Arun Ramamurthy <arun.ramamurthy@broadcom.com>
CC: Jonathan Corbet <corbet@lwn.net>, Tejun Heo <tj@kernel.org>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Kukjin Kim <kgene@kernel.org>,
	Kishon Vijay Abraham I <kishon@ti.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Alan Stern <stern@rowland.harvard.edu>,
	Tony Prisk <linux@prisktech.co.nz>,
	Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
	Tomi Valkeinen <tomi.valkeinen@ti.com>,
	Arnd Bergmann <arnd@arndb.de>, Felipe Balbi <balbi@ti.com>,
	Mathias Nyman <mathias.nyman@linux.intel.com>,
	Paul Bolle <pebolle@tiscali.nl>,
	Thomas Pugliese <thomas.pugliese@gmail.com>,
	Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
	Masanari Iida <standby24x7@gmail.com>,
	David Mosberger <davidm@egauge.net>,
	Peter Griffin <peter.griffin@linaro.org>,
	Gregory CLEMENT <gregory.clement@free-electrons.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Kevin Hao <haokexin@gmail.com>,
	Jean Delvare <jdelvare@suse.de>, <linux-doc@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <linux-ide@vger.kernel.org>,
	<linux-media@vger.kernel.org>,
	<linux-arm-kernel@lists.infradead.org>,
	<linux-samsung-soc@vger.kernel.org>, <linux-usb@vger.kernel.org>,
	<linux-fbdev@vger.kernel.org>, Dmitry Torokhov <dtor@google.com>,
	Anatol Pomazau <anatol@google.com>,
	Jonathan Richardson <jonathar@broadcom.com>,
	Scott Branden <sbranden@broadcom.com>,
	Ray Jui <rjui@broadcom.com>,
	<bcm-kernel-feedback-list@broadcom.com>
Subject: Re: [PATCHv3 1/4] phy: phy-core: Make GENERIC_PHY an invisible option
Message-ID: <20150515005210.GA31534@saruman.tx.rr.com>
Reply-To: <balbi@ti.com>
References: <1429743853-10254-1-git-send-email-arun.ramamurthy@broadcom.com>
 <1429743853-10254-2-git-send-email-arun.ramamurthy@broadcom.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="LQksG6bCIzRHxTLp"
Content-Disposition: inline
In-Reply-To: <1429743853-10254-2-git-send-email-arun.ramamurthy@broadcom.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--LQksG6bCIzRHxTLp
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Wed, Apr 22, 2015 at 04:04:10PM -0700, Arun Ramamurthy wrote:
> Most of the phy providers use "select" to enable GENERIC_PHY. Since select
> is only recommended when the config is not visible, GENERIC_PHY is changed
> an invisible option. To maintain consistency, all phy providers are chang=
ed
> to "select" GENERIC_PHY and all non-phy drivers use "depends on" when the
> phy framework is explicity required. USB_MUSB_OMAP2PLUS has a cyclic
> dependency, so it is left as "select".
>=20
> Signed-off-by: Arun Ramamurthy <arun.ramamurthy@broadcom.com>
> ---
>  drivers/ata/Kconfig                       | 1 -
>  drivers/media/platform/exynos4-is/Kconfig | 2 +-
>  drivers/phy/Kconfig                       | 4 ++--
>  drivers/usb/host/Kconfig                  | 4 ++--
>  drivers/video/fbdev/exynos/Kconfig        | 2 +-
>  5 files changed, 6 insertions(+), 7 deletions(-)
>=20
> diff --git a/drivers/ata/Kconfig b/drivers/ata/Kconfig
> index 5f60155..6d2e881 100644
> --- a/drivers/ata/Kconfig
> +++ b/drivers/ata/Kconfig
> @@ -301,7 +301,6 @@ config SATA_MV
>  	tristate "Marvell SATA support"
>  	depends on PCI || ARCH_DOVE || ARCH_MV78XX0 || \
>  		   ARCH_MVEBU || ARCH_ORION5X || COMPILE_TEST
> -	select GENERIC_PHY
>  	help
>  	  This option enables support for the Marvell Serial ATA family.
>  	  Currently supports 88SX[56]0[48][01] PCI(-X) chips,
> diff --git a/drivers/media/platform/exynos4-is/Kconfig b/drivers/media/pl=
atform/exynos4-is/Kconfig
> index b7b2e47..b6f3eaa 100644
> --- a/drivers/media/platform/exynos4-is/Kconfig
> +++ b/drivers/media/platform/exynos4-is/Kconfig
> @@ -31,7 +31,7 @@ config VIDEO_S5P_FIMC
>  config VIDEO_S5P_MIPI_CSIS
>  	tristate "S5P/EXYNOS MIPI-CSI2 receiver (MIPI-CSIS) driver"
>  	depends on REGULATOR
> -	select GENERIC_PHY
> +	depends on GENERIC_PHY
>  	help
>  	  This is a V4L2 driver for Samsung S5P and EXYNOS4 SoC MIPI-CSI2
>  	  receiver (MIPI-CSIS) devices.
> diff --git a/drivers/phy/Kconfig b/drivers/phy/Kconfig
> index 2962de2..edecdb1 100644
> --- a/drivers/phy/Kconfig
> +++ b/drivers/phy/Kconfig
> @@ -5,7 +5,7 @@
>  menu "PHY Subsystem"
> =20
>  config GENERIC_PHY
> -	bool "PHY Core"
> +	bool
>  	help
>  	  Generic PHY support.
> =20
> @@ -72,7 +72,7 @@ config PHY_MIPHY365X
>  config PHY_RCAR_GEN2
>  	tristate "Renesas R-Car generation 2 USB PHY driver"
>  	depends on ARCH_SHMOBILE
> -	depends on GENERIC_PHY
> +	select GENERIC_PHY

so some you changed from depends to select...

>  	help
>  	  Support for USB PHY found on Renesas R-Car generation 2 SoCs.
> =20
> diff --git a/drivers/usb/host/Kconfig b/drivers/usb/host/Kconfig
> index 5ad60e4..e2197e2 100644
> --- a/drivers/usb/host/Kconfig
> +++ b/drivers/usb/host/Kconfig
> @@ -182,7 +182,7 @@ config USB_EHCI_HCD_SPEAR
>  config USB_EHCI_HCD_STI
>  	tristate "Support for ST STiHxxx on-chip EHCI USB controller"
>  	depends on ARCH_STI && OF
> -	select GENERIC_PHY
> +	depends on GENERIC_PHY

while others you changed from select to depends.

NAK.

--=20
balbi

--LQksG6bCIzRHxTLp
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJVVUM6AAoJEIaOsuA1yqRE1EwP/RDMwkCFyZHRfZL/OOXOfdof
EFZFSuW7QcNT5MceiWlbo0uWjo7xiUSSyHUe4/D66pntOQEWobnJhQJrqQA5WoPl
+c74g5NE/dkjdOmPcHoA9nyfi4M+uW7X1JI34+Y2oSfDAETWKNu5QGxTFulm9tKp
4vNODYmU2lbe+4+xl71iSYyjbkpliuhM/sRj6P2hNhV24kysfsL1Nqh5dEatR/un
XvBqVxxDAMXe7T647CI9R+urW1zQ2ix8ALVcYBD9lot4gDL5Lru1zadHkOBx7RPr
43wI9PSgEIb/Z+Ur6M0b4OsJkq0VVK42dkRd3gMyKeC7Djf2nfSU/XmtyWkewTwO
1ACWBo+9lnpIvGiblkZFtuNqehTupdVvGakXrRXojtIytt8ipCVGDYsl//IPmahC
JkZG4BnhsLgmXYlwSYlDEtmE/82Mg7w1n2AyLjbWgwbkbzZmT+iYiLiorhlNJO9H
U+kq+cd0RQK3mQqRc8GiE6Y2OeLoOWzRgQKrcFhQ5jrIbeEwqhAnxAH35uHywcgp
Mx4VmyOQRuNWkytQJEj0WNetvkwjs6pVRjyxPgs+T7h9JKuPxGTlkhYmLoczz8zx
5J3EKJ2c6/PpRYdYXpl18dFdRhaDDV6R0rSHCBdqw/G8uczcGxifNHErfnAlIs/h
OltLWaE+xPlWhGZS0xSx
=urxV
-----END PGP SIGNATURE-----

--LQksG6bCIzRHxTLp--
