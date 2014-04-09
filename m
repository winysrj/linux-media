Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.karo-electronics.de ([81.173.242.67]:58422 "EHLO
	mail.karo-electronics.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750889AbaDIGZ4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 9 Apr 2014 02:25:56 -0400
Date: Wed, 9 Apr 2014 08:23:24 +0200
From: Lothar =?UTF-8?B?V2HDn21hbm4=?= <LW@KARO-electronics.de>
To: Shawn Guo <shawn.guo@linaro.org>
Cc: Denis Carikli <denis@eukrea.com>,
	Philipp Zabel <p.zabel@pengutronix.de>,
	Eric =?UTF-8?B?QsOpbmFyZA==?= <eric@eukrea.com>,
	Sascha Hauer <kernel@pengutronix.de>,
	<linux-arm-kernel@lists.infradead.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	<devel@driverdev.osuosl.org>,
	Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Russell King <linux@arm.linux.org.uk>,
	<linux-media@vger.kernel.org>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	<dri-devel@lists.freedesktop.org>, David Airlie <airlied@linux.ie>
Subject: Re: [PATCH v12][ 06/12] ARM: dts: imx5*, imx6*: correct
 display-timings nodes.
Message-ID: <20140409082324.5637040f@ipc1.ka-ro>
In-Reply-To: <20140408114407.GB3860@dragon>
References: <1396874691-27954-1-git-send-email-denis@eukrea.com>
	<1396874691-27954-6-git-send-email-denis@eukrea.com>
	<20140408114407.GB3860@dragon>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

Shawn Guo wrote:
> On Mon, Apr 07, 2014 at 02:44:45PM +0200, Denis Carikli wrote:
> > The imx-drm driver can't use the de-active and
> > pixelclk-active display-timings properties yet.
> > 
> > Instead the data-enable and the pixel data clock
> > polarity are hardcoded in the imx-drm driver.
> > 
> > So theses properties are now set to keep
> > the same behaviour when imx-drm will start
> > using them.
> > 
> > Signed-off-by: Denis Carikli <denis@eukrea.com>
> > ---
> > ChangeLog v9->v10:
> > - New patch that was splitted out of:
> >   "staging imx-drm: Use de-active and pixelclk-active
> >   display-timings."
> > ---
> >  arch/arm/boot/dts/imx51-babbage.dts       |    2 ++
> >  arch/arm/boot/dts/imx53-m53evk.dts        |    2 ++
> >  arch/arm/boot/dts/imx53-tx53-x03x.dts     |    2 +-
> >  arch/arm/boot/dts/imx6qdl-gw53xx.dtsi     |    2 ++
> >  arch/arm/boot/dts/imx6qdl-gw54xx.dtsi     |    2 ++
> >  arch/arm/boot/dts/imx6qdl-nitrogen6x.dtsi |    2 ++
> >  arch/arm/boot/dts/imx6qdl-sabreauto.dtsi  |    2 ++
> >  arch/arm/boot/dts/imx6qdl-sabrelite.dtsi  |    2 ++
> >  arch/arm/boot/dts/imx6qdl-sabresd.dtsi    |    2 ++
> >  9 files changed, 17 insertions(+), 1 deletion(-)
> 
> ...
> 
> > diff --git a/arch/arm/boot/dts/imx53-tx53-x03x.dts b/arch/arm/boot/dts/imx53-tx53-x03x.dts
> > index 0217dde3..4092a81 100644
> > --- a/arch/arm/boot/dts/imx53-tx53-x03x.dts
> > +++ b/arch/arm/boot/dts/imx53-tx53-x03x.dts
> > @@ -93,7 +93,7 @@
> >  					hsync-active = <0>;
> >  					vsync-active = <0>;
> >  					de-active = <1>;
> > -					pixelclk-active = <1>;
> > +					pixelclk-active = <0>;
> 
> @Lothar, is this change correct?
> 
No, the ET0430 display which is affected by this patch actually has an
inverted clock wrt the other displays of the family.

'pixelclk-active = <1>' is the correct setting for this display!

Thanks, Shawn for the reminder.


Lothar Waßmann
-- 
___________________________________________________________

Ka-Ro electronics GmbH | Pascalstraße 22 | D - 52076 Aachen
Phone: +49 2408 1402-0 | Fax: +49 2408 1402-10
Geschäftsführer: Matthias Kaussen
Handelsregistereintrag: Amtsgericht Aachen, HRB 4996

www.karo-electronics.de | info@karo-electronics.de
___________________________________________________________
