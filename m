Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:44204 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754110Ab0GMSlf (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 13 Jul 2010 14:41:35 -0400
Received: by bwz1 with SMTP id 1so465267bwz.19
        for <linux-media@vger.kernel.org>; Tue, 13 Jul 2010 11:41:29 -0700 (PDT)
Message-ID: <4C3CB355.7070904@gmail.com>
Date: Tue, 13 Jul 2010 20:41:25 +0200
From: Hamza Ferrag <hferraggreat@gmail.com>
Reply-To: hferraggreat@gmail.com
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: TeVii S470 Tunning Issue (Kernel 2.6.27-21)
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

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

