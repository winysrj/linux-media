Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m6H7VtrF021012
	for <video4linux-list@redhat.com>; Thu, 17 Jul 2008 03:31:56 -0400
Received: from cicero3.cybercity.dk (cicero3.cybercity.dk [212.242.43.248])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m6H7VenZ013808
	for <video4linux-list@redhat.com>; Thu, 17 Jul 2008 03:31:40 -0400
Message-ID: <487EF54E.8040704@b4net.dk>
Date: Thu, 17 Jul 2008 09:31:26 +0200
From: Per Baekgaard <baekgaard@b4net.dk>
MIME-Version: 1.0
To: hermann pitton <hermann-pitton@arcor.de>, video4linux-list@redhat.com
References: <487E7238.7030003@b4net.dk>
	<1216252071.2669.56.camel@pc10.localdom.local>
In-Reply-To: <1216252071.2669.56.camel@pc10.localdom.local>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: 
Subject: Re: Seeking help for a 713x based card
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

Hi Hermann,

Thanks for the quick reply.

You wrote:
> Hi Per,
>
> Am Donnerstag, den 17.07.2008, 00:12 +0200 schrieb Per Baekgaard:
>   
>> I have a card of unknown (to me) brand that identifies itself as a 
>> 1131:7133 (chipset) with 1a7f:2004 rev d1 as the subsystem ID/revision.
>>     
>
> 1131:7133 in .dk means a saa7135 or more likely a recent saa7131e.
> The subvendor 1a7f seems to be seen the first time here, subdevice 2004
> is only known on some Philips reference designs.
>   
There is a windows driver that comes with the system. Inspecting the 
3xhybrid.inf file reveals only tiny bits more information to me. Appears 
copyrighted by Philips Semi and is labelled "SAA713x Based - BDA TV 
Capture Driver" with a random provider name "Active Development Co., Ltd.".

Cards in the series are apparently called "Mercur, Tiger", "Proteus", 
"Europa (1-3), Snake, Tough, Smart, Clever" and "Europe (4.x)"

Some parts here:

;******** Proteus ***
;%PHILIPS_30.DeviceDesc% = 
PHILIPS_PROTEUS.NTx86,PCI\VEN_1131&DEV_7130&SUBSYS_20011A7F
;%PHILIPS_33.DeviceDesc% = 
PHILIPS_PROTEUS.NTx86,PCI\VEN_1131&DEV_7133&SUBSYS_20011A7F
;%PHILIPS_34.DeviceDesc% = 
PHILIPS_PROTEUS.NTx86,PCI\VEN_1131&DEV_7134&SUBSYS_20011A7F

;******** PHILIPS PROTEUS x32 ***
[PHILIPS_PROTEUS.NTx86.CoInstallers]
CopyFiles     = SectionX32.CopyDll.NTx86
AddReg        = SectionX32.DllAddReg.NTx86
 
[PHILIPS_PROTEUS.NTx86]
Include       = ks.inf, wdmaudio.inf, kscaptur.inf, bda.inf
Needs         = KS.Registration.NT, WDMAUDIO.Registration.NT, 
KSCAPTUR.Registration.NT, BDA.Installation.NT
CopyFiles     = SectionX32.CopyDriver.NTx86, SectionX32.CopyDll.NTx86
AddReg        = SectionX32.AddReg.NTx86, PHILIPS_PROTEUS.AddReg
 
[PHILIPS_PROTEUS.NTx86.Services]
AddService    = %SERVICE_NAME_X32%, 0x00000002, 
SectionX32.ServiceInstall.NTx86

;---- Proteus ----
[PHILIPS_PROTEUS.AddReg]
; Prefix will be displayed in front of the device name on every filter
HKR, "Parameters","Prefix",,%PHILIPS_CUSTOM_TUNERNAME%
 
; SmallXBar=0: XBar inputs => Tuner, Composite1, S-Video1, Composite2, 
S-Video2
; SmallXBar=1: XBar inputs => Tuner, Composite1, S-Video1
HKR, "Parameters", "SmallXBar",0x00010001,1
 
HKR, "I2C Devices", "Force Registry Settings",0x00010001,0x01
HKR, "VideoDecoder", "Tuner Channel",0x00010001,0x01
HKR, "VideoDecoder", "CVBS Channel",0x00010001,0x00
HKR, "VideoDecoder", "SVHS Channel",0x00010001,0x06
;HKR, "VideoDecoder", "FM Radio Channel",0x00010001,0x00
 
HKR, "AudioDecoder", "Tuner Channel",0x00010001,0x01
HKR, "AudioDecoder", "CVBS Channel",0x00010001,0x02
HKR, "AudioDecoder", "SVHS Channel",0x00010001,0x02
;HKR, "AudioDecoder", "FM Radio Channel",0x00010001,0x02
;HKR, "AudioDecoder", "XTAL",0x00010001,0x0                ;Default = 32MHz
 
HKR, "I2C Devices", "Number of I2C Devices",0x00010001,0x01
HKR, "I2C Devices", "Device 0, Data1",0x00010001,0x03  ; Tuner ID
HKR, "I2C Devices", "Device 0, Data2",0x00010001,0xC0  ; Tuner slave addr.
HKR, "I2C Devices", "Device 0, Data3",0x00010001,0x86  ; Tuner IF PLL 
slave addr.
;HKR, "I2C Devices", "Device 0, Data4",0x00010001,0x0   ; Demod slave addr.
;HKR, "I2C Devices", "Device 0, Data5",0x00010001,0x0   ; Size of add. data
;HKR, "I2C Devices", "Device 0, Data6",0x00010001,0x0   ; Add. data #1
;HKR, "I2C Devices", "Device 0, Data7",0x00010001,0x0   ; Add. data #2
;HKR, "I2C Devices", "Device 0, Data8",0x00010001,0x0   ; Add. data #3



PHILIPS_33.DeviceDesc         = "PCI DTV Card"


... but not sure how helpful this is at all?

>> The card is unfortunately glued (!) inside a LCD enclosure, and I am not 
>> able to see any further identifications on it.
>>     
>
> ;) what to say.
>   
... know it sounds strange (and indeed it is). It is inside an otherwise 
well-equipped enclosure of .cn origin that basically embeds a low-noise 
PC (GA-MA78M-S2H MB w/AMD X2 5400 CPU) inside what looks like a normal 
LCD based TV.
>> I am able to get it partially running by using "options saa7134 card=107 
>> tuner=54" (or card 3), but it appears that changing channel via tvtime 
>> or myth  fails roughly half the time and simply causes it to return an 
>> invalid (or empty) video stream. Indeed, in myth, it sometimes crashes 
>> the application.
>>     
>
> If channel change sometimes works it is some tuner=54, but might need
> some card specific calibration or your signal is weak.
>   
I don't think the signal is weak as such here, and it is also pretty 
random what channels fail. In tvtime, I can sometimes just roll through 
the inputs (tuner, composite, ...) and then the signal is there when the 
tuner is re-selected. More likely some card specifics that needs to be 
added, me thinks.
> Is DVB-T or DVB-S announced too or only analog TV?
>   
This is not evident. The specs on the device leads me to think that 
there is at least DVB-T support, but I'm not sure.
>> I am also not able to capture any sound from the card, although 
>> saa7134_alsa gets loaded as expected.
>>     
>
> Most of the recent cards don't have analog sound output to the sound
> card anymore. The chips do provide it, but manufacturers decide against
> to provide the connector.
>
> The saa7134-alsa must be properly used and does not work automagically,
> also if a gpio switched sound mux chip is on the card, it needs to be
> configured correctly for sound switching. This is not visible in the
> logs.
>   
OK -- so likely some setup missing too.
>   
>> How do I debug this, and get the driver to recognise the card properly?
>>
>> Or any good hints at what the card may be? Would the i2c reveal any 
>> further hints?
>>     
>
> To set up an invisible device is a bit odd,
> but copy and paste "dmesg" output after loading the driver with
> i2c_scan=1 enabled ("modinfo saa7134") might help on some further
> guessing.
>   
Here's the relevant clip:


[   46.297474] saa7130/34: v4l2 driver version 0.2.14 loaded
[   46.297544] ACPI: PCI Interrupt 0000:03:07.0[A] -> GSI 21 (level, 
low) -> IRQ 21
[   46.297552] saa7133[0]: found at 0000:03:07.0, rev: 209, irq: 21, 
latency: 32, mmio: 0xfdcff000
[   46.297558] saa7133[0]: subsystem: 1a7f:2004, board: UNKNOWN/GENERIC 
[card=0,autodetected]
[   46.297566] saa7133[0]: board init: gpio is ac6ee00
[   46.311610] usbcore: registered new interface driver libusual
[   46.423269] Initializing USB Mass Storage driver...
[   46.426251] scsi6 : SCSI emulation for USB Mass Storage devices
[   46.427460] usbcore: registered new interface driver usb-storage
[   46.427465] USB Mass Storage support registered.
[   46.427469] usb-storage: device found at 4
[   46.427470] usb-storage: waiting for device to settle before scanning
[   46.430243] saa7133[0]: i2c eeprom 00: 7f 1a 04 20 54 20 1c 00 43 43 
a9 1c 55 d2 b2 92
[   46.430250] saa7133[0]: i2c eeprom 10: 00 df 86 0f ff 20 ff ff ff ff 
ff ff ff ff ff ff
[   46.430255] saa7133[0]: i2c eeprom 20: 01 40 01 02 02 ff 01 03 08 ff 
00 8f ff ff ff ff
[   46.430260] saa7133[0]: i2c eeprom 30: ff ff ff ff ff ff ff ff ff ff 
ff ff ff ff ff ff
[   46.430264] saa7133[0]: i2c eeprom 40: ff 21 00 c2 96 10 03 32 15 08 
ff ff ff ff ff ff
[   46.430269] saa7133[0]: i2c eeprom 50: ff ff ff ff ff ff ff 5f 84 ff 
31 30 4d 4f 4f 4e
[   46.430273] saa7133[0]: i2c eeprom 60: 53 50 44 41 31 30 30 ff 50 ff 
ff ff ff ff ff ff
[   46.430278] saa7133[0]: i2c eeprom 70: ff ff ff ff ff ff ff ff ff ff 
ff ff ff ff ff ff
[   46.446649] saa7133[0]: i2c scan: found device @ 0x10  [???]
[   46.462198] saa7133[0]: i2c scan: found device @ 0x96  [???]
[   46.473848] saa7133[0]: i2c scan: found device @ 0xa0  [eeprom]
[   46.496852] saa7133[0]: registered device video0 [v4l2]
[   46.498102] saa7133[0]: registered device vbi0
[   46.504905] lirc_dev: IR Remote Control driver registered, at major 61
[   46.520467] ACPI: PCI Interrupt 0000:00:14.2[A] -> GSI 16 (level, 
low) -> IRQ 18
[   46.535450]
[   46.535452] lirc_mceusb2: Philips eHome USB IR Transciever and 
Microsoft MCE 2005 Remote Control driver for LIRC $Revision: 1.33 $
[   46.535455] lirc_mceusb2: Daniel Melander <lirc@rajidae.se>, Martin 
Blatter <martin_a_blatter@yahoo.com>
[   46.547154] saa7134 ALSA driver for DMA sound loaded
[   46.547182] saa7133[0]/alsa: saa7133[0] at 0xfdcff000 irq 21 
registered as card -2
[   46.556138] hda_codec: Unknown model for ALC882, trying auto-probe 
from BIOS...
[   46.594717] ACPI: PCI Interrupt 0000:01:05.1[B] -> GSI 19 (level, 
low) -> IRQ 20
[   46.594747] PCI: Setting latency timer of device 0000:01:05.1 to 64
[   46.736190] usb 3-2: reset full speed USB device using ohci_hcd and 
address 4
[   46.947578] lirc_dev: lirc_register_plugin: sample_rate: 0
[   46.951560] lirc_mceusb2[4]: Topseed eHome Infrared Transceiver on usb3:4
[   46.951584] usbcore: registered new interface driver lirc_mceusb2
[   46.951689] usbcore: registered new interface driver hiddev

Full log is temporarily here:

   http://www.b4net.dk/dmesg.log2

There is also a http://www.b4net.dk/dmesg.log when run with my "normal" 
parameters for getting the card somehow working. Sometimes, randomly (as 
in the log above) there is a also a whole slew of dsp errors, which 
again points in the direction of some setup failing.


Thanks for any advice you can give!


-- Per.
--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
