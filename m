Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from rv-out-0506.google.com ([209.85.198.231])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <mrechberger@gmail.com>) id 1K4yeL-0002Ki-5o
	for linux-dvb@linuxtv.org; Sat, 07 Jun 2008 15:40:06 +0200
Received: by rv-out-0506.google.com with SMTP id b25so2153504rvf.41
	for <linux-dvb@linuxtv.org>; Sat, 07 Jun 2008 06:39:59 -0700 (PDT)
Message-ID: <d9def9db0806070639r320ebfa2s3a60e9294d59cef@mail.gmail.com>
Date: Sat, 7 Jun 2008 15:39:59 +0200
From: "Markus Rechberger" <mrechberger@gmail.com>
To: "Devin Heitmueller" <devin.heitmueller@gmail.com>
In-Reply-To: <412bdbff0806061621m67235004p360951a0c8c42fdb@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
References: <20999-51361@sneakemail.com>
	<412bdbff0806061621m67235004p360951a0c8c42fdb@mail.gmail.com>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] multiple em28xx devices doesn't work (well)
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

Hi,

On Sat, Jun 7, 2008 at 1:21 AM, Devin Heitmueller
<devin.heitmueller@gmail.com> wrote:
> Hello,
>
> Thanks for the heads up.  I just got a second device this week,
> noticed the same thing, and was planning to work on it this weekend.
>
> The driver is designed to handle multiple devices, but there is
> apparently a bug in there somewhere...
>
> Devin
>
> On Fri, Jun 6, 2008 at 7:10 PM, Sneake <2hteq3r02@sneakemail.com> wrote:
>> I have 2 em28xx USB capture devices - a Hauppauge Win-HVR-950 and a Pinnacle HD stick:
>>
>> Bus 001 Device 007: ID 2304:0227 Pinnacle Systems, Inc. [hex] Pinnacle TV for Mac, HD Stick
>> Bus 001 Device 004: ID 2040:6513 Hauppauge
>>
>> Both of which are em28xx devices.
>> I am running the latest HG pull of the v4l-dvb drivers as of today (6th June 2008).
>>
>> From a cold start, both devices are seen by the USB probe, however only one gets a /dev/dvb/adapter entry. If I remove the one that did not, I get the following warning:
>>
>> ==========
>> Jun  6 18:00:15 Deathwish kernel: usb 1-3: new high speed USB device using ehci_hcd and address 7
>> Jun  6 18:00:15 Deathwish kernel: usb 1-3: configuration #1 chosen from 1 choice
>> Jun  6 18:00:15 Deathwish kernel: em28xx new video device (2304:0227): interface 0, class 255
>> Jun  6 18:00:15 Deathwish kernel: em28xx Doesn't have usb audio class
>> Jun  6 18:00:15 Deathwish kernel: em28xx #0: Alternate settings: 8
>> Jun  6 18:00:15 Deathwish kernel: em28xx #0: Alternate setting 0, max size= 0
>> Jun  6 18:00:15 Deathwish kernel: em28xx #0: Alternate setting 1, max size= 0
>> Jun  6 18:00:15 Deathwish kernel: em28xx #0: Alternate setting 2, max size= 1448
>> Jun  6 18:00:15 Deathwish kernel: em28xx #0: Alternate setting 3, max size= 2048
>> Jun  6 18:00:15 Deathwish kernel: em28xx #0: Alternate setting 4, max size= 2304
>> Jun  6 18:00:15 Deathwish kernel: em28xx #0: Alternate setting 5, max size= 2580
>> Jun  6 18:00:15 Deathwish kernel: em28xx #0: Alternate setting 6, max size= 2892
>> Jun  6 18:00:15 Deathwish kernel: em28xx #0: Alternate setting 7, max size= 3072
>> Jun  6 18:00:15 Deathwish kernel: em28xx #0: chip ID is em2882/em2883
>> Jun  6 18:00:15 Deathwish kernel: tuner' 1-0061: chip found @ 0xc2 (em28xx #0)
>> Jun  6 18:00:15 Deathwish kernel: em28xx #0: i2c eeprom 00: 1a eb 67 95 04 23 27 02 d0 12 5c 03 8e 16 a4 1c
>> Jun  6 18:00:15 Deathwish kernel: em28xx #0: i2c eeprom 10: 6a 24 27 57 46 07 01 00 00 00 00 00 00 00 00 00
>> Jun  6 18:00:15 Deathwish kernel: em28xx #0: i2c eeprom 20: 46 00 01 00 f0 10 02 00 b8 00 00 00 5b 1c 00 00
>> Jun  6 18:00:15 Deathwish kernel: em28xx #0: i2c eeprom 30: 00 00 20 40 20 80 02 20 01 01 00 00 00 00 00 00
>> Jun  6 18:00:15 Deathwish kernel: em28xx #0: i2c eeprom 40: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
>> Jun  6 18:00:15 Deathwish kernel: em28xx #0: i2c eeprom 50: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
>> Jun  6 18:00:15 Deathwish kernel: em28xx #0: i2c eeprom 60: 00 00 00 00 00 00 00 00 00 00 24 03 50 00 69 00
>> Jun  6 18:00:15 Deathwish kernel: em28xx #0: i2c eeprom 70: 6e 00 6e 00 61 00 63 00 6c 00 65 00 20 00 53 00
>> Jun  6 18:00:15 Deathwish kernel: em28xx #0: i2c eeprom 80: 79 00 73 00 74 00 65 00 6d 00 73 00 00 00 16 03
>> Jun  6 18:00:15 Deathwish kernel: em28xx #0: i2c eeprom 90: 50 00 43 00 54 00 56 00 20 00 38 00 30 00 30 00
>> Jun  6 18:00:15 Deathwish kernel: em28xx #0: i2c eeprom a0: 65 00 00 00 1c 03 30 00 37 00 30 00 38 00 30 00
>> Jun  6 18:00:15 Deathwish kernel: em28xx #0: i2c eeprom b0: 31 00 30 00 36 00 31 00 33 00 37 00 33 00 00 00
>> Jun  6 18:00:15 Deathwish kernel: em28xx #0: i2c eeprom c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
>> Jun  6 18:00:15 Deathwish kernel: em28xx #0: i2c eeprom d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
>> Jun  6 18:00:15 Deathwish kernel: em28xx #0: i2c eeprom e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 54 00
>> Jun  6 18:00:15 Deathwish kernel: em28xx #0: i2c eeprom f0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
>> Jun  6 18:00:15 Deathwish kernel: EEPROM ID= 0x9567eb1a, hash = 0x2de5f5bf
>> Jun  6 18:00:15 Deathwish kernel: Vendor/Product ID= 2304:0227
>> Jun  6 18:00:15 Deathwish kernel: AC97 audio (5 sample rates)
>> Jun  6 18:00:15 Deathwish kernel: 500mA max power
>> Jun  6 18:00:15 Deathwish kernel: Table at 0x27, strings=0x168e, 0x1ca4, 0x246a
>> Jun  6 18:00:15 Deathwish kernel: xc2028 1-0061: creating new instance
>> Jun  6 18:00:15 Deathwish kernel: xc2028 1-0061: type set to XCeive xc2028/xc3028 tuner
>> Jun  6 18:00:15 Deathwish kernel: xc2028 1-0061: Loading 80 firmware images from xc3028-v27.fw, type: xc2028 firmware, ver 2.7
>> Jun  6 18:00:15 Deathwish kernel: xc2028 1-0061: Loading firmware for type=BASE MTS (5), id 0000000000000000.
>> Jun  6 18:00:16 Deathwish kernel: xc2028 1-0061: Loading firmware for type=MTS (4), id 000000000000b700.
>> Jun  6 18:00:16 Deathwish kernel: tvp5150 1-005c: tvp5150am1 detected.
>> Jun  6 18:00:17 Deathwish kernel: em28xx #0: V4L2 device registered as /dev/video0 and /dev/vbi0
>> Jun  6 18:00:17 Deathwish kernel: em28xx-audio.c: probing for em28x1 non standard usbaudio
>> Jun  6 18:00:17 Deathwish kernel: em28xx-audio.c: Copyright (C) 2006 Markus Rechberger
>> Jun  6 18:00:17 Deathwish kernel: proc_dir_entry 'Em28xx Audio' already registered
>> Jun  6 18:00:17 Deathwish kernel: Pid: 135, comm: khubd Not tainted 2.6.25 #1
>> Jun  6 18:00:17 Deathwish kernel:  [<c04935cf>] proc_register+0xa3/0xfd
>> Jun  6 18:00:17 Deathwish kernel:  [<c04937ce>] proc_symlink+0x55/0x70
>> Jun  6 18:00:17 Deathwish kernel:  [<f899d848>] snd_info_card_register+0x31/0x47 [snd]
>> Jun  6 18:00:17 Deathwish kernel:  [<f899c9e8>] snd_card_register+0x1af/0x204 [snd]
>> Jun  6 18:00:17 Deathwish kernel:  [<f9a15144>] em28xx_audio_init+0xf2/0x120 [em28xx_alsa]
>> Jun  6 18:00:17 Deathwish kernel:  [<f9a27a7c>] em28xx_usb_probe+0x607/0x6a0 [em28xx]
>> Jun  6 18:00:17 Deathwish kernel:  [<c054c80f>] usb_autopm_do_device+0xaa/0xb1
>> Jun  6 18:00:17 Deathwish kernel:  [<c054d1be>] usb_probe_interface+0xba/0xfa
>> Jun  6 18:00:17 Deathwish kernel:  [<c05382fd>] driver_probe_device+0xb5/0x126
>> Jun  6 18:00:17 Deathwish kernel:  [<c053836e>] __device_attach+0x0/0x5
>> Jun  6 18:00:17 Deathwish kernel:  [<c05377c6>] bus_for_each_drv+0x36/0x5e
>> Jun  6 18:00:17 Deathwish kernel:  [<c05383fa>] device_attach+0x6c/0x7f
>> Jun  6 18:00:17 Deathwish kernel:  [<c053836e>] __device_attach+0x0/0x5
>> Jun  6 18:00:17 Deathwish kernel:  [<c0537763>] bus_attach_device+0x25/0x52
>> Jun  6 18:00:17 Deathwish kernel:  [<c053697b>] device_add+0x30b/0x45f
>> Jun  6 18:00:17 Deathwish kernel:  [<c054bc16>] usb_set_configuration+0x3c4/0x432
>> Jun  6 18:00:17 Deathwish kernel:  [<c0551dc4>] generic_probe+0x48/0x7c
>> Jun  6 18:00:17 Deathwish kernel:  [<c054cfd8>] usb_probe_device+0x2f/0x34
>> Jun  6 18:00:17 Deathwish kernel:  [<c05382fd>] driver_probe_device+0xb5/0x126
>> Jun  6 18:00:17 Deathwish kernel:  [<c053836e>] __device_attach+0x0/0x5
>> Jun  6 18:00:17 Deathwish kernel:  [<c05377c6>] bus_for_each_drv+0x36/0x5e
>> Jun  6 18:00:17 Deathwish kernel:  [<c05383fa>] device_attach+0x6c/0x7f
>> Jun  6 18:00:17 Deathwish kernel:  [<c053836e>] __device_attach+0x0/0x5
>> Jun  6 18:00:17 Deathwish kernel:  [<c0537763>] bus_attach_device+0x25/0x52
>> Jun  6 18:00:17 Deathwish kernel:  [<c053697b>] device_add+0x30b/0x45f
>> Jun  6 18:00:17 Deathwish kernel:  [<c054c80f>] usb_autopm_do_device+0xaa/0xb1
>> Jun  6 18:00:17 Deathwish kernel:  [<c05477e1>] usb_new_device+0x4a/0x7c
>> Jun  6 18:00:17 Deathwish kernel:  [<c0548ac8>] hub_thread+0x687/0xa4b
>> Jun  6 18:00:17 Deathwish kernel:  [<c0429e51>] autoremove_wake_function+0x0/0x2d
>> Jun  6 18:00:17 Deathwish kernel:  [<c0548441>] hub_thread+0x0/0xa4b
>> Jun  6 18:00:17 Deathwish kernel:  [<c0429d6f>] kthread+0x36/0x5b
>> Jun  6 18:00:17 Deathwish kernel:  [<c0429d39>] kthread+0x0/0x5b
>> Jun  6 18:00:17 Deathwish kernel:  [<c04051cf>] kernel_thread_helper+0x7/0x10
>> Jun  6 18:00:17 Deathwish kernel:  =======================
>> Jun  6 18:00:17 Deathwish kernel: xc2028 1-0061: attaching existing instance
>> Jun  6 18:00:17 Deathwish kernel: xc2028 1-0061: type set to XCeive xc2028/xc3028 tuner
>> Jun  6 18:00:17 Deathwish kernel: em28xx #0/2: xc3028 attached
>> Jun  6 18:00:17 Deathwish kernel: DVB: registering new adapter (em28xx #0)
>> Jun  6 18:00:17 Deathwish kernel: DVB: registering frontend 2 (LG Electronics LGDT3303 VSB/QAM Frontend)...
>> Jun  6 18:00:17 Deathwish kernel: Successfully loaded em28xx-dvb
>> Jun  6 18:00:17 Deathwish kernel: em28xx #0: Found Pinnacle PCTV HD Pro Stick
>> =======
>> at which point both devices have /dev/dvb/adapter entries.
>>
>> It would seem that the code as it is is not multiple-device friendly.
>>

please use the driver which is offered on mcentral.de and supported by
Empiatech, there's also a mailinglist available which helps solving
various problems.

regards,
Markus

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
