Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from ti-out-0910.google.com ([209.85.142.189])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <jarro.2783@gmail.com>) id 1JZHIc-0003Y2-7C
	for linux-dvb@linuxtv.org; Wed, 12 Mar 2008 04:06:48 +0100
Received: by ti-out-0910.google.com with SMTP id y6so1216489tia.13
	for <linux-dvb@linuxtv.org>; Tue, 11 Mar 2008 20:06:32 -0700 (PDT)
Message-ID: <abf3e5070803112006l31b5f878j764a4ded24a2702d@mail.gmail.com>
Date: Wed, 12 Mar 2008 14:06:32 +1100
From: "Jarryd Beck" <jarro.2783@gmail.com>
To: "Michael Krufky" <mkrufky@linuxtv.org>
In-Reply-To: <47D735F4.2070303@linuxtv.org>
MIME-Version: 1.0
Content-Disposition: inline
References: <abf3e5070803091836g6415112ete553958792f54d@mail.gmail.com>
	<47D4B8D0.9090401@linuxtv.org>
	<abf3e5070803100039s232bf009ib5d1bde70b8e908d@mail.gmail.com>
	<47D539E8.6060204@linuxtv.org>
	<abf3e5070803101415g79c1f4a6m9b7467a0e6590348@mail.gmail.com>
	<47D5AF38.90600@iki.fi>
	<abf3e5070803111405v5d65d531mbff0649df14226d3@mail.gmail.com>
	<37219a840803111625x3079e56apf38b7122979fc11d@mail.gmail.com>
	<abf3e5070803111708k5dcee77ay166fc4bcf7c97711@mail.gmail.com>
	<47D735F4.2070303@linuxtv.org>
Cc: Antti Palosaari <crope@iki.fi>, linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] NXP 18211HDC1 tuner
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

>  >
>  > Also when I plugged it in, it sat there for about 10 seconds before
>  > finishing loading (dmesg printed another 5 lines about the device
>  > after about 10 seconds), but still no tuning.
>
>  Can I see those five lines?  ;-)
>
>  While you're at it, you may as well include dmesg from the point that the bridge driver loads and on.
>

Here's dmesg from the point it starts up until it finishes printing stuff.

usb 2-10: new high speed USB device using ehci_hcd and address 22
usb 2-10: configuration #1 chosen from 1 choice
af9015_usb_probe:
af9015_identify_state: reply:01
dvb-usb: found a 'Leadtek Winfast DTV Dongle Gold' in cold state, will
try to load a firmware
dvb-usb: downloading firmware from file 'dvb-usb-af9015.fw'
af9015_download_firmware:
dvb-usb: found a 'Leadtek Winfast DTV Dongle Gold' in warm state.
dvb-usb: will pass the complete MPEG2 transport stream to the software demuxer.
DVB: registering new adapter (Leadtek Winfast DTV Dongle Gold)
af9015_eeprom_dump:
00: 31 c2 bb 0b 00 00 00 00 13 04 29 60 00 02 01 02
10: 00 80 00 fa fa 10 40 ef 01 30 31 30 31 30 32 30
20: 35 30 35 30 30 30 30 31 ff ff ff ff ff ff ff ff
30: 00 00 3a 01 00 08 02 00 cc 10 00 00 9c ff ff ff
40: ff ff ff ff ff 08 02 00 1d 8d c4 04 82 ff ff ff
50: ff ff ff ff ff 26 00 00 04 03 09 04 10 03 4c 00
60: 65 00 61 00 64 00 74 00 65 00 6b 00 30 03 57 00
70: 69 00 6e 00 46 00 61 00 73 00 74 00 20 00 44 00
80: 54 00 56 00 20 00 44 00 6f 00 6e 00 67 00 6c 00
90: 65 00 20 00 47 00 6f 00 6c 00 64 00 20 03 30 00
a0: 31 00 30 00 31 00 30 00 31 00 30 00 31 00 30 00
b0: 36 00 30 00 30 00 30 00 30 00 31 00 00 ff ff ff
c0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
d0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
e0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
f0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
af9015_read_config: xtal:2 set adc_clock:28000
af9015_read_config: tuner id1:156
af9015_read_config: spectral inversion:0
af9015_set_gpios:
af9013: firmware version:4.95.0
DVB: registering frontend 2 (Afatech AF9013 DVB-T)...
af9015_tuner_attach:
tda18271_tuner_attach:
tda18271 5-00c0: creating new instance
TDA18271HD/C1 detected @ 5-00c0
input: IR-receiver inside an USB DVB receiver as /class/input/input34
dvb-usb: schedule remote query interval to 200 msecs.
dvb-usb: Leadtek Winfast DTV Dongle Gold successfully initialized and connected.
af9015_init:
af9015_download_ir_table:
input: Leadtek WinFast DTV Dongle Gold as /class/input/input35
input: USB HID v1.01 Keyboard [Leadtek WinFast DTV Dongle Gold] on
usb-0000:00:02.1-10

>
>  You said that you tuned to "channel 7, sydney, australia" -- is that an 8 MHz channel?  What frequency is it on?
>

This is channel 7's entry in channels.conf:
7 Digital:177500000:INVERSION_AUTO:BANDWIDTH_7_MHZ:FEC_2_3:FEC_2_3:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_16:HIERARCHY_NONE:513:514:1312

Jarryd.

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
