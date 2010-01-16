Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f227.google.com ([209.85.218.227]:48524 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750908Ab0APLzf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 16 Jan 2010 06:55:35 -0500
Received: by bwz27 with SMTP id 27so1176751bwz.21
        for <linux-media@vger.kernel.org>; Sat, 16 Jan 2010 03:55:34 -0800 (PST)
To: paul10@planar.id.au
Subject: Re: DM1105: could not attach frontend 195d:1105
Content-Disposition: inline
From: "Igor M. Liplianin" <liplianin@me.by>
Date: Sat, 16 Jan 2010 13:55:20 +0200
Cc: linux-media@vger.kernel.org
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201001161355.20874.liplianin@me.by>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 16 января 2010, paul10@planar.id.au wrote:
> Sorry for the many e-mails.
>
> I've looked through the code for si21xx.c.  I can't see any obvious reason
> it wouldn't be working.  si21xx_attach calls read_reg, and read_reg is not
> returning a value.  The datasheet for the chip
> (http://www.datasheetarchive.com/datasheet-pdf/016/DSA00286370.html) says
> those registers are correct.
>
> I'm assuming the problem would be the demod_address?  I modified the code
> in dm1105.c to try all options for demod_address between 0x01 and 0x100.
> None of them seemed to work.  The code looked like this:
>                 int demod = 0x01;
>                 while (demod < 0x100) {
>                     serit_config.demod_address = demod;
>                     dm1105dvb->fe = dvb_attach(
>                         si21xx_attach, &serit_config,
>                         &dm1105dvb->i2c_adap);
>                     if (dm1105dvb->fe) {
>                         dm1105dvb->fe->ops.set_voltage =
>                                                 dm1105dvb_set_voltage;
>                         break;
>                     }
>                     printk(KERN_ERR "Try: %x\n", demod);
>                     demod++;
>                 }
>
> The output from dmesg looks something like this (obviously much longer):
> [196838.768110] Try: fb
> [196838.768162] si21xx: si21xx_attach
> [196839.016208] si21xx: si21_readreg: readreg error (reg == 0x01, ret ==
> -1)
> [196839.264255] si21xx: si21_writereg: writereg error (reg == 0x01, data
> == 0x40, ret == -1)
> [196839.716056] si21xx: si21_readreg: readreg error (reg == 0x00, ret ==
> -1)
> [196839.716112] Try: fc
> [196839.716164] si21xx: si21xx_attach
> [196839.964211] si21xx: si21_readreg: readreg error (reg == 0x01, ret ==
> -1)
> [196840.212259] si21xx: si21_writereg: writereg error (reg == 0x01, data
> == 0x40, ret == -1)
> [196840.664056] si21xx: si21_readreg: readreg error (reg == 0x00, ret ==
> -1)
> [196840.664112] Try: fd
> [196840.664164] si21xx: si21xx_attach
> [196840.912211] si21xx: si21_readreg: readreg error (reg == 0x01, ret ==
> -1)
> [196841.160258] si21xx: si21_writereg: writereg error (reg == 0x01, data
> == 0x40, ret == -1)
> [196841.612053] si21xx: si21_readreg: readreg error (reg == 0x00, ret ==
> -1)
> [196841.612111] Try: fe
> [196841.612162] si21xx: si21xx_attach
> [196841.860209] si21xx: si21_readreg: readreg error (reg == 0x01, ret ==
> -1)
> [196842.108256] si21xx: si21_writereg: writereg error (reg == 0x01, data
> == 0x40, ret == -1)
> [196842.560055] si21xx: si21_readreg: readreg error (reg == 0x00, ret ==
> -1)
> [196842.560112] Try: ff
> [196842.560115] dm1105 0000:06:00.0: could not attach frontend
> [196842.560287] dm1105 0000:06:00.0: PCI INT A disabled
>
>
> I'm now out of ideas for what to do next.  In the mean-time, I noticed a
> couple of tidyups in the code for si21xx.c.  They are cosmetic only, patch
> is attached if you happened to be in that module for some other reason:
>
> diff si21xx.c.old si21xx.c
> 99a100,104
>
> > #define VERSION_SI2107                        0x34
> > #define VERSION_SI2108                        0x24
> > #define VERSION_SI2109                        0x14
> > #define VERSION_SI2110                        0x04
>
> 945c950
> <       id = si21_readreg(state, 0x00);
> ---
>
> >       id = si21_readreg(state, REVISION_REG);
>
> 947c952
> <       /* register 0x00 contains:
> ---
>
> >       /* register REVISION_REG contains:
>
> 953c958
> <       if (id != 0x04 && id != 0x14)
> ---
>
> >       if (id != VERSION_SI2110 && id != VERSION_SI2109)
>
> 954a960
>
> >                 /* only 2110 and 2109 are currently supported */
>
> Thanks again for your help,
>
> Paul

Accordingly datasheet possible demod addresses are 0x68, 0x69, 0x6a, 0x6b only.
Possibly there is some DM1105 GPIO drives reset for demod.
I assume it is last (26, top right if you look from card elements side) pin on tuner.
You can visually trace way from can tuner. Or use multimeter.

-- 
Igor M. Liplianin
Microsoft Windows Free Zone - Linux used for all Computing Tasks

