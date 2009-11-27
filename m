Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yx0-f188.google.com ([209.85.210.188]:45106 "EHLO
	mail-yx0-f188.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751768AbZK0NNa (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 27 Nov 2009 08:13:30 -0500
Received: by yxe26 with SMTP id 26so1299835yxe.4
        for <linux-media@vger.kernel.org>; Fri, 27 Nov 2009 05:13:36 -0800 (PST)
MIME-Version: 1.0
Date: Fri, 27 Nov 2009 15:13:36 +0200
Message-ID: <bcf98daa0911270513v7463260dm36e0a5e2557b797f@mail.gmail.com>
Subject: High cpu load (dvb_usb_dib0700)
From: Markus Suvanto <markus.suvanto@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hauppauge Nova-T 500 Dual DVB-T generates
high cpu load even if there is nothing going on.
For example:

#!/bin/bash

echo "rmmod  dvb_usb_dib0700"
rmmod  dvb_usb_dib0700

        for ((i=0; i<10; i++))
        do
                cat /proc/loadavg
                sleep 30
        done

echo "modprobe  dvb_usb_dib0700"
modprobe  dvb_usb_dib0700

        for ((i=0; i<10; i++))
        do
                cat /proc/loadavg
                sleep 30
        done


rmmod  dvb_usb_dib0700
0.51 0.50 0.47 1/289 8253
0.51 0.50 0.47 1/289 8261
0.31 0.45 0.45 1/289 8269
0.18 0.41 0.43 1/289 8277
0.11 0.37 0.42 1/289 8285
0.07 0.33 0.40 1/289 8295
0.04 0.30 0.39 1/289 8303
0.26 0.33 0.40 1/288 8312
0.16 0.30 0.38 1/289 8321
0.09 0.27 0.37 1/289 8330
modprobe  dvb_usb_dib0700
0.13 0.25 0.36 2/291 8355
0.16 0.24 0.35 1/289 8370
0.64 0.35 0.38 1/289 8378
0.78 0.41 0.40 1/289 8386
0.58 0.40 0.40 1/289 8394
0.35 0.36 0.38 1/289 8404
0.21 0.32 0.37 1/289 8412
0.52 0.39 0.38 1/289 8433
0.84 0.48 0.41 1/289 8441
0.75 0.49 0.42 1/289 8450

Kernel:  2.6.32-rc8  (+
	git://git.kernel.org/pub/scm/linux/kernel/git/airlied/drm-2.6.git
drm-linus)

Linux 2.6.32-rc8-00020-g5349ef3 #29 SMP Tue Nov 24 09:52:05 EET 2009
x86_64 AMD Phenom(tm) II X3 705e Processor AuthenticAMD GNU/Linux

Gnu C                  4.3.4
Gnu make               3.81
binutils               2.18
util-linux             2.14.2
mount                  support
module-init-tools      3.5
e2fsprogs              1.41.3
PPP                    2.4.4
Linux C Library        2.9
Dynamic linker (ldd)   2.9
Procps                 3.2.8
Net-tools              1.60
Kbd                    1.13
Sh-utils               7.5
wireless-tools         29
Modules Loaded         dvb_usb_dib0700 ipv6 snd_seq_dummy snd_seq_oss
snd_seq_midi_event snd_seq snd_seq_device snd_pcm_oss snd_mixer_oss
libafs af_packet bridge stp llc tun bitrev kvm_amd kvm option btrfs
zlib_deflate cryptomgr aead pcompress crypto_blkcipher crc32c
libcrc32c crypto_hash crypto_algapi mt2060 usbserial mousedev usbhid
usbmouse dib7000p dib7000m dib0070 dvb_usb dib3000mc dib8000
dibx000_common dvb_core usb_storage firewire_ohci radeon ohci_hcd
ehci_hcd uhci_hcd ttm firewire_core drm_kms_helper drm usbcore
firmware_class crc_itu_t i2c_algo_bit i2c_piix4 ohci1394 ata_generic
pata_acpi snd_hda_codec_atihdmi ieee1394 processor cfbcopyarea thermal
snd_hda_codec_via i2c_core atl1e thermal_sys snd_hda_intel nls_base
snd_hda_codec pata_atiixp rtc_cmos atkbd snd_pcm floppy snd_timer
rtc_core pcspkr snd rtc_lib sg 8250_pnp cfbimgblt cfbfillrect
soundcore 8250 asus_atk0110 evdev serial_core psmouse snd_page_alloc
hwmon serio_raw button unix ext4 jbd2 crc16 dm_mod raid1 md_mod sd_mod
ahci libata scsi_mod fbcon tileblit crc32 font bitblit softcursor fb

-Markus
