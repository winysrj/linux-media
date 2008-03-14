Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail.hauppauge.com ([167.206.143.4])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <mkrufky@linuxtv.org>) id 1Ja1Wc-0004JR-P2
	for linux-dvb@linuxtv.org; Fri, 14 Mar 2008 05:28:15 +0100
Message-ID: <47D9FED0.2060507@linuxtv.org>
Date: Fri, 14 Mar 2008 00:28:00 -0400
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
	<47D9EED4.8090303@linuxtv.org>	
	<abf3e5070803132022g3e2c638fxc218030c535372b@mail.gmail.com>
	<abf3e5070803132033x13ac35fax38fc427ce1e0a040@mail.gmail.com>
In-Reply-To: <abf3e5070803132033x13ac35fax38fc427ce1e0a040@mail.gmail.com>
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
> On Fri, Mar 14, 2008 at 2:22 PM, Jarryd Beck <jarro.2783@gmail.com> wrote:
>   
>>  >  > Here is dmesg with debug enabled on af9013 too:
>>  >  >
>>  >  > usb 2-10: new high speed USB device using ehci_hcd and address 7
>>  >  > usb 2-10: configuration #1 chosen from 1 choice
>>  >  > af9015_usb_probe:
>>  >  > af9015_identify_state: reply:01
>>  >  > dvb-usb: found a 'Afatech AF9015 DVB-T USB2.0 stick' in cold state,
>>  >  > will try to load a firmware
>>  >  > dvb-usb: downloading firmware from file 'dvb-usb-af9015.fw'
>>  >  > af9015_download_firmware:
>>  >  > dvb-usb: found a 'Afatech AF9015 DVB-T USB2.0 stick' in warm state.
>>  >  > dvb-usb: will pass the complete MPEG2 transport stream to the software demuxer.
>>  >  > DVB: registering new adapter (Afatech AF9015 DVB-T USB2.0 stick)
>>  >  > af9015_eeprom_dump:
>>  >  > 00: 31 c2 bb 0b 00 00 00 00 13 04 29 60 00 02 01 02
>>  >  > 10: 00 80 00 fa fa 10 40 ef 01 30 31 30 31 30 32 30
>>  >  > 20: 35 30 35 30 30 30 30 31 ff ff ff ff ff ff ff ff
>>  >  > 30: 00 00 3a 01 00 08 02 00 cc 10 00 00 9c ff ff ff
>>  >  > 40: ff ff ff ff ff 08 02 00 1d 8d c4 04 82 ff ff ff
>>  >  > 50: ff ff ff ff ff 26 00 00 04 03 09 04 10 03 4c 00
>>  >  > 60: 65 00 61 00 64 00 74 00 65 00 6b 00 30 03 57 00
>>  >  > 70: 69 00 6e 00 46 00 61 00 73 00 74 00 20 00 44 00
>>  >  > 80: 54 00 56 00 20 00 44 00 6f 00 6e 00 67 00 6c 00
>>  >  > 90: 65 00 20 00 47 00 6f 00 6c 00 64 00 20 03 30 00
>>  >  > a0: 31 00 30 00 31 00 30 00 31 00 30 00 31 00 30 00
>>  >  > b0: 36 00 30 00 30 00 30 00 30 00 31 00 00 ff ff ff
>>  >  > c0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
>>  >  > d0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
>>  >  > e0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
>>  >  > f0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
>>  >  > af9015_read_config: xtal:2 set adc_clock:28000
>>  >  > af9015_read_config: tuner id1:156
>>  >  > af9015_read_config: spectral inversion:0
>>  >  > af9015_set_gpios:
>>  >  > af9013: firmware version:4.95.0
>>  >  > DVB: registering frontend 2 (Afatech AF9013 DVB-T)...
>>  >  > af9015_tuner_attach:
>>  >  > af9015_tda18271_tuner_attach:
>>  >  > tda18271 5-00c0: creating new instance
>>  >  > af9013_i2c_gate_ctrl: enable:1
>>  >  > af9013_i2c_gate_ctrl: enable:0
>>  >  > TDA18271HD/C1 detected @ 5-00c0
>>  >  > tda18271_init_regs: initializing registers for device @ 5-00c0
>>  >  > af9013_i2c_gate_ctrl: enable:1
>>  >  > af9013_i2c_gate_ctrl: enable:0
>>  >  > af9013_i2c_gate_ctrl: enable:1
>>  >  > af9013_i2c_gate_ctrl: enable:0
>> [...]
>>  >  > af9013_i2c_gate_ctrl: enable:1
>>  >  > af9013_i2c_gate_ctrl: enable:0
>>  >  > input: IR-receiver inside an USB DVB receiver as /class/input/input9
>>  >  > dvb-usb: schedule remote query interval to 200 msecs.
>>  >  > dvb-usb: Afatech AF9015 DVB-T USB2.0 stick successfully initialized
>>  >  > and connected.
>>  >  > af9015_init:
>>  >  > af9015_download_ir_table:
>>  >  > input: Leadtek WinFast DTV Dongle Gold as /class/input/input10
>>  >  > input: USB HID v1.01 Keyboard [Leadtek WinFast DTV Dongle Gold] on
>>  >  > usb-0000:00:02.1-10
>>  >  >
>>  >  > and when I try to tune it I get this:
>>  >  >
>>  >  > af9013_init
>>  >  > af9013_reset
>>  >  > af9013_power_ctrl: onoff:1
>>  >  > af9013_set_adc_ctrl: adc_clock:28000
>>  >  > af913_div: a:28000000 b:1000000 x:19
>>  >  > af913_div: a:0 b:1000000 x:19 r:14680064 r:e00000
>>  >  > af9013_init: load ofsm settings
>>  >  > af9013_init: load tuner specific settings
>>  >  > af9013_init: setting ts mode
>>  >  > af9013_lock_led: onoff:1
>>  >  > tda18271_set_standby_mode: sm = 0, sm_lt = 0, sm_xt = 0
>>  >  > af9013_i2c_gate_ctrl: enable:1
>>  >  > af9013_i2c_gate_ctrl: enable:0
>>  >  > af9013_i2c_gate_ctrl: enable:1
>>  >  > af9013_i2c_gate_ctrl: enable:0
>>  >  > tda18271_init_regs: initializing registers for device @ 5-00c0
>>  >  > af9013_i2c_gate_ctrl: enable:1
>>  >  > af9013_i2c_gate_ctrl: enable:0
>>  >  >
>>  >  > the last two lines are repeated about another 30 times and it
>>  >  > just sits there doing nothing. Also for some reason it makes
>>  >  > my keyboard really slow to respond just while it's tuning.
>>  >  >
>>  >  > Jarryd.
>>  >  >
>>  >  The tda18271c1 driver does many i2c transactions during a tune request.
>>  >  This involves image rejection filter calibration, if it hasnt already
>>  >  been done at least once, and rf tracking filter calibration on every tune.
>>  >
>>  >  This all happens very quickly on the hardware that I've tested ( a
>>  >  cx23887-based pcie card and a cypress fx2-based usb device).  I've also
>>  >  heard good reports on saa713x-based pci cards.  Is the i2c slow in the
>>  >  af9013 driver?
>>  >
>>  >  The tuner driver is programmed to use 7mhz dvbt with IF centered at 3.8
>>  >  mhz -- is the demod set to the same?
>>  >
>>  >  -Mike
>>  >
>>
>>  How do I find out about the demod? Is the speed of af9013 a question for
>>  me because I have no idea.
>>     
> Somewhere along the way demod_address in a struct is set to AF9015_I2C_DEMOD
> which is 0x38. Is that what you wanted?
>   
I was hoping that Antti might know the answers those questions.

Anyhow, there is something else related to the tuner that we can try.  In the snoop log, I see that no i2c transactions are longer than 16 bytes.  The linux driver writes 39 registers at once during its initialization, but the windows driver in your snoop log breaks that into three write transactions.

Please try this patch:

[PATCH] tda18271: break 39-byte register initialization into three i2c transactions

...for testing.

diff -r d1654ab5f056 linux/drivers/media/dvb/frontends/tda18271-common.c
--- a/linux/drivers/media/dvb/frontends/tda18271-common.c	Mon Mar 10 11:27:26 2008 -0300
+++ b/linux/drivers/media/dvb/frontends/tda18271-common.c	Fri Mar 14 00:13:10 2008 -0400
@@ -311,7 +311,13 @@ int tda18271_init_regs(struct dvb_fronte
 	regs[R_EB22] = 0x48;
 	regs[R_EB23] = 0xb0;
 
+#if 0
 	tda18271_write_regs(fe, 0x00, TDA18271_NUM_REGS);
+#else
+	tda18271_write_regs(fe, 0x00, 0x10);
+	tda18271_write_regs(fe, 0x10, 0x10);
+	tda18271_write_regs(fe, 0x20, 0x07);
+#endif
 
 	/* setup agc1 gain */
 	regs[R_EB17] = 0x00;


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
