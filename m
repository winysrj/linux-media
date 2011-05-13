Return-path: <mchehab@gaivota>
Received: from casper.infradead.org ([85.118.1.10]:57998 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757100Ab1EMHUs (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 13 May 2011 03:20:48 -0400
Message-ID: <4DCCDBCE.3070208@infradead.org>
Date: Fri, 13 May 2011 09:20:46 +0200
From: Mauro Carvalho Chehab <mchehab@infradead.org>
MIME-Version: 1.0
To: Manoel PN <pinusdtv@hotmail.com>
CC: linux-media@vger.kernel.org, lgspn@hotmail.com
Subject: =?windows-1256?Q?Re=3A_=5BPATCH_3/4=5D_Modifications_to_?=
 =?windows-1256?Q?the_driver_mb86a20s=FE?=
References: <blu157-w124182C4A0D5D602B90768D8880@phx.gbl>
In-Reply-To: <blu157-w124182C4A0D5D602B90768D8880@phx.gbl>
Content-Type: text/plain; charset=windows-1256
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

Em 13-05-2011 04:11, Manoel PN escreveu:
> This patch implements some modifications in the function
> 
> This patch implements some modifications in the initialization function of the mb86a20s.
> 
> Explanation:
> 
> Several registers of mb86a20s can be programmed and to simplify this task and due to lack of technical literature to elaborate the necessary calculations was opted by the sending of values already ready for the registers, eliminating the process of calculations.

Please, don't assume that because you don't have the specs that the driver needs
to be changed. Other people might have the specs.

Also, on several cases, the datasheets describe a common init sequence that 
should be done in order to initialize the device, that is on several cases fixed.

So, on most cases, the better approach is to just put the init sequence into a
table. This also helps to easily fix the init sequence, if the vendor (or new
rev. engineering dumps) find that such default init sequence changed for whatever
reason (sometimes, vendors add some new init sequences on some errata, to fix some
hardware bug).


> The technique is quite simple: to each register that can be modified an identification (REGxxxx_IDCFG) was attributed and those that do not need modification was attributed REG_IDCFG_NONE.
> 
> The device that uses the demodulator mb86a20s simply informs the registers to be modified through the configuration parameter of the function frontend_attach.
> 
> Like in the example:
> 
> static struct mb86a20s_config_regs_val mb86a20s_config_regs[] = {
>     { REG2820_IDCFG, 0x33ddcd },
>     { REG50D5_IDCFG, 0x00 },    /* use output TS parallel */
>     { REG50D6_IDCFG, 0x17 }
> };
> 
> static struct mb86a20s_config mb86a20s_cfg = {
>     .demod_address = DEMOD_I2C_ADDR,
>     .config_regs_size = ARRAY_SIZE(mb86a20s_config_regs),
>     .config_regs = mb86a20s_config_regs,
> };
> 
> If there are no registers to be modified to do just this:
> 
> static struct mb86a20s_config mb86a20s_cfg = {
>     .demod_address = DEMOD_I2C_ADDR,
> };
> 
> static int tbs_dtb08_frontend_attach(struct dvb_usb_adapter *adap)
> {
>     adap->fe = dvb_attach(mb86a20s_attach, &mb86a20s_cfg, &adap->dev->i2c_adap);
>     if (adap->fe) {
>         frontend_tuner_attach(adap);
>     }
> }
> 
> 
> 
> Signed-off-by: Manoel Pinheiro <pinusdtv@hotmail.com>

In this specific case, I think you're adding a more complex logic without a good
reason for it. Keep the code simple.

NACK.


> regs_init.patch

Commenting attached patches is harder, as emails don't like to reply for it.
The better is to always send patches inlined.

Mauro,
