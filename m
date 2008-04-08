Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from fk-out-0910.google.com ([209.85.128.184])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <benoitpaquindk@gmail.com>) id 1Jj7hE-0005Qa-Nv
	for linux-dvb@linuxtv.org; Tue, 08 Apr 2008 08:52:47 +0200
Received: by fk-out-0910.google.com with SMTP id z22so2635169fkz.1
	for <linux-dvb@linuxtv.org>; Mon, 07 Apr 2008 23:52:39 -0700 (PDT)
Message-ID: <7dd90a210804072352n200e336bv2dbe3fe23160483@mail.gmail.com>
Date: Tue, 8 Apr 2008 08:52:37 +0200
From: "Benoit Paquin" <benoitpaquindk@gmail.com>
To: "Antti Palosaari" <crope@iki.fi>
In-Reply-To: <47FAFDDA.4050109@iki.fi>
MIME-Version: 1.0
Content-Disposition: inline
References: <7dd90a210804070554t6d8b972xa85eb6a75b0663cd@mail.gmail.com>
	<47FA3A7A.3010002@iki.fi> <47FAFDDA.4050109@iki.fi>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] USB 1.1 support for AF9015 DVB-T tuner
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

Amazing! I mentioned it yesterday, got it today.

I recorded using a USB1.1 port on a mind blowing 133 MHz Via C3
computer! Tuner locks frequency very fast compared to my Hauppauge
HVH-900.

I included dmesg. The only odd message is: af9013: i2c write failed
reg:ae00 val:02

Thanks a lot!
/benoit

[  203.284000] usb 1-1: new full speed USB device using uhci_hcd and address 2
[  203.468000] usb 1-1: configuration #1 chosen from 1 choice
[  203.468000] af9015_usb_probe: interface:0
[  203.472000] af9015_identify_state: reply:01
[  203.472000] dvb-usb: found a 'Afatech AF9015 DVB-T USB2.0 stick' in
cold state, will try to load a firmware
[  204.060000] dvb-usb: downloading firmware from file 'dvb-usb-af9015.fw'
[  204.060000] af9015_download_firmware:
[  204.356000] af9015_usb_probe: interface:1
[  204.356000] usb 1-1: USB disconnect, address 2
[  204.356000] dvb-usb: generic DVB-USB module successfully
deinitialized and disconnected.
[  204.356000] dvb-usb: generic DVB-USB module successfully
deinitialized and disconnected.
[  204.628000] usb 1-1: new full speed USB device using uhci_hcd and address 3
[  204.812000] usb 1-1: configuration #1 chosen from 1 choice
[  204.812000] af9015_usb_probe: interface:0
[  204.816000] af9015_identify_state: reply:02
[  204.816000] dvb-usb: found a 'Afatech AF9015 DVB-T USB2.0 stick' in
warm state.
[  204.816000] dvb-usb: will use the device's hardware PID filter
(table count: 32).
[  204.816000] DVB: registering new adapter (Afatech AF9015 DVB-T USB2.0 stick)
[  204.816000] af9015_eeprom_dump:
[  204.848000] 00: 2c 34 97 0b 00 00 00 00 a4 15 16 90 00 02 01 02
[  204.880000] 10: 03 80 00 fa fa 10 40 ef 01 30 31 30 31 30 38 31
[  204.912000] 20: 37 30 37 30 30 33 38 33 ff ff ff ff ff ff ff ff
[  204.944000] 30: 00 00 3a 01 00 08 02 00 1d 8d c4 04 82 ff ff ff
[  204.976000] 40: ff ff ff ff ff 08 02 00 1d 8d c4 04 82 ff ff ff
[  205.024000] 50: ff ff ff ff ff 24 00 00 04 03 09 04 10 03 41 00
[  205.056000] 60: 66 00 61 00 74 00 65 00 63 00 68 00 0c 03 44 00
[  205.088000] 70: 56 00 42 00 2d 00 54 00 20 03 30 00 31 00 30 00
[  205.120000] 80: 31 00 30 00 31 00 30 00 31 00 30 00 36 00 30 00
[  205.152000] 90: 30 00 30 00 30 00 31 00 00 ff ff ff ff ff ff ff
[  205.184000] a0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[  205.216000] b0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[  205.248000] c0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[  205.280000] d0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[  205.312000] e0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[  205.344000] f0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[  205.348000] af9015_read_config: xtal:2 set adc_clock:28000
[  205.352000] af9015_read_config: IF1:36125
[  205.356000] af9015_read_config: MT2060 IF1:1220
[  205.356000] af9015_read_config: tuner id1:130
[  205.360000] af9015_read_config: spectral inversion:0
[  205.572000] af9013: firmware version:4.95.0
[  205.572000] DVB: registering frontend 0 (Afatech AF9013 DVB-T)...
[  205.572000] af9015_tuner_attach:
[  205.572000] af9015_set_gpio: gpio:3 gpioval:03
[  205.772000] MT2060: successfully identified (IF1 = 1220)
[  206.244000] dvb-usb: Afatech AF9015 DVB-T USB2.0 stick successfully
initialized and connected.
[  206.244000] af9015_init:
[  206.244000] af9015_init_endpoint: USB speed:2
[  206.264000] af9015_download_ir_table:
[  206.516000] af9015_usb_probe: interface:1
[  206.524000] usbcore: registered new interface driver hiddev
[  206.532000] usbcore: registered new interface driver usbhid
[  206.532000] /build/buildd/linux-source-2.6.22-2.6.22/drivers/hid/usbhid/hid-core.c:
v2.6:USB HID core driver
[  328.552000] af9015_pid_filter: set pid filter, index 0, pid fa1, onoff 1
[  328.556000] af9015_pid_filter_ctrl: onoff:1
[  328.560000] af9015_pid_filter: set pid filter, index 1, pid fa2, onoff 1
[  329.568000] af9015: af9015_rw_udev: receiving failed: -110
[  329.568000] af9013: i2c write failed reg:ae00 val:02
[  339.252000] af9015_pid_filter: set pid filter, index 0, pid fa1, onoff 0
[  339.268000] af9015_pid_filter: set pid filter, index 1, pid fa2, onoff 0


2008/4/8, Antti Palosaari <crope@iki.fi>:
> Antti Palosaari wrote:
>
> >  Benoit Paquin wrote:
> >
> > >  Antti,
> > >  Can you explain this? It would be neat if it worked with USB 1.1. There are several old laptops around that could be used as digital video recorder. The main stream vendors (Pinnacle, Hauppauge and ASUS) do not support USB 1.1.
> > >
> >
> >  AF9015 chipset does support USB1.1 but driver not. I haven't see this important enough to implement yet... It is rather easy to implement, lets see if I get inspirations soon ;)
> >
>
>  Implemented now.
>
>
>  regards
>  Antti
>  --
>  http://palosaari.fi/
>

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
