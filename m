Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx2.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m8HFBkgo011735
	for <video4linux-list@redhat.com>; Wed, 17 Sep 2008 11:11:46 -0400
Received: from ug-out-1314.google.com (ug-out-1314.google.com [66.249.92.174])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m8HFBVlS008374
	for <video4linux-list@redhat.com>; Wed, 17 Sep 2008 11:11:35 -0400
Received: by ug-out-1314.google.com with SMTP id o38so427174ugd.13
	for <video4linux-list@redhat.com>; Wed, 17 Sep 2008 08:11:30 -0700 (PDT)
Message-ID: <48D11E1E.3050902@gmail.com>
Date: Wed, 17 Sep 2008 17:11:26 +0200
From: eli hamels <eli.hamels@gmail.com>
MIME-Version: 1.0
To: Markus Rechberger <mrechberger@gmail.com>
References: <48CFE85B.8050407@gmail.com>
	<d9def9db0809161033r6a73c67dg5746fc2d05cf694@mail.gmail.com>
In-Reply-To: <d9def9db0809161033r6a73c67dg5746fc2d05cf694@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: video4linux-list@redhat.com, em28xx@mcentral.de
Subject: Re: Geniatech UTV3
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

Markus Rechberger wrote:
> On Tue, Sep 16, 2008 at 7:09 PM, eli hamels <eli.hamels@gmail.com> wrote:
>   
>> Hi all,
>>
>> I  have a Geniatech UTV3 usb tv box that didn't worked on linux.
>>
>> After taking the device apart, I found following components
>> * FM24C02   -> EEPROM
>> * EM2860      -> USB Video Capture Device
>> * SAA7113H  -> Video input processor
>> * TOA9801    -> Demodulator and FM-PLL detector (for sound)
>> * HCF4052   -> Analog multiplexer (for switching sound between TV and AV)
>> * TNF8337-DFD -> TV tuner/reciever
>>
>> After I insmoded the em28xx,the device was detected as the
>> EM2860_BOARD_TYPHOON_DVD_MAKER??
>> I figured out the "TYPHOON_DVD_MAKER" and my Geniatech UTV3 must have the
>> same Vendor/Product ID.
>>
>> #lsusb
>> Bus 004 Device 012: ID eb1a:2860 eMPIA Technology, Inc.
>>
>> I guess somebody has to change the detection system to handle different
>> devices with the same Vendor/Product ID.
>>
>> I had to make some modifications to the em28xx driver in order to get the
>> Geniatech device working.
>> I changed the EM2860_BOARD_TYPHOON_DVD_MAKER struct in em28xx-cards.c to the
>> following:
>>
>> [EM2860_BOARD_TYPHOON_DVD_MAKER] = {
>>       .name             = "Geniatech UTV3",
>>       .vchannels      = 2,
>>       .tuner_type    = TUNER_TNF_5335MF,
>>       .has_tuner      = 1,
>>       .norm              = V4L2_STD_PAL_BG,
>>       .decoder         = EM28XX_SAA7113,
>>       .dev_modes    = EM28XX_VIDEO,
>>       .input             = {{
>>           .type     = EM28XX_VMUX_TELEVISION,
>>           .vmux    = SAA7115_COMPOSITE2,
>>           .amux    = 0,
>>       },{
>>           .type     = EM28XX_VMUX_COMPOSITE1,
>>           .vmux    = SAA7115_COMPOSITE0,
>>           .amux    = 1,
>>       }},
>>       .tvnorms    = {{
>>               .name = "PAL-BG",
>>               .id = V4L2_STD_PAL_BG,
>>           },{
>>               .name = "PAL-DK",
>>               .id = V4L2_STD_PAL_DK,
>>           },{
>>               .name = "PAL-I",
>>               .id = V4L2_STD_PAL_I,
>>           },{
>>               .name = "PAL-M",
>>               .id = V4L2_STD_PAL_M,
>>           },{
>>               .name = "NTSC",
>>               .id = V4L2_STD_NTSC,
>>       }},
>> },
>>
>> I know this isn't a 'proper' solution, but it's fine for me.
>>
>> The tuner isn't actually a TVF58t5-MFF, it is an SN761678.
>> (the SN761678 is located inside the TNF8337-DFD)
>>
>> After compiling and reloading the em28xx driver, the geniatech device was
>> properly detected.
>> #dmesg
>> [32985.830259] em28xx v4l2 driver version 0.0.1 loaded
>> [32985.830728] em28xx new video device (eb1a:2860): interface 0, class 255
>> [32985.830741] em28xx: device is attached to a USB 2.0 bus
>> [32985.830744] em28xx: you're using the experimental/unstable tree from
>> mcentral.de
>> [32985.830746] em28xx: there's also a stable tree available but which is
>> limited to
>> [32985.830749] em28xx: linux <=2.6.19.2
>> [32985.830750] em28xx: it's fine to use this driver but keep in mind that it
>> will move
>> [32985.830752] em28xx: to http://mcentral.de/hg/~mrec/v4l-dvb-kernel as soon
>> as it's
>> [32985.830754] em28xx: proved to be stable
>> [32985.832682] em28xx #0: Alternate settings: 8
>> [32985.832694] em28xx #0: Alternate setting 0, max size= 0
>> [32985.832696] em28xx #0: Alternate setting 1, max size= 0
>> [32985.832698] em28xx #0: Alternate setting 2, max size= 1448
>> [32985.832701] em28xx #0: Alternate setting 3, max size= 2048
>> [32985.832703] em28xx #0: Alternate setting 4, max size= 2304
>> [32985.832705] em28xx #0: Alternate setting 5, max size= 2580
>> [32985.832708] em28xx #0: Alternate setting 6, max size= 2892
>> [32985.832710] em28xx #0: Alternate setting 7, max size= 3072
>> [32985.936456] tuner 2-0061: I2C RECV = 7c 7c 7c 7c 7c 7c 7c 7c 7c 7c 7c 7c
>> 7c 7c 7c 7c
>> [32985.936473] Tunder detected
>> [32985.936476] tuner 2-0061: chip found @ 0xc2 (em28xx #0)
>> [32985.936537] attach inform (default): detected I2C address c2
>> [32985.936543] tuner 0x61: Configuration acknowledged
>> [32985.936550] tuner 2-0061: type set to 69 (Tena TNF 5335 and similar
>> models)
>> [32985.963697] saa7115 2-0025: saa7113 found (1f7113d0e100000) @ 0x4a
>> (em28xx #0)
>> [32985.993604] attach_inform: saa7113 detected.
>> [32985.996353] attach_inform: eeprom detected.
>> [32986.023303] em28xx #0: i2c eeprom 00: 1a eb 67 95 1a eb 60 28 c0 00 3e 01
>> 6a 22 00 00
>> [32986.023320] em28xx #0: i2c eeprom 10: 00 00 04 57 4e 03 00 00 60 c0 60 c0
>> 02 02 02 02
>> [32986.023331] em28xx #0: i2c eeprom 20: 16 00 00 02 f0 10 02 00 4a 00 00 00
>> 5b 00 00 00
>> [32986.023341] em28xx #0: i2c eeprom 30: 00 00 20 40 20 80 02 20 10 01 02 01
>> 00 00 00 00
>> [32986.023352] em28xx #0: i2c eeprom 40: 00 00 00 00 00 00 00 00 00 00 00 00
>> 00 00 00 00
>> [32986.023362] em28xx #0: i2c eeprom 50: 00 00 00 00 00 00 00 00 00 00 00 00
>> 00 00 00 00
>> [32986.023373] em28xx #0: i2c eeprom 60: 00 00 00 00 00 00 00 00 00 00 22 03
>> 55 00 53 00
>> [32986.023383] em28xx #0: i2c eeprom 70: 42 00 20 00 32 00 38 00 36 00 30 00
>> 20 00 44 00
>> [32986.023394] em28xx #0: i2c eeprom 80: 65 00 76 00 69 00 63 00 65 00 00 00
>> 00 00 00 00
>> [32986.023404] em28xx #0: i2c eeprom 90: 00 00 00 00 00 00 00 00 00 00 00 00
>> 00 00 00 00
>> [32986.023415] em28xx #0: i2c eeprom a0: 00 00 00 00 00 00 00 00 00 00 00 00
>> 00 00 00 00
>> [32986.023425] em28xx #0: i2c eeprom b0: 00 00 00 00 00 00 00 00 00 00 00 00
>> 00 00 00 00
>> [32986.023436] em28xx #0: i2c eeprom c0: 00 00 00 00 00 00 00 00 00 00 00 00
>> 00 00 00 00
>> [32986.023446] em28xx #0: i2c eeprom d0: 00 00 00 00 00 00 00 00 00 00 00 00
>> 00 00 00 00
>> [32986.023456] em28xx #0: i2c eeprom e0: 00 00 00 00 00 00 00 00 00 00 00 00
>> 00 00 00 00
>> [32986.023467] em28xx #0: i2c eeprom f0: 00 00 00 00 00 00 00 00 00 00 00 00
>> 00 00 00 00
>> [32986.023477] EEPROM ID= 0x9567eb1a
>> [32986.023479] Vendor/Product ID= eb1a:2860
>> [32986.023481] No audio on board.
>> [32986.023482] 500mA max power
>> [32986.023485] Table at 0x04, strings=0x226a, 0x0000, 0x0000
>> [32986.040701] em28xx #0: V4L2 device registered as /dev/video0
>> [32986.040713] em28xx #0: Found Geniatech UTV3
>> [32986.040748] usbcore: registered new interface driver em28xx
>>
>> With this new configuration I'm able to watch TV using xawtv.
>> Only the sound wasn't working.
>>
>> The sound isn't available through the usb connection(like the driver said),
>> but it goes out by a audio jack connector.
>>
>> After a while a discovered that the em28xx didn't controlled the multiplexer
>> (HCF4052).
>> The multiplexer is used to switch between the sound of the TV and the sound
>> of the AV.
>> In oder to get sound out of the audio connector the following configuration
>> has to applied to the multiplexer
>>        A         B
>> TV:    1          0
>> AV:    0          0
>> Other combinations give no output.
>>
>> The multiplexer is connected by pin 10(A) and 9(B) to the em2860 by pin
>> 27(PIO0) and 28(PIO1).
>> During the use of the em28xx driver the PIO0 and PIO1 are 3.3V, thus
>> resulting no sound.
>> The PIO's of the em2860 are probably configured as input, and are pulled up
>> to 3.3V
>>
>> As a temporarily solution I lifted pin 9(B) from the multiplexer and
>> connected it to GND.
>> This way I can listen and watch to the TV.
>>
>> I hope that this contribution can help to the further development of the
>> em28xx driver.
>>
>>     
>
> can you submit the usbview output? depends what this device is set to
> in order to get
> audio through the digital link.
>
> Markus
>   

Markus,

The sound goes only by the external audio jack, even in "windows".
In order to play audio through your PC speakers, the device comes with 
an extra cable.
Witch you should connect to the line-in of the PC's audio card.

Anyway, here is the usbview output.

USB 2860 Device
Speed: 480Mb/s (high)
USB Version:  2.00
Device Class: 00(>ifc )
Device Subclass: 00
Device Protocol: 00
Maximum Default Endpoint Size: 64
Number of Configurations: 1
Vendor Id: eb1a
Product Id: 2860
Revision Number:  1.00

Config Number: 1
    Number of Interfaces: 1
    Attributes: 80
    MaxPower Needed: 500mA

    Interface Number: 0
        Name: em28xx
        Alternate Number: 0
        Class: ff(vend.)
        Sub Class: 00
        Protocol: ff
        Number of Endpoints: 3

            Endpoint Address: 81
            Direction: in
            Attribute: 3
            Type: Int.
            Max Packet Size: 1
            Interval: 128ms

            Endpoint Address: 82
            Direction: in
            Attribute: 1
            Type: Isoc
            Max Packet Size: 0
            Interval: 125us

            Endpoint Address: 84
            Direction: in
            Attribute: 1
            Type: Isoc
            Max Packet Size: 0
            Interval: 125us

    Interface Number: 0
        Name: em28xx
        Alternate Number: 1
        Class: ff(vend.)
        Sub Class: 00
        Protocol: ff
        Number of Endpoints: 3

            Endpoint Address: 81
            Direction: in
            Attribute: 3
            Type: Int.
            Max Packet Size: 1
            Interval: 128ms

            Endpoint Address: 82
            Direction: in
            Attribute: 1
            Type: Isoc
            Max Packet Size: 0
            Interval: 125us

            Endpoint Address: 84
            Direction: in
            Attribute: 1
            Type: Isoc
            Max Packet Size: 0
            Interval: 125us

    Interface Number: 0
        Name: em28xx
        Alternate Number: 2
        Class: ff(vend.)
        Sub Class: 00
        Protocol: ff
        Number of Endpoints: 3

            Endpoint Address: 81
            Direction: in
            Attribute: 3
            Type: Int.
            Max Packet Size: 1
            Interval: 128ms

            Endpoint Address: 82
            Direction: in
            Attribute: 1
            Type: Isoc
            Max Packet Size: 1448
            Interval: 125us

            Endpoint Address: 84
            Direction: in
            Attribute: 1
            Type: Isoc
            Max Packet Size: 0
            Interval: 125us

    Interface Number: 0
        Name: em28xx
        Alternate Number: 3
        Class: ff(vend.)
        Sub Class: 00
        Protocol: ff
        Number of Endpoints: 3

            Endpoint Address: 81
            Direction: in
            Attribute: 3
            Type: Int.
            Max Packet Size: 1
            Interval: 128ms

            Endpoint Address: 82
            Direction: in
            Attribute: 1
            Type: Isoc
            Max Packet Size: 2048
            Interval: 125us

            Endpoint Address: 84
            Direction: in
            Attribute: 1
            Type: Isoc
            Max Packet Size: 0
            Interval: 125us

    Interface Number: 0
        Name: em28xx
        Alternate Number: 4
        Class: ff(vend.)
        Sub Class: 00
        Protocol: ff
        Number of Endpoints: 3

            Endpoint Address: 81
            Direction: in
            Attribute: 3
            Type: Int.
            Max Packet Size: 1
            Interval: 128ms

            Endpoint Address: 82
            Direction: in
            Attribute: 1
            Type: Isoc
            Max Packet Size: 2304
            Interval: 125us

            Endpoint Address: 84
            Direction: in
            Attribute: 1
            Type: Isoc
            Max Packet Size: 0
            Interval: 125us

    Interface Number: 0
        Name: em28xx
        Alternate Number: 5
        Class: ff(vend.)
        Sub Class: 00
        Protocol: ff
        Number of Endpoints: 3

            Endpoint Address: 81
            Direction: in
            Attribute: 3
            Type: Int.
            Max Packet Size: 1
            Interval: 128ms

            Endpoint Address: 82
            Direction: in
            Attribute: 1
            Type: Isoc
            Max Packet Size: 2580
            Interval: 125us

            Endpoint Address: 84
            Direction: in
            Attribute: 1
            Type: Isoc
            Max Packet Size: 0
            Interval: 125us

    Interface Number: 0
        Name: em28xx
        Alternate Number: 6
        Class: ff(vend.)
        Sub Class: 00
        Protocol: ff
        Number of Endpoints: 3

            Endpoint Address: 81
            Direction: in
            Attribute: 3
            Type: Int.
            Max Packet Size: 1
            Interval: 128ms

            Endpoint Address: 82
            Direction: in
            Attribute: 1
            Type: Isoc
            Max Packet Size: 2892
            Interval: 125us

            Endpoint Address: 84
            Direction: in
            Attribute: 1
            Type: Isoc
            Max Packet Size: 0
            Interval: 125us

    Interface Number: 0
        Name: em28xx
        Alternate Number: 7
        Class: ff(vend.)
        Sub Class: 00
        Protocol: ff
        Number of Endpoints: 3

            Endpoint Address: 81
            Direction: in
            Attribute: 3
            Type: Int.
            Max Packet Size: 1
            Interval: 128ms

            Endpoint Address: 82
            Direction: in
            Attribute: 1
            Type: Isoc
            Max Packet Size: 3072
            Interval: 125us

            Endpoint Address: 84
            Direction: in
            Attribute: 1
            Type: Isoc
            Max Packet Size: 0
            Interval: 125us


Greets,
Eli

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
