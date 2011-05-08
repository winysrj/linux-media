Return-path: <mchehab@gaivota>
Received: from smtp1.mtw.ru ([93.95.97.34]:43465 "EHLO smtp1.mtw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752119Ab1EHIXZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 8 May 2011 04:23:25 -0400
Date: Sun, 8 May 2011 12:23:21 +0400
From: Andrew Junev <a-j@a-j.ru>
Reply-To: Andrew Junev <a-j@a-j.ru>
Message-ID: <157285607.20110508122321@a-j.ru>
To: linux-media@vger.kernel.org
CC: Josu Lazkano <josu.lazkano@gmail.com>
Subject: Re: [linux-dvb] TeVii S470 (cx23885 / ds3000) makes the machine unstable
In-Reply-To: <BANLkTimGEL4YvXRJsFM10NfyHPOn-JsA_g@mail.gmail.com>
References: <1908281867.20110505213806@a-j.ru> <BANLkTimL7qhNpXr8xBBcU4MccZKAAFURYw@mail.gmail.com> <16110382789.20110506010009@a-j.ru> <BANLkTimGEL4YvXRJsFM10NfyHPOn-JsA_g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

Hi,

Friday, May 6, 2011, 1:58:22 AM, you wrote:

> I have 2.6.32-5-686 kernel and I have this output on dmesg:

> [   11.459771] cx23885 driver version 0.0.2 loaded
> [   11.460894] ACPI: PCI Interrupt Link [LN4A] enabled at IRQ 19
> [   11.460914] cx23885 0000:05:00.0: PCI INT A -> Link[LN4A] -> GSI 19
(level, low) ->> IRQ 19
> [   11.461093] CORE cx23885[0]: subsystem: d470:9022, board: TeVii
> S470 [card=15,autodetected]
> [   11.587592] cx23885_dvb_register() allocating 1 frontend(s)
> [   11.587600] cx23885[0]: cx23885 based dvb card
> [   11.718813] DS3000 chip version: 0.192 attached.
> [   11.718823] DVB: registering new adapter (cx23885[0])
> [   11.718831] DVB: registering adapter 7 frontend 0 (Montage
> Technology DS3000/TS2020)...
> [   11.719476] cx23885_dev_checkrevision() Hardware revision = 0xb0
> [   11.719490] cx23885[0]/0: found at 0000:05:00.0, rev: 2, irq: 19,
> latency: 0, mmio: 0xfea00000
> [   11.719502] cx23885 0000:05:00.0: setting latency timer to 64

> I complete the wiki page on linuxtv wiki, but I am not any expert and
> english is not my best. Be careful with kernel upgrade, i had lots of
> problem with 2.6.38 kernel.

> Tell me how goes your progress.

> Kind regards.


I installed the latest s2-liplianin drivers, but I still seem to have
the same issue. The card works fine for some time after reboot, then I
am starting to get the following errors in the system log:

May  8 11:11:38 localhost kernel: ds3000_readreg: reg=0xa1(error=-5)
May  8 11:11:38 localhost kernel: ds3000_readreg: reg=0xa1(error=-5)
May  8 11:11:38 localhost kernel: ds3000_readreg: reg=0xa1(error=-5)
May  8 11:11:38 localhost kernel: ds3000_writereg: writereg error(err == -5, reg == 0xa1, value == 0x7b)
May  8 11:11:38 localhost kernel: ds3000_readreg: reg=0xa2(error=-5)
May  8 11:11:38 localhost kernel: ds3000_writereg: writereg error(err == -5, reg == 0xa2, value == 0xbb)
May  8 11:11:39 localhost kernel: ds3000_readreg: reg=0xa2(error=-5)
May  8 11:11:39 localhost kernel: ds3000_writereg: writereg error(err == -5, reg == 0xa2, value == 0x3b)
May  8 11:11:39 localhost kernel: ds3000_writereg: writereg error(err == -5, reg == 0xa3, value == 0xe0)
May  8 11:11:39 localhost kernel: ds3000_writereg: writereg error(err == -5, reg == 0xa4, value == 0x10)
May  8 11:11:39 localhost kernel: ds3000_writereg: writereg error(err == -5, reg == 0xa5, value == 0x38)
May  8 11:11:39 localhost kernel: ds3000_writereg: writereg error(err == -5, reg == 0xa6, value == 0xf6)
May  8 11:11:39 localhost kernel: ds3000_readreg: reg=0xa1(error=-5)
May  8 11:11:39 localhost kernel: ds3000_writereg: writereg error(err == -5, reg == 0xa1, value == 0x1f)
May  8 11:11:39 localhost kernel: ds3000_readreg: reg=0xa1(error=-5)
May  8 11:11:39 localhost kernel: ds3000_writereg: writereg error(err == -5, reg == 0xa1, value == 0x1f)
May  8 11:11:39 localhost kernel: ds3000_readreg: reg=0xa1(error=-5)
May  8 11:11:39 localhost kernel: ds3000_readreg: reg=0xa1(error=-5)
May  8 11:11:39 localhost kernel: ds3000_readreg: reg=0xa1(error=-5)
May  8 11:11:39 localhost kernel: ds3000_readreg: reg=0xa1(error=-5)
May  8 11:11:39 localhost kernel: ds3000_readreg: reg=0xa1(error=-5)
May  8 11:11:39 localhost kernel: ds3000_readreg: reg=0xa1(error=-5)
May  8 11:11:39 localhost kernel: ds3000_readreg: reg=0xa1(error=-5)
May  8 11:11:39 localhost kernel: ds3000_readreg: reg=0xa1(error=-5)
May  8 11:11:39 localhost kernel: ds3000_readreg: reg=0xa1(error=-5)
May  8 11:11:39 localhost kernel: ds3000_readreg: reg=0xa1(error=-5)
May  8 11:11:39 localhost kernel: ds3000_readreg: reg=0xa1(error=-5)
May  8 11:11:39 localhost kernel: ds3000_readreg: reg=0xa1(error=-5)
May  8 11:11:39 localhost kernel: ds3000_readreg: reg=0xa1(error=-5)
May  8 11:11:39 localhost kernel: ds3000_readreg: reg=0xa1(error=-5)
May  8 11:11:39 localhost kernel: ds3000_readreg: reg=0xa1(error=-5)
May  8 11:11:39 localhost kernel: ds3000_readreg: reg=0xa1(error=-5)
May  8 11:11:39 localhost kernel: ds3000_writereg: writereg error(err == -5, reg == 0xa1, value == 0x7b)
May  8 11:11:39 localhost kernel: ds3000_readreg: reg=0xa2(error=-5)
May  8 11:11:39 localhost kernel: ds3000_writereg: writereg error(err == -5, reg == 0xa2, value == 0xbb)


And then my machine just stops responding - even on the ssh sessions.


A friend of mine installed the same S470 card a few days ago. He's
using Fedora 14 (kernel 2.6.35) and he says his machine started to
'hang' sporadically, too... I guess he might have a similar issue...

How could I track what is going on?

-- 
Best regards,
 Andrew             

