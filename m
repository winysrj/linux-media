Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wg0-f54.google.com ([74.125.82.54]:60333 "EHLO
	mail-wg0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752396AbaAZLVg (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 26 Jan 2014 06:21:36 -0500
Received: by mail-wg0-f54.google.com with SMTP id x13so4643614wgg.9
        for <linux-media@vger.kernel.org>; Sun, 26 Jan 2014 03:21:34 -0800 (PST)
Received: from [192.168.0.104] (host86-170-10-210.range86-170.btcentralplus.com. [86.170.10.210])
        by mx.google.com with ESMTPSA id ju6sm16607257wjc.1.2014.01.26.03.21.32
        for <linux-media@vger.kernel.org>
        (version=TLSv1 cipher=ECDHE-RSA-RC4-SHA bits=128/128);
        Sun, 26 Jan 2014 03:21:33 -0800 (PST)
Message-ID: <52E4EFBB.7070504@googlemail.com>
Date: Sun, 26 Jan 2014 11:21:31 +0000
From: Robert Longbottom <rongblor@googlemail.com>
MIME-Version: 1.0
To: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: Conexant PCI-8604PW 4 channel BNC Video capture card (bttv)
References: <7D00B0B1-8873-4CB2-903F-8B98749C75FF@googlemail.com> <20140121101950.GA13818@minime.bse> <52DECF44.1070609@googlemail.com> <52DEDFCB.6010802@googlemail.com> <20140122115334.GA14710@minime.bse> <52DFC300.8010508@googlemail.com> <20140122135036.GA14871@minime.bse> <52E00AD0.2020402@googlemail.com> <20140123132741.GA15756@minime.bse> <52E1273F.90207@googlemail.com> <20140125152339.GA18168@minime.bse>
In-Reply-To: <20140125152339.GA18168@minime.bse>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 25/01/14 15:23, Daniel Glöckner wrote:
> On Thu, Jan 23, 2014 at 02:29:19PM +0000, Robert Longbottom wrote:
>> Jan 23 14:24:48 quad kernel: [154562.493224] bits: FMTCHG* VSYNC
>> HSYNC OFLOW FBUS   NUML => 625
>> Jan 23 14:24:49 quad kernel: [154562.994015] bttv: 0: timeout:
>> drop=0 irq=1868/1868, risc=146da000, bits: VSYNC HSYNC OFLOW
>> Jan 23 14:24:49 quad kernel: [154563.496010] bttv: 0: timeout:
>> drop=0 irq=1868/1868, risc=146da000, bits: VSYNC HSYNC OFLOW
>> Jan 23 14:24:50 quad kernel: [154563.997020] bttv: 0: timeout:
>> drop=0 irq=1868/1868, risc=146da000, bits: VSYNC HSYNC OFLOW
>> Jan 23 14:24:50 quad kernel: [154564.498018] bttv: 0: timeout:
>> drop=0 irq=1868/1868, risc=146da000, bits: VSYNC HSYNC OFLOW
>> Jan 23 14:24:51 quad kernel: [154564.999023] bttv: 0: timeout:
>> drop=0 irq=1868/1868, risc=146da000, bits: VSYNC HSYNC OFLOW
>> Jan 23 14:24:51 quad kernel: [154565.500024] bttv: 0: timeout:
>> drop=0 irq=1868/1868, risc=146da000, bits: VSYNC HSYNC OFLOW
>> Jan 23 14:24:52 quad kernel: [154566.001014] bttv: 0: timeout:
>> drop=0 irq=1868/1868, risc=146da000, bits: VSYNC HSYNC OFLOW
>> Jan 23 14:24:52 quad kernel: [154566.502016] bttv: 0: timeout:
>> drop=0 irq=1868/1868, risc=146da000, bits: VSYNC HSYNC OFLOW
>
> The chip didn't lock to the input signal.
> What kind of input are you feeding into the card?

Ah, for most of the testing I've done during the week I haven't had 
anything plugged in.  Though (obviously) I have tried with some cameras 
plugged in.  I have 3 "bullet" cams and one mini security camera.  All 
just standard wired video outputs, PAL, colour.  They work fine on the 
IVC capture card I have.

I've rerun the test with irq_debug=1 and the /var/log/messages output is 
here: http://pastebin.com/AJSLBhtY  I don't think it looks any better 
(/different).

> Can you run the attached program while xawtv is running?
> It will dump most of the registers of the bt8xx video function.

Sure, output below.  It didn't print out anything until I ran it as root 
(failed on fd = open(path, O_RDWR|O_SYNC);).  The output remains pretty 
much the same over multiple runs except these two values:

0E8 FCAP flips between a few values
100 INT_STAT changes from 0A00000C to 0B00000C and back.

Full output with xawtv running, bttv module loaded with no params.

sudo ./dumpbt8xx /dev/video0

000 00000092 DSTATUS
004 00000053 IFORM
008 00000000 TDEC
00C 000000D2 E_CROP
010 000000FE E_VDELAY_LO
014 000000E0 E_VACTIVE_LO
018 00000078 E_HDELAY_LO
01C 00000080 E_HACTIVE_LO
020 00000002 E_HSCALE_HI
024 000000AC E_HSCALE_LO
028 00000000 BRIGHT
02C 00000022 E_CONTROL
030 000000D8 CONTRAST_LO
034 00000000 SAT_U_LO
038 000000B5 SAT_V_LO
03C 00000000 HUE
040 00000000 E_SCLOOP
044 000000CF WC_UP
048 00000006 OFORM
04C 00000020 E_VSCALE_HI
050 00000000 E_VSCALE_LO
054 00000001 TEST
058 00000000 ARESET
060 0000007F ADELAY
064 00000072 BDELAY
068 00000081 ADC
06C 00000000 E_VTC
078 0000007F WC_DOWN
080 0000007F TGLB
084 00000008 TGCTRL
08C 000000D2 O_CROP
090 000000FE O_VDELAY_LO
094 000000E0 O_VACTIVE_LO
098 00000078 O_HDELAY_LO
09C 00000080 O_HACTIVE_LO
0A0 00000002 O_HSCALE_HI
0A4 000000AC O_HSCALE_LO
0AC 00000022 O_CONTROL
0B0 00000000 VTOTAL_LO
0B4 00000000 VTOTAL_HI
0C0 00000000 O_SCLOOP
0CC 00000020 O_VSCALE_HI
0D0 00000000 O_VSCALE_LO
0D4 00000000 COLOR_FMT
0D8 00000010 COLOR_CTL
0DC 00000003 CAP_CTL
0E0 000000FF VBI_PACK_SIZE
0E4 00000001 VBI_PACK_DEL
0E8 00000011 FCAP
0EC 00000000 O_VTC
0F0 000000F9 PLL_F_LO
0F4 000000DC PLL_F_HI
0F8 0000008E PLL_XCI
0FC 00000000 DVSIF
100 0A00000C INT_STAT
104 000C0B13 INT_MASK
10C 0000C0AF GPIO_DMA_CTL
110 00000003 I2C
114 30B35000 RISC_STRT_ADD
118 00000000 GPIO_OUT_EN
11C 00000000 GPIO_REG_INP
120 30B35000 RISC_COUNT
200 000FFFFF GPIO_DATA

Thanks,
Rob.

