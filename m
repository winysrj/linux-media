Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail.infomir.com.ua ([79.142.192.5] helo=infomir.com.ua)
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <vdp@teletec.com.ua>) id 1KYPpT-0002Tf-JW
	for linux-dvb@linuxtv.org; Wed, 27 Aug 2008 20:33:16 +0200
Received: from [10.128.0.10] (iptv.infomir.com.ua [79.142.192.146])
	by infomir.com.ua with ESMTP id 1KYPpP-0000GB-4x
	for linux-dvb@linuxtv.org; Wed, 27 Aug 2008 21:33:11 +0300
Message-ID: <48B59DEC.9030302@teletec.com.ua>
Date: Wed, 27 Aug 2008 21:33:16 +0300
From: Dmitry Podyachev <vdp@teletec.com.ua>
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
Subject: [linux-dvb] mantis and dvb_ca adapter 0: CAM tried to send a buffer
 larger than the link buffer size (16384 > 128)
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

with "open" channel situation little bit different:
./zap -adapter 0 -caslotnum 0 -channels /srv/mantis_c/sport.conf 
-secfile /srv/mantis_c/sec.cfg -secid c10750 'open_channel'
Using frontend "Fujitsu MB86A16 DVB-S", type DVB-S
status SCVYL | signal ff76 | snr ff12 | ber 00000000 | unc 00000001 | 
FE_HAS_LOCK
CAM Application type: 01
CAM Application manufacturer: 0500
CAM Manufacturer code: 0500
CAM Menu string: Viaccess
CAM supports the following ca system ids:
  0x0500
Received new PMT - sending to CAM...
en50221_stdcam_llci_poll: Error reported by stack:-2



dmesg:
kernel: mantis_hif_write_wait (0): Adater(0) Slot(0): Write operation 
timed out!
kernel: mantis_hif_write_iom (0): Adapter(0) Slot(0): HIF Smart Buffer 
operation failed
kernel: mantis_hif_write_wait (0): Adater(0) Slot(0): Write operation 
timed out!
kernel: mantis_hif_write_iom (0): Adapter(0) Slot(0): HIF Smart Buffer 
operation failed
kernel: dvb_ca adapter 0: CAM tried to send a buffer larger than the 
link buffer size (16384 > 128)!
kernel: mantis_hif_write_wait (0): Adater(0) Slot(0): Write operation 
timed out!
kernel: mantis_hif_write_iom (0): Adapter(0) Slot(0): HIF Smart Buffer 
operation failed
kernel: dvb_ca adapter 0: DVB CAM link initialisation failed :(
kernel: mantis stop feed and dma
kernel: vp1034_set_voltage (0): Frontend (dummy) POWERDOWN

and after unload/reload all dvb* modules  when modprobe mantis.ko it 
kernel panic.
If anybody has experience with dvb_ca - help please with advice
bb

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
