Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from wx-out-0506.google.com ([66.249.82.236])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <vanessaezekowitz@gmail.com>) id 1KhIDN-0002qI-QS
	for linux-dvb@linuxtv.org; Sun, 21 Sep 2008 08:14:40 +0200
Received: by wx-out-0506.google.com with SMTP id t16so273840wxc.17
	for <linux-dvb@linuxtv.org>; Sat, 20 Sep 2008 23:14:33 -0700 (PDT)
From: Vanessa Ezekowitz <vanessaezekowitz@gmail.com>
To: "linux-dvb" <linux-dvb@linuxtv.org>
Date: Sun, 21 Sep 2008 01:14:44 -0500
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200809210114.44842.vanessaezekowitz@gmail.com>
Cc: Curt Blank <Curt.Blank@curtronics.com>
Subject: Re: [linux-dvb] Kworld PlusTV HD PCI 120 (ATSC 120)
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

Curt's latest message in the thread.  Curt, let's keep this on the v4l-dvb =

mailing list, that's where all the action is. :-)

v4l-dvb members: I think I got the order of the messages right.  My apologi=
es =

for so many posts in such a short time; I didn't want to leave anything out =

that might be important.  My next reply will follow.

----- Text Import Begin -----

Re: Kworld PlusTV HD PCI 120 (ATSC 120)
From: Curt Blank <Curt.Blank@curtronics.com>
To: Vanessa Ezekowitz <vanessaezekowitz@gmail.com>
CC: video4linux-list@redhat.com
Date:  Sat Sep 20 22:52:28 2008
  =A0
Vanessa Ezekowitz wrote:
> On Saturday 20 September 2008 6:28:08 pm, Curt Blank wrote:
>
> =A0 =

>> I've got the new computer built, with the 2.6.26.5 kernel, v4l not gen'd
>> in and using the latest from the repository.
>>
>> Using Kradio I still can only listen to it via the Line Out on the 120's
>> board.
>>
>> When I run kaffeine I get a pop up window with this:
>>
>> No plugin found to handle this resource (/dev/video)
>>
>> 17:59:33: xine: couldn't find demux for >file:///dev/video<
>>
>> 17:59:33: xine: found input plugin : file input plugin
>>
>>
>> When I run xawtv I get this:
>>
>> # xawtv
>> This is xawtv-3.95, running on Linux/x86_64 (2.6.26.5-touch)
>> xinerama 0: 1024x768+0+0
>> /dev/video0 [v4l2]: no overlay support
>> v4l-conf had some trouble, trying to continue anyway
>> ioctl: VIDIOC_REQBUFS(count=3D2;type=3DVIDEO_CAPTURE;memory=3DMMAP): Suc=
cess
>> ioctl: VIDIOC_REQBUFS(count=3D2;type=3DVIDEO_CAPTURE;memory=3DMMAP): Res=
ource
>> temporarily unavailable
>>
>>
>> And I still get the "Unable to grab video." pop up form kdetv.
>>
>> Ideas? Am I missing something?
>>
>> I blacklisted cx8800, cx8802, cx88-alsa, & cx88-dvb on boot, then moved
>> the blacklist file then only modprobed cx8800. That and cx88xx are the
>> only ones loaded.
>>
>> I have this in my modprobe.d/tv file:
>>
>> alias char-major-81 videodev
>> options i2c-algo-bit bit_test=3D1
>>
>> alias char-major-81-0 cx8800
>> alias char-major-81-1 off
>> alias char-major-81-2 off
>> alias char-major-81-3 off
>>
>> Thanks.
>> =A0 =A0 =

>
> Something odd is happening then - there should be a fair number of other =

> modules that got brought in with cx8800, like tuner_xc2028, tuner, =

> v4l2_common, videodev, and others.
>
> Can you copy&paste dmesg and lsmod outputs as they look after a fresh reb=
oot =

> and having loaded the modules?
>
> I also have a feeling I'm wrong about cx88-alsa not being needed...
>
> V4l team: =A0Is or is not cx88-alsa still part of the usual modules that =
must =

be =

> loaded (either manually or automatically)? =A0If it is, did something mer=
ely =

> break recently that made it disappear from the output of the build?
>
> /me is confused.
>
> =A0 =

Um, sorry, there are a bunch of other modules loaded too. I was just =

referring to the Conexant related modules.

Below is the info requested, but it doesn't look like hte dmesg output =

is of much help.

Oh and I noticed here: http://linuxtv.org/wiki/index.php/ATSC_PCI_Cards =

that the 120 card isn't listed, it would be easier to find I think if it =

was. oh and you asked the v4l team but it looks like this message cam =

only to me?? (I cc'd my reply.)

lsmod before

Module =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0Size =A0Used by
iptable_filter =A0 =A0 =A0 =A0 19968 =A00
ip_tables =A0 =A0 =A0 =A0 =A0 =A0 =A034064 =A01 iptable_filter
ip6_tables =A0 =A0 =A0 =A0 =A0 =A0 35728 =A00
x_tables =A0 =A0 =A0 =A0 =A0 =A0 =A0 38280 =A02 ip_tables,ip6_tables
snd_pcm_oss =A0 =A0 =A0 =A0 =A0 =A060672 =A00
snd_mixer_oss =A0 =A0 =A0 =A0 =A032000 =A01 snd_pcm_oss
binfmt_misc =A0 =A0 =A0 =A0 =A0 =A026252 =A01
snd_seq =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A072208 =A00
it87 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 40088 =A00
snd_seq_device =A0 =A0 =A0 =A0 24724 =A01 snd_seq
hwmon_vid =A0 =A0 =A0 =A0 =A0 =A0 =A019840 =A01 it87
cpufreq_conservative =A0 =A024328 =A00
cpufreq_userspace =A0 =A0 =A022916 =A00
cpufreq_powersave =A0 =A0 =A018944 =A00
powernow_k8 =A0 =A0 =A0 =A0 =A0 =A029956 =A01
fuse =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 66880 =A01
loop =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 32396 =A00
dm_mod =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 72288 =A00
snd_hda_intel =A0 =A0 =A0 =A0 469804 =A02
usbhid =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 58192 =A01
snd_pcm =A0 =A0 =A0 =A0 =A0 =A0 =A0 101512 =A02 snd_pcm_oss,snd_hda_intel
snd_timer =A0 =A0 =A0 =A0 =A0 =A0 =A039952 =A02 snd_seq,snd_pcm
hid =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A054688 =A01 usbhid
snd_page_alloc =A0 =A0 =A0 =A0 26128 =A02 snd_hda_intel,snd_pcm
rtc_cmos =A0 =A0 =A0 =A0 =A0 =A0 =A0 27064 =A00
ff_memless =A0 =A0 =A0 =A0 =A0 =A0 22024 =A01 usbhid
rtc_core =A0 =A0 =A0 =A0 =A0 =A0 =A0 35252 =A01 rtc_cmos
rtc_lib =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A020096 =A01 rtc_core
sr_mod =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 31156 =A00
snd_hwdep =A0 =A0 =A0 =A0 =A0 =A0 =A025096 =A01 snd_hda_intel
floppy =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 74792 =A00
snd =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A084216 =A012 =

snd_pcm_oss,snd_mixer_oss,snd_seq,snd_seq_device,snd_hda_intel,snd_pcm,snd_=
timer,snd_hwdep
i2c_piix4 =A0 =A0 =A0 =A0 =A0 =A0 =A025616 =A00
serio_raw =A0 =A0 =A0 =A0 =A0 =A0 =A022660 =A00
usbtouchscreen =A0 =A0 =A0 =A0 26756 =A00
k8temp =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 21760 =A00
fglrx =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A02058956 =A028
ohci1394 =A0 =A0 =A0 =A0 =A0 =A0 =A0 45364 =A00
sg =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 48976 =A00
usb_storage =A0 =A0 =A0 =A0 =A0 142064 =A00
cdrom =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A050856 =A01 sr_mod
i2c_core =A0 =A0 =A0 =A0 =A0 =A0 =A0 40480 =A01 i2c_piix4
soundcore =A0 =A0 =A0 =A0 =A0 =A0 =A024464 =A01 snd
shpchp =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 47392 =A00
button =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 24480 =A00
r8169 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A043652 =A00
wmi =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A024256 =A00
ieee1394 =A0 =A0 =A0 =A0 =A0 =A0 =A0106984 =A01 ohci1394
pci_hotplug =A0 =A0 =A0 =A0 =A0 =A044472 =A01 shpchp
raid456 =A0 =A0 =A0 =A0 =A0 =A0 =A0 140576 =A00
async_xor =A0 =A0 =A0 =A0 =A0 =A0 =A020992 =A01 raid456
async_memcpy =A0 =A0 =A0 =A0 =A0 19456 =A01 raid456
async_tx =A0 =A0 =A0 =A0 =A0 =A0 =A0 24420 =A03 raid456,async_xor,async_mem=
cpy
xor =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A022288 =A02 raid456,async_xor
raid0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A023424 =A00
ehci_hcd =A0 =A0 =A0 =A0 =A0 =A0 =A0 50060 =A00
ohci_hcd =A0 =A0 =A0 =A0 =A0 =A0 =A0 37892 =A00
usbcore =A0 =A0 =A0 =A0 =A0 =A0 =A0 162392 =A07 =

usbhid,usbtouchscreen,usb_storage,ehci_hcd,ohci_hcd
sd_mod =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 41648 =A024
edd =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A026000 =A00
raid1 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A038016 =A011
reiserfs =A0 =A0 =A0 =A0 =A0 =A0 =A0230224 =A010
fan =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A022152 =A00
ahci =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 45192 =A022
pata_atiixp =A0 =A0 =A0 =A0 =A0 =A022400 =A00
libata =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0181184 =A02 ahci,pata_atiixp
scsi_mod =A0 =A0 =A0 =A0 =A0 =A0 =A0174680 =A05 sr_mod,sg,usb_storage,sd_mo=
d,libata
dock =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 26656 =A01 libata
thermal =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A037792 =A00
processor =A0 =A0 =A0 =A0 =A0 =A0 =A064704 =A02 powernow_k8,thermal


dmesg after modprobe cx8800

[Note: I edited this section to shorten it - gobs of usb-storage messages t=
hat =

aren't related to this issue.  --Vanessa ]

Linux video capture interface: v2.00
cx88/0: cx2388x v4l2 driver version 0.0.6 loaded
ACPI: PCI Interrupt 0000:04:06.0[A] -> GSI 20 (level, low) -> IRQ 20
cx88[0]: subsystem: 17de:08c1, board: Kworld PlusTV HD PCI 120 (ATSC
120) [card=3D67,autodetected]
cx88[0]: TV tuner type 71, Radio tuner type -1
cx88[0]: Test OK
tuner' 1-0061: chip found @ 0xc2 (cx88[0])
xc2028 1-0061: creating new instance
xc2028 1-0061: type set to XCeive xc2028/xc3028 tuner
cx88[0]: Asking xc2028/3028 to load firmware xc3028-v27.fw
cx88[0]/0: found at 0000:04:06.0, rev: 5, irq: 20, latency: 64, mmio:
0xfb000000
cx88[0]/0: registered device video0 [v4l2]
cx88[0]/0: registered device vbi0
cx88[0]/0: registered device radio0
firmware: requesting xc3028-v27.fw
xc2028 1-0061: Loading 80 firmware images from xc3028-v27.fw, type:
xc2028 firmware, ver 2.7
cx88[0]: Calling XC2028/3028 callback
xc2028 1-0061: Loading firmware for type=3DBASE (1), id 0000000000000000.
cx88[0]: Calling XC2028/3028 callback
xc2028 1-0061: Loading firmware for type=3D(0), id 000000000000b700.
SCODE (20000000), id 000000000000b700:
xc2028 1-0061: Loading SCODE for type=3DMONO SCODE HAS_IF_4320 (60008000),
id 0000000000008000.
xc2028 1-0061: Incorrect readback of firmware version.
cx88[0]: Calling XC2028/3028 callback
xc2028 1-0061: Loading firmware for type=3DBASE (1), id 0000000000000000.
cx88[0]: Calling XC2028/3028 callback
xc2028 1-0061: Loading firmware for type=3D(0), id 000000000000b700.
SCODE (20000000), id 000000000000b700:
xc2028 1-0061: Loading SCODE for type=3DMONO SCODE HAS_IF_4320 (60008000),
id 0000000000008000.
cx88[0]: Calling XC2028/3028 callback
cx88[0]: Calling XC2028/3028 callback
xc2028 1-0061: Loading firmware for type=3DBASE FM (401), id 00000000000000=
00.
cx88[0]: Calling XC2028/3028 callback
xc2028 1-0061: Loading firmware for type=3DFM (400), id 0000000000000000.
cx88[0]: Calling XC2028/3028 callback

[ End of my edit.  --Vanessa]

lsmod after

Module =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0Size =A0Used by
tuner_xc2028 =A0 =A0 =A0 =A0 =A0 35504 =A01
firmware_class =A0 =A0 =A0 =A0 25216 =A01 tuner_xc2028
tuner =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A041804 =A00
cx8800 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 50084 =A00
cx88xx =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 85928 =A01 cx8800
ir_common =A0 =A0 =A0 =A0 =A0 =A0 =A060292 =A01 cx88xx
i2c_algo_bit =A0 =A0 =A0 =A0 =A0 22916 =A01 cx88xx
tveeprom =A0 =A0 =A0 =A0 =A0 =A0 =A0 30212 =A01 cx88xx
compat_ioctl32 =A0 =A0 =A0 =A0 24832 =A01 cx8800
videodev =A0 =A0 =A0 =A0 =A0 =A0 =A0 51456 =A04 tuner,cx8800,cx88xx,compat_=
ioctl32
v4l1_compat =A0 =A0 =A0 =A0 =A0 =A029828 =A01 videodev
v4l2_common =A0 =A0 =A0 =A0 =A0 =A029952 =A02 tuner,cx8800
videobuf_dma_sg =A0 =A0 =A0 =A029828 =A02 cx8800,cx88xx
videobuf_core =A0 =A0 =A0 =A0 =A036100 =A03 cx8800,cx88xx,videobuf_dma_sg
btcx_risc =A0 =A0 =A0 =A0 =A0 =A0 =A021384 =A02 cx8800,cx88xx
iptable_filter =A0 =A0 =A0 =A0 19968 =A00
ip_tables =A0 =A0 =A0 =A0 =A0 =A0 =A034064 =A01 iptable_filter
ip6_tables =A0 =A0 =A0 =A0 =A0 =A0 35728 =A00
x_tables =A0 =A0 =A0 =A0 =A0 =A0 =A0 38280 =A02 ip_tables,ip6_tables
snd_pcm_oss =A0 =A0 =A0 =A0 =A0 =A060672 =A00
snd_mixer_oss =A0 =A0 =A0 =A0 =A032000 =A01 snd_pcm_oss
binfmt_misc =A0 =A0 =A0 =A0 =A0 =A026252 =A01
snd_seq =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A072208 =A00
it87 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 40088 =A00
snd_seq_device =A0 =A0 =A0 =A0 24724 =A01 snd_seq
hwmon_vid =A0 =A0 =A0 =A0 =A0 =A0 =A019840 =A01 it87
cpufreq_conservative =A0 =A024328 =A00
cpufreq_userspace =A0 =A0 =A022916 =A00
cpufreq_powersave =A0 =A0 =A018944 =A00
powernow_k8 =A0 =A0 =A0 =A0 =A0 =A029956 =A01
fuse =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 66880 =A01
loop =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 32396 =A00
dm_mod =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 72288 =A00
snd_hda_intel =A0 =A0 =A0 =A0 469804 =A02
usbhid =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 58192 =A01
snd_pcm =A0 =A0 =A0 =A0 =A0 =A0 =A0 101512 =A02 snd_pcm_oss,snd_hda_intel
snd_timer =A0 =A0 =A0 =A0 =A0 =A0 =A039952 =A02 snd_seq,snd_pcm
hid =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A054688 =A01 usbhid
snd_page_alloc =A0 =A0 =A0 =A0 26128 =A02 snd_hda_intel,snd_pcm
rtc_cmos =A0 =A0 =A0 =A0 =A0 =A0 =A0 27064 =A00
ff_memless =A0 =A0 =A0 =A0 =A0 =A0 22024 =A01 usbhid
rtc_core =A0 =A0 =A0 =A0 =A0 =A0 =A0 35252 =A01 rtc_cmos
rtc_lib =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A020096 =A01 rtc_core
sr_mod =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 31156 =A00
snd_hwdep =A0 =A0 =A0 =A0 =A0 =A0 =A025096 =A01 snd_hda_intel
floppy =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 74792 =A00
snd =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A084216 =A012 =

snd_pcm_oss,snd_mixer_oss,snd_seq,snd_seq_device,snd_hda_intel,snd_pcm,snd_=
timer,snd_hwdep
i2c_piix4 =A0 =A0 =A0 =A0 =A0 =A0 =A025616 =A00
serio_raw =A0 =A0 =A0 =A0 =A0 =A0 =A022660 =A00
usbtouchscreen =A0 =A0 =A0 =A0 26756 =A00
k8temp =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 21760 =A00
fglrx =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A02058956 =A028
ohci1394 =A0 =A0 =A0 =A0 =A0 =A0 =A0 45364 =A00
sg =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 48976 =A00
usb_storage =A0 =A0 =A0 =A0 =A0 142064 =A00
cdrom =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A050856 =A01 sr_mod
i2c_core =A0 =A0 =A0 =A0 =A0 =A0 =A0 40480 =A07 =

tuner_xc2028,tuner,cx88xx,i2c_algo_bit,tveeprom,v4l2_common,i2c_piix4
soundcore =A0 =A0 =A0 =A0 =A0 =A0 =A024464 =A01 snd
shpchp =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 47392 =A00
button =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 24480 =A00
r8169 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A043652 =A00
wmi =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A024256 =A00
ieee1394 =A0 =A0 =A0 =A0 =A0 =A0 =A0106984 =A01 ohci1394
pci_hotplug =A0 =A0 =A0 =A0 =A0 =A044472 =A01 shpchp
raid456 =A0 =A0 =A0 =A0 =A0 =A0 =A0 140576 =A00
async_xor =A0 =A0 =A0 =A0 =A0 =A0 =A020992 =A01 raid456
async_memcpy =A0 =A0 =A0 =A0 =A0 19456 =A01 raid456
async_tx =A0 =A0 =A0 =A0 =A0 =A0 =A0 24420 =A03 raid456,async_xor,async_mem=
cpy
xor =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A022288 =A02 raid456,async_xor
raid0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A023424 =A00
ehci_hcd =A0 =A0 =A0 =A0 =A0 =A0 =A0 50060 =A00
ohci_hcd =A0 =A0 =A0 =A0 =A0 =A0 =A0 37892 =A00
usbcore =A0 =A0 =A0 =A0 =A0 =A0 =A0 162392 =A07 =

usbhid,usbtouchscreen,usb_storage,ehci_hcd,ohci_hcd
sd_mod =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 41648 =A024
edd =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A026000 =A00
raid1 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A038016 =A011
reiserfs =A0 =A0 =A0 =A0 =A0 =A0 =A0230224 =A010
fan =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A022152 =A00
ahci =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 45192 =A022
pata_atiixp =A0 =A0 =A0 =A0 =A0 =A022400 =A00
libata =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0181184 =A02 ahci,pata_atiixp
scsi_mod =A0 =A0 =A0 =A0 =A0 =A0 =A0174680 =A05 sr_mod,sg,usb_storage,sd_mo=
d,libata
dock =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 26656 =A01 libata
thermal =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A037792 =A00
processor =A0 =A0 =A0 =A0 =A0 =A0 =A064704 =A02 powernow_k8,thermal

----- Text Import End -----

-- =

"Life is full of positive and negative events.  Spend
your time considering the former, not the latter."
Vanessa Ezekowitz <vanessaezekowitz@gmail.com>

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
