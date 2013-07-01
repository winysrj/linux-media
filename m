Return-path: <linux-media-owner@vger.kernel.org>
Received: from 7of9.schinagl.nl ([88.159.158.68]:39897 "EHLO 7of9.schinagl.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754776Ab3GAUjW (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 1 Jul 2013 16:39:22 -0400
Message-ID: <51D1E8F8.9030402@schinagl.nl>
Date: Mon, 01 Jul 2013 22:39:20 +0200
From: Oliver Schinagl <oliver+list@schinagl.nl>
MIME-Version: 1.0
To: Antti Palosaari <crope@iki.fi>
CC: Bogdan Oprea <bogdaninedit@yahoo.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: drivers:media:tuners:fc2580c fix for Asus U3100Mini Plus error
 while loading driver (-19)
References: <1372660460.41879.YahooMailNeo@web162304.mail.bf1.yahoo.com> <1372661590.52145.YahooMailNeo@web162304.mail.bf1.yahoo.com> <51D1352A.2080107@schinagl.nl> <51D182CD.2040502@iki.fi> <51D1839B.1010007@schinagl.nl>
In-Reply-To: <51D1839B.1010007@schinagl.nl>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 07/01/13 15:26, Oliver Schinagl wrote:
> On 01-07-13 15:23, Antti Palosaari wrote:
>> On 07/01/2013 10:52 AM, Oliver Schinagl wrote:
>>> On 01-07-13 08:53, Bogdan Oprea wrote:
>>>> this is a fix for this type of error
>>>>
>>>> [18384.579235] usb 6-5: dvb_usb_v2: 'Asus U3100Mini Plus' error while
>>>> loading driver (-19)
>>>> [18384.580621] usb 6-5: dvb_usb_v2: 'Asus U3100Mini Plus' successfully
>>>> deinitialized and disconnected
>>>>
>>> This isn't really a fix, I think i mentioned this on the ML ages ago,
>>
>> Argh, I just replied that same. Oliver, do you has that same device? Is
>> it working? Could you tweak to see if I2C readings are working at all?
> I have the same device, but mine works normally (though I haven't
> checked for ages), I will try it tonight when I'm at home and don't
> forget what happens with my current kernel.

Hard to test when it 'just works (tm)' :)

After a clean reboot:
[  100.965450] usb 2-1: new high-speed USB device number 2 using ehci-pci
[  101.086860] usb 2-1: New USB device found, idVendor=0b05, idProduct=1779
[  101.086874] usb 2-1: New USB device strings: Mfr=1, Product=2, 
SerialNumber=3
[  101.086883] usb 2-1: Product: AF9035A USB Device
[  101.086889] usb 2-1: Manufacturer: Afa Technologies Inc.
[  101.086895] usb 2-1: SerialNumber: AF0102020700001
[  101.092237] input: Afa Technologies Inc. AF9035A USB Device as 
/devices/pci0000:00/0000:00:13.2/usb2/2-1/2-1:1.1/input/input14
[  101.092506] hid-generic 0003:0B05:1779.0003: input: USB HID v1.01 
Keyboard [Afa Technologies Inc. AF9035A USB Device] on 
usb-0000:00:13.2-1/input1
[  101.145576] usbcore: registered new interface driver dvb_usb_af9035
[  101.146220] usb 2-1: dvb_usb_v2: found a 'Asus U3100Mini Plus' in 
cold state
[  101.158094] usb 2-1: dvb_usb_v2: downloading firmware from file 
'dvb-usb-af9035-02.fw'
[  101.410106] usb 2-1: dvb_usb_af9035: bad firmware
[  101.467276] usb 2-1: dvb_usb_af9035: firmware version=12.13.15.0
[  101.467302] usb 2-1: dvb_usb_v2: found a 'Asus U3100Mini Plus' in 
warm state
[  101.469606] usb 2-1: dvb_usb_v2: will pass the complete MPEG2 
transport stream to the software demuxer
[  101.469680] DVB: registering new adapter (Asus U3100Mini Plus)
[  101.483031] i2c i2c-1: af9033: firmware version: LINK=12.13.15.0 
OFDM=6.20.15.0
[  101.486914] usb 2-1: DVB: registering adapter 0 frontend 0 (Afatech 
AF9033 (DVB-T))...
[  101.552160] i2c i2c-1: fc2580: FCI FC2580 successfully identified
[  101.564633] usb 2-1: dvb_usb_v2: 'Asus U3100Mini Plus' successfully 
initialized and connected

Linux valexia 3.9.4-gentoo #6 SMP PREEMPT Thu Jun 13 00:19:15 CEST 2013 
x86_64 AMD Phenom(tm) II X6 1090T Processor AuthenticAMD GNU/Linux


The bad firmware wories me, no clue where that error is from, using:
862604ab3fec0c94f4bf22b4cffd0d89  /lib/firmware/dvb-usb-af9035-02.fw

after downloading one of your firmwares and several hotplugs:
[  591.004936] usb 2-1: Product: AF9035A USB Device
[  591.004943] usb 2-1: Manufacturer: Afa Technologies Inc.
[  591.004949] usb 2-1: SerialNumber: AF0102020700001
[  591.010242] usb 2-1: dvb_usb_v2: found a 'Asus U3100Mini Plus' in 
cold state
[  591.010358] usb 2-1: dvb_usb_v2: downloading firmware from file 
'dvb-usb-af9035-02.fw'
[  591.011142] input: Afa Technologies Inc. AF9035A USB Device as 
/devices/pci0000:00/0000:00:13.2/usb2/2-1/2-1:1.1/input/input17
[  591.011292] hid-generic 0003:0B05:1779.0006: input: USB HID v1.01 
Keyboard [Afa Technologies Inc. AF9035A USB Device] on 
usb-0000:00:13.2-1/input1
[  591.318792] usb 2-1: dvb_usb_af9035: firmware version=12.13.15.0
[  591.318828] usb 2-1: dvb_usb_v2: found a 'Asus U3100Mini Plus' in 
warm state
[  591.320986] usb 2-1: dvb_usb_v2: will pass the complete MPEG2 
transport stream to the software demuxer
[  591.321062] DVB: registering new adapter (Asus U3100Mini Plus)
[  591.325398] i2c i2c-1: af9033: firmware version: LINK=12.13.15.0 
OFDM=6.20.15.0
[  591.329331] usb 2-1: DVB: registering adapter 0 frontend 0 (Afatech 
AF9033 (DVB-T))...
[  591.366046] i2c i2c-1: fc2580: FCI FC2580 successfully identified
[  591.378790] usb 2-1: dvb_usb_v2: 'Asus U3100Mini Plus' successfully 
initialized and connected

3735d499d945a6bb873a7f3ad5c701fa_12.13.15.0_6.20.15.0 is the one i used.

dvb-fe-tool -g works fine
dvb-fe-tool -g
INFO     Device Afatech AF9033 (DVB-T) (/dev/dvb/adapter0/frontend0) 
capabilities:
INFO          CAN_FEC_1_2
INFO          CAN_FEC_2_3
INFO          CAN_FEC_3_4
INFO          CAN_FEC_5_6
INFO          CAN_FEC_7_8
INFO          CAN_FEC_AUTO
INFO          CAN_GUARD_INTERVAL_AUTO
INFO          CAN_HIERARCHY_AUTO
INFO          CAN_INVERSION_AUTO
INFO          CAN_MUTE_TS
INFO          CAN_QAM_16
INFO          CAN_QAM_64
INFO          CAN_QAM_AUTO
INFO          CAN_QPSK
INFO          CAN_RECOVER
INFO          CAN_TRANSMISSION_MODE_AUTO
INFO     DVB API Version 5.10, Current v5 delivery system: DVBT
INFO     Supported delivery system:
INFO         [DVBT]
INFO     Got parameters for DVBT:
INFO     FREQUENCY = 0
INFO     MODULATION = QPSK
INFO     BANDWIDTH_HZ = 0
INFO     INVERSION = OFF
INFO     CODE_RATE_HP = NONE
INFO     CODE_RATE_LP = NONE
INFO     GUARD_INTERVAL = 1/32
INFO     TRANSMISSION_MODE = 2K
INFO     HIERARCHY = NONE
INFO     DELIVERY_SYSTEM = DVBT
INFO     FREQUENCY = 0
INFO     MODULATION = QPSK
INFO     BANDWIDTH_HZ = 0
INFO     INVERSION = OFF
INFO     CODE_RATE_HP = NONE
INFO     CODE_RATE_LP = NONE
INFO     GUARD_INTERVAL = 1/32
INFO     TRANSMISSION_MODE = 2K
INFO     HIERARCHY = NONE
INFO     DELIVERY_SYSTEM = DVBT

dvbscan fails horribly:
Unable to query frontend status

scan-dvb works fine:
0x0000 0x044d: pmt_pid 0x0000 Digitenne -- Nederland 1 (running)
0x0000 0x044e: pmt_pid 0x0000 Digitenne -- Nederland 2 (running)
0x0000 0x044f: pmt_pid 0x0000 Digitenne -- Nederland 3 (running)
0x0000 0x0450: pmt_pid 0x0000 Digitenne -- Omroep Brabant (running)
0x0000 0x0457: pmt_pid 0x0000 Digitenne -- Omroep Brabant (running)
0x0000 0x0458: pmt_pid 0x0000 Digitenne -- Radio 1 (running)
0x0000 0x0459: pmt_pid 0x0000 Digitenne -- Radio 2 (running)
0x0000 0x045a: pmt_pid 0x0000 Digitenne -- 3FM (running)
0x0000 0x045b: pmt_pid 0x0000 Digitenne -- Radio 4 (running)
0x0000 0x045c: pmt_pid 0x0000 Digitenne -- Radio 5 (running)
0x0000 0x045d: pmt_pid 0x0000 Digitenne -- Radio 6 (running)
0x0000 0x045f: pmt_pid 0x0000 Digitenne -- FunX (running)
Network Name 'Digitenne'


All the info i can supply for now ;) If anything else is needed; shoot.
>>
>>
>> regards
>> Antti
>>
>>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

