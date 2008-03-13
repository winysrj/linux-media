Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from ti-out-0910.google.com ([209.85.142.184])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <jarro.2783@gmail.com>) id 1JZwW4-0005y0-MM
	for linux-dvb@linuxtv.org; Fri, 14 Mar 2008 00:07:18 +0100
Received: by ti-out-0910.google.com with SMTP id y6so1506451tia.13
	for <linux-dvb@linuxtv.org>; Thu, 13 Mar 2008 16:07:08 -0700 (PDT)
Message-ID: <abf3e5070803131607j1432f590p44b9b9c80f1f36e7@mail.gmail.com>
Date: Fri, 14 Mar 2008 10:07:08 +1100
From: "Jarryd Beck" <jarro.2783@gmail.com>
To: "Antti Palosaari" <crope@iki.fi>
In-Reply-To: <abf3e5070803121920j5d05208fo1162e4d4e3f6c44f@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
References: <abf3e5070803121412i322041fbyede6c5a727827c7f@mail.gmail.com>
	<47D847AC.9070803@linuxtv.org>
	<abf3e5070803121425k326fd126l1bfd47595617c10f@mail.gmail.com>
	<47D86336.2070200@iki.fi>
	<abf3e5070803121920j5d05208fo1162e4d4e3f6c44f@mail.gmail.com>
Cc: linux-dvb@linuxtv.org, mkrufky@linuxtv.org
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

On Thu, Mar 13, 2008 at 1:20 PM, Jarryd Beck <jarro.2783@gmail.com> wrote:
>
> On Thu, Mar 13, 2008 at 10:11 AM, Antti Palosaari <crope@iki.fi> wrote:
>  > Jarryd Beck wrote:
>  >  > On Thu, Mar 13, 2008 at 8:14 AM,  <mkrufky@linuxtv.org> wrote:
>  >
>  > >>  Then, please turn ON debug, repeat your tests, and post again with
>  >  >>  dmesg.  I am not familiar with the af9015 driver, but for tda18271, set
>  >  >>  debug=1.  (you must unload all modules first -- do 'make unload' in the
>  >  >>  v4l-dvb dir, then replug your device)
>  >  >>
>  >  >>  -Mike
>  >  >>
>  >  >>
>  >  >
>  >  > Sorry I'm unsure where to set debug.
>  >  >
>  >  > Jarryd.
>  >
>  >  I added initial support for this tda-tuner to the driver. Jarryd, can
>  >  you test?
>  >  http://linuxtv.org/hg/~anttip/af9015_new/
>  >
>  >  There is debug switch in af9013 module that may be helpful if it does
>  >  not work. You can enable it as described or if it is too hard to play
>  >  with modprobe just edit af9013.c file in frontend directory and set
>  >  debug=1 by hard coding.
>  >  If it does not work you can also try set GPIO3 setting (af9015) to 0xb
>  >  instead 0x3 used currently. Also try to change rf-spectral inversion to
>  >  see if it helps. Firmware should be ok and all other settings as well as
>  >  I can see from usb-sniffs. With little lucky it should start working.
>  >
>  >  regards
>  >  Antti
>  >  --
>  >  http://palosaari.fi/
>  >
>
>  Thanks, but now for some reason all I get is this:
>
>  usb 2-10: new high speed USB device using ehci_hcd and address 6
>
> usb 2-10: configuration #1 chosen from 1 choice
>  input: Leadtek WinFast DTV Dongle Gold as /class/input/input8
>
> input: USB HID v1.01 Keyboard [Leadtek WinFast DTV Dongle Gold] on
>  usb-0000:00:02.1-10
>
> af9015_usb_probe:
>  af9015_identify_state: reply:01
>  dvb-usb: found a 'Afatech AF9015 DVB-T USB2.0 stick' in cold state,
>
> will try to load a firmware
>  dvb-usb: downloading firmware from file 'dvb-usb-af9015.fw'
>  af9015_download_firmware:
>  usbcore: registered new interface driver dvb_usb_af9015
>
>  Jarryd.
>

I found the problem, the driver I had set .no_reconnect = 1 in
af9015_properties, the one in af9015_new didn't. So after I changed
that I tried again, it still didn't work. I enabled debugging and tried
to tune to a channel and this is what I got in dmesg.

usb 2-10: new high speed USB device using ehci_hcd and address 27
usb 2-10: configuration #1 chosen from 1 choice
af9015_usb_probe:
af9015_identify_state: reply:01
dvb-usb: found a 'Afatech AF9015 DVB-T USB2.0 stick' in cold state,
will try to load a firmware
dvb-usb: downloading firmware from file 'dvb-usb-af9015.fw'
af9015_download_firmware:
dvb-usb: found a 'Afatech AF9015 DVB-T USB2.0 stick' in warm state.
dvb-usb: will pass the complete MPEG2 transport stream to the software demuxer.
DVB: registering new adapter (Afatech AF9015 DVB-T USB2.0 stick)
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
DVB: registering frontend 0 (Afatech AF9013 DVB-T)...
af9015_tuner_attach:
af9015_tda18271_tuner_attach:
tda18271 5-00c0: creating new instance
TDA18271HD/C1 detected @ 5-00c0
tda18271_init_regs: initializing registers for device @ 5-00c0
input: IR-receiver inside an USB DVB receiver as /class/input/input39
dvb-usb: schedule remote query interval to 200 msecs.
dvb-usb: Afatech AF9015 DVB-T USB2.0 stick successfully initialized
and connected.
af9015_init:
af9015_download_ir_table:
input: Leadtek WinFast DTV Dongle Gold as /class/input/input40
input: USB HID v1.01 Keyboard [Leadtek WinFast DTV Dongle Gold] on
usb-0000:00:02.1-10
tda18271_set_standby_mode: sm = 0, sm_lt = 0, sm_xt = 0
tda18271_init_regs: initializing registers for device @ 5-00c0
tda18271_tune: freq = 219500000, ifc = 3800000, bw = 7000000, std = 0x1d
tda18271_set_standby_mode: sm = 0, sm_lt = 0, sm_xt = 0
tda18271_init_regs: initializing registers for device @ 5-00c0
tda18271_set_standby_mode: sm = 1, sm_lt = 0, sm_xt = 0

Jarryd.

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
