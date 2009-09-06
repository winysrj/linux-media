Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f217.google.com ([209.85.220.217]:48959 "EHLO
	mail-fx0-f217.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752123AbZIFUwh (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 6 Sep 2009 16:52:37 -0400
Received: by fxm17 with SMTP id 17so1654385fxm.37
        for <linux-media@vger.kernel.org>; Sun, 06 Sep 2009 13:52:39 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4A956124.5070902@upcore.net>
References: <4A953E52.4020300@upcore.net> <4A956124.5070902@upcore.net>
Date: Sun, 6 Sep 2009 22:52:38 +0200
Message-ID: <bcb3ef430909061352v202d5b6fy3c668b64966a2848@mail.gmail.com>
Subject: Re: Azurewave AD-CP400 (Twinhan VP-2040 DVB-C)
From: MartinG <gronslet@gmail.com>
To: Magnus Nilsson <magnus@upcore.net>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Aug 26, 2009 at 6:21 PM, Magnus Nilsson<magnus@upcore.net> wrote:
> Nevermind this for the time being...all is pointing to open-sasc-ng being
> the culprit here...

Just to add a datapoint - I have the same problem: I can't seem to
successfully scan for channels. I've taken open-sasc-ng out of the
equation by simply not loading the loopback device and scan directly
on the true frontend.
These are my bits:
Terratec Cinergy C HD PCI
kernel 2.6.29.6-217.2.16.fc11.x86_64
s2-liplianin from http://mercurial.intuxication.org/hg/s2-liplianin
Currently:
changeset:   12465:096aa4559b71
tag:         tip
user:        Igor M. Liplianin <liplianin@me.by>
date:        Sat Sep 05 20:26:33 2009 +0300

dmesg when "modprobe mantis"
Sep  6 22:33:52 localhost kernel: Mantis 0000:04:00.0: PCI INT A ->
GSI 16 (level, low) -> IRQ 16
Sep  6 22:33:52 localhost kernel: irq: 16, latency: 64
Sep  6 22:33:52 localhost kernel: memory: 0xfdfff000, mmio: 0xffffc20023906000
Sep  6 22:33:52 localhost kernel: found a VP-2040 PCI DVB-C device on (04:00.0),
Sep  6 22:33:52 localhost kernel:    Mantis Rev 1 [153b:1178], irq:
16, latency: 64
Sep  6 22:33:52 localhost kernel:    memory: 0xfdfff000, mmio:
0xffffc20023906000
Sep  6 22:33:52 localhost kernel:    MAC Address=[00:08:ca:1d:bd:a6]
Sep  6 22:33:52 localhost kernel: mantis_alloc_buffers (0):
DMA=0xcc0d0000 cpu=0xffff8800cc0d0000 size=65536
Sep  6 22:33:52 localhost kernel: mantis_alloc_buffers (0):
RISC=0xa85ce000 cpu=0xffff8800a85ce000 size=1000
Sep  6 22:33:52 localhost kernel: DVB: registering new adapter (Mantis
dvb adapter)
Sep  6 22:33:52 localhost kernel: mantis_frontend_init (0): Probing
for CU1216 (DVB-C)
Sep  6 22:33:52 localhost kernel: TDA10023: i2c-addr = 0x0c, id = 0x7d
Sep  6 22:33:52 localhost kernel: mantis_frontend_init (0): found
Philips CU1216 DVB-C frontend (TDA10023) @ 0x0c
Sep  6 22:33:52 localhost kernel: mantis_frontend_init (0): Mantis
DVB-C Philips CU1216 frontend attach success
Sep  6 22:33:52 localhost kernel: DVB: registering adapter 0 frontend
0 (Philips TDA10023 DVB-C)...
Sep  6 22:33:52 localhost kernel: mantis_ca_init (0): Registering EN50221 device
Sep  6 22:33:52 localhost kernel: mantis_ca_init (0): Registered EN50221 device
Sep  6 22:33:52 localhost kernel: mantis_hif_init (0): Adapter(0)
Initializing Mantis Host Interface
Sep  6 22:33:52 localhost kernel: input: Mantis VP-2040 IR Receiver as
/devices/virtual/input/input11
Sep  6 22:33:53 localhost kernel: Mantis VP-2040 IR Receiver: unknown
key: key=0x00 raw=0x00 down=1
Sep  6 22:33:53 localhost kernel: Mantis VP-2040 IR Receiver: unknown
key: key=0x00 raw=0x00 down=0

lspci -v
04:00.0 Multimedia controller: Twinhan Technology Co. Ltd Mantis DTV
PCI Bridge Controller [Ver 1.0] (rev 01)
        Subsystem: TERRATEC Electronic GmbH Device 1178
        Flags: bus master, medium devsel, latency 64, IRQ 16
        Memory at fdfff000 (32-bit, prefetchable) [size=4K]
        Kernel driver in use: Mantis
        Kernel modules: mantis

I have also tried the mantis module from v4l-dvb without success. The
card is then recognized as TDA10021 instead of TDA10023, just as you
describe.

Typically, I have to do "modprobe -r mantis;modprobe mantis" right
before I try to scan (with w_scan, scandvb og mythtv) in order to get
any channels at all. But the joy doesn't last for long, and I get
stuff like
kernel: mantis_ack_wait (0): Slave RACK Fail !
in /var/log/messages.

I guess the problems mentioned in the following post are related:
 Subject: Terratec Cinergy C HD tuning problems
 Date: 2009-08-19 21:10:56 GMT

Hope we can find a solution to this!

best,
MartinG
