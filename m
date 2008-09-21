Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx2.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m8L3r5Fr025110
	for <video4linux-list@redhat.com>; Sat, 20 Sep 2008 23:53:05 -0400
Received: from www.curtronics.com
	(h69-129-7-18.nwblwi.dedicated.static.tds.net [69.129.7.18])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m8L3qlIb002675
	for <video4linux-list@redhat.com>; Sat, 20 Sep 2008 23:52:47 -0400
Message-ID: <48D5C4FC.4030106@curtronics.com>
Date: Sat, 20 Sep 2008 22:52:28 -0500
From: Curt Blank <Curt.Blank@curtronics.com>
MIME-Version: 1.0
To: Vanessa Ezekowitz <vanessaezekowitz@gmail.com>
References: <48D32F0E.1000903@curtronics.com> <48D3B730.9060204@curtronics.com>
	<48D58708.9040808@curtronics.com>
	<200809202159.50464.vanessaezekowitz@gmail.com>
In-Reply-To: <200809202159.50464.vanessaezekowitz@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: video4linux-list@redhat.com
Subject: Re: Kworld PlusTV HD PCI 120 (ATSC 120)
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

Vanessa Ezekowitz wrote:
> On Saturday 20 September 2008 6:28:08 pm, Curt Blank wrote:
>
>   
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
>> ioctl: VIDIOC_REQBUFS(count=2;type=VIDEO_CAPTURE;memory=MMAP): Success
>> ioctl: VIDIOC_REQBUFS(count=2;type=VIDEO_CAPTURE;memory=MMAP): Resource
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
>> options i2c-algo-bit bit_test=1
>>
>> alias char-major-81-0 cx8800
>> alias char-major-81-1 off
>> alias char-major-81-2 off
>> alias char-major-81-3 off
>>
>> Thanks.
>>     
>
> Something odd is happening then - there should be a fair number of other 
> modules that got brought in with cx8800, like tuner_xc2028, tuner, 
> v4l2_common, videodev, and others.
>
> Can you copy&paste dmesg and lsmod outputs as they look after a fresh reboot 
> and having loaded the modules?
>
> I also have a feeling I'm wrong about cx88-alsa not being needed...
>
> V4l team:  Is or is not cx88-alsa still part of the usual modules that must be 
> loaded (either manually or automatically)?  If it is, did something merely 
> break recently that made it disappear from the output of the build?
>
> /me is confused.
>
>   
Um, sorry, there are a bunch of other modules loaded too. I was just 
referring to the Conexant related modules.

Below is the info requested, but it doesn't look like hte dmesg output 
is of much help.

Oh and I noticed here: http://linuxtv.org/wiki/index.php/ATSC_PCI_Cards 
that the 120 card isn't listed, it would be easier to find I think if it 
was. oh and you asked the v4l team but it looks like this message cam 
only to me?? (I cc'd my reply.)

lsmod before

Module                  Size  Used by
iptable_filter         19968  0
ip_tables              34064  1 iptable_filter
ip6_tables             35728  0
x_tables               38280  2 ip_tables,ip6_tables
snd_pcm_oss            60672  0
snd_mixer_oss          32000  1 snd_pcm_oss
binfmt_misc            26252  1
snd_seq                72208  0
it87                   40088  0
snd_seq_device         24724  1 snd_seq
hwmon_vid              19840  1 it87
cpufreq_conservative    24328  0
cpufreq_userspace      22916  0
cpufreq_powersave      18944  0
powernow_k8            29956  1
fuse                   66880  1
loop                   32396  0
dm_mod                 72288  0
snd_hda_intel         469804  2
usbhid                 58192  1
snd_pcm               101512  2 snd_pcm_oss,snd_hda_intel
snd_timer              39952  2 snd_seq,snd_pcm
hid                    54688  1 usbhid
snd_page_alloc         26128  2 snd_hda_intel,snd_pcm
rtc_cmos               27064  0
ff_memless             22024  1 usbhid
rtc_core               35252  1 rtc_cmos
rtc_lib                20096  1 rtc_core
sr_mod                 31156  0
snd_hwdep              25096  1 snd_hda_intel
floppy                 74792  0
snd                    84216  12 
snd_pcm_oss,snd_mixer_oss,snd_seq,snd_seq_device,snd_hda_intel,snd_pcm,snd_timer,snd_hwdep
i2c_piix4              25616  0
serio_raw              22660  0
usbtouchscreen         26756  0
k8temp                 21760  0
fglrx                2058956  28
ohci1394               45364  0
sg                     48976  0
usb_storage           142064  0
cdrom                  50856  1 sr_mod
i2c_core               40480  1 i2c_piix4
soundcore              24464  1 snd
shpchp                 47392  0
button                 24480  0
r8169                  43652  0
wmi                    24256  0
ieee1394              106984  1 ohci1394
pci_hotplug            44472  1 shpchp
raid456               140576  0
async_xor              20992  1 raid456
async_memcpy           19456  1 raid456
async_tx               24420  3 raid456,async_xor,async_memcpy
xor                    22288  2 raid456,async_xor
raid0                  23424  0
ehci_hcd               50060  0
ohci_hcd               37892  0
usbcore               162392  7 
usbhid,usbtouchscreen,usb_storage,ehci_hcd,ohci_hcd
sd_mod                 41648  24
edd                    26000  0
raid1                  38016  11
reiserfs              230224  10
fan                    22152  0
ahci                   45192  22
pata_atiixp            22400  0
libata                181184  2 ahci,pata_atiixp
scsi_mod              174680  5 sr_mod,sg,usb_storage,sd_mod,libata
dock                   26656  1 libata
thermal                37792  0
processor              64704  2 powernow_k8,thermal


dmesg after modprobe cx8800


usb-storage: -- transfer complete
usb-storage: Bulk command transfer result=0
usb-storage: usb_stor_bulk_transfer_sglist: xfer 18 bytes, 1 entries
usb-storage: Status code 0; transferred 18/18
usb-storage: -- transfer complete
usb-storage: Bulk data transfer result 0x0
usb-storage: Attempting to get CSW...
usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
usb-storage: Status code 0; transferred 13/13
usb-storage: -- transfer complete
usb-storage: Bulk status result = 0
usb-storage: Bulk Status S 0x53425355 T 0x484 R 0 Stat 0x0
usb-storage: -- Result from auto-sense is 0
usb-storage: -- code: 0x70, key: 0x2, ASC: 0x3a, ASCQ: 0x0
usb-storage: Not Ready: Medium not present
usb-storage: scsi cmd done, result=0x2
usb-storage: *** thread sleeping.
usb-storage: queuecommand called
usb-storage: *** thread awakened.
usb-storage: Command TEST_UNIT_READY (6 bytes)
usb-storage:  00 00 00 00 00 00
usb-storage: Bulk Command S 0x43425355 T 0x485 L 0 F 0 Trg 0 LUN 0 CL 6
usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
usb-storage: Status code 0; transferred 31/31
usb-storage: -- transfer complete
usb-storage: Bulk command transfer result=0
usb-storage: Attempting to get CSW...
usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
usb-storage: Status code 0; transferred 13/13
usb-storage: -- transfer complete
usb-storage: Bulk status result = 0
usb-storage: Bulk Status S 0x53425355 T 0x485 R 0 Stat 0x1
usb-storage: -- transport indicates command failure
usb-storage: Issuing auto-REQUEST_SENSE
usb-storage: Bulk Command S 0x43425355 T 0x486 L 18 F 128 Trg 0 LUN 0 CL 6
usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
usb-storage: Status code 0; transferred 31/31
usb-storage: -- transfer complete
usb-storage: Bulk command transfer result=0
usb-storage: usb_stor_bulk_transfer_sglist: xfer 18 bytes, 1 entries
usb-storage: Status code 0; transferred 18/18
usb-storage: -- transfer complete
usb-storage: Bulk data transfer result 0x0
usb-storage: Attempting to get CSW...
usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
usb-storage: Status code 0; transferred 13/13
usb-storage: -- transfer complete
usb-storage: Bulk status result = 0
usb-storage: Bulk Status S 0x53425355 T 0x486 R 0 Stat 0x0
usb-storage: -- Result from auto-sense is 0
usb-storage: -- code: 0x70, key: 0x2, ASC: 0x3a, ASCQ: 0x0
usb-storage: Not Ready: Medium not present
usb-storage: scsi cmd done, result=0x2
usb-storage: *** thread sleeping.
usb-storage: queuecommand called
usb-storage: *** thread awakened.
usb-storage: Command TEST_UNIT_READY (6 bytes)
usb-storage:  00 00 00 00 00 00
usb-storage: Bulk Command S 0x43425355 T 0x487 L 0 F 0 Trg 0 LUN 1 CL 6
usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
usb-storage: Status code 0; transferred 31/31
usb-storage: -- transfer complete
usb-storage: Bulk command transfer result=0
usb-storage: Attempting to get CSW...
usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
usb-storage: Status code 0; transferred 13/13
usb-storage: -- transfer complete
usb-storage: Bulk status result = 0
usb-storage: Bulk Status S 0x53425355 T 0x487 R 0 Stat 0x1
usb-storage: -- transport indicates command failure
usb-storage: Issuing auto-REQUEST_SENSE
usb-storage: Bulk Command S 0x43425355 T 0x488 L 18 F 128 Trg 0 LUN 1 CL 6
usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
usb-storage: Status code 0; transferred 31/31
usb-storage: -- transfer complete
usb-storage: Bulk command transfer result=0
usb-storage: usb_stor_bulk_transfer_sglist: xfer 18 bytes, 1 entries
usb-storage: Status code 0; transferred 18/18
usb-storage: -- transfer complete
usb-storage: Bulk data transfer result 0x0
usb-storage: Attempting to get CSW...
usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
usb-storage: Status code 0; transferred 13/13
usb-storage: -- transfer complete
usb-storage: Bulk status result = 0
usb-storage: Bulk Status S 0x53425355 T 0x488 R 0 Stat 0x0
usb-storage: -- Result from auto-sense is 0
usb-storage: -- code: 0x70, key: 0x2, ASC: 0x3a, ASCQ: 0x0
usb-storage: Not Ready: Medium not present
usb-storage: scsi cmd done, result=0x2
usb-storage: *** thread sleeping.
usb-storage: queuecommand called
usb-storage: *** thread awakened.
usb-storage: Command TEST_UNIT_READY (6 bytes)
usb-storage:  00 00 00 00 00 00
usb-storage: Bulk Command S 0x43425355 T 0x489 L 0 F 0 Trg 0 LUN 0 CL 6
usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
usb-storage: Status code 0; transferred 31/31
usb-storage: -- transfer complete
usb-storage: Bulk command transfer result=0
usb-storage: Attempting to get CSW...
usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
usb-storage: Status code 0; transferred 13/13
usb-storage: -- transfer complete
usb-storage: Bulk status result = 0
usb-storage: Bulk Status S 0x53425355 T 0x489 R 0 Stat 0x1
usb-storage: -- transport indicates command failure
usb-storage: Issuing auto-REQUEST_SENSE
usb-storage: Bulk Command S 0x43425355 T 0x48a L 18 F 128 Trg 0 LUN 0 CL 6
usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
usb-storage: Status code 0; transferred 31/31
usb-storage: -- transfer complete
usb-storage: Bulk command transfer result=0
usb-storage: usb_stor_bulk_transfer_sglist: xfer 18 bytes, 1 entries
usb-storage: Status code 0; transferred 18/18
usb-storage: -- transfer complete
usb-storage: Bulk data transfer result 0x0
usb-storage: Attempting to get CSW...
usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
usb-storage: Status code 0; transferred 13/13
usb-storage: -- transfer complete
usb-storage: Bulk status result = 0
usb-storage: Bulk Status S 0x53425355 T 0x48a R 0 Stat 0x0
usb-storage: -- Result from auto-sense is 0
usb-storage: -- code: 0x70, key: 0x2, ASC: 0x3a, ASCQ: 0x0
usb-storage: Not Ready: Medium not present
usb-storage: scsi cmd done, result=0x2
usb-storage: *** thread sleeping.
usb-storage: queuecommand called
usb-storage: *** thread awakened.
usb-storage: Command TEST_UNIT_READY (6 bytes)
usb-storage:  00 00 00 00 00 00
usb-storage: Bulk Command S 0x43425355 T 0x48b L 0 F 0 Trg 0 LUN 1 CL 6
usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
usb-storage: Status code 0; transferred 31/31
usb-storage: -- transfer complete
usb-storage: Bulk command transfer result=0
usb-storage: Attempting to get CSW...
usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
usb-storage: Status code 0; transferred 13/13
usb-storage: -- transfer complete
usb-storage: Bulk status result = 0
usb-storage: Bulk Status S 0x53425355 T 0x48b R 0 Stat 0x1
usb-storage: -- transport indicates command failure
usb-storage: Issuing auto-REQUEST_SENSE
usb-storage: Bulk Command S 0x43425355 T 0x48c L 18 F 128 Trg 0 LUN 1 CL 6
usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
usb-storage: Status code 0; transferred 31/31
usb-storage: -- transfer complete
usb-storage: Bulk command transfer result=0
usb-storage: usb_stor_bulk_transfer_sglist: xfer 18 bytes, 1 entries
usb-storage: Status code 0; transferred 18/18
usb-storage: -- transfer complete
usb-storage: Bulk data transfer result 0x0
usb-storage: Attempting to get CSW...
usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
usb-storage: Status code 0; transferred 13/13
usb-storage: -- transfer complete
usb-storage: Bulk status result = 0
usb-storage: Bulk Status S 0x53425355 T 0x48c R 0 Stat 0x0
usb-storage: -- Result from auto-sense is 0
usb-storage: -- code: 0x70, key: 0x2, ASC: 0x3a, ASCQ: 0x0
usb-storage: Not Ready: Medium not present
usb-storage: scsi cmd done, result=0x2
usb-storage: *** thread sleeping.
Linux video capture interface: v2.00
usb-storage: queuecommand called
usb-storage: *** thread awakened.
usb-storage: Command TEST_UNIT_READY (6 bytes)
usb-storage:  00 00 00 00 00 00
usb-storage: Bulk Command S 0x43425355 T 0x48d L 0 F 0 Trg 0 LUN 0 CL 6
usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
usb-storage: Status code 0; transferred 31/31
usb-storage: -- transfer complete
usb-storage: Bulk command transfer result=0
usb-storage: Attempting to get CSW...
usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
usb-storage: Status code 0; transferred 13/13
usb-storage: -- transfer complete
usb-storage: Bulk status result = 0
usb-storage: Bulk Status S 0x53425355 T 0x48d R 0 Stat 0x1
usb-storage: -- transport indicates command failure
usb-storage: Issuing auto-REQUEST_SENSE
usb-storage: Bulk Command S 0x43425355 T 0x48e L 18 F 128 Trg 0 LUN 0 CL 6
usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
usb-storage: Status code 0; transferred 31/31
usb-storage: -- transfer complete
usb-storage: Bulk command transfer result=0
usb-storage: usb_stor_bulk_transfer_sglist: xfer 18 bytes, 1 entries
usb-storage: Status code 0; transferred 18/18
usb-storage: -- transfer complete
usb-storage: Bulk data transfer result 0x0
usb-storage: Attempting to get CSW...
usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
usb-storage: Status code 0; transferred 13/13
usb-storage: -- transfer complete
usb-storage: Bulk status result = 0
usb-storage: Bulk Status S 0x53425355 T 0x48e R 0 Stat 0x0
usb-storage: -- Result from auto-sense is 0
usb-storage: -- code: 0x70, key: 0x2, ASC: 0x3a, ASCQ: 0x0
usb-storage: Not Ready: Medium not present
usb-storage: scsi cmd done, result=0x2
usb-storage: *** thread sleeping.
usb-storage: queuecommand called
usb-storage: *** thread awakened.
usb-storage: Command TEST_UNIT_READY (6 bytes)
usb-storage:  00 00 00 00 00 00
usb-storage: Bulk Command S 0x43425355 T 0x48f L 0 F 0 Trg 0 LUN 1 CL 6
usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
usb-storage: Status code 0; transferred 31/31
usb-storage: -- transfer complete
usb-storage: Bulk command transfer result=0
usb-storage: Attempting to get CSW...
usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
usb-storage: Status code 0; transferred 13/13
usb-storage: -- transfer complete
usb-storage: Bulk status result = 0
usb-storage: Bulk Status S 0x53425355 T 0x48f R 0 Stat 0x1
usb-storage: -- transport indicates command failure
usb-storage: Issuing auto-REQUEST_SENSE
usb-storage: Bulk Command S 0x43425355 T 0x490 L 18 F 128 Trg 0 LUN 1 CL 6
usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
usb-storage: Status code 0; transferred 31/31
usb-storage: -- transfer complete
usb-storage: Bulk command transfer result=0
usb-storage: usb_stor_bulk_transfer_sglist: xfer 18 bytes, 1 entries
usb-storage: Status code 0; transferred 18/18
usb-storage: -- transfer complete
usb-storage: Bulk data transfer result 0x0
usb-storage: Attempting to get CSW...
usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
usb-storage: Status code 0; transferred 13/13
usb-storage: -- transfer complete
usb-storage: Bulk status result = 0
usb-storage: Bulk Status S 0x53425355 T 0x490 R 0 Stat 0x0
usb-storage: -- Result from auto-sense is 0
usb-storage: -- code: 0x70, key: 0x2, ASC: 0x3a, ASCQ: 0x0
usb-storage: Not Ready: Medium not present
usb-storage: scsi cmd done, result=0x2
usb-storage: *** thread sleeping.
usb-storage: queuecommand called
usb-storage: *** thread awakened.
usb-storage: Command TEST_UNIT_READY (6 bytes)
usb-storage:  00 00 00 00 00 00
usb-storage: Bulk Command S 0x43425355 T 0x491 L 0 F 0 Trg 0 LUN 0 CL 6
usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
usb-storage: Status code 0; transferred 31/31
usb-storage: -- transfer complete
usb-storage: Bulk command transfer result=0
usb-storage: Attempting to get CSW...
usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
usb-storage: Status code 0; transferred 13/13
usb-storage: -- transfer complete
usb-storage: Bulk status result = 0
usb-storage: Bulk Status S 0x53425355 T 0x491 R 0 Stat 0x1
usb-storage: -- transport indicates command failure
usb-storage: Issuing auto-REQUEST_SENSE
usb-storage: Bulk Command S 0x43425355 T 0x492 L 18 F 128 Trg 0 LUN 0 CL 6
usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
usb-storage: Status code 0; transferred 31/31
usb-storage: -- transfer complete
usb-storage: Bulk command transfer result=0
usb-storage: usb_stor_bulk_transfer_sglist: xfer 18 bytes, 1 entries
usb-storage: Status code 0; transferred 18/18
usb-storage: -- transfer complete
usb-storage: Bulk data transfer result 0x0
usb-storage: Attempting to get CSW...
usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
usb-storage: Status code 0; transferred 13/13
usb-storage: -- transfer complete
usb-storage: Bulk status result = 0
usb-storage: Bulk Status S 0x53425355 T 0x492 R 0 Stat 0x0
usb-storage: -- Result from auto-sense is 0
usb-storage: -- code: 0x70, key: 0x2, ASC: 0x3a, ASCQ: 0x0
usb-storage: Not Ready: Medium not present
usb-storage: scsi cmd done, result=0x2
usb-storage: *** thread sleeping.
usb-storage: queuecommand called
usb-storage: *** thread awakened.
usb-storage: Command TEST_UNIT_READY (6 bytes)
usb-storage:  00 00 00 00 00 00
usb-storage: Bulk Command S 0x43425355 T 0x493 L 0 F 0 Trg 0 LUN 1 CL 6
usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
usb-storage: Status code 0; transferred 31/31
usb-storage: -- transfer complete
usb-storage: Bulk command transfer result=0
usb-storage: Attempting to get CSW...
usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
usb-storage: Status code 0; transferred 13/13
usb-storage: -- transfer complete
usb-storage: Bulk status result = 0
usb-storage: Bulk Status S 0x53425355 T 0x493 R 0 Stat 0x1
usb-storage: -- transport indicates command failure
usb-storage: Issuing auto-REQUEST_SENSE
usb-storage: Bulk Command S 0x43425355 T 0x494 L 18 F 128 Trg 0 LUN 1 CL 6
usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
usb-storage: Status code 0; transferred 31/31
usb-storage: -- transfer complete
usb-storage: Bulk command transfer result=0
usb-storage: usb_stor_bulk_transfer_sglist: xfer 18 bytes, 1 entries
usb-storage: Status code 0; transferred 18/18
usb-storage: -- transfer complete
usb-storage: Bulk data transfer result 0x0
usb-storage: Attempting to get CSW...
usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
usb-storage: Status code 0; transferred 13/13
usb-storage: -- transfer complete
usb-storage: Bulk status result = 0
usb-storage: Bulk Status S 0x53425355 T 0x494 R 0 Stat 0x0
usb-storage: -- Result from auto-sense is 0
usb-storage: -- code: 0x70, key: 0x2, ASC: 0x3a, ASCQ: 0x0
usb-storage: Not Ready: Medium not present
usb-storage: scsi cmd done, result=0x2
usb-storage: *** thread sleeping.
cx88/0: cx2388x v4l2 driver version 0.0.6 loaded
ACPI: PCI Interrupt 0000:04:06.0[A] -> GSI 20 (level, low) -> IRQ 20
cx88[0]: subsystem: 17de:08c1, board: Kworld PlusTV HD PCI 120 (ATSC 
120) [card=67,autodetected]
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
xc2028 1-0061: Loading firmware for type=BASE (1), id 0000000000000000.
cx88[0]: Calling XC2028/3028 callback
usb-storage: queuecommand called
usb-storage: *** thread awakened.
usb-storage: Command TEST_UNIT_READY (6 bytes)
usb-storage:  00 00 00 00 00 00
usb-storage: Bulk Command S 0x43425355 T 0x495 L 0 F 0 Trg 0 LUN 0 CL 6
usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
usb-storage: Status code 0; transferred 31/31
usb-storage: -- transfer complete
usb-storage: Bulk command transfer result=0
usb-storage: Attempting to get CSW...
usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
usb-storage: Status code 0; transferred 13/13
usb-storage: -- transfer complete
usb-storage: Bulk status result = 0
usb-storage: Bulk Status S 0x53425355 T 0x495 R 0 Stat 0x1
usb-storage: -- transport indicates command failure
usb-storage: Issuing auto-REQUEST_SENSE
usb-storage: Bulk Command S 0x43425355 T 0x496 L 18 F 128 Trg 0 LUN 0 CL 6
usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
usb-storage: Status code 0; transferred 31/31
usb-storage: -- transfer complete
usb-storage: Bulk command transfer result=0
usb-storage: usb_stor_bulk_transfer_sglist: xfer 18 bytes, 1 entries
usb-storage: Status code 0; transferred 18/18
usb-storage: -- transfer complete
usb-storage: Bulk data transfer result 0x0
usb-storage: Attempting to get CSW...
usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
usb-storage: Status code 0; transferred 13/13
usb-storage: -- transfer complete
usb-storage: Bulk status result = 0
usb-storage: Bulk Status S 0x53425355 T 0x496 R 0 Stat 0x0
usb-storage: -- Result from auto-sense is 0
usb-storage: -- code: 0x70, key: 0x2, ASC: 0x3a, ASCQ: 0x0
usb-storage: Not Ready: Medium not present
usb-storage: scsi cmd done, result=0x2
usb-storage: *** thread sleeping.
usb-storage: queuecommand called
usb-storage: *** thread awakened.
usb-storage: Command TEST_UNIT_READY (6 bytes)
usb-storage:  00 00 00 00 00 00
usb-storage: Bulk Command S 0x43425355 T 0x497 L 0 F 0 Trg 0 LUN 0 CL 6
usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
usb-storage: Status code 0; transferred 31/31
usb-storage: -- transfer complete
usb-storage: Bulk command transfer result=0
usb-storage: Attempting to get CSW...
usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
usb-storage: Status code 0; transferred 13/13
usb-storage: -- transfer complete
usb-storage: Bulk status result = 0
usb-storage: Bulk Status S 0x53425355 T 0x497 R 0 Stat 0x1
usb-storage: -- transport indicates command failure
usb-storage: Issuing auto-REQUEST_SENSE
usb-storage: Bulk Command S 0x43425355 T 0x498 L 18 F 128 Trg 0 LUN 0 CL 6
usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
usb-storage: Status code 0; transferred 31/31
usb-storage: -- transfer complete
usb-storage: Bulk command transfer result=0
usb-storage: usb_stor_bulk_transfer_sglist: xfer 18 bytes, 1 entries
usb-storage: Status code 0; transferred 18/18
usb-storage: -- transfer complete
usb-storage: Bulk data transfer result 0x0
usb-storage: Attempting to get CSW...
usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
usb-storage: Status code 0; transferred 13/13
usb-storage: -- transfer complete
usb-storage: Bulk status result = 0
usb-storage: Bulk Status S 0x53425355 T 0x498 R 0 Stat 0x0
usb-storage: -- Result from auto-sense is 0
usb-storage: -- code: 0x70, key: 0x2, ASC: 0x3a, ASCQ: 0x0
usb-storage: Not Ready: Medium not present
usb-storage: scsi cmd done, result=0x2
usb-storage: *** thread sleeping.
usb-storage: queuecommand called
usb-storage: *** thread awakened.
usb-storage: Command TEST_UNIT_READY (6 bytes)
usb-storage:  00 00 00 00 00 00
usb-storage: Bulk Command S 0x43425355 T 0x499 L 0 F 0 Trg 0 LUN 1 CL 6
usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
usb-storage: Status code 0; transferred 31/31
usb-storage: -- transfer complete
usb-storage: Bulk command transfer result=0
usb-storage: Attempting to get CSW...
usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
usb-storage: Status code 0; transferred 13/13
usb-storage: -- transfer complete
usb-storage: Bulk status result = 0
usb-storage: Bulk Status S 0x53425355 T 0x499 R 0 Stat 0x1
usb-storage: -- transport indicates command failure
usb-storage: Issuing auto-REQUEST_SENSE
usb-storage: Bulk Command S 0x43425355 T 0x49a L 18 F 128 Trg 0 LUN 1 CL 6
usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
usb-storage: Status code 0; transferred 31/31
usb-storage: -- transfer complete
usb-storage: Bulk command transfer result=0
usb-storage: usb_stor_bulk_transfer_sglist: xfer 18 bytes, 1 entries
usb-storage: Status code 0; transferred 18/18
usb-storage: -- transfer complete
usb-storage: Bulk data transfer result 0x0
usb-storage: Attempting to get CSW...
usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
usb-storage: Status code 0; transferred 13/13
usb-storage: -- transfer complete
usb-storage: Bulk status result = 0
usb-storage: Bulk Status S 0x53425355 T 0x49a R 0 Stat 0x0
usb-storage: -- Result from auto-sense is 0
usb-storage: -- code: 0x70, key: 0x2, ASC: 0x3a, ASCQ: 0x0
usb-storage: Not Ready: Medium not present
usb-storage: scsi cmd done, result=0x2
usb-storage: *** thread sleeping.
usb-storage: queuecommand called
usb-storage: *** thread awakened.
usb-storage: Command TEST_UNIT_READY (6 bytes)
usb-storage:  00 00 00 00 00 00
usb-storage: Bulk Command S 0x43425355 T 0x49b L 0 F 0 Trg 0 LUN 1 CL 6
usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
usb-storage: Status code 0; transferred 31/31
usb-storage: -- transfer complete
usb-storage: Bulk command transfer result=0
usb-storage: Attempting to get CSW...
usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
usb-storage: Status code 0; transferred 13/13
usb-storage: -- transfer complete
usb-storage: Bulk status result = 0
usb-storage: Bulk Status S 0x53425355 T 0x49b R 0 Stat 0x1
usb-storage: -- transport indicates command failure
usb-storage: Issuing auto-REQUEST_SENSE
usb-storage: Bulk Command S 0x43425355 T 0x49c L 18 F 128 Trg 0 LUN 1 CL 6
usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
usb-storage: Status code 0; transferred 31/31
usb-storage: -- transfer complete
usb-storage: Bulk command transfer result=0
usb-storage: usb_stor_bulk_transfer_sglist: xfer 18 bytes, 1 entries
usb-storage: Status code 0; transferred 18/18
usb-storage: -- transfer complete
usb-storage: Bulk data transfer result 0x0
usb-storage: Attempting to get CSW...
usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
usb-storage: Status code 0; transferred 13/13
usb-storage: -- transfer complete
usb-storage: Bulk status result = 0
usb-storage: Bulk Status S 0x53425355 T 0x49c R 0 Stat 0x0
usb-storage: -- Result from auto-sense is 0
usb-storage: -- code: 0x70, key: 0x2, ASC: 0x3a, ASCQ: 0x0
usb-storage: Not Ready: Medium not present
usb-storage: scsi cmd done, result=0x2
usb-storage: *** thread sleeping.
xc2028 1-0061: Loading firmware for type=(0), id 000000000000b700.
SCODE (20000000), id 000000000000b700:
xc2028 1-0061: Loading SCODE for type=MONO SCODE HAS_IF_4320 (60008000), 
id 0000000000008000.
xc2028 1-0061: Incorrect readback of firmware version.
cx88[0]: Calling XC2028/3028 callback
xc2028 1-0061: Loading firmware for type=BASE (1), id 0000000000000000.
cx88[0]: Calling XC2028/3028 callback
usb-storage: queuecommand called
usb-storage: *** thread awakened.
usb-storage: Command TEST_UNIT_READY (6 bytes)
usb-storage:  00 00 00 00 00 00
usb-storage: Bulk Command S 0x43425355 T 0x49d L 0 F 0 Trg 0 LUN 0 CL 6
usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
usb-storage: Status code 0; transferred 31/31
usb-storage: -- transfer complete
usb-storage: Bulk command transfer result=0
usb-storage: Attempting to get CSW...
usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
usb-storage: Status code 0; transferred 13/13
usb-storage: -- transfer complete
usb-storage: Bulk status result = 0
usb-storage: Bulk Status S 0x53425355 T 0x49d R 0 Stat 0x1
usb-storage: -- transport indicates command failure
usb-storage: Issuing auto-REQUEST_SENSE
usb-storage: Bulk Command S 0x43425355 T 0x49e L 18 F 128 Trg 0 LUN 0 CL 6
usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
usb-storage: Status code 0; transferred 31/31
usb-storage: -- transfer complete
usb-storage: Bulk command transfer result=0
usb-storage: usb_stor_bulk_transfer_sglist: xfer 18 bytes, 1 entries
usb-storage: Status code 0; transferred 18/18
usb-storage: -- transfer complete
usb-storage: Bulk data transfer result 0x0
usb-storage: Attempting to get CSW...
usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
usb-storage: Status code 0; transferred 13/13
usb-storage: -- transfer complete
usb-storage: Bulk status result = 0
usb-storage: Bulk Status S 0x53425355 T 0x49e R 0 Stat 0x0
usb-storage: -- Result from auto-sense is 0
usb-storage: -- code: 0x70, key: 0x2, ASC: 0x3a, ASCQ: 0x0
usb-storage: Not Ready: Medium not present
usb-storage: scsi cmd done, result=0x2
usb-storage: *** thread sleeping.
usb-storage: queuecommand called
usb-storage: *** thread awakened.
usb-storage: Command TEST_UNIT_READY (6 bytes)
usb-storage:  00 00 00 00 00 00
usb-storage: Bulk Command S 0x43425355 T 0x49f L 0 F 0 Trg 0 LUN 1 CL 6
usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
usb-storage: Status code 0; transferred 31/31
usb-storage: -- transfer complete
usb-storage: Bulk command transfer result=0
usb-storage: Attempting to get CSW...
usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
usb-storage: Status code 0; transferred 13/13
usb-storage: -- transfer complete
usb-storage: Bulk status result = 0
usb-storage: Bulk Status S 0x53425355 T 0x49f R 0 Stat 0x1
usb-storage: -- transport indicates command failure
usb-storage: Issuing auto-REQUEST_SENSE
usb-storage: Bulk Command S 0x43425355 T 0x4a0 L 18 F 128 Trg 0 LUN 1 CL 6
usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
usb-storage: Status code 0; transferred 31/31
usb-storage: -- transfer complete
usb-storage: Bulk command transfer result=0
usb-storage: usb_stor_bulk_transfer_sglist: xfer 18 bytes, 1 entries
usb-storage: Status code 0; transferred 18/18
usb-storage: -- transfer complete
usb-storage: Bulk data transfer result 0x0
usb-storage: Attempting to get CSW...
usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
usb-storage: Status code 0; transferred 13/13
usb-storage: -- transfer complete
usb-storage: Bulk status result = 0
usb-storage: Bulk Status S 0x53425355 T 0x4a0 R 0 Stat 0x0
usb-storage: -- Result from auto-sense is 0
usb-storage: -- code: 0x70, key: 0x2, ASC: 0x3a, ASCQ: 0x0
usb-storage: Not Ready: Medium not present
usb-storage: scsi cmd done, result=0x2
usb-storage: *** thread sleeping.
usb-storage: queuecommand called
usb-storage: *** thread awakened.
usb-storage: Command TEST_UNIT_READY (6 bytes)
usb-storage:  00 00 00 00 00 00
usb-storage: Bulk Command S 0x43425355 T 0x4a1 L 0 F 0 Trg 0 LUN 0 CL 6
usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
usb-storage: Status code 0; transferred 31/31
usb-storage: -- transfer complete
usb-storage: Bulk command transfer result=0
usb-storage: Attempting to get CSW...
usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
usb-storage: Status code 0; transferred 13/13
usb-storage: -- transfer complete
usb-storage: Bulk status result = 0
usb-storage: Bulk Status S 0x53425355 T 0x4a1 R 0 Stat 0x1
usb-storage: -- transport indicates command failure
usb-storage: Issuing auto-REQUEST_SENSE
usb-storage: Bulk Command S 0x43425355 T 0x4a2 L 18 F 128 Trg 0 LUN 0 CL 6
usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
usb-storage: Status code 0; transferred 31/31
usb-storage: -- transfer complete
usb-storage: Bulk command transfer result=0
usb-storage: usb_stor_bulk_transfer_sglist: xfer 18 bytes, 1 entries
usb-storage: Status code 0; transferred 18/18
usb-storage: -- transfer complete
usb-storage: Bulk data transfer result 0x0
usb-storage: Attempting to get CSW...
usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
usb-storage: Status code 0; transferred 13/13
usb-storage: -- transfer complete
usb-storage: Bulk status result = 0
usb-storage: Bulk Status S 0x53425355 T 0x4a2 R 0 Stat 0x0
usb-storage: -- Result from auto-sense is 0
usb-storage: -- code: 0x70, key: 0x2, ASC: 0x3a, ASCQ: 0x0
usb-storage: Not Ready: Medium not present
usb-storage: scsi cmd done, result=0x2
usb-storage: *** thread sleeping.
usb-storage: queuecommand called
usb-storage: *** thread awakened.
usb-storage: Command TEST_UNIT_READY (6 bytes)
usb-storage:  00 00 00 00 00 00
usb-storage: Bulk Command S 0x43425355 T 0x4a3 L 0 F 0 Trg 0 LUN 1 CL 6
usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
usb-storage: Status code 0; transferred 31/31
usb-storage: -- transfer complete
usb-storage: Bulk command transfer result=0
usb-storage: Attempting to get CSW...
usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
usb-storage: Status code 0; transferred 13/13
usb-storage: -- transfer complete
usb-storage: Bulk status result = 0
usb-storage: Bulk Status S 0x53425355 T 0x4a3 R 0 Stat 0x1
usb-storage: -- transport indicates command failure
usb-storage: Issuing auto-REQUEST_SENSE
usb-storage: Bulk Command S 0x43425355 T 0x4a4 L 18 F 128 Trg 0 LUN 1 CL 6
usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
usb-storage: Status code 0; transferred 31/31
usb-storage: -- transfer complete
usb-storage: Bulk command transfer result=0
usb-storage: usb_stor_bulk_transfer_sglist: xfer 18 bytes, 1 entries
usb-storage: Status code 0; transferred 18/18
usb-storage: -- transfer complete
usb-storage: Bulk data transfer result 0x0
usb-storage: Attempting to get CSW...
usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
usb-storage: Status code 0; transferred 13/13
usb-storage: -- transfer complete
usb-storage: Bulk status result = 0
usb-storage: Bulk Status S 0x53425355 T 0x4a4 R 0 Stat 0x0
usb-storage: -- Result from auto-sense is 0
usb-storage: -- code: 0x70, key: 0x2, ASC: 0x3a, ASCQ: 0x0
usb-storage: Not Ready: Medium not present
usb-storage: scsi cmd done, result=0x2
usb-storage: *** thread sleeping.
xc2028 1-0061: Loading firmware for type=(0), id 000000000000b700.
SCODE (20000000), id 000000000000b700:
xc2028 1-0061: Loading SCODE for type=MONO SCODE HAS_IF_4320 (60008000), 
id 0000000000008000.
cx88[0]: Calling XC2028/3028 callback
cx88[0]: Calling XC2028/3028 callback
xc2028 1-0061: Loading firmware for type=BASE FM (401), id 0000000000000000.
cx88[0]: Calling XC2028/3028 callback
usb-storage: queuecommand called
usb-storage: *** thread awakened.
usb-storage: Command TEST_UNIT_READY (6 bytes)
usb-storage:  00 00 00 00 00 00
usb-storage: Bulk Command S 0x43425355 T 0x4a5 L 0 F 0 Trg 0 LUN 0 CL 6
usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
usb-storage: Status code 0; transferred 31/31
usb-storage: -- transfer complete
usb-storage: Bulk command transfer result=0
usb-storage: Attempting to get CSW...
usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
usb-storage: Status code 0; transferred 13/13
usb-storage: -- transfer complete
usb-storage: Bulk status result = 0
usb-storage: Bulk Status S 0x53425355 T 0x4a5 R 0 Stat 0x1
usb-storage: -- transport indicates command failure
usb-storage: Issuing auto-REQUEST_SENSE
usb-storage: Bulk Command S 0x43425355 T 0x4a6 L 18 F 128 Trg 0 LUN 0 CL 6
usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
usb-storage: Status code 0; transferred 31/31
usb-storage: -- transfer complete
usb-storage: Bulk command transfer result=0
usb-storage: usb_stor_bulk_transfer_sglist: xfer 18 bytes, 1 entries
usb-storage: Status code 0; transferred 18/18
usb-storage: -- transfer complete
usb-storage: Bulk data transfer result 0x0
usb-storage: Attempting to get CSW...
usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
usb-storage: Status code 0; transferred 13/13
usb-storage: -- transfer complete
usb-storage: Bulk status result = 0
usb-storage: Bulk Status S 0x53425355 T 0x4a6 R 0 Stat 0x0
usb-storage: -- Result from auto-sense is 0
usb-storage: -- code: 0x70, key: 0x2, ASC: 0x3a, ASCQ: 0x0
usb-storage: Not Ready: Medium not present
usb-storage: scsi cmd done, result=0x2
usb-storage: *** thread sleeping.
usb-storage: queuecommand called
usb-storage: *** thread awakened.
usb-storage: Command TEST_UNIT_READY (6 bytes)
usb-storage:  00 00 00 00 00 00
usb-storage: Bulk Command S 0x43425355 T 0x4a7 L 0 F 0 Trg 0 LUN 1 CL 6
usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
usb-storage: Status code 0; transferred 31/31
usb-storage: -- transfer complete
usb-storage: Bulk command transfer result=0
usb-storage: Attempting to get CSW...
usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
usb-storage: Status code 0; transferred 13/13
usb-storage: -- transfer complete
usb-storage: Bulk status result = 0
usb-storage: Bulk Status S 0x53425355 T 0x4a7 R 0 Stat 0x1
usb-storage: -- transport indicates command failure
usb-storage: Issuing auto-REQUEST_SENSE
usb-storage: Bulk Command S 0x43425355 T 0x4a8 L 18 F 128 Trg 0 LUN 1 CL 6
usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
usb-storage: Status code 0; transferred 31/31
usb-storage: -- transfer complete
usb-storage: Bulk command transfer result=0
usb-storage: usb_stor_bulk_transfer_sglist: xfer 18 bytes, 1 entries
usb-storage: Status code 0; transferred 18/18
usb-storage: -- transfer complete
usb-storage: Bulk data transfer result 0x0
usb-storage: Attempting to get CSW...
usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
usb-storage: Status code 0; transferred 13/13
usb-storage: -- transfer complete
usb-storage: Bulk status result = 0
usb-storage: Bulk Status S 0x53425355 T 0x4a8 R 0 Stat 0x0
usb-storage: -- Result from auto-sense is 0
usb-storage: -- code: 0x70, key: 0x2, ASC: 0x3a, ASCQ: 0x0
usb-storage: Not Ready: Medium not present
usb-storage: scsi cmd done, result=0x2
usb-storage: *** thread sleeping.
usb-storage: queuecommand called
usb-storage: *** thread awakened.
usb-storage: Command TEST_UNIT_READY (6 bytes)
usb-storage:  00 00 00 00 00 00
usb-storage: Bulk Command S 0x43425355 T 0x4a9 L 0 F 0 Trg 0 LUN 0 CL 6
usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
usb-storage: Status code 0; transferred 31/31
usb-storage: -- transfer complete
usb-storage: Bulk command transfer result=0
usb-storage: Attempting to get CSW...
usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
usb-storage: Status code 0; transferred 13/13
usb-storage: -- transfer complete
usb-storage: Bulk status result = 0
usb-storage: Bulk Status S 0x53425355 T 0x4a9 R 0 Stat 0x1
usb-storage: -- transport indicates command failure
usb-storage: Issuing auto-REQUEST_SENSE
usb-storage: Bulk Command S 0x43425355 T 0x4aa L 18 F 128 Trg 0 LUN 0 CL 6
usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
usb-storage: Status code 0; transferred 31/31
usb-storage: -- transfer complete
usb-storage: Bulk command transfer result=0
usb-storage: usb_stor_bulk_transfer_sglist: xfer 18 bytes, 1 entries
usb-storage: Status code 0; transferred 18/18
usb-storage: -- transfer complete
usb-storage: Bulk data transfer result 0x0
usb-storage: Attempting to get CSW...
usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
usb-storage: Status code 0; transferred 13/13
usb-storage: -- transfer complete
usb-storage: Bulk status result = 0
usb-storage: Bulk Status S 0x53425355 T 0x4aa R 0 Stat 0x0
usb-storage: -- Result from auto-sense is 0
usb-storage: -- code: 0x70, key: 0x2, ASC: 0x3a, ASCQ: 0x0
usb-storage: Not Ready: Medium not present
usb-storage: scsi cmd done, result=0x2
usb-storage: *** thread sleeping.
usb-storage: queuecommand called
usb-storage: *** thread awakened.
usb-storage: Command TEST_UNIT_READY (6 bytes)
usb-storage:  00 00 00 00 00 00
usb-storage: Bulk Command S 0x43425355 T 0x4ab L 0 F 0 Trg 0 LUN 1 CL 6
usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
usb-storage: Status code 0; transferred 31/31
usb-storage: -- transfer complete
usb-storage: Bulk command transfer result=0
usb-storage: Attempting to get CSW...
usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
usb-storage: Status code 0; transferred 13/13
usb-storage: -- transfer complete
usb-storage: Bulk status result = 0
usb-storage: Bulk Status S 0x53425355 T 0x4ab R 0 Stat 0x1
usb-storage: -- transport indicates command failure
usb-storage: Issuing auto-REQUEST_SENSE
usb-storage: Bulk Command S 0x43425355 T 0x4ac L 18 F 128 Trg 0 LUN 1 CL 6
usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
usb-storage: Status code 0; transferred 31/31
usb-storage: -- transfer complete
usb-storage: Bulk command transfer result=0
usb-storage: usb_stor_bulk_transfer_sglist: xfer 18 bytes, 1 entries
usb-storage: Status code 0; transferred 18/18
usb-storage: -- transfer complete
usb-storage: Bulk data transfer result 0x0
usb-storage: Attempting to get CSW...
usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
usb-storage: Status code 0; transferred 13/13
usb-storage: -- transfer complete
usb-storage: Bulk status result = 0
usb-storage: Bulk Status S 0x53425355 T 0x4ac R 0 Stat 0x0
usb-storage: -- Result from auto-sense is 0
usb-storage: -- code: 0x70, key: 0x2, ASC: 0x3a, ASCQ: 0x0
usb-storage: Not Ready: Medium not present
usb-storage: scsi cmd done, result=0x2
usb-storage: *** thread sleeping.
xc2028 1-0061: Loading firmware for type=FM (400), id 0000000000000000.
cx88[0]: Calling XC2028/3028 callback
usb-storage: queuecommand called
usb-storage: *** thread awakened.
usb-storage: Command TEST_UNIT_READY (6 bytes)
usb-storage:  00 00 00 00 00 00
usb-storage: Bulk Command S 0x43425355 T 0x4ad L 0 F 0 Trg 0 LUN 0 CL 6
usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
usb-storage: Status code 0; transferred 31/31
usb-storage: -- transfer complete
usb-storage: Bulk command transfer result=0
usb-storage: Attempting to get CSW...
usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
usb-storage: Status code 0; transferred 13/13
usb-storage: -- transfer complete
usb-storage: Bulk status result = 0
usb-storage: Bulk Status S 0x53425355 T 0x4ad R 0 Stat 0x1
usb-storage: -- transport indicates command failure
usb-storage: Issuing auto-REQUEST_SENSE
usb-storage: Bulk Command S 0x43425355 T 0x4ae L 18 F 128 Trg 0 LUN 0 CL 6
usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
usb-storage: Status code 0; transferred 31/31
usb-storage: -- transfer complete
usb-storage: Bulk command transfer result=0
usb-storage: usb_stor_bulk_transfer_sglist: xfer 18 bytes, 1 entries
usb-storage: Status code 0; transferred 18/18
usb-storage: -- transfer complete
usb-storage: Bulk data transfer result 0x0
usb-storage: Attempting to get CSW...
usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
usb-storage: Status code 0; transferred 13/13
usb-storage: -- transfer complete
usb-storage: Bulk status result = 0
usb-storage: Bulk Status S 0x53425355 T 0x4ae R 0 Stat 0x0
usb-storage: -- Result from auto-sense is 0
usb-storage: -- code: 0x70, key: 0x2, ASC: 0x3a, ASCQ: 0x0
usb-storage: Not Ready: Medium not present
usb-storage: scsi cmd done, result=0x2
usb-storage: *** thread sleeping.
usb-storage: queuecommand called
usb-storage: *** thread awakened.
usb-storage: Command TEST_UNIT_READY (6 bytes)
usb-storage:  00 00 00 00 00 00
usb-storage: Bulk Command S 0x43425355 T 0x4af L 0 F 0 Trg 0 LUN 0 CL 6
usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
usb-storage: Status code 0; transferred 31/31
usb-storage: -- transfer complete
usb-storage: Bulk command transfer result=0
usb-storage: Attempting to get CSW...
usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
usb-storage: Status code 0; transferred 13/13
usb-storage: -- transfer complete
usb-storage: Bulk status result = 0
usb-storage: Bulk Status S 0x53425355 T 0x4af R 0 Stat 0x1
usb-storage: -- transport indicates command failure
usb-storage: Issuing auto-REQUEST_SENSE
usb-storage: Bulk Command S 0x43425355 T 0x4b0 L 18 F 128 Trg 0 LUN 0 CL 6
usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
usb-storage: Status code 0; transferred 31/31
usb-storage: -- transfer complete
usb-storage: Bulk command transfer result=0
usb-storage: usb_stor_bulk_transfer_sglist: xfer 18 bytes, 1 entries
usb-storage: Status code 0; transferred 18/18
usb-storage: -- transfer complete
usb-storage: Bulk data transfer result 0x0
usb-storage: Attempting to get CSW...
usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
usb-storage: Status code 0; transferred 13/13
usb-storage: -- transfer complete
usb-storage: Bulk status result = 0
usb-storage: Bulk Status S 0x53425355 T 0x4b0 R 0 Stat 0x0
usb-storage: -- Result from auto-sense is 0
usb-storage: -- code: 0x70, key: 0x2, ASC: 0x3a, ASCQ: 0x0
usb-storage: Not Ready: Medium not present
usb-storage: scsi cmd done, result=0x2
usb-storage: *** thread sleeping.
usb-storage: queuecommand called
usb-storage: *** thread awakened.
usb-storage: Command TEST_UNIT_READY (6 bytes)
usb-storage:  00 00 00 00 00 00
usb-storage: Bulk Command S 0x43425355 T 0x4b1 L 0 F 0 Trg 0 LUN 1 CL 6
usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
usb-storage: Status code 0; transferred 31/31
usb-storage: -- transfer complete
usb-storage: Bulk command transfer result=0
usb-storage: Attempting to get CSW...
usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
usb-storage: Status code 0; transferred 13/13
usb-storage: -- transfer complete
usb-storage: Bulk status result = 0
usb-storage: Bulk Status S 0x53425355 T 0x4b1 R 0 Stat 0x1
usb-storage: -- transport indicates command failure
usb-storage: Issuing auto-REQUEST_SENSE
usb-storage: Bulk Command S 0x43425355 T 0x4b2 L 18 F 128 Trg 0 LUN 1 CL 6
usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
usb-storage: Status code 0; transferred 31/31
usb-storage: -- transfer complete
usb-storage: Bulk command transfer result=0
usb-storage: usb_stor_bulk_transfer_sglist: xfer 18 bytes, 1 entries
usb-storage: Status code 0; transferred 18/18
usb-storage: -- transfer complete
usb-storage: Bulk data transfer result 0x0
usb-storage: Attempting to get CSW...
usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
usb-storage: Status code 0; transferred 13/13
usb-storage: -- transfer complete
usb-storage: Bulk status result = 0
usb-storage: Bulk Status S 0x53425355 T 0x4b2 R 0 Stat 0x0
usb-storage: -- Result from auto-sense is 0
usb-storage: -- code: 0x70, key: 0x2, ASC: 0x3a, ASCQ: 0x0
usb-storage: Not Ready: Medium not present
usb-storage: scsi cmd done, result=0x2
usb-storage: *** thread sleeping.
usb-storage: queuecommand called
usb-storage: *** thread awakened.
usb-storage: Command TEST_UNIT_READY (6 bytes)
usb-storage:  00 00 00 00 00 00
usb-storage: Bulk Command S 0x43425355 T 0x4b3 L 0 F 0 Trg 0 LUN 1 CL 6
usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
usb-storage: Status code 0; transferred 31/31
usb-storage: -- transfer complete
usb-storage: Bulk command transfer result=0
usb-storage: Attempting to get CSW...
usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
usb-storage: Status code 0; transferred 13/13
usb-storage: -- transfer complete
usb-storage: Bulk status result = 0
usb-storage: Bulk Status S 0x53425355 T 0x4b3 R 0 Stat 0x1
usb-storage: -- transport indicates command failure
usb-storage: Issuing auto-REQUEST_SENSE
usb-storage: Bulk Command S 0x43425355 T 0x4b4 L 18 F 128 Trg 0 LUN 1 CL 6
usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
usb-storage: Status code 0; transferred 31/31
usb-storage: -- transfer complete
usb-storage: Bulk command transfer result=0
usb-storage: usb_stor_bulk_transfer_sglist: xfer 18 bytes, 1 entries
usb-storage: Status code 0; transferred 18/18
usb-storage: -- transfer complete
usb-storage: Bulk data transfer result 0x0
usb-storage: Attempting to get CSW...
usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
usb-storage: Status code 0; transferred 13/13
usb-storage: -- transfer complete
usb-storage: Bulk status result = 0
usb-storage: Bulk Status S 0x53425355 T 0x4b4 R 0 Stat 0x0
usb-storage: -- Result from auto-sense is 0
usb-storage: -- code: 0x70, key: 0x2, ASC: 0x3a, ASCQ: 0x0
usb-storage: Not Ready: Medium not present
usb-storage: scsi cmd done, result=0x2
usb-storage: *** thread sleeping.
usb-storage: queuecommand called
usb-storage: *** thread awakened.
usb-storage: Command TEST_UNIT_READY (6 bytes)
usb-storage:  00 00 00 00 00 00
usb-storage: Bulk Command S 0x43425355 T 0x4b5 L 0 F 0 Trg 0 LUN 0 CL 6
usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
usb-storage: Status code 0; transferred 31/31
usb-storage: -- transfer complete
usb-storage: Bulk command transfer result=0
usb-storage: Attempting to get CSW...
usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
usb-storage: Status code 0; transferred 13/13
usb-storage: -- transfer complete
usb-storage: Bulk status result = 0
usb-storage: Bulk Status S 0x53425355 T 0x4b5 R 0 Stat 0x1
usb-storage: -- transport indicates command failure
usb-storage: Issuing auto-REQUEST_SENSE
usb-storage: Bulk Command S 0x43425355 T 0x4b6 L 18 F 128 Trg 0 LUN 0 CL 6
usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
usb-storage: Status code 0; transferred 31/31
usb-storage: -- transfer complete
usb-storage: Bulk command transfer result=0
usb-storage: usb_stor_bulk_transfer_sglist: xfer 18 bytes, 1 entries
usb-storage: Status code 0; transferred 18/18
usb-storage: -- transfer complete
usb-storage: Bulk data transfer result 0x0
usb-storage: Attempting to get CSW...
usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
usb-storage: Status code 0; transferred 13/13
usb-storage: -- transfer complete
usb-storage: Bulk status result = 0
usb-storage: Bulk Status S 0x53425355 T 0x4b6 R 0 Stat 0x0
usb-storage: -- Result from auto-sense is 0
usb-storage: -- code: 0x70, key: 0x2, ASC: 0x3a, ASCQ: 0x0
usb-storage: Not Ready: Medium not present
usb-storage: scsi cmd done, result=0x2
usb-storage: *** thread sleeping.
usb-storage: queuecommand called
usb-storage: *** thread awakened.
usb-storage: Command TEST_UNIT_READY (6 bytes)
usb-storage:  00 00 00 00 00 00
usb-storage: Bulk Command S 0x43425355 T 0x4b7 L 0 F 0 Trg 0 LUN 0 CL 6
usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
usb-storage: Status code 0; transferred 31/31
usb-storage: -- transfer complete
usb-storage: Bulk command transfer result=0
usb-storage: Attempting to get CSW...
usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
usb-storage: Status code 0; transferred 13/13
usb-storage: -- transfer complete
usb-storage: Bulk status result = 0
usb-storage: Bulk Status S 0x53425355 T 0x4b7 R 0 Stat 0x1
usb-storage: -- transport indicates command failure
usb-storage: Issuing auto-REQUEST_SENSE
usb-storage: Bulk Command S 0x43425355 T 0x4b8 L 18 F 128 Trg 0 LUN 0 CL 6
usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
usb-storage: Status code 0; transferred 31/31
usb-storage: -- transfer complete
usb-storage: Bulk command transfer result=0
usb-storage: usb_stor_bulk_transfer_sglist: xfer 18 bytes, 1 entries
usb-storage: Status code 0; transferred 18/18
usb-storage: -- transfer complete
usb-storage: Bulk data transfer result 0x0
usb-storage: Attempting to get CSW...
usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
usb-storage: Status code 0; transferred 13/13
usb-storage: -- transfer complete
usb-storage: Bulk status result = 0
usb-storage: Bulk Status S 0x53425355 T 0x4b8 R 0 Stat 0x0
usb-storage: -- Result from auto-sense is 0
usb-storage: -- code: 0x70, key: 0x2, ASC: 0x3a, ASCQ: 0x0
usb-storage: Not Ready: Medium not present
usb-storage: scsi cmd done, result=0x2
usb-storage: *** thread sleeping.
usb-storage: queuecommand called
usb-storage: *** thread awakened.
usb-storage: Command TEST_UNIT_READY (6 bytes)
usb-storage:  00 00 00 00 00 00
usb-storage: Bulk Command S 0x43425355 T 0x4b9 L 0 F 0 Trg 0 LUN 1 CL 6
usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
usb-storage: Status code 0; transferred 31/31
usb-storage: -- transfer complete
usb-storage: Bulk command transfer result=0
usb-storage: Attempting to get CSW...
usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
usb-storage: Status code 0; transferred 13/13
usb-storage: -- transfer complete
usb-storage: Bulk status result = 0
usb-storage: Bulk Status S 0x53425355 T 0x4b9 R 0 Stat 0x1
usb-storage: -- transport indicates command failure
usb-storage: Issuing auto-REQUEST_SENSE
usb-storage: Bulk Command S 0x43425355 T 0x4ba L 18 F 128 Trg 0 LUN 1 CL 6
usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
usb-storage: Status code 0; transferred 31/31
usb-storage: -- transfer complete
usb-storage: Bulk command transfer result=0
usb-storage: usb_stor_bulk_transfer_sglist: xfer 18 bytes, 1 entries
usb-storage: Status code 0; transferred 18/18
usb-storage: -- transfer complete
usb-storage: Bulk data transfer result 0x0
usb-storage: Attempting to get CSW...
usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
usb-storage: Status code 0; transferred 13/13
usb-storage: -- transfer complete
usb-storage: Bulk status result = 0
usb-storage: Bulk Status S 0x53425355 T 0x4ba R 0 Stat 0x0
usb-storage: -- Result from auto-sense is 0
usb-storage: -- code: 0x70, key: 0x2, ASC: 0x3a, ASCQ: 0x0
usb-storage: Not Ready: Medium not present
usb-storage: scsi cmd done, result=0x2
usb-storage: *** thread sleeping.
usb-storage: queuecommand called
usb-storage: *** thread awakened.
usb-storage: Command TEST_UNIT_READY (6 bytes)
usb-storage:  00 00 00 00 00 00
usb-storage: Bulk Command S 0x43425355 T 0x4bb L 0 F 0 Trg 0 LUN 1 CL 6
usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
usb-storage: Status code 0; transferred 31/31
usb-storage: -- transfer complete
usb-storage: Bulk command transfer result=0
usb-storage: Attempting to get CSW...
usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
usb-storage: Status code 0; transferred 13/13
usb-storage: -- transfer complete
usb-storage: Bulk status result = 0
usb-storage: Bulk Status S 0x53425355 T 0x4bb R 0 Stat 0x1
usb-storage: -- transport indicates command failure
usb-storage: Issuing auto-REQUEST_SENSE
usb-storage: Bulk Command S 0x43425355 T 0x4bc L 18 F 128 Trg 0 LUN 1 CL 6
usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
usb-storage: Status code 0; transferred 31/31
usb-storage: -- transfer complete
usb-storage: Bulk command transfer result=0
usb-storage: usb_stor_bulk_transfer_sglist: xfer 18 bytes, 1 entries
usb-storage: Status code 0; transferred 18/18
usb-storage: -- transfer complete
usb-storage: Bulk data transfer result 0x0
usb-storage: Attempting to get CSW...
usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
usb-storage: Status code 0; transferred 13/13
usb-storage: -- transfer complete
usb-storage: Bulk status result = 0
usb-storage: Bulk Status S 0x53425355 T 0x4bc R 0 Stat 0x0
usb-storage: -- Result from auto-sense is 0
usb-storage: -- code: 0x70, key: 0x2, ASC: 0x3a, ASCQ: 0x0
usb-storage: Not Ready: Medium not present
usb-storage: scsi cmd done, result=0x2
usb-storage: *** thread sleeping.
usb-storage: queuecommand called
usb-storage: *** thread awakened.
usb-storage: Command TEST_UNIT_READY (6 bytes)
usb-storage:  00 00 00 00 00 00
usb-storage: Bulk Command S 0x43425355 T 0x4bd L 0 F 0 Trg 0 LUN 1 CL 6
usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
usb-storage: Status code 0; transferred 31/31
usb-storage: -- transfer complete
usb-storage: Bulk command transfer result=0
usb-storage: Attempting to get CSW...
usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
usb-storage: Status code 0; transferred 13/13
usb-storage: -- transfer complete
usb-storage: Bulk status result = 0
usb-storage: Bulk Status S 0x53425355 T 0x4bd R 0 Stat 0x1
usb-storage: -- transport indicates command failure
usb-storage: Issuing auto-REQUEST_SENSE
usb-storage: Bulk Command S 0x43425355 T 0x4be L 18 F 128 Trg 0 LUN 1 CL 6
usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
usb-storage: Status code 0; transferred 31/31
usb-storage: -- transfer complete
usb-storage: Bulk command transfer result=0
usb-storage: usb_stor_bulk_transfer_sglist: xfer 18 bytes, 1 entries
usb-storage: Status code 0; transferred 18/18
usb-storage: -- transfer complete
usb-storage: Bulk data transfer result 0x0
usb-storage: Attempting to get CSW...
usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
usb-storage: Status code 0; transferred 13/13
usb-storage: -- transfer complete
usb-storage: Bulk status result = 0
usb-storage: Bulk Status S 0x53425355 T 0x4be R 0 Stat 0x0
usb-storage: -- Result from auto-sense is 0
usb-storage: -- code: 0x70, key: 0x2, ASC: 0x3a, ASCQ: 0x0
usb-storage: Not Ready: Medium not present
usb-storage: scsi cmd done, result=0x2
usb-storage: *** thread sleeping.
usb-storage: queuecommand called
usb-storage: *** thread awakened.
usb-storage: Command TEST_UNIT_READY (6 bytes)
usb-storage:  00 00 00 00 00 00
usb-storage: Bulk Command S 0x43425355 T 0x4bf L 0 F 0 Trg 0 LUN 1 CL 6
usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
usb-storage: Status code 0; transferred 31/31
usb-storage: -- transfer complete
usb-storage: Bulk command transfer result=0
usb-storage: Attempting to get CSW...
usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
usb-storage: Status code 0; transferred 13/13
usb-storage: -- transfer complete
usb-storage: Bulk status result = 0
usb-storage: Bulk Status S 0x53425355 T 0x4bf R 0 Stat 0x1
usb-storage: -- transport indicates command failure
usb-storage: Issuing auto-REQUEST_SENSE
usb-storage: Bulk Command S 0x43425355 T 0x4c0 L 18 F 128 Trg 0 LUN 1 CL 6
usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
usb-storage: Status code 0; transferred 31/31
usb-storage: -- transfer complete
usb-storage: Bulk command transfer result=0
usb-storage: usb_stor_bulk_transfer_sglist: xfer 18 bytes, 1 entries
usb-storage: Status code 0; transferred 18/18
usb-storage: -- transfer complete
usb-storage: Bulk data transfer result 0x0
usb-storage: Attempting to get CSW...
usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
usb-storage: Status code 0; transferred 13/13
usb-storage: -- transfer complete
usb-storage: Bulk status result = 0
usb-storage: Bulk Status S 0x53425355 T 0x4c0 R 0 Stat 0x0
usb-storage: -- Result from auto-sense is 0
usb-storage: -- code: 0x70, key: 0x2, ASC: 0x3a, ASCQ: 0x0
usb-storage: Not Ready: Medium not present
usb-storage: scsi cmd done, result=0x2
usb-storage: *** thread sleeping.
usb-storage: queuecommand called
usb-storage: *** thread awakened.
usb-storage: Command TEST_UNIT_READY (6 bytes)
usb-storage:  00 00 00 00 00 00
usb-storage: Bulk Command S 0x43425355 T 0x4c1 L 0 F 0 Trg 0 LUN 0 CL 6
usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
usb-storage: Status code 0; transferred 31/31
usb-storage: -- transfer complete
usb-storage: Bulk command transfer result=0
usb-storage: Attempting to get CSW...
usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
usb-storage: Status code 0; transferred 13/13
usb-storage: -- transfer complete
usb-storage: Bulk status result = 0
usb-storage: Bulk Status S 0x53425355 T 0x4c1 R 0 Stat 0x1
usb-storage: -- transport indicates command failure
usb-storage: Issuing auto-REQUEST_SENSE
usb-storage: Bulk Command S 0x43425355 T 0x4c2 L 18 F 128 Trg 0 LUN 0 CL 6
usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
usb-storage: Status code 0; transferred 31/31
usb-storage: -- transfer complete
usb-storage: Bulk command transfer result=0
usb-storage: usb_stor_bulk_transfer_sglist: xfer 18 bytes, 1 entries
usb-storage: Status code 0; transferred 18/18
usb-storage: -- transfer complete
usb-storage: Bulk data transfer result 0x0
usb-storage: Attempting to get CSW...
usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
usb-storage: Status code 0; transferred 13/13
usb-storage: -- transfer complete
usb-storage: Bulk status result = 0
usb-storage: Bulk Status S 0x53425355 T 0x4c2 R 0 Stat 0x0
usb-storage: -- Result from auto-sense is 0
usb-storage: -- code: 0x70, key: 0x2, ASC: 0x3a, ASCQ: 0x0
usb-storage: Not Ready: Medium not present
usb-storage: scsi cmd done, result=0x2
usb-storage: *** thread sleeping.
usb-storage: queuecommand called
usb-storage: *** thread awakened.
usb-storage: Command TEST_UNIT_READY (6 bytes)
usb-storage:  00 00 00 00 00 00
usb-storage: Bulk Command S 0x43425355 T 0x4c3 L 0 F 0 Trg 0 LUN 0 CL 6
usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
usb-storage: Status code 0; transferred 31/31
usb-storage: -- transfer complete
usb-storage: Bulk command transfer result=0
usb-storage: Attempting to get CSW...
usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
usb-storage: Status code 0; transferred 13/13
usb-storage: -- transfer complete
usb-storage: Bulk status result = 0
usb-storage: Bulk Status S 0x53425355 T 0x4c3 R 0 Stat 0x1
usb-storage: -- transport indicates command failure
usb-storage: Issuing auto-REQUEST_SENSE
usb-storage: Bulk Command S 0x43425355 T 0x4c4 L 18 F 128 Trg 0 LUN 0 CL 6
usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
usb-storage: Status code 0; transferred 31/31
usb-storage: -- transfer complete
usb-storage: Bulk command transfer result=0
usb-storage: usb_stor_bulk_transfer_sglist: xfer 18 bytes, 1 entries
usb-storage: Status code 0; transferred 18/18
usb-storage: -- transfer complete
usb-storage: Bulk data transfer result 0x0
usb-storage: Attempting to get CSW...
usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
usb-storage: Status code 0; transferred 13/13
usb-storage: -- transfer complete
usb-storage: Bulk status result = 0
usb-storage: Bulk Status S 0x53425355 T 0x4c4 R 0 Stat 0x0
usb-storage: -- Result from auto-sense is 0
usb-storage: -- code: 0x70, key: 0x2, ASC: 0x3a, ASCQ: 0x0
usb-storage: Not Ready: Medium not present
usb-storage: scsi cmd done, result=0x2
usb-storage: *** thread sleeping.
usb-storage: queuecommand called
usb-storage: *** thread awakened.
usb-storage: Command TEST_UNIT_READY (6 bytes)
usb-storage:  00 00 00 00 00 00
usb-storage: Bulk Command S 0x43425355 T 0x4c5 L 0 F 0 Trg 0 LUN 0 CL 6
usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
usb-storage: Status code 0; transferred 31/31
usb-storage: -- transfer complete
usb-storage: Bulk command transfer result=0
usb-storage: Attempting to get CSW...
usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
usb-storage: Status code 0; transferred 13/13
usb-storage: -- transfer complete
usb-storage: Bulk status result = 0
usb-storage: Bulk Status S 0x53425355 T 0x4c5 R 0 Stat 0x1
usb-storage: -- transport indicates command failure
usb-storage: Issuing auto-REQUEST_SENSE
usb-storage: Bulk Command S 0x43425355 T 0x4c6 L 18 F 128 Trg 0 LUN 0 CL 6
usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
usb-storage: Status code 0; transferred 31/31
usb-storage: -- transfer complete
usb-storage: Bulk command transfer result=0
usb-storage: usb_stor_bulk_transfer_sglist: xfer 18 bytes, 1 entries
usb-storage: Status code 0; transferred 18/18
usb-storage: -- transfer complete
usb-storage: Bulk data transfer result 0x0
usb-storage: Attempting to get CSW...
usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
usb-storage: Status code 0; transferred 13/13
usb-storage: -- transfer complete
usb-storage: Bulk status result = 0
usb-storage: Bulk Status S 0x53425355 T 0x4c6 R 0 Stat 0x0
usb-storage: -- Result from auto-sense is 0
usb-storage: -- code: 0x70, key: 0x2, ASC: 0x3a, ASCQ: 0x0
usb-storage: Not Ready: Medium not present
usb-storage: scsi cmd done, result=0x2
usb-storage: *** thread sleeping.
usb-storage: queuecommand called
usb-storage: *** thread awakened.
usb-storage: Command TEST_UNIT_READY (6 bytes)
usb-storage:  00 00 00 00 00 00
usb-storage: Bulk Command S 0x43425355 T 0x4c7 L 0 F 0 Trg 0 LUN 1 CL 6
usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
usb-storage: Status code 0; transferred 31/31
usb-storage: -- transfer complete
usb-storage: Bulk command transfer result=0
usb-storage: Attempting to get CSW...
usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
usb-storage: Status code 0; transferred 13/13
usb-storage: -- transfer complete
usb-storage: Bulk status result = 0
usb-storage: Bulk Status S 0x53425355 T 0x4c7 R 0 Stat 0x1
usb-storage: -- transport indicates command failure
usb-storage: Issuing auto-REQUEST_SENSE
usb-storage: Bulk Command S 0x43425355 T 0x4c8 L 18 F 128 Trg 0 LUN 1 CL 6
usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
usb-storage: Status code 0; transferred 31/31
usb-storage: -- transfer complete
usb-storage: Bulk command transfer result=0
usb-storage: usb_stor_bulk_transfer_sglist: xfer 18 bytes, 1 entries
usb-storage: Status code 0; transferred 18/18
usb-storage: -- transfer complete
usb-storage: Bulk data transfer result 0x0
usb-storage: Attempting to get CSW...
usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
usb-storage: Status code 0; transferred 13/13
usb-storage: -- transfer complete
usb-storage: Bulk status result = 0
usb-storage: Bulk Status S 0x53425355 T 0x4c8 R 0 Stat 0x0
usb-storage: -- Result from auto-sense is 0
usb-storage: -- code: 0x70, key: 0x2, ASC: 0x3a, ASCQ: 0x0
usb-storage: Not Ready: Medium not present
usb-storage: scsi cmd done, result=0x2
usb-storage: *** thread sleeping.
usb-storage: queuecommand called
usb-storage: *** thread awakened.
usb-storage: Command TEST_UNIT_READY (6 bytes)
usb-storage:  00 00 00 00 00 00
usb-storage: Bulk Command S 0x43425355 T 0x4c9 L 0 F 0 Trg 0 LUN 0 CL 6
usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
usb-storage: Status code 0; transferred 31/31
usb-storage: -- transfer complete
usb-storage: Bulk command transfer result=0
usb-storage: Attempting to get CSW...
usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
usb-storage: Status code 0; transferred 13/13
usb-storage: -- transfer complete
usb-storage: Bulk status result = 0
usb-storage: Bulk Status S 0x53425355 T 0x4c9 R 0 Stat 0x1
usb-storage: -- transport indicates command failure
usb-storage: Issuing auto-REQUEST_SENSE
usb-storage: Bulk Command S 0x43425355 T 0x4ca L 18 F 128 Trg 0 LUN 0 CL 6
usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
usb-storage: Status code 0; transferred 31/31
usb-storage: -- transfer complete
usb-storage: Bulk command transfer result=0
usb-storage: usb_stor_bulk_transfer_sglist: xfer 18 bytes, 1 entries
usb-storage: Status code 0; transferred 18/18
usb-storage: -- transfer complete
usb-storage: Bulk data transfer result 0x0
usb-storage: Attempting to get CSW...
usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
usb-storage: Status code 0; transferred 13/13
usb-storage: -- transfer complete
usb-storage: Bulk status result = 0
usb-storage: Bulk Status S 0x53425355 T 0x4ca R 0 Stat 0x0
usb-storage: -- Result from auto-sense is 0
usb-storage: -- code: 0x70, key: 0x2, ASC: 0x3a, ASCQ: 0x0
usb-storage: Not Ready: Medium not present
usb-storage: scsi cmd done, result=0x2
usb-storage: *** thread sleeping.
usb-storage: queuecommand called
usb-storage: *** thread awakened.
usb-storage: Command TEST_UNIT_READY (6 bytes)
usb-storage:  00 00 00 00 00 00
usb-storage: Bulk Command S 0x43425355 T 0x4cb L 0 F 0 Trg 0 LUN 1 CL 6
usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
usb-storage: Status code 0; transferred 31/31
usb-storage: -- transfer complete
usb-storage: Bulk command transfer result=0
usb-storage: Attempting to get CSW...
usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
usb-storage: Status code 0; transferred 13/13
usb-storage: -- transfer complete
usb-storage: Bulk status result = 0
usb-storage: Bulk Status S 0x53425355 T 0x4cb R 0 Stat 0x1
usb-storage: -- transport indicates command failure
usb-storage: Issuing auto-REQUEST_SENSE
usb-storage: Bulk Command S 0x43425355 T 0x4cc L 18 F 128 Trg 0 LUN 1 CL 6
usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
usb-storage: Status code 0; transferred 31/31
usb-storage: -- transfer complete
usb-storage: Bulk command transfer result=0
usb-storage: usb_stor_bulk_transfer_sglist: xfer 18 bytes, 1 entries
usb-storage: Status code 0; transferred 18/18
usb-storage: -- transfer complete
usb-storage: Bulk data transfer result 0x0
usb-storage: Attempting to get CSW...
usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
usb-storage: Status code 0; transferred 13/13
usb-storage: -- transfer complete
usb-storage: Bulk status result = 0
usb-storage: Bulk Status S 0x53425355 T 0x4cc R 0 Stat 0x0
usb-storage: -- Result from auto-sense is 0
usb-storage: -- code: 0x70, key: 0x2, ASC: 0x3a, ASCQ: 0x0
usb-storage: Not Ready: Medium not present
usb-storage: scsi cmd done, result=0x2
usb-storage: *** thread sleeping.
usb-storage: queuecommand called
usb-storage: *** thread awakened.
usb-storage: Command TEST_UNIT_READY (6 bytes)
usb-storage:  00 00 00 00 00 00
usb-storage: Bulk Command S 0x43425355 T 0x4cd L 0 F 0 Trg 0 LUN 1 CL 6
usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
usb-storage: Status code 0; transferred 31/31
usb-storage: -- transfer complete
usb-storage: Bulk command transfer result=0
usb-storage: Attempting to get CSW...
usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
usb-storage: Status code 0; transferred 13/13
usb-storage: -- transfer complete
usb-storage: Bulk status result = 0
usb-storage: Bulk Status S 0x53425355 T 0x4cd R 0 Stat 0x1
usb-storage: -- transport indicates command failure
usb-storage: Issuing auto-REQUEST_SENSE
usb-storage: Bulk Command S 0x43425355 T 0x4ce L 18 F 128 Trg 0 LUN 1 CL 6
usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
usb-storage: Status code 0; transferred 31/31
usb-storage: -- transfer complete
usb-storage: Bulk command transfer result=0
usb-storage: usb_stor_bulk_transfer_sglist: xfer 18 bytes, 1 entries
usb-storage: Status code 0; transferred 18/18
usb-storage: -- transfer complete
usb-storage: Bulk data transfer result 0x0
usb-storage: Attempting to get CSW...
usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
usb-storage: Status code 0; transferred 13/13
usb-storage: -- transfer complete
usb-storage: Bulk status result = 0
usb-storage: Bulk Status S 0x53425355 T 0x4ce R 0 Stat 0x0
usb-storage: -- Result from auto-sense is 0
usb-storage: -- code: 0x70, key: 0x2, ASC: 0x3a, ASCQ: 0x0
usb-storage: Not Ready: Medium not present
usb-storage: scsi cmd done, result=0x2
usb-storage: *** thread sleeping.
usb-storage: queuecommand called
usb-storage: *** thread awakened.
usb-storage: Command TEST_UNIT_READY (6 bytes)
usb-storage:  00 00 00 00 00 00
usb-storage: Bulk Command S 0x43425355 T 0x4cf L 0 F 0 Trg 0 LUN 1 CL 6
usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
usb-storage: Status code 0; transferred 31/31
usb-storage: -- transfer complete
usb-storage: Bulk command transfer result=0
usb-storage: Attempting to get CSW...
usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
usb-storage: Status code 0; transferred 13/13
usb-storage: -- transfer complete
usb-storage: Bulk status result = 0
usb-storage: Bulk Status S 0x53425355 T 0x4cf R 0 Stat 0x1
usb-storage: -- transport indicates command failure
usb-storage: Issuing auto-REQUEST_SENSE
usb-storage: Bulk Command S 0x43425355 T 0x4d0 L 18 F 128 Trg 0 LUN 1 CL 6
usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
usb-storage: Status code 0; transferred 31/31
usb-storage: -- transfer complete
usb-storage: Bulk command transfer result=0
usb-storage: usb_stor_bulk_transfer_sglist: xfer 18 bytes, 1 entries
usb-storage: Status code 0; transferred 18/18
usb-storage: -- transfer complete
usb-storage: Bulk data transfer result 0x0
usb-storage: Attempting to get CSW...
usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
usb-storage: Status code 0; transferred 13/13
usb-storage: -- transfer complete
usb-storage: Bulk status result = 0
usb-storage: Bulk Status S 0x53425355 T 0x4d0 R 0 Stat 0x0
usb-storage: -- Result from auto-sense is 0
usb-storage: -- code: 0x70, key: 0x2, ASC: 0x3a, ASCQ: 0x0
usb-storage: Not Ready: Medium not present
usb-storage: scsi cmd done, result=0x2
usb-storage: *** thread sleeping.
usb-storage: queuecommand called
usb-storage: *** thread awakened.
usb-storage: Command TEST_UNIT_READY (6 bytes)
usb-storage:  00 00 00 00 00 00
usb-storage: Bulk Command S 0x43425355 T 0x4d1 L 0 F 0 Trg 0 LUN 0 CL 6
usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
usb-storage: Status code 0; transferred 31/31
usb-storage: -- transfer complete
usb-storage: Bulk command transfer result=0
usb-storage: Attempting to get CSW...
usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
usb-storage: Status code 0; transferred 13/13
usb-storage: -- transfer complete
usb-storage: Bulk status result = 0
usb-storage: Bulk Status S 0x53425355 T 0x4d1 R 0 Stat 0x1
usb-storage: -- transport indicates command failure
usb-storage: Issuing auto-REQUEST_SENSE
usb-storage: Bulk Command S 0x43425355 T 0x4d2 L 18 F 128 Trg 0 LUN 0 CL 6
usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
usb-storage: Status code 0; transferred 31/31
usb-storage: -- transfer complete
usb-storage: Bulk command transfer result=0
usb-storage: usb_stor_bulk_transfer_sglist: xfer 18 bytes, 1 entries
usb-storage: Status code 0; transferred 18/18
usb-storage: -- transfer complete
usb-storage: Bulk data transfer result 0x0
usb-storage: Attempting to get CSW...
usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
usb-storage: Status code 0; transferred 13/13
usb-storage: -- transfer complete
usb-storage: Bulk status result = 0
usb-storage: Bulk Status S 0x53425355 T 0x4d2 R 0 Stat 0x0
usb-storage: -- Result from auto-sense is 0
usb-storage: -- code: 0x70, key: 0x2, ASC: 0x3a, ASCQ: 0x0
usb-storage: Not Ready: Medium not present
usb-storage: scsi cmd done, result=0x2
usb-storage: *** thread sleeping.
usb-storage: queuecommand called
usb-storage: *** thread awakened.
usb-storage: Command TEST_UNIT_READY (6 bytes)
usb-storage:  00 00 00 00 00 00
usb-storage: Bulk Command S 0x43425355 T 0x4d3 L 0 F 0 Trg 0 LUN 0 CL 6
usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
usb-storage: Status code 0; transferred 31/31
usb-storage: -- transfer complete
usb-storage: Bulk command transfer result=0
usb-storage: Attempting to get CSW...
usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
usb-storage: Status code 0; transferred 13/13
usb-storage: -- transfer complete
usb-storage: Bulk status result = 0
usb-storage: Bulk Status S 0x53425355 T 0x4d3 R 0 Stat 0x1
usb-storage: -- transport indicates command failure
usb-storage: Issuing auto-REQUEST_SENSE
usb-storage: Bulk Command S 0x43425355 T 0x4d4 L 18 F 128 Trg 0 LUN 0 CL 6
usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
usb-storage: Status code 0; transferred 31/31
usb-storage: -- transfer complete
usb-storage: Bulk command transfer result=0
usb-storage: usb_stor_bulk_transfer_sglist: xfer 18 bytes, 1 entries
usb-storage: Status code 0; transferred 18/18
usb-storage: -- transfer complete
usb-storage: Bulk data transfer result 0x0
usb-storage: Attempting to get CSW...
usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
usb-storage: Status code 0; transferred 13/13
usb-storage: -- transfer complete
usb-storage: Bulk status result = 0
usb-storage: Bulk Status S 0x53425355 T 0x4d4 R 0 Stat 0x0
usb-storage: -- Result from auto-sense is 0
usb-storage: -- code: 0x70, key: 0x2, ASC: 0x3a, ASCQ: 0x0
usb-storage: Not Ready: Medium not present
usb-storage: scsi cmd done, result=0x2
usb-storage: *** thread sleeping.
usb-storage: queuecommand called
usb-storage: *** thread awakened.
usb-storage: Command TEST_UNIT_READY (6 bytes)
usb-storage:  00 00 00 00 00 00
usb-storage: Bulk Command S 0x43425355 T 0x4d5 L 0 F 0 Trg 0 LUN 0 CL 6
usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
usb-storage: Status code 0; transferred 31/31
usb-storage: -- transfer complete
usb-storage: Bulk command transfer result=0
usb-storage: Attempting to get CSW...
usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
usb-storage: Status code 0; transferred 13/13
usb-storage: -- transfer complete
usb-storage: Bulk status result = 0
usb-storage: Bulk Status S 0x53425355 T 0x4d5 R 0 Stat 0x1
usb-storage: -- transport indicates command failure
usb-storage: Issuing auto-REQUEST_SENSE
usb-storage: Bulk Command S 0x43425355 T 0x4d6 L 18 F 128 Trg 0 LUN 0 CL 6
usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
usb-storage: Status code 0; transferred 31/31
usb-storage: -- transfer complete
usb-storage: Bulk command transfer result=0
usb-storage: usb_stor_bulk_transfer_sglist: xfer 18 bytes, 1 entries
usb-storage: Status code 0; transferred 18/18
usb-storage: -- transfer complete
usb-storage: Bulk data transfer result 0x0
usb-storage: Attempting to get CSW...
usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
usb-storage: Status code 0; transferred 13/13
usb-storage: -- transfer complete
usb-storage: Bulk status result = 0
usb-storage: Bulk Status S 0x53425355 T 0x4d6 R 0 Stat 0x0
usb-storage: -- Result from auto-sense is 0
usb-storage: -- code: 0x70, key: 0x2, ASC: 0x3a, ASCQ: 0x0
usb-storage: Not Ready: Medium not present
usb-storage: scsi cmd done, result=0x2
usb-storage: *** thread sleeping.
usb-storage: queuecommand called
usb-storage: *** thread awakened.
usb-storage: Command TEST_UNIT_READY (6 bytes)
usb-storage:  00 00 00 00 00 00
usb-storage: Bulk Command S 0x43425355 T 0x4d7 L 0 F 0 Trg 0 LUN 0 CL 6
usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
usb-storage: Status code 0; transferred 31/31
usb-storage: -- transfer complete
usb-storage: Bulk command transfer result=0
usb-storage: Attempting to get CSW...
usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
usb-storage: Status code 0; transferred 13/13
usb-storage: -- transfer complete
usb-storage: Bulk status result = 0
usb-storage: Bulk Status S 0x53425355 T 0x4d7 R 0 Stat 0x1
usb-storage: -- transport indicates command failure
usb-storage: Issuing auto-REQUEST_SENSE
usb-storage: Bulk Command S 0x43425355 T 0x4d8 L 18 F 128 Trg 0 LUN 0 CL 6
usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
usb-storage: Status code 0; transferred 31/31
usb-storage: -- transfer complete
usb-storage: Bulk command transfer result=0
usb-storage: usb_stor_bulk_transfer_sglist: xfer 18 bytes, 1 entries
usb-storage: Status code 0; transferred 18/18
usb-storage: -- transfer complete
usb-storage: Bulk data transfer result 0x0
usb-storage: Attempting to get CSW...
usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
usb-storage: Status code 0; transferred 13/13
usb-storage: -- transfer complete
usb-storage: Bulk status result = 0
usb-storage: Bulk Status S 0x53425355 T 0x4d8 R 0 Stat 0x0
usb-storage: -- Result from auto-sense is 0
usb-storage: -- code: 0x70, key: 0x2, ASC: 0x3a, ASCQ: 0x0
usb-storage: Not Ready: Medium not present
usb-storage: scsi cmd done, result=0x2
usb-storage: *** thread sleeping.
usb-storage: queuecommand called
usb-storage: *** thread awakened.
usb-storage: Command TEST_UNIT_READY (6 bytes)
usb-storage:  00 00 00 00 00 00
usb-storage: Bulk Command S 0x43425355 T 0x4d9 L 0 F 0 Trg 0 LUN 1 CL 6
usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
usb-storage: Status code 0; transferred 31/31
usb-storage: -- transfer complete
usb-storage: Bulk command transfer result=0
usb-storage: Attempting to get CSW...
usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
usb-storage: Status code 0; transferred 13/13
usb-storage: -- transfer complete
usb-storage: Bulk status result = 0
usb-storage: Bulk Status S 0x53425355 T 0x4d9 R 0 Stat 0x1
usb-storage: -- transport indicates command failure
usb-storage: Issuing auto-REQUEST_SENSE
usb-storage: Bulk Command S 0x43425355 T 0x4da L 18 F 128 Trg 0 LUN 1 CL 6
usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
usb-storage: Status code 0; transferred 31/31
usb-storage: -- transfer complete
usb-storage: Bulk command transfer result=0
usb-storage: usb_stor_bulk_transfer_sglist: xfer 18 bytes, 1 entries
usb-storage: Status code 0; transferred 18/18
usb-storage: -- transfer complete
usb-storage: Bulk data transfer result 0x0
usb-storage: Attempting to get CSW...
usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
usb-storage: Status code 0; transferred 13/13
usb-storage: -- transfer complete
usb-storage: Bulk status result = 0
usb-storage: Bulk Status S 0x53425355 T 0x4da R 0 Stat 0x0
usb-storage: -- Result from auto-sense is 0
usb-storage: -- code: 0x70, key: 0x2, ASC: 0x3a, ASCQ: 0x0
usb-storage: Not Ready: Medium not present
usb-storage: scsi cmd done, result=0x2
usb-storage: *** thread sleeping.
usb-storage: queuecommand called
usb-storage: *** thread awakened.
usb-storage: Command TEST_UNIT_READY (6 bytes)
usb-storage:  00 00 00 00 00 00
usb-storage: Bulk Command S 0x43425355 T 0x4db L 0 F 0 Trg 0 LUN 1 CL 6
usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
usb-storage: Status code 0; transferred 31/31
usb-storage: -- transfer complete
usb-storage: Bulk command transfer result=0
usb-storage: Attempting to get CSW...
usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
usb-storage: Status code 0; transferred 13/13
usb-storage: -- transfer complete
usb-storage: Bulk status result = 0
usb-storage: Bulk Status S 0x53425355 T 0x4db R 0 Stat 0x1
usb-storage: -- transport indicates command failure
usb-storage: Issuing auto-REQUEST_SENSE
usb-storage: Bulk Command S 0x43425355 T 0x4dc L 18 F 128 Trg 0 LUN 1 CL 6
usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
usb-storage: Status code 0; transferred 31/31
usb-storage: -- transfer complete
usb-storage: Bulk command transfer result=0
usb-storage: usb_stor_bulk_transfer_sglist: xfer 18 bytes, 1 entries
usb-storage: Status code 0; transferred 18/18
usb-storage: -- transfer complete
usb-storage: Bulk data transfer result 0x0
usb-storage: Attempting to get CSW...
usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
usb-storage: Status code 0; transferred 13/13
usb-storage: -- transfer complete
usb-storage: Bulk status result = 0
usb-storage: Bulk Status S 0x53425355 T 0x4dc R 0 Stat 0x0
usb-storage: -- Result from auto-sense is 0
usb-storage: -- code: 0x70, key: 0x2, ASC: 0x3a, ASCQ: 0x0
usb-storage: Not Ready: Medium not present
usb-storage: scsi cmd done, result=0x2
usb-storage: *** thread sleeping.
usb-storage: queuecommand called
usb-storage: *** thread awakened.
usb-storage: Command TEST_UNIT_READY (6 bytes)
usb-storage:  00 00 00 00 00 00
usb-storage: Bulk Command S 0x43425355 T 0x4dd L 0 F 0 Trg 0 LUN 1 CL 6
usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
usb-storage: Status code 0; transferred 31/31
usb-storage: -- transfer complete
usb-storage: Bulk command transfer result=0
usb-storage: Attempting to get CSW...
usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
usb-storage: Status code 0; transferred 13/13
usb-storage: -- transfer complete
usb-storage: Bulk status result = 0
usb-storage: Bulk Status S 0x53425355 T 0x4dd R 0 Stat 0x1
usb-storage: -- transport indicates command failure
usb-storage: Issuing auto-REQUEST_SENSE
usb-storage: Bulk Command S 0x43425355 T 0x4de L 18 F 128 Trg 0 LUN 1 CL 6
usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
usb-storage: Status code 0; transferred 31/31
usb-storage: -- transfer complete
usb-storage: Bulk command transfer result=0
usb-storage: usb_stor_bulk_transfer_sglist: xfer 18 bytes, 1 entries
usb-storage: Status code 0; transferred 18/18
usb-storage: -- transfer complete
usb-storage: Bulk data transfer result 0x0
usb-storage: Attempting to get CSW...
usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
usb-storage: Status code 0; transferred 13/13
usb-storage: -- transfer complete
usb-storage: Bulk status result = 0
usb-storage: Bulk Status S 0x53425355 T 0x4de R 0 Stat 0x0
usb-storage: -- Result from auto-sense is 0
usb-storage: -- code: 0x70, key: 0x2, ASC: 0x3a, ASCQ: 0x0
usb-storage: Not Ready: Medium not present
usb-storage: scsi cmd done, result=0x2
usb-storage: *** thread sleeping.
usb-storage: queuecommand called
usb-storage: *** thread awakened.
usb-storage: Command TEST_UNIT_READY (6 bytes)
usb-storage:  00 00 00 00 00 00
usb-storage: Bulk Command S 0x43425355 T 0x4df L 0 F 0 Trg 0 LUN 1 CL 6
usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
usb-storage: Status code 0; transferred 31/31
usb-storage: -- transfer complete
usb-storage: Bulk command transfer result=0
usb-storage: Attempting to get CSW...
usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
usb-storage: Status code 0; transferred 13/13
usb-storage: -- transfer complete
usb-storage: Bulk status result = 0
usb-storage: Bulk Status S 0x53425355 T 0x4df R 0 Stat 0x1
usb-storage: -- transport indicates command failure
usb-storage: Issuing auto-REQUEST_SENSE
usb-storage: Bulk Command S 0x43425355 T 0x4e0 L 18 F 128 Trg 0 LUN 1 CL 6
usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
usb-storage: Status code 0; transferred 31/31
usb-storage: -- transfer complete
usb-storage: Bulk command transfer result=0
usb-storage: usb_stor_bulk_transfer_sglist: xfer 18 bytes, 1 entries
usb-storage: Status code 0; transferred 18/18
usb-storage: -- transfer complete
usb-storage: Bulk data transfer result 0x0
usb-storage: Attempting to get CSW...
usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
usb-storage: Status code 0; transferred 13/13
usb-storage: -- transfer complete
usb-storage: Bulk status result = 0
usb-storage: Bulk Status S 0x53425355 T 0x4e0 R 0 Stat 0x0
usb-storage: -- Result from auto-sense is 0
usb-storage: -- code: 0x70, key: 0x2, ASC: 0x3a, ASCQ: 0x0
usb-storage: Not Ready: Medium not present
usb-storage: scsi cmd done, result=0x2
usb-storage: *** thread sleeping.
usb-storage: queuecommand called
usb-storage: *** thread awakened.
usb-storage: Command TEST_UNIT_READY (6 bytes)
usb-storage:  00 00 00 00 00 00
usb-storage: Bulk Command S 0x43425355 T 0x4e1 L 0 F 0 Trg 0 LUN 0 CL 6
usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
usb-storage: Status code 0; transferred 31/31
usb-storage: -- transfer complete
usb-storage: Bulk command transfer result=0
usb-storage: Attempting to get CSW...
usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
usb-storage: Status code 0; transferred 13/13
usb-storage: -- transfer complete
usb-storage: Bulk status result = 0
usb-storage: Bulk Status S 0x53425355 T 0x4e1 R 0 Stat 0x1
usb-storage: -- transport indicates command failure
usb-storage: Issuing auto-REQUEST_SENSE
usb-storage: Bulk Command S 0x43425355 T 0x4e2 L 18 F 128 Trg 0 LUN 0 CL 6
usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
usb-storage: Status code 0; transferred 31/31
usb-storage: -- transfer complete
usb-storage: Bulk command transfer result=0
usb-storage: usb_stor_bulk_transfer_sglist: xfer 18 bytes, 1 entries
usb-storage: Status code 0; transferred 18/18
usb-storage: -- transfer complete
usb-storage: Bulk data transfer result 0x0
usb-storage: Attempting to get CSW...
usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
usb-storage: Status code 0; transferred 13/13
usb-storage: -- transfer complete
usb-storage: Bulk status result = 0
usb-storage: Bulk Status S 0x53425355 T 0x4e2 R 0 Stat 0x0
usb-storage: -- Result from auto-sense is 0
usb-storage: -- code: 0x70, key: 0x2, ASC: 0x3a, ASCQ: 0x0
usb-storage: Not Ready: Medium not present
usb-storage: scsi cmd done, result=0x2
usb-storage: *** thread sleeping.
usb-storage: queuecommand called
usb-storage: *** thread awakened.
usb-storage: Command TEST_UNIT_READY (6 bytes)
usb-storage:  00 00 00 00 00 00
usb-storage: Bulk Command S 0x43425355 T 0x4e3 L 0 F 0 Trg 0 LUN 0 CL 6
usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
usb-storage: Status code 0; transferred 31/31
usb-storage: -- transfer complete
usb-storage: Bulk command transfer result=0
usb-storage: Attempting to get CSW...
usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
usb-storage: Status code 0; transferred 13/13
usb-storage: -- transfer complete
usb-storage: Bulk status result = 0
usb-storage: Bulk Status S 0x53425355 T 0x4e3 R 0 Stat 0x1
usb-storage: -- transport indicates command failure
usb-storage: Issuing auto-REQUEST_SENSE
usb-storage: Bulk Command S 0x43425355 T 0x4e4 L 18 F 128 Trg 0 LUN 0 CL 6
usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
usb-storage: Status code 0; transferred 31/31
usb-storage: -- transfer complete
usb-storage: Bulk command transfer result=0
usb-storage: usb_stor_bulk_transfer_sglist: xfer 18 bytes, 1 entries
usb-storage: Status code 0; transferred 18/18
usb-storage: -- transfer complete
usb-storage: Bulk data transfer result 0x0
usb-storage: Attempting to get CSW...
usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
usb-storage: Status code 0; transferred 13/13
usb-storage: -- transfer complete
usb-storage: Bulk status result = 0
usb-storage: Bulk Status S 0x53425355 T 0x4e4 R 0 Stat 0x0
usb-storage: -- Result from auto-sense is 0
usb-storage: -- code: 0x70, key: 0x2, ASC: 0x3a, ASCQ: 0x0
usb-storage: Not Ready: Medium not present
usb-storage: scsi cmd done, result=0x2
usb-storage: *** thread sleeping.
usb-storage: queuecommand called
usb-storage: *** thread awakened.
usb-storage: Command TEST_UNIT_READY (6 bytes)
usb-storage:  00 00 00 00 00 00
usb-storage: Bulk Command S 0x43425355 T 0x4e5 L 0 F 0 Trg 0 LUN 0 CL 6
usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
usb-storage: Status code 0; transferred 31/31
usb-storage: -- transfer complete
usb-storage: Bulk command transfer result=0
usb-storage: Attempting to get CSW...
usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
usb-storage: Status code 0; transferred 13/13
usb-storage: -- transfer complete
usb-storage: Bulk status result = 0
usb-storage: Bulk Status S 0x53425355 T 0x4e5 R 0 Stat 0x1
usb-storage: -- transport indicates command failure
usb-storage: Issuing auto-REQUEST_SENSE
usb-storage: Bulk Command S 0x43425355 T 0x4e6 L 18 F 128 Trg 0 LUN 0 CL 6
usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
usb-storage: Status code 0; transferred 31/31
usb-storage: -- transfer complete
usb-storage: Bulk command transfer result=0
usb-storage: usb_stor_bulk_transfer_sglist: xfer 18 bytes, 1 entries
usb-storage: Status code 0; transferred 18/18
usb-storage: -- transfer complete
usb-storage: Bulk data transfer result 0x0
usb-storage: Attempting to get CSW...
usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
usb-storage: Status code 0; transferred 13/13
usb-storage: -- transfer complete
usb-storage: Bulk status result = 0
usb-storage: Bulk Status S 0x53425355 T 0x4e6 R 0 Stat 0x0
usb-storage: -- Result from auto-sense is 0
usb-storage: -- code: 0x70, key: 0x2, ASC: 0x3a, ASCQ: 0x0
usb-storage: Not Ready: Medium not present
usb-storage: scsi cmd done, result=0x2
usb-storage: *** thread sleeping.
usb-storage: queuecommand called
usb-storage: *** thread awakened.
usb-storage: Command TEST_UNIT_READY (6 bytes)
usb-storage:  00 00 00 00 00 00
usb-storage: Bulk Command S 0x43425355 T 0x4e7 L 0 F 0 Trg 0 LUN 0 CL 6
usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
usb-storage: Status code 0; transferred 31/31
usb-storage: -- transfer complete
usb-storage: Bulk command transfer result=0
usb-storage: Attempting to get CSW...
usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
usb-storage: Status code 0; transferred 13/13
usb-storage: -- transfer complete
usb-storage: Bulk status result = 0
usb-storage: Bulk Status S 0x53425355 T 0x4e7 R 0 Stat 0x1
usb-storage: -- transport indicates command failure
usb-storage: Issuing auto-REQUEST_SENSE
usb-storage: Bulk Command S 0x43425355 T 0x4e8 L 18 F 128 Trg 0 LUN 0 CL 6
usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
usb-storage: Status code 0; transferred 31/31
usb-storage: -- transfer complete
usb-storage: Bulk command transfer result=0
usb-storage: usb_stor_bulk_transfer_sglist: xfer 18 bytes, 1 entries
usb-storage: Status code 0; transferred 18/18
usb-storage: -- transfer complete
usb-storage: Bulk data transfer result 0x0
usb-storage: Attempting to get CSW...
usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
usb-storage: Status code 0; transferred 13/13
usb-storage: -- transfer complete
usb-storage: Bulk status result = 0
usb-storage: Bulk Status S 0x53425355 T 0x4e8 R 0 Stat 0x0
usb-storage: -- Result from auto-sense is 0
usb-storage: -- code: 0x70, key: 0x2, ASC: 0x3a, ASCQ: 0x0
usb-storage: Not Ready: Medium not present
usb-storage: scsi cmd done, result=0x2
usb-storage: *** thread sleeping.
usb-storage: queuecommand called
usb-storage: *** thread awakened.
usb-storage: Command TEST_UNIT_READY (6 bytes)
usb-storage:  00 00 00 00 00 00
usb-storage: Bulk Command S 0x43425355 T 0x4e9 L 0 F 0 Trg 0 LUN 1 CL 6
usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
usb-storage: Status code 0; transferred 31/31
usb-storage: -- transfer complete
usb-storage: Bulk command transfer result=0
usb-storage: Attempting to get CSW...
usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
usb-storage: Status code 0; transferred 13/13
usb-storage: -- transfer complete
usb-storage: Bulk status result = 0
usb-storage: Bulk Status S 0x53425355 T 0x4e9 R 0 Stat 0x1
usb-storage: -- transport indicates command failure
usb-storage: Issuing auto-REQUEST_SENSE
usb-storage: Bulk Command S 0x43425355 T 0x4ea L 18 F 128 Trg 0 LUN 1 CL 6
usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
usb-storage: Status code 0; transferred 31/31
usb-storage: -- transfer complete
usb-storage: Bulk command transfer result=0
usb-storage: usb_stor_bulk_transfer_sglist: xfer 18 bytes, 1 entries
usb-storage: Status code 0; transferred 18/18
usb-storage: -- transfer complete
usb-storage: Bulk data transfer result 0x0
usb-storage: Attempting to get CSW...
usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
usb-storage: Status code 0; transferred 13/13
usb-storage: -- transfer complete
usb-storage: Bulk status result = 0
usb-storage: Bulk Status S 0x53425355 T 0x4ea R 0 Stat 0x0
usb-storage: -- Result from auto-sense is 0
usb-storage: -- code: 0x70, key: 0x2, ASC: 0x3a, ASCQ: 0x0
usb-storage: Not Ready: Medium not present
usb-storage: scsi cmd done, result=0x2
usb-storage: *** thread sleeping.
usb-storage: queuecommand called
usb-storage: *** thread awakened.
usb-storage: Command TEST_UNIT_READY (6 bytes)
usb-storage:  00 00 00 00 00 00
usb-storage: Bulk Command S 0x43425355 T 0x4eb L 0 F 0 Trg 0 LUN 1 CL 6
usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
usb-storage: Status code 0; transferred 31/31
usb-storage: -- transfer complete
usb-storage: Bulk command transfer result=0
usb-storage: Attempting to get CSW...
usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
usb-storage: Status code 0; transferred 13/13
usb-storage: -- transfer complete
usb-storage: Bulk status result = 0
usb-storage: Bulk Status S 0x53425355 T 0x4eb R 0 Stat 0x1
usb-storage: -- transport indicates command failure
usb-storage: Issuing auto-REQUEST_SENSE
usb-storage: Bulk Command S 0x43425355 T 0x4ec L 18 F 128 Trg 0 LUN 1 CL 6
usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
usb-storage: Status code 0; transferred 31/31
usb-storage: -- transfer complete
usb-storage: Bulk command transfer result=0
usb-storage: usb_stor_bulk_transfer_sglist: xfer 18 bytes, 1 entries
usb-storage: Status code 0; transferred 18/18
usb-storage: -- transfer complete
usb-storage: Bulk data transfer result 0x0
usb-storage: Attempting to get CSW...
usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
usb-storage: Status code 0; transferred 13/13
usb-storage: -- transfer complete
usb-storage: Bulk status result = 0
usb-storage: Bulk Status S 0x53425355 T 0x4ec R 0 Stat 0x0
usb-storage: -- Result from auto-sense is 0
usb-storage: -- code: 0x70, key: 0x2, ASC: 0x3a, ASCQ: 0x0
usb-storage: Not Ready: Medium not present
usb-storage: scsi cmd done, result=0x2
usb-storage: *** thread sleeping.
usb-storage: queuecommand called
usb-storage: *** thread awakened.
usb-storage: Command TEST_UNIT_READY (6 bytes)
usb-storage:  00 00 00 00 00 00
usb-storage: Bulk Command S 0x43425355 T 0x4ed L 0 F 0 Trg 0 LUN 1 CL 6
usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
usb-storage: Status code 0; transferred 31/31
usb-storage: -- transfer complete
usb-storage: Bulk command transfer result=0
usb-storage: Attempting to get CSW...
usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
usb-storage: Status code 0; transferred 13/13
usb-storage: -- transfer complete
usb-storage: Bulk status result = 0
usb-storage: Bulk Status S 0x53425355 T 0x4ed R 0 Stat 0x1
usb-storage: -- transport indicates command failure
usb-storage: Issuing auto-REQUEST_SENSE
usb-storage: Bulk Command S 0x43425355 T 0x4ee L 18 F 128 Trg 0 LUN 1 CL 6
usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
usb-storage: Status code 0; transferred 31/31
usb-storage: -- transfer complete
usb-storage: Bulk command transfer result=0
usb-storage: usb_stor_bulk_transfer_sglist: xfer 18 bytes, 1 entries
usb-storage: Status code 0; transferred 18/18
usb-storage: -- transfer complete
usb-storage: Bulk data transfer result 0x0
usb-storage: Attempting to get CSW...
usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
usb-storage: Status code 0; transferred 13/13
usb-storage: -- transfer complete
usb-storage: Bulk status result = 0
usb-storage: Bulk Status S 0x53425355 T 0x4ee R 0 Stat 0x0
usb-storage: -- Result from auto-sense is 0
usb-storage: -- code: 0x70, key: 0x2, ASC: 0x3a, ASCQ: 0x0
usb-storage: Not Ready: Medium not present
usb-storage: scsi cmd done, result=0x2
usb-storage: *** thread sleeping.
usb-storage: queuecommand called
usb-storage: *** thread awakened.
usb-storage: Command TEST_UNIT_READY (6 bytes)
usb-storage:  00 00 00 00 00 00
usb-storage: Bulk Command S 0x43425355 T 0x4ef L 0 F 0 Trg 0 LUN 0 CL 6
usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
usb-storage: Status code 0; transferred 31/31
usb-storage: -- transfer complete
usb-storage: Bulk command transfer result=0
usb-storage: Attempting to get CSW...
usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
usb-storage: Status code 0; transferred 13/13
usb-storage: -- transfer complete
usb-storage: Bulk status result = 0
usb-storage: Bulk Status S 0x53425355 T 0x4ef R 0 Stat 0x1
usb-storage: -- transport indicates command failure
usb-storage: Issuing auto-REQUEST_SENSE
usb-storage: Bulk Command S 0x43425355 T 0x4f0 L 18 F 128 Trg 0 LUN 0 CL 6
usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
usb-storage: Status code 0; transferred 31/31
usb-storage: -- transfer complete
usb-storage: Bulk command transfer result=0
usb-storage: usb_stor_bulk_transfer_sglist: xfer 18 bytes, 1 entries
usb-storage: Status code 0; transferred 18/18
usb-storage: -- transfer complete
usb-storage: Bulk data transfer result 0x0
usb-storage: Attempting to get CSW...
usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
usb-storage: Status code 0; transferred 13/13
usb-storage: -- transfer complete
usb-storage: Bulk status result = 0
usb-storage: Bulk Status S 0x53425355 T 0x4f0 R 0 Stat 0x0
usb-storage: -- Result from auto-sense is 0
usb-storage: -- code: 0x70, key: 0x2, ASC: 0x3a, ASCQ: 0x0
usb-storage: Not Ready: Medium not present
usb-storage: scsi cmd done, result=0x2
usb-storage: *** thread sleeping.
usb-storage: queuecommand called
usb-storage: *** thread awakened.
usb-storage: Command TEST_UNIT_READY (6 bytes)
usb-storage:  00 00 00 00 00 00
usb-storage: Bulk Command S 0x43425355 T 0x4f1 L 0 F 0 Trg 0 LUN 1 CL 6
usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
usb-storage: Status code 0; transferred 31/31
usb-storage: -- transfer complete
usb-storage: Bulk command transfer result=0
usb-storage: Attempting to get CSW...
usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
usb-storage: Status code 0; transferred 13/13
usb-storage: -- transfer complete
usb-storage: Bulk status result = 0
usb-storage: Bulk Status S 0x53425355 T 0x4f1 R 0 Stat 0x1
usb-storage: -- transport indicates command failure
usb-storage: Issuing auto-REQUEST_SENSE
usb-storage: Bulk Command S 0x43425355 T 0x4f2 L 18 F 128 Trg 0 LUN 1 CL 6
usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
usb-storage: Status code 0; transferred 31/31
usb-storage: -- transfer complete
usb-storage: Bulk command transfer result=0
usb-storage: usb_stor_bulk_transfer_sglist: xfer 18 bytes, 1 entries
usb-storage: Status code 0; transferred 18/18
usb-storage: -- transfer complete
usb-storage: Bulk data transfer result 0x0
usb-storage: Attempting to get CSW...
usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
usb-storage: Status code 0; transferred 13/13
usb-storage: -- transfer complete
usb-storage: Bulk status result = 0
usb-storage: Bulk Status S 0x53425355 T 0x4f2 R 0 Stat 0x0
usb-storage: -- Result from auto-sense is 0
usb-storage: -- code: 0x70, key: 0x2, ASC: 0x3a, ASCQ: 0x0
usb-storage: Not Ready: Medium not present
usb-storage: scsi cmd done, result=0x2
usb-storage: *** thread sleeping.
usb-storage: queuecommand called
usb-storage: *** thread awakened.
usb-storage: Command TEST_UNIT_READY (6 bytes)
usb-storage:  00 00 00 00 00 00
usb-storage: Bulk Command S 0x43425355 T 0x4f3 L 0 F 0 Trg 0 LUN 0 CL 6
usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
usb-storage: Status code 0; transferred 31/31
usb-storage: -- transfer complete
usb-storage: Bulk command transfer result=0
usb-storage: Attempting to get CSW...
usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
usb-storage: Status code 0; transferred 13/13
usb-storage: -- transfer complete
usb-storage: Bulk status result = 0
usb-storage: Bulk Status S 0x53425355 T 0x4f3 R 0 Stat 0x1
usb-storage: -- transport indicates command failure
usb-storage: Issuing auto-REQUEST_SENSE
usb-storage: Bulk Command S 0x43425355 T 0x4f4 L 18 F 128 Trg 0 LUN 0 CL 6
usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
usb-storage: Status code 0; transferred 31/31
usb-storage: -- transfer complete
usb-storage: Bulk command transfer result=0
usb-storage: usb_stor_bulk_transfer_sglist: xfer 18 bytes, 1 entries
usb-storage: Status code 0; transferred 18/18
usb-storage: -- transfer complete
usb-storage: Bulk data transfer result 0x0
usb-storage: Attempting to get CSW...
usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
usb-storage: Status code 0; transferred 13/13
usb-storage: -- transfer complete
usb-storage: Bulk status result = 0
usb-storage: Bulk Status S 0x53425355 T 0x4f4 R 0 Stat 0x0
usb-storage: -- Result from auto-sense is 0
usb-storage: -- code: 0x70, key: 0x2, ASC: 0x3a, ASCQ: 0x0
usb-storage: Not Ready: Medium not present
usb-storage: scsi cmd done, result=0x2
usb-storage: *** thread sleeping.
usb-storage: queuecommand called
usb-storage: *** thread awakened.
usb-storage: Command TEST_UNIT_READY (6 bytes)
usb-storage:  00 00 00 00 00 00
usb-storage: Bulk Command S 0x43425355 T 0x4f5 L 0 F 0 Trg 0 LUN 0 CL 6
usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
usb-storage: Status code 0; transferred 31/31
usb-storage: -- transfer complete
usb-storage: Bulk command transfer result=0
usb-storage: Attempting to get CSW...
usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
usb-storage: Status code 0; transferred 13/13
usb-storage: -- transfer complete
usb-storage: Bulk status result = 0
usb-storage: Bulk Status S 0x53425355 T 0x4f5 R 0 Stat 0x1
usb-storage: -- transport indicates command failure
usb-storage: Issuing auto-REQUEST_SENSE
usb-storage: Bulk Command S 0x43425355 T 0x4f6 L 18 F 128 Trg 0 LUN 0 CL 6
usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
usb-storage: Status code 0; transferred 31/31
usb-storage: -- transfer complete
usb-storage: Bulk command transfer result=0
usb-storage: usb_stor_bulk_transfer_sglist: xfer 18 bytes, 1 entries
usb-storage: Status code 0; transferred 18/18
usb-storage: -- transfer complete
usb-storage: Bulk data transfer result 0x0
usb-storage: Attempting to get CSW...
usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
usb-storage: Status code 0; transferred 13/13
usb-storage: -- transfer complete
usb-storage: Bulk status result = 0
usb-storage: Bulk Status S 0x53425355 T 0x4f6 R 0 Stat 0x0
usb-storage: -- Result from auto-sense is 0
usb-storage: -- code: 0x70, key: 0x2, ASC: 0x3a, ASCQ: 0x0
usb-storage: Not Ready: Medium not present
usb-storage: scsi cmd done, result=0x2
usb-storage: *** thread sleeping.
usb-storage: queuecommand called
usb-storage: *** thread awakened.
usb-storage: Command TEST_UNIT_READY (6 bytes)
usb-storage:  00 00 00 00 00 00
usb-storage: Bulk Command S 0x43425355 T 0x4f7 L 0 F 0 Trg 0 LUN 1 CL 6
usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
usb-storage: Status code 0; transferred 31/31
usb-storage: -- transfer complete
usb-storage: Bulk command transfer result=0
usb-storage: Attempting to get CSW...
usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
usb-storage: Status code 0; transferred 13/13
usb-storage: -- transfer complete
usb-storage: Bulk status result = 0
usb-storage: Bulk Status S 0x53425355 T 0x4f7 R 0 Stat 0x1
usb-storage: -- transport indicates command failure
usb-storage: Issuing auto-REQUEST_SENSE
usb-storage: Bulk Command S 0x43425355 T 0x4f8 L 18 F 128 Trg 0 LUN 1 CL 6
usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
usb-storage: Status code 0; transferred 31/31
usb-storage: -- transfer complete
usb-storage: Bulk command transfer result=0
usb-storage: usb_stor_bulk_transfer_sglist: xfer 18 bytes, 1 entries
usb-storage: Status code 0; transferred 18/18
usb-storage: -- transfer complete
usb-storage: Bulk data transfer result 0x0
usb-storage: Attempting to get CSW...
usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
usb-storage: Status code 0; transferred 13/13
usb-storage: -- transfer complete
usb-storage: Bulk status result = 0
usb-storage: Bulk Status S 0x53425355 T 0x4f8 R 0 Stat 0x0
usb-storage: -- Result from auto-sense is 0
usb-storage: -- code: 0x70, key: 0x2, ASC: 0x3a, ASCQ: 0x0
usb-storage: Not Ready: Medium not present
usb-storage: scsi cmd done, result=0x2
usb-storage: *** thread sleeping.
usb-storage: queuecommand called
usb-storage: *** thread awakened.
usb-storage: Command TEST_UNIT_READY (6 bytes)
usb-storage:  00 00 00 00 00 00
usb-storage: Bulk Command S 0x43425355 T 0x4f9 L 0 F 0 Trg 0 LUN 0 CL 6
usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
usb-storage: Status code 0; transferred 31/31
usb-storage: -- transfer complete
usb-storage: Bulk command transfer result=0
usb-storage: Attempting to get CSW...
usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
usb-storage: Status code 0; transferred 13/13
usb-storage: -- transfer complete
usb-storage: Bulk status result = 0
usb-storage: Bulk Status S 0x53425355 T 0x4f9 R 0 Stat 0x1
usb-storage: -- transport indicates command failure
usb-storage: Issuing auto-REQUEST_SENSE
usb-storage: Bulk Command S 0x43425355 T 0x4fa L 18 F 128 Trg 0 LUN 0 CL 6
usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
usb-storage: Status code 0; transferred 31/31
usb-storage: -- transfer complete
usb-storage: Bulk command transfer result=0
usb-storage: usb_stor_bulk_transfer_sglist: xfer 18 bytes, 1 entries
usb-storage: Status code 0; transferred 18/18
usb-storage: -- transfer complete
usb-storage: Bulk data transfer result 0x0
usb-storage: Attempting to get CSW...
usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
usb-storage: Status code 0; transferred 13/13
usb-storage: -- transfer complete
usb-storage: Bulk status result = 0
usb-storage: Bulk Status S 0x53425355 T 0x4fa R 0 Stat 0x0
usb-storage: -- Result from auto-sense is 0
usb-storage: -- code: 0x70, key: 0x2, ASC: 0x3a, ASCQ: 0x0
usb-storage: Not Ready: Medium not present
usb-storage: scsi cmd done, result=0x2
usb-storage: *** thread sleeping.
usb-storage: queuecommand called
usb-storage: *** thread awakened.
usb-storage: Command TEST_UNIT_READY (6 bytes)
usb-storage:  00 00 00 00 00 00
usb-storage: Bulk Command S 0x43425355 T 0x4fb L 0 F 0 Trg 0 LUN 1 CL 6
usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
usb-storage: Status code 0; transferred 31/31
usb-storage: -- transfer complete
usb-storage: Bulk command transfer result=0
usb-storage: Attempting to get CSW...
usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
usb-storage: Status code 0; transferred 13/13
usb-storage: -- transfer complete
usb-storage: Bulk status result = 0
usb-storage: Bulk Status S 0x53425355 T 0x4fb R 0 Stat 0x1
usb-storage: -- transport indicates command failure
usb-storage: Issuing auto-REQUEST_SENSE
usb-storage: Bulk Command S 0x43425355 T 0x4fc L 18 F 128 Trg 0 LUN 1 CL 6
usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
usb-storage: Status code 0; transferred 31/31
usb-storage: -- transfer complete
usb-storage: Bulk command transfer result=0
usb-storage: usb_stor_bulk_transfer_sglist: xfer 18 bytes, 1 entries
usb-storage: Status code 0; transferred 18/18
usb-storage: -- transfer complete
usb-storage: Bulk data transfer result 0x0
usb-storage: Attempting to get CSW...
usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
usb-storage: Status code 0; transferred 13/13
usb-storage: -- transfer complete
usb-storage: Bulk status result = 0
usb-storage: Bulk Status S 0x53425355 T 0x4fc R 0 Stat 0x0
usb-storage: -- Result from auto-sense is 0
usb-storage: -- code: 0x70, key: 0x2, ASC: 0x3a, ASCQ: 0x0
usb-storage: Not Ready: Medium not present
usb-storage: scsi cmd done, result=0x2
usb-storage: *** thread sleeping.
usb-storage: queuecommand called
usb-storage: *** thread awakened.
usb-storage: Command TEST_UNIT_READY (6 bytes)
usb-storage:  00 00 00 00 00 00
usb-storage: Bulk Command S 0x43425355 T 0x4fd L 0 F 0 Trg 0 LUN 1 CL 6
usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
usb-storage: Status code 0; transferred 31/31
usb-storage: -- transfer complete
usb-storage: Bulk command transfer result=0
usb-storage: Attempting to get CSW...
usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
usb-storage: Status code 0; transferred 13/13
usb-storage: -- transfer complete
usb-storage: Bulk status result = 0
usb-storage: Bulk Status S 0x53425355 T 0x4fd R 0 Stat 0x1
usb-storage: -- transport indicates command failure
usb-storage: Issuing auto-REQUEST_SENSE
usb-storage: Bulk Command S 0x43425355 T 0x4fe L 18 F 128 Trg 0 LUN 1 CL 6
usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
usb-storage: Status code 0; transferred 31/31
usb-storage: -- transfer complete
usb-storage: Bulk command transfer result=0
usb-storage: usb_stor_bulk_transfer_sglist: xfer 18 bytes, 1 entries
usb-storage: Status code 0; transferred 18/18
usb-storage: -- transfer complete
usb-storage: Bulk data transfer result 0x0
usb-storage: Attempting to get CSW...
usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
usb-storage: Status code 0; transferred 13/13
usb-storage: -- transfer complete
usb-storage: Bulk status result = 0
usb-storage: Bulk Status S 0x53425355 T 0x4fe R 0 Stat 0x0
usb-storage: -- Result from auto-sense is 0
usb-storage: -- code: 0x70, key: 0x2, ASC: 0x3a, ASCQ: 0x0
usb-storage: Not Ready: Medium not present
usb-storage: scsi cmd done, result=0x2
usb-storage: *** thread sleeping.
usb-storage: queuecommand called
usb-storage: *** thread awakened.
usb-storage: Command TEST_UNIT_READY (6 bytes)
usb-storage:  00 00 00 00 00 00
usb-storage: Bulk Command S 0x43425355 T 0x4ff L 0 F 0 Trg 0 LUN 1 CL 6
usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
usb-storage: Status code 0; transferred 31/31
usb-storage: -- transfer complete
usb-storage: Bulk command transfer result=0
usb-storage: Attempting to get CSW...
usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
usb-storage: Status code 0; transferred 13/13
usb-storage: -- transfer complete
usb-storage: Bulk status result = 0
usb-storage: Bulk Status S 0x53425355 T 0x4ff R 0 Stat 0x1
usb-storage: -- transport indicates command failure
usb-storage: Issuing auto-REQUEST_SENSE
usb-storage: Bulk Command S 0x43425355 T 0x500 L 18 F 128 Trg 0 LUN 1 CL 6
usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
usb-storage: Status code 0; transferred 31/31
usb-storage: -- transfer complete
usb-storage: Bulk command transfer result=0
usb-storage: usb_stor_bulk_transfer_sglist: xfer 18 bytes, 1 entries
usb-storage: Status code 0; transferred 18/18
usb-storage: -- transfer complete
usb-storage: Bulk data transfer result 0x0
usb-storage: Attempting to get CSW...
usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
usb-storage: Status code 0; transferred 13/13
usb-storage: -- transfer complete
usb-storage: Bulk status result = 0
usb-storage: Bulk Status S 0x53425355 T 0x500 R 0 Stat 0x0
usb-storage: -- Result from auto-sense is 0
usb-storage: -- code: 0x70, key: 0x2, ASC: 0x3a, ASCQ: 0x0
usb-storage: Not Ready: Medium not present
usb-storage: scsi cmd done, result=0x2
usb-storage: *** thread sleeping.
usb-storage: queuecommand called
usb-storage: *** thread awakened.
usb-storage: Command TEST_UNIT_READY (6 bytes)
usb-storage:  00 00 00 00 00 00
usb-storage: Bulk Command S 0x43425355 T 0x501 L 0 F 0 Trg 0 LUN 0 CL 6
usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
usb-storage: Status code 0; transferred 31/31
usb-storage: -- transfer complete
usb-storage: Bulk command transfer result=0
usb-storage: Attempting to get CSW...
usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
usb-storage: Status code 0; transferred 13/13
usb-storage: -- transfer complete
usb-storage: Bulk status result = 0
usb-storage: Bulk Status S 0x53425355 T 0x501 R 0 Stat 0x1
usb-storage: -- transport indicates command failure
usb-storage: Issuing auto-REQUEST_SENSE
usb-storage: Bulk Command S 0x43425355 T 0x502 L 18 F 128 Trg 0 LUN 0 CL 6
usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
usb-storage: Status code 0; transferred 31/31
usb-storage: -- transfer complete
usb-storage: Bulk command transfer result=0
usb-storage: usb_stor_bulk_transfer_sglist: xfer 18 bytes, 1 entries
usb-storage: Status code 0; transferred 18/18
usb-storage: -- transfer complete
usb-storage: Bulk data transfer result 0x0
usb-storage: Attempting to get CSW...
usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
usb-storage: Status code 0; transferred 13/13
usb-storage: -- transfer complete
usb-storage: Bulk status result = 0
usb-storage: Bulk Status S 0x53425355 T 0x502 R 0 Stat 0x0
usb-storage: -- Result from auto-sense is 0
usb-storage: -- code: 0x70, key: 0x2, ASC: 0x3a, ASCQ: 0x0
usb-storage: Not Ready: Medium not present
usb-storage: scsi cmd done, result=0x2
usb-storage: *** thread sleeping.
usb-storage: queuecommand called
usb-storage: *** thread awakened.
usb-storage: Command TEST_UNIT_READY (6 bytes)
usb-storage:  00 00 00 00 00 00
usb-storage: Bulk Command S 0x43425355 T 0x503 L 0 F 0 Trg 0 LUN 0 CL 6
usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
usb-storage: Status code 0; transferred 31/31
usb-storage: -- transfer complete
usb-storage: Bulk command transfer result=0
usb-storage: Attempting to get CSW...
usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
usb-storage: Status code 0; transferred 13/13
usb-storage: -- transfer complete
usb-storage: Bulk status result = 0
usb-storage: Bulk Status S 0x53425355 T 0x503 R 0 Stat 0x1
usb-storage: -- transport indicates command failure
usb-storage: Issuing auto-REQUEST_SENSE
usb-storage: Bulk Command S 0x43425355 T 0x504 L 18 F 128 Trg 0 LUN 0 CL 6
usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
usb-storage: Status code 0; transferred 31/31
usb-storage: -- transfer complete
usb-storage: Bulk command transfer result=0
usb-storage: usb_stor_bulk_transfer_sglist: xfer 18 bytes, 1 entries
usb-storage: Status code 0; transferred 18/18
usb-storage: -- transfer complete
usb-storage: Bulk data transfer result 0x0
usb-storage: Attempting to get CSW...
usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
usb-storage: Status code 0; transferred 13/13
usb-storage: -- transfer complete
usb-storage: Bulk status result = 0
usb-storage: Bulk Status S 0x53425355 T 0x504 R 0 Stat 0x0
usb-storage: -- Result from auto-sense is 0
usb-storage: -- code: 0x70, key: 0x2, ASC: 0x3a, ASCQ: 0x0
usb-storage: Not Ready: Medium not present
usb-storage: scsi cmd done, result=0x2
usb-storage: *** thread sleeping.
usb-storage: queuecommand called
usb-storage: *** thread awakened.
usb-storage: Command TEST_UNIT_READY (6 bytes)
usb-storage:  00 00 00 00 00 00
usb-storage: Bulk Command S 0x43425355 T 0x505 L 0 F 0 Trg 0 LUN 0 CL 6
usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
usb-storage: Status code 0; transferred 31/31
usb-storage: -- transfer complete
usb-storage: Bulk command transfer result=0
usb-storage: Attempting to get CSW...
usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
usb-storage: Status code 0; transferred 13/13
usb-storage: -- transfer complete
usb-storage: Bulk status result = 0
usb-storage: Bulk Status S 0x53425355 T 0x505 R 0 Stat 0x1
usb-storage: -- transport indicates command failure
usb-storage: Issuing auto-REQUEST_SENSE
usb-storage: Bulk Command S 0x43425355 T 0x506 L 18 F 128 Trg 0 LUN 0 CL 6
usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
usb-storage: Status code 0; transferred 31/31
usb-storage: -- transfer complete
usb-storage: Bulk command transfer result=0
usb-storage: usb_stor_bulk_transfer_sglist: xfer 18 bytes, 1 entries
usb-storage: Status code 0; transferred 18/18
usb-storage: -- transfer complete
usb-storage: Bulk data transfer result 0x0
usb-storage: Attempting to get CSW...
usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
usb-storage: Status code 0; transferred 13/13
usb-storage: -- transfer complete
usb-storage: Bulk status result = 0
usb-storage: Bulk Status S 0x53425355 T 0x506 R 0 Stat 0x0
usb-storage: -- Result from auto-sense is 0
usb-storage: -- code: 0x70, key: 0x2, ASC: 0x3a, ASCQ: 0x0
usb-storage: Not Ready: Medium not present
usb-storage: scsi cmd done, result=0x2
usb-storage: *** thread sleeping.
usb-storage: queuecommand called
usb-storage: *** thread awakened.
usb-storage: Command TEST_UNIT_READY (6 bytes)
usb-storage:  00 00 00 00 00 00
usb-storage: Bulk Command S 0x43425355 T 0x507 L 0 F 0 Trg 0 LUN 1 CL 6
usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
usb-storage: Status code 0; transferred 31/31
usb-storage: -- transfer complete
usb-storage: Bulk command transfer result=0
usb-storage: Attempting to get CSW...
usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
usb-storage: Status code 0; transferred 13/13
usb-storage: -- transfer complete
usb-storage: Bulk status result = 0
usb-storage: Bulk Status S 0x53425355 T 0x507 R 0 Stat 0x1
usb-storage: -- transport indicates command failure
usb-storage: Issuing auto-REQUEST_SENSE
usb-storage: Bulk Command S 0x43425355 T 0x508 L 18 F 128 Trg 0 LUN 1 CL 6
usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
usb-storage: Status code 0; transferred 31/31
usb-storage: -- transfer complete
usb-storage: Bulk command transfer result=0
usb-storage: usb_stor_bulk_transfer_sglist: xfer 18 bytes, 1 entries
usb-storage: Status code 0; transferred 18/18
usb-storage: -- transfer complete
usb-storage: Bulk data transfer result 0x0
usb-storage: Attempting to get CSW...
usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
usb-storage: Status code 0; transferred 13/13
usb-storage: -- transfer complete
usb-storage: Bulk status result = 0
usb-storage: Bulk Status S 0x53425355 T 0x508 R 0 Stat 0x0
usb-storage: -- Result from auto-sense is 0
usb-storage: -- code: 0x70, key: 0x2, ASC: 0x3a, ASCQ: 0x0
usb-storage: Not Ready: Medium not present
usb-storage: scsi cmd done, result=0x2
usb-storage: *** thread sleeping.
usb-storage: queuecommand called
usb-storage: *** thread awakened.
usb-storage: Command TEST_UNIT_READY (6 bytes)
usb-storage:  00 00 00 00 00 00
usb-storage: Bulk Command S 0x43425355 T 0x509 L 0 F 0 Trg 0 LUN 0 CL 6
usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
usb-storage: Status code 0; transferred 31/31
usb-storage: -- transfer complete
usb-storage: Bulk command transfer result=0
usb-storage: Attempting to get CSW...
usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
usb-storage: Status code 0; transferred 13/13
usb-storage: -- transfer complete
usb-storage: Bulk status result = 0
usb-storage: Bulk Status S 0x53425355 T 0x509 R 0 Stat 0x1
usb-storage: -- transport indicates command failure
usb-storage: Issuing auto-REQUEST_SENSE
usb-storage: Bulk Command S 0x43425355 T 0x50a L 18 F 128 Trg 0 LUN 0 CL 6
usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
usb-storage: Status code 0; transferred 31/31
usb-storage: -- transfer complete
usb-storage: Bulk command transfer result=0
usb-storage: usb_stor_bulk_transfer_sglist: xfer 18 bytes, 1 entries
usb-storage: Status code 0; transferred 18/18
usb-storage: -- transfer complete
usb-storage: Bulk data transfer result 0x0
usb-storage: Attempting to get CSW...
usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
usb-storage: Status code 0; transferred 13/13
usb-storage: -- transfer complete
usb-storage: Bulk status result = 0
usb-storage: Bulk Status S 0x53425355 T 0x50a R 0 Stat 0x0
usb-storage: -- Result from auto-sense is 0
usb-storage: -- code: 0x70, key: 0x2, ASC: 0x3a, ASCQ: 0x0
usb-storage: Not Ready: Medium not present
usb-storage: scsi cmd done, result=0x2
usb-storage: *** thread sleeping.
usb-storage: queuecommand called
usb-storage: *** thread awakened.
usb-storage: Command TEST_UNIT_READY (6 bytes)
usb-storage:  00 00 00 00 00 00
usb-storage: Bulk Command S 0x43425355 T 0x50b L 0 F 0 Trg 0 LUN 1 CL 6
usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
usb-storage: Status code 0; transferred 31/31
usb-storage: -- transfer complete
usb-storage: Bulk command transfer result=0
usb-storage: Attempting to get CSW...
usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
usb-storage: Status code 0; transferred 13/13
usb-storage: -- transfer complete
usb-storage: Bulk status result = 0
usb-storage: Bulk Status S 0x53425355 T 0x50b R 0 Stat 0x1
usb-storage: -- transport indicates command failure
usb-storage: Issuing auto-REQUEST_SENSE
usb-storage: Bulk Command S 0x43425355 T 0x50c L 18 F 128 Trg 0 LUN 1 CL 6
usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
usb-storage: Status code 0; transferred 31/31
usb-storage: -- transfer complete
usb-storage: Bulk command transfer result=0
usb-storage: usb_stor_bulk_transfer_sglist: xfer 18 bytes, 1 entries
usb-storage: Status code 0; transferred 18/18
usb-storage: -- transfer complete
usb-storage: Bulk data transfer result 0x0
usb-storage: Attempting to get CSW...
usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
usb-storage: Status code 0; transferred 13/13
usb-storage: -- transfer complete
usb-storage: Bulk status result = 0
usb-storage: Bulk Status S 0x53425355 T 0x50c R 0 Stat 0x0
usb-storage: -- Result from auto-sense is 0
usb-storage: -- code: 0x70, key: 0x2, ASC: 0x3a, ASCQ: 0x0
usb-storage: Not Ready: Medium not present
usb-storage: scsi cmd done, result=0x2
usb-storage: *** thread sleeping.
usb-storage: queuecommand called
usb-storage: *** thread awakened.
usb-storage: Command TEST_UNIT_READY (6 bytes)
usb-storage:  00 00 00 00 00 00
usb-storage: Bulk Command S 0x43425355 T 0x50d L 0 F 0 Trg 0 LUN 0 CL 6
usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
usb-storage: Status code 0; transferred 31/31
usb-storage: -- transfer complete
usb-storage: Bulk command transfer result=0
usb-storage: Attempting to get CSW...
usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
usb-storage: Status code 0; transferred 13/13
usb-storage: -- transfer complete
usb-storage: Bulk status result = 0
usb-storage: Bulk Status S 0x53425355 T 0x50d R 0 Stat 0x1
usb-storage: -- transport indicates command failure
usb-storage: Issuing auto-REQUEST_SENSE
usb-storage: Bulk Command S 0x43425355 T 0x50e L 18 F 128 Trg 0 LUN 0 CL 6
usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
usb-storage: Status code 0; transferred 31/31
usb-storage: -- transfer complete
usb-storage: Bulk command transfer result=0
usb-storage: usb_stor_bulk_transfer_sglist: xfer 18 bytes, 1 entries
usb-storage: Status code 0; transferred 18/18
usb-storage: -- transfer complete
usb-storage: Bulk data transfer result 0x0
usb-storage: Attempting to get CSW...
usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
usb-storage: Status code 0; transferred 13/13
usb-storage: -- transfer complete
usb-storage: Bulk status result = 0
usb-storage: Bulk Status S 0x53425355 T 0x50e R 0 Stat 0x0
usb-storage: -- Result from auto-sense is 0
usb-storage: -- code: 0x70, key: 0x2, ASC: 0x3a, ASCQ: 0x0
usb-storage: Not Ready: Medium not present
usb-storage: scsi cmd done, result=0x2
usb-storage: *** thread sleeping.
usb-storage: queuecommand called
usb-storage: *** thread awakened.
usb-storage: Command TEST_UNIT_READY (6 bytes)
usb-storage:  00 00 00 00 00 00
usb-storage: Bulk Command S 0x43425355 T 0x50f L 0 F 0 Trg 0 LUN 0 CL 6
usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
usb-storage: Status code 0; transferred 31/31
usb-storage: -- transfer complete
usb-storage: Bulk command transfer result=0
usb-storage: Attempting to get CSW...
usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
usb-storage: Status code 0; transferred 13/13
usb-storage: -- transfer complete
usb-storage: Bulk status result = 0
usb-storage: Bulk Status S 0x53425355 T 0x50f R 0 Stat 0x1
usb-storage: -- transport indicates command failure
usb-storage: Issuing auto-REQUEST_SENSE
usb-storage: Bulk Command S 0x43425355 T 0x510 L 18 F 128 Trg 0 LUN 0 CL 6
usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
usb-storage: Status code 0; transferred 31/31
usb-storage: -- transfer complete
usb-storage: Bulk command transfer result=0
usb-storage: usb_stor_bulk_transfer_sglist: xfer 18 bytes, 1 entries
usb-storage: Status code 0; transferred 18/18
usb-storage: -- transfer complete
usb-storage: Bulk data transfer result 0x0
usb-storage: Attempting to get CSW...
usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
usb-storage: Status code 0; transferred 13/13
usb-storage: -- transfer complete
usb-storage: Bulk status result = 0
usb-storage: Bulk Status S 0x53425355 T 0x510 R 0 Stat 0x0
usb-storage: -- Result from auto-sense is 0
usb-storage: -- code: 0x70, key: 0x2, ASC: 0x3a, ASCQ: 0x0
usb-storage: Not Ready: Medium not present
usb-storage: scsi cmd done, result=0x2
usb-storage: *** thread sleeping.
usb-storage: queuecommand called
usb-storage: *** thread awakened.
usb-storage: Command TEST_UNIT_READY (6 bytes)
usb-storage:  00 00 00 00 00 00
usb-storage: Bulk Command S 0x43425355 T 0x511 L 0 F 0 Trg 0 LUN 1 CL 6
usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
usb-storage: Status code 0; transferred 31/31
usb-storage: -- transfer complete
usb-storage: Bulk command transfer result=0
usb-storage: Attempting to get CSW...
usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
usb-storage: Status code 0; transferred 13/13
usb-storage: -- transfer complete
usb-storage: Bulk status result = 0
usb-storage: Bulk Status S 0x53425355 T 0x511 R 0 Stat 0x1
usb-storage: -- transport indicates command failure
usb-storage: Issuing auto-REQUEST_SENSE
usb-storage: Bulk Command S 0x43425355 T 0x512 L 18 F 128 Trg 0 LUN 1 CL 6
usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
usb-storage: Status code 0; transferred 31/31
usb-storage: -- transfer complete
usb-storage: Bulk command transfer result=0
usb-storage: usb_stor_bulk_transfer_sglist: xfer 18 bytes, 1 entries
usb-storage: Status code 0; transferred 18/18
usb-storage: -- transfer complete
usb-storage: Bulk data transfer result 0x0
usb-storage: Attempting to get CSW...
usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
usb-storage: Status code 0; transferred 13/13
usb-storage: -- transfer complete
usb-storage: Bulk status result = 0
usb-storage: Bulk Status S 0x53425355 T 0x512 R 0 Stat 0x0
usb-storage: -- Result from auto-sense is 0
usb-storage: -- code: 0x70, key: 0x2, ASC: 0x3a, ASCQ: 0x0
usb-storage: Not Ready: Medium not present
usb-storage: scsi cmd done, result=0x2
usb-storage: *** thread sleeping.
usb-storage: queuecommand called
usb-storage: *** thread awakened.
usb-storage: Command TEST_UNIT_READY (6 bytes)
usb-storage:  00 00 00 00 00 00
usb-storage: Bulk Command S 0x43425355 T 0x513 L 0 F 0 Trg 0 LUN 1 CL 6
usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
usb-storage: Status code 0; transferred 31/31
usb-storage: -- transfer complete
usb-storage: Bulk command transfer result=0
usb-storage: Attempting to get CSW...
usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
usb-storage: Status code 0; transferred 13/13
usb-storage: -- transfer complete
usb-storage: Bulk status result = 0
usb-storage: Bulk Status S 0x53425355 T 0x513 R 0 Stat 0x1
usb-storage: -- transport indicates command failure
usb-storage: Issuing auto-REQUEST_SENSE
usb-storage: Bulk Command S 0x43425355 T 0x514 L 18 F 128 Trg 0 LUN 1 CL 6
usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
usb-storage: Status code 0; transferred 31/31
usb-storage: -- transfer complete
usb-storage: Bulk command transfer result=0
usb-storage: usb_stor_bulk_transfer_sglist: xfer 18 bytes, 1 entries
usb-storage: Status code 0; transferred 18/18
usb-storage: -- transfer complete
usb-storage: Bulk data transfer result 0x0
usb-storage: Attempting to get CSW...
usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
usb-storage: Status code 0; transferred 13/13
usb-storage: -- transfer complete
usb-storage: Bulk status result = 0
usb-storage: Bulk Status S 0x53425355 T 0x514 R 0 Stat 0x0
usb-storage: -- Result from auto-sense is 0
usb-storage: -- code: 0x70, key: 0x2, ASC: 0x3a, ASCQ: 0x0
usb-storage: Not Ready: Medium not present
usb-storage: scsi cmd done, result=0x2
usb-storage: *** thread sleeping.
usb-storage: queuecommand called
usb-storage: *** thread awakened.
usb-storage: Command TEST_UNIT_READY (6 bytes)
usb-storage:  00 00 00 00 00 00
usb-storage: Bulk Command S 0x43425355 T 0x515 L 0 F 0 Trg 0 LUN 1 CL 6
usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
usb-storage: Status code 0; transferred 31/31
usb-storage: -- transfer complete
usb-storage: Bulk command transfer result=0
usb-storage: Attempting to get CSW...
usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
usb-storage: Status code 0; transferred 13/13
usb-storage: -- transfer complete
usb-storage: Bulk status result = 0
usb-storage: Bulk Status S 0x53425355 T 0x515 R 0 Stat 0x1
usb-storage: -- transport indicates command failure
usb-storage: Issuing auto-REQUEST_SENSE
usb-storage: Bulk Command S 0x43425355 T 0x516 L 18 F 128 Trg 0 LUN 1 CL 6
usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
usb-storage: Status code 0; transferred 31/31
usb-storage: -- transfer complete
usb-storage: Bulk command transfer result=0
usb-storage: usb_stor_bulk_transfer_sglist: xfer 18 bytes, 1 entries
usb-storage: Status code 0; transferred 18/18
usb-storage: -- transfer complete
usb-storage: Bulk data transfer result 0x0
usb-storage: Attempting to get CSW...
usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
usb-storage: Status code 0; transferred 13/13
usb-storage: -- transfer complete
usb-storage: Bulk status result = 0
usb-storage: Bulk Status S 0x53425355 T 0x516 R 0 Stat 0x0
usb-storage: -- Result from auto-sense is 0
usb-storage: -- code: 0x70, key: 0x2, ASC: 0x3a, ASCQ: 0x0
usb-storage: Not Ready: Medium not present
usb-storage: scsi cmd done, result=0x2
usb-storage: *** thread sleeping.
usb-storage: queuecommand called
usb-storage: *** thread awakened.
usb-storage: Command TEST_UNIT_READY (6 bytes)
usb-storage:  00 00 00 00 00 00
usb-storage: Bulk Command S 0x43425355 T 0x517 L 0 F 0 Trg 0 LUN 0 CL 6
usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
usb-storage: Status code 0; transferred 31/31
usb-storage: -- transfer complete
usb-storage: Bulk command transfer result=0
usb-storage: Attempting to get CSW...
usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
usb-storage: Status code 0; transferred 13/13
usb-storage: -- transfer complete
usb-storage: Bulk status result = 0
usb-storage: Bulk Status S 0x53425355 T 0x517 R 0 Stat 0x1
usb-storage: -- transport indicates command failure
usb-storage: Issuing auto-REQUEST_SENSE
usb-storage: Bulk Command S 0x43425355 T 0x518 L 18 F 128 Trg 0 LUN 0 CL 6
usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
usb-storage: Status code 0; transferred 31/31
usb-storage: -- transfer complete
usb-storage: Bulk command transfer result=0
usb-storage: usb_stor_bulk_transfer_sglist: xfer 18 bytes, 1 entries
usb-storage: Status code 0; transferred 18/18
usb-storage: -- transfer complete
usb-storage: Bulk data transfer result 0x0
usb-storage: Attempting to get CSW...
usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
usb-storage: Status code 0; transferred 13/13
usb-storage: -- transfer complete
usb-storage: Bulk status result = 0
usb-storage: Bulk Status S 0x53425355 T 0x518 R 0 Stat 0x0
usb-storage: -- Result from auto-sense is 0
usb-storage: -- code: 0x70, key: 0x2, ASC: 0x3a, ASCQ: 0x0
usb-storage: Not Ready: Medium not present
usb-storage: scsi cmd done, result=0x2
usb-storage: *** thread sleeping.
usb-storage: queuecommand called
usb-storage: *** thread awakened.
usb-storage: Command TEST_UNIT_READY (6 bytes)
usb-storage:  00 00 00 00 00 00
usb-storage: Bulk Command S 0x43425355 T 0x519 L 0 F 0 Trg 0 LUN 1 CL 6
usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
usb-storage: Status code 0; transferred 31/31
usb-storage: -- transfer complete
usb-storage: Bulk command transfer result=0
usb-storage: Attempting to get CSW...
usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
usb-storage: Status code 0; transferred 13/13
usb-storage: -- transfer complete
usb-storage: Bulk status result = 0
usb-storage: Bulk Status S 0x53425355 T 0x519 R 0 Stat 0x1
usb-storage: -- transport indicates command failure
usb-storage: Issuing auto-REQUEST_SENSE
usb-storage: Bulk Command S 0x43425355 T 0x51a L 18 F 128 Trg 0 LUN 1 CL 6
usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
usb-storage: Status code 0; transferred 31/31
usb-storage: -- transfer complete
usb-storage: Bulk command transfer result=0
usb-storage: usb_stor_bulk_transfer_sglist: xfer 18 bytes, 1 entries
usb-storage: Status code 0; transferred 18/18
usb-storage: -- transfer complete
usb-storage: Bulk data transfer result 0x0
usb-storage: Attempting to get CSW...
usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
usb-storage: Status code 0; transferred 13/13
usb-storage: -- transfer complete
usb-storage: Bulk status result = 0
usb-storage: Bulk Status S 0x53425355 T 0x51a R 0 Stat 0x0
usb-storage: -- Result from auto-sense is 0
usb-storage: -- code: 0x70, key: 0x2, ASC: 0x3a, ASCQ: 0x0
usb-storage: Not Ready: Medium not present
usb-storage: scsi cmd done, result=0x2
usb-storage: *** thread sleeping.
usb-storage: queuecommand called
usb-storage: *** thread awakened.
usb-storage: Command TEST_UNIT_READY (6 bytes)
usb-storage:  00 00 00 00 00 00
usb-storage: Bulk Command S 0x43425355 T 0x51b L 0 F 0 Trg 0 LUN 0 CL 6
usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
usb-storage: Status code 0; transferred 31/31
usb-storage: -- transfer complete
usb-storage: Bulk command transfer result=0
usb-storage: Attempting to get CSW...
usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
usb-storage: Status code 0; transferred 13/13
usb-storage: -- transfer complete
usb-storage: Bulk status result = 0
usb-storage: Bulk Status S 0x53425355 T 0x51b R 0 Stat 0x1
usb-storage: -- transport indicates command failure
usb-storage: Issuing auto-REQUEST_SENSE
usb-storage: Bulk Command S 0x43425355 T 0x51c L 18 F 128 Trg 0 LUN 0 CL 6
usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
usb-storage: Status code 0; transferred 31/31
usb-storage: -- transfer complete
usb-storage: Bulk command transfer result=0
usb-storage: usb_stor_bulk_transfer_sglist: xfer 18 bytes, 1 entries
usb-storage: Status code 0; transferred 18/18
usb-storage: -- transfer complete
usb-storage: Bulk data transfer result 0x0
usb-storage: Attempting to get CSW...
usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
usb-storage: Status code 0; transferred 13/13
usb-storage: -- transfer complete
usb-storage: Bulk status result = 0
usb-storage: Bulk Status S 0x53425355 T 0x51c R 0 Stat 0x0
usb-storage: -- Result from auto-sense is 0
usb-storage: -- code: 0x70, key: 0x2, ASC: 0x3a, ASCQ: 0x0
usb-storage: Not Ready: Medium not present
usb-storage: scsi cmd done, result=0x2
usb-storage: *** thread sleeping.
usb-storage: queuecommand called
usb-storage: *** thread awakened.
usb-storage: Command TEST_UNIT_READY (6 bytes)
usb-storage:  00 00 00 00 00 00
usb-storage: Bulk Command S 0x43425355 T 0x51d L 0 F 0 Trg 0 LUN 1 CL 6
usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
usb-storage: Status code 0; transferred 31/31
usb-storage: -- transfer complete
usb-storage: Bulk command transfer result=0
usb-storage: Attempting to get CSW...
usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
usb-storage: Status code 0; transferred 13/13
usb-storage: -- transfer complete
usb-storage: Bulk status result = 0
usb-storage: Bulk Status S 0x53425355 T 0x51d R 0 Stat 0x1
usb-storage: -- transport indicates command failure
usb-storage: Issuing auto-REQUEST_SENSE
usb-storage: Bulk Command S 0x43425355 T 0x51e L 18 F 128 Trg 0 LUN 1 CL 6
usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
usb-storage: Status code 0; transferred 31/31
usb-storage: -- transfer complete
usb-storage: Bulk command transfer result=0
usb-storage: usb_stor_bulk_transfer_sglist: xfer 18 bytes, 1 entries
usb-storage: Status code 0; transferred 18/18
usb-storage: -- transfer complete
usb-storage: Bulk data transfer result 0x0
usb-storage: Attempting to get CSW...
usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
usb-storage: Status code 0; transferred 13/13
usb-storage: -- transfer complete
usb-storage: Bulk status result = 0
usb-storage: Bulk Status S 0x53425355 T 0x51e R 0 Stat 0x0
usb-storage: -- Result from auto-sense is 0
usb-storage: -- code: 0x70, key: 0x2, ASC: 0x3a, ASCQ: 0x0
usb-storage: Not Ready: Medium not present
usb-storage: scsi cmd done, result=0x2
usb-storage: *** thread sleeping.
usb-storage: queuecommand called
usb-storage: *** thread awakened.
usb-storage: Command TEST_UNIT_READY (6 bytes)
usb-storage:  00 00 00 00 00 00
usb-storage: Bulk Command S 0x43425355 T 0x51f L 0 F 0 Trg 0 LUN 0 CL 6
usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
usb-storage: Status code 0; transferred 31/31
usb-storage: -- transfer complete
usb-storage: Bulk command transfer result=0
usb-storage: Attempting to get CSW...
usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
usb-storage: Status code 0; transferred 13/13
usb-storage: -- transfer complete
usb-storage: Bulk status result = 0
usb-storage: Bulk Status S 0x53425355 T 0x51f R 0 Stat 0x1
usb-storage: -- transport indicates command failure
usb-storage: Issuing auto-REQUEST_SENSE
usb-storage: Bulk Command S 0x43425355 T 0x520 L 18 F 128 Trg 0 LUN 0 CL 6
usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
usb-storage: Status code 0; transferred 31/31
usb-storage: -- transfer complete
usb-storage: Bulk command transfer result=0
usb-storage: usb_stor_bulk_transfer_sglist: xfer 18 bytes, 1 entries
usb-storage: Status code 0; transferred 18/18
usb-storage: -- transfer complete
usb-storage: Bulk data transfer result 0x0
usb-storage: Attempting to get CSW...
usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
usb-storage: Status code 0; transferred 13/13
usb-storage: -- transfer complete
usb-storage: Bulk status result = 0
usb-storage: Bulk Status S 0x53425355 T 0x520 R 0 Stat 0x0
usb-storage: -- Result from auto-sense is 0
usb-storage: -- code: 0x70, key: 0x2, ASC: 0x3a, ASCQ: 0x0
usb-storage: Not Ready: Medium not present
usb-storage: scsi cmd done, result=0x2
usb-storage: *** thread sleeping.
usb-storage: queuecommand called
usb-storage: *** thread awakened.
usb-storage: Command TEST_UNIT_READY (6 bytes)
usb-storage:  00 00 00 00 00 00
usb-storage: Bulk Command S 0x43425355 T 0x521 L 0 F 0 Trg 0 LUN 1 CL 6
usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
usb-storage: Status code 0; transferred 31/31
usb-storage: -- transfer complete
usb-storage: Bulk command transfer result=0
usb-storage: Attempting to get CSW...
usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
usb-storage: Status code 0; transferred 13/13
usb-storage: -- transfer complete
usb-storage: Bulk status result = 0
usb-storage: Bulk Status S 0x53425355 T 0x521 R 0 Stat 0x1
usb-storage: -- transport indicates command failure
usb-storage: Issuing auto-REQUEST_SENSE
usb-storage: Bulk Command S 0x43425355 T 0x522 L 18 F 128 Trg 0 LUN 1 CL 6
usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
usb-storage: Status code 0; transferred 31/31
usb-storage: -- transfer complete
usb-storage: Bulk command transfer result=0
usb-storage: usb_stor_bulk_transfer_sglist: xfer 18 bytes, 1 entries
usb-storage: Status code 0; transferred 18/18
usb-storage: -- transfer complete
usb-storage: Bulk data transfer result 0x0
usb-storage: Attempting to get CSW...
usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
usb-storage: Status code 0; transferred 13/13
usb-storage: -- transfer complete
usb-storage: Bulk status result = 0
usb-storage: Bulk Status S 0x53425355 T 0x522 R 0 Stat 0x0
usb-storage: -- Result from auto-sense is 0
usb-storage: -- code: 0x70, key: 0x2, ASC: 0x3a, ASCQ: 0x0
usb-storage: Not Ready: Medium not present
usb-storage: scsi cmd done, result=0x2
usb-storage: *** thread sleeping.
usb-storage: queuecommand called
usb-storage: *** thread awakened.
usb-storage: Command TEST_UNIT_READY (6 bytes)
usb-storage:  00 00 00 00 00 00
usb-storage: Bulk Command S 0x43425355 T 0x523 L 0 F 0 Trg 0 LUN 0 CL 6
usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
usb-storage: Status code 0; transferred 31/31
usb-storage: -- transfer complete
usb-storage: Bulk command transfer result=0
usb-storage: Attempting to get CSW...
usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
usb-storage: Status code 0; transferred 13/13
usb-storage: -- transfer complete
usb-storage: Bulk status result = 0
usb-storage: Bulk Status S 0x53425355 T 0x523 R 0 Stat 0x1
usb-storage: -- transport indicates command failure
usb-storage: Issuing auto-REQUEST_SENSE
usb-storage: Bulk Command S 0x43425355 T 0x524 L 18 F 128 Trg 0 LUN 0 CL 6
usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
usb-storage: Status code 0; transferred 31/31
usb-storage: -- transfer complete
usb-storage: Bulk command transfer result=0
usb-storage: usb_stor_bulk_transfer_sglist: xfer 18 bytes, 1 entries
usb-storage: Status code 0; transferred 18/18
usb-storage: -- transfer complete
usb-storage: Bulk data transfer result 0x0
usb-storage: Attempting to get CSW...
usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
usb-storage: Status code 0; transferred 13/13
usb-storage: -- transfer complete
usb-storage: Bulk status result = 0
usb-storage: Bulk Status S 0x53425355 T 0x524 R 0 Stat 0x0
usb-storage: -- Result from auto-sense is 0
usb-storage: -- code: 0x70, key: 0x2, ASC: 0x3a, ASCQ: 0x0
usb-storage: Not Ready: Medium not present
usb-storage: scsi cmd done, result=0x2
usb-storage: *** thread sleeping.
usb-storage: queuecommand called
usb-storage: *** thread awakened.
usb-storage: Command TEST_UNIT_READY (6 bytes)
usb-storage:  00 00 00 00 00 00
usb-storage: Bulk Command S 0x43425355 T 0x525 L 0 F 0 Trg 0 LUN 0 CL 6
usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
usb-storage: Status code 0; transferred 31/31
usb-storage: -- transfer complete
usb-storage: Bulk command transfer result=0
usb-storage: Attempting to get CSW...
usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
usb-storage: Status code 0; transferred 13/13
usb-storage: -- transfer complete
usb-storage: Bulk status result = 0
usb-storage: Bulk Status S 0x53425355 T 0x525 R 0 Stat 0x1
usb-storage: -- transport indicates command failure
usb-storage: Issuing auto-REQUEST_SENSE
usb-storage: Bulk Command S 0x43425355 T 0x526 L 18 F 128 Trg 0 LUN 0 CL 6
usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
usb-storage: Status code 0; transferred 31/31
usb-storage: -- transfer complete
usb-storage: Bulk command transfer result=0
usb-storage: usb_stor_bulk_transfer_sglist: xfer 18 bytes, 1 entries
usb-storage: Status code 0; transferred 18/18
usb-storage: -- transfer complete
usb-storage: Bulk data transfer result 0x0
usb-storage: Attempting to get CSW...
usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
usb-storage: Status code 0; transferred 13/13
usb-storage: -- transfer complete
usb-storage: Bulk status result = 0
usb-storage: Bulk Status S 0x53425355 T 0x526 R 0 Stat 0x0
usb-storage: -- Result from auto-sense is 0
usb-storage: -- code: 0x70, key: 0x2, ASC: 0x3a, ASCQ: 0x0
usb-storage: Not Ready: Medium not present
usb-storage: scsi cmd done, result=0x2
usb-storage: *** thread sleeping.
usb-storage: queuecommand called
usb-storage: *** thread awakened.
usb-storage: Command TEST_UNIT_READY (6 bytes)
usb-storage:  00 00 00 00 00 00
usb-storage: Bulk Command S 0x43425355 T 0x527 L 0 F 0 Trg 0 LUN 0 CL 6
usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
usb-storage: Status code 0; transferred 31/31
usb-storage: -- transfer complete
usb-storage: Bulk command transfer result=0
usb-storage: Attempting to get CSW...
usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
usb-storage: Status code 0; transferred 13/13
usb-storage: -- transfer complete
usb-storage: Bulk status result = 0
usb-storage: Bulk Status S 0x53425355 T 0x527 R 0 Stat 0x1
usb-storage: -- transport indicates command failure
usb-storage: Issuing auto-REQUEST_SENSE
usb-storage: Bulk Command S 0x43425355 T 0x528 L 18 F 128 Trg 0 LUN 0 CL 6
usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
usb-storage: Status code 0; transferred 31/31
usb-storage: -- transfer complete
usb-storage: Bulk command transfer result=0
usb-storage: usb_stor_bulk_transfer_sglist: xfer 18 bytes, 1 entries
usb-storage: Status code 0; transferred 18/18
usb-storage: -- transfer complete
usb-storage: Bulk data transfer result 0x0
usb-storage: Attempting to get CSW...
usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
usb-storage: Status code 0; transferred 13/13
usb-storage: -- transfer complete
usb-storage: Bulk status result = 0
usb-storage: Bulk Status S 0x53425355 T 0x528 R 0 Stat 0x0
usb-storage: -- Result from auto-sense is 0
usb-storage: -- code: 0x70, key: 0x2, ASC: 0x3a, ASCQ: 0x0
usb-storage: Not Ready: Medium not present
usb-storage: scsi cmd done, result=0x2
usb-storage: *** thread sleeping.
usb-storage: queuecommand called
usb-storage: *** thread awakened.
usb-storage: Command TEST_UNIT_READY (6 bytes)
usb-storage:  00 00 00 00 00 00
usb-storage: Bulk Command S 0x43425355 T 0x529 L 0 F 0 Trg 0 LUN 1 CL 6
usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
usb-storage: Status code 0; transferred 31/31
usb-storage: -- transfer complete
usb-storage: Bulk command transfer result=0
usb-storage: Attempting to get CSW...
usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
usb-storage: Status code 0; transferred 13/13
usb-storage: -- transfer complete
usb-storage: Bulk status result = 0
usb-storage: Bulk Status S 0x53425355 T 0x529 R 0 Stat 0x1
usb-storage: -- transport indicates command failure
usb-storage: Issuing auto-REQUEST_SENSE
usb-storage: Bulk Command S 0x43425355 T 0x52a L 18 F 128 Trg 0 LUN 1 CL 6
usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
usb-storage: Status code 0; transferred 31/31
usb-storage: -- transfer complete
usb-storage: Bulk command transfer result=0
usb-storage: usb_stor_bulk_transfer_sglist: xfer 18 bytes, 1 entries
usb-storage: Status code 0; transferred 18/18
usb-storage: -- transfer complete
usb-storage: Bulk data transfer result 0x0
usb-storage: Attempting to get CSW...
usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
usb-storage: Status code 0; transferred 13/13
usb-storage: -- transfer complete
usb-storage: Bulk status result = 0
usb-storage: Bulk Status S 0x53425355 T 0x52a R 0 Stat 0x0
usb-storage: -- Result from auto-sense is 0
usb-storage: -- code: 0x70, key: 0x2, ASC: 0x3a, ASCQ: 0x0
usb-storage: Not Ready: Medium not present
usb-storage: scsi cmd done, result=0x2
usb-storage: *** thread sleeping.
usb-storage: queuecommand called
usb-storage: *** thread awakened.
usb-storage: Command TEST_UNIT_READY (6 bytes)
usb-storage:  00 00 00 00 00 00
usb-storage: Bulk Command S 0x43425355 T 0x52b L 0 F 0 Trg 0 LUN 1 CL 6
usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
usb-storage: Status code 0; transferred 31/31
usb-storage: -- transfer complete
usb-storage: Bulk command transfer result=0
usb-storage: Attempting to get CSW...
usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
usb-storage: Status code 0; transferred 13/13
usb-storage: -- transfer complete
usb-storage: Bulk status result = 0
usb-storage: Bulk Status S 0x53425355 T 0x52b R 0 Stat 0x1
usb-storage: -- transport indicates command failure
usb-storage: Issuing auto-REQUEST_SENSE
usb-storage: Bulk Command S 0x43425355 T 0x52c L 18 F 128 Trg 0 LUN 1 CL 6
usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
usb-storage: Status code 0; transferred 31/31
usb-storage: -- transfer complete
usb-storage: Bulk command transfer result=0
usb-storage: usb_stor_bulk_transfer_sglist: xfer 18 bytes, 1 entries
usb-storage: Status code 0; transferred 18/18
usb-storage: -- transfer complete
usb-storage: Bulk data transfer result 0x0
usb-storage: Attempting to get CSW...
usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
usb-storage: Status code 0; transferred 13/13
usb-storage: -- transfer complete
usb-storage: Bulk status result = 0
usb-storage: Bulk Status S 0x53425355 T 0x52c R 0 Stat 0x0
usb-storage: -- Result from auto-sense is 0
usb-storage: -- code: 0x70, key: 0x2, ASC: 0x3a, ASCQ: 0x0
usb-storage: Not Ready: Medium not present
usb-storage: scsi cmd done, result=0x2
usb-storage: *** thread sleeping.
usb-storage: queuecommand called
usb-storage: *** thread awakened.
usb-storage: Command TEST_UNIT_READY (6 bytes)
usb-storage:  00 00 00 00 00 00
usb-storage: Bulk Command S 0x43425355 T 0x52d L 0 F 0 Trg 0 LUN 0 CL 6
usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
usb-storage: Status code 0; transferred 31/31
usb-storage: -- transfer complete
usb-storage: Bulk command transfer result=0
usb-storage: Attempting to get CSW...
usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
usb-storage: Status code 0; transferred 13/13
usb-storage: -- transfer complete
usb-storage: Bulk status result = 0
usb-storage: Bulk Status S 0x53425355 T 0x52d R 0 Stat 0x1
usb-storage: -- transport indicates command failure
usb-storage: Issuing auto-REQUEST_SENSE
usb-storage: Bulk Command S 0x43425355 T 0x52e L 18 F 128 Trg 0 LUN 0 CL 6
usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
usb-storage: Status code 0; transferred 31/31
usb-storage: -- transfer complete
usb-storage: Bulk command transfer result=0
usb-storage: usb_stor_bulk_transfer_sglist: xfer 18 bytes, 1 entries
usb-storage: Status code 0; transferred 18/18
usb-storage: -- transfer complete
usb-storage: Bulk data transfer result 0x0
usb-storage: Attempting to get CSW...
usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
usb-storage: Status code 0; transferred 13/13
usb-storage: -- transfer complete
usb-storage: Bulk status result = 0
usb-storage: Bulk Status S 0x53425355 T 0x52e R 0 Stat 0x0
usb-storage: -- Result from auto-sense is 0
usb-storage: -- code: 0x70, key: 0x2, ASC: 0x3a, ASCQ: 0x0
usb-storage: Not Ready: Medium not present
usb-storage: scsi cmd done, result=0x2
usb-storage: *** thread sleeping.
usb-storage: queuecommand called
usb-storage: *** thread awakened.
usb-storage: Command TEST_UNIT_READY (6 bytes)
usb-storage:  00 00 00 00 00 00
usb-storage: Bulk Command S 0x43425355 T 0x52f L 0 F 0 Trg 0 LUN 0 CL 6
usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
usb-storage: Status code 0; transferred 31/31
usb-storage: -- transfer complete
usb-storage: Bulk command transfer result=0
usb-storage: Attempting to get CSW...
usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
usb-storage: Status code 0; transferred 13/13
usb-storage: -- transfer complete
usb-storage: Bulk status result = 0
usb-storage: Bulk Status S 0x53425355 T 0x52f R 0 Stat 0x1
usb-storage: -- transport indicates command failure
usb-storage: Issuing auto-REQUEST_SENSE
usb-storage: Bulk Command S 0x43425355 T 0x530 L 18 F 128 Trg 0 LUN 0 CL 6
usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
usb-storage: Status code 0; transferred 31/31
usb-storage: -- transfer complete
usb-storage: Bulk command transfer result=0
usb-storage: usb_stor_bulk_transfer_sglist: xfer 18 bytes, 1 entries
usb-storage: Status code 0; transferred 18/18
usb-storage: -- transfer complete
usb-storage: Bulk data transfer result 0x0
usb-storage: Attempting to get CSW...
usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
usb-storage: Status code 0; transferred 13/13
usb-storage: -- transfer complete
usb-storage: Bulk status result = 0
usb-storage: Bulk Status S 0x53425355 T 0x530 R 0 Stat 0x0
usb-storage: -- Result from auto-sense is 0
usb-storage: -- code: 0x70, key: 0x2, ASC: 0x3a, ASCQ: 0x0
usb-storage: Not Ready: Medium not present
usb-storage: scsi cmd done, result=0x2
usb-storage: *** thread sleeping.
usb-storage: queuecommand called
usb-storage: *** thread awakened.
usb-storage: Command TEST_UNIT_READY (6 bytes)
usb-storage:  00 00 00 00 00 00
usb-storage: Bulk Command S 0x43425355 T 0x531 L 0 F 0 Trg 0 LUN 1 CL 6
usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
usb-storage: Status code 0; transferred 31/31
usb-storage: -- transfer complete
usb-storage: Bulk command transfer result=0
usb-storage: Attempting to get CSW...
usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
usb-storage: Status code 0; transferred 13/13
usb-storage: -- transfer complete
usb-storage: Bulk status result = 0
usb-storage: Bulk Status S 0x53425355 T 0x531 R 0 Stat 0x1
usb-storage: -- transport indicates command failure
usb-storage: Issuing auto-REQUEST_SENSE
usb-storage: Bulk Command S 0x43425355 T 0x532 L 18 F 128 Trg 0 LUN 1 CL 6
usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
usb-storage: Status code 0; transferred 31/31
usb-storage: -- transfer complete
usb-storage: Bulk command transfer result=0
usb-storage: usb_stor_bulk_transfer_sglist: xfer 18 bytes, 1 entries
usb-storage: Status code 0; transferred 18/18
usb-storage: -- transfer complete
usb-storage: Bulk data transfer result 0x0
usb-storage: Attempting to get CSW...
usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
usb-storage: Status code 0; transferred 13/13
usb-storage: -- transfer complete
usb-storage: Bulk status result = 0
usb-storage: Bulk Status S 0x53425355 T 0x532 R 0 Stat 0x0
usb-storage: -- Result from auto-sense is 0
usb-storage: -- code: 0x70, key: 0x2, ASC: 0x3a, ASCQ: 0x0
usb-storage: Not Ready: Medium not present
usb-storage: scsi cmd done, result=0x2
usb-storage: *** thread sleeping.
usb-storage: queuecommand called
usb-storage: *** thread awakened.
usb-storage: Command TEST_UNIT_READY (6 bytes)
usb-storage:  00 00 00 00 00 00
usb-storage: Bulk Command S 0x43425355 T 0x533 L 0 F 0 Trg 0 LUN 1 CL 6
usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
usb-storage: Status code 0; transferred 31/31
usb-storage: -- transfer complete
usb-storage: Bulk command transfer result=0
usb-storage: Attempting to get CSW...
usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
usb-storage: Status code 0; transferred 13/13
usb-storage: -- transfer complete
usb-storage: Bulk status result = 0
usb-storage: Bulk Status S 0x53425355 T 0x533 R 0 Stat 0x1
usb-storage: -- transport indicates command failure
usb-storage: Issuing auto-REQUEST_SENSE
usb-storage: Bulk Command S 0x43425355 T 0x534 L 18 F 128 Trg 0 LUN 1 CL 6
usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
usb-storage: Status code 0; transferred 31/31
usb-storage: -- transfer complete
usb-storage: Bulk command transfer result=0
usb-storage: usb_stor_bulk_transfer_sglist: xfer 18 bytes, 1 entries
usb-storage: Status code 0; transferred 18/18
usb-storage: -- transfer complete
usb-storage: Bulk data transfer result 0x0
usb-storage: Attempting to get CSW...
usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
usb-storage: Status code 0; transferred 13/13
usb-storage: -- transfer complete
usb-storage: Bulk status result = 0
usb-storage: Bulk Status S 0x53425355 T 0x534 R 0 Stat 0x0
usb-storage: -- Result from auto-sense is 0
usb-storage: -- code: 0x70, key: 0x2, ASC: 0x3a, ASCQ: 0x0
usb-storage: Not Ready: Medium not present
usb-storage: scsi cmd done, result=0x2
usb-storage: *** thread sleeping.
usb-storage: queuecommand called
usb-storage: *** thread awakened.
usb-storage: Command TEST_UNIT_READY (6 bytes)
usb-storage:  00 00 00 00 00 00
usb-storage: Bulk Command S 0x43425355 T 0x535 L 0 F 0 Trg 0 LUN 1 CL 6
usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
usb-storage: Status code 0; transferred 31/31
usb-storage: -- transfer complete
usb-storage: Bulk command transfer result=0
usb-storage: Attempting to get CSW...
usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
usb-storage: Status code 0; transferred 13/13
usb-storage: -- transfer complete
usb-storage: Bulk status result = 0
usb-storage: Bulk Status S 0x53425355 T 0x535 R 0 Stat 0x1
usb-storage: -- transport indicates command failure
usb-storage: Issuing auto-REQUEST_SENSE
usb-storage: Bulk Command S 0x43425355 T 0x536 L 18 F 128 Trg 0 LUN 1 CL 6
usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
usb-storage: Status code 0; transferred 31/31
usb-storage: -- transfer complete
usb-storage: Bulk command transfer result=0
usb-storage: usb_stor_bulk_transfer_sglist: xfer 18 bytes, 1 entries
usb-storage: Status code 0; transferred 18/18
usb-storage: -- transfer complete
usb-storage: Bulk data transfer result 0x0
usb-storage: Attempting to get CSW...
usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
usb-storage: Status code 0; transferred 13/13
usb-storage: -- transfer complete
usb-storage: Bulk status result = 0
usb-storage: Bulk Status S 0x53425355 T 0x536 R 0 Stat 0x0
usb-storage: -- Result from auto-sense is 0
usb-storage: -- code: 0x70, key: 0x2, ASC: 0x3a, ASCQ: 0x0
usb-storage: Not Ready: Medium not present
usb-storage: scsi cmd done, result=0x2
usb-storage: *** thread sleeping.
usb-storage: queuecommand called
usb-storage: *** thread awakened.
usb-storage: Command TEST_UNIT_READY (6 bytes)
usb-storage:  00 00 00 00 00 00
usb-storage: Bulk Command S 0x43425355 T 0x537 L 0 F 0 Trg 0 LUN 0 CL 6
usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
usb-storage: Status code 0; transferred 31/31
usb-storage: -- transfer complete
usb-storage: Bulk command transfer result=0
usb-storage: Attempting to get CSW...
usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
usb-storage: Status code 0; transferred 13/13
usb-storage: -- transfer complete
usb-storage: Bulk status result = 0
usb-storage: Bulk Status S 0x53425355 T 0x537 R 0 Stat 0x1
usb-storage: -- transport indicates command failure
usb-storage: Issuing auto-REQUEST_SENSE
usb-storage: Bulk Command S 0x43425355 T 0x538 L 18 F 128 Trg 0 LUN 0 CL 6
usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
usb-storage: Status code 0; transferred 31/31
usb-storage: -- transfer complete
usb-storage: Bulk command transfer result=0
usb-storage: usb_stor_bulk_transfer_sglist: xfer 18 bytes, 1 entries
usb-storage: Status code 0; transferred 18/18
usb-storage: -- transfer complete
usb-storage: Bulk data transfer result 0x0
usb-storage: Attempting to get CSW...
usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
usb-storage: Status code 0; transferred 13/13
usb-storage: -- transfer complete
usb-storage: Bulk status result = 0
usb-storage: Bulk Status S 0x53425355 T 0x538 R 0 Stat 0x0
usb-storage: -- Result from auto-sense is 0
usb-storage: -- code: 0x70, key: 0x2, ASC: 0x3a, ASCQ: 0x0
usb-storage: Not Ready: Medium not present
usb-storage: scsi cmd done, result=0x2
usb-storage: *** thread sleeping.
usb-storage: queuecommand called
usb-storage: *** thread awakened.
usb-storage: Command TEST_UNIT_READY (6 bytes)
usb-storage:  00 00 00 00 00 00
usb-storage: Bulk Command S 0x43425355 T 0x539 L 0 F 0 Trg 0 LUN 1 CL 6
usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
usb-storage: Status code 0; transferred 31/31
usb-storage: -- transfer complete
usb-storage: Bulk command transfer result=0
usb-storage: Attempting to get CSW...
usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
usb-storage: Status code 0; transferred 13/13
usb-storage: -- transfer complete
usb-storage: Bulk status result = 0
usb-storage: Bulk Status S 0x53425355 T 0x539 R 0 Stat 0x1
usb-storage: -- transport indicates command failure
usb-storage: Issuing auto-REQUEST_SENSE
usb-storage: Bulk Command S 0x43425355 T 0x53a L 18 F 128 Trg 0 LUN 1 CL 6
usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
usb-storage: Status code 0; transferred 31/31
usb-storage: -- transfer complete
usb-storage: Bulk command transfer result=0
usb-storage: usb_stor_bulk_transfer_sglist: xfer 18 bytes, 1 entries
usb-storage: Status code 0; transferred 18/18
usb-storage: -- transfer complete
usb-storage: Bulk data transfer result 0x0
usb-storage: Attempting to get CSW...
usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
usb-storage: Status code 0; transferred 13/13
usb-storage: -- transfer complete
usb-storage: Bulk status result = 0
usb-storage: Bulk Status S 0x53425355 T 0x53a R 0 Stat 0x0
usb-storage: -- Result from auto-sense is 0
usb-storage: -- code: 0x70, key: 0x2, ASC: 0x3a, ASCQ: 0x0
usb-storage: Not Ready: Medium not present
usb-storage: scsi cmd done, result=0x2
usb-storage: *** thread sleeping.
usb-storage: queuecommand called
usb-storage: *** thread awakened.
usb-storage: Command TEST_UNIT_READY (6 bytes)
usb-storage:  00 00 00 00 00 00
usb-storage: Bulk Command S 0x43425355 T 0x53b L 0 F 0 Trg 0 LUN 0 CL 6
usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
usb-storage: Status code 0; transferred 31/31
usb-storage: -- transfer complete
usb-storage: Bulk command transfer result=0
usb-storage: Attempting to get CSW...
usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
usb-storage: Status code 0; transferred 13/13
usb-storage: -- transfer complete
usb-storage: Bulk status result = 0
usb-storage: Bulk Status S 0x53425355 T 0x53b R 0 Stat 0x1
usb-storage: -- transport indicates command failure
usb-storage: Issuing auto-REQUEST_SENSE
usb-storage: Bulk Command S 0x43425355 T 0x53c L 18 F 128 Trg 0 LUN 0 CL 6
usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
usb-storage: Status code 0; transferred 31/31
usb-storage: -- transfer complete
usb-storage: Bulk command transfer result=0
usb-storage: usb_stor_bulk_transfer_sglist: xfer 18 bytes, 1 entries
usb-storage: Status code 0; transferred 18/18
usb-storage: -- transfer complete
usb-storage: Bulk data transfer result 0x0
usb-storage: Attempting to get CSW...
usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
usb-storage: Status code 0; transferred 13/13
usb-storage: -- transfer complete
usb-storage: Bulk status result = 0
usb-storage: Bulk Status S 0x53425355 T 0x53c R 0 Stat 0x0
usb-storage: -- Result from auto-sense is 0
usb-storage: -- code: 0x70, key: 0x2, ASC: 0x3a, ASCQ: 0x0
usb-storage: Not Ready: Medium not present
usb-storage: scsi cmd done, result=0x2
usb-storage: *** thread sleeping.
usb-storage: queuecommand called
usb-storage: *** thread awakened.
usb-storage: Command TEST_UNIT_READY (6 bytes)
usb-storage:  00 00 00 00 00 00
usb-storage: Bulk Command S 0x43425355 T 0x53d L 0 F 0 Trg 0 LUN 1 CL 6
usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
usb-storage: Status code 0; transferred 31/31
usb-storage: -- transfer complete
usb-storage: Bulk command transfer result=0
usb-storage: Attempting to get CSW...
usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
usb-storage: Status code 0; transferred 13/13
usb-storage: -- transfer complete
usb-storage: Bulk status result = 0
usb-storage: Bulk Status S 0x53425355 T 0x53d R 0 Stat 0x1
usb-storage: -- transport indicates command failure
usb-storage: Issuing auto-REQUEST_SENSE
usb-storage: Bulk Command S 0x43425355 T 0x53e L 18 F 128 Trg 0 LUN 1 CL 6
usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
usb-storage: Status code 0; transferred 31/31
usb-storage: -- transfer complete
usb-storage: Bulk command transfer result=0
usb-storage: usb_stor_bulk_transfer_sglist: xfer 18 bytes, 1 entries
usb-storage: Status code 0; transferred 18/18
usb-storage: -- transfer complete
usb-storage: Bulk data transfer result 0x0
usb-storage: Attempting to get CSW...
usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
usb-storage: Status code 0; transferred 13/13
usb-storage: -- transfer complete
usb-storage: Bulk status result = 0
usb-storage: Bulk Status S 0x53425355 T 0x53e R 0 Stat 0x0
usb-storage: -- Result from auto-sense is 0
usb-storage: -- code: 0x70, key: 0x2, ASC: 0x3a, ASCQ: 0x0
usb-storage: Not Ready: Medium not present
usb-storage: scsi cmd done, result=0x2
usb-storage: *** thread sleeping.
usb-storage: queuecommand called
usb-storage: *** thread awakened.
usb-storage: Command TEST_UNIT_READY (6 bytes)
usb-storage:  00 00 00 00 00 00
usb-storage: Bulk Command S 0x43425355 T 0x53f L 0 F 0 Trg 0 LUN 0 CL 6
usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
usb-storage: Status code 0; transferred 31/31
usb-storage: -- transfer complete
usb-storage: Bulk command transfer result=0
usb-storage: Attempting to get CSW...
usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
usb-storage: Status code 0; transferred 13/13
usb-storage: -- transfer complete
usb-storage: Bulk status result = 0
usb-storage: Bulk Status S 0x53425355 T 0x53f R 0 Stat 0x1
usb-storage: -- transport indicates command failure
usb-storage: Issuing auto-REQUEST_SENSE
usb-storage: Bulk Command S 0x43425355 T 0x540 L 18 F 128 Trg 0 LUN 0 CL 6
usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
usb-storage: Status code 0; transferred 31/31
usb-storage: -- transfer complete
usb-storage: Bulk command transfer result=0
usb-storage: usb_stor_bulk_transfer_sglist: xfer 18 bytes, 1 entries
usb-storage: Status code 0; transferred 18/18
usb-storage: -- transfer complete
usb-storage: Bulk data transfer result 0x0
usb-storage: Attempting to get CSW...
usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
usb-storage: Status code 0; transferred 13/13
usb-storage: -- transfer complete
usb-storage: Bulk status result = 0
usb-storage: Bulk Status S 0x53425355 T 0x540 R 0 Stat 0x0
usb-storage: -- Result from auto-sense is 0
usb-storage: -- code: 0x70, key: 0x2, ASC: 0x3a, ASCQ: 0x0
usb-storage: Not Ready: Medium not present
usb-storage: scsi cmd done, result=0x2
usb-storage: *** thread sleeping.
usb-storage: queuecommand called
usb-storage: *** thread awakened.
usb-storage: Command TEST_UNIT_READY (6 bytes)
usb-storage:  00 00 00 00 00 00
usb-storage: Bulk Command S 0x43425355 T 0x541 L 0 F 0 Trg 0 LUN 1 CL 6
usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
usb-storage: Status code 0; transferred 31/31
usb-storage: -- transfer complete
usb-storage: Bulk command transfer result=0
usb-storage: Attempting to get CSW...
usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
usb-storage: Status code 0; transferred 13/13
usb-storage: -- transfer complete
usb-storage: Bulk status result = 0
usb-storage: Bulk Status S 0x53425355 T 0x541 R 0 Stat 0x1
usb-storage: -- transport indicates command failure
usb-storage: Issuing auto-REQUEST_SENSE
usb-storage: Bulk Command S 0x43425355 T 0x542 L 18 F 128 Trg 0 LUN 1 CL 6
usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
usb-storage: Status code 0; transferred 31/31
usb-storage: -- transfer complete
usb-storage: Bulk command transfer result=0
usb-storage: usb_stor_bulk_transfer_sglist: xfer 18 bytes, 1 entries
usb-storage: Status code 0; transferred 18/18
usb-storage: -- transfer complete
usb-storage: Bulk data transfer result 0x0
usb-storage: Attempting to get CSW...
usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
usb-storage: Status code 0; transferred 13/13
usb-storage: -- transfer complete
usb-storage: Bulk status result = 0
usb-storage: Bulk Status S 0x53425355 T 0x542 R 0 Stat 0x0
usb-storage: -- Result from auto-sense is 0
usb-storage: -- code: 0x70, key: 0x2, ASC: 0x3a, ASCQ: 0x0
usb-storage: Not Ready: Medium not present
usb-storage: scsi cmd done, result=0x2
usb-storage: *** thread sleeping.
usb-storage: queuecommand called
usb-storage: *** thread awakened.
usb-storage: Command TEST_UNIT_READY (6 bytes)
usb-storage:  00 00 00 00 00 00
usb-storage: Bulk Command S 0x43425355 T 0x543 L 0 F 0 Trg 0 LUN 0 CL 6
usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
usb-storage: Status code 0; transferred 31/31
usb-storage: -- transfer complete
usb-storage: Bulk command transfer result=0
usb-storage: Attempting to get CSW...
usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
usb-storage: Status code 0; transferred 13/13
usb-storage: -- transfer complete
usb-storage: Bulk status result = 0
usb-storage: Bulk Status S 0x53425355 T 0x543 R 0 Stat 0x1
usb-storage: -- transport indicates command failure
usb-storage: Issuing auto-REQUEST_SENSE
usb-storage: Bulk Command S 0x43425355 T 0x544 L 18 F 128 Trg 0 LUN 0 CL 6
usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
usb-storage: Status code 0; transferred 31/31
usb-storage: -- transfer complete
usb-storage: Bulk command transfer result=0
usb-storage: usb_stor_bulk_transfer_sglist: xfer 18 bytes, 1 entries
usb-storage: Status code 0; transferred 18/18
usb-storage: -- transfer complete
usb-storage: Bulk data transfer result 0x0
usb-storage: Attempting to get CSW...
usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
usb-storage: Status code 0; transferred 13/13
usb-storage: -- transfer complete
usb-storage: Bulk status result = 0
usb-storage: Bulk Status S 0x53425355 T 0x544 R 0 Stat 0x0
usb-storage: -- Result from auto-sense is 0
usb-storage: -- code: 0x70, key: 0x2, ASC: 0x3a, ASCQ: 0x0
usb-storage: Not Ready: Medium not present
usb-storage: scsi cmd done, result=0x2
usb-storage: *** thread sleeping.
usb-storage: queuecommand called
usb-storage: *** thread awakened.
usb-storage: Command TEST_UNIT_READY (6 bytes)
usb-storage:  00 00 00 00 00 00
usb-storage: Bulk Command S 0x43425355 T 0x545 L 0 F 0 Trg 0 LUN 1 CL 6
usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
usb-storage: Status code 0; transferred 31/31
usb-storage: -- transfer complete
usb-storage: Bulk command transfer result=0
usb-storage: Attempting to get CSW...
usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
usb-storage: Status code 0; transferred 13/13
usb-storage: -- transfer complete
usb-storage: Bulk status result = 0
usb-storage: Bulk Status S 0x53425355 T 0x545 R 0 Stat 0x1
usb-storage: -- transport indicates command failure
usb-storage: Issuing auto-REQUEST_SENSE
usb-storage: Bulk Command S 0x43425355 T 0x546 L 18 F 128 Trg 0 LUN 1 CL 6
usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
usb-storage: Status code 0; transferred 31/31
usb-storage: -- transfer complete
usb-storage: Bulk command transfer result=0
usb-storage: usb_stor_bulk_transfer_sglist: xfer 18 bytes, 1 entries
usb-storage: Status code 0; transferred 18/18
usb-storage: -- transfer complete
usb-storage: Bulk data transfer result 0x0
usb-storage: Attempting to get CSW...
usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
usb-storage: Status code 0; transferred 13/13
usb-storage: -- transfer complete
usb-storage: Bulk status result = 0
usb-storage: Bulk Status S 0x53425355 T 0x546 R 0 Stat 0x0
usb-storage: -- Result from auto-sense is 0
usb-storage: -- code: 0x70, key: 0x2, ASC: 0x3a, ASCQ: 0x0
usb-storage: Not Ready: Medium not present
usb-storage: scsi cmd done, result=0x2
usb-storage: *** thread sleeping.
usb-storage: queuecommand called
usb-storage: *** thread awakened.
usb-storage: Command TEST_UNIT_READY (6 bytes)
usb-storage:  00 00 00 00 00 00
usb-storage: Bulk Command S 0x43425355 T 0x547 L 0 F 0 Trg 0 LUN 0 CL 6
usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
usb-storage: Status code 0; transferred 31/31
usb-storage: -- transfer complete
usb-storage: Bulk command transfer result=0
usb-storage: Attempting to get CSW...
usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
usb-storage: Status code 0; transferred 13/13
usb-storage: -- transfer complete
usb-storage: Bulk status result = 0
usb-storage: Bulk Status S 0x53425355 T 0x547 R 0 Stat 0x1
usb-storage: -- transport indicates command failure
usb-storage: Issuing auto-REQUEST_SENSE
usb-storage: Bulk Command S 0x43425355 T 0x548 L 18 F 128 Trg 0 LUN 0 CL 6
usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
usb-storage: Status code 0; transferred 31/31
usb-storage: -- transfer complete
usb-storage: Bulk command transfer result=0
usb-storage: usb_stor_bulk_transfer_sglist: xfer 18 bytes, 1 entries
usb-storage: Status code 0; transferred 18/18
usb-storage: -- transfer complete
usb-storage: Bulk data transfer result 0x0
usb-storage: Attempting to get CSW...
usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
usb-storage: Status code 0; transferred 13/13
usb-storage: -- transfer complete
usb-storage: Bulk status result = 0
usb-storage: Bulk Status S 0x53425355 T 0x548 R 0 Stat 0x0
usb-storage: -- Result from auto-sense is 0
usb-storage: -- code: 0x70, key: 0x2, ASC: 0x3a, ASCQ: 0x0
usb-storage: Not Ready: Medium not present
usb-storage: scsi cmd done, result=0x2
usb-storage: *** thread sleeping.
usb-storage: queuecommand called
usb-storage: *** thread awakened.
usb-storage: Command TEST_UNIT_READY (6 bytes)
usb-storage:  00 00 00 00 00 00
usb-storage: Bulk Command S 0x43425355 T 0x549 L 0 F 0 Trg 0 LUN 1 CL 6
usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
usb-storage: Status code 0; transferred 31/31
usb-storage: -- transfer complete
usb-storage: Bulk command transfer result=0
usb-storage: Attempting to get CSW...
usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
usb-storage: Status code 0; transferred 13/13
usb-storage: -- transfer complete
usb-storage: Bulk status result = 0
usb-storage: Bulk Status S 0x53425355 T 0x549 R 0 Stat 0x1
usb-storage: -- transport indicates command failure
usb-storage: Issuing auto-REQUEST_SENSE
usb-storage: Bulk Command S 0x43425355 T 0x54a L 18 F 128 Trg 0 LUN 1 CL 6
usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
usb-storage: Status code 0; transferred 31/31
usb-storage: -- transfer complete
usb-storage: Bulk command transfer result=0
usb-storage: usb_stor_bulk_transfer_sglist: xfer 18 bytes, 1 entries
usb-storage: Status code 0; transferred 18/18
usb-storage: -- transfer complete
usb-storage: Bulk data transfer result 0x0
usb-storage: Attempting to get CSW...
usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
usb-storage: Status code 0; transferred 13/13
usb-storage: -- transfer complete
usb-storage: Bulk status result = 0
usb-storage: Bulk Status S 0x53425355 T 0x54a R 0 Stat 0x0
usb-storage: -- Result from auto-sense is 0
usb-storage: -- code: 0x70, key: 0x2, ASC: 0x3a, ASCQ: 0x0
usb-storage: Not Ready: Medium not present
usb-storage: scsi cmd done, result=0x2
usb-storage: *** thread sleeping.
usb-storage: queuecommand called
usb-storage: *** thread awakened.
usb-storage: Command TEST_UNIT_READY (6 bytes)
usb-storage:  00 00 00 00 00 00
usb-storage: Bulk Command S 0x43425355 T 0x54b L 0 F 0 Trg 0 LUN 0 CL 6
usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
usb-storage: Status code 0; transferred 31/31
usb-storage: -- transfer complete
usb-storage: Bulk command transfer result=0
usb-storage: Attempting to get CSW...
usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
usb-storage: Status code 0; transferred 13/13
usb-storage: -- transfer complete
usb-storage: Bulk status result = 0
usb-storage: Bulk Status S 0x53425355 T 0x54b R 0 Stat 0x1
usb-storage: -- transport indicates command failure
usb-storage: Issuing auto-REQUEST_SENSE
usb-storage: Bulk Command S 0x43425355 T 0x54c L 18 F 128 Trg 0 LUN 0 CL 6
usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
usb-storage: Status code 0; transferred 31/31
usb-storage: -- transfer complete
usb-storage: Bulk command transfer result=0
usb-storage: usb_stor_bulk_transfer_sglist: xfer 18 bytes, 1 entries
usb-storage: Status code 0; transferred 18/18
usb-storage: -- transfer complete
usb-storage: Bulk data transfer result 0x0
usb-storage: Attempting to get CSW...
usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
usb-storage: Status code 0; transferred 13/13
usb-storage: -- transfer complete
usb-storage: Bulk status result = 0
usb-storage: Bulk Status S 0x53425355 T 0x54c R 0 Stat 0x0
usb-storage: -- Result from auto-sense is 0
usb-storage: -- code: 0x70, key: 0x2, ASC: 0x3a, ASCQ: 0x0
usb-storage: Not Ready: Medium not present
usb-storage: scsi cmd done, result=0x2
usb-storage: *** thread sleeping.
usb-storage: queuecommand called
usb-storage: *** thread awakened.
usb-storage: Command TEST_UNIT_READY (6 bytes)
usb-storage:  00 00 00 00 00 00
usb-storage: Bulk Command S 0x43425355 T 0x54d L 0 F 0 Trg 0 LUN 1 CL 6
usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
usb-storage: Status code 0; transferred 31/31
usb-storage: -- transfer complete
usb-storage: Bulk command transfer result=0
usb-storage: Attempting to get CSW...
usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
usb-storage: Status code 0; transferred 13/13
usb-storage: -- transfer complete
usb-storage: Bulk status result = 0
usb-storage: Bulk Status S 0x53425355 T 0x54d R 0 Stat 0x1
usb-storage: -- transport indicates command failure
usb-storage: Issuing auto-REQUEST_SENSE
usb-storage: Bulk Command S 0x43425355 T 0x54e L 18 F 128 Trg 0 LUN 1 CL 6
usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
usb-storage: Status code 0; transferred 31/31
usb-storage: -- transfer complete
usb-storage: Bulk command transfer result=0
usb-storage: usb_stor_bulk_transfer_sglist: xfer 18 bytes, 1 entries
usb-storage: Status code 0; transferred 18/18
usb-storage: -- transfer complete
usb-storage: Bulk data transfer result 0x0
usb-storage: Attempting to get CSW...
usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
usb-storage: Status code 0; transferred 13/13
usb-storage: -- transfer complete
usb-storage: Bulk status result = 0
usb-storage: Bulk Status S 0x53425355 T 0x54e R 0 Stat 0x0
usb-storage: -- Result from auto-sense is 0
usb-storage: -- code: 0x70, key: 0x2, ASC: 0x3a, ASCQ: 0x0
usb-storage: Not Ready: Medium not present
usb-storage: scsi cmd done, result=0x2
usb-storage: *** thread sleeping.
usb-storage: queuecommand called
usb-storage: *** thread awakened.
usb-storage: Command TEST_UNIT_READY (6 bytes)
usb-storage:  00 00 00 00 00 00
usb-storage: Bulk Command S 0x43425355 T 0x54f L 0 F 0 Trg 0 LUN 0 CL 6
usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
usb-storage: Status code 0; transferred 31/31
usb-storage: -- transfer complete
usb-storage: Bulk command transfer result=0
usb-storage: Attempting to get CSW...
usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
usb-storage: Status code 0; transferred 13/13
usb-storage: -- transfer complete
usb-storage: Bulk status result = 0
usb-storage: Bulk Status S 0x53425355 T 0x54f R 0 Stat 0x1
usb-storage: -- transport indicates command failure
usb-storage: Issuing auto-REQUEST_SENSE
usb-storage: Bulk Command S 0x43425355 T 0x550 L 18 F 128 Trg 0 LUN 0 CL 6
usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
usb-storage: Status code 0; transferred 31/31
usb-storage: -- transfer complete
usb-storage: Bulk command transfer result=0
usb-storage: usb_stor_bulk_transfer_sglist: xfer 18 bytes, 1 entries
usb-storage: Status code 0; transferred 18/18
usb-storage: -- transfer complete
usb-storage: Bulk data transfer result 0x0
usb-storage: Attempting to get CSW...
usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
usb-storage: Status code 0; transferred 13/13
usb-storage: -- transfer complete
usb-storage: Bulk status result = 0
usb-storage: Bulk Status S 0x53425355 T 0x550 R 0 Stat 0x0
usb-storage: -- Result from auto-sense is 0
usb-storage: -- code: 0x70, key: 0x2, ASC: 0x3a, ASCQ: 0x0
usb-storage: Not Ready: Medium not present
usb-storage: scsi cmd done, result=0x2
usb-storage: *** thread sleeping.
usb-storage: queuecommand called
usb-storage: *** thread awakened.
usb-storage: Command TEST_UNIT_READY (6 bytes)
usb-storage:  00 00 00 00 00 00
usb-storage: Bulk Command S 0x43425355 T 0x551 L 0 F 0 Trg 0 LUN 1 CL 6
usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
usb-storage: Status code 0; transferred 31/31
usb-storage: -- transfer complete
usb-storage: Bulk command transfer result=0
usb-storage: Attempting to get CSW...
usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
usb-storage: Status code 0; transferred 13/13
usb-storage: -- transfer complete
usb-storage: Bulk status result = 0
usb-storage: Bulk Status S 0x53425355 T 0x551 R 0 Stat 0x1
usb-storage: -- transport indicates command failure
usb-storage: Issuing auto-REQUEST_SENSE
usb-storage: Bulk Command S 0x43425355 T 0x552 L 18 F 128 Trg 0 LUN 1 CL 6
usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
usb-storage: Status code 0; transferred 31/31
usb-storage: -- transfer complete
usb-storage: Bulk command transfer result=0
usb-storage: usb_stor_bulk_transfer_sglist: xfer 18 bytes, 1 entries
usb-storage: Status code 0; transferred 18/18
usb-storage: -- transfer complete
usb-storage: Bulk data transfer result 0x0
usb-storage: Attempting to get CSW...
usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
usb-storage: Status code 0; transferred 13/13
usb-storage: -- transfer complete
usb-storage: Bulk status result = 0
usb-storage: Bulk Status S 0x53425355 T 0x552 R 0 Stat 0x0
usb-storage: -- Result from auto-sense is 0
usb-storage: -- code: 0x70, key: 0x2, ASC: 0x3a, ASCQ: 0x0
usb-storage: Not Ready: Medium not present
usb-storage: scsi cmd done, result=0x2
usb-storage: *** thread sleeping.
usb-storage: queuecommand called
usb-storage: *** thread awakened.
usb-storage: Command TEST_UNIT_READY (6 bytes)
usb-storage:  00 00 00 00 00 00
usb-storage: Bulk Command S 0x43425355 T 0x553 L 0 F 0 Trg 0 LUN 0 CL 6
usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
usb-storage: Status code 0; transferred 31/31
usb-storage: -- transfer complete
usb-storage: Bulk command transfer result=0
usb-storage: Attempting to get CSW...
usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
usb-storage: Status code 0; transferred 13/13
usb-storage: -- transfer complete
usb-storage: Bulk status result = 0
usb-storage: Bulk Status S 0x53425355 T 0x553 R 0 Stat 0x1
usb-storage: -- transport indicates command failure
usb-storage: Issuing auto-REQUEST_SENSE
usb-storage: Bulk Command S 0x43425355 T 0x554 L 18 F 128 Trg 0 LUN 0 CL 6
usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
usb-storage: Status code 0; transferred 31/31
usb-storage: -- transfer complete
usb-storage: Bulk command transfer result=0
usb-storage: usb_stor_bulk_transfer_sglist: xfer 18 bytes, 1 entries
usb-storage: Status code 0; transferred 18/18
usb-storage: -- transfer complete
usb-storage: Bulk data transfer result 0x0
usb-storage: Attempting to get CSW...
usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
usb-storage: Status code 0; transferred 13/13
usb-storage: -- transfer complete
usb-storage: Bulk status result = 0
usb-storage: Bulk Status S 0x53425355 T 0x554 R 0 Stat 0x0
usb-storage: -- Result from auto-sense is 0
usb-storage: -- code: 0x70, key: 0x2, ASC: 0x3a, ASCQ: 0x0
usb-storage: Not Ready: Medium not present
usb-storage: scsi cmd done, result=0x2
usb-storage: *** thread sleeping.
usb-storage: queuecommand called
usb-storage: *** thread awakened.
usb-storage: Command TEST_UNIT_READY (6 bytes)
usb-storage:  00 00 00 00 00 00
usb-storage: Bulk Command S 0x43425355 T 0x555 L 0 F 0 Trg 0 LUN 0 CL 6
usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
usb-storage: Status code 0; transferred 31/31
usb-storage: -- transfer complete
usb-storage: Bulk command transfer result=0
usb-storage: Attempting to get CSW...
usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
usb-storage: Status code 0; transferred 13/13
usb-storage: -- transfer complete
usb-storage: Bulk status result = 0
usb-storage: Bulk Status S 0x53425355 T 0x555 R 0 Stat 0x1
usb-storage: -- transport indicates command failure
usb-storage: Issuing auto-REQUEST_SENSE
usb-storage: Bulk Command S 0x43425355 T 0x556 L 18 F 128 Trg 0 LUN 0 CL 6
usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
usb-storage: Status code 0; transferred 31/31
usb-storage: -- transfer complete
usb-storage: Bulk command transfer result=0
usb-storage: usb_stor_bulk_transfer_sglist: xfer 18 bytes, 1 entries
usb-storage: Status code 0; transferred 18/18
usb-storage: -- transfer complete
usb-storage: Bulk data transfer result 0x0
usb-storage: Attempting to get CSW...
usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
usb-storage: Status code 0; transferred 13/13
usb-storage: -- transfer complete
usb-storage: Bulk status result = 0
usb-storage: Bulk Status S 0x53425355 T 0x556 R 0 Stat 0x0
usb-storage: -- Result from auto-sense is 0
usb-storage: -- code: 0x70, key: 0x2, ASC: 0x3a, ASCQ: 0x0
usb-storage: Not Ready: Medium not present
usb-storage: scsi cmd done, result=0x2
usb-storage: *** thread sleeping.
usb-storage: queuecommand called
usb-storage: *** thread awakened.
usb-storage: Command TEST_UNIT_READY (6 bytes)
usb-storage:  00 00 00 00 00 00
usb-storage: Bulk Command S 0x43425355 T 0x557 L 0 F 0 Trg 0 LUN 0 CL 6
usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
usb-storage: Status code 0; transferred 31/31
usb-storage: -- transfer complete
usb-storage: Bulk command transfer result=0
usb-storage: Attempting to get CSW...
usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
usb-storage: Status code 0; transferred 13/13
usb-storage: -- transfer complete
usb-storage: Bulk status result = 0
usb-storage: Bulk Status S 0x53425355 T 0x557 R 0 Stat 0x1
usb-storage: -- transport indicates command failure
usb-storage: Issuing auto-REQUEST_SENSE
usb-storage: Bulk Command S 0x43425355 T 0x558 L 18 F 128 Trg 0 LUN 0 CL 6
usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
usb-storage: Status code 0; transferred 31/31
usb-storage: -- transfer complete
usb-storage: Bulk command transfer result=0
usb-storage: usb_stor_bulk_transfer_sglist: xfer 18 bytes, 1 entries
usb-storage: Status code 0; transferred 18/18
usb-storage: -- transfer complete
usb-storage: Bulk data transfer result 0x0
usb-storage: Attempting to get CSW...
usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
usb-storage: Status code 0; transferred 13/13
usb-storage: -- transfer complete
usb-storage: Bulk status result = 0
usb-storage: Bulk Status S 0x53425355 T 0x558 R 0 Stat 0x0
usb-storage: -- Result from auto-sense is 0
usb-storage: -- code: 0x70, key: 0x2, ASC: 0x3a, ASCQ: 0x0
usb-storage: Not Ready: Medium not present
usb-storage: scsi cmd done, result=0x2
usb-storage: *** thread sleeping.
usb-storage: queuecommand called
usb-storage: *** thread awakened.
usb-storage: Command TEST_UNIT_READY (6 bytes)
usb-storage:  00 00 00 00 00 00
usb-storage: Bulk Command S 0x43425355 T 0x559 L 0 F 0 Trg 0 LUN 1 CL 6
usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
usb-storage: Status code 0; transferred 31/31
usb-storage: -- transfer complete
usb-storage: Bulk command transfer result=0
usb-storage: Attempting to get CSW...
usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
usb-storage: Status code 0; transferred 13/13
usb-storage: -- transfer complete
usb-storage: Bulk status result = 0
usb-storage: Bulk Status S 0x53425355 T 0x559 R 0 Stat 0x1
usb-storage: -- transport indicates command failure
usb-storage: Issuing auto-REQUEST_SENSE
usb-storage: Bulk Command S 0x43425355 T 0x55a L 18 F 128 Trg 0 LUN 1 CL 6
usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
usb-storage: Status code 0; transferred 31/31
usb-storage: -- transfer complete
usb-storage: Bulk command transfer result=0
usb-storage: usb_stor_bulk_transfer_sglist: xfer 18 bytes, 1 entries
usb-storage: Status code 0; transferred 18/18
usb-storage: -- transfer complete
usb-storage: Bulk data transfer result 0x0
usb-storage: Attempting to get CSW...
usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
usb-storage: Status code 0; transferred 13/13
usb-storage: -- transfer complete
usb-storage: Bulk status result = 0
usb-storage: Bulk Status S 0x53425355 T 0x55a R 0 Stat 0x0
usb-storage: -- Result from auto-sense is 0
usb-storage: -- code: 0x70, key: 0x2, ASC: 0x3a, ASCQ: 0x0
usb-storage: Not Ready: Medium not present
usb-storage: scsi cmd done, result=0x2
usb-storage: *** thread sleeping.
usb-storage: queuecommand called
usb-storage: *** thread awakened.
usb-storage: Command TEST_UNIT_READY (6 bytes)
usb-storage:  00 00 00 00 00 00
usb-storage: Bulk Command S 0x43425355 T 0x55b L 0 F 0 Trg 0 LUN 1 CL 6
usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
usb-storage: Status code 0; transferred 31/31
usb-storage: -- transfer complete
usb-storage: Bulk command transfer result=0
usb-storage: Attempting to get CSW...
usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
usb-storage: Status code 0; transferred 13/13
usb-storage: -- transfer complete
usb-storage: Bulk status result = 0
usb-storage: Bulk Status S 0x53425355 T 0x55b R 0 Stat 0x1
usb-storage: -- transport indicates command failure
usb-storage: Issuing auto-REQUEST_SENSE
usb-storage: Bulk Command S 0x43425355 T 0x55c L 18 F 128 Trg 0 LUN 1 CL 6
usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
usb-storage: Status code 0; transferred 31/31
usb-storage: -- transfer complete
usb-storage: Bulk command transfer result=0
usb-storage: usb_stor_bulk_transfer_sglist: xfer 18 bytes, 1 entries
usb-storage: Status code 0; transferred 18/18
usb-storage: -- transfer complete
usb-storage: Bulk data transfer result 0x0
usb-storage: Attempting to get CSW...
usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
usb-storage: Status code 0; transferred 13/13
usb-storage: -- transfer complete
usb-storage: Bulk status result = 0
usb-storage: Bulk Status S 0x53425355 T 0x55c R 0 Stat 0x0
usb-storage: -- Result from auto-sense is 0
usb-storage: -- code: 0x70, key: 0x2, ASC: 0x3a, ASCQ: 0x0
usb-storage: Not Ready: Medium not present
usb-storage: scsi cmd done, result=0x2
usb-storage: *** thread sleeping.
usb-storage: queuecommand called
usb-storage: *** thread awakened.
usb-storage: Command TEST_UNIT_READY (6 bytes)
usb-storage:  00 00 00 00 00 00
usb-storage: Bulk Command S 0x43425355 T 0x55d L 0 F 0 Trg 0 LUN 1 CL 6
usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
usb-storage: Status code 0; transferred 31/31
usb-storage: -- transfer complete
usb-storage: Bulk command transfer result=0
usb-storage: Attempting to get CSW...
usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
usb-storage: Status code 0; transferred 13/13
usb-storage: -- transfer complete
usb-storage: Bulk status result = 0
usb-storage: Bulk Status S 0x53425355 T 0x55d R 0 Stat 0x1
usb-storage: -- transport indicates command failure
usb-storage: Issuing auto-REQUEST_SENSE
usb-storage: Bulk Command S 0x43425355 T 0x55e L 18 F 128 Trg 0 LUN 1 CL 6
usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
usb-storage: Status code 0; transferred 31/31
usb-storage: -- transfer complete
usb-storage: Bulk command transfer result=0
usb-storage: usb_stor_bulk_transfer_sglist: xfer 18 bytes, 1 entries
usb-storage: Status code 0; transferred 18/18
usb-storage: -- transfer complete
usb-storage: Bulk data transfer result 0x0
usb-storage: Attempting to get CSW...
usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
usb-storage: Status code 0; transferred 13/13
usb-storage: -- transfer complete
usb-storage: Bulk status result = 0
usb-storage: Bulk Status S 0x53425355 T 0x55e R 0 Stat 0x0
usb-storage: -- Result from auto-sense is 0
usb-storage: -- code: 0x70, key: 0x2, ASC: 0x3a, ASCQ: 0x0
usb-storage: Not Ready: Medium not present
usb-storage: scsi cmd done, result=0x2
usb-storage: *** thread sleeping.
usb-storage: queuecommand called
usb-storage: *** thread awakened.
usb-storage: Command TEST_UNIT_READY (6 bytes)
usb-storage:  00 00 00 00 00 00
usb-storage: Bulk Command S 0x43425355 T 0x55f L 0 F 0 Trg 0 LUN 1 CL 6
usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
usb-storage: Status code 0; transferred 31/31
usb-storage: -- transfer complete
usb-storage: Bulk command transfer result=0
usb-storage: Attempting to get CSW...
usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
usb-storage: Status code 0; transferred 13/13
usb-storage: -- transfer complete
usb-storage: Bulk status result = 0
usb-storage: Bulk Status S 0x53425355 T 0x55f R 0 Stat 0x1
usb-storage: -- transport indicates command failure
usb-storage: Issuing auto-REQUEST_SENSE
usb-storage: Bulk Command S 0x43425355 T 0x560 L 18 F 128 Trg 0 LUN 1 CL 6
usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
usb-storage: Status code 0; transferred 31/31
usb-storage: -- transfer complete
usb-storage: Bulk command transfer result=0
usb-storage: usb_stor_bulk_transfer_sglist: xfer 18 bytes, 1 entries
usb-storage: Status code 0; transferred 18/18
usb-storage: -- transfer complete
usb-storage: Bulk data transfer result 0x0
usb-storage: Attempting to get CSW...
usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
usb-storage: Status code 0; transferred 13/13
usb-storage: -- transfer complete
usb-storage: Bulk status result = 0
usb-storage: Bulk Status S 0x53425355 T 0x560 R 0 Stat 0x0
usb-storage: -- Result from auto-sense is 0
usb-storage: -- code: 0x70, key: 0x2, ASC: 0x3a, ASCQ: 0x0
usb-storage: Not Ready: Medium not present
usb-storage: scsi cmd done, result=0x2
usb-storage: *** thread sleeping.
usb-storage: queuecommand called
usb-storage: *** thread awakened.
usb-storage: Command TEST_UNIT_READY (6 bytes)
usb-storage:  00 00 00 00 00 00
usb-storage: Bulk Command S 0x43425355 T 0x561 L 0 F 0 Trg 0 LUN 0 CL 6
usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
usb-storage: Status code 0; transferred 31/31
usb-storage: -- transfer complete
usb-storage: Bulk command transfer result=0
usb-storage: Attempting to get CSW...
usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
usb-storage: Status code 0; transferred 13/13
usb-storage: -- transfer complete
usb-storage: Bulk status result = 0
usb-storage: Bulk Status S 0x53425355 T 0x561 R 0 Stat 0x1
usb-storage: -- transport indicates command failure
usb-storage: Issuing auto-REQUEST_SENSE
usb-storage: Bulk Command S 0x43425355 T 0x562 L 18 F 128 Trg 0 LUN 0 CL 6
usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
usb-storage: Status code 0; transferred 31/31
usb-storage: -- transfer complete
usb-storage: Bulk command transfer result=0
usb-storage: usb_stor_bulk_transfer_sglist: xfer 18 bytes, 1 entries
usb-storage: Status code 0; transferred 18/18
usb-storage: -- transfer complete
usb-storage: Bulk data transfer result 0x0
usb-storage: Attempting to get CSW...
usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
usb-storage: Status code 0; transferred 13/13
usb-storage: -- transfer complete
usb-storage: Bulk status result = 0
usb-storage: Bulk Status S 0x53425355 T 0x562 R 0 Stat 0x0
usb-storage: -- Result from auto-sense is 0
usb-storage: -- code: 0x70, key: 0x2, ASC: 0x3a, ASCQ: 0x0
usb-storage: Not Ready: Medium not present
usb-storage: scsi cmd done, result=0x2
usb-storage: *** thread sleeping.
usb-storage: queuecommand called
usb-storage: *** thread awakened.
usb-storage: Command TEST_UNIT_READY (6 bytes)
usb-storage:  00 00 00 00 00 00
usb-storage: Bulk Command S 0x43425355 T 0x563 L 0 F 0 Trg 0 LUN 0 CL 6
usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
usb-storage: Status code 0; transferred 31/31
usb-storage: -- transfer complete
usb-storage: Bulk command transfer result=0
usb-storage: Attempting to get CSW...
usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
usb-storage: Status code 0; transferred 13/13
usb-storage: -- transfer complete
usb-storage: Bulk status result = 0
usb-storage: Bulk Status S 0x53425355 T 0x563 R 0 Stat 0x1
usb-storage: -- transport indicates command failure
usb-storage: Issuing auto-REQUEST_SENSE
usb-storage: Bulk Command S 0x43425355 T 0x564 L 18 F 128 Trg 0 LUN 0 CL 6
usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
usb-storage: Status code 0; transferred 31/31
usb-storage: -- transfer complete
usb-storage: Bulk command transfer result=0
usb-storage: usb_stor_bulk_transfer_sglist: xfer 18 bytes, 1 entries
usb-storage: Status code 0; transferred 18/18
usb-storage: -- transfer complete
usb-storage: Bulk data transfer result 0x0
usb-storage: Attempting to get CSW...
usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
usb-storage: Status code 0; transferred 13/13
usb-storage: -- transfer complete
usb-storage: Bulk status result = 0
usb-storage: Bulk Status S 0x53425355 T 0x564 R 0 Stat 0x0
usb-storage: -- Result from auto-sense is 0
usb-storage: -- code: 0x70, key: 0x2, ASC: 0x3a, ASCQ: 0x0
usb-storage: Not Ready: Medium not present
usb-storage: scsi cmd done, result=0x2
usb-storage: *** thread sleeping.
usb-storage: queuecommand called
usb-storage: *** thread awakened.
usb-storage: Command TEST_UNIT_READY (6 bytes)
usb-storage:  00 00 00 00 00 00
usb-storage: Bulk Command S 0x43425355 T 0x565 L 0 F 0 Trg 0 LUN 0 CL 6
usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
usb-storage: Status code 0; transferred 31/31
usb-storage: -- transfer complete
usb-storage: Bulk command transfer result=0
usb-storage: Attempting to get CSW...
usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
usb-storage: Status code 0; transferred 13/13
usb-storage: -- transfer complete
usb-storage: Bulk status result = 0
usb-storage: Bulk Status S 0x53425355 T 0x565 R 0 Stat 0x1
usb-storage: -- transport indicates command failure
usb-storage: Issuing auto-REQUEST_SENSE
usb-storage: Bulk Command S 0x43425355 T 0x566 L 18 F 128 Trg 0 LUN 0 CL 6
usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
usb-storage: Status code 0; transferred 31/31
usb-storage: -- transfer complete
usb-storage: Bulk command transfer result=0
usb-storage: usb_stor_bulk_transfer_sglist: xfer 18 bytes, 1 entries
usb-storage: Status code 0; transferred 18/18
usb-storage: -- transfer complete
usb-storage: Bulk data transfer result 0x0
usb-storage: Attempting to get CSW...
usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
usb-storage: Status code 0; transferred 13/13
usb-storage: -- transfer complete
usb-storage: Bulk status result = 0
usb-storage: Bulk Status S 0x53425355 T 0x566 R 0 Stat 0x0
usb-storage: -- Result from auto-sense is 0
usb-storage: -- code: 0x70, key: 0x2, ASC: 0x3a, ASCQ: 0x0
usb-storage: Not Ready: Medium not present
usb-storage: scsi cmd done, result=0x2
usb-storage: *** thread sleeping.
usb-storage: queuecommand called
usb-storage: *** thread awakened.
usb-storage: Command TEST_UNIT_READY (6 bytes)
usb-storage:  00 00 00 00 00 00
usb-storage: Bulk Command S 0x43425355 T 0x567 L 0 F 0 Trg 0 LUN 1 CL 6
usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
usb-storage: Status code 0; transferred 31/31
usb-storage: -- transfer complete
usb-storage: Bulk command transfer result=0
usb-storage: Attempting to get CSW...
usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
usb-storage: Status code 0; transferred 13/13
usb-storage: -- transfer complete
usb-storage: Bulk status result = 0
usb-storage: Bulk Status S 0x53425355 T 0x567 R 0 Stat 0x1
usb-storage: -- transport indicates command failure
usb-storage: Issuing auto-REQUEST_SENSE
usb-storage: Bulk Command S 0x43425355 T 0x568 L 18 F 128 Trg 0 LUN 1 CL 6
usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
usb-storage: Status code 0; transferred 31/31
usb-storage: -- transfer complete
usb-storage: Bulk command transfer result=0
usb-storage: usb_stor_bulk_transfer_sglist: xfer 18 bytes, 1 entries
usb-storage: Status code 0; transferred 18/18
usb-storage: -- transfer complete
usb-storage: Bulk data transfer result 0x0
usb-storage: Attempting to get CSW...
usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
usb-storage: Status code 0; transferred 13/13
usb-storage: -- transfer complete
usb-storage: Bulk status result = 0
usb-storage: Bulk Status S 0x53425355 T 0x568 R 0 Stat 0x0
usb-storage: -- Result from auto-sense is 0
usb-storage: -- code: 0x70, key: 0x2, ASC: 0x3a, ASCQ: 0x0
usb-storage: Not Ready: Medium not present
usb-storage: scsi cmd done, result=0x2
usb-storage: *** thread sleeping.
usb-storage: queuecommand called
usb-storage: *** thread awakened.
usb-storage: Command TEST_UNIT_READY (6 bytes)
usb-storage:  00 00 00 00 00 00
usb-storage: Bulk Command S 0x43425355 T 0x569 L 0 F 0 Trg 0 LUN 0 CL 6
usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
usb-storage: Status code 0; transferred 31/31
usb-storage: -- transfer complete
usb-storage: Bulk command transfer result=0
usb-storage: Attempting to get CSW...
usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
usb-storage: Status code 0; transferred 13/13
usb-storage: -- transfer complete
usb-storage: Bulk status result = 0
usb-storage: Bulk Status S 0x53425355 T 0x569 R 0 Stat 0x1
usb-storage: -- transport indicates command failure
usb-storage: Issuing auto-REQUEST_SENSE
usb-storage: Bulk Command S 0x43425355 T 0x56a L 18 F 128 Trg 0 LUN 0 CL 6
usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
usb-storage: Status code 0; transferred 31/31
usb-storage: -- transfer complete
usb-storage: Bulk command transfer result=0
usb-storage: usb_stor_bulk_transfer_sglist: xfer 18 bytes, 1 entries
usb-storage: Status code 0; transferred 18/18
usb-storage: -- transfer complete
usb-storage: Bulk data transfer result 0x0
usb-storage: Attempting to get CSW...
usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
usb-storage: Status code 0; transferred 13/13
usb-storage: -- transfer complete
usb-storage: Bulk status result = 0
usb-storage: Bulk Status S 0x53425355 T 0x56a R 0 Stat 0x0
usb-storage: -- Result from auto-sense is 0
usb-storage: -- code: 0x70, key: 0x2, ASC: 0x3a, ASCQ: 0x0
usb-storage: Not Ready: Medium not present
usb-storage: scsi cmd done, result=0x2
usb-storage: *** thread sleeping.
usb-storage: queuecommand called
usb-storage: *** thread awakened.
usb-storage: Command TEST_UNIT_READY (6 bytes)
usb-storage:  00 00 00 00 00 00
usb-storage: Bulk Command S 0x43425355 T 0x56b L 0 F 0 Trg 0 LUN 1 CL 6
usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
usb-storage: Status code 0; transferred 31/31
usb-storage: -- transfer complete
usb-storage: Bulk command transfer result=0
usb-storage: Attempting to get CSW...
usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
usb-storage: Status code 0; transferred 13/13
usb-storage: -- transfer complete
usb-storage: Bulk status result = 0
usb-storage: Bulk Status S 0x53425355 T 0x56b R 0 Stat 0x1
usb-storage: -- transport indicates command failure
usb-storage: Issuing auto-REQUEST_SENSE
usb-storage: Bulk Command S 0x43425355 T 0x56c L 18 F 128 Trg 0 LUN 1 CL 6
usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
usb-storage: Status code 0; transferred 31/31
usb-storage: -- transfer complete
usb-storage: Bulk command transfer result=0
usb-storage: usb_stor_bulk_transfer_sglist: xfer 18 bytes, 1 entries
usb-storage: Status code 0; transferred 18/18
usb-storage: -- transfer complete
usb-storage: Bulk data transfer result 0x0
usb-storage: Attempting to get CSW...
usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
usb-storage: Status code 0; transferred 13/13
usb-storage: -- transfer complete
usb-storage: Bulk status result = 0
usb-storage: Bulk Status S 0x53425355 T 0x56c R 0 Stat 0x0
usb-storage: -- Result from auto-sense is 0
usb-storage: -- code: 0x70, key: 0x2, ASC: 0x3a, ASCQ: 0x0
usb-storage: Not Ready: Medium not present
usb-storage: scsi cmd done, result=0x2
usb-storage: *** thread sleeping.
usb-storage: queuecommand called
usb-storage: *** thread awakened.
usb-storage: Command TEST_UNIT_READY (6 bytes)
usb-storage:  00 00 00 00 00 00
usb-storage: Bulk Command S 0x43425355 T 0x56d L 0 F 0 Trg 0 LUN 1 CL 6
usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
usb-storage: Status code 0; transferred 31/31
usb-storage: -- transfer complete
usb-storage: Bulk command transfer result=0
usb-storage: Attempting to get CSW...
usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
usb-storage: Status code 0; transferred 13/13
usb-storage: -- transfer complete
usb-storage: Bulk status result = 0
usb-storage: Bulk Status S 0x53425355 T 0x56d R 0 Stat 0x1
usb-storage: -- transport indicates command failure
usb-storage: Issuing auto-REQUEST_SENSE
usb-storage: Bulk Command S 0x43425355 T 0x56e L 18 F 128 Trg 0 LUN 1 CL 6
usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
usb-storage: Status code 0; transferred 31/31
usb-storage: -- transfer complete
usb-storage: Bulk command transfer result=0
usb-storage: usb_stor_bulk_transfer_sglist: xfer 18 bytes, 1 entries
usb-storage: Status code 0; transferred 18/18
usb-storage: -- transfer complete
usb-storage: Bulk data transfer result 0x0
usb-storage: Attempting to get CSW...
usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
usb-storage: Status code 0; transferred 13/13
usb-storage: -- transfer complete
usb-storage: Bulk status result = 0
usb-storage: Bulk Status S 0x53425355 T 0x56e R 0 Stat 0x0
usb-storage: -- Result from auto-sense is 0
usb-storage: -- code: 0x70, key: 0x2, ASC: 0x3a, ASCQ: 0x0
usb-storage: Not Ready: Medium not present
usb-storage: scsi cmd done, result=0x2
usb-storage: *** thread sleeping.
usb-storage: queuecommand called
usb-storage: *** thread awakened.
usb-storage: Command TEST_UNIT_READY (6 bytes)
usb-storage:  00 00 00 00 00 00
usb-storage: Bulk Command S 0x43425355 T 0x56f L 0 F 0 Trg 0 LUN 0 CL 6
usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
usb-storage: Status code 0; transferred 31/31
usb-storage: -- transfer complete
usb-storage: Bulk command transfer result=0
usb-storage: Attempting to get CSW...
usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
usb-storage: Status code 0; transferred 13/13
usb-storage: -- transfer complete
usb-storage: Bulk status result = 0
usb-storage: Bulk Status S 0x53425355 T 0x56f R 0 Stat 0x1
usb-storage: -- transport indicates command failure
usb-storage: Issuing auto-REQUEST_SENSE
usb-storage: Bulk Command S 0x43425355 T 0x570 L 18 F 128 Trg 0 LUN 0 CL 6
usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
usb-storage: Status code 0; transferred 31/31
usb-storage: -- transfer complete
usb-storage: Bulk command transfer result=0
usb-storage: usb_stor_bulk_transfer_sglist: xfer 18 bytes, 1 entries
usb-storage: Status code 0; transferred 18/18
usb-storage: -- transfer complete
usb-storage: Bulk data transfer result 0x0
usb-storage: Attempting to get CSW...
usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
usb-storage: Status code 0; transferred 13/13
usb-storage: -- transfer complete
usb-storage: Bulk status result = 0
usb-storage: Bulk Status S 0x53425355 T 0x570 R 0 Stat 0x0
usb-storage: -- Result from auto-sense is 0
usb-storage: -- code: 0x70, key: 0x2, ASC: 0x3a, ASCQ: 0x0
usb-storage: Not Ready: Medium not present
usb-storage: scsi cmd done, result=0x2
usb-storage: *** thread sleeping.
usb-storage: queuecommand called
usb-storage: *** thread awakened.
usb-storage: Command TEST_UNIT_READY (6 bytes)
usb-storage:  00 00 00 00 00 00
usb-storage: Bulk Command S 0x43425355 T 0x571 L 0 F 0 Trg 0 LUN 1 CL 6
usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
usb-storage: Status code 0; transferred 31/31
usb-storage: -- transfer complete
usb-storage: Bulk command transfer result=0
usb-storage: Attempting to get CSW...
usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
usb-storage: Status code 0; transferred 13/13
usb-storage: -- transfer complete
usb-storage: Bulk status result = 0
usb-storage: Bulk Status S 0x53425355 T 0x571 R 0 Stat 0x1
usb-storage: -- transport indicates command failure
usb-storage: Issuing auto-REQUEST_SENSE
usb-storage: Bulk Command S 0x43425355 T 0x572 L 18 F 128 Trg 0 LUN 1 CL 6
usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
usb-storage: Status code 0; transferred 31/31
usb-storage: -- transfer complete
usb-storage: Bulk command transfer result=0
usb-storage: usb_stor_bulk_transfer_sglist: xfer 18 bytes, 1 entries
usb-storage: Status code 0; transferred 18/18
usb-storage: -- transfer complete
usb-storage: Bulk data transfer result 0x0
usb-storage: Attempting to get CSW...
usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
usb-storage: Status code 0; transferred 13/13
usb-storage: -- transfer complete
usb-storage: Bulk status result = 0
usb-storage: Bulk Status S 0x53425355 T 0x572 R 0 Stat 0x0
usb-storage: -- Result from auto-sense is 0
usb-storage: -- code: 0x70, key: 0x2, ASC: 0x3a, ASCQ: 0x0
usb-storage: Not Ready: Medium not present
usb-storage: scsi cmd done, result=0x2
usb-storage: *** thread sleeping.
usb-storage: queuecommand called
usb-storage: *** thread awakened.
usb-storage: Command TEST_UNIT_READY (6 bytes)
usb-storage:  00 00 00 00 00 00
usb-storage: Bulk Command S 0x43425355 T 0x573 L 0 F 0 Trg 0 LUN 0 CL 6
usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
usb-storage: Status code 0; transferred 31/31
usb-storage: -- transfer complete
usb-storage: Bulk command transfer result=0
usb-storage: Attempting to get CSW...
usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
usb-storage: Status code 0; transferred 13/13
usb-storage: -- transfer complete
usb-storage: Bulk status result = 0
usb-storage: Bulk Status S 0x53425355 T 0x573 R 0 Stat 0x1
usb-storage: -- transport indicates command failure
usb-storage: Issuing auto-REQUEST_SENSE
usb-storage: Bulk Command S 0x43425355 T 0x574 L 18 F 128 Trg 0 LUN 0 CL 6
usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
usb-storage: Status code 0; transferred 31/31
usb-storage: -- transfer complete
usb-storage: Bulk command transfer result=0
usb-storage: usb_stor_bulk_transfer_sglist: xfer 18 bytes, 1 entries
usb-storage: Status code 0; transferred 18/18
usb-storage: -- transfer complete
usb-storage: Bulk data transfer result 0x0
usb-storage: Attempting to get CSW...
usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
usb-storage: Status code 0; transferred 13/13
usb-storage: -- transfer complete
usb-storage: Bulk status result = 0
usb-storage: Bulk Status S 0x53425355 T 0x574 R 0 Stat 0x0
usb-storage: -- Result from auto-sense is 0
usb-storage: -- code: 0x70, key: 0x2, ASC: 0x3a, ASCQ: 0x0
usb-storage: Not Ready: Medium not present
usb-storage: scsi cmd done, result=0x2
usb-storage: *** thread sleeping.
usb-storage: queuecommand called
usb-storage: *** thread awakened.
usb-storage: Command TEST_UNIT_READY (6 bytes)
usb-storage:  00 00 00 00 00 00
usb-storage: Bulk Command S 0x43425355 T 0x575 L 0 F 0 Trg 0 LUN 0 CL 6
usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
usb-storage: Status code 0; transferred 31/31
usb-storage: -- transfer complete
usb-storage: Bulk command transfer result=0
usb-storage: Attempting to get CSW...
usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
usb-storage: Status code 0; transferred 13/13
usb-storage: -- transfer complete
usb-storage: Bulk status result = 0
usb-storage: Bulk Status S 0x53425355 T 0x575 R 0 Stat 0x1
usb-storage: -- transport indicates command failure
usb-storage: Issuing auto-REQUEST_SENSE
usb-storage: Bulk Command S 0x43425355 T 0x576 L 18 F 128 Trg 0 LUN 0 CL 6
usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
usb-storage: Status code 0; transferred 31/31
usb-storage: -- transfer complete
usb-storage: Bulk command transfer result=0
usb-storage: usb_stor_bulk_transfer_sglist: xfer 18 bytes, 1 entries
usb-storage: Status code 0; transferred 18/18
usb-storage: -- transfer complete
usb-storage: Bulk data transfer result 0x0
usb-storage: Attempting to get CSW...
usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
usb-storage: Status code 0; transferred 13/13
usb-storage: -- transfer complete
usb-storage: Bulk status result = 0
usb-storage: Bulk Status S 0x53425355 T 0x576 R 0 Stat 0x0
usb-storage: -- Result from auto-sense is 0
usb-storage: -- code: 0x70, key: 0x2, ASC: 0x3a, ASCQ: 0x0
usb-storage: Not Ready: Medium not present
usb-storage: scsi cmd done, result=0x2
usb-storage: *** thread sleeping.
usb-storage: queuecommand called
usb-storage: *** thread awakened.
usb-storage: Command TEST_UNIT_READY (6 bytes)
usb-storage:  00 00 00 00 00 00
usb-storage: Bulk Command S 0x43425355 T 0x577 L 0 F 0 Trg 0 LUN 1 CL 6
usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
usb-storage: Status code 0; transferred 31/31
usb-storage: -- transfer complete
usb-storage: Bulk command transfer result=0
usb-storage: Attempting to get CSW...
usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
usb-storage: Status code 0; transferred 13/13
usb-storage: -- transfer complete
usb-storage: Bulk status result = 0
usb-storage: Bulk Status S 0x53425355 T 0x577 R 0 Stat 0x1
usb-storage: -- transport indicates command failure
usb-storage: Issuing auto-REQUEST_SENSE
usb-storage: Bulk Command S 0x43425355 T 0x578 L 18 F 128 Trg 0 LUN 1 CL 6
usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
usb-storage: Status code 0; transferred 31/31
usb-storage: -- transfer complete
usb-storage: Bulk command transfer result=0
usb-storage: usb_stor_bulk_transfer_sglist: xfer 18 bytes, 1 entries
usb-storage: Status code 0; transferred 18/18
usb-storage: -- transfer complete
usb-storage: Bulk data transfer result 0x0
usb-storage: Attempting to get CSW...
usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
usb-storage: Status code 0; transferred 13/13
usb-storage: -- transfer complete
usb-storage: Bulk status result = 0
usb-storage: Bulk Status S 0x53425355 T 0x578 R 0 Stat 0x0
usb-storage: -- Result from auto-sense is 0
usb-storage: -- code: 0x70, key: 0x2, ASC: 0x3a, ASCQ: 0x0
usb-storage: Not Ready: Medium not present
usb-storage: scsi cmd done, result=0x2
usb-storage: *** thread sleeping.
usb-storage: queuecommand called
usb-storage: *** thread awakened.
usb-storage: Command TEST_UNIT_READY (6 bytes)
usb-storage:  00 00 00 00 00 00
usb-storage: Bulk Command S 0x43425355 T 0x579 L 0 F 0 Trg 0 LUN 0 CL 6
usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
usb-storage: Status code 0; transferred 31/31
usb-storage: -- transfer complete
usb-storage: Bulk command transfer result=0
usb-storage: Attempting to get CSW...
usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
usb-storage: Status code 0; transferred 13/13
usb-storage: -- transfer complete
usb-storage: Bulk status result = 0
usb-storage: Bulk Status S 0x53425355 T 0x579 R 0 Stat 0x1
usb-storage: -- transport indicates command failure
usb-storage: Issuing auto-REQUEST_SENSE
usb-storage: Bulk Command S 0x43425355 T 0x57a L 18 F 128 Trg 0 LUN 0 CL 6
usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
usb-storage: Status code 0; transferred 31/31
usb-storage: -- transfer complete
usb-storage: Bulk command transfer result=0
usb-storage: usb_stor_bulk_transfer_sglist: xfer 18 bytes, 1 entries
usb-storage: Status code 0; transferred 18/18
usb-storage: -- transfer complete
usb-storage: Bulk data transfer result 0x0
usb-storage: Attempting to get CSW...
usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
usb-storage: Status code 0; transferred 13/13
usb-storage: -- transfer complete
usb-storage: Bulk status result = 0
usb-storage: Bulk Status S 0x53425355 T 0x57a R 0 Stat 0x0
usb-storage: -- Result from auto-sense is 0
usb-storage: -- code: 0x70, key: 0x2, ASC: 0x3a, ASCQ: 0x0
usb-storage: Not Ready: Medium not present
usb-storage: scsi cmd done, result=0x2
usb-storage: *** thread sleeping.
usb-storage: queuecommand called
usb-storage: *** thread awakened.
usb-storage: Command TEST_UNIT_READY (6 bytes)
usb-storage:  00 00 00 00 00 00
usb-storage: Bulk Command S 0x43425355 T 0x57b L 0 F 0 Trg 0 LUN 1 CL 6
usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
usb-storage: Status code 0; transferred 31/31
usb-storage: -- transfer complete
usb-storage: Bulk command transfer result=0
usb-storage: Attempting to get CSW...
usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
usb-storage: Status code 0; transferred 13/13
usb-storage: -- transfer complete
usb-storage: Bulk status result = 0
usb-storage: Bulk Status S 0x53425355 T 0x57b R 0 Stat 0x1
usb-storage: -- transport indicates command failure
usb-storage: Issuing auto-REQUEST_SENSE
usb-storage: Bulk Command S 0x43425355 T 0x57c L 18 F 128 Trg 0 LUN 1 CL 6
usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
usb-storage: Status code 0; transferred 31/31
usb-storage: -- transfer complete
usb-storage: Bulk command transfer result=0
usb-storage: usb_stor_bulk_transfer_sglist: xfer 18 bytes, 1 entries
usb-storage: Status code 0; transferred 18/18
usb-storage: -- transfer complete
usb-storage: Bulk data transfer result 0x0
usb-storage: Attempting to get CSW...
usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
usb-storage: Status code 0; transferred 13/13
usb-storage: -- transfer complete
usb-storage: Bulk status result = 0
usb-storage: Bulk Status S 0x53425355 T 0x57c R 0 Stat 0x0
usb-storage: -- Result from auto-sense is 0
usb-storage: -- code: 0x70, key: 0x2, ASC: 0x3a, ASCQ: 0x0
usb-storage: Not Ready: Medium not present
usb-storage: scsi cmd done, result=0x2
usb-storage: *** thread sleeping.
usb-storage: queuecommand called
usb-storage: *** thread awakened.
usb-storage: Command TEST_UNIT_READY (6 bytes)
usb-storage:  00 00 00 00 00 00
usb-storage: Bulk Command S 0x43425355 T 0x57d L 0 F 0 Trg 0 LUN 1 CL 6
usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
usb-storage: Status code 0; transferred 31/31
usb-storage: -- transfer complete
usb-storage: Bulk command transfer result=0
usb-storage: Attempting to get CSW...
usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
usb-storage: Status code 0; transferred 13/13
usb-storage: -- transfer complete
usb-storage: Bulk status result = 0
usb-storage: Bulk Status S 0x53425355 T 0x57d R 0 Stat 0x1
usb-storage: -- transport indicates command failure
usb-storage: Issuing auto-REQUEST_SENSE
usb-storage: Bulk Command S 0x43425355 T 0x57e L 18 F 128 Trg 0 LUN 1 CL 6
usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
usb-storage: Status code 0; transferred 31/31
usb-storage: -- transfer complete
usb-storage: Bulk command transfer result=0
usb-storage: usb_stor_bulk_transfer_sglist: xfer 18 bytes, 1 entries
usb-storage: Status code 0; transferred 18/18
usb-storage: -- transfer complete
usb-storage: Bulk data transfer result 0x0
usb-storage: Attempting to get CSW...
usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
usb-storage: Status code 0; transferred 13/13
usb-storage: -- transfer complete
usb-storage: Bulk status result = 0
usb-storage: Bulk Status S 0x53425355 T 0x57e R 0 Stat 0x0
usb-storage: -- Result from auto-sense is 0
usb-storage: -- code: 0x70, key: 0x2, ASC: 0x3a, ASCQ: 0x0
usb-storage: Not Ready: Medium not present
usb-storage: scsi cmd done, result=0x2
usb-storage: *** thread sleeping.
usb-storage: queuecommand called
usb-storage: *** thread awakened.
usb-storage: Command TEST_UNIT_READY (6 bytes)
usb-storage:  00 00 00 00 00 00
usb-storage: Bulk Command S 0x43425355 T 0x57f L 0 F 0 Trg 0 LUN 0 CL 6
usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
usb-storage: Status code 0; transferred 31/31
usb-storage: -- transfer complete
usb-storage: Bulk command transfer result=0
usb-storage: Attempting to get CSW...
usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
usb-storage: Status code 0; transferred 13/13
usb-storage: -- transfer complete
usb-storage: Bulk status result = 0
usb-storage: Bulk Status S 0x53425355 T 0x57f R 0 Stat 0x1
usb-storage: -- transport indicates command failure
usb-storage: Issuing auto-REQUEST_SENSE
usb-storage: Bulk Command S 0x43425355 T 0x580 L 18 F 128 Trg 0 LUN 0 CL 6
usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
usb-storage: Status code 0; transferred 31/31
usb-storage: -- transfer complete
usb-storage: Bulk command transfer result=0
usb-storage: usb_stor_bulk_transfer_sglist: xfer 18 bytes, 1 entries
usb-storage: Status code 0; transferred 18/18
usb-storage: -- transfer complete
usb-storage: Bulk data transfer result 0x0
usb-storage: Attempting to get CSW...
usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
usb-storage: Status code 0; transferred 13/13
usb-storage: -- transfer complete
usb-storage: Bulk status result = 0
usb-storage: Bulk Status S 0x53425355 T 0x580 R 0 Stat 0x0
usb-storage: -- Result from auto-sense is 0
usb-storage: -- code: 0x70, key: 0x2, ASC: 0x3a, ASCQ: 0x0
usb-storage: Not Ready: Medium not present
usb-storage: scsi cmd done, result=0x2
usb-storage: *** thread sleeping.
usb-storage: queuecommand called
usb-storage: *** thread awakened.
usb-storage: Command TEST_UNIT_READY (6 bytes)
usb-storage:  00 00 00 00 00 00
usb-storage: Bulk Command S 0x43425355 T 0x581 L 0 F 0 Trg 0 LUN 1 CL 6
usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
usb-storage: Status code 0; transferred 31/31
usb-storage: -- transfer complete
usb-storage: Bulk command transfer result=0
usb-storage: Attempting to get CSW...
usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
usb-storage: Status code 0; transferred 13/13
usb-storage: -- transfer complete
usb-storage: Bulk status result = 0
usb-storage: Bulk Status S 0x53425355 T 0x581 R 0 Stat 0x1
usb-storage: -- transport indicates command failure
usb-storage: Issuing auto-REQUEST_SENSE
usb-storage: Bulk Command S 0x43425355 T 0x582 L 18 F 128 Trg 0 LUN 1 CL 6
usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
usb-storage: Status code 0; transferred 31/31
usb-storage: -- transfer complete
usb-storage: Bulk command transfer result=0
usb-storage: usb_stor_bulk_transfer_sglist: xfer 18 bytes, 1 entries
usb-storage: Status code 0; transferred 18/18
usb-storage: -- transfer complete
usb-storage: Bulk data transfer result 0x0
usb-storage: Attempting to get CSW...
usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
usb-storage: Status code 0; transferred 13/13
usb-storage: -- transfer complete
usb-storage: Bulk status result = 0
usb-storage: Bulk Status S 0x53425355 T 0x582 R 0 Stat 0x0
usb-storage: -- Result from auto-sense is 0
usb-storage: -- code: 0x70, key: 0x2, ASC: 0x3a, ASCQ: 0x0
usb-storage: Not Ready: Medium not present
usb-storage: scsi cmd done, result=0x2
usb-storage: *** thread sleeping.
usb-storage: queuecommand called
usb-storage: *** thread awakened.
usb-storage: Command TEST_UNIT_READY (6 bytes)
usb-storage:  00 00 00 00 00 00
usb-storage: Bulk Command S 0x43425355 T 0x583 L 0 F 0 Trg 0 LUN 0 CL 6
usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
usb-storage: Status code 0; transferred 31/31
usb-storage: -- transfer complete
usb-storage: Bulk command transfer result=0
usb-storage: Attempting to get CSW...
usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
usb-storage: Status code 0; transferred 13/13
usb-storage: -- transfer complete
usb-storage: Bulk status result = 0
usb-storage: Bulk Status S 0x53425355 T 0x583 R 0 Stat 0x1
usb-storage: -- transport indicates command failure
usb-storage: Issuing auto-REQUEST_SENSE
usb-storage: Bulk Command S 0x43425355 T 0x584 L 18 F 128 Trg 0 LUN 0 CL 6
usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
usb-storage: Status code 0; transferred 31/31
usb-storage: -- transfer complete
usb-storage: Bulk command transfer result=0
usb-storage: usb_stor_bulk_transfer_sglist: xfer 18 bytes, 1 entries
usb-storage: Status code 0; transferred 18/18
usb-storage: -- transfer complete
usb-storage: Bulk data transfer result 0x0
usb-storage: Attempting to get CSW...
usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
usb-storage: Status code 0; transferred 13/13
usb-storage: -- transfer complete
usb-storage: Bulk status result = 0
usb-storage: Bulk Status S 0x53425355 T 0x584 R 0 Stat 0x0
usb-storage: -- Result from auto-sense is 0
usb-storage: -- code: 0x70, key: 0x2, ASC: 0x3a, ASCQ: 0x0
usb-storage: Not Ready: Medium not present
usb-storage: scsi cmd done, result=0x2
usb-storage: *** thread sleeping.
usb-storage: queuecommand called
usb-storage: *** thread awakened.
usb-storage: Command TEST_UNIT_READY (6 bytes)
usb-storage:  00 00 00 00 00 00
usb-storage: Bulk Command S 0x43425355 T 0x585 L 0 F 0 Trg 0 LUN 0 CL 6
usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
usb-storage: Status code 0; transferred 31/31
usb-storage: -- transfer complete
usb-storage: Bulk command transfer result=0
usb-storage: Attempting to get CSW...
usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
usb-storage: Status code 0; transferred 13/13
usb-storage: -- transfer complete
usb-storage: Bulk status result = 0
usb-storage: Bulk Status S 0x53425355 T 0x585 R 0 Stat 0x1
usb-storage: -- transport indicates command failure
usb-storage: Issuing auto-REQUEST_SENSE
usb-storage: Bulk Command S 0x43425355 T 0x586 L 18 F 128 Trg 0 LUN 0 CL 6
usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
usb-storage: Status code 0; transferred 31/31
usb-storage: -- transfer complete
usb-storage: Bulk command transfer result=0
usb-storage: usb_stor_bulk_transfer_sglist: xfer 18 bytes, 1 entries
usb-storage: Status code 0; transferred 18/18
usb-storage: -- transfer complete
usb-storage: Bulk data transfer result 0x0
usb-storage: Attempting to get CSW...
usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
usb-storage: Status code 0; transferred 13/13
usb-storage: -- transfer complete
usb-storage: Bulk status result = 0
usb-storage: Bulk Status S 0x53425355 T 0x586 R 0 Stat 0x0
usb-storage: -- Result from auto-sense is 0
usb-storage: -- code: 0x70, key: 0x2, ASC: 0x3a, ASCQ: 0x0
usb-storage: Not Ready: Medium not present
usb-storage: scsi cmd done, result=0x2
usb-storage: *** thread sleeping.
usb-storage: queuecommand called
usb-storage: *** thread awakened.
usb-storage: Command TEST_UNIT_READY (6 bytes)
usb-storage:  00 00 00 00 00 00
usb-storage: Bulk Command S 0x43425355 T 0x587 L 0 F 0 Trg 0 LUN 1 CL 6
usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
usb-storage: Status code 0; transferred 31/31
usb-storage: -- transfer complete
usb-storage: Bulk command transfer result=0
usb-storage: Attempting to get CSW...
usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
usb-storage: Status code 0; transferred 13/13
usb-storage: -- transfer complete
usb-storage: Bulk status result = 0
usb-storage: Bulk Status S 0x53425355 T 0x587 R 0 Stat 0x1
usb-storage: -- transport indicates command failure
usb-storage: Issuing auto-REQUEST_SENSE
usb-storage: Bulk Command S 0x43425355 T 0x588 L 18 F 128 Trg 0 LUN 1 CL 6
usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
usb-storage: Status code 0; transferred 31/31
usb-storage: -- transfer complete
usb-storage: Bulk command transfer result=0
usb-storage: usb_stor_bulk_transfer_sglist: xfer 18 bytes, 1 entries
usb-storage: Status code 0; transferred 18/18
usb-storage: -- transfer complete
usb-storage: Bulk data transfer result 0x0
usb-storage: Attempting to get CSW...
usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
usb-storage: Status code 0; transferred 13/13
usb-storage: -- transfer complete
usb-storage: Bulk status result = 0
usb-storage: Bulk Status S 0x53425355 T 0x588 R 0 Stat 0x0
usb-storage: -- Result from auto-sense is 0
usb-storage: -- code: 0x70, key: 0x2, ASC: 0x3a, ASCQ: 0x0
usb-storage: Not Ready: Medium not present
usb-storage: scsi cmd done, result=0x2
usb-storage: *** thread sleeping.
usb-storage: queuecommand called
usb-storage: *** thread awakened.
usb-storage: Command TEST_UNIT_READY (6 bytes)
usb-storage:  00 00 00 00 00 00
usb-storage: Bulk Command S 0x43425355 T 0x589 L 0 F 0 Trg 0 LUN 0 CL 6
usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
usb-storage: Status code 0; transferred 31/31
usb-storage: -- transfer complete
usb-storage: Bulk command transfer result=0
usb-storage: Attempting to get CSW...
usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
usb-storage: Status code 0; transferred 13/13
usb-storage: -- transfer complete
usb-storage: Bulk status result = 0
usb-storage: Bulk Status S 0x53425355 T 0x589 R 0 Stat 0x1
usb-storage: -- transport indicates command failure
usb-storage: Issuing auto-REQUEST_SENSE
usb-storage: Bulk Command S 0x43425355 T 0x58a L 18 F 128 Trg 0 LUN 0 CL 6
usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
usb-storage: Status code 0; transferred 31/31
usb-storage: -- transfer complete
usb-storage: Bulk command transfer result=0
usb-storage: usb_stor_bulk_transfer_sglist: xfer 18 bytes, 1 entries
usb-storage: Status code 0; transferred 18/18
usb-storage: -- transfer complete
usb-storage: Bulk data transfer result 0x0
usb-storage: Attempting to get CSW...
usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
usb-storage: Status code 0; transferred 13/13
usb-storage: -- transfer complete
usb-storage: Bulk status result = 0
usb-storage: Bulk Status S 0x53425355 T 0x58a R 0 Stat 0x0
usb-storage: -- Result from auto-sense is 0
usb-storage: -- code: 0x70, key: 0x2, ASC: 0x3a, ASCQ: 0x0
usb-storage: Not Ready: Medium not present
usb-storage: scsi cmd done, result=0x2
usb-storage: *** thread sleeping.
usb-storage: queuecommand called
usb-storage: *** thread awakened.
usb-storage: Command TEST_UNIT_READY (6 bytes)
usb-storage:  00 00 00 00 00 00
usb-storage: Bulk Command S 0x43425355 T 0x58b L 0 F 0 Trg 0 LUN 1 CL 6
usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
usb-storage: Status code 0; transferred 31/31
usb-storage: -- transfer complete
usb-storage: Bulk command transfer result=0
usb-storage: Attempting to get CSW...
usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
usb-storage: Status code 0; transferred 13/13
usb-storage: -- transfer complete
usb-storage: Bulk status result = 0
usb-storage: Bulk Status S 0x53425355 T 0x58b R 0 Stat 0x1
usb-storage: -- transport indicates command failure
usb-storage: Issuing auto-REQUEST_SENSE
usb-storage: Bulk Command S 0x43425355 T 0x58c L 18 F 128 Trg 0 LUN 1 CL 6
usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
usb-storage: Status code 0; transferred 31/31
usb-storage: -- transfer complete
usb-storage: Bulk command transfer result=0
usb-storage: usb_stor_bulk_transfer_sglist: xfer 18 bytes, 1 entries
usb-storage: Status code 0; transferred 18/18
usb-storage: -- transfer complete
usb-storage: Bulk data transfer result 0x0
usb-storage: Attempting to get CSW...
usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
usb-storage: Status code 0; transferred 13/13
usb-storage: -- transfer complete
usb-storage: Bulk status result = 0
usb-storage: Bulk Status S 0x53425355 T 0x58c R 0 Stat 0x0
usb-storage: -- Result from auto-sense is 0
usb-storage: -- code: 0x70, key: 0x2, ASC: 0x3a, ASCQ: 0x0
usb-storage: Not Ready: Medium not present
usb-storage: scsi cmd done, result=0x2
usb-storage: *** thread sleeping.
usb-storage: queuecommand called
usb-storage: *** thread awakened.
usb-storage: Command TEST_UNIT_READY (6 bytes)
usb-storage:  00 00 00 00 00 00
usb-storage: Bulk Command S 0x43425355 T 0x58d L 0 F 0 Trg 0 LUN 1 CL 6
usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
usb-storage: Status code 0; transferred 31/31
usb-storage: -- transfer complete
usb-storage: Bulk command transfer result=0
usb-storage: Attempting to get CSW...
usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
usb-storage: Status code 0; transferred 13/13
usb-storage: -- transfer complete
usb-storage: Bulk status result = 0
usb-storage: Bulk Status S 0x53425355 T 0x58d R 0 Stat 0x1
usb-storage: -- transport indicates command failure
usb-storage: Issuing auto-REQUEST_SENSE
usb-storage: Bulk Command S 0x43425355 T 0x58e L 18 F 128 Trg 0 LUN 1 CL 6
usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
usb-storage: Status code 0; transferred 31/31
usb-storage: -- transfer complete
usb-storage: Bulk command transfer result=0
usb-storage: usb_stor_bulk_transfer_sglist: xfer 18 bytes, 1 entries
usb-storage: Status code 0; transferred 18/18
usb-storage: -- transfer complete
usb-storage: Bulk data transfer result 0x0
usb-storage: Attempting to get CSW...
usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
usb-storage: Status code 0; transferred 13/13
usb-storage: -- transfer complete
usb-storage: Bulk status result = 0
usb-storage: Bulk Status S 0x53425355 T 0x58e R 0 Stat 0x0
usb-storage: -- Result from auto-sense is 0
usb-storage: -- code: 0x70, key: 0x2, ASC: 0x3a, ASCQ: 0x0
usb-storage: Not Ready: Medium not present
usb-storage: scsi cmd done, result=0x2
usb-storage: *** thread sleeping.
usb-storage: queuecommand called
usb-storage: *** thread awakened.
usb-storage: Command TEST_UNIT_READY (6 bytes)
usb-storage:  00 00 00 00 00 00
usb-storage: Bulk Command S 0x43425355 T 0x58f L 0 F 0 Trg 0 LUN 0 CL 6
usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
usb-storage: Status code 0; transferred 31/31
usb-storage: -- transfer complete
usb-storage: Bulk command transfer result=0
usb-storage: Attempting to get CSW...
usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
usb-storage: Status code 0; transferred 13/13
usb-storage: -- transfer complete
usb-storage: Bulk status result = 0
usb-storage: Bulk Status S 0x53425355 T 0x58f R 0 Stat 0x1
usb-storage: -- transport indicates command failure
usb-storage: Issuing auto-REQUEST_SENSE
usb-storage: Bulk Command S 0x43425355 T 0x590 L 18 F 128 Trg 0 LUN 0 CL 6
usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
usb-storage: Status code 0; transferred 31/31
usb-storage: -- transfer complete
usb-storage: Bulk command transfer result=0
usb-storage: usb_stor_bulk_transfer_sglist: xfer 18 bytes, 1 entries
usb-storage: Status code 0; transferred 18/18
usb-storage: -- transfer complete
usb-storage: Bulk data transfer result 0x0
usb-storage: Attempting to get CSW...
usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
usb-storage: Status code 0; transferred 13/13
usb-storage: -- transfer complete
usb-storage: Bulk status result = 0
usb-storage: Bulk Status S 0x53425355 T 0x590 R 0 Stat 0x0
usb-storage: -- Result from auto-sense is 0
usb-storage: -- code: 0x70, key: 0x2, ASC: 0x3a, ASCQ: 0x0
usb-storage: Not Ready: Medium not present
usb-storage: scsi cmd done, result=0x2
usb-storage: *** thread sleeping.
usb-storage: queuecommand called
usb-storage: *** thread awakened.
usb-storage: Command TEST_UNIT_READY (6 bytes)
usb-storage:  00 00 00 00 00 00
usb-storage: Bulk Command S 0x43425355 T 0x591 L 0 F 0 Trg 0 LUN 1 CL 6
usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
usb-storage: Status code 0; transferred 31/31
usb-storage: -- transfer complete
usb-storage: Bulk command transfer result=0
usb-storage: Attempting to get CSW...
usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
usb-storage: Status code 0; transferred 13/13
usb-storage: -- transfer complete
usb-storage: Bulk status result = 0
usb-storage: Bulk Status S 0x53425355 T 0x591 R 0 Stat 0x1
usb-storage: -- transport indicates command failure
usb-storage: Issuing auto-REQUEST_SENSE
usb-storage: Bulk Command S 0x43425355 T 0x592 L 18 F 128 Trg 0 LUN 1 CL 6
usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
usb-storage: Status code 0; transferred 31/31
usb-storage: -- transfer complete
usb-storage: Bulk command transfer result=0
usb-storage: usb_stor_bulk_transfer_sglist: xfer 18 bytes, 1 entries
usb-storage: Status code 0; transferred 18/18
usb-storage: -- transfer complete
usb-storage: Bulk data transfer result 0x0
usb-storage: Attempting to get CSW...
usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
usb-storage: Status code 0; transferred 13/13
usb-storage: -- transfer complete
usb-storage: Bulk status result = 0
usb-storage: Bulk Status S 0x53425355 T 0x592 R 0 Stat 0x0
usb-storage: -- Result from auto-sense is 0
usb-storage: -- code: 0x70, key: 0x2, ASC: 0x3a, ASCQ: 0x0
usb-storage: Not Ready: Medium not present
usb-storage: scsi cmd done, result=0x2
usb-storage: *** thread sleeping.
usb-storage: queuecommand called
usb-storage: *** thread awakened.
usb-storage: Command TEST_UNIT_READY (6 bytes)
usb-storage:  00 00 00 00 00 00
usb-storage: Bulk Command S 0x43425355 T 0x593 L 0 F 0 Trg 0 LUN 0 CL 6
usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
usb-storage: Status code 0; transferred 31/31
usb-storage: -- transfer complete
usb-storage: Bulk command transfer result=0
usb-storage: Attempting to get CSW...
usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
usb-storage: Status code 0; transferred 13/13
usb-storage: -- transfer complete
usb-storage: Bulk status result = 0
usb-storage: Bulk Status S 0x53425355 T 0x593 R 0 Stat 0x1
usb-storage: -- transport indicates command failure
usb-storage: Issuing auto-REQUEST_SENSE
usb-storage: Bulk Command S 0x43425355 T 0x594 L 18 F 128 Trg 0 LUN 0 CL 6
usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
usb-storage: Status code 0; transferred 31/31
usb-storage: -- transfer complete
usb-storage: Bulk command transfer result=0
usb-storage: usb_stor_bulk_transfer_sglist: xfer 18 bytes, 1 entries
usb-storage: Status code 0; transferred 18/18
usb-storage: -- transfer complete
usb-storage: Bulk data transfer result 0x0
usb-storage: Attempting to get CSW...
usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
usb-storage: Status code 0; transferred 13/13
usb-storage: -- transfer complete
usb-storage: Bulk status result = 0
usb-storage: Bulk Status S 0x53425355 T 0x594 R 0 Stat 0x0
usb-storage: -- Result from auto-sense is 0
usb-storage: -- code: 0x70, key: 0x2, ASC: 0x3a, ASCQ: 0x0
usb-storage: Not Ready: Medium not present
usb-storage: scsi cmd done, result=0x2
usb-storage: *** thread sleeping.
usb-storage: queuecommand called
usb-storage: *** thread awakened.
usb-storage: Command TEST_UNIT_READY (6 bytes)
usb-storage:  00 00 00 00 00 00
usb-storage: Bulk Command S 0x43425355 T 0x595 L 0 F 0 Trg 0 LUN 0 CL 6
usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
usb-storage: Status code 0; transferred 31/31
usb-storage: -- transfer complete
usb-storage: Bulk command transfer result=0
usb-storage: Attempting to get CSW...
usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
usb-storage: Status code 0; transferred 13/13
usb-storage: -- transfer complete
usb-storage: Bulk status result = 0
usb-storage: Bulk Status S 0x53425355 T 0x595 R 0 Stat 0x1
usb-storage: -- transport indicates command failure
usb-storage: Issuing auto-REQUEST_SENSE
usb-storage: Bulk Command S 0x43425355 T 0x596 L 18 F 128 Trg 0 LUN 0 CL 6
usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
usb-storage: Status code 0; transferred 31/31
usb-storage: -- transfer complete
usb-storage: Bulk command transfer result=0
usb-storage: usb_stor_bulk_transfer_sglist: xfer 18 bytes, 1 entries
usb-storage: Status code 0; transferred 18/18
usb-storage: -- transfer complete
usb-storage: Bulk data transfer result 0x0
usb-storage: Attempting to get CSW...
usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
usb-storage: Status code 0; transferred 13/13
usb-storage: -- transfer complete
usb-storage: Bulk status result = 0
usb-storage: Bulk Status S 0x53425355 T 0x596 R 0 Stat 0x0
usb-storage: -- Result from auto-sense is 0
usb-storage: -- code: 0x70, key: 0x2, ASC: 0x3a, ASCQ: 0x0
usb-storage: Not Ready: Medium not present
usb-storage: scsi cmd done, result=0x2
usb-storage: *** thread sleeping.
usb-storage: queuecommand called
usb-storage: *** thread awakened.
usb-storage: Command TEST_UNIT_READY (6 bytes)
usb-storage:  00 00 00 00 00 00
usb-storage: Bulk Command S 0x43425355 T 0x597 L 0 F 0 Trg 0 LUN 1 CL 6
usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
usb-storage: Status code 0; transferred 31/31
usb-storage: -- transfer complete
usb-storage: Bulk command transfer result=0
usb-storage: Attempting to get CSW...
usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
usb-storage: Status code 0; transferred 13/13
usb-storage: -- transfer complete
usb-storage: Bulk status result = 0
usb-storage: Bulk Status S 0x53425355 T 0x597 R 0 Stat 0x1
usb-storage: -- transport indicates command failure
usb-storage: Issuing auto-REQUEST_SENSE
usb-storage: Bulk Command S 0x43425355 T 0x598 L 18 F 128 Trg 0 LUN 1 CL 6
usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
usb-storage: Status code 0; transferred 31/31
usb-storage: -- transfer complete
usb-storage: Bulk command transfer result=0
usb-storage: usb_stor_bulk_transfer_sglist: xfer 18 bytes, 1 entries
usb-storage: Status code 0; transferred 18/18
usb-storage: -- transfer complete
usb-storage: Bulk data transfer result 0x0
usb-storage: Attempting to get CSW...
usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
usb-storage: Status code 0; transferred 13/13
usb-storage: -- transfer complete
usb-storage: Bulk status result = 0
usb-storage: Bulk Status S 0x53425355 T 0x598 R 0 Stat 0x0
usb-storage: -- Result from auto-sense is 0
usb-storage: -- code: 0x70, key: 0x2, ASC: 0x3a, ASCQ: 0x0
usb-storage: Not Ready: Medium not present
usb-storage: scsi cmd done, result=0x2
usb-storage: *** thread sleeping.
usb-storage: queuecommand called
usb-storage: *** thread awakened.
usb-storage: Command TEST_UNIT_READY (6 bytes)
usb-storage:  00 00 00 00 00 00
usb-storage: Bulk Command S 0x43425355 T 0x599 L 0 F 0 Trg 0 LUN 0 CL 6
usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
usb-storage: Status code 0; transferred 31/31
usb-storage: -- transfer complete
usb-storage: Bulk command transfer result=0
usb-storage: Attempting to get CSW...
usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
usb-storage: Status code 0; transferred 13/13
usb-storage: -- transfer complete
usb-storage: Bulk status result = 0
usb-storage: Bulk Status S 0x53425355 T 0x599 R 0 Stat 0x1
usb-storage: -- transport indicates command failure
usb-storage: Issuing auto-REQUEST_SENSE
usb-storage: Bulk Command S 0x43425355 T 0x59a L 18 F 128 Trg 0 LUN 0 CL 6
usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
usb-storage: Status code 0; transferred 31/31
usb-storage: -- transfer complete
usb-storage: Bulk command transfer result=0
usb-storage: usb_stor_bulk_transfer_sglist: xfer 18 bytes, 1 entries
usb-storage: Status code 0; transferred 18/18
usb-storage: -- transfer complete
usb-storage: Bulk data transfer result 0x0
usb-storage: Attempting to get CSW...
usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
usb-storage: Status code 0; transferred 13/13
usb-storage: -- transfer complete
usb-storage: Bulk status result = 0
usb-storage: Bulk Status S 0x53425355 T 0x59a R 0 Stat 0x0
usb-storage: -- Result from auto-sense is 0
usb-storage: -- code: 0x70, key: 0x2, ASC: 0x3a, ASCQ: 0x0
usb-storage: Not Ready: Medium not present
usb-storage: scsi cmd done, result=0x2
usb-storage: *** thread sleeping.
usb-storage: queuecommand called
usb-storage: *** thread awakened.
usb-storage: Command TEST_UNIT_READY (6 bytes)
usb-storage:  00 00 00 00 00 00
usb-storage: Bulk Command S 0x43425355 T 0x59b L 0 F 0 Trg 0 LUN 1 CL 6
usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
usb-storage: Status code 0; transferred 31/31
usb-storage: -- transfer complete
usb-storage: Bulk command transfer result=0
usb-storage: Attempting to get CSW...
usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
usb-storage: Status code 0; transferred 13/13
usb-storage: -- transfer complete
usb-storage: Bulk status result = 0
usb-storage: Bulk Status S 0x53425355 T 0x59b R 0 Stat 0x1
usb-storage: -- transport indicates command failure
usb-storage: Issuing auto-REQUEST_SENSE
usb-storage: Bulk Command S 0x43425355 T 0x59c L 18 F 128 Trg 0 LUN 1 CL 6
usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
usb-storage: Status code 0; transferred 31/31
usb-storage: -- transfer complete
usb-storage: Bulk command transfer result=0
usb-storage: usb_stor_bulk_transfer_sglist: xfer 18 bytes, 1 entries
usb-storage: Status code 0; transferred 18/18
usb-storage: -- transfer complete
usb-storage: Bulk data transfer result 0x0
usb-storage: Attempting to get CSW...
usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
usb-storage: Status code 0; transferred 13/13
usb-storage: -- transfer complete
usb-storage: Bulk status result = 0
usb-storage: Bulk Status S 0x53425355 T 0x59c R 0 Stat 0x0
usb-storage: -- Result from auto-sense is 0
usb-storage: -- code: 0x70, key: 0x2, ASC: 0x3a, ASCQ: 0x0
usb-storage: Not Ready: Medium not present
usb-storage: scsi cmd done, result=0x2
usb-storage: *** thread sleeping.
usb-storage: queuecommand called
usb-storage: *** thread awakened.
usb-storage: Command TEST_UNIT_READY (6 bytes)
usb-storage:  00 00 00 00 00 00
usb-storage: Bulk Command S 0x43425355 T 0x59d L 0 F 0 Trg 0 LUN 1 CL 6
usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
usb-storage: Status code 0; transferred 31/31
usb-storage: -- transfer complete
usb-storage: Bulk command transfer result=0
usb-storage: Attempting to get CSW...
usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
usb-storage: Status code 0; transferred 13/13
usb-storage: -- transfer complete
usb-storage: Bulk status result = 0
usb-storage: Bulk Status S 0x53425355 T 0x59d R 0 Stat 0x1
usb-storage: -- transport indicates command failure
usb-storage: Issuing auto-REQUEST_SENSE
usb-storage: Bulk Command S 0x43425355 T 0x59e L 18 F 128 Trg 0 LUN 1 CL 6
usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
usb-storage: Status code 0; transferred 31/31
usb-storage: -- transfer complete
usb-storage: Bulk command transfer result=0
usb-storage: usb_stor_bulk_transfer_sglist: xfer 18 bytes, 1 entries
usb-storage: Status code 0; transferred 18/18
usb-storage: -- transfer complete
usb-storage: Bulk data transfer result 0x0
usb-storage: Attempting to get CSW...
usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
usb-storage: Status code 0; transferred 13/13
usb-storage: -- transfer complete
usb-storage: Bulk status result = 0
usb-storage: Bulk Status S 0x53425355 T 0x59e R 0 Stat 0x0
usb-storage: -- Result from auto-sense is 0
usb-storage: -- code: 0x70, key: 0x2, ASC: 0x3a, ASCQ: 0x0
usb-storage: Not Ready: Medium not present
usb-storage: scsi cmd done, result=0x2
usb-storage: *** thread sleeping.
usb-storage: queuecommand called
usb-storage: *** thread awakened.
usb-storage: Command TEST_UNIT_READY (6 bytes)
usb-storage:  00 00 00 00 00 00
usb-storage: Bulk Command S 0x43425355 T 0x59f L 0 F 0 Trg 0 LUN 0 CL 6
usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
usb-storage: Status code 0; transferred 31/31
usb-storage: -- transfer complete
usb-storage: Bulk command transfer result=0
usb-storage: Attempting to get CSW...
usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
usb-storage: Status code 0; transferred 13/13
usb-storage: -- transfer complete
usb-storage: Bulk status result = 0
usb-storage: Bulk Status S 0x53425355 T 0x59f R 0 Stat 0x1
usb-storage: -- transport indicates command failure
usb-storage: Issuing auto-REQUEST_SENSE
usb-storage: Bulk Command S 0x43425355 T 0x5a0 L 18 F 128 Trg 0 LUN 0 CL 6
usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
usb-storage: Status code 0; transferred 31/31
usb-storage: -- transfer complete
usb-storage: Bulk command transfer result=0
usb-storage: usb_stor_bulk_transfer_sglist: xfer 18 bytes, 1 entries
usb-storage: Status code 0; transferred 18/18
usb-storage: -- transfer complete
usb-storage: Bulk data transfer result 0x0
usb-storage: Attempting to get CSW...
usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
usb-storage: Status code 0; transferred 13/13
usb-storage: -- transfer complete
usb-storage: Bulk status result = 0
usb-storage: Bulk Status S 0x53425355 T 0x5a0 R 0 Stat 0x0
usb-storage: -- Result from auto-sense is 0
usb-storage: -- code: 0x70, key: 0x2, ASC: 0x3a, ASCQ: 0x0
usb-storage: Not Ready: Medium not present
usb-storage: scsi cmd done, result=0x2
usb-storage: *** thread sleeping.
usb-storage: queuecommand called
usb-storage: *** thread awakened.
usb-storage: Command TEST_UNIT_READY (6 bytes)
usb-storage:  00 00 00 00 00 00
usb-storage: Bulk Command S 0x43425355 T 0x5a1 L 0 F 0 Trg 0 LUN 1 CL 6
usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
usb-storage: Status code 0; transferred 31/31
usb-storage: -- transfer complete
usb-storage: Bulk command transfer result=0
usb-storage: Attempting to get CSW...
usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
usb-storage: Status code 0; transferred 13/13
usb-storage: -- transfer complete
usb-storage: Bulk status result = 0
usb-storage: Bulk Status S 0x53425355 T 0x5a1 R 0 Stat 0x1
usb-storage: -- transport indicates command failure
usb-storage: Issuing auto-REQUEST_SENSE
usb-storage: Bulk Command S 0x43425355 T 0x5a2 L 18 F 128 Trg 0 LUN 1 CL 6
usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
usb-storage: Status code 0; transferred 31/31
usb-storage: -- transfer complete
usb-storage: Bulk command transfer result=0
usb-storage: usb_stor_bulk_transfer_sglist: xfer 18 bytes, 1 entries
usb-storage: Status code 0; transferred 18/18
usb-storage: -- transfer complete
usb-storage: Bulk data transfer result 0x0
usb-storage: Attempting to get CSW...
usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
usb-storage: Status code 0; transferred 13/13
usb-storage: -- transfer complete
usb-storage: Bulk status result = 0
usb-storage: Bulk Status S 0x53425355 T 0x5a2 R 0 Stat 0x0
usb-storage: -- Result from auto-sense is 0
usb-storage: -- code: 0x70, key: 0x2, ASC: 0x3a, ASCQ: 0x0
usb-storage: Not Ready: Medium not present
usb-storage: scsi cmd done, result=0x2
usb-storage: *** thread sleeping.
usb-storage: queuecommand called
usb-storage: *** thread awakened.
usb-storage: Command TEST_UNIT_READY (6 bytes)
usb-storage:  00 00 00 00 00 00
usb-storage: Bulk Command S 0x43425355 T 0x5a3 L 0 F 0 Trg 0 LUN 0 CL 6
usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
usb-storage: Status code 0; transferred 31/31
usb-storage: -- transfer complete
usb-storage: Bulk command transfer result=0
usb-storage: Attempting to get CSW...
usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
usb-storage: Status code 0; transferred 13/13
usb-storage: -- transfer complete
usb-storage: Bulk status result = 0
usb-storage: Bulk Status S 0x53425355 T 0x5a3 R 0 Stat 0x1
usb-storage: -- transport indicates command failure
usb-storage: Issuing auto-REQUEST_SENSE
usb-storage: Bulk Command S 0x43425355 T 0x5a4 L 18 F 128 Trg 0 LUN 0 CL 6
usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
usb-storage: Status code 0; transferred 31/31
usb-storage: -- transfer complete
usb-storage: Bulk command transfer result=0
usb-storage: usb_stor_bulk_transfer_sglist: xfer 18 bytes, 1 entries
usb-storage: Status code 0; transferred 18/18
usb-storage: -- transfer complete
usb-storage: Bulk data transfer result 0x0
usb-storage: Attempting to get CSW...
usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
usb-storage: Status code 0; transferred 13/13
usb-storage: -- transfer complete
usb-storage: Bulk status result = 0
usb-storage: Bulk Status S 0x53425355 T 0x5a4 R 0 Stat 0x0
usb-storage: -- Result from auto-sense is 0
usb-storage: -- code: 0x70, key: 0x2, ASC: 0x3a, ASCQ: 0x0
usb-storage: Not Ready: Medium not present
usb-storage: scsi cmd done, result=0x2
usb-storage: *** thread sleeping.


lsmod after

Module                  Size  Used by
tuner_xc2028           35504  1
firmware_class         25216  1 tuner_xc2028
tuner                  41804  0
cx8800                 50084  0
cx88xx                 85928  1 cx8800
ir_common              60292  1 cx88xx
i2c_algo_bit           22916  1 cx88xx
tveeprom               30212  1 cx88xx
compat_ioctl32         24832  1 cx8800
videodev               51456  4 tuner,cx8800,cx88xx,compat_ioctl32
v4l1_compat            29828  1 videodev
v4l2_common            29952  2 tuner,cx8800
videobuf_dma_sg        29828  2 cx8800,cx88xx
videobuf_core          36100  3 cx8800,cx88xx,videobuf_dma_sg
btcx_risc              21384  2 cx8800,cx88xx
iptable_filter         19968  0
ip_tables              34064  1 iptable_filter
ip6_tables             35728  0
x_tables               38280  2 ip_tables,ip6_tables
snd_pcm_oss            60672  0
snd_mixer_oss          32000  1 snd_pcm_oss
binfmt_misc            26252  1
snd_seq                72208  0
it87                   40088  0
snd_seq_device         24724  1 snd_seq
hwmon_vid              19840  1 it87
cpufreq_conservative    24328  0
cpufreq_userspace      22916  0
cpufreq_powersave      18944  0
powernow_k8            29956  1
fuse                   66880  1
loop                   32396  0
dm_mod                 72288  0
snd_hda_intel         469804  2
usbhid                 58192  1
snd_pcm               101512  2 snd_pcm_oss,snd_hda_intel
snd_timer              39952  2 snd_seq,snd_pcm
hid                    54688  1 usbhid
snd_page_alloc         26128  2 snd_hda_intel,snd_pcm
rtc_cmos               27064  0
ff_memless             22024  1 usbhid
rtc_core               35252  1 rtc_cmos
rtc_lib                20096  1 rtc_core
sr_mod                 31156  0
snd_hwdep              25096  1 snd_hda_intel
floppy                 74792  0
snd                    84216  12 
snd_pcm_oss,snd_mixer_oss,snd_seq,snd_seq_device,snd_hda_intel,snd_pcm,snd_timer,snd_hwdep
i2c_piix4              25616  0
serio_raw              22660  0
usbtouchscreen         26756  0
k8temp                 21760  0
fglrx                2058956  28
ohci1394               45364  0
sg                     48976  0
usb_storage           142064  0
cdrom                  50856  1 sr_mod
i2c_core               40480  7 
tuner_xc2028,tuner,cx88xx,i2c_algo_bit,tveeprom,v4l2_common,i2c_piix4
soundcore              24464  1 snd
shpchp                 47392  0
button                 24480  0
r8169                  43652  0
wmi                    24256  0
ieee1394              106984  1 ohci1394
pci_hotplug            44472  1 shpchp
raid456               140576  0
async_xor              20992  1 raid456
async_memcpy           19456  1 raid456
async_tx               24420  3 raid456,async_xor,async_memcpy
xor                    22288  2 raid456,async_xor
raid0                  23424  0
ehci_hcd               50060  0
ohci_hcd               37892  0
usbcore               162392  7 
usbhid,usbtouchscreen,usb_storage,ehci_hcd,ohci_hcd
sd_mod                 41648  24
edd                    26000  0
raid1                  38016  11
reiserfs              230224  10
fan                    22152  0
ahci                   45192  22
pata_atiixp            22400  0
libata                181184  2 ahci,pata_atiixp
scsi_mod              174680  5 sr_mod,sg,usb_storage,sd_mod,libata
dock                   26656  1 libata
thermal                37792  0
processor              64704  2 powernow_k8,thermal

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
