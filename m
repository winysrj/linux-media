Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from yw-out-2324.google.com ([74.125.46.30])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <gs.thiru@gmail.com>) id 1Jjwnw-0007LT-2X
	for linux-dvb@linuxtv.org; Thu, 10 Apr 2008 15:27:11 +0200
Received: by yw-out-2324.google.com with SMTP id 5so732266ywh.41
	for <linux-dvb@linuxtv.org>; Thu, 10 Apr 2008 06:26:54 -0700 (PDT)
Message-ID: <5b5250670804100626p223df572r1c99e89b7d4da576@mail.gmail.com>
Date: Thu, 10 Apr 2008 18:56:26 +0530
From: "thirunavukarasu selvam" <gs.thiru@gmail.com>
To: linux-dvb@linuxtv.org
MIME-Version: 1.0
Subject: [linux-dvb] Trouble in loading drivers for both wintv nova-s-plus
	and pvr-500 card simultaneously (mainly becos of tveeprom.ko module)
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============1679872615=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

--===============1679872615==
Content-Type: multipart/alternative;
	boundary="----=_Part_14888_7152488.1207833986994"

------=_Part_14888_7152488.1207833986994
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

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

------=_Part_14888_7152488.1207833986994
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hi all,<br><br>I am working with WinTV NOVA-S-Plus card and WinTV PVR-500 card in RHEL 4.4 machine.<br>I am using kernel <a href="http://2.6.12.">2.6.12.</a><br>For WinTV NOVA-S-plus card i have used v4l-dvb drivers.<br>For PVR-500 card i have used ivtv-0.4.9 drivers.<br>
After compiling and installing these two drivers, i tried the following steps to load the drivers.<br><br>1. for NOVA-S-Plus card<br>modprobe tveeprom<br>modprobe cx24123<br>modprobe cx8800<br>modprobe cx8802<br>modprobe cx88xx<br>
modprobe cx88-dvb<br><br>2. for PVR-500 card<br>depmod -a<br>modprobe tveeprom<br>modprobe ivtv<br><br>U can see the tveeprom is loaded twice. becos both the drivers has its own tveeprom<br>for nova-s-plus card it is in /lib/modules/2.6.12/kernel/drivers/media/video/ directory<br>
for pvr-500 card it is in /lib/modules/2.6.12/ivtv/ directory.<br><br>If i do load the driver for nova-s-plus card it load it properly and dvb device is getting registered properly.<br>xawtv -hwscan detects the card and shows card details.<br>
<br>After this if i load the driver for pvr card<br>modprobe ivtv gives the following error<br>FATAL: Error inserting ivtv (/lib/modules/2.6.12/kernel/drivers/media/video/ivtv/ivtv.ko): Unknown symbol in module, or unknown parameter (see dmesg)<br>
<br>dmesg shows the following<br>ivtv: disagrees about version of symbol video_unregister_device<br>ivtv: Unknown symbol video_unregister_device<br>ivtv: disagrees about version of symbol video_device_alloc<br>ivtv: Unknown symbol video_device_alloc<br>
ivtv: disagrees about version of symbol video_register_device<br>ivtv: Unknown symbol video_register_device<br>ivtv: disagrees about version of symbol video_device_release<br>ivtv: Unknown symbol video_device_release<br><br>
<br>If do the reverse procedure ie loading ivtv first and then load v4l dvb drivers<br>PVR card is detected properly but while loading NOVA-S-plus card drivers<br><br>modprobe cx88-dvb gives the following error<br>&nbsp;modprobe cx88-dvb<br>
WARNING: Error inserting cx88xx (/lib/modules/2.6.12/kernel/drivers/media/video/cx88/cx88xx.ko): Unknown symbol in module, or unknown parameter (see dmesg)<br>WARNING: Error inserting cx8802 (/lib/modules/2.6.12/kernel/drivers/media/video/cx88/cx8802.ko): Unknown symbol in module, or unknown parameter (see dmesg)<br>
FATAL: Error inserting cx88_dvb (/lib/modules/2.6.12/kernel/drivers/media/video/cx88/cx88-dvb.ko): Unknown symbol in module, or unknown parameter (see dmesg)<br><br>dmesg shows the following<br>cx88xx: disagrees about version of symbol tveeprom_hauppauge_analog<br>
cx88xx: Unknown symbol tveeprom_hauppauge_analog<br>cx8802: Unknown symbol cx88_reset<br>cx8802: Unknown symbol cx88_wakeup<br>cx8802: Unknown symbol cx88_risc_stopper<br>cx8802: Unknown symbol cx88_print_irqbits<br>cx8802: Unknown symbol cx88_shutdown<br>
cx8802: Unknown symbol cx88_core_irq<br>cx8802: Unknown symbol cx88_sram_channels<br>cx8802: Unknown symbol cx88_sram_channel_dump<br>cx8802: Unknown symbol cx88_sram_channel_setup<br>cx8802: Unknown symbol cx88_free_buffer<br>
cx8802: Unknown symbol cx88_boards<br>cx8802: Unknown symbol cx88_risc_databuffer<br>cx88_dvb: Unknown symbol cx8802_fini_common<br>cx88_dvb: Unknown symbol cx88_call_i2c_clients<br>cx88_dvb: Unknown symbol cx88_core_put<br>
cx88_dvb: Unknown symbol cx88_core_get<br>cx88_dvb: Unknown symbol cx8802_resume_common<br>cx88_dvb: Unknown symbol cx8802_buf_prepare<br>cx88_dvb: Unknown symbol cx8802_init_common<br>cx88_dvb: Unknown symbol cx88_free_buffer<br>
cx88_dvb: Unknown symbol cx88_boards<br>cx88_dvb: Unknown symbol cx8802_buf_queue<br>cx88_dvb: Unknown symbol cx8802_suspend_common<br><br>From the result what i understood is both drivers have a module called tveeprom.ko and that&#39;s where the problem starts.<br>
<br>so please tell the solution for both the cards to work simultaneously.<br><br>Thanks in advance for ur help<br><br>Regards,<br>Thiru.<br><br>

------=_Part_14888_7152488.1207833986994--


--===============1679872615==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============1679872615==--
