Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:37932 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751851Ab1KKWMn (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 11 Nov 2011 17:12:43 -0500
Received: by mail-ww0-f44.google.com with SMTP id 5so1958562wwe.1
        for <linux-media@vger.kernel.org>; Fri, 11 Nov 2011 14:12:42 -0800 (PST)
MIME-Version: 1.0
Date: Fri, 11 Nov 2011 23:12:42 +0100
Message-ID: <CAL9G6WVfx3_0c1=uGoa5OB+0K8LretrGjAnB6EsGvF4kHApCCw@mail.gmail.com>
Subject: Hauppauge WinTV-Duet HD i2c problems
From: Josu Lazkano <josu.lazkano@gmail.com>
To: linux-media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello list, I just buy a Hauppauge WinTV-Duet HD DVB USB stick. I
added on my laptop and it works great.

The problem is on my Nvidia ION board PC, when I add the stick I get this:

[ 3852.016040] usb 1-2: new high speed USB device using ehci_hcd and address 2
[ 3852.149612] usb 1-2: New USB device found, idVendor=2040, idProduct=5200
[ 3852.149620] usb 1-2: New USB device strings: Mfr=1, Product=2, SerialNumber=3
[ 3852.149627] usb 1-2: Product: NovaT 500Stick
[ 3852.149631] usb 1-2: Manufacturer: Hauppauge
[ 3852.149636] usb 1-2: SerialNumber: 4034588817
[ 3852.149876] usb 1-2: configuration #1 chosen from 1 choice
[ 3852.343074] dib0700: loaded with support for 14 different device-types
[ 3852.343247] dvb-usb: found a 'Hauppauge Nova-TD Stick (52009)' in
cold state, will try to load a firmware
[ 3852.343259] usb 1-2: firmware: requesting dvb-usb-dib0700-1.20.fw
[ 3852.389203] dvb-usb: downloading firmware from file 'dvb-usb-dib0700-1.20.fw'
[ 3852.590849] dib0700: firmware started successfully.
[ 3853.092251] dvb-usb: found a 'Hauppauge Nova-TD Stick (52009)' in warm state.
[ 3853.092369] dvb-usb: will pass the complete MPEG2 transport stream
to the software demuxer.
[ 3853.092502] DVB: registering new adapter (Hauppauge Nova-TD Stick (52009))
[ 3853.327595] DVB: registering adapter 4 frontend 0 (DiBcom 7000PC)...
[ 3853.380054] BUG: unable to handle kernel NULL pointer dereference at (null)
[ 3853.380067] IP: [<f7f34314>] i2c_transfer+0x18/0x9a [i2c_core]
[ 3853.380096] *pde = 00000000
[ 3853.380102] Oops: 0000 [#1] SMP
[ 3853.380108] last sysfs file:
/sys/devices/pci0000:00/0000:00:04.1/usb1/1-2/dvb/dvb4.frontend0/uevent
[ 3853.380116] Modules linked in: dvb_usb_dib0700(+) dib7000p dib0090
dib7000m dib0070 dib8000 dib3000mc dibx000_common dvbloopback
cpufreq_stats cpufreq_powersave cpufreq_userspace cpufreq_conservative
parport_pc ppdev lp parport sco rfcomm bridge stp bnep l2cap crc16
bluetooth rfkill nls_utf8 cifs xt_multiport iptable_filter ip_tables
x_tables binfmt_misc fuse nfsd nfs lockd fscache nfs_acl auth_rpcgss
sunrpc xfs exportfs lm90 coretemp loop snd_hda_codec_nvhdmi
snd_hda_codec_realtek cx23885 cx2341x v4l2_common snd_hda_intel
videodev v4l1_compat videobuf_dma_sg snd_hda_codec ir_sony_decoder
videobuf_dvb ir_jvc_decoder snd_hwdep videobuf_core snd_pcm
ir_rc6_decoder ds3000 ir_rc5_decoder joydev snd_seq ir_common
ir_nec_decoder snd_timer snd_seq_device ir_core hid_sunplus snd
btcx_risc dvb_usb_dw2102 usbhid soundcore shpchp dvb_usb lirc_mceusb2
psmouse snd_page_alloc i2c_nforce2 pci_hotplug hid dvb_core tveeprom
lirc_dev nvidia(P) evdev i2c_core wmi serio_raw pcspkr processor
button ext3 jbd mbcache sd_mod crc_t10dif ata_generic ohci_hcd ahci
libata scsi_mod ehci_hcd forcedeth usbcore nls_base thermal
thermal_sys [last unloaded: scsi_wait_scan]
[ 3853.380287]
[ 3853.380295] Pid: 7052, comm: modprobe Tainted: P
(2.6.32-5-686 #1) To Be Filled By O.E.M.
[ 3853.380302] EIP: 0060:[<f7f34314>] EFLAGS: 00010282 CPU: 0
[ 3853.380322] EIP is at i2c_transfer+0x18/0x9a [i2c_core]
[ 3853.380328] EAX: 00000000 EBX: ffffffa1 ECX: 00000002 EDX: f3c4de14
[ 3853.380334] ESI: f60afaf8 EDI: 00000040 EBP: f7e30874 ESP: f3c4ddf4
[ 3853.380340]  DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
[ 3853.380347] Process modprobe (pid: 7052, ti=f3c4c000 task=f6114400
task.ti=f3c4c000)
[ 3853.380352] Stack:
[ 3853.380355]  00000002 f3c4de14 f7d81b00 f51eac00 00000040 f7e30874
f7d8110a 00000022
[ 3853.380369] <0> 00000060 00000001 f3c4de10 00010060 f7d80002
f3c4de2e c103b32a f7d81bcd
[ 3853.380383] <0> f51eac00 f60afaf8 f60af800 f7d820d4 f4078864
f7d81b00 f4078864 f60afaf8
[ 3853.380398] Call Trace:
[ 3853.380409]  [<f7d81b00>] ? dib0070_attach+0x0/0x3c4 [dib0070]
[ 3853.380418]  [<f7d8110a>] ? dib0070_read_reg+0x4e/0x77 [dib0070]
[ 3853.380443]  [<c103b32a>] ? msleep+0xd/0x12
[ 3853.380451]  [<f7d81bcd>] ? dib0070_attach+0xcd/0x3c4 [dib0070]
[ 3853.380460]  [<f7d81b00>] ? dib0070_attach+0x0/0x3c4 [dib0070]
[ 3853.380475]  [<f7e27fa6>] ? dib7070p_tuner_attach+0x9e/0xeb [dvb_usb_dib0700]
[ 3853.380503]  [<f96c2d6a>] ? dvb_usb_adapter_frontend_init+0xb9/0xd7 [dvb_usb]
[ 3853.380527]  [<f96c2878>] ? dvb_usb_device_init+0x448/0x51c [dvb_usb]
[ 3853.380541]  [<f7e26ae8>] ? dib0700_probe+0x33/0xb5 [dvb_usb_dib0700]
[ 3853.380551]  [<c126dece>] ? mutex_lock+0xb/0x24
[ 3853.380592]  [<f7c9400c>] ? usb_match_one_id+0x19/0x6e [usbcore]
[ 3853.380635]  [<f7c94d8c>] ? usb_probe_interface+0xe7/0x130 [usbcore]
[ 3853.380646]  [<c11b3482>] ? driver_probe_device+0x8a/0x11e
[ 3853.380654]  [<c11b3556>] ? __driver_attach+0x40/0x5b
[ 3853.380678]  [<c11b2ec5>] ? bus_for_each_dev+0x37/0x5f
[ 3853.380686]  [<c11b3355>] ? driver_attach+0x11/0x13
[ 3853.380694]  [<c11b3516>] ? __driver_attach+0x0/0x5b
[ 3853.380702]  [<c11b298d>] ? bus_add_driver+0x99/0x1c5
[ 3853.380724]  [<c11b3787>] ? driver_register+0x87/0xe0
[ 3853.380733]  [<c107248f>] ? tracepoint_module_notify+0x1d/0x20
[ 3853.380774]  [<f7c94b9a>] ? usb_register_driver+0x5d/0xb4 [usbcore]
[ 3853.380787]  [<f7e13000>] ? dib0700_module_init+0x0/0x3e [dvb_usb_dib0700]
[ 3853.380800]  [<f7e13025>] ? dib0700_module_init+0x25/0x3e [dvb_usb_dib0700]
[ 3853.380809]  [<c100113e>] ? do_one_initcall+0x55/0x155
[ 3853.380817]  [<c1057949>] ? sys_init_module+0xa7/0x1d7
[ 3853.380825]  [<c10030fb>] ? sysenter_do_call+0x12/0x28
[ 3853.380830] Code: 89 e2 89 4c 24 04 b9 ee 40 f3 f7 e8 a0 ce 27 c9
59 58 c3 55 57 56 89 c6 53 bb a1 ff ff ff 83 ec 08 89 54 24 04 89 0c
24 8b 40 0c <83> 38 00 74 74 89 e0 25 00 e0 ff ff f7 40 14 ff ff ff ef
75 0b
[ 3853.380909] EIP: [<f7f34314>] i2c_transfer+0x18/0x9a [i2c_core]
SS:ESP 0068:f3c4ddf4
[ 3853.380937] CR2: 0000000000000000
[ 3853.380943] ---[ end trace 488e92047d7c65dd ]---

If I boot with the stick connected I get similar problems, and if I
execute the "lsusb" the terminal stop working.

I don't know if this is related to the DVB device or the Nvidia board.
This is the board USB controller:

# lspci | grep USB
00:04.0 USB Controller: nVidia Corporation MCP79 OHCI USB 1.1
Controller (rev b1)
00:04.1 USB Controller: nVidia Corporation MCP79 EHCI USB 2.0
Controller (rev b1)
00:06.0 USB Controller: nVidia Corporation MCP79 OHCI USB 1.1
Controller (rev b1)
00:06.1 USB Controller: nVidia Corporation MCP79 EHCI USB 2.0
Controller (rev b1)

I will appreciate any help, I have not enough technical skill to
understand this.

Best regards.

-- 
Josu Lazkano
