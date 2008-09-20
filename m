Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx2.redhat.com (mx2.redhat.com [10.255.15.25])
	by int-mx2.corp.redhat.com (8.13.1/8.13.1) with SMTP id m8KAsMQk024938
	for <video4linux-list@redhat.com>; Sat, 20 Sep 2008 06:54:22 -0400
Received: from mho-02-bos.mailhop.org (mho-02-bos.mailhop.org [63.208.196.179])
	by mx2.redhat.com (8.13.8/8.13.8) with SMTP id m8KAs32a007845
	for <video4linux-list@redhat.com>; Sat, 20 Sep 2008 06:54:04 -0400
Received: from c-24-63-231-219.hsd1.vt.comcast.net ([24.63.231.219]
	helo=homer.edgehp.net)
	by mho-02-bos.mailhop.org with esmtpsa (TLSv1:AES256-SHA:256)
	(Exim 4.68) (envelope-from <DEPontius@edgehp.net>)
	id 1Kh052-000DBv-5R
	for video4linux-list@redhat.com; Sat, 20 Sep 2008 10:52:48 +0000
Received: from [192.168.154.40] (anastasia.edgehp.net [192.168.154.40])
	by homer.edgehp.net (Postfix) with ESMTP id 11B1E1426D
	for <video4linux-list@redhat.com>; Sat, 20 Sep 2008 06:52:47 -0400 (EDT)
Message-ID: <48D4D5FE.60507@edgehp.net>
Date: Sat, 20 Sep 2008 06:52:46 -0400
From: Dale Pontius <DEPontius@edgehp.net>
MIME-Version: 1.0
To: video4linux-list@redhat.com
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Subject: HVR-1600 - unable to find tuner
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

I've been having mail problems recently, both at my ISP and my
server, so if this is a dupe, I apologize.

A week back I posted a "newby question," and eventually it became
apparent that I can't find my tuner.  Though I have a supposedly
good (PCI-2.3) motherboard, I loaded the module with:
"modprobe cx18 mmio_ndelay=61"

The results of dmesg:
cx18:  Start initialization, version 1.0.0
cx18-0: Initializing card #0
cx18-0: Autodetected Hauppauge card
ACPI: PCI Interrupt 0000:05:08.0[A] -> Link [APC3] -> GSI 18 (level, low) -> IRQ 18
cx18-0: Unreasonably low latency timer, setting to 64 (was 32)
cx18-0: cx23418 revision 01010000 (B)
tveeprom 6-0050: Hauppauge model 74041, rev C6B2, serial# 3334244
tveeprom 6-0050: MAC address is 00-0D-FE-32-E0-64
tveeprom 6-0050: tuner model is TCL M2523_5N_E (idx 112, type 50)
tveeprom 6-0050: TV standards NTSC(M) (eeprom 0x08)
tveeprom 6-0050: audio processor is CX23418 (idx 38)
tveeprom 6-0050: decoder processor is CX23418 (idx 31)
tveeprom 6-0050: has no radio, has IR receiver, has IR transmitter
cx18-0: Autodetected Hauppauge HVR-1600
cx18-0: VBI is not yet supported
cs5345 6-004c: chip found @ 0x98 (cx18 i2c driver #0-0)
cx18-0: Disabled encoder IDX device
cx18-0: Registered device video1 for encoder MPEG (2 MB)
DVB: registering new adapter (cx18)
MXL5005S: Attached at address 0x63
DVB: registering frontend 0 (Samsung S5H1409 QAM/8VSB Frontend)...
cx18-0: DVB Frontend registered
cx18-0: Registered device video32 for encoder YUV (2 MB)
cx18-0: Registered device video24 for encoder PCM audio (1 MB)
cx18-0: Initialized card #0: Hauppauge HVR-1600
cx18:  End initialization

Then thinking about the i2c problems, and not easily finding any sort
of "i2c-explorer" or "lsi2c" I went probing around in "/sys/class/i2c-adapter".
The card shows up as i2c-6 and i2c-7: (cat i2c-*/name)
SMBus nForce2 adapter at 4c00
SMBus nForce2 adapter at 4c40
bt878 #0 [sw]
NVIDIA i2c adapter
NVIDIA i2c adapter
NVIDIA i2c adapter
cx18 i2c driver #0-0
cx18 i2c driver #0-1

(Even though it says "SMBus nForce2" it's really nForce4.)

The i2c-6 bus is the cs5345:
i2c-6:
total 0
drwxr-xr-x 3 root root    0 Sep 19 19:33 6-004c
lrwxrwxrwx 1 root root    0 Sep 19 19:33 device -> ../../../devices/pci0000:00/0000:00:09.0/0000:05:08.0
-r--r--r-- 1 root root 4096 Sep 19 19:33 name       (cx18 i2c driver #0-0)
drwxr-xr-x 2 root root    0 Sep 19 19:33 power
lrwxrwxrwx 1 root root    0 Sep 19 19:33 subsystem -> ../../i2c-adapter
-rw-r--r-- 1 root root 4096 Sep 19 19:33 uevent

i2c-6/6-004c:
total 0
lrwxrwxrwx 1 root root    0 Sep 19 19:33 bus -> ../../../../bus/i2c
lrwxrwxrwx 1 root root    0 Sep 19 19:33 driver -> ../../../../bus/i2c/drivers/cs5345
-r--r--r-- 1 root root 4096 Sep 19 19:33 modalias   (cs5345)
-r--r--r-- 1 root root 4096 Sep 19 19:33 name       ( )
drwxr-xr-x 2 root root    0 Sep 19 19:33 power
lrwxrwxrwx 1 root root    0 Sep 19 19:33 subsystem -> ../../../../bus/i2c
-rw-r--r-- 1 root root 4096 Sep 19 19:33 uevent

i2c-6/6-004c/power:
total 0
-rw-r--r-- 1 root root 4096 Sep 19 19:33 wakeup

i2c-6/power:
total 0
-rw-r--r-- 1 root root 4096 Sep 19 19:33 wakeup

The i2c-7 bus is the cx18:
i2c-7:
total 0
lrwxrwxrwx 1 root root    0 Sep 19 19:34 device -> ../../../devices/pci0000:00/0000:00:09.0/0000:05:08.0
-r--r--r-- 1 root root 4096 Sep 19 19:33 name
drwxr-xr-x 2 root root    0 Sep 19 19:34 power
lrwxrwxrwx 1 root root    0 Sep 19 19:34 subsystem -> ../../i2c-adapter
-rw-r--r-- 1 root root 4096 Sep 19 19:34 uevent

i2c-7/power:
total 0
-rw-r--r-- 1 root root 4096 Sep 19 19:34 wakeup

And there's a bit more information under i2c-7/device/:
.:
total 0
-rw-r--r-- 1 root root     4096 Sep 19 19:38 broken_parity_status
lrwxrwxrwx 1 root root        0 Sep 19 06:22 bus -> ../../../../bus/pci
-r--r--r-- 1 root root     4096 Sep 19 19:38 class
-rw-r--r-- 1 root root      256 Sep 19 19:38 config
-r--r--r-- 1 root root     4096 Sep 19 19:38 device
lrwxrwxrwx 1 root root        0 Sep 19 19:38 driver -> ../../../../bus/pci/drivers/cx18
lrwxrwxrwx 1 root root        0 Sep 19 19:38 dvb:dvb0.demux0 -> ../../../../class/dvb/dvb0.demux0
lrwxrwxrwx 1 root root        0 Sep 19 19:38 dvb:dvb0.dvr0 -> ../../../../class/dvb/dvb0.dvr0
lrwxrwxrwx 1 root root        0 Sep 19 19:38 dvb:dvb0.frontend0 -> ../../../../class/dvb/dvb0.frontend0
lrwxrwxrwx 1 root root        0 Sep 19 19:38 dvb:dvb0.net0 -> ../../../../class/dvb/dvb0.net0
-rw------- 1 root root     4096 Sep 19 19:38 enable
lrwxrwxrwx 1 root root        0 Sep 19 19:38 i2c-adapter:i2c-6 -> ../../../../class/i2c-adapter/i2c-6
lrwxrwxrwx 1 root root        0 Sep 19 19:38 i2c-adapter:i2c-7 -> ../../../../class/i2c-adapter/i2c-7
-r--r--r-- 1 root root     4096 Sep 19 19:38 irq
-r--r--r-- 1 root root     4096 Sep 19 19:38 local_cpus
-r--r--r-- 1 root root     4096 Sep 19 19:38 modalias
-rw-r--r-- 1 root root     4096 Sep 19 19:38 msi_bus
drwxr-xr-x 2 root root        0 Sep 19 06:30 power
-r--r--r-- 1 root root     4096 Sep 19 06:22 resource
-rw------- 1 root root 67108864 Sep 19 19:38 resource0
lrwxrwxrwx 1 root root        0 Sep 19 19:38 subsystem -> ../../../../bus/pci
-r--r--r-- 1 root root     4096 Sep 19 19:38 subsystem_device
-r--r--r-- 1 root root     4096 Sep 19 19:38 subsystem_vendor
-rw-r--r-- 1 root root     4096 Sep 19 06:22 uevent
-r--r--r-- 1 root root     4096 Sep 19 19:38 vendor
lrwxrwxrwx 1 root root        0 Sep 19 19:38 video4linux:video1 -> ../../../../class/video4linux/video1
lrwxrwxrwx 1 root root        0 Sep 19 19:38 video4linux:video24 -> ../../../../class/video4linux/video24
lrwxrwxrwx 1 root root        0 Sep 19 19:38 video4linux:video32 -> ../../../../class/video4linux/video32

./power:
total 0
-rw-r--r-- 1 root root 4096 Sep 19 06:30 wakeup

I understand that both tuners are supposed to be attached to the i2c bus of the cx18, and it's pretty clear that the ATSC/QAM tuner is there. But other than the "video4linux:video1" I don't see
anything that smacks of the NTSC tuner.

Can someone tell me what this is supposed to look like, or suggest a next step in finding my tuner?

Thanks,
Dale Pontius

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
