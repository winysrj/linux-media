Return-path: <linux-media-owner@vger.kernel.org>
Received: from acorn.exetel.com.au ([220.233.0.21]:55987 "EHLO
	acorn.exetel.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752513AbZKEXp7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 5 Nov 2009 18:45:59 -0500
Message-ID: <25126.64.213.30.2.1257464759.squirrel@webmail.exetel.com.au>
In-Reply-To: <829197380911051304g1544e277s870f869be14e1a18@mail.gmail.com>
References: <20764.64.213.30.2.1257390002.squirrel@webmail.exetel.com.au>
    <829197380911042051l295e9796g65fe1b163f72a70c@mail.gmail.com>
    <26256.64.213.30.2.1257398603.squirrel@webmail.exetel.com.au>
    <829197380911050602t30bc69d0sd0b269c39bf759e@mail.gmail.com>
    <702870ef0911051257k52c142e8ne1b32506f1efb45c@mail.gmail.com>
    <829197380911051304g1544e277s870f869be14e1a18@mail.gmail.com>
Date: Fri, 6 Nov 2009 10:45:59 +1100 (EST)
Subject: Re: bisected regression in tuner-xc2028 on DVICO dual digital 4
From: "Robert Lowery" <rglowery@exemail.com.au>
To: "Devin Heitmueller" <dheitmueller@kernellabs.com>
Cc: "Vincent McIntyre" <vincent.mcintyre@gmail.com>,
	linux-media@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

> On Thu, Nov 5, 2009 at 3:57 PM, Vincent McIntyre
> <vincent.mcintyre@gmail.com> wrote:
>> I have one of these too.
>>
>> lsusb:
>> Bus 003 Device 003: ID 0fe9:db78 DVICO FusionHDTV DVB-T Dual Digital 4
>> (ZL10353+xc2028/xc3028) (initialized)
>> Bus 003 Device 002: ID 0fe9:db78 DVICO FusionHDTV DVB-T Dual Digital 4
>> (ZL10353+xc2028/xc3028) (initialized)
>>
>> In addition I have a "DViCO Dual Digital Express" which is a PCIe card
>> based on Conexant, with the Zarlink frontend.
>> lspci:
>> 04:00.0 Multimedia video controller [0400]: Conexant Systems, Inc.
>> CX23885 PCI Video and Audio Decoder [14f1:8852] (rev 02)
>>        Subsystem: DViCO Corporation Device [18ac:db78]
>>        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
>> ParErr-
>> Stepping- SERR- FastB2B- DisINTx-
>>        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
>> <TAbort- <MAbort- >SERR- <PERR- INTx-
>>        Latency: 0, Cache Line Size: 64 bytes
>>        Interrupt: pin A routed to IRQ 19
>>        Region 0: Memory at 90000000 (64-bit, non-prefetchable) [size=2M]
>>        Capabilities: <access denied>
>>        Kernel driver in use: cx23885
>>        Kernel modules: cx23885
>
> Crap.  This is the price I pay for not having noticed Robert included
> a launchpad ticket with the dmesg output.
>
> Yeah, it's a zl10353, so I know what the problem is.  Let me look at
> the code and send you a patch for testing.  If you don't hear back
> from me within 24 hours, ping me again.

Do you mean something like this (untested) patch?  I'll try it out tonight.

diff -r 43878f8dbfb0 linux/drivers/media/dvb/dvb-usb/cxusb.c
--- a/linux/drivers/media/dvb/dvb-usb/cxusb.c   Sun Nov 01 07:17:46 2009
-0200
+++ b/linux/drivers/media/dvb/dvb-usb/cxusb.c   Fri Nov 06 10:39:38 2009
+1100
@@ -666,6 +666,14 @@
        .parallel_ts = 1,
 };

+static struct zl10353_config cxusb_zl10353_xc3028_config_no_i2c_gate = {
+       .demod_address = 0x0f,
+       .if2 = 45600,
+       .no_tuner = 1,
+       .parallel_ts = 1,
+       .disable_i2c_gate_ctrl = 1,
+};
+
 static struct mt352_config cxusb_mt352_xc3028_config = {
        .demod_address = 0x0f,
        .if2 = 4560,
@@ -897,7 +905,7 @@
        cxusb_bluebird_gpio_pulse(adap->dev, 0x02, 1);

        if ((adap->fe = dvb_attach(zl10353_attach,
-                                  &cxusb_zl10353_xc3028_config,
+                                  &cxusb_zl10353_xc3028_config_no_i2c_gate,
                                   &adap->dev->i2c_adap)) == NULL)
                return -EIO;

>
> Cheers,
>
> Devin
>
> --
> Devin J. Heitmueller - Kernel Labs
> http://www.kernellabs.com
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>


