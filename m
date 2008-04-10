Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m3ADSAs2020006
	for <video4linux-list@redhat.com>; Thu, 10 Apr 2008 09:28:10 -0400
Received: from el-out-1112.google.com (el-out-1112.google.com [209.85.162.180])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m3ADS0Nm001578
	for <video4linux-list@redhat.com>; Thu, 10 Apr 2008 09:28:00 -0400
Received: by el-out-1112.google.com with SMTP id n30so2499082elf.7
	for <video4linux-list@redhat.com>; Thu, 10 Apr 2008 06:28:00 -0700 (PDT)
Message-ID: <5b5250670804100627v28b2d64ex733e14dceb37fac1@mail.gmail.com>
Date: Thu, 10 Apr 2008 18:57:58 +0530
From: "thirunavukarasu selvam" <gs.thiru@gmail.com>
To: video4linux-list@redhat.com
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Subject: Trouble in loading drivers for both wintv nova-s-plus and pvr-500
	card simultaneously (mainly becos of tveeprom.ko module)
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

Hi all,

I am working with WinTV NOVA-S-Plus card and WinTV PVR-500 card in RHEL 4.4
machine.
I am using kernel 2.6.12.
For WinTV NOVA-S-plus card i have used v4l-dvb drivers.
For PVR-500 card i have used ivtv-0.4.9 drivers.
After compiling and installing these two drivers, i tried the following
steps to load the drivers.

1. for NOVA-S-Plus card
modprobe tveeprom
modprobe cx24123
modprobe cx8800
modprobe cx8802
modprobe cx88xx
modprobe cx88-dvb

2. for PVR-500 card
depmod -a
modprobe tveeprom
modprobe ivtv

U can see the tveeprom is loaded twice. becos both the drivers has its own
tveeprom
for nova-s-plus card it is in
/lib/modules/2.6.12/kernel/drivers/media/video/ directory
for pvr-500 card it is in /lib/modules/2.6.12/ivtv/ directory.

If i do load the driver for nova-s-plus card it load it properly and dvb
device is getting registered properly.
xawtv -hwscan detects the card and shows card details.

After this if i load the driver for pvr card
modprobe ivtv gives the following error
FATAL: Error inserting ivtv
(/lib/modules/2.6.12/kernel/drivers/media/video/ivtv/ivtv.ko): Unknown
symbol in module, or unknown parameter (see dmesg)

dmesg shows the following
ivtv: disagrees about version of symbol video_unregister_device
ivtv: Unknown symbol video_unregister_device
ivtv: disagrees about version of symbol video_device_alloc
ivtv: Unknown symbol video_device_alloc
ivtv: disagrees about version of symbol video_register_device
ivtv: Unknown symbol video_register_device
ivtv: disagrees about version of symbol video_device_release
ivtv: Unknown symbol video_device_release


If do the reverse procedure ie loading ivtv first and then load v4l dvb
drivers
PVR card is detected properly but while loading NOVA-S-plus card drivers

modprobe cx88-dvb gives the following error
 modprobe cx88-dvb
WARNING: Error inserting cx88xx
(/lib/modules/2.6.12/kernel/drivers/media/video/cx88/cx88xx.ko): Unknown
symbol in module, or unknown parameter (see dmesg)
WARNING: Error inserting cx8802
(/lib/modules/2.6.12/kernel/drivers/media/video/cx88/cx8802.ko): Unknown
symbol in module, or unknown parameter (see dmesg)
FATAL: Error inserting cx88_dvb
(/lib/modules/2.6.12/kernel/drivers/media/video/cx88/cx88-dvb.ko): Unknown
symbol in module, or unknown parameter (see dmesg)

dmesg shows the following
cx88xx: disagrees about version of symbol tveeprom_hauppauge_analog
cx88xx: Unknown symbol tveeprom_hauppauge_analog
cx8802: Unknown symbol cx88_reset
cx8802: Unknown symbol cx88_wakeup
cx8802: Unknown symbol cx88_risc_stopper
cx8802: Unknown symbol cx88_print_irqbits
cx8802: Unknown symbol cx88_shutdown
cx8802: Unknown symbol cx88_core_irq
cx8802: Unknown symbol cx88_sram_channels
cx8802: Unknown symbol cx88_sram_channel_dump
cx8802: Unknown symbol cx88_sram_channel_setup
cx8802: Unknown symbol cx88_free_buffer
cx8802: Unknown symbol cx88_boards
cx8802: Unknown symbol cx88_risc_databuffer
cx88_dvb: Unknown symbol cx8802_fini_common
cx88_dvb: Unknown symbol cx88_call_i2c_clients
cx88_dvb: Unknown symbol cx88_core_put
cx88_dvb: Unknown symbol cx88_core_get
cx88_dvb: Unknown symbol cx8802_resume_common
cx88_dvb: Unknown symbol cx8802_buf_prepare
cx88_dvb: Unknown symbol cx8802_init_common
cx88_dvb: Unknown symbol cx88_free_buffer
cx88_dvb: Unknown symbol cx88_boards
cx88_dvb: Unknown symbol cx8802_buf_queue
cx88_dvb: Unknown symbol cx8802_suspend_common

>From the result what i understood is both drivers have a module called
tveeprom.ko and that's where the problem starts.

so please tell the solution for both the cards to work simultaneously.

Thanks in advance for ur help

Regards,
Thiru.
--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
