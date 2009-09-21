Return-path: <linux-media-owner@vger.kernel.org>
Received: from m2.goneo.de ([82.100.220.83]:56251 "EHLO m2.goneo.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756230AbZIUOKt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 21 Sep 2009 10:10:49 -0400
From: Roman <lists@hasnoname.de>
To: Antti Palosaari <crope@iki.fi>
Subject: Re: MSI Digivox mini III Remote Control
Date: Mon, 21 Sep 2009 16:10:52 +0200
Cc: "Aleksandr V. Piskunov" <aleksandr.v.piskunov@gmail.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
References: <200909202026.27086.lists@hasnoname.de> <200909211555.11747.lists@hasnoname.de> <4AB7870D.3030300@iki.fi>
In-Reply-To: <4AB7870D.3030300@iki.fi>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200909211610.52856.lists@hasnoname.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am Monday 21 September 2009 16:00:45 schrieb Antti Palosaari:
> For reason or the other there is no any mention about remote polling.
> Could you enable debug=3 to see what eeprom value is set to remote?
> rmmod dvb-usb-af9015; modprobe dvb-usb-af9015 debug=3;
>
> Antti

Here is the output of dmesg after reloading the module:
#--
af9015_usb_probe: interface:0
af9015_read_config: IR mode:4
af9015_read_config: TS mode:0
af9015_read_config: [0] xtal:2 set adc_clock:28000
af9015_read_config: [0] IF1:4300
af9015_read_config: [0] MT2060 IF1:0
af9015_read_config: [0] tuner id:156
af9015_identify_state: reply:02
dvb-usb: found a 'MSI Digi VOX mini III' in warm state.
dvb-usb: will pass the complete MPEG2 transport stream to the software 
demuxer.
DVB: registering new adapter (MSI Digi VOX mini III)
af9015_af9013_frontend_attach: init I2C
af9015_i2c_init:
00: 2b aa 9b 0b 00 00 00 00 62 14 07 88 00 02 01 02
10: 00 80 00 fa fa 10 40 ef 04 30 31 30 31 30 37 32
20: 34 30 37 30 30 30 30 31 ff ff ff ff ff ff ff ff
30: 00 00 3a 01 00 08 02 00 cc 10 00 00 9c ff ff ff
40: ff ff ff ff ff 08 02 00 1d 8d c4 04 82 ff ff ff
50: ff ff ff ff ff 26 00 00 04 03 09 04 10 03 41 00
60: 66 00 61 00 74 00 65 00 63 00 68 00 10 03 44 00
70: 56 00 42 00 2d 00 54 00 20 00 32 00 20 03 30 00
80: 31 00 30 00 31 00 30 00 31 00 30 00 31 00 30 00
90: 36 00 30 00 30 00 30 00 30 00 31 00 00 ff ff ff
a0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
b0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
c0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
d0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
e0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
f0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
af9013: firmware version:4.95.0
DVB: registering adapter 0 frontend 0 (Afatech AF9013 DVB-T)...
af9015_tuner_attach: 
tda18271 3-00c0: creating new instance
TDA18271HD/C1 detected @ 3-00c0
dvb-usb: MSI Digi VOX mini III successfully initialized and connected.
af9015_init:
af9015_init_endpoint: USB speed:3
af9015_download_ir_table:
usbcore: registered new interface driver dvb_usb_af9015
#--


Gruﬂ,
Roman

-- 
Adam West:  I love this job more than I love taffy, and I'm a man who loves 
his taffy.
