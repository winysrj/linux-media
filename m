Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from crow.cadsoft.de ([217.86.189.86] helo=raven.cadsoft.de)
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <Klaus.Schmidinger@cadsoft.de>) id 1L6nCx-0003Dh-8U
	for linux-dvb@linuxtv.org; Sun, 30 Nov 2008 15:23:36 +0100
Received: from [192.168.100.10] (hawk.cadsoft.de [192.168.100.10])
	by raven.cadsoft.de (8.14.3/8.14.3) with ESMTP id mAUENVOW019934
	for <linux-dvb@linuxtv.org>; Sun, 30 Nov 2008 15:23:31 +0100
Message-ID: <4932A1E2.5060606@cadsoft.de>
Date: Sun, 30 Nov 2008 15:23:30 +0100
From: Klaus Schmidinger <Klaus.Schmidinger@cadsoft.de>
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
Subject: [linux-dvb] Problem with TT-Budget-T-CI PCI firmware
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
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

I'm trying to use the latest s2API driver from http://linuxtv.org/hg/v4l-dvb
(7100e78482d7) with a TT-Budget-T-CI PCI card:

Nov 30 15:13:45 vdr2 kernel: DVB: registering new adapter (TT-Budget-T-CI PCI)
Nov 30 15:13:45 vdr2 kernel: adapter has MAC addr = 00:d0:5c:07:d7:39
Nov 30 15:13:45 vdr2 kernel: input: Budget-CI dvb ir receiver saa7146 (3) as /devices/pci0000:00/0000:00:1e.0/0000:01:05.0/input/input11
Nov 30 15:13:45 vdr2 kernel: DVB: registering adapter 3 frontend 0 (Philips TDA10046H DVB-T)...
Nov 30 15:13:45 vdr2 kernel: saa7130/34: v4l2 driver version 0.2.14 loaded

I ran

  linux/Documentation/dvb/get_dvb_firmware tda10045

to get the firmware file dvb-fe-tda10045.fw and copied it to
/lib/firmware. The driver then told me to rename that file to
dvb-fe-tda10046.fw, which I did. When starting the application
I get

Nov 30 15:14:00 vdr2 kernel: tda1004x: timeout waiting for DSP ready
Nov 30 15:14:00 vdr2 kernel: tda1004x: found firmware revision 0 -- invalid
Nov 30 15:14:00 vdr2 kernel: tda1004x: trying to boot from eeprom
Nov 30 15:14:02 vdr2 kernel: tda1004x: timeout waiting for DSP ready
Nov 30 15:14:02 vdr2 kernel: tda1004x: found firmware revision 0 -- invalid
Nov 30 15:14:02 vdr2 kernel: tda1004x: waiting for firmware upload...
Nov 30 15:14:05 vdr2 kernel: tda1004x: timeout waiting for DSP ready
Nov 30 15:14:05 vdr2 kernel: tda1004x: found firmware revision 0 -- invalid
Nov 30 15:14:05 vdr2 kernel: tda1004x: firmware upload failed

in the log file, which seems to indicate that the firmware file was
found, but isn't acceptable.

The file that got downloaded was tt_budget_217g.zip, and the dvb-fe-tda10045.fw
has a size of 30555 byte and an md5sum of 2105fd5bf37842fbcdfa4bfd58f3594a.

Am I doing something wrong here?

Klaus

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
