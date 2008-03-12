Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Message-ID: <47D7F16F.4070604@linuxtv.org>
From: mkrufky@linuxtv.org
To: crope@iki.fi
Date: Wed, 12 Mar 2008 11:06:23 -0400
MIME-Version: 1.0
in-reply-to: <47D7E260.4030502@iki.fi>
Cc: linux-dvb@linuxtv.org
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

Michael Krufky wrote:
>> On Tue, Mar 11, 2008 at 11:06 PM, Jarryd Beck <jarro.2783@gmail.com> 
>> wrote:
>>>>  >
>>>  >  > Also when I plugged it in, it sat there for about 10 seconds 
>>> before
>>>  >  > finishing loading (dmesg printed another 5 lines about the device
>>>  >  > after about 10 seconds), but still no tuning.
>>>  >
>>>  >  Can I see those five lines?  ;-)
>>>  >
>>>  >  While you're at it, you may as well include dmesg from the point 
>>> that the bridge driver loads and on.
>>>  >
>>>
>>>  Here's dmesg from the point it starts up until it finishes printing 
>>> stuff.
>>>
>>>  usb 2-10: new high speed USB device using ehci_hcd and address 22
>>>  usb 2-10: configuration #1 chosen from 1 choice
>>>  af9015_usb_probe:
>>>  af9015_identify_state: reply:01
>>>  dvb-usb: found a 'Leadtek Winfast DTV Dongle Gold' in cold state, will
>>>  try to load a firmware
>>>  dvb-usb: downloading firmware from file 'dvb-usb-af9015.fw'
>>>  af9015_download_firmware:
>>>  dvb-usb: found a 'Leadtek Winfast DTV Dongle Gold' in warm state.
>>>  dvb-usb: will pass the complete MPEG2 transport stream to the 
>>> software demuxer.
>>>  DVB: registering new adapter (Leadtek Winfast DTV Dongle Gold)
>>>  af9015_eeprom_dump:
>>>  00: 31 c2 bb 0b 00 00 00 00 13 04 29 60 00 02 01 02
>>>  10: 00 80 00 fa fa 10 40 ef 01 30 31 30 31 30 32 30
>>>  20: 35 30 35 30 30 30 30 31 ff ff ff ff ff ff ff ff
>>>  30: 00 00 3a 01 00 08 02 00 cc 10 00 00 9c ff ff ff
>>>  40: ff ff ff ff ff 08 02 00 1d 8d c4 04 82 ff ff ff
>>>  50: ff ff ff ff ff 26 00 00 04 03 09 04 10 03 4c 00
>>>  60: 65 00 61 00 64 00 74 00 65 00 6b 00 30 03 57 00
>>>  70: 69 00 6e 00 46 00 61 00 73 00 74 00 20 00 44 00
>>>  80: 54 00 56 00 20 00 44 00 6f 00 6e 00 67 00 6c 00
>>>  90: 65 00 20 00 47 00 6f 00 6c 00 64 00 20 03 30 00
>>>  a0: 31 00 30 00 31 00 30 00 31 00 30 00 31 00 30 00
>>>  b0: 36 00 30 00 30 00 30 00 30 00 31 00 00 ff ff ff
>>>  c0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
>>>  d0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
>>>  e0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
>>>  f0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
>>>  af9015_read_config: xtal:2 set adc_clock:28000
>>>  af9015_read_config: tuner id1:156
>>>  af9015_read_config: spectral inversion:0
>>>  af9015_set_gpios:
>>>  af9013: firmware version:4.95.0
>>>  DVB: registering frontend 2 (Afatech AF9013 DVB-T)...
>>>  af9015_tuner_attach:
>>>  tda18271_tuner_attach:
>>>  tda18271 5-00c0: creating new instance
>>>
>>> TDA18271HD/C1 detected @ 5-00c0
>>>  input: IR-receiver inside an USB DVB receiver as /class/input/input34
>>>  dvb-usb: schedule remote query interval to 200 msecs.
>>>  dvb-usb: Leadtek Winfast DTV Dongle Gold successfully initialized 
>>> and connected.
>>>  af9015_init:
>>>  af9015_download_ir_table:
>>>  input: Leadtek WinFast DTV Dongle Gold as /class/input/input35
>>>  input: USB HID v1.01 Keyboard [Leadtek WinFast DTV Dongle Gold] on
>>>  usb-0000:00:02.1-10
>>>
>>>
>>>
>>>  This is channel 7's entry in channels.conf:
>>>  7 
>>>
Digital:177500000:INVERSION_AUTO:BANDWIDTH_7_MHZ:FEC_2_3:FEC_2_3:QAM_64:TRAN
SMISSION_MODE_8K:GUARD_INTERVAL_1_16:HIERARCHY_NONE:513:514:1312 
>>>
>>
>>
>> Jarryd,
>>
>> I've analyzed the snoop that you've taken of the windows driver, and I
>> conclude that the driver is basically doing exactly the same that the
>> linux driver would do.  The only thing that I cannot verify is whether
>> or not the tda18211 uses the same table values as the tda18271c1.
>> Based on the traffic in your snoop, it looks like the exact same
>> algorithm is used, but based on a new set of tables -- I will not be
>> able to confirm that without a tda18211 datasheet.  The only thing
>> that you can do is try the tda18271 driver and hopefully it will work.
>>
>> Have you tried to tune yet?  There is a space in your channels.conf,
>> "7 Digital" -- you may want to change that to something like,
>> "7Digital" so that command line applications will work.
>>


Antti Palosaari wrote:
> hello
> I looked sniffs and find correct demodulator initialization values for 
> this NXP tuner. Copy & paste correct table from attached file and try. 
> Hopefully it works. I compared your sniff to mt2060 and qt1010 based 
> devices and there was still some minor differences to check.
>
> regards,
> Antti
>

Antti,

Please remember not to top-post.

Jarryd,

I have done further analysis on the snoop logs.  Not only is the driver 
using the same protocol as the tda18271 linux driver, it also seems to 
use the same table values as used with the tda18271c1 -- The linux 
driver should work on your tuner without any modification at all.

Regards,

Mike

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
