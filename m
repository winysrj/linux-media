Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail.tu-berlin.de ([130.149.7.33])
	by mail.linuxtv.org with esmtp (Exim 4.69)
	(envelope-from <hm@seneca.muc.de>) id 1NWpM6-0003Ky-D9
	for linux-dvb@linuxtv.org; Mon, 18 Jan 2010 12:01:12 +0100
Received: from colin.muc.de ([193.149.48.1] helo=mail.muc.de)
	by mail.tu-berlin.de (exim-4.69/mailfrontend-b) with esmtps
	[TLSv1:AES256-SHA:256] for <linux-dvb@linuxtv.org>
	id 1NWpM5-00044H-Sj; Mon, 18 Jan 2010 12:01:10 +0100
Date: Mon, 18 Jan 2010 11:33:31 +0100
From: Harald Milz <hm@seneca.muc.de>
To: linux-dvb@linuxtv.org
Message-ID: <20100118103331.GA13882@seneca.muc.de>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="OgqxwSJOaUobr8KG"
Content-Disposition: inline
Subject: [linux-dvb] s2-liplianin & Technotrend TT-Connect S-2400
Reply-To: linux-media@vger.kernel.org
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/options/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>


--OgqxwSJOaUobr8KG
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi,

I am trying to use a S-2400 for Hotbird in addition to 2 S2-3650's pointing at
Astra. For the 3650's I need to use s2-liplianin because the box is not yet
supported by my stock OpenSUSE 11.1 (update) kernel. The 3650's work fine so
far. I have no luck with the 2400, though. Attached is the syslog excerpt -
maybe someone can see what is wrong here. The driver code is s2-liplianin-head
from last Saturday. 

Shortcut question: Do I want to get another 3650 / 3600? I had no luck with a
quad monoblock LNB either... 

TIA!

-- 
When I was a boy I was told that anybody could become President.  Now
I'm beginning to believe it.
		-- Clarence Darrow

--OgqxwSJOaUobr8KG
Content-Type: text/x-nemerle; charset=iso-8859-1
Content-Disposition: attachment; filename="messages-20100117.n"
Content-Transfer-Encoding: quoted-printable

Jan 15 15:26:18 seneca kernel: dvb-usb: found a 'Technotrend TT-connect S-2=
400' in cold state, will try to load a firmware
Jan 15 15:26:18 seneca kernel: firmware: requesting dvb-usb-tt-s2400-01.fw
Jan 15 15:26:18 seneca kernel: dvb-usb: downloading firmware from file 'dvb=
-usb-tt-s2400-01.fw'
Jan 15 15:26:18 seneca kernel: usbcore: registered new interface driver dvb=
_usb_ttusb2
Jan 15 15:26:18 seneca kernel: usb 1-2: USB disconnect, address 7
Jan 15 15:26:18 seneca kernel: dvb-usb: generic DVB-USB module successfully=
 deinitialized and disconnected.
Jan 15 15:26:20 seneca kernel: usb 1-2: new high speed USB device using ehc=
i_hcd and address 8
Jan 15 15:26:20 seneca kernel: usb 1-2: configuration #1 chosen from 1 choi=
ce
Jan 15 15:26:20 seneca kernel: dvb-usb: found a 'Technotrend TT-connect S-2=
400' in warm state.
Jan 15 15:26:20 seneca kernel: dvb-usb: will pass the complete MPEG2 transp=
ort stream to the software demuxer.
Jan 15 15:26:20 seneca kernel: DVB: registering new adapter (Technotrend TT=
-connect S-2400)
Jan 15 15:26:20 seneca kernel: DVB: registering frontend 0 (Philips TDA1008=
6 DVB-S)...
Jan 15 15:26:23 seneca kernel: dvb-usb: recv bulk message failed: -110
Jan 15 15:26:23 seneca kernel: ttusb2: there might have been an error durin=
g control message transfer. (rlen =3D 0, was 0)
Jan 15 15:26:23 seneca kernel: dvb-usb: Technotrend TT-connect S-2400 succe=
ssfully initialized and connected.
Jan 15 15:26:23 seneca kernel: usb 1-2: New USB device found, idVendor=3D0b=
48, idProduct=3D3006
Jan 15 15:26:23 seneca kernel: usb 1-2: New USB device strings: Mfr=3D1, Pr=
oduct=3D2, SerialNumber=3D0
Jan 15 15:26:23 seneca kernel: usb 1-2: Product: TT-USB2.0
Jan 15 15:26:23 seneca kernel: usb 1-2: Manufacturer: TechnoTrend

Jan 15 15:35:31 seneca kernel: usbcore: deregistering interface driver dvb_=
usb_ttusb2
Jan 15 15:35:31 seneca kernel: dvb-usb: bulk message failed: -22 (8/-30720)
Jan 15 15:35:31 seneca kernel: ttusb2: there might have been an error durin=
g control message transfer. (rlen =3D 3, was 0)
Jan 15 15:35:31 seneca kernel: ttusb2: i2c transfer failed.
Jan 15 15:35:31 seneca kernel: dvb-usb: bulk message failed: -22 (8/-30720)
Jan 15 15:35:31 seneca kernel: ttusb2: there might have been an error durin=
g control message transfer. (rlen =3D 4, was 0)
Jan 15 15:35:31 seneca kernel: ttusb2: i2c transfer failed.
Jan 15 15:35:31 seneca kernel: dvb-usb: bulk message failed: -22 (9/0)
Jan 15 15:35:31 seneca kernel: ttusb2: there might have been an error durin=
g control message transfer. (rlen =3D 3, was 0)
Jan 15 15:35:31 seneca kernel: ttusb2: i2c transfer failed.
Jan 15 15:35:31 seneca kernel: dvb-usb: Technotrend TT-connect S-2400 succe=
ssfully deinitialized and disconnected.

Jan 15 15:36:40 seneca kernel: dvb-usb: found a 'Technotrend TT-connect S-2=
400' in warm state.
Jan 15 15:36:42 seneca kernel: dvb-usb: recv bulk message failed: -110
Jan 15 15:36:42 seneca kernel: ttusb2: there might have been an error durin=
g control message transfer. (rlen =3D 0, was 0)
Jan 15 15:36:42 seneca kernel: dvb-usb: will pass the complete MPEG2 transp=
ort stream to the software demuxer.
Jan 15 15:36:42 seneca kernel: DVB: registering new adapter (Technotrend TT=
-connect S-2400)
Jan 15 15:36:42 seneca kernel: DVB: registering adapter 1 frontend 0 (Phili=
ps TDA10086 DVB-S)...
Jan 15 15:36:45 seneca kernel: dvb-usb: recv bulk message failed: -110
Jan 15 15:36:45 seneca kernel: ttusb2: there might have been an error durin=
g control message transfer. (rlen =3D 0, was 0)
Jan 15 15:36:45 seneca kernel: dvb-usb: Technotrend TT-connect S-2400 succe=
ssfully initialized and connected.
Jan 15 15:36:45 seneca kernel: usbcore: registered new interface driver dvb=
_usb_ttusb2

Jan 15 15:39:28 seneca kernel: usbcore: deregistering interface driver dvb_=
usb_ttusb2
Jan 15 15:39:28 seneca kernel: dvb-usb: bulk message failed: -22 (8/-30720)
Jan 15 15:39:28 seneca kernel: ttusb2: there might have been an error durin=
g control message transfer. (rlen =3D 3, was 0)
Jan 15 15:39:28 seneca kernel: ttusb2: i2c transfer failed.
Jan 15 15:39:28 seneca kernel: dvb-usb: bulk message failed: -22 (8/4)
Jan 15 15:39:28 seneca kernel: ttusb2: there might have been an error durin=
g control message transfer. (rlen =3D 4, was 0)
Jan 15 15:39:28 seneca kernel: ttusb2: i2c transfer failed.
Jan 15 15:39:28 seneca kernel: dvb-usb: bulk message failed: -22 (9/-30720)
Jan 15 15:39:28 seneca kernel: ttusb2: there might have been an error durin=
g control message transfer. (rlen =3D 3, was 0)
Jan 15 15:39:28 seneca kernel: ttusb2: i2c transfer failed.
Jan 15 15:39:28 seneca kernel: dvb-usb: bulk message failed: -22 (9/5)
Jan 15 15:39:28 seneca kernel: ttusb2: there might have been an error durin=
g control message transfer. (rlen =3D 3, was 0)
Jan 15 15:39:28 seneca kernel: ttusb2: i2c transfer failed.
Jan 15 15:39:28 seneca kernel: dvb-usb: bulk message failed: -22 (8/0)
Jan 15 15:39:28 seneca kernel: ttusb2: there might have been an error durin=
g control message transfer. (rlen =3D 4, was 0)
Jan 15 15:39:28 seneca kernel: ttusb2: i2c transfer failed.
Jan 15 15:39:28 seneca kernel: dvb-usb: bulk message failed: -22 (9/0)
Jan 15 15:39:28 seneca kernel: ttusb2: there might have been an error durin=
g control message transfer. (rlen =3D 3, was 0)
Jan 15 15:39:28 seneca kernel: ttusb2: i2c transfer failed.
Jan 15 15:39:28 seneca kernel: BUG: unable to handle kernel paging request =
at ffff8800c404a800
Jan 15 15:39:28 seneca kernel: IP: [<ffff8800c404a800>] 0xffff8800c404a800
Jan 15 15:39:28 seneca kernel: PGD 202063 PUD 12067 PMD 80000000c40001e3=20
Jan 15 15:39:28 seneca kernel: Oops: 0011 [1] SMP=20
Jan 15 15:39:28 seneca kernel: last sysfs file: /sys/devices/system/cpu/cpu=
1/cache/index2/shared_cpu_map
Jan 15 15:39:28 seneca kernel: CPU 1=20
Jan 15 15:39:28 seneca kernel: Modules linked in: lnbp21(N) tda826x(N) tda1=
0086(N) dvb_usb_ttusb2(N-) dvb_usb_pctv452e(N) dvb_usb(N) ttpci_eeprom(N) l=
nbp22(N) stb0899(N) stb6100(N) dvb_core(N) vboxnetadp(N) vboxnetflt(N) vbox=
drv(N) nls_iso8859_1 nls_cp437 vfat fat usb_storage af_packet nfsd lockd nf=
s_acl auth_rpcgss sunrpc exportfs mga drm snd_pcm_oss snd_mixer_oss snd_seq=
 binfmt_misc w83627ehf(N) hwmon_vid cpufreq_conservative cpufreq_userspace =
cpufreq_powersave powernow_k8 fuse ext3 jbd mbcache cryptoloop loop snd_usb=
_audio snd_pcm snd_timer snd_page_alloc snd_usb_lib snd_rawmidi snd_seq_dev=
ice k8temp(N) 8139too 8139cp snd_hwdep pcspkr snd usblp soundcore shpchp pc=
i_hotplug r8169 i2c_nforce2 mii i2c_core sg sr_mod cdrom button rtc_cmos rt=
c_core rtc_lib linear usbhid hid ff_memless ohci_hcd sd_mod crc_t10dif ehci=
_hcd usbcore dm_snapshot edd dm_mod xfs fan ide_pci_generic amd74xx ide_cor=
e ata_generic pata_jmicron pata_amd thermal processor thermal_sys hwmon ahc=
i libata scsi_mod dock [last unloaded: dvb_core]
Jan 15 15:39:28 seneca kernel: Supported: No
Jan 15 15:39:28 seneca kernel: Pid: 17379, comm: rmmod Tainted: G          =
2.6.27.42-0.1-default #1
Jan 15 15:39:28 seneca kernel: RIP: 0010:[<ffff8800c404a800>]  [<ffff8800c4=
04a800>] 0xffff8800c404a800
Jan 15 15:39:28 seneca kernel: RSP: 0018:ffff88005e41ddc0  EFLAGS: 00010286
Jan 15 15:39:28 seneca kernel: RAX: ffff8800c404a800 RBX: ffff8800b7da9030 =
RCX: ffffffffa0642000
Jan 15 15:39:28 seneca kernel: RDX: ffffffffa0642d40 RSI: ffffffffa0640718 =
RDI: ffff8800c404a810
Jan 15 15:39:28 seneca kernel: RBP: ffff8800c404a810 R08: 00000000ffffffff =
R09: ffff8800c404a810
Jan 15 15:39:28 seneca kernel: R10: 000000000000000a R11: 000000010001000e =
R12: 0000000000000001
Jan 15 15:39:28 seneca kernel: R13: ffff8800b7da8670 R14: ffffffffa0637e48 =
R15: 0000000000000000
Jan 15 15:39:28 seneca kernel: FS:  00007f7c813036f0(0000) GS:ffff88012fad0=
340(0000) knlGS:00000000f3147b90
Jan 15 15:39:28 seneca kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 00000000800=
5003b
Jan 15 15:39:28 seneca kernel: CR2: ffff8800c404a800 CR3: 000000005e47c000 =
CR4: 00000000000006e0
Jan 15 15:39:28 seneca kernel: DR0: 0000000000000000 DR1: 0000000000000000 =
DR2: 0000000000000000
Jan 15 15:39:28 seneca kernel: DR3: 0000000000000000 DR6: 00000000ffff0ff0 =
DR7: 0000000000000400
Jan 15 15:39:28 seneca kernel: Process rmmod (pid: 17379, threadinfo ffff88=
005e41c000, task ffff8800529fa400)
Jan 15 15:39:28 seneca kernel: Stack:  ffffffffa0601edd ffff88005e412e00 ff=
ff8800b7da9030 ffff8800b7da8000
Jan 15 15:39:28 seneca kernel:  ffffffffa0628e49 ffff8800b7da9030 ffffffffa=
06283e8 ffff88004a66e800
Jan 15 15:39:28 seneca kernel:  ffffffffa0636cc3 ffff880110010430 ffff88011=
0010400 ffff88004a66e800
Jan 15 15:39:28 seneca kernel: Call Trace:
Jan 15 15:39:28 seneca kernel: Inexact backtrace:
Jan 15 15:39:28 seneca kernel:=20
Jan 15 15:39:28 seneca kernel:  [<ffffffffa0601edd>] ? dvb_frontend_detach+=
0x51/0x7d [dvb_core]
Jan 15 15:39:28 seneca kernel:  [<ffffffffa0628e49>] ? dvb_usb_adapter_fron=
tend_exit+0x21/0x25 [dvb_usb]
Jan 15 15:39:28 seneca kernel:  [<ffffffffa06283e8>] ? dvb_usb_exit+0x54/0x=
de [dvb_usb]
Jan 15 15:39:28 seneca kernel:  [<ffffffffa06284af>] ? dvb_usb_device_exit+=
0x3d/0x4f [dvb_usb]
Jan 15 15:39:28 seneca kernel:  [<ffffffffa0167bd5>] ? usb_unbind_interface=
+0x5c/0xb7 [usbcore]
Jan 15 15:39:28 seneca kernel:  [<ffffffff803e6de5>] ? __device_release_dri=
ver+0x95/0xba
Jan 15 15:39:28 seneca kernel:  [<ffffffff803e6e88>] ? driver_detach+0x7e/0=
xab
Jan 15 15:39:28 seneca kernel:  [<ffffffff803e60e6>] ? bus_remove_driver+0x=
c3/0xf3
Jan 15 15:39:28 seneca kernel:  [<ffffffffa0167a03>] ? usb_deregister+0x90/=
0x99 [usbcore]
Jan 15 15:39:28 seneca kernel:  [<ffffffff802614fc>] ? sys_delete_module+0x=
214/0x289
Jan 15 15:39:28 seneca kernel:  [<ffffffff80364118>] ? __up_write+0x21/0x10f
Jan 15 15:39:28 seneca kernel:  [<ffffffff8020bffb>] ? system_call_fastpath=
+0x16/0x1b
Jan 15 15:39:28 seneca kernel:=20
Jan 15 15:39:28 seneca kernel:=20
Jan 15 15:39:28 seneca kernel: Code: 00 00 00 00 00 00 00 00 00 00 00 00 00=
 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00=
 00 00 00 00 00 <08> 8d da b7 00 88 ff ff 20 a5 63 a0 ff ff ff ff 50 68 69 =
6c 69=20
Jan 15 15:39:29 seneca kernel: RIP  [<ffff8800c404a800>] 0xffff8800c404a800
Jan 15 15:39:29 seneca kernel:  RSP <ffff88005e41ddc0>
Jan 15 15:39:29 seneca kernel: CR2: ffff8800c404a800
Jan 15 15:39:29 seneca kernel: ---[ end trace c28d08190c89a184 ]---




Jan 15 15:51:25 seneca kernel: dvb-usb: found a 'Technotrend TT-connect S-2=
400' in warm state.
Jan 15 15:51:27 seneca kernel: dvb-usb: recv bulk message failed: -110
Jan 15 15:51:27 seneca kernel: ttusb2: there might have been an error durin=
g control message transfer. (rlen =3D 0, was 0)
Jan 15 15:51:27 seneca kernel: dvb-usb: will pass the complete MPEG2 transp=
ort stream to the software demuxer.
Jan 15 15:51:27 seneca kernel: DVB: registering new adapter (Technotrend TT=
-connect S-2400)
Jan 15 15:51:27 seneca kernel: DVB: registering adapter 1 frontend 0 (Phili=
ps TDA10086 DVB-S)...
Jan 15 15:51:29 seneca kernel: dvb-usb: recv bulk message failed: -110
Jan 15 15:51:29 seneca kernel: ttusb2: there might have been an error durin=
g control message transfer. (rlen =3D 0, was 0)
Jan 15 15:51:29 seneca kernel: dvb-usb: Technotrend TT-connect S-2400 succe=
ssfully initialized and connected.
Jan 15 15:51:29 seneca kernel: usbcore: registered new interface driver dvb=
_usb_ttusb2
=2E..
Jan 15 15:51:31 seneca kernel: pctv452e_power_ctrl: 1
Jan 15 15:51:32 seneca vdr: [6211] device 1 provides DVB-S2 ("STB0899 Multi=
standard")
Jan 15 15:51:32 seneca vdr: [6211] device 2 provides DVB-S ("Philips TDA100=
86 DVB-S")
Jan 15 15:51:32 seneca vdr: [6211] found 2 video devices
=2E..
Jan 15 15:51:36 seneca vdr: [6211] switching to channel 1
Jan 15 15:51:36 seneca kernel: BUG: unable to handle kernel paging request =
at ffff8800ce529c00
Jan 15 15:51:36 seneca kernel: IP: [<ffff8800ce529c00>] 0xffff8800ce529c00
Jan 15 15:51:36 seneca kernel: PGD 202063 PUD 12067 PMD 80000000ce4001e3=20
Jan 15 15:51:36 seneca kernel: Oops: 0011 [1] SMP=20
Jan 15 15:51:36 seneca kernel: last sysfs file: /sys/devices/system/cpu/cpu=
1/cache/index2/shared_cpu_map
Jan 15 15:51:36 seneca kernel: CPU 1=20
Jan 15 15:51:36 seneca kernel: Modules linked in: lnbp21(N) tda826x(N) tda1=
0086(N) dvb_usb_ttusb2(N) dvb_usb_pctv452e(N) dvb_usb(N) ttpci_eeprom(N) ln=
bp22(N) stb0899(N) stb6100(N) dvb_core(N) af_packet nfsd lockd nfs_acl auth=
_rpcgss sunrpc exportfs mga drm w83627ehf(N) binfmt_misc snd_pcm_oss snd_mi=
xer_oss hwmon_vid snd_seq vboxnetadp(N) vboxnetflt(N) vboxdrv(N) cpufreq_co=
nservative cpufreq_userspace cpufreq_powersave powernow_k8 fuse ext3 jbd mb=
cache cryptoloop loop snd_usb_audio snd_pcm snd_timer snd_page_alloc snd_us=
b_lib snd_rawmidi 8139too snd_seq_device 8139cp snd_hwdep snd rtc_cmos rtc_=
core shpchp soundcore pcspkr r8169 usblp pci_hotplug k8temp(N) i2c_nforce2 =
rtc_lib mii sr_mod button i2c_core cdrom sg linear usbhid hid ff_memless oh=
ci_hcd sd_mod ehci_hcd crc_t10dif usbcore dm_snapshot edd dm_mod xfs fan id=
e_pci_generic amd74xx ide_core ata_generic pata_jmicron pata_amd thermal pr=
ocessor thermal_sys hwmon ahci libata scsi_mod dock [last unloaded: tda1008=
6]
Jan 15 15:51:36 seneca kernel: Supported: No
Jan 15 15:51:36 seneca kernel: Pid: 6227, comm: tuner on device Tainted: G =
         2.6.27.42-0.1-default #1
Jan 15 15:51:36 seneca kernel: RIP: 0010:[<ffff8800ce529c00>]  [<ffff8800ce=
529c00>] 0xffff8800ce529c00
Jan 15 15:51:36 seneca kernel: RSP: 0018:ffff8800c7a43d90  EFLAGS: 00010286
Jan 15 15:51:36 seneca kernel: RAX: ffff8800ce529c00 RBX: ffff880104547c10 =
RCX: 0000000000000000
Jan 15 15:51:36 seneca kernel: RDX: 0000000000000002 RSI: ffff8800c7a33a40 =
RDI: ffff880104547c10
Jan 15 15:51:36 seneca kernel: RBP: ffff8801030f6501 R08: ffffffffa05f7fb4 =
R09: 0000000000000002
Jan 15 15:51:36 seneca kernel: R10: 0000000000000000 R11: 0000000000000282 =
R12: ffff8800c7a33a40
Jan 15 15:51:36 seneca kernel: R13: 0000000000000000 R14: 0000000000000000 =
R15: ffff8800c7a43e28
Jan 15 15:51:36 seneca kernel: FS:  00007fdcfeffd950(0000) GS:ffff88012fad0=
340(0000) knlGS:00000000f75a06c0
Jan 15 15:51:36 seneca kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 00000000800=
5003b
Jan 15 15:51:36 seneca kernel: CR2: ffff8800ce529c00 CR3: 00000000c78ba000 =
CR4: 00000000000006e0
Jan 15 15:51:36 seneca kernel: DR0: 0000000000000000 DR1: 0000000000000000 =
DR2: 0000000000000000
Jan 15 15:51:36 seneca kernel: DR3: 0000000000000000 DR6: 00000000ffff0ff0 =
DR7: 0000000000000400
Jan 15 15:51:36 seneca kernel: Process tuner on device (pid: 6227, threadin=
fo ffff8800c7a42000, task ffff88012bde83c0)
Jan 15 15:51:36 seneca kernel: Stack:  ffffffffa05f81a7 ffff8800ce453180 ff=
ff8800c789d118 ffff8801030f65b0
Jan 15 15:51:36 seneca kernel:  00000000280642b8 ffff8800c7a33a40 ffff88010=
4547f30 ffff8801030f6400
Jan 15 15:51:36 seneca kernel:  0000000040106f52 00007fdcfeffd020 ffff8800c=
7a43e28 0000000000000000
Jan 15 15:51:36 seneca kernel: Call Trace:
Jan 15 15:51:36 seneca kernel: Inexact backtrace:
Jan 15 15:51:36 seneca kernel:=20
Jan 15 15:51:36 seneca kernel:  [<ffffffffa05f81a7>] ? dvb_frontend_ioctl+0=
x1f3/0xbec [dvb_core]
Jan 15 15:51:36 seneca kernel:  [<ffffffffa05f02a0>] ? dvb_usercopy+0xa3/0x=
ff [dvb_core]
Jan 15 15:51:36 seneca vdr: [6238] vdr-fritzbox - FritzFonbook.cpp: read 0 =
entries.
Jan 15 15:51:36 seneca kernel:  [<ffffffffa05f7fb4>] ? dvb_frontend_ioctl+0=
x0/0xbec [dvb_core]
Jan 15 15:51:36 seneca kernel:  [<ffffffff8025a6d1>] ? futex_wake+0x61/0xea
Jan 15 15:51:36 seneca kernel:  [<ffffffff802bd622>] ? vfs_ioctl+0x56/0x6c
Jan 15 15:51:36 seneca kernel:  [<ffffffff802bd85a>] ? do_vfs_ioctl+0x222/0=
x231
Jan 15 15:51:36 seneca kernel:  [<ffffffff802bd8ba>] ? sys_ioctl+0x51/0x73
Jan 15 15:51:36 seneca kernel:  [<ffffffff8020bffb>] ? system_call_fastpath=
+0x16/0x1b
Jan 15 15:51:36 seneca kernel:=20
Jan 15 15:51:36 seneca kernel:=20
Jan 15 15:51:36 seneca kernel: Code: 00 00 00 00 00 00 00 00 00 00 00 00 64=
 61 74 61 00 67 65 74 5f 45 78 65 52 6f 61 6d 69 6e 67 43 6f 6e 66 69 67 44=
 69 72 65 63 74 <44> 00 ff 03 00 e2 ff ff 08 8d 86 cb 00 88 ff ff 00 00 00 =
00 00=20
Jan 15 15:51:36 seneca vdr: [6211] ERROR (svdrp.c,129): Das Argument ist un=
g=FCltig
Jan 15 15:51:36 seneca kernel: RIP  [<ffff8800ce529c00>] 0xffff8800ce529c00
Jan 15 15:51:37 seneca kernel:  RSP <ffff8800c7a43d90>
Jan 15 15:51:37 seneca kernel: CR2: ffff8800ce529c00
Jan 15 15:51:37 seneca kernel: ---[ end trace be5c44b6403925b1 ]---
Jan 15 15:51:37 seneca vdr: [6211] ERROR (svdrp.c,129): Das Argument ist un=
g=FCltig
Jan 15 15:51:37 seneca vdr: [6211] ERROR (svdrp.c,129): Das Argument ist un=
g=FCltig
Jan 15 15:51:37 seneca vdr: [6211] ERROR (svdrp.c,129): Das Argument ist un=
g=FCltig
Jan 15 15:51:37 seneca vdr: [6211] ERROR (svdrp.c,129): Das Argument ist un=
g=FCltig
=2E..


Jan 16 15:35:53 seneca kernel: dvb-usb: found a 'Technotrend TT-connect S-2=
400' in warm state.
Jan 16 15:35:55 seneca kernel: dvb-usb: recv bulk message failed: -110
Jan 16 15:35:55 seneca kernel: ttusb2: there might have been an error durin=
g control message transfer. (rlen =3D 0, was 0)
Jan 16 15:35:55 seneca kernel: dvb-usb: will pass the complete MPEG2 transp=
ort stream to the software demuxer.
Jan 16 15:35:55 seneca kernel: DVB: registering new adapter (Technotrend TT=
-connect S-2400)
Jan 16 15:35:55 seneca kernel: DVB: registering adapter 0 frontend 0 (Phili=
ps TDA10086 DVB-S)...
Jan 16 15:35:57 seneca kernel: dvb-usb: recv bulk message failed: -110
Jan 16 15:35:57 seneca kernel: ttusb2: there might have been an error durin=
g control message transfer. (rlen =3D 0, was 0)
Jan 16 15:35:57 seneca kernel: dvb-usb: Technotrend TT-connect S-2400 succe=
ssfully initialized and connected.
Jan 16 15:35:57 seneca kernel: usbcore: registered new interface driver dvb=
_usb_ttusb2
Jan 16 15:36:02 seneca kernel: usbcore: deregistering interface driver dvb_=
usb_ttusb2
Jan 16 15:36:02 seneca kernel: dvb-usb: bulk message failed: -22 (8/-30719)
Jan 16 15:36:02 seneca kernel: ttusb2: there might have been an error durin=
g control message transfer. (rlen =3D 3, was 0)
Jan 16 15:36:02 seneca kernel: ttusb2: i2c transfer failed.
Jan 16 15:36:02 seneca kernel: dvb-usb: bulk message failed: -22 (8/4)
Jan 16 15:36:02 seneca kernel: ttusb2: there might have been an error durin=
g control message transfer. (rlen =3D 4, was 0)
Jan 16 15:36:02 seneca kernel: ttusb2: i2c transfer failed.
Jan 16 15:36:02 seneca kernel: dvb-usb: bulk message failed: -22 (9/-30720)
Jan 16 15:36:02 seneca kernel: ttusb2: there might have been an error durin=
g control message transfer. (rlen =3D 3, was 0)
Jan 16 15:36:02 seneca kernel: ttusb2: i2c transfer failed.
Jan 16 15:36:02 seneca kernel: dvb-usb: bulk message failed: -22 (9/5)
Jan 16 15:36:02 seneca kernel: ttusb2: there might have been an error durin=
g control message transfer. (rlen =3D 3, was 0)
Jan 16 15:36:02 seneca kernel: ttusb2: i2c transfer failed.
Jan 16 15:36:02 seneca kernel: dvb-usb: bulk message failed: -22 (8/0)
Jan 16 15:36:02 seneca kernel: ttusb2: there might have been an error durin=
g control message transfer. (rlen =3D 4, was 0)
Jan 16 15:36:02 seneca kernel: ttusb2: i2c transfer failed.
Jan 16 15:36:02 seneca kernel: dvb-usb: bulk message failed: -22 (9/0)
Jan 16 15:36:02 seneca kernel: ttusb2: there might have been an error durin=
g control message transfer. (rlen =3D 3, was 0)
Jan 16 15:36:02 seneca kernel: ttusb2: i2c transfer failed.
Jan 16 15:36:02 seneca kernel: BUG: unable to handle kernel paging request =
at ffff88012b958000
Jan 16 15:36:02 seneca kernel: IP: [<ffff88012b958000>] 0xffff88012b958000
Jan 16 15:36:02 seneca kernel: PGD 202063 PUD 14067 PMD 800000012b8001e3=20
Jan 16 15:36:02 seneca kernel: Oops: 0011 [1] SMP=20
Jan 16 15:36:02 seneca kernel: last sysfs file: /sys/devices/system/cpu/cpu=
1/cache/index2/shared_cpu_map
Jan 16 15:36:02 seneca kernel: CPU 0=20
Jan 16 15:36:02 seneca kernel: Modules linked in: lnbp21(N) tda826x(N) tda1=
0086(N) dvb_usb_ttusb2(N-) dvb_usb(N) dvb_core(N) vboxnetadp(N) vboxnetflt(=
N) vboxdrv(N) af_packet nfsd lockd nfs_acl auth_rpcgss sunrpc exportfs mga =
drm snd_pcm_oss snd_mixer_oss snd_seq w83627ehf(N) hwmon_vid binfmt_misc cp=
ufreq_conservative cpufreq_userspace cpufreq_powersave powernow_k8 fuse ext=
3 jbd mbcache cryptoloop loop snd_usb_audio snd_pcm snd_timer snd_page_allo=
c snd_usb_lib 8139too 8139cp snd_rawmidi snd_seq_device snd_hwdep pcspkr sr=
_mod rtc_cmos k8temp(N) shpchp button snd i2c_nforce2 cdrom soundcore pci_h=
otplug usblp rtc_core r8169 i2c_core rtc_lib mii sg linear usbhid hid ff_me=
mless ohci_hcd ehci_hcd sd_mod crc_t10dif usbcore dm_snapshot edd dm_mod xf=
s fan ide_pci_generic amd74xx ide_core ata_generic pata_jmicron pata_amd th=
ermal processor thermal_sys hwmon ahci libata scsi_mod dock [last unloaded:=
 tda10086]
Jan 16 15:36:02 seneca kernel: Supported: No
Jan 16 15:36:02 seneca kernel: Pid: 12526, comm: rmmod Tainted: G          =
2.6.27.42-0.1-default #1
Jan 16 15:36:02 seneca kernel: RIP: 0010:[<ffff88012b958000>]  [<ffff88012b=
958000>] 0xffff88012b958000
Jan 16 15:36:02 seneca kernel: RSP: 0018:ffff8800589d1dc0  EFLAGS: 00010286
Jan 16 15:36:02 seneca kernel: RAX: ffff88012b958000 RBX: ffff88009a959030 =
RCX: ffffffffa024c000
Jan 16 15:36:02 seneca kernel: RDX: ffffffffa024cd40 RSI: ffffffffa024a718 =
RDI: ffff88012b958010
Jan 16 15:36:03 seneca kernel: RBP: ffff88012b958010 R08: 00000000ffffffff =
R09: ffff88012b958010
Jan 16 15:36:03 seneca kernel: R10: 000000000000000a R11: 000000010001000e =
R12: 0000000000000001
Jan 16 15:36:03 seneca kernel: R13: ffff88009a958670 R14: ffffffffa0241e48 =
R15: 0000000000000000
Jan 16 15:36:03 seneca kernel: FS:  00007fb7f1e0f6f0(0000) GS:ffffffff80a43=
080(0000) knlGS:00000000f317ab90
Jan 16 15:36:03 seneca kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 00000000800=
5003b
Jan 16 15:36:03 seneca kernel: CR2: ffff88012b958000 CR3: 00000000cb0d5000 =
CR4: 00000000000006e0
Jan 16 15:36:03 seneca kernel: DR0: 0000000000000000 DR1: 0000000000000000 =
DR2: 0000000000000000
Jan 16 15:36:03 seneca kernel: DR3: 0000000000000000 DR6: 00000000ffff0ff0 =
DR7: 0000000000000400
Jan 16 15:36:03 seneca kernel: Process rmmod (pid: 12526, threadinfo ffff88=
00589d0000, task ffff880054c4a6c0)
Jan 16 15:36:03 seneca kernel: Stack:  ffffffffa05f5edd ffff88012d1f3300 ff=
ff88009a959030 ffff88009a958000
Jan 16 15:36:03 seneca kernel:  ffffffffa0239e49 ffff88009a959030 ffffffffa=
02393e8 ffff88012c820800
Jan 16 15:36:03 seneca kernel:  ffffffffa0240cc3 ffff88012cc50430 ffff88012=
cc50400 ffff88012c820800
Jan 16 15:36:03 seneca kernel: Call Trace:
Jan 16 15:36:03 seneca kernel: Inexact backtrace:
Jan 16 15:36:03 seneca kernel:=20
Jan 16 15:36:03 seneca kernel:  [<ffffffffa05f5edd>] ? dvb_frontend_detach+=
0x51/0x7d [dvb_core]
Jan 16 15:36:03 seneca kernel:  [<ffffffffa0239e49>] ? dvb_usb_adapter_fron=
tend_exit+0x21/0x25 [dvb_usb]
Jan 16 15:36:03 seneca kernel:  [<ffffffffa02393e8>] ? dvb_usb_exit+0x54/0x=
de [dvb_usb]
Jan 16 15:36:03 seneca kernel:  [<ffffffffa02394af>] ? dvb_usb_device_exit+=
0x3d/0x4f [dvb_usb]
Jan 16 15:36:03 seneca kernel:  [<ffffffffa0167bd5>] ? usb_unbind_interface=
+0x5c/0xb7 [usbcore]
Jan 16 15:36:03 seneca kernel:  [<ffffffff803e6de5>] ? __device_release_dri=
ver+0x95/0xba
Jan 16 15:36:03 seneca kernel:  [<ffffffff803e6e88>] ? driver_detach+0x7e/0=
xab
Jan 16 15:36:03 seneca kernel:  [<ffffffff803e60e6>] ? bus_remove_driver+0x=
c3/0xf3
Jan 16 15:36:03 seneca kernel:  [<ffffffffa0167a03>] ? usb_deregister+0x90/=
0x99 [usbcore]
Jan 16 15:36:03 seneca kernel:  [<ffffffff802614fc>] ? sys_delete_module+0x=
214/0x289
Jan 16 15:36:03 seneca kernel:  [<ffffffff80364118>] ? __up_write+0x21/0x10f
Jan 16 15:36:03 seneca kernel:  [<ffffffff8020bffb>] ? system_call_fastpath=
+0x16/0x1b
Jan 16 15:36:03 seneca kernel:=20
Jan 16 15:36:03 seneca kernel:=20
Jan 16 15:36:03 seneca kernel: Code: 55 00 4c 8b 58 10 48 8d 05 5e b8 01 00=
 41 80 7b 1d 00 4c 0f 45 c0 45 85 d2 0f 8e ac 00 00 00 31 f6 31 c9 49 8b b9=
 a8 03 00 00 eb <08> 8d 95 9a 00 88 ff ff 20 45 24 a0 ff ff ff ff 50 68 69 =
6c 69=20
Jan 16 15:36:03 seneca kernel: RIP  [<ffff88012b958000>] 0xffff88012b958000
Jan 16 15:36:03 seneca kernel:  RSP <ffff8800589d1dc0>
Jan 16 15:36:03 seneca kernel: CR2: ffff88012b958000
Jan 16 15:36:03 seneca kernel: ---[ end trace 32bb07b47e72b634 ]---




--OgqxwSJOaUobr8KG
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--OgqxwSJOaUobr8KG--
