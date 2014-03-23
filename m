Return-path: <linux-media-owner@vger.kernel.org>
Received: from defiant.no-carrier.info ([37.187.57.99]:33245 "EHLO
	mail.no-carrier.info" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751056AbaCWMZh (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 23 Mar 2014 08:25:37 -0400
Received: from localhost (localhost [127.0.0.1])
	by mail.no-carrier.info (Postfix) with ESMTP id 38F49200554
	for <linux-media@vger.kernel.org>; Sun, 23 Mar 2014 13:18:17 +0100 (CET)
Received: from mail.no-carrier.info ([127.0.0.1])
	by localhost (mail.no-carrier.info [127.0.0.1]) (amavisd-new, port 10024)
	with LMTP id VccqVGYwtI37 for <linux-media@vger.kernel.org>;
	Sun, 23 Mar 2014 13:18:06 +0100 (CET)
Received: from [192.168.1.129] (p549462AB.dip0.t-ipconnect.de [84.148.98.171])
	(Authenticated sender: mail@marc-stuermer.de)
	by mail.no-carrier.info (Postfix) with ESMTPA id 353F420037A
	for <linux-media@vger.kernel.org>; Sun, 23 Mar 2014 13:18:06 +0100 (CET)
Message-ID: <532ED0FA.9070509@marc-stuermer.de>
Date: Sun, 23 Mar 2014 13:18:02 +0100
From: =?ISO-8859-15?Q?Marc_St=FCrmer?= <mail@marc-stuermer.de>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: TeVii S471 on kernel 3.10.33 - endless waiting for firmware upload
 loop in ds3000
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Greetings,

recently I've bought a TeVii S471 dvb card, 'cause on the Linux TV Wiki 
says it is fully supported by the kernel since 3.5.X.

Drivers are all present (cx23885, ds3000, ts2020) and inserting them 
into the kernel works just like it should.

I've downloaded the firmware blob from the TeVii web site and copied it 
to /lib/firmware, too.

But loading up the firmware does not work at all, when I try to run a tv 
scan.

dmesg says:

[  634.381154] cx23885 driver version 0.0.3 loaded
[  634.381286] CORE cx23885[0]: subsystem: d471:9022, board: TeVii S471 
[card=35,autodetected]
[  634.509262] cx23885_dvb_register() allocating 1 frontend(s)
[  634.509264] cx23885[0]: cx23885 based dvb card
[  634.511206] DS3000 chip version: 0.192 attached.
[  634.516333] ts2020_attach: Find tuner TS2020!
[  634.516334] DVB: registering new adapter (cx23885[0])
[  634.516337] cx23885 0000:03:00.0: DVB: registering adapter 0 frontend 
0 (Montage Technology DS3000)...
[  634.516904] cx23885_dev_checkrevision() Hardware revision = 0xa5
[  634.516910] cx23885[0]/0: found at 0000:03:00.0, rev: 4, irq: 16, 
latency: 0, mmio: 0xf7200000
[  668.658653] ds3000_firmware_ondemand: Waiting for firmware upload 
(dvb-fe-ds3000.fw)...
[  668.658674] ds3000_firmware_ondemand: Waiting for firmware upload(2)...
[  669.591135] ds3000_firmware_ondemand: Waiting for firmware upload 
(dvb-fe-ds3000.fw)...
[  669.591149] ds3000_firmware_ondemand: Waiting for firmware upload(2)...

And so on and on, it is just stuck in kind of a loop, no success in 
loading the firmware at all. Ever.

I've tried a different variety from kernels, ranging from 3.8, 3.9 up to 
3.13 - always no luck at all.

I am unable to get that damn firmware blob uploaded to the tv card for 
good.

So I do need help; what else could I try to finally get that card up and 
running under Linux?

Google just gave me a whole variety of different solutions, but no one 
seemed to work so far.

Thanks in advance,
Marc
