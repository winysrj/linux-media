Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:53902 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753838AbaENKtI (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 14 May 2014 06:49:08 -0400
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 8BIT
Message-id: <53734A1F.7080905@samsung.com>
Date: Wed, 14 May 2014 12:49:03 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
To: Alexander Shiyan <shc_work@mail.ru>
Cc: linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Shawn Guo <shawn.guo@freescale.com>, devicetree@vger.kernel.org
Subject: Re: [PATCH 3/3] media: mx2-emmaprp: Add devicetree support
References: <1399015119-24000-1-git-send-email-shc_work@mail.ru>
 <537251CA.3070005@samsung.com> <1400001829.645600850@f332.i.mail.ru>
In-reply-to: <1400001829.645600850@f332.i.mail.ru>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 13/05/14 19:23, Alexander Shiyan wrote:
> Tue, 13 May 2014 19:09:30 +0200 от Sylwester Nawrocki <s.nawrocki@samsung.com>:
>> > Hi,
>> > 
>> > On 02/05/14 09:18, Alexander Shiyan wrote:
>>> > > This patch adds devicetree support for the Freescale enhanced Multimedia
>>> > > Accelerator (eMMA) video Pre-processor (PrP).
>>> > > 
>>> > > Signed-off-by: Alexander Shiyan <shc_work@mail.ru>
>>> > > ---
>>> > >  .../devicetree/bindings/media/fsl-imx-emmaprp.txt     | 19 +++++++++++++++++++
>>> > >  drivers/media/platform/mx2_emmaprp.c                  |  8 ++++++++
>>> > >  2 files changed, 27 insertions(+)
>>> > >  create mode 100644 Documentation/devicetree/bindings/media/fsl-imx-emmaprp.txt
>>> > > 
>>> > > diff --git a/Documentation/devicetree/bindings/media/fsl-imx-emmaprp.txt b/Documentation/devicetree/bindings/media/fsl-imx-emmaprp.txt
>>> > > new file mode 100644
>>> > > index 0000000..9e8238f
>>> > > --- /dev/null
>>> > > +++ b/Documentation/devicetree/bindings/media/fsl-imx-emmaprp.txt
>>> > > @@ -0,0 +1,19 @@
>>> > > +* Freescale enhanced Multimedia Accelerator (eMMA) video Pre-processor (PrP)
>>> > > +  for i.MX.
>>> > > +
>>> > > +Required properties:
>>> > > +- compatible : Shall contain "fsl,imx21-emmaprp".
>>> > > +- reg        : Offset and length of the register set for the device.
>>> > > +- interrupts : Should contain eMMA PrP interrupt number.
>>> > > +- clocks     : Should contain the ahb and ipg clocks, in the order
>>> > > +               determined by the clock-names property.
>>> > > +- clock-names: Should be "ahb", "ipg".
>>> > > +
>>> > > +Example:
>>> > > +	emmaprp: emmaprp@10026400 {
>>> > > +		compatible = "fsl,imx27-emmaprp", "fsl,imx21-emmaprp";
>> > 
>> > Is "fsl,imx27-emmaprp" compatible documented somewhere ?
>
> The overall structure of the eMMA module is slightly different.
> As for the part of the PrP, according to the datasheet they are compatible.

Then can we please have all the valid compatible strings listed at the
'compatible' property's description above ? I think it is useful to have
an indication to which SoC each of them apply in documentation of the
binding.

--
Thanks,
Sylwester
