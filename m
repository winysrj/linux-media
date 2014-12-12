Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:45804 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030737AbaLLQ6l (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 12 Dec 2014 11:58:41 -0500
Message-ID: <1418403519.3172.13.camel@pengutronix.de>
Subject: Re: VPU on iMX51 babbage board
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Pierluigi Passaro <pierluigi.passaro@phoenixsoftware.it>
Cc: Fabio Estevam <festevam@gmail.com>,
	linux-media <linux-media@vger.kernel.org>
Date: Fri, 12 Dec 2014 17:58:39 +0100
In-Reply-To: <548AB21B.8050402@phoenixsoftware.it>
References: <5488C10F.1040508@phoenixsoftware.it>
		 <CAOMZO5Deesoe61g_MzUKiUpXfjyJjVTBbogSd6bT9WA1GJ9P2Q@mail.gmail.com>
	 <1418306587.3188.13.camel@pengutronix.de>
	 <548AB21B.8050402@phoenixsoftware.it>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am Freitag, den 12.12.2014, 10:15 +0100 schrieb Pierluigi Passaro:
> On 11/12/2014 15:03, Philipp Zabel wrote:
> > Am Mittwoch, den 10.12.2014, 22:04 -0200 schrieb Fabio Estevam:
> >> On Wed, Dec 10, 2014 at 7:54 PM, Pierluigi Passaro
> >> <pierluigi.passaro@phoenixsoftware.it> wrote:
> >>> Hi all,
> >>> I'm trying to use VPU code driver on iMX51 with kernel 3.18, following these
> >>> steps:
> >>> - disabled DVI interface
> >>> - enabled LCD interface
> >>> - configured and enabled VPU
> >>> - copied iMX51 vpu firmware without header and renamed
> >>> v4l-coda7541-imx53.bin in /lib/firmware
> >>>
> >>> Attached you can find the patch and the defconfig I used.
> >>>
> >>> The boot process hangs after loading the firmware at the first attempt of
> >>> writing in VPU address space in the function coda_write of file
> >>> driver/media/platform/coda/coda-common.c
> >>>
> >>> Is there anything preventing the coda driver to work with iMX51?
> >>> Could anyone provide any suggestion on how investigate the problem?
> >> I have only tested the coda driver on mx6, but looking at the
> >> mx51.dtsi you would need this:
> >>
> >> --- a/arch/arm/boot/dts/imx51.dtsi
> >> +++ b/arch/arm/boot/dts/imx51.dtsi
> >> @@ -121,6 +121,7 @@
> >>           iram: iram@1ffe0000 {
> >>               compatible = "mmio-sram";
> >>               reg = <0x1ffe0000 0x20000>;
> >> +            clocks = <&clks IMX5_CLK_OCRAM>;
> >>           };
> >>
> >>           ipu: ipu@40000000 {
> >> @@ -584,6 +585,18 @@
> >>                   clock-names = "ipg", "ahb", "ptp";
> >>                   status = "disabled";
> >>               };
> >> +
> >> +            vpu: vpu@83ff4000 {
> >> +                compatible = "fsl,imx53-vpu";
> > This should be "fsl,imx51-vpu", and add a "cnm,codahx14".
> >
> > According to the old imx-vpu-lib code and the vpu_fw_imx51.bin firmware
> > file, the i.MX51 has a CodaHx14 (0xF00A) as opposed to the i.MX53's
> > Coda7541 (0xF012).
> >
> Thanks for the hint, I'm now going through the old imx-vpu-lib to 
> understand the CodaHX14 behaviour.
> In old imx-vpu-lib, file vpu_util.c, there is a comment that make me 
> doubtful: "i.MX51 has no secondary AXI memory, but use on chip RAM".
> As far as I understood, the portion of coda driver affected from this 
> comment should be around the function coda_setup_iram in coda-bit.c.
> How am I supposed to manage this information?
> Have I to avoid to use iram for iMX51 (and return on !dev->iram.vaddr) 
> or go through the function without managing any CodaHX14 specific behaviour?

I think for CodaHx14 on i.MX51 the CODA7_USE_HOST_xyz_ENABLE bits should
be set in coda_setup_iram, but the CODA7_USE_xyz_ENABLE should not.

regards
Philipp

