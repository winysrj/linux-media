Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Message-ID: <47D9FE66.4080206@iki.fi>
Date: Fri, 14 Mar 2008 06:26:14 +0200
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Jarryd Beck <jarro.2783@gmail.com>
References: <abf3e5070803121412i322041fbyede6c5a727827c7f@mail.gmail.com>	<47D847AC.9070803@linuxtv.org>	<abf3e5070803121425k326fd126l1bfd47595617c10f@mail.gmail.com>	<47D86336.2070200@iki.fi>	<abf3e5070803121920j5d05208fo1162e4d4e3f6c44f@mail.gmail.com>	<abf3e5070803131607j1432f590p44b9b9c80f1f36e7@mail.gmail.com>	<47D9C33E.6090503@iki.fi>
	<abf3e5070803131953o5c52def9n5c6e4c3f26102e89@mail.gmail.com>
In-Reply-To: <abf3e5070803131953o5c52def9n5c6e4c3f26102e89@mail.gmail.com>
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

Jarryd Beck wrote:
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

Sounds weird. tda18271 driver does own i2c transaction for every 
register write / read. Thats why it opens and closes i2c-gate of the 
af9013 (about i2c-gate: tuner is wired to demodulator and demodulator 
keeps gate that should be open and close every time when access to tuner 
is needed). I don't know if this really takes so much cpu-time from 
af9013/5 that it slows down or so much disk IO from your computer to 
write all logs to disk. Anyhown, i2c-bus of the af9015/3 can be 
increased from driver. It is 400kHz currently if I remember correctly.

There is still missing all best information from your logs. I put here 
successful case with logs where AF9015 + MT2060 (tuner) is tuned to 
channel. I need same kind information to see if demodulator is 
programmed correctly. There could be even bug because I have only 8MHz 
BW and you have 7MHz, maybe there is no test for 7MHz at all.


Mar 14 06:11:27 crope-laptop kernel: [15962.068300] usb 2-1: new high 
speed USB device using ehci_hcd and address 19
Mar 14 06:11:27 crope-laptop kernel: [15962.120712] usb 2-1: 
configuration #1 chosen from 1 choice
Mar 14 06:11:27 crope-laptop kernel: [15962.126234] input: Afatech DVB-T 
2 as /devices/pci0000:00/0000:00:02.1/usb2/2-1/2-1:1.1/input/input26
Mar 14 06:11:27 crope-laptop kernel: [15962.143945] input,hidraw0: USB 
HID v1.01 Keyboard [Afatech DVB-T 2] on usb-0000:00:02.1-1
Mar 14 06:11:27 crope-laptop kernel: [15962.185417] af9015_usb_probe:
Mar 14 06:11:27 crope-laptop kernel: [15962.186118] 
af9015_identify_state: reply:01
Mar 14 06:11:27 crope-laptop kernel: [15962.186123] dvb-usb: found a 
'Afatech AF9015 DVB-T USB2.0 stick' in cold state, will try to load a 
firmware
Mar 14 06:11:27 crope-laptop kernel: [15962.191522] dvb-usb: downloading 
firmware from file 'dvb-usb-af9015.fw'
Mar 14 06:11:27 crope-laptop kernel: [15962.191526] 
af9015_download_firmware:
Mar 14 06:11:27 crope-laptop kernel: [15962.228754] usbcore: registered 
new interface driver dvb_usb_af9015
Mar 14 06:11:27 crope-laptop kernel: [15962.228878] usb 2-1: USB 
disconnect, address 19
Mar 14 06:11:27 crope-laptop kernel: [15962.231248] dvb-usb: generic 
DVB-USB module successfully deinitialized and disconnected.
Mar 14 06:11:27 crope-laptop kernel: [15962.334815] usb 2-1: new high 
speed USB device using ehci_hcd and address 20
Mar 14 06:11:28 crope-laptop kernel: [15962.471565] usb 2-1: 
configuration #1 chosen from 1 choice
Mar 14 06:11:28 crope-laptop kernel: [15962.483220] af9015_usb_probe:
Mar 14 06:11:28 crope-laptop kernel: [15962.484851] 
af9015_identify_state: reply:02
Mar 14 06:11:28 crope-laptop kernel: [15962.484857] dvb-usb: found a 
'Afatech AF9015 DVB-T USB2.0 stick' in warm state.
Mar 14 06:11:28 crope-laptop kernel: [15962.484910] dvb-usb: will pass 
the complete MPEG2 transport stream to the software demuxer.
Mar 14 06:11:28 crope-laptop kernel: [15962.485346] DVB: registering new 
adapter (Afatech AF9015 DVB-T USB2.0 stick)
Mar 14 06:11:28 crope-laptop kernel: [15962.485557] af9015_eeprom_dump:
Mar 14 06:11:28 crope-laptop kernel: [15962.538409] 00: 2c 75 9b 0b 00 
00 00 00 a4 15 16 90 00 02 01 02
Mar 14 06:11:28 crope-laptop kernel: [15962.765844] 10: 00 80 00 fa fa 
10 40 ef 01 30 31 30 31 31 30 30
Mar 14 06:11:28 crope-laptop kernel: [15962.629342] 20: 34 30 36 30 30 
30 30 31 ff ff ff ff ff ff ff ff
Mar 14 06:11:28 crope-laptop kernel: [15962.672188] 30: 00 00 3a 01 00 
08 02 00 1d 8d c4 04 82 ff ff ff
Mar 14 06:11:28 crope-laptop kernel: [15962.696172] 40: ff ff ff ff ff 
08 02 00 1d 8d c4 04 82 ff ff ff
Mar 14 06:11:28 crope-laptop kernel: [15962.729650] 50: ff ff ff ff ff 
24 00 00 04 03 09 04 10 03 41 00
Mar 14 06:11:28 crope-laptop kernel: [15962.760627] 60: 66 00 61 00 74 
00 65 00 63 00 68 00 10 03 44 00
Mar 14 06:11:28 crope-laptop kernel: [15962.791231] 70: 56 00 42 00 2d 
00 54 00 20 00 32 00 20 03 30 00
Mar 14 06:11:28 crope-laptop kernel: [15962.823208] 80: 31 00 30 00 31 
00 31 00 30 00 30 00 34 00 30 00
Mar 14 06:11:28 crope-laptop kernel: [15962.855187] 90: 36 00 30 00 30 
00 30 00 30 00 31 00 00 ff ff ff
Mar 14 06:11:28 crope-laptop kernel: [15962.887165] a0: ff ff ff ff ff 
ff ff ff ff ff ff ff ff ff ff ff
Mar 14 06:11:28 crope-laptop kernel: [15962.919148] b0: ff ff ff ff ff 
ff ff ff ff ff ff ff ff ff ff ff
Mar 14 06:11:28 crope-laptop kernel: [15962.951121] c0: ff ff ff ff ff 
ff ff ff ff ff ff ff ff ff ff ff
Mar 14 06:11:28 crope-laptop kernel: [15962.983099] d0: ff ff ff ff ff 
ff ff ff ff ff ff ff ff ff ff ff
Mar 14 06:11:28 crope-laptop kernel: [15963.015077] e0: ff ff ff ff ff 
ff ff ff ff ff ff ff ff ff ff ff
Mar 14 06:11:28 crope-laptop kernel: [15963.047055] f0: ff ff ff ff ff 
ff ff ff ff ff ff ff ff ff ff ff
Mar 14 06:11:28 crope-laptop kernel: [15963.049053] af9015_read_config: 
xtal:2 set adc_clock:28000
Mar 14 06:11:28 crope-laptop kernel: [15963.051052] af9015_read_config: 
tuner id1:130
Mar 14 06:11:28 crope-laptop kernel: [15963.053053] af9015_read_config: 
spectral inversion:0
Mar 14 06:11:28 crope-laptop kernel: [15963.053055] af9015_set_gpios:
Mar 14 06:11:28 crope-laptop kernel: [15963.058672] af9013: firmware 
version:4.95.0
Mar 14 06:11:28 crope-laptop kernel: [15963.058678] DVB: registering 
frontend 0 (Afatech AF9013 DVB-T)...
Mar 14 06:11:28 crope-laptop kernel: [15963.058721] af9015_tuner_attach:
Mar 14 06:11:28 crope-laptop kernel: [15963.058723] 
af9015_mt2060_tuner_attach:
Mar 14 06:11:28 crope-laptop kernel: [15963.084215] 
af9013_i2c_gate_ctrl: enable:1
Mar 14 06:11:28 crope-laptop kernel: [15963.087285] MT2060: successfully 
identified (IF1 = 1220)
Mar 14 06:11:29 crope-laptop kernel: [15963.597056] 
af9013_i2c_gate_ctrl: enable:0
Mar 14 06:11:29 crope-laptop kernel: [15963.599780] input: IR-receiver 
inside an USB DVB receiver as 
/devices/pci0000:00/0000:00:02.1/usb2/2-1/input/input27
Mar 14 06:11:29 crope-laptop kernel: [15963.630193] dvb-usb: schedule 
remote query interval to 200 msecs.
Mar 14 06:11:29 crope-laptop kernel: [15963.630200] dvb-usb: Afatech 
AF9015 DVB-T USB2.0 stick successfully initialized and connected.
Mar 14 06:11:29 crope-laptop kernel: [15963.630203] af9015_init:
Mar 14 06:11:29 crope-laptop kernel: [15963.644404] 
af9015_download_ir_table:
Mar 14 06:11:29 crope-laptop kernel: [15963.786395] input: Afatech DVB-T 
2 as /devices/pci0000:00/0000:00:02.1/usb2/2-1/2-1:1.1/input/input28
Mar 14 06:11:29 crope-laptop kernel: [15963.830100] input,hidraw0: USB 
HID v1.01 Keyboard [Afatech DVB-T 2] on usb-0000:00:02.1-1
Mar 14 06:11:36 crope-laptop kernel: [15968.704830] af9013_init
Mar 14 06:11:36 crope-laptop kernel: [15968.704836] af9013_reset
Mar 14 06:11:36 crope-laptop kernel: [15968.539122] af9013_power_ctrl: 
onoff:1
Mar 14 06:11:36 crope-laptop kernel: [15968.543485] af9013_set_adc_ctrl: 
adc_clock:28000
Mar 14 06:11:36 crope-laptop kernel: [15968.543490] af913_div: 
a:28000000 b:1000000 x:19
Mar 14 06:11:36 crope-laptop kernel: [15968.543492] af913_div: a:0 
b:1000000 x:19 r:14680064 r:e00000
Mar 14 06:11:36 crope-laptop kernel: [15968.549298] af9013_init: load 
ofsm settings
Mar 14 06:11:36 crope-laptop kernel: [15968.611074] af9013_init: load 
tuner specific settings
Mar 14 06:11:36 crope-laptop kernel: [15968.664858] af9013_init: setting 
ts mode
Mar 14 06:11:36 crope-laptop kernel: [15968.666584] af9013_lock_led: onoff:1
Mar 14 06:11:36 crope-laptop kernel: [15968.668038] 
af9013_i2c_gate_ctrl: enable:1
Mar 14 06:11:36 crope-laptop kernel: [15968.669128] 
af9013_i2c_gate_ctrl: enable:0
Mar 14 06:11:37 crope-laptop kernel: [15968.669856] 
af9013_i2c_gate_ctrl: enable:0
Mar 14 06:11:37 crope-laptop kernel: [15968.670862] af9013_set_frontend: 
freq:506000000 bw:0
Mar 14 06:11:37 crope-laptop kernel: [15968.670865] af9013_set_coeff: 
adc_clock:28000 bw:0
Mar 14 06:11:37 crope-laptop kernel: [15968.670867] coeff:02 9c bc 15 05 
39 78 0a 00 a7 34 3f 00 a7 2f 05 00 a7 29 cc 01 4e 5e 03
Mar 14 06:11:37 crope-laptop kernel: [15968.679757] af9013_set_freq_ctrl
Mar 14 06:11:37 crope-laptop kernel: [15968.679763] af913_div: a:8125000 
b:28000000 x:23
Mar 14 06:11:37 crope-laptop kernel: [15968.679765] af913_div: a:8000000 
b:28000000 x:23 r:2434194 r:252492
Mar 14 06:11:37 crope-laptop kernel: [15968.679766] freq_cw:92 24 25
Mar 14 06:11:37 crope-laptop kernel: [15968.684392] 
af9013_i2c_gate_ctrl: enable:1
Mar 14 06:11:37 crope-laptop kernel: [15968.697839] 
af9013_i2c_gate_ctrl: enable:0
Mar 14 06:11:37 crope-laptop kernel: [15968.698564] af9013_set_ofdm_params
Mar 14 06:11:37 crope-laptop kernel: [15968.700380] af9013_set_frontend: 
manual TPS
Mar 14 06:11:37 crope-laptop kernel: [15968.914429] af9013_set_frontend: 
TPS locked in 588 ms
Mar 14 06:11:37 crope-laptop kernel: [15968.936233] af9013_set_frontend: 
MPEG2 locked in 60 ms
Mar 14 06:11:37 crope-laptop kernel: [15969.104766] af9013_read_status
Mar 14 06:11:39 crope-laptop kernel: [15970.018343] af9013_read_status
Mar 14 06:11:40 crope-laptop kernel: [15970.275022] af9013_read_status
Mar 14 06:11:40 crope-laptop kernel: [15970.448005] 
af9013_i2c_gate_ctrl: enable:1
Mar 14 06:11:40 crope-laptop kernel: [15970.449224] 
af9013_i2c_gate_ctrl: enable:0
Mar 14 06:11:40 crope-laptop kernel: [15970.449677] 
af9013_i2c_gate_ctrl: enable:0
Mar 14 06:11:40 crope-laptop kernel: [15970.450404] af9013_sleep
Mar 14 06:11:40 crope-laptop kernel: [15970.450406] af9013_lock_led: onoff:0
Mar 14 06:11:40 crope-laptop kernel: [15970.451133] af9013_power_ctrl: 
onoff:0
Mar 14 06:11:40 crope-laptop kernel: [15970.451136] af9013_reset

regards
Antti

-- 
http://palosaari.fi/

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
