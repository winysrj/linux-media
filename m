Return-path: <mchehab@pedra>
Received: from proofpoint-cluster.metrocast.net ([65.175.128.136]:39758 "EHLO
	proofpoint-cluster.metrocast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752415Ab0IKOCa (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 11 Sep 2010 10:02:30 -0400
Subject: Re: Kernel Oops with Kernel 2.6.32
From: Andy Walls <awalls@md.metrocast.net>
To: Christoph Pleger <Christoph.Pleger@cs.tu-dortmund.de>
Cc: linux-media@vger.kernel.org,
	Patrick Boettcher <pboettcher@dibcom.fr>
In-Reply-To: <201009102306.55019.Christoph.Pleger@cs.tu-dortmund.de>
References: <201009102306.55019.Christoph.Pleger@cs.tu-dortmund.de>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 11 Sep 2010 10:02:16 -0400
Message-ID: <1284213736.2053.65.camel@morgan.silverblock.net>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@pedra>

On Fri, 2010-09-10 at 23:06 +0200, Christoph Pleger wrote:

> Hello,
> 
> I am running a Debian 2.6.32-Kernel (which by the way contains a lot of 
> unresolved symbols in many dvb modules). As this kernel does not support my 
> WinTV Nova-T USB-Stick, I downloaded the latest sources via the web interface 
> from linuxtv.org, compiled the sources and installed the resulting modules.
> 
> When I now connect the USB stick, the DVB modules are loaded correctly, but 
> when I start an application to watch TV, I get a Kernel Oops.

> These lines from my kern.log show the Oops event:
> Sep  8 19:51:28 superstar kernel: [ 3492.321914] BUG: unable to handle kernel 
> NULL pointer dereference at 0000000000000012
> Sep  8 19:51:28 superstar kernel: [ 3492.321920] IP: [<ffffffffa015e3db>] 
> i2c_transfer+0x1c/0xc0 [i2c_core]
> Sep  8 19:51:28 superstar kernel: [ 3492.321928] PGD 1b8e69067 PUD 1b8e6a067 
> PMD 0
> Sep  8 19:51:28 superstar kernel: [ 3492.321932] Oops: 0000 [#1] SMP
> Sep  8 19:51:28 superstar kernel: [ 3492.321934] last sysfs 
> file: /sys/devices/pci0000:00/0000:00:02.1/usb2/2-5/input/input6/capabilities/sw
> Sep  8 19:51:28 superstar kernel: [ 3492.321936] CPU 0
> Sep  8 19:51:28 superstar kernel: [ 3492.321938] Modules linked in: mt2060 
> dvb_usb_dib0700 dib7000p dib0090 dib7000m dib0070 dvb_usb dib8000 dvb_core 
> dib30
> 00mc dibx000_common fglrx(P) binfmt_misc rfcomm l2cap crc16 bluetooth rfkill 
> vboxnetadp vboxnetflt vboxdrv battery ppdev lp ext3 jbd mbcache xfs exportfs 
> r
> eiserfs hwmon_vid eeprom firewire_sbp2 firewire_core crc_itu_t loop 
> snd_hda_codec_atihdmi parport_pc parport psmouse evdev serio_raw 
> snd_emu10k1_synth snd_
> emux_synth snd_seq_virmidi snd_seq_midi_emul snd_hda_intel snd_hda_codec 
> snd_emu10k1 snd_ac97_codec ac97_bus snd_pcm_oss snd_mixer_oss snd_seq_midi 
> snd_pcm
>  snd_rawmidi snd_util_mem asus_atk0110 snd_seq_midi_event snd_hwdep snd_seq 
> snd_timer snd_seq_device emu10k1_gp pcspkr gameport snd snd_page_alloc 
> soundcor
> e k8temp edac_core edac_mce_amd button processor i2c_nforce2 i2c_core jfs 
> dm_mirror dm_region_hash dm_log dm_snapshot dm_mod sg sr_mod cdrom sd_mod 
> crc_t10
> dif ata_generic floppy fan pata_amd sata_nv ehci_hcd ohci_hcd libata thermal 
> forcedeth thermal_sys scsi_mod usbcore nls_base [last unloaded: 
> scsi_wait_scan
> ]
> Sep  8 19:51:28 superstar kernel: [ 3492.321984] Pid: 26841, comm: kaffeine 
> Tainted: P           2.6.32-bpo.5-amd64 #1 System Product Name
> Sep  8 19:51:28 superstar kernel: [ 3492.321986] RIP: 0010:
> [<ffffffffa015e3db>]  [<ffffffffa015e3db>] i2c_transfer+0x1c/0xc0 [i2c_core]
> Sep  8 19:51:28 superstar kernel: [ 3492.321990] RSP: 0018:ffff8801b95d9ba8  
> EFLAGS: 00010292
> Sep  8 19:51:28 superstar kernel: [ 3492.321992] RAX: ffff8801b95d9c08 RBX: 
> 0000000000000002 RCX: 0000000000000000
> Sep  8 19:51:28 superstar kernel: [ 3492.321994] RDX: 0000000000000002 RSI: 
> ffff8801b95d9be8 RDI: 0000000000000002
> Sep  8 19:51:28 superstar kernel: [ 3492.321995] RBP: 00000000ffffffa1 R08: 
> 000000000e008d80 R09: ffff880037803300
> Sep  8 19:51:28 superstar kernel: [ 3492.321997] R10: ffff880037803360 R11: 
> 0000000000000002 R12: ffff8802115a6800
> Sep  8 19:51:28 superstar kernel: [ 3492.321999] R13: 0000000000000001 R14: 
> 0000000000000002 R15: ffff8801b95d9be8
> Sep  8 19:51:28 superstar kernel: [ 3492.322001] FS:  00007f2765d656f0(0000) 
> GS:ffff880008c00000(0000) knlGS:0000000000000000
> Sep  8 19:51:28 superstar kernel: [ 3492.322003] CS:  0010 DS: 0000 ES: 0000 
> CR0: 000000008005003b
> Sep  8 19:51:28 superstar kernel: [ 3492.322004] CR2: 0000000000000012 CR3: 
> 00000001b8e68000 CR4: 00000000000006f0
> Sep  8 19:51:28 superstar kernel: [ 3492.322006] DR0: 0000000000000000 DR1: 
> 0000000000000000 DR2: 0000000000000000
> Sep  8 19:51:28 superstar kernel: [ 3492.322008] DR3: 0000000000000000 DR6: 
> 00000000ffff0ff0 DR7: 0000000000000400
> Sep  8 19:51:28 superstar kernel: [ 3492.322010] Process kaffeine (pid: 26841, 
> threadinfo ffff8801b95d8000, task ffff88022305b170)
> Sep  8 19:51:28 superstar kernel: [ 3492.322011] Stack:
> Sep  8 19:51:28 superstar kernel: [ 3492.322012]  ffff8801b8c09e18 
> 00000000000000eb ffffc90013b0c000 ffff8802115a6800
> Sep  8 19:51:28 superstar kernel: [ 3492.322015] <0> 0000000000000001 
> ffffc90012e51000 ffff8802115650c8 ffffffffa0271109
> Sep  8 19:51:28 superstar kernel: [ 3492.322017] <0> 0000000200000010 
> ffff8801b95d9c18 0000000200010010 ffff8801b95d9c08
> Sep  8 19:51:28 superstar kernel: [ 3492.322020] Call Trace:
> Sep  8 19:51:28 superstar kernel: [ 3492.322024]  [<ffffffffa0271109>] ? 
> dib7000p_read_word+0x6e/0xbe [dib7000p]
> Sep  8 19:51:28 superstar kernel: [ 3492.322027]  [<ffffffffa01fd05e>] ? 
> usb_urb_submit+0x3f/0x81 [dvb_usb]
> Sep  8 19:51:28 superstar kernel: [ 3492.322030]  [<ffffffffa0271cdb>] ? 
> dib7000p_pid_filter_ctrl+0x1e/0x74 [dib7000p]
> Sep  8 19:51:28 superstar kernel: [ 3492.322033]  [<ffffffffa01fc354>] ? 
> dvb_usb_ctrl_feed+0x16b/0x1ca [dvb_usb]
> Sep  8 19:51:28 superstar kernel: [ 3492.322038]  [<ffffffffa0393610>] ? 
> dmx_ts_feed_start_filtering+0x72/0xc6 [dvb_core]
> Sep  8 19:51:28 superstar kernel: [ 3492.322041]  [<ffffffffa039099e>] ? 
> dvb_dmxdev_start_feed+0xbe/0xe6 [dvb_core]
> Sep  8 19:51:28 superstar kernel: [ 3492.322045]  [<ffffffffa0391ae1>] ? 
> dvb_dmxdev_filter_start+0x2a9/0x315 [dvb_core]
> Sep  8 19:51:28 superstar kernel: [ 3492.322049]  [<ffffffffa0391dcf>] ? 
> dvb_dmxdev_add_pid+0x50/0xf6 [dvb_core]
> Sep  8 19:51:28 superstar kernel: [ 3492.322052]  [<ffffffffa03920e6>] ? 
> dvb_demux_do_ioctl+0x271/0x4b7 [dvb_core]
> Sep  8 19:51:28 superstar kernel: [ 3492.322055]  [<ffffffffa0390332>] ? 
> dvb_usercopy+0xb4/0x128 [dvb_core]
> Sep  8 19:51:28 superstar kernel: [ 3492.322059]  [<ffffffffa0391e75>] ? 
> dvb_demux_do_ioctl+0x0/0x4b7 [dvb_core]
> Sep  8 19:51:28 superstar kernel: [ 3492.322063]  [<ffffffff810f6e63>] ? 
> do_filp_open+0x4e4/0x94b
> Sep  8 19:51:28 superstar kernel: [ 3492.322066]  [<ffffffff810f8b83>] ? 
> vfs_ioctl+0x56/0x6c
> Sep  8 19:51:28 superstar kernel: [ 3492.322068]  [<ffffffff810f909c>] ? 
> do_vfs_ioctl+0x48d/0x4cb
> Sep  8 19:51:28 superstar kernel: [ 3492.322072]  [<ffffffff810e3e9d>] ? 
> virt_to_head_page+0x9/0x2a
> Sep  8 19:51:28 superstar kernel: [ 3492.322074]  [<ffffffff810f912b>] ? 
> sys_ioctl+0x51/0x70
> Sep  8 19:51:28 superstar kernel: [ 3492.322078]  [<ffffffff81010b42>] ? 
> system_call_fastpath+0x16/0x1b
> Sep  8 19:51:28 superstar kernel: [ 3492.322079] Code: c2 22 e1 15 a0 e8 0b d5 
> 0b e1 48 83 c4 18 c3 41 57 49 89 f7 41 56 41 89 d6 41 55 41 54 55 bd a1 ff ff 
> ff 53 48 89 fb 48 83 ec 08 <48> 8b 47 10 48 83 38 00 0f 84 87 00 00 00 65 48 
> 8b 04 25 c8 cb
> Sep  8 19:51:28 superstar kernel: [ 3492.322098] RIP  [<ffffffffa015e3db>] 
> i2c_transfer+0x1c/0xc0 [i2c_core]
> Sep  8 19:51:28 superstar kernel: [ 3492.322102]  RSP <ffff8801b95d9ba8>
> Sep  8 19:51:28 superstar kernel: [ 3492.322103] CR2: 0000000000000012
> Sep  8 19:51:28 superstar kernel: [ 3492.322105] ---[ end trace 
> 106578cacf144da6 ]---


This Ooops is happening in i2c-core.c:i2c_transfer():

        int i2c_transfer(struct i2c_adapter *adap, struct i2c_msg *msgs, int num)
        {
                unsigned long orig_jiffies;
                int ret, try; 
        [...]
                if (adap->algo->master_xfer) {   <---- Ooops is here. "adap" is bad


The value for "adap" is in register RDI: 0000000000000002, and that is
not a valid pointer.  There is a bug in dib7000p.c somewhere.

Do a 'hg log -v -p linux/drivers/media/dvb/frontends/dib7000p.c | less'
to see what might have changed.

That's about all I can do to help with this particular hardware.

Regards,
Andy


> What can I do to solve the problem?
> 
> Regards
>   Christoph


