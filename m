Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx1.redhat.com (mx1.redhat.com [172.16.48.31])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n177KAU8028184
	for <video4linux-list@redhat.com>; Sat, 7 Feb 2009 02:20:10 -0500
Received: from web31601.mail.mud.yahoo.com (web31601.mail.mud.yahoo.com
	[68.142.198.147])
	by mx1.redhat.com (8.13.8/8.13.8) with SMTP id n177JqGp026655
	for <video4linux-list@redhat.com>; Sat, 7 Feb 2009 02:19:52 -0500
Message-ID: <509279.77236.qm@web31601.mail.mud.yahoo.com>
Date: Fri, 6 Feb 2009 23:19:51 -0800 (PST)
From: Jon Burford <jj_burford@yahoo.com>
To: video4linux-list@redhat.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Subject: HVR-950Q status
Reply-To: jj_burford@yahoo.com
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>


Howdy.

I recently (foolishly?) purchased a Haupaugge HVR-950Q USB dongle.  I am running Ubuntu 8.10 and after noticing it needed firmware, I downloaded it from  http://steventoth.net/linux/xc5000/HVR-12x0-14x0-17x0_1_25_25271_WHQL.zip.  I gleefully saw the following in /var/log/messages:


Feb  5 22:03:10 prospector kernel: [   11.771891] au0828 driver loaded
Feb  5 22:03:10 prospector kernel: [   12.128977] au0828: i2c bus registered
Feb  5 22:03:10 prospector kernel: [   12.227876] tveeprom 0-0050: Hauppauge model 72001, rev B3F0, serial# 5299599
Feb  5 22:03:10 prospector kernel: [   12.227880] tveeprom 0-0050: MAC address is 00-0D-FE-50-DD-8F
Feb  5 22:03:10 prospector kernel: [   12.227883] tveeprom 0-0050: tuner model is Xceive XC5000 (idx 150, type 4)
Feb  5 22:03:10 prospector kernel: [   12.227886] tveeprom 0-0050: TV standards NTSC(M) ATSC/DVB Digital (eeprom 0x88)
Feb  5 22:03:10 prospector kernel: [   12.227889] tveeprom 0-0050: audio processor is AU8522 (idx 44)
Feb  5 22:03:10 prospector kernel: [   12.227891] tveeprom 0-0050: decoder processor is AU8522 (idx 42)
Feb  5 22:03:10 prospector kernel: [   12.227893] tveeprom 0-0050: has no radio, has IR receiver, has no IR transmitter
Feb  5 22:03:10 prospector kernel: [   12.227895] hauppauge_eeprom: hauppauge eeprom: model=72001
Feb  5 22:03:10 prospector kernel: [   12.500444] HDA Intel 0000:00:1b.0: PCI INT A -> GSI 22 (level, low) -> IRQ 22
Feb  5 22:03:10 prospector kernel: [   12.534166] hda_codec: Unknown model for ALC883, trying auto-probe from BIOS...
Feb  5 22:03:10 prospector kernel: [   12.567486] HDA Intel 0000:04:00.1: PCI INT B -> GSI 17 (level, low) -> IRQ 17
Feb  5 22:03:10 prospector kernel: [   12.583762] xc5000: Successfully identified at address 0x61
Feb  5 22:03:10 prospector kernel: [   12.583765] xc5000: Firmware has not been loaded previously
Feb  5 22:03:10 prospector kernel: [   12.583767] DVB: registering new adapter (au0828)
Feb  5 22:03:10 prospector kernel: [   12.583770] DVB: registering frontend 0 (Auvitek AU8522 QAM/8VSB Frontend)...
Feb  5 22:03:10 prospector kernel: [   12.583982] Registered device AU0828 [Hauppauge HVR950Q]
Feb  5 22:03:10 prospector kernel: [   12.592279] usbcore: registered new interface driver au0828
Feb  5 22:03:10 prospector kernel: [   12.592363] usbcore: registered new interface driver snd-usb-audio
....
Feb  5 22:03:19 prospector kernel: [   28.851400] xc5000: waiting for firmware upload (dvb-fe-xc5000-1.1.fw)...
Feb  5 22:03:19 prospector kernel: [   28.851405] firmware: requesting dvb-fe-xc5000-1.1.fw
Feb  5 22:03:19 prospector kernel: [   28.895429] xc5000: firmware read 12332 bytes.
Feb  5 22:03:19 prospector kernel: [   28.895432] xc5000: firmware upload


I look in /dev/dvb and I see goodies:

jj@prospector:~$ ls -l /dev/dvb/adapter0/
total 0
crw-rw----+ 1 root video 212, 4 2009-02-05 22:03 demux0
crw-rw----+ 1 root video 212, 5 2009-02-05 22:03 dvr0
crw-rw----+ 1 root video 212, 3 2009-02-05 22:03 frontend0
crw-rw----+ 1 root video 212, 7 2009-02-05 22:03 net0


This is where the fun ended.  I banged my head on VLC, MythTV, me-tv, tvtime, vdr and others to no avail.  A little digging in the lists seemed to suggest I might be able to bring in over the air stations.  But my hope is to bring in analog NTSC cable channels and (gasp), possibly even Clear QAM HD channels.  Is there any hope or current effort to get analog NTSC working on this dongle?  Also, are there any USB dongles which support HD Clear QAM?  While I am primarily interested in analog NTSC (yeah, I hear ya, shoulda bought an HVR-950), getting analog and Clear QAM HD would be great.  While I would love to get my HVR-950Q working, I would settle for another well supported USB dongle with at least analog cable support that in known to work well with MythTV.

Thanks in advance for any feedback you can provide.

Regards,
Jon

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
