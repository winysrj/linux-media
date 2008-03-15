Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from ti-out-0910.google.com ([209.85.142.186])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <jarro.2783@gmail.com>) id 1JaW5q-0000AZ-Oz
	for linux-dvb@linuxtv.org; Sat, 15 Mar 2008 14:06:39 +0100
Received: by ti-out-0910.google.com with SMTP id y6so1628951tia.13
	for <linux-dvb@linuxtv.org>; Sat, 15 Mar 2008 06:06:23 -0700 (PDT)
Message-ID: <abf3e5070803150606g7d9cd8f2g76f34196362d2974@mail.gmail.com>
Date: Sun, 16 Mar 2008 00:06:23 +1100
From: "Jarryd Beck" <jarro.2783@gmail.com>
To: "Antti Palosaari" <crope@iki.fi>
In-Reply-To: <47DAC4BE.5090805@iki.fi>
MIME-Version: 1.0
Content-Disposition: inline
References: <abf3e5070803121412i322041fbyede6c5a727827c7f@mail.gmail.com>
	<abf3e5070803131607j1432f590p44b9b9c80f1f36e7@mail.gmail.com>
	<47D9C33E.6090503@iki.fi>
	<abf3e5070803131953o5c52def9n5c6e4c3f26102e89@mail.gmail.com>
	<47D9EED4.8090303@linuxtv.org>
	<abf3e5070803132022g3e2c638fxc218030c535372b@mail.gmail.com>
	<47DA0F01.8010707@iki.fi> <47DA7008.8010404@linuxtv.org>
	<47DAC42D.7010306@iki.fi> <47DAC4BE.5090805@iki.fi>
Cc: linux-dvb@linuxtv.org, Michael Krufky <mkrufky@linuxtv.org>
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

On Sat, Mar 15, 2008 at 5:32 AM, Antti Palosaari <crope@iki.fi> wrote:
> forgot attach patch...
>
>
>
>  Antti Palosaari wrote:
>  > Michael Krufky wrote:
>  >> 4.3 is not close enough to 3.8.  If you don't know how to set the demod
>  >> to 3.8, then we can do some hacks to make it work, but signal reception
>  >> is likely to be very poor -- better off looking in his snoop log to see
>  >> how the windows driver sets the demod to 3.8
>  >
>  > OI have looked sniffs and tested linux driver and found that it is set
>  > to 3800. There is 4300 kHz set in eeprom, it is ok for 8 MHz but not for
>  > 6 or 7. Looks like driver needs to do some quirks when this tuner is
>  > used. Anyhow, patch attached is hardcoded to use 3.8 now.
>  >
>  > Jarryd, please test. Also some changes to stick plug done, if it does
>  > not work for you can fix it as earlier.
>  >
>  > regards
>  > Antti
>
>
>  --
>  http://palosaari.fi/
>

I tried it with both patches separately, and both patches together. None of
them worked, and with both together I got a kernel oops, lost my keyboard
and it wouldn't even reboot so I had to cut the power.
Michael's patch didn't produce any interesting dmesg output. I included
dmesg for plugging in and tuning with antti's patch.

Jarryd.

Here is dmesg with antti's patch when I plugged it in:

usb 5-1: new high speed USB device using ehci_hcd and address 4
usb 5-1: configuration #1 chosen from 1 choice
af9015_usb_probe:
af9015_identify_state: reply:01
dvb-usb: found a 'Afatech AF9015 DVB-T USB2.0 stick' in cold state,
will try to load a firmware
dvb-usb: downloading firmware from file 'dvb-usb-af9015.fw'
af9015_download_firmware:
af9015_usb_probe:
af9015: af9015_rw_udev: sending failed: -71 (8/0)
af9015: af9015_rw_udev: receiving failed: -71
dvb-usb: found a 'Afatech AF9015 DVB-T USB2.0 stick' in cold state,
will try to load a firmware
dvb-usb: downloading firmware from file 'dvb-usb-af9015.fw'
af9015_download_firmware:
af9015: af9015_rw_udev: sending failed: -71 (63/0)

<snip> - repeated about 200 times

af9015: af9015_rw_udev: sending failed: -71 (26/0)
af9015: af9015_rw_udev: sending failed: -71 (8/0)
af9015: af9015_rw_udev: receiving failed: -71
af9015: af9015_download_firmware: boot failed: -71
dvb_usb_af9015: probe of 5-1:1.1 failed with error -71
usb 5-1: USB disconnect, address 4
dvb-usb: generic DVB-USB module successfully deinitialized and disconnected.
usb 5-1: new high speed USB device using ehci_hcd and address 5
usb 5-1: configuration #1 chosen from 1 choice
af9015_usb_probe:
af9015_identify_state: reply:02
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
tda18271 1-00c0: creating new instance
af9013_i2c_gate_ctrl: enable:1
af9013_i2c_gate_ctrl: enable:0
TDA18271HD/C1 detected @ 1-00c0
tda18271_init_regs: initializing registers for device @ 1-00c0
af9013_i2c_gate_ctrl: enable:1
af9013_i2c_gate_ctrl: enable:0

<snip> - repeated about 30 times

input: IR-receiver inside an USB DVB receiver as /class/input/input12
dvb-usb: schedule remote query interval to 200 msecs.
dvb-usb: Afatech AF9015 DVB-T USB2.0 stick successfully initialized
and connected.
af9015_init:
af9015_download_ir_table:
input: Leadtek WinFast DTV Dongle Gold as /class/input/input13
input: USB HID v1.01 Keyboard [Leadtek WinFast DTV Dongle Gold] on
usb-0000:00:1d.7-1

dmesg after trying to tune:

af9013_init
af9013_reset
af9013_power_ctrl: onoff:1
af9013_set_adc_ctrl: adc_clock:28000
af913_div: a:28000000 b:1000000 x:19
af913_div: a:0 b:1000000 x:19 r:14680064 r:e00000
adc_cw:00 00 e0
af9013_init: load ofsm settings
af9013_init: load tuner specific settings
af9013_init: setting ts mode
af9013_lock_led: onoff:1
tda18271_set_standby_mode: sm = 0, sm_lt = 0, sm_xt = 0
af9013_i2c_gate_ctrl: enable:1
af9013_i2c_gate_ctrl: enable:0
af9013_i2c_gate_ctrl: enable:1
af9013_i2c_gate_ctrl: enable:0
tda18271_init_regs: initializing registers for device @ 1-00c0
af9013_i2c_gate_ctrl: enable:1
af9013_i2c_gate_ctrl: enable:0
<snip>
af9013_i2c_gate_ctrl: enable:0
af9013_i2c_gate_ctrl: enable:0
af9013_set_frontend: freq:177500000 bw:1
af9013_set_coeff: adc_clock:28000 bw:1
coeff:02 49 24 92 04 92 49 09 00 92 4d b7 00 92 49 25 00 92 44 92 01 24 92 12
af9013_set_freq_ctrl
af913_div: a:3800000 b:28000000 x:23
af913_div: a:54400000 b:28000000 x:23 r:1138452 r:115f14
freq_cw:14 5f 11
tda18271_tune: freq = 177500000, ifc = 3800000, bw = 7000000, std = 0x1d
tda18271_set_standby_mode: sm = 0, sm_lt = 0, sm_xt = 0
af9013_i2c_gate_ctrl: enable:1
af9013_i2c_gate_ctrl: enable:0
<snip>
af9013_set_ofdm_params
af9013_set_frontend: manual TPS
af9013_read_status
tda18271_set_standby_mode: sm = 1, sm_lt = 0, sm_xt = 0
af9013_i2c_gate_ctrl: enable:1
af9013_i2c_gate_ctrl: enable:0
af9013_i2c_gate_ctrl: enable:0
af9013_sleep
af9013_lock_led: onoff:0
af9013_power_ctrl: onoff:0
af9013_reset

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
