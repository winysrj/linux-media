Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wg0-f44.google.com ([74.125.82.44]:55459 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752315AbbBVNRi (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 22 Feb 2015 08:17:38 -0500
Received: by mail-wg0-f44.google.com with SMTP id k14so21082938wgh.3
        for <linux-media@vger.kernel.org>; Sun, 22 Feb 2015 05:17:37 -0800 (PST)
Received: from i72600 ([2001:610:600:8489::10])
        by mx.google.com with ESMTPSA id ul1sm51129465wjc.0.2015.02.22.05.17.36
        for <linux-media@vger.kernel.org>
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Sun, 22 Feb 2015 05:17:36 -0800 (PST)
From: "Gert-Jan van der Stroom" <gjstroom@gmail.com>
To: <linux-media@vger.kernel.org>
Subject: Mygica T230 DVB-T/T2/C Ubuntu 14.04 (kernel 3.13.0-45) using media_build
Date: Sun, 22 Feb 2015 14:17:24 +0100
Message-ID: <002401d04ea1$e5cf1780$b16d4680$@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Language: nl
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Can someone help me to get a Mygica T230 DVB-T/T2/C working on Ubuntu 14.04
(kernel 3.13.0-45) using media_build.
I succeed doing a build of the media_build, the drivers also load when I
attach the Mygica, but when I try to use it (tvheadend) it crashes:

[   61.592114] dvb-usb: found a 'Mygica T230 DVB-T/T2/C' in warm state.
[   61.828138] dvb-usb: will pass the complete MPEG2 transport stream to the
software demuxer.
[   61.828279] DVB: registering new adapter (Mygica T230 DVB-T/T2/C)
[   61.847369] i2c i2c-7: Added multiplexed i2c bus 8
[   61.847372] si2168 7-0064: Silicon Labs Si2168 successfully attached
[   61.857024] si2157 8-0060: Silicon Labs Si2147/2148/2157/2158
successfully attached
[   61.857034] usb 1-5: DVB: registering adapter 0 frontend 0 (Silicon Labs
Si2168)...
[   61.857488] input: IR-receiver inside an USB DVB receiver as
/devices/pci0000:00/0000:00:1a.7/usb1/1-5/input/input11
[   61.857541] dvb-usb: schedule remote query interval to 100 msecs.
[   61.857709] dvb-usb: Mygica T230 DVB-T/T2/C successfully initialized and
connected.
[   61.857773] usbcore: registered new interface driver dvb_usb_cxusb

Tvheadend start:
[  314.356162] BUG: unable to handle kernel NULL pointer dereference at
0000000000000010
[  314.356202] IP: [<ffffffffa02ef74c>]
media_entity_pipeline_start+0x1c/0x390 [media]
[  314.356236] PGD 76c6c067 PUD 766b0067 PMD 0
[  314.356260] Oops: 0000 [#1] SMP
[  314.356279] Modules linked in: si2157(OX) si2168(OX) i2c_mux
dvb_usb_cxusb(OX) dib0070(OX) dvb_usb(OX) dvb_core(OX) rc_core(OX) media(OX)
snd_hda_codec_analog gpio_ich hp_wmi sparse_keymap coretemp kvm_intel kvm
serio_raw snd_hda_intel i915 lpc_ich snd_hda_codec shpchp drm_kms_helper
snd_hwdep snd_pcm snd_page_alloc snd_timer pl2303 video wmi tpm_infineon drm
mac_hid mei_me snd soundcore i2c_algo_bit usbserial mei lp parport psmouse
e1000e floppy ptp pps_core pata_acpi
[  314.356541] CPU: 1 PID: 1053 Comm: kdvb-ad-0-fe-0 Tainted: G        W  OX
3.13.0-45-generic #74-Ubuntu

What is wrong, or do I miss something ?
I also added the firmware described at:
http://www.linuxtv.org/wiki/index.php/Geniatech_T230

