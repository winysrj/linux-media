Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail.infomir.com.ua ([79.142.192.5] helo=infomir.com.ua)
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <vdp@teletec.com.ua>) id 1KYHMu-00060f-Mf
	for linux-dvb@linuxtv.org; Wed, 27 Aug 2008 11:31:13 +0200
Received: from [10.128.0.10] (iptv.infomir.com.ua [79.142.192.146])
	by infomir.com.ua with ESMTP id 1KYHMp-0008GD-WE
	for linux-dvb@linuxtv.org; Wed, 27 Aug 2008 12:31:08 +0300
Message-ID: <48B51EE1.1080507@teletec.com.ua>
Date: Wed, 27 Aug 2008 12:31:13 +0300
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

How to look which layer of CI available for mantis (VP-1034  Mantis Rev 
1 [1822:0014] )
modprobe stb0899
modprobe mantis

DVB: registering frontend 0 (Fujitsu MB86A16 
DVB-S).                                     ..
kernel: mantis_ca_init (0): Registering EN50221 device
kernel: mantis_ca_init (0): Registered EN50221 device
kernel: mantis_hif_init (0): Adapter(0) Initializing Mantis Host Interface
kernel: dvb_ca adapter 0: DVB CAM detected and initialised successfully

zap_ca and gnutv don't work properly with CAM:
/hg/dvb-apps/util/gnutv # ./gnutv -adapter 0 -caslotnum 0 -channels 
/srv/mantis_c/sport.conf -secfile /srv/mantis_c/sec.cfg -secid c10750 
-cammenu

en50221_stdcam_llci_poll: Error reported by stack:-2

en50221_stdcam_llci_poll: Error reported by stack:-3

and dmesg:
kernel: dvb_ca adapter 0: DVB CAM detected and initialised successfully
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
kernel: mantis_hif_write_wait (0): Adater(0) Slot(0): Write operation 
timed out!
kernel: mantis_hif_write_iom (0): Adapter(0) Slot(0): HIF Smart Buffer 
operation failed
kernel: dvb_ca adapter 0: DVB CAM link initialisation failed :(



_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
