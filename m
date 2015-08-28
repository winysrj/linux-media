Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f174.google.com ([209.85.212.174]:35024 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752732AbbH1RHo (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 28 Aug 2015 13:07:44 -0400
Received: by wicne3 with SMTP id ne3so24712733wic.0
        for <linux-media@vger.kernel.org>; Fri, 28 Aug 2015 10:07:43 -0700 (PDT)
Date: Fri, 28 Aug 2015 18:07:40 +0100
From: Peter Griffin <peter.griffin@linaro.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	maxime.coquelin@st.com, srinivas.kandagatla@gmail.com,
	patrice.chotard@st.com, mchehab@osg.samsung.com,
	devicetree@vger.kernel.org, linux-media@vger.kernel.org
Subject: Re: [PATCH v2 2/5] ARM: DT: STi: STiH407: Add c8sectpfe LinuxDVB DT
 node.
Message-ID: <20150828170740.GA18136@griffinp-ThinkPad-X1-Carbon-2nd>
References: <1440678575-21646-1-git-send-email-peter.griffin@linaro.org>
 <1440678575-21646-3-git-send-email-peter.griffin@linaro.org>
 <20150828070100.GF4796@x1>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150828070100.GF4796@x1>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Lee,

On Fri, 28 Aug 2015, Lee Jones wrote:

> On Thu, 27 Aug 2015, Peter Griffin wrote:
> 
> > This patch adds in the required DT node for the c8sectpfe
> > Linux DVB demux driver which allows the tsin channels
> > to be used on an upstream kernel.
> > 
> > Signed-off-by: Peter Griffin <peter.griffin@linaro.org>
> > ---
> >  arch/arm/boot/dts/stihxxx-b2120.dtsi | 34 ++++++++++++++++++++++++++++++++++
> >  1 file changed, 34 insertions(+)
> > 
> > diff --git a/arch/arm/boot/dts/stihxxx-b2120.dtsi b/arch/arm/boot/dts/stihxxx-b2120.dtsi
> > index 62994ae..c014173 100644
> > --- a/arch/arm/boot/dts/stihxxx-b2120.dtsi
> > +++ b/arch/arm/boot/dts/stihxxx-b2120.dtsi
> > @@ -6,6 +6,9 @@
> >   * it under the terms of the GNU General Public License version 2 as
> >   * published by the Free Software Foundation.
> >   */
> > +
> > +#include <dt-bindings/clock/stih407-clks.h>
> > +#include <dt-bindings/media/c8sectpfe.h>
> >  / {
> >  	soc {
> >  		sbc_serial0: serial@9530000 {
> > @@ -85,5 +88,36 @@
> >  			status = "okay";
> >  		};
> >  
> > +		demux@08a20000 {
> > +			compatible	= "st,stih407-c8sectpfe";
> > +			status		= "okay";
> > +			reg		= <0x08a20000 0x10000>,
> > +					  <0x08a00000 0x4000>;
> 
> These look like they're the wrong way round.

No, it isn't the wrong way round.

> 
> > +			reg-names	= "c8sectpfe", "c8sectpfe-ram";
> > +			interrupts	= <GIC_SPI 34 IRQ_TYPE_NONE>,
> > +					  <GIC_SPI 35 IRQ_TYPE_NONE>;
> > +			interrupt-names	= "c8sectpfe-error-irq",
> > +					  "c8sectpfe-idle-irq";
> > +			pinctrl-names	= "tsin0-serial",
> > +					  "tsin0-parallel",
> > +					  "tsin3-serial",
> > +					  "tsin4-serial",
> > +					  "tsin5-serial";
> > +			pinctrl-0	= <&pinctrl_tsin0_serial>;
> > +			pinctrl-1	= <&pinctrl_tsin0_parallel>;
> > +			pinctrl-2	= <&pinctrl_tsin3_serial>;
> > +			pinctrl-3	= <&pinctrl_tsin4_serial_alt3>;
> > +			pinctrl-4	= <&pinctrl_tsin5_serial_alt1>;
> > +			clock-names	= "c8sectpfe";
> > +			clocks		= <&clk_s_c0_flexgen CLK_PROC_STFE>;
> 
> Personal preferenc is that the *-names properties should come *after*
> the ones they reference.

Ok, will fix this in v3.

> 
> > +			/* tsin0 is TSA on NIMA */
> > +			tsin0: port@0 {
> > +				tsin-num	= <0>;
> > +				serial-not-parallel;
> > +				i2c-bus		= <&ssc2>;
> > +				rst-gpio	= <&pio15 4 0>;
> 
> "reset-gpios"?
> 
> Use the GPIO DEFINES.

This change is done in patch 4/5 as one atomic commit
(code, dt doc, and dt node).

I could have used the GPIO_DEFINE in this patch and
updated the dt binding in 4/5.

I'll do that in v3.

regards,

Peter.
