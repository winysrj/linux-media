Return-path: <linux-media-owner@vger.kernel.org>
Received: from web37607.mail.mud.yahoo.com ([209.191.87.90]:31026 "HELO
	web37607.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753226Ab0AZRZk (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 26 Jan 2010 12:25:40 -0500
Message-ID: <834871.34078.qm@web37607.mail.mud.yahoo.com>
Date: Tue, 26 Jan 2010 09:18:58 -0800 (PST)
From: Emil Meier <emil276me@yahoo.com>
Subject: Kernel oops after vbi access on a dvb-t device
To: linux-media@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,
after updating the kernel from 2.6.31.6 to 2.6.32.4 I get oops when I use alevtv on a dvb-demux device.
I get the same result on 3 different systems with 3 different TV-cards. 
With v4l-dvb-59e746a1c5d1 snapshoot I get the same result on a 64bit machine with a hvr-1400 card.
Here is the oputput of a hvr-1900 card:

Command causing the oop and the resulting output::
-------------------------------------------
$ alevt -dev /dev/dvb/adapter0/demux0 
alevt: SDT: service_id 0x4082 not in PAT

Service ID 0x0xxx Type 0x01 Provider Name "XXXXXXXX" Name "XXX"
  PMT PID 0x0xxx TXT: PID 0x0xxx lang xxx type 0x01 magazine 1 page   0
Service ID 0x0xxx Type 0x01 Provider Name "XXXXXX" Name "XXX"
  PMT PID 0x0xxx TXT: PID 0x0xxx lang xxx type 0x01 magazine 1 page   0
Service ID 0x0xxx Type 0x01 Provider Name "XXX" Name "XXX"
  PMT PID 0x0xxx TXT: PID 0x0xxx lang xxx type 0x01 magazine 1 page   0
Service ID 0x0xxx Type 0x01 Provider Name "XXX" Name "XXX"
  PMT PID 0x0xxx TXT: PID 0x0xxx lang xxx type 0x01 magazine 1 page   0
Using: Service ID 0x0202 Type 0x01 Provider Name "XXX" Name "XXX"
  PMT PID 0x0xxx TXT: PID 0x0xxx lang xxx type 0x01 magazine 1 page   0
alevt: ioctl: DMX_SET_PES_FILTER Invalid argument (22)
Killed
---------------------------------------------
dmesg output:
pvrusb2: registered device video1 [mpeg]
DVB: registering new adapter (pvrusb2-dvb)
cx25840 6-0044: firmware: requesting v4l-cx25840.fw
cx25840 6-0044: loaded v4l-cx25840.fw firmware (16382 bytes)
tda829x 6-0042: setting tuner address to 60
tda18271 6-0060: creating new instance
TDA18271HD/C1 detected @ 6-0060
tda829x 6-0042: type set to tda8295+18271
usb 1-2: firmware: requesting v4l-cx2341x-enc.fw
cx25840 6-0044: 0x0000 is not a valid video input!
DVB: registering adapter 0 frontend 0 (NXP TDA10048HN DVB-T)...
tda829x 6-0042: type set to tda8295
tda18271 6-0060: attaching existing instance
tda10048_firmware_upload: waiting for firmware upload (dvb-fe-tda10048-1.0.fw)...
usb 1-2: firmware: requesting dvb-fe-tda10048-1.0.fw
tda10048_firmware_upload: firmware read 24878 bytes.
tda10048_firmware_upload: firmware uploading
tda10048_firmware_upload: firmware uploaded
BUG: unable to handle kernel NULL pointer dereference at (null)
IP: [<ffffffffa0cf856f>] dvb_demux_release+0x62/0x1c4 [dvb_core]
PGD 20514a067 PUD 1cbd17067 PMD 0 
Oops: 0000 [#1] SMP 
last sysfs file: /sys/devices/pci0000:00/0000:00:18.3/temp3_input
CPU 1 
Modules linked in: tda10048 tda18271 tda8290 cx25840 pvrusb2 dvb_core cx2341x bridge w83627ehf hwmon_vid stp llc bnep rfcomm l2cap crc16 snd_pcm_oss snd_mixer_oss snd_seq snd_seq_device md5 des_generic cbc rpcsec_gss_krb5 nfs lockd nfs_acl auth_rpcgss sunrpc af_packet cpufreq_conservative cpufreq_userspace cpufreq_powersave powernow_k8 fuse dm_crypt vfat fat loop dm_mod snd_hda_codec_realtek tuner_simple tuner_types tuner tvaudio tda7432 msp3400 bttv v4l2_common videodev v4l1_compat snd_hda_intel v4l2_compat_ioctl32 ir_common i2c_algo_bit snd_hda_codec snd_pcm videobuf_dma_sg ppdev snd_timer videobuf_core btusb btcx_risc parport_pc tveeprom nvidia(P) i2c_nforce2 snd usb_storage r8169 bluetooth soundcore parport i2c_core rtc_cmos button k8temp mii snd_page_alloc sr_mod rfkill cdrom floppy sg ohci_hcd ehci_hcd sd_mod usbcore edd ext3 mbcache jbd fan ide_pci_generic amd74xx ide_core ahci pata_amd libata scsi_mod thermal processor thermal_sys hwmon
Pid: 12181, comm: alevt Tainted: P           2.6.32.4 #1 MS-xxxxx
RIP: 0010:[<ffffffffa0cf856f>]  [<ffffffffa0cf856f>] dvb_demux_release+0x62/0x1c4 [dvb_core]
RSP: 0018:ffff8801ce517ec8  EFLAGS: 00010246
RAX: 0000000000000000 RBX: 0000000000000008 RCX: 0000000000000003
RDX: 0000000000000000 RSI: ffff88022eeb9ec0 RDI: fffffffffffffff0
RBP: ffffc90011d4a420 R08: 0000000000000000 R09: 0000000000000000
R10: ffffffffffffffff R11: 0000000000000001 R12: ffffc90011d4a428
R13: ffff8802220ff8b8 R14: ffff8802220ff938 R15: ffff88022eeb9ec0
FS:  00007f4386d9f6f0(0000) GS:ffff880028300000(0000) knlGS:00000000f693c8d0
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 0000000000000000 CR3: 00000001ce797000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process alevt (pid: 12181, threadinfo ffff8801ce516000, task ffff880211093340)
Stack:
 ffffc90011d4a4d0 0000000000000008 ffff88022eeb9ec0 ffff8801f10fee40
<0> ffff88022b639d78 ffff88022b639d78 ffff880230054580 ffffffff810d3cde
<0> ffff8801f10fee40 ffff88022eeb9ec0 0000000000000000 ffff880230321780
Call Trace:
 [<ffffffff810d3cde>] ? __fput+0x100/0x1cb
 [<ffffffff810d121c>] ? filp_close+0x5b/0x62
 [<ffffffff810d12b6>] ? sys_close+0x93/0xcb
 [<ffffffff8100b9ab>] ? system_call_fastpath+0x16/0x1b
Code: 04 24 e8 d5 6d 59 e0 48 89 ef e8 fa fe ff ff 83 7d 58 01 0f 86 87 00 00 00 83 7d 54 02 75 58 48 8b 45 08 4c 8d 65 08 48 8d 78 f0 <48> 8b 47 10 48 8d 58 f0 eb 2f 48 8b 47 10 48 8b 57 18 48 89 50 
RIP  [<ffffffffa0cf856f>] dvb_demux_release+0x62/0x1c4 [dvb_core]
 RSP <ffff8801ce517ec8>
CR2: 0000000000000000
---[ end trace 6384db606bfe8853 ]---

Perhaps some one can have a look on this issue?

Thanks
Emil



      
