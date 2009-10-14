Return-path: <linux-media-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.157]:44108 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758269AbZJNK2O (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 14 Oct 2009 06:28:14 -0400
Received: by fg-out-1718.google.com with SMTP id d23so1297818fga.1
        for <linux-media@vger.kernel.org>; Wed, 14 Oct 2009 03:26:26 -0700 (PDT)
Date: Wed, 14 Oct 2009 12:25:50 +0200
From: Giuseppe Borzi <gborzi@gmail.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Devin Heitmueller <dheitmueller@kernellabs.com>
Subject: Re: em28xx DVB modeswitching change: call for testers
Message-ID: <20091014122550.7c84bba5@ieee.org>
In-Reply-To: <829197380910132052w155116ecrcea808abe87a57a6@mail.gmail.com>
References: <829197380910132052w155116ecrcea808abe87a57a6@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/7v8ue/OUuS3Fup1TWFr_+5B"; protocol="application/pgp-signature"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--Sig_/7v8ue/OUuS3Fup1TWFr_+5B
Content-Type: multipart/mixed; boundary="MP_//e75pbI6hqgJg8TSxgRcklE"

--MP_//e75pbI6hqgJg8TSxgRcklE
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

> Hello all,
>=20
> I have setup a tree that removes the mode switching code when
> starting/stopping streaming.  If you have one of the em28xx dvb
> devices mentioned in the previous thread and volunteered to test,
> please try out the following tree:
>=20
> http://kernellabs.com/hg/~dheitmueller/em28xx-modeswitch
>=20
> In particular, this should work for those of you who reported problems
> with zl10353 based devices like the Pinnacle 320e (or Dazzle) and were
> using that one line change I sent this week.  It should also work with
> Antti's Reddo board without needing his patch to move the demod reset
> into the tuner_gpio.
>=20
> This also brings us one more step forward to setting up the locking
> properly so that applications cannot simultaneously open the analog
> and dvb side of the device.
>=20
> Thanks for your help,
>=20
> Devin
>=20
Hello Devin,
I've just downloaded, compiled and installed em28xx-modeswitch.
Unfortunately, it doesn't work and doesn't even
create /dev/dvb, /dev/videoX, /dev/vbiX. Only /dev/dsp1 is created.
The dmesg is attached to this email. As you can see it ends up in
errors.
One last note, I downloaded from the bz2 link.

Cheers.

--=20
***********************************************************
  Giuseppe Borzi, Assistant Professor at the
  University of Messina - Department of Civil Engineering
  Address: Contrada di Dio, Messina, I-98166, Italy
  Tel:     +390903977323
  Fax:     +390903977480
  email:   gborzi@ieee.org
  url:     http://ww2.unime.it/dic/gborzi/index.php
***********************************************************

--MP_//e75pbI6hqgJg8TSxgRcklE
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment; filename=dmesg.txt

usb 1-3.1: new high speed USB device using ehci_hcd and address 8
usb 1-3.1: configuration #1 chosen from 1 choice
em28xx: New device USB 2881 Video @ 480 Mbps (eb1a:2881, interface 0, class=
 0)
em28xx #0: chip ID is em2882/em2883
em28xx #0: i2c eeprom 00: 1a eb 67 95 1a eb 81 28 58 12 5c 00 6a 20 6a 00
em28xx #0: i2c eeprom 10: 00 00 04 57 64 57 00 00 60 f4 00 00 02 02 00 00
em28xx #0: i2c eeprom 20: 56 00 01 00 00 00 02 00 b8 00 00 00 5b 1e 00 00
em28xx #0: i2c eeprom 30: 00 00 20 40 20 80 02 20 10 02 00 00 00 00 00 00
em28xx #0: i2c eeprom 40: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
em28xx #0: i2c eeprom 50: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
em28xx #0: i2c eeprom 60: 00 00 00 00 00 00 00 00 00 00 20 03 55 00 53 00
em28xx #0: i2c eeprom 70: 42 00 20 00 32 00 38 00 38 00 31 00 20 00 56 00
em28xx #0: i2c eeprom 80: 69 00 64 00 65 00 6f 00 00 00 00 00 00 00 00 00
em28xx #0: i2c eeprom 90: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
em28xx #0: i2c eeprom a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
em28xx #0: i2c eeprom b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
em28xx #0: i2c eeprom c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
em28xx #0: i2c eeprom d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
em28xx #0: i2c eeprom e0: 5a 00 55 aa 79 55 54 03 00 17 98 01 00 00 00 00
em28xx #0: i2c eeprom f0: 0c 00 00 01 00 00 00 00 00 00 00 00 00 00 00 00
em28xx #0: EEPROM ID=3D 0x9567eb1a, EEPROM hash =3D 0xb8846b20
em28xx #0: EEPROM info:
em28xx #0:	AC97 audio (5 sample rates)
em28xx #0:	USB Remote wakeup capable
em28xx #0:	500mA max power
em28xx #0:	Table at 0x04, strings=3D0x206a, 0x006a, 0x0000
em28xx #0: Identified as Unknown EM2750/28xx video grabber (card=3D1)
em28xx #0: Your board has no unique USB ID.
em28xx #0: A hint were successfully done, based on eeprom hash.
em28xx #0: This method is not 100% failproof.
em28xx #0: If the board were missdetected, please email this log to:
em28xx #0: 	V4L Mailing List  <linux-media@vger.kernel.org>
em28xx #0: Board detected as Pinnacle Hybrid Pro
tvp5150 2-005c: chip found @ 0xb8 (em28xx #0)
tuner 2-0061: chip found @ 0xc2 (em28xx #0)
general protection fault: 0000 [#1] PREEMPT SMP=20
last sysfs file: /sys/module/tuner/initstate
CPU 0=20
Modules linked in: em28xx(+) ir_common videobuf_vmalloc videobuf_core tveep=
rom iptable_filter ipt_MASQUERADE iptable_nat nf_nat nf_conntrack_ipv4 nf_c=
onntrack nf_defrag_ipv4 ip_tables x_tables cryptd aes_x86_64 aes_generic ip=
v6 hidp rfcomm sco bridge stp llc bnep l2cap zl10353 snd_usb_audio snd_usb_=
lib snd_rawmidi usbhid hid tuner_xc2028 tuner snd_seq_dummy tvp5150 snd_seq=
_oss snd_seq_midi_event snd_seq snd_seq_device v4l2_common videodev v4l1_co=
mpat v4l2_compat_ioctl32 snd_hda_codec_realtek btusb bluetooth snd_pcm_oss =
snd_mixer_oss snd_hda_intel arc4 snd_hda_codec snd_hwdep snd_pcm fan snd_ti=
mer snd soundcore snd_page_alloc kqemu pcmcia fuse ecb sdhci_pci sdhci mmc_=
core coretemp iwl3945 iTCO_wdt iTCO_vendor_support iwlcore mac80211 led_cla=
ss yenta_socket rsrc_nonstatic ohci1394 pcmcia_core cpufreq_powersave ieee1=
394 cfg80211 rfkill psmouse r8169 mii uhci_hcd i2c_i801 battery thermal but=
ton sg ac pcspkr serio_raw ehci_hcd cpufreq_ondemand usbcore evdev acpi_cpu=
freq freq_table processor rtc_cmos rtc_core rtc_lib ext4 mbcache jbd2 crc16=
 sr_mod cdrom sd_mod pata_acpi ata_generic ata_piix libata scsi_mod i915 dr=
m i2c_algo_bit i2c_core video output intel_agp [last unloaded: tveeprom]
Pid: 16669, comm: modprobe Not tainted 2.6.31-ARCH #1 HEL81I         =20
RIP: 0010:[<ffffffffa07b14bc>]  [<ffffffffa07b14bc>] em28xx_card_setup+0xcd=
c/0xf40 [em28xx]
RSP: 0018:ffff88002ce97ab8  EFLAGS: 00010206
RAX: 64252073253e343c RBX: ffff880074d66000 RCX: 0000000000000000
RDX: ffff880074d66038 RSI: ffff88002ce97b08 RDI: ffff88002cfcd380
RBP: ffff880074d66038 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000000 R12: ffff88002ce97b08
R13: ffff88002cfcd380 R14: ffff880074d66030 R15: ffff88007bd52600
FS:  00007fc3e060b6f0(0000) GS:ffff880001695000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 00007f7ab9601970 CR3: 000000002ce29000 CR4: 00000000000006f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process modprobe (pid: 16669, threadinfo ffff88002ce96000, task ffff88002cd=
a8d40)
Stack:
 ffff880000000000 ffffffffa05a0f50 ffffffffa07b975a 0000000000000040
<0> 0000000000000000 00000000000011d0 0000004700000061 0000000000000006
<0> ffffffffa07b00d0 ffff880074d66ad0 0000000000000047 ffff88002ce97ac8
Call Trace:
 [<ffffffffa07b00d0>] ? em28xx_tuner_callback+0x0/0x70 [em28xx]
 [<ffffffffa07afa81>] ? em28xx_i2c_register+0x1b1/0x520 [em28xx]
 [<ffffffffa07b1cc9>] ? em28xx_usb_probe+0x5a9/0xb00 [em28xx]
 [<ffffffffa0217c94>] ? usb_probe_interface+0xc4/0x1d0 [usbcore]
 [<ffffffff81297b68>] ? driver_probe_device+0xa8/0x1a0
 [<ffffffff81297d23>] ? __driver_attach+0xc3/0xd0
 [<ffffffff81297c60>] ? __driver_attach+0x0/0xd0
 [<ffffffff81296fd8>] ? bus_for_each_dev+0x68/0xb0
 [<ffffffff812965ea>] ? bus_add_driver+0xda/0x2f0
 [<ffffffff8129814a>] ? driver_register+0x7a/0x150
 [<ffffffff810beada>] ? tracepoint_module_notify+0x5a/0x70
 [<ffffffffa02179ca>] ? usb_register_driver+0xca/0x150 [usbcore]
 [<ffffffffa0238000>] ? em28xx_module_init+0x0/0x6e [em28xx]
 [<ffffffffa023802f>] ? em28xx_module_init+0x2f/0x6e [em28xx]
 [<ffffffff81009075>] ? do_one_initcall+0x45/0x1d0
 [<ffffffff81097f75>] ? sys_init_module+0x105/0x260
 [<ffffffff8100c382>] ? system_call_fastpath+0x16/0x1b
Code: 24 58 4c 8b 6b 38 eb 2c 0f 1f 80 00 00 00 00 49 8b 45 28 48 8b 40 08 =
48 85 c0 74 15 48 8b 40 48 48 85 c0 74 0c 4c 89 e6 4c 89 ef <ff> d0 49 8b 5=
5 00 49 89 d5 49 8b 55 00 49 39 ed 0f 18 0a 75 cf=20
RIP  [<ffffffffa07b14bc>] em28xx_card_setup+0xcdc/0xf40 [em28xx]
 RSP <ffff88002ce97ab8>
---[ end trace 7c9bb7af72074381 ]---

--MP_//e75pbI6hqgJg8TSxgRcklE--

--Sig_/7v8ue/OUuS3Fup1TWFr_+5B
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkrVpy4ACgkQVX4H2P5hPtO5kACdE3lmZoKU3sO8Dvs+fCDLHiq1
ZhkAoJG1aiOo5QNoFLgqyKh2r27woOnv
=YpXH
-----END PGP SIGNATURE-----

--Sig_/7v8ue/OUuS3Fup1TWFr_+5B--
