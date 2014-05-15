Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bn1lp0144.outbound.protection.outlook.com ([207.46.163.144]:7213
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751077AbaEOBUo (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 14 May 2014 21:20:44 -0400
Date: Thu, 15 May 2014 09:19:35 +0800
From: Shawn Guo <shawn.guo@freescale.com>
To: Alexander Shiyan <shc_work@mail.ru>
CC: Sylwester Nawrocki <s.nawrocki@samsung.com>,
	<linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <m.chehab@samsung.com>,
	<devicetree@vger.kernel.org>, Sascha Hauer <kernel@pengutronix.de>
Subject: Re: [PATCH 3/3] media: mx2-emmaprp: Add devicetree support
Message-ID: <20140515011933.GA10685@dragon>
References: <1399015119-24000-1-git-send-email-shc_work@mail.ru>
 <1400001829.645600850@f332.i.mail.ru> <53734A1F.7080905@samsung.com>
 <1400086794.204219517@f388.i.mail.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1400086794.204219517@f388.i.mail.ru>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, May 14, 2014 at 08:59:54PM +0400, Alexander Shiyan wrote:
> Wed, 14 May 2014 12:49:03 +0200 от Sylwester Nawrocki <s.nawrocki@samsung.com>:
> > On 13/05/14 19:23, Alexander Shiyan wrote:
> > > Tue, 13 May 2014 19:09:30 +0200 от Sylwester Nawrocki <s.nawrocki@samsung.com>:
> > >> > Hi,
> > >> > 
> > >> > On 02/05/14 09:18, Alexander Shiyan wrote:
> > >>> > > This patch adds devicetree support for the Freescale enhanced Multimedia
> > >>> > > Accelerator (eMMA) video Pre-processor (PrP).
> > >>> > > 
> > >>> > > Signed-off-by: Alexander Shiyan <shc_work@mail.ru>
> > >>> > > ---
> > >>> > >  .../devicetree/bindings/media/fsl-imx-emmaprp.txt     | 19 +++++++++++++++++++
> > >>> > >  drivers/media/platform/mx2_emmaprp.c                  |  8 ++++++++
> > >>> > >  2 files changed, 27 insertions(+)
> > >>> > >  create mode 100644 Documentation/devicetree/bindings/media/fsl-imx-emmaprp.txt
> > >>> > > 
> > >>> > > diff --git a/Documentation/devicetree/bindings/media/fsl-imx-emmaprp.txt b/Documentation/devicetree/bindings/media/fsl-imx-emmaprp.txt
> > >>> > > new file mode 100644
> > >>> > > index 0000000..9e8238f
> > >>> > > --- /dev/null
> > >>> > > +++ b/Documentation/devicetree/bindings/media/fsl-imx-emmaprp.txt
> > >>> > > @@ -0,0 +1,19 @@
> > >>> > > +* Freescale enhanced Multimedia Accelerator (eMMA) video Pre-processor (PrP)
> > >>> > > +  for i.MX.
> > >>> > > +
> > >>> > > +Required properties:
> > >>> > > +- compatible : Shall contain "fsl,imx21-emmaprp".
> > >>> > > +- reg        : Offset and length of the register set for the device.
> > >>> > > +- interrupts : Should contain eMMA PrP interrupt number.
> > >>> > > +- clocks     : Should contain the ahb and ipg clocks, in the order
> > >>> > > +               determined by the clock-names property.
> > >>> > > +- clock-names: Should be "ahb", "ipg".
> > >>> > > +
> > >>> > > +Example:
> > >>> > > +	emmaprp: emmaprp@10026400 {
> > >>> > > +		compatible = "fsl,imx27-emmaprp", "fsl,imx21-emmaprp";
> > >> > 
> > >> > Is "fsl,imx27-emmaprp" compatible documented somewhere ?
> > >
> > > The overall structure of the eMMA module is slightly different.
> > > As for the part of the PrP, according to the datasheet they are compatible.
> > 
> > Then can we please have all the valid compatible strings listed at the
> > 'compatible' property's description above ? I think it is useful to have
> > an indication to which SoC each of them apply in documentation of the
> > binding.
> 
> Traditionally, i.MX drivers uses youngest chip for compatibility string.
> The best example of this: drivers/bus/imx-weim.c

I guess Sylwester's point is either "fsl,imx27-emmaprp" is documented in
the bindings or it shouldn't be used anywhere.

Shawn
