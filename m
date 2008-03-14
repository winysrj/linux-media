Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail.hauppauge.com ([167.206.143.4])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <mkrufky@linuxtv.org>) id 1Ja0Sc-0006Og-D7
	for linux-dvb@linuxtv.org; Fri, 14 Mar 2008 04:20:01 +0100
Message-ID: <47D9EED4.8090303@linuxtv.org>
Date: Thu, 13 Mar 2008 23:19:48 -0400
From: Michael Krufky <mkrufky@linuxtv.org>
MIME-Version: 1.0
To: Jarryd Beck <jarro.2783@gmail.com>
References: <abf3e5070803121412i322041fbyede6c5a727827c7f@mail.gmail.com>	
	<47D847AC.9070803@linuxtv.org>	
	<abf3e5070803121425k326fd126l1bfd47595617c10f@mail.gmail.com>	
	<47D86336.2070200@iki.fi>	
	<abf3e5070803121920j5d05208fo1162e4d4e3f6c44f@mail.gmail.com>	
	<abf3e5070803131607j1432f590p44b9b9c80f1f36e7@mail.gmail.com>	
	<47D9C33E.6090503@iki.fi>
	<abf3e5070803131953o5c52def9n5c6e4c3f26102e89@mail.gmail.com>
In-Reply-To: <abf3e5070803131953o5c52def9n5c6e4c3f26102e89@mail.gmail.com>
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

Jarryd Beck wrote:
> On Fri, Mar 14, 2008 at 11:13 AM, Antti Palosaari <crope@iki.fi> wrote:
>   
>> Jarryd Beck wrote:
>>  > I found the problem, the driver I had set .no_reconnect = 1 in
>>  > af9015_properties, the one in af9015_new didn't. So after I changed
>>  > that I tried again, it still didn't work. I enabled debugging and tried
>>  > to tune to a channel and this is what I got in dmesg.
>>
>>  I know this no_reconnect problem. But haven't found proper correction
>>  yet. Looks like sometimes with some hw / sw configuration it reconnects
>>  USB-bus after firmware download and sometimes not. When there is
>>  no_reconnect set it is possible that driver loads twice (two adapters)
>>  and it causes race condition when two drivers are accessing same hw same
>>  time and it hangs (remote polling causes hangs very soon after plug).
>>  You can help and test if it is OK set no_reconnect=0 and remove #if 0
>>  -killed code by changing it to #if 1 in line where is comment "firmware
>>  is running, reconnect device in the usb bus". This forces AF9015 chipset
>>  reconnect USB.
>>
>>
>>
>>  >
>>  > usb 2-10: new high speed USB device using ehci_hcd and address 27
>>  > usb 2-10: configuration #1 chosen from 1 choice
>>  > af9015_usb_probe:
>>  > af9015_identify_state: reply:01
>>  > dvb-usb: found a 'Afatech AF9015 DVB-T USB2.0 stick' in cold state,
>>  > will try to load a firmware
>>  > dvb-usb: downloading firmware from file 'dvb-usb-af9015.fw'
>>  > af9015_download_firmware:
>>  > dvb-usb: found a 'Afatech AF9015 DVB-T USB2.0 stick' in warm state.
>>  > dvb-usb: will pass the complete MPEG2 transport stream to the software demuxer.
>>  > DVB: registering new adapter (Afatech AF9015 DVB-T USB2.0 stick)
>>  > af9015_eeprom_dump:
>>  > 00: 31 c2 bb 0b 00 00 00 00 13 04 29 60 00 02 01 02
>>  > 10: 00 80 00 fa fa 10 40 ef 01 30 31 30 31 30 32 30
>>  > 20: 35 30 35 30 30 30 30 31 ff ff ff ff ff ff ff ff
>>  > 30: 00 00 3a 01 00 08 02 00 cc 10 00 00 9c ff ff ff
>>  > 40: ff ff ff ff ff 08 02 00 1d 8d c4 04 82 ff ff ff
>>  > 50: ff ff ff ff ff 26 00 00 04 03 09 04 10 03 4c 00
>>  > 60: 65 00 61 00 64 00 74 00 65 00 6b 00 30 03 57 00
>>  > 70: 69 00 6e 00 46 00 61 00 73 00 74 00 20 00 44 00
>>  > 80: 54 00 56 00 20 00 44 00 6f 00 6e 00 67 00 6c 00
>>  > 90: 65 00 20 00 47 00 6f 00 6c 00 64 00 20 03 30 00
>>  > a0: 31 00 30 00 31 00 30 00 31 00 30 00 31 00 30 00
>>  > b0: 36 00 30 00 30 00 30 00 30 00 31 00 00 ff ff ff
>>  > c0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
>>  > d0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
>>  > e0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
>>  > f0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
>>  > af9015_read_config: xtal:2 set adc_clock:28000
>>  > af9015_read_config: tuner id1:156
>>  > af9015_read_config: spectral inversion:0
>>  > af9015_set_gpios:
>>  > af9013: firmware version:4.95.0
>>  > DVB: registering frontend 0 (Afatech AF9013 DVB-T)...
>>  > af9015_tuner_attach:
>>  > af9015_tda18271_tuner_attach:
>>  > tda18271 5-00c0: creating new instance
>>  > TDA18271HD/C1 detected @ 5-00c0
>>  > tda18271_init_regs: initializing registers for device @ 5-00c0
>>  > input: IR-receiver inside an USB DVB receiver as /class/input/input39
>>  > dvb-usb: schedule remote query interval to 200 msecs.
>>  > dvb-usb: Afatech AF9015 DVB-T USB2.0 stick successfully initialized
>>  > and connected.
>>  > af9015_init:
>>  > af9015_download_ir_table:
>>  > input: Leadtek WinFast DTV Dongle Gold as /class/input/input40
>>  > input: USB HID v1.01 Keyboard [Leadtek WinFast DTV Dongle Gold] on
>>  > usb-0000:00:02.1-10
>>  > tda18271_set_standby_mode: sm = 0, sm_lt = 0, sm_xt = 0
>>  > tda18271_init_regs: initializing registers for device @ 5-00c0
>>  > tda18271_tune: freq = 219500000, ifc = 3800000, bw = 7000000, std = 0x1d
>>  > tda18271_set_standby_mode: sm = 0, sm_lt = 0, sm_xt = 0
>>  > tda18271_init_regs: initializing registers for device @ 5-00c0
>>  > tda18271_set_standby_mode: sm = 1, sm_lt = 0, sm_xt = 0
>>
>>  There is no debug logs from af9013 demodulator module. You can enable
>>  logs by modprobe af9013 debug=1. Remember rmmod modules first from
>>  memory rmmod dvb_usb_af9015 af9013 mt2060 dvb_usb dvb_core
>>
>>  af9013 debug should log rather much useful data when tuning to channel.
>>  Did you try change GPIO3 as mentioned earlier?
>>
>>
>>
>>  regards
>>  Antti
>>  --
>>  http://palosaari.fi/
>>
>>     
>
> I tried what you said, it works with no_reconnect = 1 and #if 0, and it also
> works with no_reconnect = 0 and #if 1, but no_reconnect = 0 and #if 0
> doesn't work. It has a fit if I use no_reconnect = 1 and #if 1. It
> gives me a lot
> of this:
> Mar 14 13:42:17 localhost kernel: af9015: af9015_rw_udev: receiving failed: -22
> Mar 14 13:42:17 localhost kernel: dvb-usb: error while querying for an
> remote control event.
>
> I also tried changing the rf_spec_inv and gpio3 but that didn't seem to
> do anything. It seems like it's the tuner, from dmesg the rest seems to be
> working fine.
>
> Here is dmesg with debug enabled on af9013 too:
>
> usb 2-10: new high speed USB device using ehci_hcd and address 7
> usb 2-10: configuration #1 chosen from 1 choice
> af9015_usb_probe:
> af9015_identify_state: reply:01
> dvb-usb: found a 'Afatech AF9015 DVB-T USB2.0 stick' in cold state,
> will try to load a firmware
> dvb-usb: downloading firmware from file 'dvb-usb-af9015.fw'
> af9015_download_firmware:
> dvb-usb: found a 'Afatech AF9015 DVB-T USB2.0 stick' in warm state.
> dvb-usb: will pass the complete MPEG2 transport stream to the software demuxer.
> DVB: registering new adapter (Afatech AF9015 DVB-T USB2.0 stick)
> af9015_eeprom_dump:
> 00: 31 c2 bb 0b 00 00 00 00 13 04 29 60 00 02 01 02
> 10: 00 80 00 fa fa 10 40 ef 01 30 31 30 31 30 32 30
> 20: 35 30 35 30 30 30 30 31 ff ff ff ff ff ff ff ff
> 30: 00 00 3a 01 00 08 02 00 cc 10 00 00 9c ff ff ff
> 40: ff ff ff ff ff 08 02 00 1d 8d c4 04 82 ff ff ff
> 50: ff ff ff ff ff 26 00 00 04 03 09 04 10 03 4c 00
> 60: 65 00 61 00 64 00 74 00 65 00 6b 00 30 03 57 00
> 70: 69 00 6e 00 46 00 61 00 73 00 74 00 20 00 44 00
> 80: 54 00 56 00 20 00 44 00 6f 00 6e 00 67 00 6c 00
> 90: 65 00 20 00 47 00 6f 00 6c 00 64 00 20 03 30 00
> a0: 31 00 30 00 31 00 30 00 31 00 30 00 31 00 30 00
> b0: 36 00 30 00 30 00 30 00 30 00 31 00 00 ff ff ff
> c0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> d0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> e0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> f0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> af9015_read_config: xtal:2 set adc_clock:28000
> af9015_read_config: tuner id1:156
> af9015_read_config: spectral inversion:0
> af9015_set_gpios:
> af9013: firmware version:4.95.0
> DVB: registering frontend 2 (Afatech AF9013 DVB-T)...
> af9015_tuner_attach:
> af9015_tda18271_tuner_attach:
> tda18271 5-00c0: creating new instance
> af9013_i2c_gate_ctrl: enable:1
> af9013_i2c_gate_ctrl: enable:0
> TDA18271HD/C1 detected @ 5-00c0
> tda18271_init_regs: initializing registers for device @ 5-00c0
> af9013_i2c_gate_ctrl: enable:1
> af9013_i2c_gate_ctrl: enable:0
> af9013_i2c_gate_ctrl: enable:1
> af9013_i2c_gate_ctrl: enable:0
> af9013_i2c_gate_ctrl: enable:1
> af9013_i2c_gate_ctrl: enable:0
> af9013_i2c_gate_ctrl: enable:1
> af9013_i2c_gate_ctrl: enable:0
> af9013_i2c_gate_ctrl: enable:1
> af9013_i2c_gate_ctrl: enable:0
> af9013_i2c_gate_ctrl: enable:1
> af9013_i2c_gate_ctrl: enable:0
> af9013_i2c_gate_ctrl: enable:1
> af9013_i2c_gate_ctrl: enable:0
> af9013_i2c_gate_ctrl: enable:1
> af9013_i2c_gate_ctrl: enable:0
> af9013_i2c_gate_ctrl: enable:1
> af9013_i2c_gate_ctrl: enable:0
> af9013_i2c_gate_ctrl: enable:1
> af9013_i2c_gate_ctrl: enable:0
> af9013_i2c_gate_ctrl: enable:1
> af9013_i2c_gate_ctrl: enable:0
> af9013_i2c_gate_ctrl: enable:1
> af9013_i2c_gate_ctrl: enable:0
> af9013_i2c_gate_ctrl: enable:1
> af9013_i2c_gate_ctrl: enable:0
> af9013_i2c_gate_ctrl: enable:1
> af9013_i2c_gate_ctrl: enable:0
> af9013_i2c_gate_ctrl: enable:1
> af9013_i2c_gate_ctrl: enable:0
> af9013_i2c_gate_ctrl: enable:1
> af9013_i2c_gate_ctrl: enable:0
> af9013_i2c_gate_ctrl: enable:1
> af9013_i2c_gate_ctrl: enable:0
> af9013_i2c_gate_ctrl: enable:1
> af9013_i2c_gate_ctrl: enable:0
> af9013_i2c_gate_ctrl: enable:1
> af9013_i2c_gate_ctrl: enable:0
> af9013_i2c_gate_ctrl: enable:1
> af9013_i2c_gate_ctrl: enable:0
> af9013_i2c_gate_ctrl: enable:1
> af9013_i2c_gate_ctrl: enable:0
> af9013_i2c_gate_ctrl: enable:1
> af9013_i2c_gate_ctrl: enable:0
> af9013_i2c_gate_ctrl: enable:1
> af9013_i2c_gate_ctrl: enable:0
> input: IR-receiver inside an USB DVB receiver as /class/input/input9
> dvb-usb: schedule remote query interval to 200 msecs.
> dvb-usb: Afatech AF9015 DVB-T USB2.0 stick successfully initialized
> and connected.
> af9015_init:
> af9015_download_ir_table:
> input: Leadtek WinFast DTV Dongle Gold as /class/input/input10
> input: USB HID v1.01 Keyboard [Leadtek WinFast DTV Dongle Gold] on
> usb-0000:00:02.1-10
>
> and when I try to tune it I get this:
>
> af9013_init
> af9013_reset
> af9013_power_ctrl: onoff:1
> af9013_set_adc_ctrl: adc_clock:28000
> af913_div: a:28000000 b:1000000 x:19
> af913_div: a:0 b:1000000 x:19 r:14680064 r:e00000
> af9013_init: load ofsm settings
> af9013_init: load tuner specific settings
> af9013_init: setting ts mode
> af9013_lock_led: onoff:1
> tda18271_set_standby_mode: sm = 0, sm_lt = 0, sm_xt = 0
> af9013_i2c_gate_ctrl: enable:1
> af9013_i2c_gate_ctrl: enable:0
> af9013_i2c_gate_ctrl: enable:1
> af9013_i2c_gate_ctrl: enable:0
> tda18271_init_regs: initializing registers for device @ 5-00c0
> af9013_i2c_gate_ctrl: enable:1
> af9013_i2c_gate_ctrl: enable:0
>
> the last two lines are repeated about another 30 times and it
> just sits there doing nothing. Also for some reason it makes
> my keyboard really slow to respond just while it's tuning.
>
> Jarryd.
>   
The tda18271c1 driver does many i2c transactions during a tune request. 
This involves image rejection filter calibration, if it hasnt already
been done at least once, and rf tracking filter calibration on every tune.

This all happens very quickly on the hardware that I've tested ( a
cx23887-based pcie card and a cypress fx2-based usb device).  I've also
heard good reports on saa713x-based pci cards.  Is the i2c slow in the
af9013 driver?

The tuner driver is programmed to use 7mhz dvbt with IF centered at 3.8
mhz -- is the demod set to the same?

-Mike



_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
