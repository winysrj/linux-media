Return-path: <linux-media-owner@vger.kernel.org>
Received: from arroyo.ext.ti.com ([192.94.94.40]:56869 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751771AbbFASmL (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 1 Jun 2015 14:42:11 -0400
Date: Mon, 1 Jun 2015 13:39:02 -0500
From: Felipe Balbi <balbi@ti.com>
To: Kishon Vijay Abraham I <kishon@ti.com>
CC: <balbi@ti.com>, Arun Ramamurthy <arun.ramamurthy@broadcom.com>,
	Jonathan Corbet <corbet@lwn.net>, Tejun Heo <tj@kernel.org>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Kukjin Kim <kgene@kernel.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Alan Stern <stern@rowland.harvard.edu>,
	Tony Prisk <linux@prisktech.co.nz>,
	Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
	Tomi Valkeinen <tomi.valkeinen@ti.com>,
	Arnd Bergmann <arnd@arndb.de>,
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
Message-ID: <20150601183902.GG26081@saruman.tx.rr.com>
Reply-To: <balbi@ti.com>
References: <1429743853-10254-1-git-send-email-arun.ramamurthy@broadcom.com>
 <1429743853-10254-2-git-send-email-arun.ramamurthy@broadcom.com>
 <20150515005210.GA31534@saruman.tx.rr.com>
 <556391FE.1020503@broadcom.com>
 <20150526141938.GA25686@saruman.tx.rr.com>
 <5564BD5D.1070601@broadcom.com>
 <20150526183955.GW26599@saruman.tx.rr.com>
 <55684ECE.9060003@ti.com>
 <20150529150413.GB2026@saruman.tx.rr.com>
 <556C5599.9020808@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="E69HUUNAyIJqGpVn"
Content-Disposition: inline
In-Reply-To: <556C5599.9020808@ti.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--E69HUUNAyIJqGpVn
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jun 01, 2015 at 06:22:41PM +0530, Kishon Vijay Abraham I wrote:
> Hi,
>=20
> On Friday 29 May 2015 08:34 PM, Felipe Balbi wrote:
> >Hi,
> >
> >On Fri, May 29, 2015 at 05:04:38PM +0530, Kishon Vijay Abraham I wrote:
> >>Hi Felipe,
> >>
> >>On Wednesday 27 May 2015 12:09 AM, Felipe Balbi wrote:
> >>>On Tue, May 26, 2015 at 11:37:17AM -0700, Arun Ramamurthy wrote:
> >>>>Hi
> >>>>
> >>>>On 15-05-26 07:19 AM, Felipe Balbi wrote:
> >>>>>HI,
> >>>>>
> >>>>>On Mon, May 25, 2015 at 02:19:58PM -0700, Arun Ramamurthy wrote:
> >>>>>>
> >>>>>>
> >>>>>>On 15-05-14 05:52 PM, Felipe Balbi wrote:
> >>>>>>>Hi,
> >>>>>>>
> >>>>>>>On Wed, Apr 22, 2015 at 04:04:10PM -0700, Arun Ramamurthy wrote:
> >>>>>>>>Most of the phy providers use "select" to enable GENERIC_PHY. Sin=
ce select
> >>>>>>>>is only recommended when the config is not visible, GENERIC_PHY i=
s changed
> >>>>>>>>an invisible option. To maintain consistency, all phy providers a=
re changed
> >>>>>>>>to "select" GENERIC_PHY and all non-phy drivers use "depends on" =
when the
> >>>>>>>>phy framework is explicity required. USB_MUSB_OMAP2PLUS has a cyc=
lic
> >>>>>>>>dependency, so it is left as "select".
> >>>>>>>>
> >>>>>>>>Signed-off-by: Arun Ramamurthy <arun.ramamurthy@broadcom.com>
> >>>>>>>>---
> >>>>>>>>  drivers/ata/Kconfig                       | 1 -
> >>>>>>>>  drivers/media/platform/exynos4-is/Kconfig | 2 +-
> >>>>>>>>  drivers/phy/Kconfig                       | 4 ++--
> >>>>>>>>  drivers/usb/host/Kconfig                  | 4 ++--
> >>>>>>>>  drivers/video/fbdev/exynos/Kconfig        | 2 +-
> >>>>>>>>  5 files changed, 6 insertions(+), 7 deletions(-)
> >>>>>>>>
> >>>>>>>>diff --git a/drivers/ata/Kconfig b/drivers/ata/Kconfig
> >>>>>>>>index 5f60155..6d2e881 100644
> >>>>>>>>--- a/drivers/ata/Kconfig
> >>>>>>>>+++ b/drivers/ata/Kconfig
> >>>>>>>>@@ -301,7 +301,6 @@ config SATA_MV
> >>>>>>>>  	tristate "Marvell SATA support"
> >>>>>>>>  	depends on PCI || ARCH_DOVE || ARCH_MV78XX0 || \
> >>>>>>>>  		   ARCH_MVEBU || ARCH_ORION5X || COMPILE_TEST
> >>>>>>>>-	select GENERIC_PHY
> >>>>>>>>  	help
> >>>>>>>>  	  This option enables support for the Marvell Serial ATA famil=
y.
> >>>>>>>>  	  Currently supports 88SX[56]0[48][01] PCI(-X) chips,
> >>>>>>>>diff --git a/drivers/media/platform/exynos4-is/Kconfig b/drivers/=
media/platform/exynos4-is/Kconfig
> >>>>>>>>index b7b2e47..b6f3eaa 100644
> >>>>>>>>--- a/drivers/media/platform/exynos4-is/Kconfig
> >>>>>>>>+++ b/drivers/media/platform/exynos4-is/Kconfig
> >>>>>>>>@@ -31,7 +31,7 @@ config VIDEO_S5P_FIMC
> >>>>>>>>  config VIDEO_S5P_MIPI_CSIS
> >>>>>>>>  	tristate "S5P/EXYNOS MIPI-CSI2 receiver (MIPI-CSIS) driver"
> >>>>>>>>  	depends on REGULATOR
> >>>>>>>>-	select GENERIC_PHY
> >>>>>>>>+	depends on GENERIC_PHY
> >>>>>>>>  	help
> >>>>>>>>  	  This is a V4L2 driver for Samsung S5P and EXYNOS4 SoC MIPI-C=
SI2
> >>>>>>>>  	  receiver (MIPI-CSIS) devices.
> >>>>>>>>diff --git a/drivers/phy/Kconfig b/drivers/phy/Kconfig
> >>>>>>>>index 2962de2..edecdb1 100644
> >>>>>>>>--- a/drivers/phy/Kconfig
> >>>>>>>>+++ b/drivers/phy/Kconfig
> >>>>>>>>@@ -5,7 +5,7 @@
> >>>>>>>>  menu "PHY Subsystem"
> >>>>>>>>
> >>>>>>>>  config GENERIC_PHY
> >>>>>>>>-	bool "PHY Core"
> >>>>>>>>+	bool
> >>>>>>>>  	help
> >>>>>>>>  	  Generic PHY support.
> >>>>>>>>
> >>>>>>>>@@ -72,7 +72,7 @@ config PHY_MIPHY365X
> >>>>>>>>  config PHY_RCAR_GEN2
> >>>>>>>>  	tristate "Renesas R-Car generation 2 USB PHY driver"
> >>>>>>>>  	depends on ARCH_SHMOBILE
> >>>>>>>>-	depends on GENERIC_PHY
> >>>>>>>>+	select GENERIC_PHY
> >>>>>>>
> >>>>>>>so some you changed from depends to select...
> >>>>>>>
> >>>>>>>>  	help
> >>>>>>>>  	  Support for USB PHY found on Renesas R-Car generation 2 SoCs.
> >>>>>>>>
> >>>>>>>>diff --git a/drivers/usb/host/Kconfig b/drivers/usb/host/Kconfig
> >>>>>>>>index 5ad60e4..e2197e2 100644
> >>>>>>>>--- a/drivers/usb/host/Kconfig
> >>>>>>>>+++ b/drivers/usb/host/Kconfig
> >>>>>>>>@@ -182,7 +182,7 @@ config USB_EHCI_HCD_SPEAR
> >>>>>>>>  config USB_EHCI_HCD_STI
> >>>>>>>>  	tristate "Support for ST STiHxxx on-chip EHCI USB controller"
> >>>>>>>>  	depends on ARCH_STI && OF
> >>>>>>>>-	select GENERIC_PHY
> >>>>>>>>+	depends on GENERIC_PHY
> >>>>>>>
> >>>>>>>while others you changed from select to depends.
> >>>>>>>
> >>>>>>>NAK.
> >>>>>>>
> >>>>>>Felipe, I dont understand your concern, could you please explain it=
 more
> >>>>>>detail?  The logic behind the changes is that in cases where there =
was an
> >>>>>>explicit dependency, I changed it to "depends on" and in other case=
s I
> >>>>>>changed it to "selects". Thanks
> >>>>>
> >>>>>Since GENERIC_PHY is visible from Kconfig, it would be much nicer to
> >>>>>avoid select altogether.
> >>>>>
> >>>>Felipe, after discussion with the maintainers, I have made GENERIC_PH=
Y an
> >>>>invisible option as part of this change. Thanks
> >>>
> >>>Then, if the option is invisible, how can you "depend" on it ? It can
> >>>never be selected by poking around in Kconfig. IMO, it's
> >>>counterintuitive that you need to enable a PHY driver before you can s=
ee
> >>>your EHCI/OHCI/whatever controller listed in Kconfig.
> >>
> >>If the controller requires PHY for it to be functional, it is okay to m=
ake
> >>the controller depend on PHY IMHO. We want to try and minimize the usag=
e of
> >>'select' wherever possible or else 'select' is the most intuitive way. =
The
> >>other option is just to leave the 'depends on' and let the user select =
PHY.
> >
> >How can you 'depend' on something that the user can't select by
> >navigating through Kconfig ?
>=20
> hmm... Actually it's selected when the user selects the PHY driver.

that's my point, don't you think it's a little counter-intuitive ?

> Maybe we should directly depend on the PHY driver instead of Generic
> PHY?

maybe... But then what do you do when you have different boards using
different PHYs ?

--=20
balbi

--E69HUUNAyIJqGpVn
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJVbKbGAAoJEIaOsuA1yqREsFUQAIGrVwFCpphY920lpk6CZVsf
B1LWJ8FSsfEVmVS7GrpliW4dUMx+MQaqEz0tZrAlGOqg0FcqhkOztA4rJfbYVS9d
2dbFE5v21YohQ2H7IYLbQ56yFIZirxg0Pc23OZNrIOsVh0Or46XLsYvH1sJ4OkAs
uP8+d4gJCRjZoSka/Zu8h2hh7x8XN7RGaDxO5eCH3mcWnUfMR1puZnSDz59FUfpC
GlX0PtCxNGLuswDhRXBRvK47ghPj3iIHLZ8mLRqr+qgozJA35gcM8O1C1ChzZsRW
pfF8WJ8tzPoajA9E0MvU89LB7PCV/zVLLYqgjK7Z4FEtf5OaviJ13AWbAgEc350x
nqd3k5ZhiXRM2qkvL/OFqcqMiihtGSzMUvxpjjzdA9eOt47vC7cFOiM0XCNwir5j
yhCuiRwjFa+XKLSeawvVOumBtq1SxdNT1bvUf6fmc7yKzRwOZ0w5UFgAYVekDedx
lAuAbMQaezM4UeiBF+e16vLGPejiJBf5aA7aPzl7yM4ufTDEZ5nu/YsEMaJ8lPbs
06xBd3jZ7WNyGyN4IRMAs2ticSIJeF40/GYQ/gEdydvcgtkyRfWe7WqIOnrHJhnI
NuHdoqV60CqLFwhTuH8iILaNwk7+kRev7+cD/8ExNJ6htFHj4Ol8nSpCR6HD5ZEr
djisWMUAu7SU/kED905p
=eGxF
-----END PGP SIGNATURE-----

--E69HUUNAyIJqGpVn--
