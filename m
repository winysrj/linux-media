Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from 60-241-246-14.static.tpgi.com.au ([60.241.246.14]
	helo=fw.iplatinum.com.au) by mail.linuxtv.org with esmtp (Exim 4.69)
	(envelope-from <andrew.congdon@iplatinum.com.au>) id 1MqHUJ-0005VI-2v
	for linux-dvb@linuxtv.org; Wed, 23 Sep 2009 04:21:48 +0200
Received: from egroups.iplatinum.com.au (fs.iplatinum.com.au [192.168.226.1])
	by fw.iplatinum.com.au (8.14.3/8.14.3) with ESMTP id n8N2LRQS029541
	for <linux-dvb@linuxtv.org>; Wed, 23 Sep 2009 12:21:27 +1000
From: "Andrew Congdon" <andrew.congdon@iplatinum.com.au>
To: linux-dvb@linuxtv.org
Date: Wed, 23 Sep 2009 12:21:27 +1000
Message-ID: <20090923.r7x.21495100@egroups.iplatinum.com.au>
MIME-Version: 1.0
Content-Disposition: inline
Subject: [linux-dvb] =?iso-8859-1?q?Help_Request=3A_DM1105_STV0299_DVB-S_P?=
	=?iso-8859-1?q?CI_-_Unable_to_tune?=
Reply-To: linux-media@vger.kernel.org
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/options/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

> Please see the following link for the images:
> http://www.flickr.com/photos/7690...@n04/sets/72157621703527801/

I'm also trying to get one of these working.
Similar symptoms, card seems to be recognised but unable to lock.
I'm using an existing DVB-S setup with myth using the loopthru from
the working card and same LNB settings.

I've tried recent v4l-dvb and s2-liplianin drivers.
When attempting to tune the system becomes unresponsive with the
driver taking over the cpu:

  PID USER      PR  NI  VIRT  RES  SHR S %CPU %MEM    TIME+  COMMAND

 8206 root      15  -5     0    0    0 R 84.6  0.0   0:59.62
kdvb-ad-0-fe-0


Sep 23 09:39:06 localhost kernel: dm1105 0000:01:06.0: PCI INT A -> Link[APC3]
-> GSI 18 (level, high) -> IRQ 18
Sep 23 09:39:06 localhost kernel: DVB: registering new adapter (dm1105)
Sep 23 09:39:06 localhost kernel: dm1105 0000:01:06.0: MAC 00:00:00:00:00:00

Sep 23 09:39:06 localhost kernel: DVB: registering adapter 0 frontend 0 (ST
STV0299 DVB-S)...
Sep 23 09:39:06 localhost kernel: input: DVB on-card IR receiver as
/devices/pci0000:00/0000:00:08.0/0000:01:06.0/input/input7


lspci -vv:

01:06.0 Ethernet controller: Device 195d:1105 (rev 10)
        Subsystem: Device 195d:1105
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
        Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 32 (4000ns min, 8000ns max), Cache Line Size: 32 bytes
        Interrupt: pin A routed to IRQ 18
        Region 0: I/O ports at 9000 [size=256]
        Kernel driver in use: dm1105
        Kernel modules: dm1105

thanks
--
Andrew


_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
