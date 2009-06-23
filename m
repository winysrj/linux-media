Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ew0-f210.google.com ([209.85.219.210]:53462 "EHLO
	mail-ew0-f210.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751037AbZFWP0J convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 23 Jun 2009 11:26:09 -0400
Received: by ewy6 with SMTP id 6so222870ewy.37
        for <linux-media@vger.kernel.org>; Tue, 23 Jun 2009 08:26:11 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4A409C29.7030506@deckpoint.ch>
References: <4A23D25F.9060700@deckpoint.ch>
	 <eaf6cbc30906012354n5bab2b41k58d717c80ca96936@mail.gmail.com>
	 <4A409C29.7030506@deckpoint.ch>
Date: Tue, 23 Jun 2009 18:26:09 +0300
Message-ID: <eaf6cbc30906230826h165a4072gd5881c7a834913c9@mail.gmail.com>
Subject: Re: CAM initialisation failing
From: Tomer Barletz <barletz@gmail.com>
To: Thomas Kernen <tkernen@deckpoint.ch>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Jun 23, 2009 at 12:11 PM, Thomas Kernen<tkernen@deckpoint.ch> wrote:
> Tomer Barletz wrote:
>>
>> On Mon, Jun 1, 2009 at 4:06 PM, Thomas Kernen <tkernen@deckpoint.ch>
>> wrote:
>>>
>>> Dear community,
>>>
>>> After finally getting my Mystique SaTiX DVB-S2 PCI card (clone of KNC1
>>> DVB
>>> Station S2), I'm now facing trouble with the CAM initialisation (KNC1 CA
>>> daughter card, PowerCam Pro CAM and Viaccess card)
>>>
>>> All of the hardware (DVB-S2 PCI card, sat card, CI, CAM) has been tested
>>> under Windows with any issues, hence I suspect this is a module related
>>> issue.
>>>
>>> To try and better understand the issue, I added some debug statements to
>>> the
>>> following modules:
>>> options dvb-core cam_debug=1 debug=1
>>> options budget-core debug=1
>>>
>>> And this is the output I'm getting:
>>>
>>> [    9.146782] DVB: registering new adapter (KNC1 DVB-S2)
>>> [    9.203364] adapter failed MAC signature check
>>> [    9.203366] encoded MAC from EEPROM was
>>> ff:ff:ff:ff:ff:ff:ff:ff:ff:ff:ff:ff:ff:ff:ff:ff:ff:ff:ff:ff
>>> [    9.410061] budget_av: saa7113_init(): saa7113 not found on KNC card
>>> [    9.510352] KNC1-1: MAC addr = 00:09:d6:65:2d:91
>>> [    9.642505] saa7146 (0) saa7146_i2c_writeout [irq]: timed out waiting
>>> for
>>> end of xfer
>>> [    9.764427] stb0899_attach: Attaching STB0899
>>> [    9.776853] tda8261_attach: Attaching TDA8261 8PSK/QPSK tuner
>>> [    9.776855] DVB: registering adapter 1 frontend 0 (STB0899
>>> Multistandard)...
>>> [    9.776888] dvb_ca_en50221_init
>>> [    9.777048] budget-av: ci interface initialised.
>>> [    9.777050] dvb_ca_en50221_thread
>>> <snip>
>>> [   14.770017] budget-av: cam inserted A
>>> [   14.770032] budget_av: ciintf_slot_reset(): ciintf_slot_reset
>>> [   14.950033] TUPLE type:0x1d length:4
>>> [   14.950041]   0x00: 0x00 .
>>> [   14.950048]   0x01: 0x61 a
>>> [   14.950055]   0x02: 0x00 .
>>> [   14.950063]   0x03: 0xff .
>>> [   14.950076] TUPLE type:0x1c length:4
>>> [   14.950083]   0x00: 0x00 .
>>> [   14.950091]   0x01: 0xd3 .
>>> [   14.950098]   0x02: 0x00 .
>>> [   14.950105]   0x03: 0xff .
>>> [   14.950118] TUPLE type:0x15 length:11
>>> [   14.950126]   0x00: 0x05 .
>>> [   14.950133]   0x01: 0x00 .
>>> [   14.950140]   0x02: 0x47 G
>>> [   14.950147]   0x03: 0x00 .
>>> [   14.950154]   0x04: 0x4d M
>>> [   14.950161]   0x05: 0x00 .
>>> [   14.950168]   0x06: 0x4c L
>>> [   14.950175]   0x07: 0x00 .
>>> [   14.950182]   0x08: 0x4c L
>>> [   14.950189]   0x09: 0x00 .
>>> [   14.950196]   0x0a: 0xff .
>>> [   14.950210] TUPLE type:0x20 length:4
>>> [   14.950217]   0x00: 0x02 .
>>> [   14.950224]   0x01: 0xca .
>>> [   14.950232]   0x02: 0x12 .
>>> [   14.950239]   0x03: 0x60 `
>>> [   14.950252] TUPLE type:0x1a length:21
>>> [   14.950260]   0x00: 0x01 .
>>> [   14.950267]   0x01: 0x0f .
>>> [   14.950274]   0x02: 0x00 .
>>> [   14.950281]   0x03: 0x02 .
>>> [   14.950288]   0x04: 0x03 .
>>> [   14.950295]   0x05: 0xc0 .
>>> [   14.950302]   0x06: 0x0e .
>>> [   14.950309]   0x07: 0x41 A
>>> [   14.950316]   0x08: 0x02 .
>>> [   14.950323]   0x09: 0x44 D
>>> [   14.950330]   0x0a: 0x56 V
>>> [   14.950337]   0x0b: 0x42 B
>>> [   14.950344]   0x0c: 0x5f _
>>> [   14.950352]   0x0d: 0x43 C
>>> [   14.950359]   0x0e: 0x49 I
>>> [   14.950366]   0x0f: 0x5f _
>>> [   14.950373]   0x10: 0x56 V
>>> [   14.950380]   0x11: 0x31 1
>>> [   14.950387]   0x12: 0x2e .
>>> [   14.950394]   0x13: 0x30 0
>>> [   14.950401]   0x14: 0x30 0
>>> [   14.950415] TUPLE type:0x1b length:42
>>> [   14.950422]   0x00: 0xcf .
>>> [   14.950429]   0x01: 0x04 .
>>> [   14.950436]   0x02: 0x09 .
>>> [   14.950443]   0x03: 0x7f .
>>> [   14.950450]   0x04: 0x55 U
>>> [   14.950458]   0x05: 0xcd .
>>> [   14.950465]   0x06: 0x19 .
>>> [   14.950472]   0x07: 0xd5 .
>>> [   14.950479]   0x08: 0x19 .
>>> [   14.950486]   0x09: 0x3d =
>>> [   14.950493]   0x0a: 0x9e .
>>> [   14.950500]   0x0b: 0x25 %
>>> [   14.950507]   0x0c: 0x26 &
>>> [   14.950514]   0x0d: 0x54 T
>>> [   14.950521]   0x0e: 0x22 "
>>> [   14.950528]   0x0f: 0xc0 .
>>> [   14.950535]   0x10: 0x09 .
>>> [   14.950542]   0x11: 0x44 D
>>> [   14.950549]   0x12: 0x56 V
>>> [   14.950557]   0x13: 0x42 B
>>> [   14.950564]   0x14: 0x5f _
>>> [   14.950571]   0x15: 0x48 H
>>> [   14.950578]   0x16: 0x4f O
>>> [   14.950585]   0x17: 0x53 S
>>> [   14.950592]   0x18: 0x54 T
>>> [   14.950599]   0x19: 0x00 .
>>> [   14.950606]   0x1a: 0xc1 .
>>> [   14.950613]   0x1b: 0x0e .
>>> [   14.950620]   0x1c: 0x44 D
>>> [   14.950627]   0x1d: 0x56 V
>>> [   14.950634]   0x1e: 0x42 B
>>> [   14.950642]   0x1f: 0x5f _
>>> [   14.950649]   0x20: 0x43 C
>>> [   14.950656]   0x21: 0x49 I
>>> [   14.950663]   0x22: 0x5f _
>>> [   14.950670]   0x23: 0x4d M
>>> [   14.950677]   0x24: 0x4f O
>>> [   14.950684]   0x25: 0x44 D
>>> [   14.950691]   0x26: 0x55 U
>>> [   14.950698]   0x27: 0x4c L
>>> [   14.950705]   0x28: 0x45 E
>>> [   14.950712]   0x29: 0x00 .
>>> [   14.950727] TUPLE type:0x14 length:0
>>> [   14.950734] END OF CHAIN TUPLE type:0xff
>>> [   14.950735] Valid DVB CAM detected MANID:ca02 DEVID:6012
>>> CONFIGBASE:0x200
>>> CONFIGOPTION:0xf
>>> [   14.950736] dvb_ca_en50221_set_configoption
>>> [   14.950750] Set configoption 0xf, read configoption 0xf
>>> [   14.950757] DVB CAM validated successfully
>>> <snip>
>>> [   15.050023] dvb_ca_en50221_link_init
>>> [   15.050030] dvb_ca_en50221_wait_if_status
>>> [   15.050037] dvb_ca_en50221_wait_if_status succeeded timeout:0
>>> [   15.050038] dvb_ca_en50221_read_data
>>> [   15.050084] dvb_ca adapter 1: DVB CAM link initialisation failed :(
>>>
>>> So if I understand correctly the CAM is ok but the en50221 module is
>>> times
>>> out when trying to read the card, is this correct?
>>>
>>> Any pointers/suggestions would be most welcomed.
>>> Thomas
>>>
>>>
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-media" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>>
>>
>> Hi Thomas,
>> This looks very similar to my problem.
>> See here:
>> http://www.mail-archive.com/linux-media@vger.kernel.org/msg05743.html
>>
>> Tomer
>
> Hi Tomer,
>
> Did you find any solution to this issue? I'm still struggling to find a way
> to provide better debug in an attempt for someone to find a solution.
>
> Thomas
>

Hi,
I indeed have found a way to solve this problem.
It seems that the link_init procedure is not fully compliant to the
standard, and some of the SCM/Viaccess modules are quite rigid, and
demand better adherence.
You need to read Annex A.2.2 of EN-50221, and add the appropriate
changes to the link initialisation code.
I will commit a patch with my changes, but it might take a while,
since I'm using an older kernel (2.6.10), so I have quite a bit of
integration work to make before I'll be able to add this, and other
changes.

Tomer
