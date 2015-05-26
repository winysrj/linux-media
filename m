Return-path: <linux-media-owner@vger.kernel.org>
Received: from arroyo.ext.ti.com ([192.94.94.40]:58340 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750835AbbEZSm4 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 26 May 2015 14:42:56 -0400
Date: Tue, 26 May 2015 13:39:55 -0500
From: Felipe Balbi <balbi@ti.com>
To: Arun Ramamurthy <arun.ramamurthy@broadcom.com>
CC: <balbi@ti.com>, Jonathan Corbet <corbet@lwn.net>,
	Tejun Heo <tj@kernel.org>,
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
Message-ID: <20150526183955.GW26599@saruman.tx.rr.com>
Reply-To: <balbi@ti.com>
References: <1429743853-10254-1-git-send-email-arun.ramamurthy@broadcom.com>
 <1429743853-10254-2-git-send-email-arun.ramamurthy@broadcom.com>
 <20150515005210.GA31534@saruman.tx.rr.com>
 <556391FE.1020503@broadcom.com>
 <20150526141938.GA25686@saruman.tx.rr.com>
 <5564BD5D.1070601@broadcom.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="SqGHvGqRphKoTacN"
Content-Disposition: inline
In-Reply-To: <5564BD5D.1070601@broadcom.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--SqGHvGqRphKoTacN
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, May 26, 2015 at 11:37:17AM -0700, Arun Ramamurthy wrote:
> Hi
>=20
> On 15-05-26 07:19 AM, Felipe Balbi wrote:
> >HI,
> >
> >On Mon, May 25, 2015 at 02:19:58PM -0700, Arun Ramamurthy wrote:
> >>
> >>
> >>On 15-05-14 05:52 PM, Felipe Balbi wrote:
> >>>Hi,
> >>>
> >>>On Wed, Apr 22, 2015 at 04:04:10PM -0700, Arun Ramamurthy wrote:
> >>>>Most of the phy providers use "select" to enable GENERIC_PHY. Since s=
elect
> >>>>is only recommended when the config is not visible, GENERIC_PHY is ch=
anged
> >>>>an invisible option. To maintain consistency, all phy providers are c=
hanged
> >>>>to "select" GENERIC_PHY and all non-phy drivers use "depends on" when=
 the
> >>>>phy framework is explicity required. USB_MUSB_OMAP2PLUS has a cyclic
> >>>>dependency, so it is left as "select".
> >>>>
> >>>>Signed-off-by: Arun Ramamurthy <arun.ramamurthy@broadcom.com>
> >>>>---
> >>>>  drivers/ata/Kconfig                       | 1 -
> >>>>  drivers/media/platform/exynos4-is/Kconfig | 2 +-
> >>>>  drivers/phy/Kconfig                       | 4 ++--
> >>>>  drivers/usb/host/Kconfig                  | 4 ++--
> >>>>  drivers/video/fbdev/exynos/Kconfig        | 2 +-
> >>>>  5 files changed, 6 insertions(+), 7 deletions(-)
> >>>>
> >>>>diff --git a/drivers/ata/Kconfig b/drivers/ata/Kconfig
> >>>>index 5f60155..6d2e881 100644
> >>>>--- a/drivers/ata/Kconfig
> >>>>+++ b/drivers/ata/Kconfig
> >>>>@@ -301,7 +301,6 @@ config SATA_MV
> >>>>  	tristate "Marvell SATA support"
> >>>>  	depends on PCI || ARCH_DOVE || ARCH_MV78XX0 || \
> >>>>  		   ARCH_MVEBU || ARCH_ORION5X || COMPILE_TEST
> >>>>-	select GENERIC_PHY
> >>>>  	help
> >>>>  	  This option enables support for the Marvell Serial ATA family.
> >>>>  	  Currently supports 88SX[56]0[48][01] PCI(-X) chips,
> >>>>diff --git a/drivers/media/platform/exynos4-is/Kconfig b/drivers/medi=
a/platform/exynos4-is/Kconfig
> >>>>index b7b2e47..b6f3eaa 100644
> >>>>--- a/drivers/media/platform/exynos4-is/Kconfig
> >>>>+++ b/drivers/media/platform/exynos4-is/Kconfig
> >>>>@@ -31,7 +31,7 @@ config VIDEO_S5P_FIMC
> >>>>  config VIDEO_S5P_MIPI_CSIS
> >>>>  	tristate "S5P/EXYNOS MIPI-CSI2 receiver (MIPI-CSIS) driver"
> >>>>  	depends on REGULATOR
> >>>>-	select GENERIC_PHY
> >>>>+	depends on GENERIC_PHY
> >>>>  	help
> >>>>  	  This is a V4L2 driver for Samsung S5P and EXYNOS4 SoC MIPI-CSI2
> >>>>  	  receiver (MIPI-CSIS) devices.
> >>>>diff --git a/drivers/phy/Kconfig b/drivers/phy/Kconfig
> >>>>index 2962de2..edecdb1 100644
> >>>>--- a/drivers/phy/Kconfig
> >>>>+++ b/drivers/phy/Kconfig
> >>>>@@ -5,7 +5,7 @@
> >>>>  menu "PHY Subsystem"
> >>>>
> >>>>  config GENERIC_PHY
> >>>>-	bool "PHY Core"
> >>>>+	bool
> >>>>  	help
> >>>>  	  Generic PHY support.
> >>>>
> >>>>@@ -72,7 +72,7 @@ config PHY_MIPHY365X
> >>>>  config PHY_RCAR_GEN2
> >>>>  	tristate "Renesas R-Car generation 2 USB PHY driver"
> >>>>  	depends on ARCH_SHMOBILE
> >>>>-	depends on GENERIC_PHY
> >>>>+	select GENERIC_PHY
> >>>
> >>>so some you changed from depends to select...
> >>>
> >>>>  	help
> >>>>  	  Support for USB PHY found on Renesas R-Car generation 2 SoCs.
> >>>>
> >>>>diff --git a/drivers/usb/host/Kconfig b/drivers/usb/host/Kconfig
> >>>>index 5ad60e4..e2197e2 100644
> >>>>--- a/drivers/usb/host/Kconfig
> >>>>+++ b/drivers/usb/host/Kconfig
> >>>>@@ -182,7 +182,7 @@ config USB_EHCI_HCD_SPEAR
> >>>>  config USB_EHCI_HCD_STI
> >>>>  	tristate "Support for ST STiHxxx on-chip EHCI USB controller"
> >>>>  	depends on ARCH_STI && OF
> >>>>-	select GENERIC_PHY
> >>>>+	depends on GENERIC_PHY
> >>>
> >>>while others you changed from select to depends.
> >>>
> >>>NAK.
> >>>
> >>Felipe, I dont understand your concern, could you please explain it more
> >>detail?  The logic behind the changes is that in cases where there was =
an
> >>explicit dependency, I changed it to "depends on" and in other cases I
> >>changed it to "selects". Thanks
> >
> >Since GENERIC_PHY is visible from Kconfig, it would be much nicer to
> >avoid select altogether.
> >
> Felipe, after discussion with the maintainers, I have made GENERIC_PHY an
> invisible option as part of this change. Thanks

Then, if the option is invisible, how can you "depend" on it ? It can
never be selected by poking around in Kconfig. IMO, it's
counterintuitive that you need to enable a PHY driver before you can see
your EHCI/OHCI/whatever controller listed in Kconfig.

--=20
balbi

--SqGHvGqRphKoTacN
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJVZL37AAoJEIaOsuA1yqREYmsP/0GcYQ1JlJr3bXCNwKT+F1mh
kdMtcehzUFKWeWue/IvtHlGUQ89VtA2nBnVCUPz3Kydvw+anUJTIxQ3zwEeuE2sf
W65h4mgH1ykSnFBVY0CBK1LSvyVJ4qxqPTnKANvKrl99tdjEmtJzWPPxnZBw6pnr
/y96MhL1zm2Hn3Pm/CPe8NcdnNOd7MXgWif6VxOWpC3ody5z9aMM8ZhLt2bTf9Sw
hAEfI1Nb8NdSv+z/CSLqkvZS589bgQps2A4Btv9ZQJ9tBEQqeZC4wcLAC9Rm3ddB
auALPyjuw/QPwEoglnS/eE0X36kucY7ddWIQb+OjeXV4I39pqa0s9KovTD42wONG
MxvlmlZLoxh4OtgET4KJksC4/lWTjET7loAM9AkXmrtYlkZqozNG+cMBYsIkzUul
DJpA/nuwAyqei4ks2k6i2P1vFQ8M42g/Dtiy+/Wz/EYT4+nOx2fvnHXIqZO52Nou
TqoFDUgsViBCmR0cNZnja+CFHn6PJoqd/yBzWvFV9E5Xe1yUMgpT//EZDp9XkOGJ
Q9vYmNRVPEjpnSj9TPCIZzct8mg0U1pu3GB99mGPb75ECk/FKsVG5s4/t+PfLFHX
sYnt0udk+pbVrM6UX0LOVLASWikYtQKqS0M8uV4fGbKhf1w5Xf3E0RJyk8LkTFPW
Cm1xrgHiwn3os+aIWRvx
=bNqk
-----END PGP SIGNATURE-----

--SqGHvGqRphKoTacN--
