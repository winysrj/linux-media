Return-path: <linux-media-owner@vger.kernel.org>
Received: from fmmailgate01.web.de ([217.72.192.221]:53937 "EHLO
	fmmailgate01.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753877AbZFDMbu (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 4 Jun 2009 08:31:50 -0400
Received: from smtp08.web.de (fmsmtp08.dlan.cinetic.de [172.20.5.216])
	by fmmailgate01.web.de (Postfix) with ESMTP id A2DE6104733C7
	for <linux-media@vger.kernel.org>; Thu,  4 Jun 2009 14:31:51 +0200 (CEST)
Received: from [77.1.226.116] (helo=tobi-desktop.localnet)
	by smtp08.web.de with esmtp (WEB.DE 4.110 #277)
	id 1MCC6o-0005Ob-00
	for linux-media@vger.kernel.org; Thu, 04 Jun 2009 14:31:51 +0200
From: Tobias Kaminsky <tobiaskaminsky@web.de>
To: linux-media@vger.kernel.org
Subject: Re: Two WinTV1110 in one PC not working, single works
Date: Thu, 4 Jun 2009 14:31:15 +0200
References: <200906021557.27614.tobiaskaminsky@web.de> <200906021632.43653.tobiaskaminsky@web.de>
In-Reply-To: <200906021632.43653.tobiaskaminsky@web.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200906041431.15681.tobiaskaminsky@web.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello, 

this is what I figured out.
If I am using the newest v4l-hg:
1) make install --> coldboot -->  both card works --> coldboot --> just one 
card works
2) make install --> init 0 (not powering completly off) --> just one card works
3) make install --> init 6 --> both card works


Please let me know what informations do you need!

Thank you!

Tobias Kaminsky


On Tuesday 02 June 2009 16:32:43 Tobias Kaminsky wrote:
> With a new firmware:
> -rw-r--r-- 1 root 24479 2009-06-02 16:09 /lib/firmware/dvb-fe-tda10046.fw
> -rw-r--r-- 1 root 24478 2009-06-02 16:09 /lib/firmware/dvb-fe-tda10046.fw-
> backup-02-06-09
>
> I get FE_HAS_LOCK on both cards, but
>
> root@finswimmer-desktop:/lib/firmware# tzap -a 1
> "ProSieben(ProSiebenSat.1)" using '/dev/dvb/adapter1/frontend0' and
> '/dev/dvb/adapter1/demux0' tuning to 738000000 Hz
> video pid 0x0131, audio pid 0x0132
> status 00 | signal 0000 | snr f6f6 | ber 0001fffe | unc 00000000 |
> status 1f | signal 0000 | snr f6f6 | ber 0001fffe | unc 00000000 |
> FE_HAS_LOCK status 1f | signal 0000 | snr f6f6 | ber 0001fffe | unc
> 00000000 | FE_HAS_LOCK status 1f | signal 0000 | snr f6f6 | ber 0001fffe |
> unc 00000000 | FE_HAS_LOCK status 1f | signal 0000 | snr f6f6 | ber
> 0001fffe | unc 00000000 | FE_HAS_LOCK
>
> "ber" is always the same. Therefore there are no datas in dvr0.
>
>
> Jun  2 16:11:30 finswimmer-desktop root: card0
>
> Jun  2 16:11:33 finswimmer-desktop kernel: [ 6540.080006] tda1004x: setting
> up plls for 48MHz sampling clock
> Jun  2 16:11:33 finswimmer-desktop kernel: [ 6540.364007] tda1004x: found
> firmware revision 20 -- ok
>
>
>
> Jun  2 16:11:46 finswimmer-desktop root: card1
>
> Jun  2 16:11:49 finswimmer-desktop kernel: [ 6556.044007] tda1004x: setting
> up plls for 48MHz sampling clock
> Jun  2 16:11:49 finswimmer-desktop kernel: [ 6556.712007] tda1004x: found
> firmware revision 0 -- invalid
> Jun  2 16:11:49 finswimmer-desktop kernel: [ 6556.712015] tda1004x: trying
> to boot from eeprom
> Jun  2 16:11:52 finswimmer-desktop kernel: [ 6559.080007] tda1004x: found
> firmware revision 0 -- invalid
> Jun  2 16:11:52 finswimmer-desktop kernel: [ 6559.080013] tda1004x: waiting
> for firmware upload...
> Jun  2 16:11:52 finswimmer-desktop kernel: [ 6559.080017] firmware:
> requesting dvb-fe-tda10046.fw
> Jun  2 16:12:06 finswimmer-desktop kernel: [ 6573.524007] tda1004x: found
> firmware revision ed -- invalid
> Jun  2 16:12:06 finswimmer-desktop kernel: [ 6573.524013] tda1004x:
> firmware upload failed
> Jun  2 16:12:27 finswimmer-desktop kernel: [ 6594.332007] tda1004x: setting
> up plls for 48MHz sampling clock
> Jun  2 16:12:29 finswimmer-desktop kernel: [ 6596.616006] tda1004x: found
> firmware revision 0 -- invalid
> Jun  2 16:12:29 finswimmer-desktop kernel: [ 6596.616012] tda1004x: trying
> to boot from eeprom
> Jun  2 16:12:31 finswimmer-desktop kernel: [ 6598.984007] tda1004x: found
> firmware revision 0 -- invalid
> Jun  2 16:12:31 finswimmer-desktop kernel: [ 6598.984014] tda1004x: waiting
> for firmware upload...
> Jun  2 16:12:31 finswimmer-desktop kernel: [ 6598.984018] firmware:
> requesting dvb-fe-tda10046.fw
> Jun  2 16:12:46 finswimmer-desktop kernel: [ 6613.424007] tda1004x: found
> firmware revision ed -- invalid
> Jun  2 16:12:46 finswimmer-desktop kernel: [ 6613.424013] tda1004x:
> firmware upload failed
>
> On Tuesday 02 June 2009 15:57:27 Tobias Kaminsky wrote:
> > Hello,
> >
> > I have two WinTX1110 installed in one PC:
> >
> > 04:03.0 Multimedia controller: Philips Semiconductors
> > SAA7131/SAA7133/SAA7135 Video Broadcast Decoder (rev d1)
> > 04:04.0 Multimedia controller: Philips Semiconductors
> > SAA7131/SAA7133/SAA7135 Video Broadcast Decoder (rev d1)
> >
> > The first card is working fine.
> > But the second fails to load the firmware:
> > [  215.424008] tda1004x: found firmware revision 0 -- invalid
> > [  215.424014] tda1004x: firmware upload failed
> >
> > I have tried both cards alone in the pc and they are working, but
> > together not.
> >
> > The "first" card says this:
> > [  204.217357] tda1004x: found firmware revision 20 -- ok
> >
> > So the current status is that only one is working and I do not know what
> > I can change.
> >
> > The Firmware:
> > -rw-r--r-- 1 root 24478 2008-10-27 06:33 /lib/firmware/dvb-fe-tda10046.fw
> >
> > What else informations do you need?
> >
> > Thank you very much!
> >
> > Tobias Kaminsky
> >
> > dmesg:
> > [   12.593302] Linux video capture interface: v2.00
> > [   12.903476] saa7130/34: v4l2 driver version 0.2.14 loaded
> > [   12.904699] saa7134 0000:04:03.0: PCI INT A -> GSI 16 (level, low) ->
> > IRQ 16
> > [   12.904706] saa7133[0]: found at 0000:04:03.0, rev: 209, irq: 16,
> > latency: 32, mmio: 0xfdaff000
> > [   12.904714] saa7133[0]: subsystem: 0070:6701, board: Hauppauge WinTV-
> > HVR1110 DVB-T/Hybrid [card=104,autodetected]
> > [   12.904726] saa7133[0]: board init: gpio is 6400000
> > [   13.063355] saa7133[0]: i2c eeprom 00: 70 00 01 67 54 20 1c 00 43 43
> > a9 1c 55 d2 b2 92
> > [   13.063366] saa7133[0]: i2c eeprom 10: ff ff ff 0e ff 20 ff ff ff ff
> > ff ff ff ff ff ff [   13.063375] saa7133[0]: i2c eeprom 20: 01 40 01 32
> > 32 01 01 33 88 ff 00 aa ff ff ff ff
> > [   13.063383] saa7133[0]: i2c eeprom 30: ff ff ff ff ff ff ff ff ff ff
> > ff ff ff ff ff ff [   13.063392] saa7133[0]: i2c eeprom 40: ff 21 00 c2
> > 96 10 03 32 15 60 ff ff ff ff ff ff
> > [   13.063401] saa7133[0]: i2c eeprom 50: ff 00 00 00 00 00 00 00 00 00
> > 00 00 00 00 00 00
> > [   13.063409] saa7133[0]: i2c eeprom 60: 00 00 00 00 00 00 00 00 00 00
> > 00 00 00 00 00 00
> > [   13.063418] saa7133[0]: i2c eeprom 70: 00 00 00 00 00 00 00 00 00 00
> > 00 00 00 00 00 00
> > [   13.063426] saa7133[0]: i2c eeprom 80: 84 09 00 04 20 77 00 40 6f 78
> > 0e f0 73 05 29 00
> > [   13.063435] saa7133[0]: i2c eeprom 90: 84 08 00 06 cb 05 01 00 94 48
> > 89 72 07 70 73 09
> > [   13.063444] saa7133[0]: i2c eeprom a0: 23 5f 73 0a fc 72 72 0b 2f 72
> > 0e 01 72 0f 03 72
> > [   13.063452] saa7133[0]: i2c eeprom b0: 10 01 72 11 ff 79 49 00 00 00
> > 00 00 00 00 00 00
> > [   13.063461] saa7133[0]: i2c eeprom c0: 00 00 00 00 00 00 00 00 00 00
> > 00 00 00 00 00 00
> > [   13.063469] saa7133[0]: i2c eeprom d0: 00 00 00 00 00 00 00 00 00 00
> > 00 00 00 00 00 00
> > [   13.063478] saa7133[0]: i2c eeprom e0: 00 00 00 00 00 00 00 00 00 00
> > 00 00 00 00 00 00
> > [   13.063486] saa7133[0]: i2c eeprom f0: 00 00 00 00 00 00 00 00 00 00
> > 00 00 00 00 00 00
> > [   13.364324] tuner' 1-004b: chip found @ 0x96 (saa7133[0])
> > [   13.367371] tveeprom 1-0050: Hauppauge model 67019, rev B4B4, serial#
> > 948335
> > [   13.367375] tveeprom 1-0050: MAC address is 00-0D-FE-0E-78-6F
> > [   13.367378] tveeprom 1-0050: tuner model is Philips 8275A (idx 114,
> > type 4) [   13.367381] tveeprom 1-0050: TV standards PAL(B/G) NTSC(M)
> > PAL(I) SECAM(L/L') PAL(D/D1/K) ATSC/DVB Digital (eeprom 0xfc)
> > [   13.367385] tveeprom 1-0050: audio processor is SAA7131 (idx 41)
> > [   13.367387] tveeprom 1-0050: decoder processor is SAA7131 (idx 35)
> > [   13.367390] tveeprom 1-0050: has radio, has IR receiver, has IR
> > transmitter [   13.367392] saa7133[0]: hauppauge eeprom: model=67019
> > [   13.456094] tda829x 1-004b: setting tuner address to 61
> > [   13.556076] tda829x 1-004b: type set to tda8290+75a
> > [   17.422485] saa7133[0]: registered device video0 [v4l2]
> > [   17.422789] saa7133[0]: registered device vbi0
> > [   17.423087] saa7133[0]: registered device radio0
> > [   17.484044] saa7134 0000:04:04.0: PCI INT A -> GSI 17 (level, low) ->
> > IRQ 17
> > [   17.484052] saa7133[1]: found at 0000:04:04.0, rev: 209, irq: 17,
> > latency: 32, mmio: 0xfdafe000
> > [   17.484060] saa7133[1]: subsystem: 0070:6701, board: Hauppauge WinTV-
> > HVR1110 DVB-T/Hybrid [card=104,autodetected]
> > [   17.484072] saa7133[1]: board init: gpio is 6400000
> > [   17.628082] tuner' 2-004b: chip found @ 0x96 (saa7133[1])
> > [   17.676014] saa7133[1]: i2c eeprom 00: 70 00 01 67 54 20 1c 00 43 43
> > a9 1c 55 d2 b2 92
> > [   17.676024] saa7133[1]: i2c eeprom 10: ff ff ff 0e ff 20 ff ff ff ff
> > ff ff ff ff ff ff [   17.676033] saa7133[1]: i2c eeprom 20: 01 40 01 32
> > 32 01 01 33 88 ff 00 aa ff ff ff ff
> > [   17.676042] saa7133[1]: i2c eeprom 30: ff ff ff ff ff ff ff ff ff ff
> > ff ff ff ff ff ff [   17.676051] saa7133[1]: i2c eeprom 40: ff 21 00 c2
> > 96 10 03 32 15 60 ff ff ff ff ff ff
> > [   17.676059] saa7133[1]: i2c eeprom 50: ff 00 00 00 00 00 00 00 00 00
> > 00 00 00 00 00 00
> > [   17.676068] saa7133[1]: i2c eeprom 60: 00 00 00 00 00 00 00 00 00 00
> > 00 00 00 00 00 00
> > [   17.676077] saa7133[1]: i2c eeprom 70: 00 00 00 00 00 00 00 00 00 00
> > 00 00 00 00 00 00
> > [   17.676085] saa7133[1]: i2c eeprom 80: 84 09 00 04 20 77 00 40 59 4b
> > 4f f0 73 05 29 00
> > [   17.676094] saa7133[1]: i2c eeprom 90: 84 08 00 06 cb 05 01 00 94 48
> > 89 72 07 70 73 09
> > [   17.676103] saa7133[1]: i2c eeprom a0: 23 5f 73 0a fc 72 72 0b 2f 72
> > 0e 01 72 0f 03 72
> > [   17.676111] saa7133[1]: i2c eeprom b0: 10 01 72 11 ff 79 4b 00 00 00
> > 00 00 00 00 00 00
> > [   17.676120] saa7133[1]: i2c eeprom c0: 00 00 00 00 00 00 00 00 00 00
> > 00 00 00 00 00 00
> > [   17.676128] saa7133[1]: i2c eeprom d0: 00 00 00 00 00 00 00 00 00 00
> > 00 00 00 00 00 00
> > [   17.676137] saa7133[1]: i2c eeprom e0: 00 00 00 00 00 00 00 00 00 00
> > 00 00 00 00 00 00
> > [   17.676146] saa7133[1]: i2c eeprom f0: 00 00 00 00 00 00 00 00 00 00
> > 00 00 00 00 00 00
> > [   17.685388] tveeprom 2-0050: Hauppauge model 67019, rev B4B4, serial#
> > 5196633
> > [   17.685392] tveeprom 2-0050: MAC address is 00-0D-FE-4F-4B-59
> > [   17.685395] tveeprom 2-0050: tuner model is Philips 8275A (idx 114,
> > type 4) [   17.685398] tveeprom 2-0050: TV standards PAL(B/G) NTSC(M)
> > PAL(I) SECAM(L/L') PAL(D/D1/K) ATSC/DVB Digital (eeprom 0xfc)
> > [   17.685402] tveeprom 2-0050: audio processor is SAA7131 (idx 41)
> > [   17.685404] tveeprom 2-0050: decoder processor is SAA7131 (idx 35)
> > [   17.685407] tveeprom 2-0050: has radio, has IR receiver, has IR
> > transmitter [   17.685410] saa7133[1]: hauppauge eeprom: model=67019
> > [   17.772015] tda829x 2-004b: setting tuner address to 61
> > [   17.836014] tda829x 2-004b: type set to tda8290+75a
> > [   21.692599] saa7133[1]: registered device video1 [v4l2]
> > [   21.692915] saa7133[1]: registered device vbi1
> > [   21.693223] saa7133[1]: registered device radio1
> > [   21.777372] saa7134 ALSA driver for DMA sound loaded
> > [   21.789059] saa7133[0]/alsa: saa7133[0] at 0xfdaff000 irq 16
> > registered as card -2
> > [   21.789550] saa7133[1]/alsa: saa7133[1] at 0xfdafe000 irq 17
> > registered as card -1
> > [   21.938693] DVB: registering new adapter (saa7133[0])
> > [   21.938698] DVB: registering frontend 0 (Philips TDA10046H DVB-T)...
> >
> >
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-media" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

