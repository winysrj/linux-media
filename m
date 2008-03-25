Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m2PBcc7b020936
	for <video4linux-list@redhat.com>; Tue, 25 Mar 2008 07:38:38 -0400
Received: from py-out-1112.google.com (py-out-1112.google.com [64.233.166.177])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m2PBbvDX029111
	for <video4linux-list@redhat.com>; Tue, 25 Mar 2008 07:37:58 -0400
Received: by py-out-1112.google.com with SMTP id a29so3834541pyi.0
	for <video4linux-list@redhat.com>; Tue, 25 Mar 2008 04:37:57 -0700 (PDT)
Message-ID: <47E8E411.7060804@gmail.com>
Date: Tue, 25 Mar 2008 05:37:53 -0600
From: nix4me@gmail.com
MIME-Version: 1.0
To: video4linux-list@redhat.com
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Subject: cx18
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

The card I'm trying to get working, is an hauppauge hvr-1600 model 1181 
with the instructions from here: 
http://ivtvdriver.org/index.php/Cx18#Introduction

The driver compiled with no problems, and I renamed, and copied the 
firmware files to /lib/firmware on my slackware 12.0 system.

here is some info from my system:

$lspci -v
02:04.0 Multimedia video controller: Conexant Unknown device 5b7a
         Subsystem: Hauppauge computer works Inc. Unknown device 7444
         Flags: bus master, medium devsel, latency 66, IRQ 5
         Memory at e4000000 (32-bit, non-prefetchable) [size=64M]
         Capabilities: [44] Vital Product Data
         Capabilities: [4c] Power Management version 2

$lsmod
Module                  Size  Used by
i2c_dev                 6404  0
snd_seq_dummy           2692  0
snd_seq_oss            28032  0
snd_seq_midi_event      5888  1 snd_seq_oss
snd_seq                42704  5 snd_seq_dummy,snd_seq_oss,snd_seq_midi_event
snd_seq_device          6412  3 snd_seq_dummy,snd_seq_oss,snd_seq
snd_pcm_oss            36000  0
snd_mixer_oss          13824  1 snd_pcm_oss
usbhid                 38400  0
hid                    32128  1 usbhid
s5h1409                 8452  0
cs5345                  3116  0
tuner                  24140  0
tea5767                 6404  1 tuner
tda8290                12292  1 tuner
tda18271               29832  1 tda8290
tda827x                 9604  1 tda8290
tuner_xc2028           19856  1 tuner
xc5000                  9604  1 tuner
tda9887                 9348  1 tuner
tuner_simple            9352  1 tuner
tuner_types            11392  1 tuner_simple
mt20xx                 11912  1 tuner
tea5761                 4356  1 tuner
ohci1394               27824  0
cx18                   82240  0
ieee1394               76856  1 ohci1394
dvb_core               68732  1 cx18
cx2341x                11140  1 cx18
v4l2_common             9600  4 cs5345,tuner,cx18,cx2341x
8139too                20736  0
nvidia               4707120  22
videodev               30848  2 tuner,cx18
e100                   30988  0
mii                     4480  2 8139too,e100
v4l1_compat            13700  2 cx18,videodev
tveeprom               11780  1 cx18
snd_intel8x0           27548  0
thermal                12572  0
button                  6032  0
snd_ac97_codec         94500  1 snd_intel8x0
ac97_bus                1792  1 snd_ac97_codec
snd_pcm                65416  3 snd_pcm_oss,snd_intel8x0,snd_ac97_codec
snd_timer              17540  2 snd_seq,snd_pcm
snd                    42852  9 
snd_seq_oss,snd_seq,snd_seq_device,snd_pcm_oss,snd_mixer_oss,snd_intel8x0,snd_ac97_codec,snd_pcm,snd_timer
processor              17056  1 thermal
soundcore               5472  1 snd
intel_agp              21268  1
rtc_cmos                6560  0
evdev                   8448  3
agpgart                26288  2 nvidia,intel_agp
rtc_core               13976  1 rtc_cmos
uhci_hcd               21260  0
serio_raw               4996  0
snd_page_alloc          7560  2 snd_intel8x0,snd_pcm
psmouse                36112  0
rtc_lib                 2560  1 rtc_core


$cat /var/log/syslog|grep cx18
Mar 24 09:37:46 slack kernel: cx18-0: Invalid EEPROM
Mar 24 09:37:47 slack kernel: cx18: frontend initialization failed
Mar 24 09:37:47 slack kernel: cx18_reg_dev() DVB failed to register
Mar 24 09:39:21 slack kernel: cx18-0: Mismatch at offset 10
Mar 24 09:39:21 slack kernel: cx18-0: Retry loading firmware
Mar 24 09:39:21 slack kernel: cx18-0: Mismatch at offset 10
Mar 24 09:39:21 slack kernel: cx18-0: Failed to initialize on minor 0
Mar 24 09:40:48 slack kernel: cx18-0: Invalid EEPROM
Mar 24 09:40:48 slack kernel: cx18: frontend initialization failed
Mar 24 09:40:48 slack kernel: cx18_reg_dev() DVB failed to register
Mar 24 09:41:54 slack kernel: cx18-0: Mismatch at offset 10
Mar 24 09:41:54 slack kernel: cx18-0: Retry loading firmware
Mar 24 09:41:54 slack kernel: cx18-0: Mismatch at offset 10
Mar 24 09:41:54 slack kernel: cx18-0: Failed to initialize on minor 0
Mar 24 10:04:10 slack kernel: cx18-0: Invalid EEPROM
Mar 24 10:04:11 slack kernel: cx18: frontend initialization failed
Mar 24 10:04:11 slack kernel: cx18_reg_dev() DVB failed to register
Mar 24 10:47:13 slack kernel: cx18-0: Invalid EEPROM
Mar 24 10:47:13 slack kernel: cx18: frontend initialization failed
Mar 24 10:47:13 slack kernel: cx18_reg_dev() DVB failed to register
Mar 24 10:52:47 slack kernel: cx18-0: Invalid EEPROM
Mar 24 10:52:48 slack kernel: cx18: frontend initialization failed
Mar 24 10:52:48 slack kernel: cx18_reg_dev() DVB failed to register
Mar 24 10:58:22 slack kernel: cx18-0: Invalid EEPROM
Mar 24 10:58:23 slack kernel: cx18: frontend initialization failed
Mar 24 10:58:23 slack kernel: cx18_reg_dev() DVB failed to register
Mar 24 11:35:46 slack kernel: cx18-0: Mismatch at offset 10
Mar 24 11:35:46 slack kernel: cx18-0: Retry loading firmware
Mar 24 11:35:46 slack kernel: cx18-0: Mismatch at offset 10
Mar 24 11:35:46 slack kernel: cx18-0: Failed to initialize on minor 0
Mar 24 22:19:39 slack kernel: cx18-0: Invalid EEPROM
Mar 24 22:19:39 slack kernel: cx18: frontend initialization failed
Mar 24 22:19:39 slack kernel: cx18_reg_dev() DVB failed to register
Mar 24 23:54:37 slack kernel: cx18-0: Invalid EEPROM
Mar 24 23:54:37 slack kernel: cx18: frontend initialization failed
Mar 24 23:54:37 slack kernel: cx18_reg_dev() DVB failed to register
Mar 25 00:07:42 slack kernel: cx18-0: Invalid EEPROM
Mar 25 00:07:42 slack kernel: cx18: frontend initialization failed
Mar 25 00:07:42 slack kernel: cx18_reg_dev() DVB failed to register
Mar 25 01:15:32 slack kernel: cx18-0: Mismatch at offset 10
Mar 25 01:15:32 slack kernel: cx18-0: Retry loading firmware
Mar 25 01:15:32 slack kernel: cx18-0: Mismatch at offset 10
Mar 25 01:15:32 slack kernel: cx18-0: Failed to initialize on minor 0
Mar 25 01:17:23 slack kernel: cx18-0: Failed to initialize on minor 0
Mar 25 01:17:56 slack kernel: cx18-0: Failed to initialize on minor 0
Mar 25 02:02:16 slack kernel: cx18-0: Invalid EEPROM
Mar 25 02:02:16 slack kernel: cx18: frontend initialization failed
Mar 25 02:02:16 slack kernel: cx18_reg_dev() DVB failed to register
Mar 25 02:12:12 slack kernel: cx18-0: Mismatch at offset 10
Mar 25 02:12:12 slack kernel: cx18-0: Retry loading firmware
Mar 25 02:12:12 slack kernel: cx18-0: Mismatch at offset 10
Mar 25 02:12:12 slack kernel: cx18-0: Failed to initialize on minor 0
Mar 25 02:50:45 slack kernel: cx18-0: Invalid EEPROM
Mar 25 02:50:45 slack kernel: cx18: frontend initialization failed
Mar 25 02:50:45 slack kernel: cx18_reg_dev() DVB failed to register
Mar 25 03:04:45 slack kernel: cx18-0: Mismatch at offset 10
Mar 25 03:04:45 slack kernel: cx18-0: Retry loading firmware
Mar 25 03:04:45 slack kernel: cx18-0: Mismatch at offset 10
Mar 25 03:04:45 slack kernel: cx18-0: Failed to initialize on minor 0

$dmesg|grep cx18
6>cx18-0: Registered device video0 for encoder MPEG (2 MB)
cx18-0: Registered device video16 for TS (1 MB)
cx18_reg_dev() Calling DVB Register
cx18_dvb_register()
DVB: registering new adapter (cx18)
cx18: frontend initialization failed
cx18_reg_dev() DVB failed to register
cx18-0: Registered device video32 for encoder YUV (2 MB)
cx18-0: Registered device vbi0 for encoder VBI (1 MB)
cx18-0: Registered device video24 for encoder PCM audio (1 MB)
cx18-0: Registered device radio0 for encoder radio
cx18-0: Initialized card #0: Hauppauge HVR-1600
cx18:  End initialization
i2c-dev: adapter [cx18 i2c driver #0-0] registered as minor 0
i2c-dev: adapter [cx18 i2c driver #0-1] registered as minor 1
cx18-0: Mismatch at offset 10
cx18-0: Retry loading firmware
cx18-0: Mismatch at offset 10
cx18-0: Failed to initialize on minor 0

$ls -l /lib/firmware
-rw-r--r-- 1 root root 141200 2008-03-24 10:42 v4l-cx23418-apu.fw
-rw-r--r-- 1 root root 174716 2008-03-24 10:43 v4l-cx23418-cpu.fw
-rw-r--r-- 1 root root  16382 2008-03-24 10:43 v4l-cx23418-dig.fw

Does anyone have any idea why the firmware will not load for this card?

regards
Doug Chalmers

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
