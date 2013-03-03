Return-path: <linux-media-owner@vger.kernel.org>
Received: from imr-da03.mx.aol.com ([205.188.105.145]:47038 "EHLO
	imr-da03.mx.aol.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752811Ab3CCOyH (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 3 Mar 2013 09:54:07 -0500
Message-ID: <51336331.10205@netscape.net>
Date: Sun, 03 Mar 2013 11:50:25 -0300
From: =?UTF-8?B?QWxmcmVkbyBKZXPDunMgRGVsYWl0aQ==?=
	<alfredodelaiti@netscape.net>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@redhat.com>
CC: linux-media@vger.kernel.org
Subject: Re: mb86a20s and cx23885
References: <51054759.7050202@netscape.net> <20130127141633.5f751e5d@redhat.com> <5105A0C9.6070007@netscape.net> <20130128082354.607fae64@redhat.com> <5106E3EA.70307@netscape.net> <511264CF.3010002@netscape.net>
In-Reply-To: <511264CF.3010002@netscape.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro and others from the list

El 06/02/13 11:12, Alfredo Jesús Delaiti escribió:
> Hi
>
> El 28/01/13 17:47, Alfredo Jesús Delaiti escribió:
>> Hi
>> El 28/01/13 07:23, Mauro Carvalho Chehab escribió:
>>> Em Sun, 27 Jan 2013 18:48:57 -0300
>>> Alfredo Jesús Delaiti <alfredodelaiti@netscape.net> escreveu:
>>>
>>>> Hi
>>>>
>>>> El 27/01/13 13:16, Mauro Carvalho Chehab escribió:
>>>>> Em Sun, 27 Jan 2013 12:27:21 -0300
>>>>> Alfredo Jesús Delaiti <alfredodelaiti@netscape.net> escreveu:
>>>>>
>>>>>> Hi all
>>>>>>
>>>>>> I'm trying to run the digital part of the card MyGica X8507 and I 
>>>>>> need
>>>>>> help on some issues.
>>>>>>
>>>>>>
>>>>>>
>>>>>> Need data sheet of IC MB86A20S and no where to get it. Fujitsu 
>>>>>> People of
>>>>>> Germany told me: "This is a very old product and not supported any
>>>>>> more". Does anyone know where to get it?
>>>>> I never found any public datasheet for this device.
>>>> Congratulations for driver you have made
>>> Thanks!
>>>>>> linux-puon:/home/alfredo # modprobe cx23885 i2c_scan=1
>>>>>>
>>>>>> ...
>>>>>>
>>>>>> [ 7011.618381] cx23885[0]: scan bus 0:
>>>>>>
>>>>>> [ 7011.620759] cx23885[0]: i2c scan: found device @ 0x20 [???]
>>>>>>
>>>>>> [ 7011.625653] cx23885[0]: i2c scan: found device @ 0x66 [???]
>>>>>>
>>>>>> [ 7011.629702] cx23885[0]: i2c scan: found device @ 0xa0 [eeprom]
>>>>>>
>>>>>> [ 7011.629983] cx23885[0]: i2c scan: found device @ 0xa4 [???]
>>>>>>
>>>>>> [ 7011.630267] cx23885[0]: i2c scan: found device @ 0xa8 [???]
>>>>>>
>>>>>> [ 7011.630548] cx23885[0]: i2c scan: found device @ 0xac [???]
>>>>>>
>>>>>> [ 7011.636438] cx23885[0]: scan bus 1:
>>>>>>
>>>>>> [ 7011.650108] cx23885[0]: i2c scan: found device @ 0xc2
>>>>>> [tuner/mt2131/tda8275/xc5000/xc3028]
>>>>>>
>>>>>> [ 7011.654460] cx23885[0]: scan bus 2:
>>>>>>
>>>>>> [ 7011.656434] cx23885[0]: i2c scan: found device @ 0x66 [???]
>>>>>>
>>>>>> [ 7011.657087] cx23885[0]: i2c scan: found device @ 0x88 [cx25837]
>>>>>>
>>>>>> [ 7011.657393] cx23885[0]: i2c scan: found device @ 0x98 [flatiron]
>>>>>>
>>>>>> ...
>>>>>>
>>>>>>
>>>>>> In the bus 0 is demodulator mb86a20s 0x20 (0x10) and in the bus 1 
>>>>>> the
>>>>>> tuner (xc5000). I understand that would have to be cancel the 
>>>>>> mb86a20s
>>>>>> i2c_gate_ctrl similarly as in the IC zl10353. If this is 
>>>>>> possible, is
>>>>>> not yet implemented in the controller of mb86a20s. The IC cx23885 is
>>>>>> always who controls the tuner i2c bus.
>>>>> Well, if you don't add an i2c_gate_ctrl() callback, the mb86a20s 
>>>>> won't
>>>>> be calling it. So, IMO, the cleanest approach would simply to do:
>>>>>
>>>>>     fe->dvb.frontend->ops.i2c_gate_ctrl = NULL;
>>>>>
>>>>> after tuner attach, if the tuner or the bridge driver implements 
>>>>> an i2c gate.
>>>>> I don't think xc5000 does. The mb86a20s also has its own i2c gate 
>>>>> and gpio
>>>>> ports that might be used to control an external gate, but support 
>>>>> for it is
>>>>> currently not implemented, as no known device uses it.
>>>> If in this way, it does not work:
>>>>
>>>>       case CX23885_BOARD_MYGICA_X8507:
>>>>           i2c_bus = &dev->i2c_bus[0];
>>>>           i2c_bus2 = &dev->i2c_bus[1];
>>>>           fe0->dvb.frontend = dvb_attach(mb86a20s_attach,
>>>>               &mygica_x8507_mb86a20s_config,
>>>>               &i2c_bus->i2c_adap);
>>>>           if (fe0->dvb.frontend != NULL) {
>>>>               dvb_attach(xc5000_attach,
>>>>                   fe0->dvb.frontend,
>>>>                   &i2c_bus2->i2c_adap,
>>>>                   &mygica_x8507_xc5000_config);
>>>>           fe0->dvb.frontend->ops.i2c_gate_ctrl = NULL;
>>>> fe0->dvb.frontend->ops.tuner_ops.init(fe0->dvb.frontend);
>>>>
>>>> I get:
>>>>
>>>> ...dmesg
>>>> ...
>>>> [  964.105688] mb86a20s: mb86a20s_read_status: val = 2, status = 0x01
>>>> [  964.105696] mb86a20s: mb86a20s_set_frontend:
>>>> [  964.105700] mb86a20s: mb86a20s_set_frontend: Calling tuner set 
>>>> parameters
>>> It seems that the driver is able to talk with mb86a20s and read the 
>>> status
>>> and version registers. If the xc5000 firmware got loaded, that means 
>>> that
>>> there's no issue with I2C.
>>>
>>> So, the issue is likely something else.
>>>
>>>  From this:
>>>
>>>> ;Demod Comm mode : 0x00 = Serial, 0x01 = Parallel
>>>> HKR,"DriverData","DemodTransferMode",0x00010001, 0x01, 0x00, 0x00, 
>>>> 0x00
>>> mb86a20s_config.is_serial should be false (default).
>>
>> static struct mb86a20s_config mygica_x8507_mb86a20s_config = {
>>     .demod_address = 0x10,
>> };
>>
>>
>> nothing of .is_serial
>>
>>>
>>> Can you confirm if the XTAL at the side of mb86a20s is 32.57MHz?
>>
>> The exact value is 32.571MHz
>>
>>>
>>> If the XTAL is the same and the device driver is set to parallel mode,
>>> then we'll need to investigate other setups that happen during init 
>>> time.
>>>
>>> There are a few places at the driver that you could play with.
>>> For example, on this register set:
>>>     { 0x09, 0x3e },
>>>
>>> You could try, instead of 0x3e, 0x1e, 0x1a or 0x3a.
>>
>> I tested with the three new values ​​and get nothing different
>>
>>>
>>> However, I recommend you to sniff the PCI traffic, in order to be 
>>> sure about
>>> what this specific device does.
>>
>> For this I need a little more time to study and apply. In a few days 
>> it I obtained commented
>>
>>>
>>> When I was writing the driver for mb86a20s, I used this technique to
>>> be sure about what it was needed to make one PCI card to work with it.
>>> What I did then was to patch kvm to force it to emulate all DMA 
>>> transfers,
>>> writing a dump of all such transfers at the host kernel. Then, I ran 
>>> some
>>> parsing scripts to get the mb86a20s and tuner initialization. I made 
>>> the
>>> patches available at:
>>>
>>> http://git.linuxtv.org/v4l-utils.git/tree/HEAD:/contrib/pci_traffic
>>>
>>> I documented what it was needed to sniff the traffic at:
>>> http://git.linuxtv.org/v4l-utils.git/blob/HEAD:/contrib/pci_traffic/README 
>>>
>>>
>>> The patches were made against the kvm version that were shipped with 
>>> the
>>> latest Fedora version that were available in Oct, 2010 (likely 
>>> Fedora 13).
>>> I'm not sure if they still apply on today's kvm.
>>>
>>> As you may expect, emulating all DMA transfers on a PCIe device is 
>>> slow. So,
>>> the VM may die or produce unexpected results. However, as the 
>>> mb86a20s init
>>> happens before the beginning of the video stream, you'll very likely 
>>> be able
>>> to get the needed dumps before the guest system crash.
>>>
>>> Once you get the dumps, you'll need to parse them, in order to 
>>> filter just the
>>> cx23885 I2C register reads/writes, and get only the data sent to 
>>> mb86a20s.

I searched for a plan B to get the data bus and after several 
alternative plans that were available to me was to do a logic analyzer 
(http://tfla-01.berlios.de).

With the logic analyzer I could get the data transmitted by the I2C bus 
under Windows, but when I put this data in replacement of originals in 
mb86a20s.c and I try to run the Linux TV board, do not get the logic 
analyzer with the same sequence.

The new data replacement in mb86a20s

/*
  * Initialization sequence: Use whatevere default values that PV SBTVD
  * does on its initialisation, obtained via USB snoop
  */
static struct regdata mb86a20s_init[] = {

     { 0x70, 0x0f },
     { 0x70, 0xff },
     { 0x09, 0x3a },
     { 0x50, 0xd1 },
     { 0x51, 0x22 },
     { 0x39, 0x00 },
     { 0x28, 0x2a },
     { 0x29, 0x00 },
     { 0x2a, 0xfd },
     { 0x2b, 0xc8 },
     { 0x3b, 0x21 },
     { 0x3c, 0x38 },
     { 0x28, 0x20 },
     { 0x29, 0x3e },
     { 0x2a, 0xde },
     { 0x2b, 0x4d },
     { 0x28, 0x22 },
     { 0x29, 0x00 },
     { 0x2a, 0x1f },
     { 0x2b, 0xf0 },
     { 0x01, 0x0d },
     { 0x04, 0x08 },
     { 0x05, 0x03 },
     { 0x04, 0x0e },
     { 0x05, 0x00 },
     { 0x08, 0x1e },
     { 0x05, 0x32 },
     { 0x04, 0x0b },
     { 0x05, 0x78 },
     { 0x04, 0x00 },
     { 0x05, 0x00 },
     { 0x04, 0x01 },
     { 0x05, 0x1e },
     { 0x04, 0x02 },
     { 0x05, 0x07 },
     { 0x04, 0x03 },
     { 0x0a, 0xa0 },
     { 0x04, 0x09 },
     { 0x05, 0x00 },
     { 0x04, 0x0a },
     { 0x05, 0xff },
     { 0x04, 0x27 },
     { 0x05, 0x00 },
     { 0x08, 0x50 },
     { 0x05, 0x00 },
     { 0x04, 0x28 },
     { 0x05, 0x00 },
     { 0x04, 0x1e },
     { 0x05, 0x00 },
     { 0x04, 0x29 },
     { 0x05, 0x64 },
     { 0x04, 0x32 },
     { 0x05, 0x68 },
     { 0x04, 0x14 },
     { 0x05, 0x02 },
     { 0x04, 0x04 },
     { 0x05, 0x00 },
     { 0x08, 0x0a },
     { 0x05, 0x22 },
     { 0x04, 0x06 },
     { 0x05, 0x0e },
     { 0x04, 0x07 },
     { 0x05, 0xd8 },
     { 0x04, 0x12 },
     { 0x05, 0x00 },
     { 0x04, 0x13 },
     { 0x05, 0xff },
     { 0x52, 0x01 },
     { 0x50, 0xa7 },
     { 0x51, 0x00 },
     { 0x50, 0xa8 },
     { 0x51, 0xfe },
     { 0x50, 0xa9 },
     { 0x51, 0xff },
     { 0x50, 0xaa },
     { 0x51, 0x00 },
     { 0x50, 0xab },
     { 0x51, 0xff },
     { 0x50, 0xac },
     { 0x51, 0xff },
     { 0x50, 0xad },
     { 0x51, 0x00 },
     { 0x50, 0xae },
     { 0x51, 0xff },
     { 0x50, 0xaf },
     { 0x51, 0xff },
     { 0x5e, 0x07 },
     { 0x50, 0xdc },
     { 0x51, 0x3f },
     { 0x50, 0xdd },
     { 0x51, 0xff },
     { 0x50, 0xde },
     { 0x51, 0x3f },
     { 0x80, 0xdf },

So I conclude that there must be some logic that I'm not understanding. 
Could you indicate the meaning of the data in the table if there are 
any? or if I'm doing something wrong, what do I do wrong?
I have also observed that the data passing through the I2C bus are not 
always the same under Windows, there are some differences between them 
in parts.

Then I put a few fragments of what I get under Windows 7 and Linux. Not 
the entire I put because they are of a size of 200KiB.

_Under_Windows_7_

0.184315 - Start
0.268094 - b00100001 - 0x21 - 33
0.279265 - ACK
0.361182 - b00010011 - 0x13 - 19
0.372353 - NACK
0.511985 - b00100000 - 0x20 - 32
0.523156 - ACK
0.603211 - b01110000 - 0x70 - 112
0.614382 - ACK
0.698161 - b00001111 - 0x0f - 15
0.70747 - ACK
0.847102 - b00100000 - 0x20 - 32
0.858273 - ACK
0.938329 - b01110000 - 0x70 - 112
0.949499 - ACK
1.03514 - b11111111 - 0xff - 255
1.04445 - ACK
1.1785 - b00100000 - 0x20 - 32
1.18967 - ACK
1.27531 - b00001001 - 0x09 - 9
1.28648 - ACK
1.37771 - b01110100 - 0x74 - 116
1.39074 - Stop

1.5192 - b00100000 - 0x20 - 32
1.52665 - ACK
1.61415 - b01010000 - 0x50 - 80
1.62346 - ACK
1.70351 - b11010001 - 0xd1 - 209
1.71468 - ACK
1.85618 - b00100000 - 0x20 - 32
1.86549 - ACK
1.9474 - b01010001 - 0x51 - 81
1.95858 - ACK
2.0498 - b00100100 - 0x24 - 36
2.06283 - Stop

2.18943 - b00100000 - 0x20 - 32
2.2006 - ACK
2.28066 - b00111001 - 0x39 - 57
2.29183 - ACK
2.37747 - b00000000 - 0x00 - 0
2.38864 - ACK
2.532 - b00100000 - 0x20 - 32
2.54131 - ACK
2.62509 - b00101000 - 0x28 - 40
2.6344 - ACK
2.72004 - b00101010 - 0x2a - 42
2.73121 - ACK
2.8727 - b00100000 - 0x20 - 32
2.88387 - ACK
2.96951 - b00101001 - 0x29 - 41
2.97882 - ACK
3.0626 - b00000000 - 0x00 - 0
3.07191 - ACK
3.21154 - b00100000 - 0x20 - 32
3.22271 - ACK
3.30835 - b00101010 - 0x2a - 42
3.31766 - ACK
3.40144 - b11111101 - 0xfd - 253
3.41261 - ACK
3.55224 - b00100000 - 0x20 - 32
3.56342 - ACK
3.64906 - b00101011 - 0x2b - 43
3.66023 - ACK
3.74028 - b11001000 - 0xc8 - 200
3.74959 - ACK
3.90039 - b00100000 - 0x20 - 32
3.90784 - ACK
3.99162 - b00111011 - 0x3b - 59
4.00093 - ACK
4.08471 - b00100001 - 0x21 - 33
4.09588 - ACK
4.23179 - b00100000 - 0x20 - 32
4.24296 - ACK
4.32674 - b00111100 - 0x3c - 60
4.33791 - ACK
4.42355 - b00111000 - 0x38 - 56
4.43472 - ACK
4.57435 - b00100000 - 0x20 - 32
4.58552 - ACK
4.66558 - b00101000 - 0x28 - 40
4.67489 - ACK
4.75867 - b00100000 - 0x20 - 32
4.76984 - ACK
4.90947 - b00100000 - 0x20 - 32
4.91878 - ACK
5.00256 - b00101001 - 0x29 - 41
5.01373 - ACK
5.09565 - b00111110 - 0x3e - 62
5.10309 - ACK
5.24086 - b00100000 - 0x20 - 32
5.25204 - ACK
5.33768 - b00101010 - 0x2a - 42
5.34885 - ACK
5.43263 - b11011110 - 0xde - 222
5.4438 - ACK
5.58529 - b00100000 - 0x20 - 32
5.59274 - ACK
5.68024 - b00101011 - 0x2b - 43
5.68955 - ACK
5.77147 - b01001101 - 0x4d - 77
5.78078 - ACK
5.92413 - b00100000 - 0x20 - 32
5.93158 - ACK
6.01536 - b00101000 - 0x28 - 40
6.02467 - ACK
6.10845 - b00100010 - 0x22 - 34
6.11776 - ACK
6.25925 - b00100000 - 0x20 - 32
6.27042 - ACK
6.3542 - b00101001 - 0x29 - 41
6.36537 - ACK
6.45101 - b00000000 - 0x00 - 0
6.46032 - ACK
6.60181 - b00100000 - 0x20 - 32
6.61112 - ACK
6.6949 - b00101010 - 0x2a - 42
6.70235 - ACK
6.78985 - b00011111 - 0x1f - 31
6.79916 - ACK
6.94252 - b00100000 - 0x20 - 32
6.95369 - ACK
7.0356 - b00101011 - 0x2b - 43
7.04678 - ACK
7.12497 - b11110000 - 0xf0 - 240
7.13428 - ACK
7.27391 - b00100000 - 0x20 - 32
7.28508 - ACK
7.367 - b00000001 - 0x01 - 1
7.37817 - ACK
7.46195 - b00001101 - 0x0d - 13
7.47312 - ACK
7.61089 - b00100000 - 0x20 - 32
7.62206 - ACK
7.70584 - b00000100 - 0x04 - 4
7.71701 - ACK
7.79893 - b00001000 - 0x08 - 8
7.8101 - ACK
7.94973 - b00100000 - 0x20 - 32
7.95718 - ACK
8.04096 - b00000101 - 0x05 - 5
8.05213 - ACK
8.13963 - b00000110 - 0x06 - 6
8.15452 - Stop
-----------------------------------------

_Under_Linux_

0.268594 - Start
0.358125 - b00100000 - 0x20 - 32
0.367451 - ACK
0.447656 - b01110000 - 0x70 - 112
0.456982 - ACK
0.548379 - b11111111 - 0xff - 255
0.55957 - ACK
0.686406 - b00100000 - 0x20 - 32
0.697597 - ACK
0.781533 - b00001000 - 0x08 - 8
0.790859 - NACK
0.871064 - b00000001 - 0x01 - 1
0.882256 - ACK
0.966191 - b10000011 - 0x83 - 131
0.975517 - ACK
1.1695 - b00100000 - 0x20 - 32
1.18069 - ACK
1.25903 - b01010001 - 0x51 - 81
1.26836 - ACK
1.36162 - b00100010 - 0x22 - 34
1.37095 - ACK
1.49778 - b00100000 - 0x20 - 32
1.50897 - ACK
1.58731 - b00111001 - 0x39 - 57
1.59851 - ACK
1.69363 - b00000000 - 0x00 - 0
1.70482 - ACK
1.84099 - b00100000 - 0x20 - 32
1.85218 - ACK
1.92865 - b00101000 - 0x28 - 40
1.93984 - ACK
2.0331 - b00101010 - 0x2a - 42
2.0443 - ACK
2.17859 - b00100000 - 0x20 - 32
2.18792 - ACK
2.26626 - b00101001 - 0x29 - 41
2.27745 - ACK
2.36885 - b00000000 - 0x00 - 0
2.37631 - ACK
2.50874 - b00100000 - 0x20 - 32
2.51993 - ACK
2.60014 - b00101010 - 0x2a - 42
2.61133 - ACK
2.70086 - b11111101 - 0xfd - 253
2.71205 - ACK
2.84448 - b00100000 - 0x20 - 32
2.85567 - ACK
2.93588 - b00101011 - 0x2b - 43
2.94707 - ACK
3.0366 - b11001000 - 0xc8 - 200
3.04779 - ACK
3.18209 - b00100000 - 0x20 - 32
3.19142 - ACK
3.27162 - b00111011 - 0x3b - 59
3.28281 - ACK
3.36861 - b00100001 - 0x21 - 33
3.37794 - ACK
3.51783 - b00100000 - 0x20 - 32
3.52902 - ACK
3.60736 - b00111100 - 0x3c - 60
3.61855 - ACK
3.70995 - b00111000 - 0x38 - 56
3.72114 - ACK
3.8573 - b00100000 - 0x20 - 32
3.86663 - ACK
3.94497 - b00101000 - 0x28 - 40
3.95616 - ACK
4.04756 - b00100000 - 0x20 - 32
4.05875 - ACK
4.19305 - b00100000 - 0x20 - 32
4.20424 - ACK
4.28444 - b00101001 - 0x29 - 41
4.31056 - ACK
4.39263 - b01111100 - 0x7c - 124
4.40382 - Stop

---------------------------------------


In the next letter, if you let me, I'll cut the old text, because I 
guess we're back on topic and not too heavy (KB) message.


Thank you very much in advance,

Alfredo


>>>
>>> You'll find some examples of such patches at:
>>> http://git.linuxtv.org/v4l-utils.git/tree/fd35e2fdc85fa6a9dcd45ce2dd7c322bcda6e93e:/contrib 
>>>
>>>
>>> In the case of the PCI device I was sniffing, I used this parser:
>>> http://git.linuxtv.org/v4l-utils.git/blob/fd35e2fdc85fa6a9dcd45ce2dd7c322bcda6e93e:/contrib/saa7134/parse_saa7134.pl 
>>>
>>>
>
> I hope I have misunderstood, because otherwise I can not do it, 
> because to use qemu-kvm is required hardware that supports IOMMU and 
> mine does not support it (Phenom_1 and chipset 780G and SB700).
>
>  # modprobe pci_stub
>  # echo "14f1 8852" > /sys/bus/pci/drivers/pci-stub/new_id
>  # echo "0000:02:00.0" > /sys/bus/pci/devices/0000:02:00.0/driver/unbind
>  # echo "0000:02:00.0" > /sys/bus/pci/drivers/pci-stub/bind
> # qemu-kvm -name "windows-7" -M pc-1.1 -m 2048 -vga cirrus -drive 
> file=/var/lib/qemu/images/windows/hda.img -device pci-assign,host=02:00.0
> Warning: default mac address being used, creating potential for 
> address conflict
> No IOMMU found.  Unable to assign device "(null)"
> qemu-kvm: -device pci-assign,host=02:00.0: Device 'pci-assign' could 
> not be initialized
>
>
> Hardware that supports IOMMU is very new and limited.
>
>
> Is there any other known way to do this?
>
>
>>> That produces something like:
>>>
>>> write_i2c_addr(0x10, 3, { 0x70, 0x0f, 0x00});
>>> write_i2c_addr(0x10, 3, { 0x70, 0xff, 0x00});
>>> write_i2c_addr(0x10, 3, { 0x08, 0x01, 0x00});
>>> write_i2c_addr(0x10, 3, { 0x09, 0x3e, 0x00});
>>> write_i2c_addr(0x10, 3, { 0x50, 0xd1, 0x00});
>>> write_i2c_addr(0x10, 3, { 0x51, 0x22, 0x00});
>>> write_i2c_addr(0x10, 3, { 0x39, 0x01, 0x00});
>>> write_i2c_addr(0x10, 3, { 0x71, 0x00, 0x00});
>>> write_i2c_addr(0x10, 3, { 0x28, 0x2a, 0x00});
>>> write_i2c_addr(0x10, 3, { 0x29, 0x00, 0x00});
>>> write_i2c_addr(0x10, 3, { 0x2a, 0xff, 0x00});
>>> write_i2c_addr(0x10, 3, { 0x2b, 0x80, 0x00});
>>> write_i2c_addr(0x10, 3, { 0x28, 0x20, 0x00});
>>> write_i2c_addr(0x10, 3, { 0x29, 0x33, 0x00});
>>> write_i2c_addr(0x10, 3, { 0x2a, 0xdf, 0x00});
>>> write_i2c_addr(0x10, 3, { 0x2b, 0xa9, 0x00});
>>> write_i2c_addr(0x10, 3, { 0x3b, 0x21, 0x00});
>>> write_i2c_addr(0x10, 3, { 0x3c, 0x3a, 0x00});
>>> write_i2c_addr(0x10, 3, { 0x01, 0x0d, 0x00});
>>> write_i2c_addr(0x10, 3, { 0x04, 0x08, 0x00});
>>> write_i2c_addr(0x10, 3, { 0x05, 0x05, 0x00});
>>> write_i2c_addr(0x10, 3, { 0x04, 0x0e, 0x00});
>>> write_i2c_addr(0x10, 3, { 0x05, 0x00, 0x00});
>>> ...
>>>
>>> By comparing it with the device init at mb86a20s, we can see if this
>>> particular device is doing something different and improve the 
>>> driver to
>>> also handle your device.
>>>
>>>>
>>>>
>>>>> So, all you need is to attach both mb86a20s and xc5000 on it, and 
>>>>> set the
>>>>> proper GPIO's.
>>>> I think I'm doing well
>>>>
>>>>       case CX23885_BOARD_MYGICA_X8506:
>>>>       case CX23885_BOARD_MYGICA_X8507:
>>>>       case CX23885_BOARD_MAGICPRO_PROHDTVE2:
>>>>           /* Select Digital TV */
>>>>           cx23885_gpio_set(dev, GPIO_0);
>>>>           break;
>>>>
>>>> X8508 and X8507 is the same card, just change the digital part.
>>>>
>>>> The driver for windows says:
>>>>
>>>> X8507 means X8502
>>>> _________________________________________________________________________________________ 
>>>>
>>>> [X8502.AddReg]
>>>>
>>>> HKR,"DriverData","TunerModel",0x00010001, 0x03,0x00,0x00,0x00
>>>>
>>>> ;Enable TS capture and BDA filter registration
>>>> HKR,"DriverData","Enable_BDA",0x00010001, 0x01, 0x00, 0x00, 0x00
>>>> HKR,"DriverData","BDA_Demod_Tuner_type",0x00010001, 0x02, 0x00, 
>>>> 0x00, 0x00
>>>> HKR,"DriverData","DemodI2CAddress",0x00010001, 0x1E, 0x00, 0x00, 0x00
>>>> ; this registry keys for the FixNMI option which takes care of the 
>>>> BSODs
>>>> in the
>>>> ; ICH6/7 chipsets
>>>> HKR,"DriverData","FixNMIBit",0x00010001, 0x00,0x00,0x00,0x00
>>>> ;IR Support
>>>> HKR,"DriverData","EnableIR",0x00010001, 0x01, 0x00, 0x00, 0x00
>>>> ;NEC standard
>>>> HKR,"DriverData","IRStandard",0x00010001, 0x01, 0x00, 0x00, 0x00
>>>> ; GPIO Pin values
>>>> HKR,"DriverData","mode_select_gpio_bit", 0x00010001, 0x00, 0x00, 
>>>> 0x00, 0x00
>>>> HKR,"DriverData","tuner_reset_gpio_bit", 0x00010001, 0x01, 0x00, 
>>>> 0x00, 0x00
>>>> HKR,"DriverData","demod_reset_gpio_bit", 0x00010001, 0x02, 0x00, 
>>>> 0x00, 0x00
>>>> HKR,"DriverData","tuner_sif_fm_gpio_bit",0x00010001, 0x03, 0x00, 
>>>> 0x00, 0x00
>>>> HKR,"DriverData","comp_select_gpio_bit", 0x00010001, 0xff, 0x00, 
>>>> 0x00, 0x00
>>> You need to double-check if all the above GPIO's are properly 
>>> initialized.
>>>
>>> Again, the PCI traffic dump can help you to confirm if you should 
>>> either set
>>> or reset the above bits.
>>>
>>>> HKR,"DriverData","comp_select_panel", 0x00010001, 0xff, 0x00, 0x00, 
>>>> 0x00
>>>>
>>>> ;Demod Comm mode : 0x00 = Serial, 0x01 = Parallel
>>>> HKR,"DriverData","DemodTransferMode",0x00010001, 0x01, 0x00, 0x00, 
>>>> 0x00
>>>>
>>>> ;BoardType Sonora353 = 0x03
>>>> HKR,"DriverData","BoardType",0x00010001, 0x13, 0x00, 0x00, 0x00
>>>> HKR,"DriverData","VideoStandard",0x00010001, 0x10,0x00,0x00,0x00
>>>> ___________________________________________________________________________________ 
>>>>
>>>>
>>>> [X8506.AddReg]
>>>>
>>>> HKR,"DriverData","TunerModel",0x00010001, 0x03,0x00,0x00,0x00
>>>>
>>>> ;Enable TS capture and BDA filter registration
>>>> HKR,"DriverData","Enable_BDA",0x00010001, 0x01, 0x00, 0x00, 0x00
>>>> HKR,"DriverData","BDA_Demod_Tuner_type",0x00010001, 0x01, 0x00, 
>>>> 0x00, 0x00
>>>> HKR,"DriverData","DemodI2CAddress",0x00010001, 0x1E, 0x00, 0x00, 0x00
>>>> ; this registry keys for the FixNMI option which takes care of the 
>>>> BSODs
>>>> in the
>>>> ; ICH6/7 chipsets
>>>> HKR,"DriverData","FixNMIBit",0x00010001, 0x00,0x00,0x00,0x00
>>>> ;IR Support
>>>> HKR,"DriverData","EnableIR",0x00010001, 0x01, 0x00, 0x00, 0x00
>>>> ;NEC standard
>>>> HKR,"DriverData","IRStandard",0x00010001, 0x01, 0x00, 0x00, 0x00
>>>> ; GPIO Pin values
>>>> HKR,"DriverData","mode_select_gpio_bit", 0x00010001, 0x00, 0x00, 
>>>> 0x00, 0x00
>>>> HKR,"DriverData","tuner_reset_gpio_bit", 0x00010001, 0x01, 0x00, 
>>>> 0x00, 0x00
>>>> HKR,"DriverData","demod_reset_gpio_bit", 0x00010001, 0x02, 0x00, 
>>>> 0x00, 0x00
>>>> HKR,"DriverData","tuner_sif_fm_gpio_bit",0x00010001, 0x03, 0x00, 
>>>> 0x00, 0x00
>>>> HKR,"DriverData","comp_select_gpio_bit", 0x00010001, 0xff, 0x00, 
>>>> 0x00, 0x00
>>>> HKR,"DriverData","comp_select_panel",    0x00010001, 0xff, 0x00, 
>>>> 0x00, 0x00
>>>>
>>>> ;Demod Comm mode : 0x00 = Serial, 0x01 = Parallel
>>>> HKR,"DriverData","DemodTransferMode",0x00010001, 0x01, 0x00, 0x00, 
>>>> 0x00
>>>>
>>>> ;BoardType Sonora353 = 0x03
>>>> HKR,"DriverData","BoardType",0x00010001, 0x0e, 0x00, 0x00, 0x00
>>>> HKR,"DriverData","VideoStandard",0x00010001, 0x10,0x00,0x00,0x00
>>>> ______________________________________________________________________________________ 
>>>>
>>>>
>>>>
>>>> there is only change in:
>>>>
>>>> HKR,"DriverData","BDA_Demod_Tuner_type",0x00010001, 0x01, 0x00, 
>>>> 0x00, 0x00
>>>>
>>>> and
>>>>
>>>> HKR,"DriverData","BoardType",0x00010001, 0x0e, 0x00, 0x00, 0x00
>>> I see your point. Yeah, both devices look similar.
>>>
>>>>> It will call fe->ops.tuner_ops.set_params(fe) inside the 
>>>>> set_frontend() fops
>>>>> logic, in order to tune the device, but this is the same thing as
>>>>> zl10353_set_parameters does.
>>>> I expected something like this:
>>>>
>>>>   From zl10353, page 12:
>>>>
>>>> 3.1.2
>>>>    Tuner
>>>> The ZL10353 has a General Purpose Port that can be configured to 
>>>> provide
>>>> a secondary 2-wire bus. See register
>>>> GPP_CTL address 0x8C.
>>>> Master control mode is selected by setting register SCAN_CTL (0x62) 
>>>> [b3]
>>>> = 1.
>>>>
>>>>   From V4L driver, zl10353.c
>>>>
>>>> static int zl10353_i2c_gate_ctrl(struct dvb_frontend* fe, int enable)
>>>> {
>>>>       struct zl10353_state *state = fe->demodulator_priv;
>>>>       u8 val = 0x0a;
>>>>
>>>>       if (state->config.disable_i2c_gate_ctrl) {
>>>>           /* No tuner attached to the internal I2C bus */
>>>>           /* If set enable I2C bridge, the main I2C bus stopped 
>>>> hardly */
>>>>           return 0;
>>>>       }
>>>>
>>>>       if (enable)
>>>>           val |= 0x10;
>>>>
>>>>       return zl10353_single_write(fe, 0x62, val);
>>>>
>>>>
>>>> Maybe I'm misunderstanding the code.
>>> Yeah, but mb86a20s driver currently doesn't have any similar logic, as
>>> no devices I'm aware have the tuner connected to its I2C gate.
>>>
>>>> When I do notknow the pins of integrated circuits I can not measure 
>>>> the
>>>> state of the GPIO.
>>>>>> Please, could you tell me if I'm reasoning correctly?
>>>>>>
>>>>>>
>>>>>> Using RegSpy I see the bus 0 alternately accesses to addresses 
>>>>>> 0x20 and
>>>>>> 0x66under Windows 7. In Windows XP only accessed to 0x20 and when 
>>>>>> the pc
>>>>>> starts to 0xa0.
>>>>>>
>>>>>> Bus 2 (internal) always accesse to 0x88
>>>>>>
>>>>>> The bus 0 and 2 (internal) access to the address 0x66 (according
>>>>>> modprobe cx23885 i2c_scan), What's there?
>>>>> Maybe a remote controller? Do you have a high-resolution picture 
>>>>> of the
>>>>> board?
>
> Here I have placed a photo in high resolution:
>
> http://linuxtv.org/wiki/index.php/File:MyGica_X8507_Hi_Resolution.jpg
> http://linuxtv.org/wiki/index.php/File:MyGica_X8507_3648x2736.JPG
>
> Again, thank you very much
>
> Alfredo
>
>
>>>> Do not know if I can be the remote, but only does so under windows7 
>>>> bus
>>>> 0 accesses the address 0x66.
>>>> Under Windows XP does not access the bus 0 to address 0x66.
>>> Please notice that we prefer to use the 7-bits notation for I2C 
>>> addresses,
>>> as this is the one used on the original Philips I2C datasheet. So, 
>>> we call
>>> it as 0x33 ;)
>>
>> OK.
>>
>>>
>>> Maybe you need to call a separate program for IR handling on Windows 
>>> XP.
>>> At least, I've seen several WinXP setups that have a separate 
>>> program to
>>> handle remotes.
>> Yes, but uses different software on both Windows XP and 7
>>
>>>> I have no photos in high resolution, but I can get a camera if it 
>>>> helps
>>>> you to help me.
>>>>
>>>>
>>>> Here are photos in low resolution:
>>>>
>>>> http://www.linuxtv.org/wiki/index.php/Geniatech/MyGica_X8507_PCI-Express_Hybrid_Card 
>>>>
>>> I couldn't identify there the small chips on it. If this device has an
>>> I2C device for IR, it is likely one small microcontroller chip.
>>
>> In Linux did not need any extra configuration:
>> http://patchwork.linuxtv.org/patch/15412/
>>
>> For now I owe it, I will upload higher resolution photos when I have 
>> a camera.
>> With my eyes I fail to read the small chips, and that they still look 
>> okay.
>>
>> Thank you very much.
>>
>> Alfredo
>> -- 
>> To unsubscribe from this list: send the line "unsubscribe 
>> linux-media" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at http://vger.kernel.org/majordomo-info.html
>
> -- 
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

