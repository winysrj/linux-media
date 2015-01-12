Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f172.google.com ([209.85.212.172]:41802 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753513AbbALTdQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 12 Jan 2015 14:33:16 -0500
Received: by mail-wi0-f172.google.com with SMTP id n3so16709791wiv.5
        for <linux-media@vger.kernel.org>; Mon, 12 Jan 2015 11:33:15 -0800 (PST)
Message-ID: <54B42179.2090502@googlemail.com>
Date: Mon, 12 Jan 2015 20:33:13 +0100
From: Oliver Freyermuth <o.freyermuth@googlemail.com>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>
CC: crope@iki.fi, nibble.max@gmail.com
Subject: m88ds3103 (in a DVBSky S960CI ) loses lock, does not re-gain by itself
 - unless FE_CAN_RECOVER is removed
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Dear DVB-experts, 

since recently I own a DVBSky S960CI incorporating a m88ds3103. I am on 3.18.2 with two patches from 3.19 in (the S960 CI support + the "dvb-usb-dvbsky: fix i2c adapter for sp2 device" commit), using firmware 3.B for the m88ds3103. 

My card is connected to a Quad LNB, to which also two set-top-box receivers and a TV with internal receiver are wired. No extra multiswitch. 

The card locks fine and has good reception (szap-s2 output): 
status 1f | signal c4e9 | snr 009a | ber 00000000 | unc fffffffe | FE_HAS_LOCK
but whenever one of the three other devices connected to the same Quad LNB is turned on / off, the LOCK is lost and not regained unless I explicitly retune, e.g. by restarting szap-s2. 

Following an intuitive feeling, I removed FE_CAN_RECOVER from the "static struct dvb_frontend_ops m88ds3103_ops.info.caps", thus activating the swzigzag-recover method in dvb-frontend.c which seems to be disabled by the CAN_RECOVER capability of a device. 

After rebuilding my kernel, the card now reacquires the lock "by itself" following the swzigzag procedure. Below the mail, you can find some debug output I captured with my kernel after removing FE_CAN_RECOVER. 

Is FE_CAN_RECOVER really true for this device? Is something broken in my setup (the LNB is only a few days old)? Is there a better solution, maybe it would be a good idea to have a generic fallback to swzigzag in any case even for (supposedly) FE_CAN_RECOVER-capable frontends if they do not recover on their own? 

I would be grateful for any advice on finally getting into a stable situation - I already own one Terratec S7 (for which the driver, or firmware, can not tune to S2 channels, but works fine with the Windows-driver) and an aparently broken TT3650CI which creates broken packages out of nowhere every few seconds (both Windows and Linux) and I am slowly running out of functional DVB-USB (with CI) hardware. 

Cheers and thanks for any help, 
Oliver

--------------------------


$ ./szap-s2 -h -V -c ~/.mpv/channelsS2VDR.conf -r "Das Erste HD;ARD" -S1
reading channels from file '/home/olifre/.mpv/channelsS2VDR.conf'
zapping to 209 'Das Erste HD;ARD':
delivery DVB-S2, modulation 8PSK
sat 0, frequency 11493 MHz H, symbolrate 22000000, coderate 2/3, rolloff 0.35 stream_id -1
vpid 0x13ed, apid 0x13ee, sid 0x283d
using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'
Filtering for PID= 0x13ed
Filtering for PID= 0x13ee
status 00 | signal ffff | snr 005a | ber 00000000 | unc fffffffe | 
status 1f | signal c4e9 | snr 009c | ber 00000000 | unc fffffffe | FE_HAS_LOCK
status 1f | signal c4e9 | snr 009c | ber 00000000 | unc fffffffe | FE_HAS_LOCK
...
putting one of the other receivers in standby
...
status 1f | signal c4e9 | snr 009a | ber 00000000 | unc fffffffe | FE_HAS_LOCK
status 1f | signal c4e9 | snr 009a | ber 00000000 | unc fffffffe | FE_HAS_LOCK
status 00 | signal c4e9 | snr 0075 | ber 00000000 | unc fffffffe | 
status 00 | signal c4e9 | snr 0068 | ber 00007e5f | unc fffffffe | 
status 00 | signal c4e9 | snr 0068 | ber 00007e5f | unc fffffffe | 
status 00 | signal c4e9 | snr 0068 | ber 00007e5f | unc fffffffe | 
status 1f | signal c4e9 | snr 008b | ber 00007e5f | unc fffffffe | FE_HAS_LOCK
status 1f | signal c4e9 | snr 0096 | ber 00007e5f | unc fffffffe | FE_HAS_LOCK
status 1f | signal c4e9 | snr 0099 | ber 00007e5f | unc fffffffe | FE_HAS_LOCK
status 1f | signal c4e9 | snr 009a | ber 00000001 | unc fffffffe | FE_HAS_LOCK
status 1f | signal c4e9 | snr 009b | ber 00000001 | unc fffffffe | FE_HAS_LOCK
status 1f | signal c4e9 | snr 0099 | ber 00000001 | unc fffffffe | FE_HAS_LOCK
status 1f | signal c4e9 | snr 0099 | ber 00000001 | unc fffffffe | FE_HAS_LOCK
status 1f | signal c4e9 | snr 009a | ber 00000000 | unc fffffffe | FE_HAS_LOCK
status 1f | signal c4e9 | snr 0097 | ber 00000000 | unc fffffffe | FE_HAS_LOCK
status 1f | signal c4e9 | snr 0093 | ber 00000000 | unc fffffffe | FE_HAS_LOCK


In kernel log with dyndebug on, from when lock was lost: 
...
Jan 12 19:55:19 alien17 kernel: [  510.022420] i2c i2c-9: m88ds3103_read_status: lock=8f status=1f
Jan 12 19:55:19 alien17 kernel: [  510.022424] usb 1-1: dvb_frontend_swzigzag_update_delay:
Jan 12 19:55:19 alien17 kernel: [  510.545510] dvb_dmx_swfilter_packet: 46431 callbacks suppressed
Jan 12 19:55:19 alien17 kernel: [  510.545513] TEI detected. PID=0x13f7 data1=0x93
Jan 12 19:55:19 alien17 kernel: [  510.545514] TEI detected. PID=0x12fb data1=0x92
Jan 12 19:55:19 alien17 kernel: [  510.545515] TEI detected. PID=0x1c39 data1=0x9c
Jan 12 19:55:19 alien17 kernel: [  510.545516] TEI detected. PID=0xf6f data1=0xcf
Jan 12 19:55:19 alien17 kernel: [  510.545517] TEI detected. PID=0x14 data1=0xc0
Jan 12 19:55:19 alien17 kernel: [  510.545518] TEI detected. PID=0x1a09 data1=0xba
Jan 12 19:55:19 alien17 kernel: [  510.545519] TEI detected. PID=0xc82 data1=0xec
Jan 12 19:55:19 alien17 kernel: [  510.545520] TEI detected. PID=0x1b5 data1=0xa1
Jan 12 19:55:19 alien17 kernel: [  510.545521] TEI detected. PID=0xad7 data1=0xca
Jan 12 19:55:19 alien17 kernel: [  510.545521] TEI detected. PID=0x40 data1=0x80
Jan 12 19:55:19 alien17 kernel: [  510.663708] usb 1-1: dvb_frontend_ioctl: (69)
Jan 12 19:55:19 alien17 kernel: [  510.664266] i2c i2c-9: m88ds3103_read_status: lock=0f status=00
Jan 12 19:55:19 alien17 kernel: [  510.664271] usb 1-1: dvb_frontend_ioctl: (71)
Jan 12 19:55:19 alien17 kernel: [  510.667450] usb 1-1: dvb_frontend_ioctl: (72)
Jan 12 19:55:19 alien17 kernel: [  510.667453] i2c i2c-9: m88ds3103_read_snr:
Jan 12 19:55:19 alien17 kernel: [  510.669906] usb 1-1: dvb_frontend_ioctl: (70)
Jan 12 19:55:19 alien17 kernel: [  510.669909] i2c i2c-9: m88ds3103_read_ber:
Jan 12 19:55:19 alien17 kernel: [  510.670704] usb 1-1: dvb_frontend_ioctl: (73)
Jan 12 19:55:20 alien17 kernel: [  511.671042] usb 1-1: dvb_frontend_ioctl: (69)
Jan 12 19:55:20 alien17 kernel: [  511.671615] i2c i2c-9: m88ds3103_read_status: lock=0f status=00
Jan 12 19:55:20 alien17 kernel: [  511.671619] usb 1-1: dvb_frontend_ioctl: (71)
Jan 12 19:55:20 alien17 kernel: [  511.674769] usb 1-1: dvb_frontend_ioctl: (72)
Jan 12 19:55:20 alien17 kernel: [  511.674772] i2c i2c-9: m88ds3103_read_snr:
Jan 12 19:55:20 alien17 kernel: [  511.677226] usb 1-1: dvb_frontend_ioctl: (70)
Jan 12 19:55:20 alien17 kernel: [  511.677229] i2c i2c-9: m88ds3103_read_ber:
...
Jan 12 19:55:22 alien17 kernel: [  513.695184] usb 1-1: dvb_frontend_ioctl: (73)
Jan 12 19:55:23 alien17 kernel: [  513.916342] i2c i2c-9: m88ds3103_read_status: lock=0f status=00
Jan 12 19:55:23 alien17 kernel: [  513.916346] usb 1-1: dvb_frontend_add_event:
Jan 12 19:55:23 alien17 kernel: [  513.916349] usb 1-1: dvb_frontend_swzigzag_update_delay:
Jan 12 19:55:23 alien17 kernel: [  513.916351] usb 1-1: dvb_frontend_swzigzag_autotune: drift:0 inversion:0 auto_step:2 auto_sub_step:0 started_auto_step:1
Jan 12 19:55:23 alien17 kernel: [  513.916354] i2c i2c-9: m88ds3103_set_frontend: delivery_system=6 modulation=9 frequency=1743000 symbol_rate=22000488 inversion=0 pilot=0 rolloff=0
Jan 12 19:55:23 alien17 kernel: [  514.251859] i2c i2c-9: m88ds3103_set_frontend: target_mclk=144000 ts_clk=10000 divide_ratio=15
Jan 12 19:55:23 alien17 kernel: [  514.260257] i2c i2c-9: m88ds3103_set_frontend: carrier offset=428
Jan 12 19:55:23 alien17 kernel: [  514.695551] usb 1-1: dvb_frontend_ioctl: (69)
Jan 12 19:55:23 alien17 kernel: [  514.696144] i2c i2c-9: m88ds3103_read_status: lock=8f status=1f
...
