Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail.tu-berlin.de ([130.149.7.33])
	by www.linuxtv.org with esmtp (Exim 4.69)
	(envelope-from <hferraggreat@gmail.com>) id 1OYkDr-0004mQ-5o
	for linux-dvb@linuxtv.org; Tue, 13 Jul 2010 20:28:52 +0200
Received: from mail-bw0-f54.google.com ([209.85.214.54])
	by mail.tu-berlin.de (exim-4.69/mailfrontend-a) with esmtp
	for <linux-dvb@linuxtv.org>
	id 1OYkDq-0004AA-AN; Tue, 13 Jul 2010 20:28:50 +0200
Received: by bwz12 with SMTP id 12so4213763bwz.41
	for <linux-dvb@linuxtv.org>; Tue, 13 Jul 2010 11:28:48 -0700 (PDT)
Message-ID: <4C3CB05E.3080002@gmail.com>
Date: Tue, 13 Jul 2010 20:28:46 +0200
From: Hamza Ferrag <hferraggreat@gmail.com>
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
Subject: [linux-dvb] TeVii S470 Tunning Issue (Kernel 2.6.27-21)
Reply-To: linux-media@vger.kernel.org, hferraggreat@gmail.com
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/options/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

Hi all,

I am trying to install a 'Tevii S470' card  from TeVii technology as 
described  here http://linuxtv.org/wiki/index.php/TeVii_S470.

My configuration is :

- intel x86 platform
- Kernel 2.6.27-21
- tevii_ds3000.tar.gz (firmware archive from 
http://tevii.com/tevii_ds3000.tar.gz ),
- s2-liplianin  mercurial sources ( from 
http://mercurial.intuxication.org/hg/s2-liplianin)last changes at 
05/29/2010,

All work fine i.e drivers/firmware installation after madprobe a right 
modules.

# lsmod
Module                  Size  Used by    Not tainted
cx23885                82416  0
tveeprom                9348  1 cx23885
btcx_risc               1928  1 cx23885
cx2341x                 7748  1 cx23885
ir_common              23936  1 cx23885
videobuf_dma_sg         5060  1 cx23885
ir_core                 3596  2 cx23885,ir_common
v4l2_common             8896  2 cx23885,cx2341x
videodev               25376  2 cx23885,v4l2_common
videobuf_dvb            2820  1 cx23885
videobuf_core           8388  3 cx23885,videobuf_dma_sg,videobuf_dvb
lnbp21                  1024  0
dvb_core               54832  2 cx23885,videobuf_dvb
ds3000                  9668  1


# dmesg
Linux video capture interface: v2.00
cx23885 driver version 0.0.2 loaded
CORE cx23885[0]: subsystem: d470:9022, board: TeVii S470 
[card=15,autodetected]
cx23885_dvb_register() allocating 1 frontend(s)
cx23885[0]: cx23885 based dvb card
DS3000 chip version: 0.192 attached.
DVB: registering new adapter (cx23885[0])
DVB: registering adapter 0 frontend 0 (Montage Technology DS3000/TS2020)...
cx23885_dev_checkrevision() Hardware revision = 0xb0
cx23885[0]/0: found at 0000:03:00.0, rev: 2, irq: 11, latency: 0, mmio: 
0xdf800000
cx23885 0000:03:00.0: setting latency timer to 64
tun: Universal TUN/TAP device driver, 1.6



A problem appear when tunning card using szap-s2 :

# szap-s2 szap-s2 -c /root/channels.conf -x -M 5 -C 89 -l 9750 -S 1 MyCh

reading channels from file '/root/channels.conf'
zapping to 1 'MyCh':
delivery DVB-S2, modulation 8PSK
sat 0, frequency 8420 MHz V, symbolrate 29400000, coderate 8/9,rolloff 0.35
vpid 0x0286, apid 0x1fff, sid 0x0000
using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'
ds3000_firmware_ondemand: Waiting for firmware upload (dvb-fe-ds3000.fw)...
firmware: requesting dvb-fe-ds3000.fw
ds3000_firmware_ondemand: Waiting for firmware upload(2)...
ds3000_firmware_ondemand: No firmware uploaded (timeout or file not found?)
ds3000_tune: Unable initialise the firmware

Apparently it can't locate a firmware file,  yet :

# ls -l  /lib/firmware/
-rwxr-xr-x    1 root     root         8192 May  3 07:09 dvb-fe-ds3000.fw


Any ideas why this happens?

Thanks and best regards,

Hamza Ferrag


_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
