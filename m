Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail-ew0-f164.google.com ([209.85.219.164])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <santi.info@gmail.com>) id 1LlMcL-0007zQ-SH
	for linux-dvb@linuxtv.org; Sun, 22 Mar 2009 13:17:30 +0100
Received: by ewy8 with SMTP id 8so1104366ewy.17
	for <linux-dvb@linuxtv.org>; Sun, 22 Mar 2009 05:16:55 -0700 (PDT)
MIME-Version: 1.0
Date: Sun, 22 Mar 2009 13:16:55 +0100
Message-ID: <2297c1d80903220516s357570cdg3b59518de87275e@mail.gmail.com>
From: Alessandra Santi <santi.info@gmail.com>
To: linux-dvb@linuxtv.org
Subject: [linux-dvb] DVBT USB DONGLE - EC168 - MXL5003S
Reply-To: linux-media@vger.kernel.org
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

Hello!
I have a DVBT USB DONGLE :-)

I have opened the device  and I have found 2 chip: EC168 e MXL5003S.
I don't know the name of the model,  but with lsusb I find:

----------------------------
Bus 001 Device 006: ID 18b4:1001
----------------------------
I'm trying to use DVBT USB DONGLE on Debian stable 5.0 Lenny with kernel:

uname -r
2.6.26-1-486

But, I would like know if it is possible to use it whit a kernel 2.6.26


I'm based on this links:
https://www.dealextreme.com/forums/Default.dx/sku.8309~threadid.244152
http://tanguy.ath.cx/index.php?q=EC168
https://www.dealextreme.com/forums/Default.dx/sku.8325~threadid.278942

I have downloaded and compiled driver from:

http://linuxtv.org/hg/~anttip/ec168/

than put firmware dvb-usb-ec168.fw in /lib/firmware.

and launched  as administrator after I had inserted the DVBT:

insmod dvb-core.ko
insmod dvb-usb.ko
insmod ec100.ko
insmod mxl5005s.ko
insmod dvb-usb-ec168.ko

from  folder   /ec168-2/v4l/:

I copy my terminal:

-------------------------------------------------
debian01:/home/alessandra/Desktop# cd ec168-ebac4965f512/
debian01:/home/alessandra/Desktop/ec168-ebac4965f512# cd v4l
debian01:/home/alessandra/Desktop/ec168-ebac4965f512/v4l# insmod dvb-core.ko
insmod: error inserting 'dvb-core.ko': -1 File exists
debian01:/home/alessandra/Desktop/ec168-ebac4965f512/v4l# insmod dvb-usb.ko
insmod: error inserting 'dvb-usb.ko': -1 File exists
debian01:/home/alessandra/Desktop/ec168-ebac4965f512/v4l# insmod ec100.ko
debian01:/home/alessandra/Desktop/ec168-ebac4965f512/v4l# insmod mxl5005s.ko
debian01:/home/alessandra/Desktop/ec168-ebac4965f512/v4l# insmod
dvb-usb-ec168.ko
insmod: error inserting 'dvb-usb-ec168.ko': -1 File exists
debian01:/home/alessandra/Desktop/ec168-ebac4965f512/v4l#
-------------------------------------------------

Here, some commands:

dmesg:
------------------------------------------------
[ 4922.152074] usb 1-2: new full speed USB device using ohci_hcd and address 6
[ 4922.355997] usb 1-2: configuration #1 chosen from 1 choice
[ 4922.374877] input: HID 18b4:1001 as /class/input/input8
[ 4922.400293] input,hidraw0: USB HID v1.11 Keyboard [HID 18b4:1001]
on usb-0000:00:07.4-2
[ 4922.405091] dvb-usb: found a 'E3C EC168 DVB-T USB2.0 reference
design' in cold state, will try to load a firmware
[ 4922.405114] firmware: requesting dvb-usb-ec168.fw
[ 4922.497395] dvb-usb: downloading firmware from file 'dvb-usb-ec168.fw'
[ 4922.573079] dvb-usb: found a 'E3C EC168 DVB-T USB2.0 reference
design' in warm state.
[ 4922.573279] i2c-adapter i2c-1: SMBus Quick command not supported,
can't probe for chips
[ 4922.573293] dvb-usb: This USB2.0 device cannot be run on a USB1.1
port. (it lacks a hardware PID filter)
[ 4922.573358] dvb-usb: E3C EC168 DVB-T USB2.0 reference design error
while loading driver (-19)
[ 4922.573572] usb 1-2: New USB device found, idVendor=18b4, idProduct=1001
[ 4922.573584] usb 1-2: New USB device strings: Mfr=0, Product=0, SerialNumber=0
------------------------------------------------

lsmod:
------------------------------------------------
debian01:/home/alessandra/Desktop/ec168-ebac4965f512/v4l# lsmod
Module                  Size  Used by
mxl5005s               32516  0
ec100                   3712  0
dvb_usb_ec168           8068  0
dvb_usb                17164  1 dvb_usb_ec168
dvb_core               73728  1 dvb_usb
usbhid                 35712  0
hid                    32128  1 usbhid
firmware_class          6656  1 dvb_usb
ff_memless              4232  1 usbhid
nls_utf8                1792  0
nls_cp437               5504  0
vfat                    8960  0
fat                    40220  1 vfat
nls_base                6528  4 nls_utf8,nls_cp437,vfat,fat
sd_mod                 22032  0
usb_storage            75840  0
dmfe                   16408  0
binfmt_misc             7176  1
tdfx                    2176  2
drm                    64672  3 tdfx
ppdev                   6404  0
lp                      7972  0
cpufreq_stats           3076  0
cpufreq_ondemand        6036  0
freq_table              4100  2 cpufreq_stats,cpufreq_ondemand
cpufreq_powersave       1792  0
cpufreq_userspace       2968  0
cpufreq_conservative     5664  0
ipv6                  225172  18
dm_snapshot            14240  0
dm_mirror              14720  0
dm_log                  8192  1 dm_mirror
dm_mod                 45384  3 dm_snapshot,dm_mirror,dm_log
eeprom                  5264  0
w83781d                25768  0
hwmon_vid               2560  1 w83781d
adm1021                10160  0
i2c_matroxfb            3840  0
i2c_algo_bit            5124  1 i2c_matroxfb
matroxfb_base          24540  1 i2c_matroxfb
matroxfb_DAC1064        9472  1 matroxfb_base
matroxfb_accel          3840  1 matroxfb_base
matroxfb_Ti3026         5120  1 matroxfb_base
matroxfb_g450           6016  1 matroxfb_base
g450_pll                5376  2 matroxfb_DAC1064,matroxfb_g450
matroxfb_misc           7936  6
i2c_matroxfb,matroxfb_base,matroxfb_DAC1064,matroxfb_Ti3026,matroxfb_g450,g450_pll
loop                   12428  0
parport_pc             22436  1
parport                30408  3 ppdev,lp,parport_pc
button                  6032  0
psmouse                32016  0
snd_ens1371            18720  0
gameport               10504  1 snd_ens1371
snd_seq_midi            5664  0
snd_seq_midi_event      6528  1 snd_seq_midi
snd_rawmidi            18592  2 snd_ens1371,snd_seq_midi
serio_raw               4740  0
snd_ac97_codec         88228  1 snd_ens1371
ac97_bus                1664  1 snd_ac97_codec
snd_pcm                60680  2 snd_ens1371,snd_ac97_codec
snd_seq                40784  2 snd_seq_midi,snd_seq_midi_event
snd_timer              17668  2 snd_pcm,snd_seq
snd_seq_device          6412  3 snd_seq_midi,snd_rawmidi,snd_seq
snd                    44964  7
snd_ens1371,snd_rawmidi,snd_ac97_codec,snd_pcm,snd_seq,snd_timer,snd_seq_device
i2c_amd756              5124  0
soundcore               6112  1 snd
i2c_core               19728  9
mxl5005s,ec100,dvb_usb,eeprom,w83781d,adm1021,i2c_matroxfb,i2c_algo_bit,i2c_amd756
snd_page_alloc          7816  1 snd_pcm
shpchp                 25496  0
pci_hotplug            23204  1 shpchp
pcspkr                  2304  0
amd_k7_agp              6028  1
agpgart                28336  2 drm,amd_k7_agp
evdev                   7808  5
ext3                  103688  5
jbd                    35092  1 ext3
mbcache                 6656  1 ext3
raid10                 18176  0
raid456               115216  0
async_xor               3456  1 raid456
async_memcpy            2176  1 raid456
async_tx                5960  3 raid456,async_xor,async_memcpy
xor                    14728  2 raid456,async_xor
raid1                  17664  0
raid0                   6272  0
multipath               6016  0
linear                  4480  0
md_mod                 65940  6 raid10,raid456,raid1,raid0,multipath,linear
ide_cd_mod             27652  0
cdrom                  30240  1 ide_cd_mod
ide_disk               10496  7
ata_generic             4612  0
libata                141088  1 ata_generic
scsi_mod              129804  3 sd_mod,usb_storage,libata
dock                    8076  1 libata
ide_pci_generic         3844  0 [permanent]
floppy                 47620  0
ohci_hcd               18436  0
amd74xx                 7688  0 [permanent]
usbcore               117616  6
dvb_usb_ec168,dvb_usb,usbhid,usb_storage,ohci_hcd
ide_core               95144  4 ide_cd_mod,ide_disk,ide_pci_generic,amd74xx
thermal                15132  0
processor              28080  1 thermal
fan                     4100  0
thermal_sys            10784  3 thermal,processor,fan

------------------------------------------------


lsusb -v -d "18b4:1001"

------------------------------------------------

debian01:/home/alessandra/Desktop/ec168-ebac4965f512/v4l# lsusb -v -d
"18b4:1001"

Bus 001 Device 006: ID 18b4:1001
Device Descriptor:
  bLength                18
  bDescriptorType         1
  bcdUSB               2.00
  bDeviceClass            0 (Defined at Interface level)
  bDeviceSubClass         0
  bDeviceProtocol         0
  bMaxPacketSize0        64
  idVendor           0x18b4
  idProduct          0x1001
  bcdDevice            0.02
  iManufacturer           0
  iProduct                0
  iSerial                 0
  bNumConfigurations      1
  Configuration Descriptor:
    bLength                 9
    bDescriptorType         2
    wTotalLength           50
    bNumInterfaces          2
    bConfigurationValue     1
    iConfiguration          0
    bmAttributes         0x80
      (Bus Powered)
    MaxPower              100mA
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        0
      bAlternateSetting       0
      bNumEndpoints           1
      bInterfaceClass         3 Human Interface Device
      bInterfaceSubClass      1 Boot Interface Subclass
      bInterfaceProtocol      1 Keyboard
      iInterface              0
        HID Device Descriptor:
          bLength                 9
          bDescriptorType        33
          bcdHID               1.11
          bCountryCode            0 Not supported
          bNumDescriptors         1
          bDescriptorType        34 Report
          wDescriptorLength      63
         Report Descriptors:
           ** UNAVAILABLE **
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x81  EP 1 IN
        bmAttributes            3
          Transfer Type            Interrupt
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0008  1x 8 bytes
        bInterval              10
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        1
      bAlternateSetting       0
      bNumEndpoints           1
      bInterfaceClass       255 Vendor Specific Class
      bInterfaceSubClass    255 Vendor Specific Subclass
      bInterfaceProtocol    255 Vendor Specific Protocol
      iInterface              0
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x82  EP 2 IN
        bmAttributes            2
          Transfer Type            Bulk
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0040  1x 64 bytes
        bInterval               0
Device Qualifier (for other device speed):
  bLength                10
  bDescriptorType         6
  bcdUSB               2.00
  bDeviceClass            0 (Defined at Interface level)
  bDeviceSubClass         0
  bDeviceProtocol         0
  bMaxPacketSize0        64
  bNumConfigurations      1
Device Status:     0x0000
  (Bus Powered)
mal_sys            10784  3 thermal,processor,fan

------------------------------------------------

..... but with scan -c:      :-(

------------------------------------------------
debian01:/home# scan -c
using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'
main:2273: FATAL: failed to open '/dev/dvb/adapter0/frontend0': 2 No
such file or directory
------------------------------------------------

where is my error?


thank for the attention and the possible help.

ciao!
Ale.a

_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
