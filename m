Return-path: <linux-media-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.155]:34728 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750830AbZCYVZg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 25 Mar 2009 17:25:36 -0400
Received: by fg-out-1718.google.com with SMTP id e12so114564fga.17
        for <linux-media@vger.kernel.org>; Wed, 25 Mar 2009 14:25:33 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <ff07fffe0903241838j278bbc4agfc94a23f2ab018cb@mail.gmail.com>
References: <7b41dd970809290235x48f63938ic56318ba3064a71b@mail.gmail.com>
	 <c4d80f839f7e2e838b04f6c37c68d9c0@10.0.0.2>
	 <7b41dd970810091315h1433fa7du56e5754a1684019d@mail.gmail.com>
	 <1223598995.4825.12.camel@pc10.localdom.local>
	 <7b41dd970810121321m715f7a81nf2c6e07485603571@mail.gmail.com>
	 <loom.20090225T203249-735@post.gmane.org>
	 <1235712905.2748.29.camel@pc10.localdom.local>
	 <7b41dd970903241514g677c1071raf1010653fd6b7e8@mail.gmail.com>
	 <ff07fffe0903241838j278bbc4agfc94a23f2ab018cb@mail.gmail.com>
Date: Wed, 25 Mar 2009 22:25:33 +0100
Message-ID: <7b41dd970903251425h581afdc4re0de4b95e102c31c@mail.gmail.com>
Subject: Re: [linux-dvb] TechnoTrend C-1501 - Locking issues on 388Mhz
From: klaas de waal <klaas.de.waal@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Mar 25, 2009 at 2:38 AM, Christian Lyra <lyra@pop-pr.rnp.br> wrote:
> Hi
>>> > > Hi,
>>> > > Am Donnerstag, den 09.10.2008, 22:15 +0200 schrieb klaas de waal:
>>> > >  The table starts a new segment at 390MHz,
>>> > > > it then starts to use VCO2 instead of VCO1.
>>> > > > I have now (hack, hack) changed the segment start from 390 to 395MHz
>>> > > > so that the 388MHz is still tuned with VCO1, and this works OK!!
>>
>> TechnoTrend C-1501 DVB-C card does not lock on 388MHz.
>> I assume that existing frequency table is valid for DVB-T. This is suggested
>> by the name of the table: tda827xa_dvbt.
>> Added a table for DVB-C with the name tda827xa_dvbc.
>> Added runtime selection of the DVB-C table when the tuner is type FE_QAM.
>> This should leave the behaviour of this driver with with DVB_T tuners
>> unchanged.
>> This modification is in file tda827x.c
>
> I imagine if there´s something similar to my card, as it doesnt seem
> to use the same tuner. dmesg only says this:
>
> [    3.611107] Linux video capture interface: v2.00
> [    3.621431] saa7146: register extension 'budget_av'.
> [    3.621513] budget_av 0000:00:00.0: enabling device (0000 -> 0002)
> [    3.621757] saa7146: found saa7146 @ mem ffffc20000024000 (revision
> 1, irq 16) (0x1894,0x0022).
> [    3.621768] saa7146 (0): dma buffer size 192512
> [    3.621773] DVB: registering new adapter (KNC1 DVB-C MK3)
> [    3.655279] adapter failed MAC signature check
> [    3.655292] encoded MAC from EEPROM was
> ff:ff:ff:ff:ff:ff:ff:ff:ff:ff:ff:ff:ff:ff:ff:ff:ff:ff:ff:ff
> [    3.858310] budget_av: saa7113_init(): saa7113 not found on KNC card
> [    3.918489] KNC1-0: MAC addr = 00:09:d6:6d:9f:db
> [    4.112763] DVB: registering adapter 0 frontend 0 (Philips TDA10023 DVB-C)...
> [    4.112896] budget-av: ci interface initialised.
>
> What tunner this card use?
>
> --
> Christian Lyra
> PoP-PR/RNP
>
Hi Christian,

The TechnoTrend C-1501 card uses a "silicon tuner" and that is a
fairly new device of which the driver needed a bit of improvement.
The KNC1 DVB-C cards use a conventional "tin can" tuner, the CU1216.
See the http://linuxtv.org/wiki/index.php/DVB-C_PCI_Cards for details.
The SAA7113 that is mentioned in your log is a chip that digitizes
analog TV input..
The cards that are sold as "DVB-C Plus"  have an S-Video analog TV
input in addition to being a DVB-C tuner card, so I expect that the
Plus cards have a SAA7113 for this.
You have probably the standard card, without the S-Video input.
DVB-C reception should work OK, also with the standard Linux kernel driver.

Cheers,
Klaas
