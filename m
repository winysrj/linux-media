Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pz0-f188.google.com ([209.85.222.188]:59203 "EHLO
	mail-pz0-f188.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757938AbZKEU5h convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 5 Nov 2009 15:57:37 -0500
Received: by pzk26 with SMTP id 26so251511pzk.4
        for <linux-media@vger.kernel.org>; Thu, 05 Nov 2009 12:57:42 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <829197380911050602t30bc69d0sd0b269c39bf759e@mail.gmail.com>
References: <20764.64.213.30.2.1257390002.squirrel@webmail.exetel.com.au>
	 <829197380911042051l295e9796g65fe1b163f72a70c@mail.gmail.com>
	 <26256.64.213.30.2.1257398603.squirrel@webmail.exetel.com.au>
	 <829197380911050602t30bc69d0sd0b269c39bf759e@mail.gmail.com>
Date: Fri, 6 Nov 2009 07:57:42 +1100
Message-ID: <702870ef0911051257k52c142e8ne1b32506f1efb45c@mail.gmail.com>
Subject: Re: bisected regression in tuner-xc2028 on DVICO dual digital 4
From: Vincent McIntyre <vincent.mcintyre@gmail.com>
To: Devin Heitmueller <dheitmueller@kernellabs.com>
Cc: Robert Lowery <rglowery@exemail.com.au>,
	linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I have one of these too.

lsusb:
Bus 003 Device 003: ID 0fe9:db78 DVICO FusionHDTV DVB-T Dual Digital 4
(ZL10353+xc2028/xc3028) (initialized)
Bus 003 Device 002: ID 0fe9:db78 DVICO FusionHDTV DVB-T Dual Digital 4
(ZL10353+xc2028/xc3028) (initialized)

In addition I have a "DViCO Dual Digital Express" which is a PCIe card
based on Conexant, with the Zarlink frontend.
lspci:
04:00.0 Multimedia video controller [0400]: Conexant Systems, Inc.
CX23885 PCI Video and Audio Decoder [14f1:8852] (rev 02)
	Subsystem: DViCO Corporation Device [18ac:db78]
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 64 bytes
	Interrupt: pin A routed to IRQ 19
	Region 0: Memory at 90000000 (64-bit, non-prefetchable) [size=2M]
	Capabilities: <access denied>
	Kernel driver in use: cx23885
	Kernel modules: cx23885



More detail, including dmesg etc, at
https://bugs.launchpad.net/ubuntu/+source/linux/+bug/459523

On 11/6/09, Devin Heitmueller <dheitmueller@kernellabs.com> wrote:
> On Thu, Nov 5, 2009 at 12:23 AM, Robert Lowery <rglowery@exemail.com.au>
> wrote:
>> Hi Devin,
>>
>> Thanks for your reply.
>>
>> I don't think your suggestion to use disable_power_mgmt will work as I
>> already tried setting the no_poweroff=1 kernel module without success (and
>> even tried recompiling with xc2028_sleep returning 0 immediately, but
>> until I stopped the .sleep being set at all in xc2028_dvb_tuner_ops, the
>> problem kept happening.
>>
>> The only thing that fixed it without code change was to set
>> dvb_powerdown_on_sleep=0.
>>
>> Looking at the below code from dvb_frontend.c, the only difference I could
>> see between setting no_poweroff=1 and not setting .sleep is the latter
>> stops i2c_gate_ctrl being called.
>>
>>        if (dvb_powerdown_on_sleep) {
>>                if (fe->ops.set_voltage)
>>                        fe->ops.set_voltage(fe, SEC_VOLTAGE_OFF);
>>                if (fe->ops.tuner_ops.sleep) {
>>                        if (fe->ops.i2c_gate_ctrl)
>>                                fe->ops.i2c_gate_ctrl(fe, 1);
>>                        fe->ops.tuner_ops.sleep(fe);
>>                        if (fe->ops.i2c_gate_ctrl)
>>                                fe->ops.i2c_gate_ctrl(fe, 0);
>>                }
>>                if (fe->ops.sleep)
>>                        fe->ops.sleep(fe);
>>        }
>>
>> I'm not very familiar with this code.  Am I missing something?
>>
>> -Rob
>
> Could you please clarify exactly which card you have (PCI/USB ID)?
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
