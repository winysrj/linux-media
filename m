Return-path: <linux-media-owner@vger.kernel.org>
Received: from arroyo.ext.ti.com ([192.94.94.40]:50155 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752590AbZBJMLg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 10 Feb 2009 07:11:36 -0500
From: "Hiremath, Vaibhav" <hvaibhav@ti.com>
To: Alexey Klimov <klimov.linux@gmail.com>
CC: "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"Jadav, Brijesh R" <brijesh.j@ti.com>,
	"Shah, Hardik" <hardik.shah@ti.com>
Date: Tue, 10 Feb 2009 17:41:26 +0530
Subject: RE: [REVIEW PATCH 2/2] OMAP3EVM Multi-Media Daughter Card Support
Message-ID: <19F8576C6E063C45BE387C64729E739403FA81B820@dbde02.ent.ti.com>
In-Reply-To: <1233419338.19837.21.camel@tux.localhost>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



Thanks,
Vaibhav Hiremath

> -----Original Message-----
> From: Alexey Klimov [mailto:klimov.linux@gmail.com]
> Sent: Saturday, January 31, 2009 9:59 PM
> To: Hiremath, Vaibhav
> Cc: linux-omap@vger.kernel.org; linux-media@vger.kernel.org; Jadav,
> Brijesh R; Shah, Hardik
> Subject: Re: [REVIEW PATCH 2/2] OMAP3EVM Multi-Media Daughter Card
> Support
> 
> Hello, Vaibhav
> May i tell few suggestions ?
> 
> On Fri, 2009-01-30 at 00:52 +0530, hvaibhav@ti.com wrote:
> > From: Vaibhav Hiremath <hvaibhav@ti.com>
> >
> > This is second version of OMAP3EVM Mulit-Media/Mass Market
> > Daughter Card support.
> >
> > Fixes:
> >     - Cleaned unused header files, struct formating, and unused
> >       comments.
> >     - Pad/mux configuration handled in mux.ch
> >     - mux.ch related changes moved to seperate patch
> >     - Renamed file board-omap3evm-dc.c to board-omap3evm-dc-v4l.c
> >       to make more explicit.
> >     - Added some more meaningful name for Kconfig option
> >
> > TODO:
> >     - Camera sensor support (for future development).
> >     - Driver header file inclusion (dependency on ISP-Camera
> patches)
> >       I am working with Sergio to seperate/move header file to
> standard
> >       location.
> >     - Still need to fix naming convention for DC
> >
> > Tested:
> >     - TVP5146 (BT656) decoder interface on top of
> >       Sergio's ISP-Camera patches.
> >     - Loopback application, capturing image through TVP5146
> >       and saving it to file per frame.
> >     - Basic functionality of HSUSB Transceiver USB-83320
> >
> > Signed-off-by: Brijesh Jadav <brijesh.j@ti.com>
> > Signed-off-by: Hardik Shah <hardik.shah@ti.com>
> > Signed-off-by: Vaibhav Hiremath <hvaibhav@ti.com>
> > ---
> >  arch/arm/mach-omap2/Kconfig                 |    8 +-
> >  arch/arm/mach-omap2/Makefile                |    1 +
> >  arch/arm/mach-omap2/board-omap3evm-dc-v4l.c |  348
> +++++++++++++++++++++++++++
> >  arch/arm/mach-omap2/board-omap3evm-dc.h     |   42 ++++
> >  4 files changed, 398 insertions(+), 1 deletions(-)
> >  create mode 100644 arch/arm/mach-omap2/board-omap3evm-dc-v4l.c
> >  create mode 100644 arch/arm/mach-omap2/board-omap3evm-dc.h
> >
[Hiremath, Vaibhav] This patch is strongly dependent on ISP-Camera patches, and need rebase/refreshment/synchronization with latest code-base from Sergio and Sakari. I believe they are under process of fixing review comments.

Since there are only minor review comments received for MMDC patch, I will wait till the time Sergio posts the patches supporting ISP-Camera module. And then I will submit it to the community after refreshing on top of it (with review comment fix).
