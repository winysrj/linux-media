Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w2.samsung.com ([211.189.100.12]:50348 "EHLO
	usmailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751306AbaALSzH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 12 Jan 2014 13:55:07 -0500
Received: from uscpsbgm1.samsung.com
 (u114.gpu85.samsung.co.kr [203.254.195.114]) by mailout2.w2.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MZA00CEJXVT5E50@mailout2.w2.samsung.com> for
 linux-media@vger.kernel.org; Sun, 12 Jan 2014 13:55:05 -0500 (EST)
Date: Sun, 12 Jan 2014 16:55:00 -0200
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
To: Frank =?UTF-8?B?U2Now6RmZXI=?= <fschaefer.oss@googlemail.com>
Cc: linux-media@vger.kernel.org
Subject: Re: [RFT/RFC PATCH 0/8] em28xx: move more v4l/dvb specific code to the
 extension modules and fix the resources handling
Message-id: <20140112165500.2322f999@samsung.com>
In-reply-to: <1389543865-2534-1-git-send-email-fschaefer.oss@googlemail.com>
References: <1389543865-2534-1-git-send-email-fschaefer.oss@googlemail.com>
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Sun, 12 Jan 2014 17:24:17 +0100
Frank Schäfer <fschaefer.oss@googlemail.com> escreveu:

> Patch 1 is fix for the analog device initialization on the first open() call.
> Patches 2-7 move some dvb and v4l specific code from the core module to the 
> extension modules and fix the resources releasing logic/order in the core and
> the v4l2 module. This will also fix the various sysfs group remove warnings 
> which we can see since kernel 3.13.
> Patch 8 finally removes some dead code lines and fixes leaking the memory of 
> video, vbi and radio video_device structs.
> 
> I've tested all patches carefully with the devices I have, but because this is
> really critical stuff, they should be reviewed and tested by others, too.

Those seem to improve it. But there are some bugs still:

1) If the device is inserted/removed quickly several times, the machine deadly
crashes. I tested it with alsa module, and also without it.

2) If the device got removed while streaming, bad things happen.

This is what happens with both audio and video streaming (analog mode):

	[  233.084393] usb 3-2: USB disconnect, device number 2
	[  233.084936] em28xx_audio_isocirq, status -108, 64 packets (size 4416)
	[  233.085024] em2882/3 #0: disconnecting em2882/3 #0 video
	[  233.085092] em2882/3 #0: V4L2 device vbi0 deregistered
	[  233.085630] em2882/3 #0: V4L2 device video1 deregistered
	[  233.086402] em2882/3 #0: Device is open ! Memory deallocation is deferred on last close.

Logs are ok, but the application (xawtv) refuses to die.

I manually removed em28xx-alsa from /lib/modules/.../usb/em28xx. After
such change, device removal while streaming worked.

3) DVB removal while streaming worked relatively well:

[  513.709376] usb 3-2: USB disconnect, device number 5
[  513.709666] em2882/3 #0: disconnecting (null)

	Note that the device name is "(null)" here.

[  514.173191] em2882/3 #0: writing to i2c device at 0x1c failed (error=-19)
[  514.173277] lgdt330x: i2c_write_demod_bytes error (addr 02 <- 00, err = -19)
[  514.173375] em2882/3 #0: writing to i2c device at 0x1c failed (error=-19)
[  514.173428] lgdt330x: i2c_read_demod_bytes: addr 0x0e select 0x6e error (ret == -19)
[  514.173453] em2882/3 #0: writing to i2c device at 0x1c failed (error=-19)
[  514.173484] lgdt330x: i2c_read_demod_bytes: addr 0x0e select 0x6e error (ret == -19)
[  514.173507] em2882/3 #0: writing to i2c device at 0x1c failed (error=-19)
[  514.173536] lgdt330x: i2c_read_demod_bytes: addr 0x0e select 0x8b error (ret == -19)
[  514.273789] em2882/3 #0: writing to i2c device at 0x1c failed (error=-19)
[  514.273823] lgdt330x: i2c_read_demod_bytes: addr 0x0e select 0x58 error (ret == -19)
[  514.374050] em2882/3 #0: writing to i2c device at 0x1c failed (error=-19)
[  514.374089] lgdt330x: i2c_read_demod_bytes: addr 0x0e select 0x58 error (ret == -19)
[  514.474290] em2882/3 #0: writing to i2c device at 0x1c failed (error=-19)
[  514.474328] lgdt330x: i2c_read_demod_bytes: addr 0x0e select 0x58 error (ret == -19)
[  514.574553] em2882/3 #0: writing to i2c device at 0x1c failed (error=-19)
[  514.574590] lgdt330x: i2c_read_demod_bytes: addr 0x0e select 0x58 error (ret == -19)
[  514.673537] em2882/3 #0: writing to i2c device at 0x1c failed (error=-19)
[  514.673567] lgdt330x: i2c_read_demod_bytes: addr 0x0e select 0x58 error (ret == -19)
[  514.673594] em2882/3 #0: writing to i2c device at 0x1c failed (error=-19)
[  514.673611] lgdt330x: i2c_write_demod_bytes error (addr 02 <- 00, err = -19)
[  514.674788] em2882/3 #0: writing to i2c device at 0x1c failed (error=-19)
[  514.674817] lgdt330x: i2c_read_demod_bytes: addr 0x0e select 0x58 error (ret == -19)
[  514.775030] em2882/3 #0: writing to i2c device at 0x1c failed (error=-19)
[  514.775070] lgdt330x: i2c_read_demod_bytes: addr 0x0e select 0x58 error (ret == -19)
[  514.875268] em2882/3 #0: writing to i2c device at 0x1c failed (error=-19)
[  514.875295] lgdt330x: i2c_read_demod_bytes: addr 0x0e select 0x58 error (ret == -19)
[  514.975500] em2882/3 #0: writing to i2c device at 0x1c failed (error=-19)
[  514.975537] lgdt330x: i2c_read_demod_bytes: addr 0x0e select 0x58 error (ret == -19)
[  515.075739] em2882/3 #0: writing to i2c device at 0x1c failed (error=-19)
[  515.075776] lgdt330x: i2c_read_demod_bytes: addr 0x0e select 0x58 error (ret == -19)
[  515.173956] em2882/3 #0: writing to i2c device at 0x1c failed (error=-19)
[  515.173994] lgdt330x: i2c_read_demod_bytes: addr 0x0e select 0x58 error (ret == -19)
[  515.174008] em2882/3 #0: writing to i2c device at 0x1c failed (error=-19)
[  515.174026] lgdt330x: i2c_write_demod_bytes error (addr 02 <- 00, err = -19)
[  515.175970] em2882/3 #0: writing to i2c device at 0x1c failed (error=-19)
[  515.176007] lgdt330x: i2c_read_demod_bytes: addr 0x0e select 0x58 error (ret == -19)
[  515.276203] em2882/3 #0: writing to i2c device at 0x1c failed (error=-19)
[  515.276229] lgdt330x: i2c_read_demod_bytes: addr 0x0e select 0x58 error (ret == -19)
[  515.376440] em2882/3 #0: writing to i2c device at 0x1c failed (error=-19)
[  515.376477] lgdt330x: i2c_read_demod_bytes: addr 0x0e select 0x58 error (ret == -19)
[  515.476674] em2882/3 #0: writing to i2c device at 0x1c failed (error=-19)
[  515.476703] lgdt330x: i2c_read_demod_bytes: addr 0x0e select 0x58 error (ret == -19)
[  515.576912] em2882/3 #0: writing to i2c device at 0x1c failed (error=-19)
[  515.576941] lgdt330x: i2c_read_demod_bytes: addr 0x0e select 0x58 error (ret == -19)
[  515.674383] em2882/3 #0: writing to i2c device at 0x1c failed (error=-19)
[  515.674413] lgdt330x: i2c_read_demod_bytes: addr 0x0e select 0x58 error (ret == -19)
[  515.674440] em2882/3 #0: writing to i2c device at 0x1c failed (error=-19)
[  515.674458] lgdt330x: i2c_write_demod_bytes error (addr 02 <- 00, err = -19)
[  515.677155] em2882/3 #0: writing to i2c device at 0x1c failed (error=-19)
[  515.677194] lgdt330x: i2c_read_demod_bytes: addr 0x0e select 0x58 error (ret == -19)
[  515.777398] em2882/3 #0: writing to i2c device at 0x1c failed (error=-19)
[  515.777425] lgdt330x: i2c_read_demod_bytes: addr 0x0e select 0x58 error (ret == -19)
[  515.877637] em2882/3 #0: writing to i2c device at 0x1c failed (error=-19)
[  515.877675] lgdt330x: i2c_read_demod_bytes: addr 0x0e select 0x58 error (ret == -19)
[  515.977877] em2882/3 #0: writing to i2c device at 0x1c failed (error=-19)
[  515.977913] lgdt330x: i2c_read_demod_bytes: addr 0x0e select 0x58 error (ret == -19)
[  516.078110] em2882/3 #0: writing to i2c device at 0x1c failed (error=-19)
[  516.078148] lgdt330x: i2c_read_demod_bytes: addr 0x0e select 0x58 error (ret == -19)
[  516.174802] em2882/3 #0: writing to i2c device at 0x1c failed (error=-19)
[  516.174841] lgdt330x: i2c_read_demod_bytes: addr 0x0e select 0x58 error (ret == -19)
[  516.174854] em2882/3 #0: writing to i2c device at 0x1c failed (error=-19)
[  516.174872] lgdt330x: i2c_write_demod_bytes error (addr 02 <- 00, err = -19)
[  516.178347] em2882/3 #0: writing to i2c device at 0x1c failed (error=-19)
[  516.178383] lgdt330x: i2c_read_demod_bytes: addr 0x0e select 0x58 error (ret == -19)
[  516.278587] em2882/3 #0: writing to i2c device at 0x1c failed (error=-19)
[  516.278616] lgdt330x: i2c_read_demod_bytes: addr 0x0e select 0x58 error (ret == -19)
[  516.378830] em2882/3 #0: writing to i2c device at 0x1c failed (error=-19)
[  516.378869] lgdt330x: i2c_read_demod_bytes: addr 0x0e select 0x58 error (ret == -19)
[  516.479074] em2882/3 #0: writing to i2c device at 0x1c failed (error=-19)
[  516.479113] lgdt330x: i2c_read_demod_bytes: addr 0x0e select 0x58 error (ret == -19)
[  516.579364] em2882/3 #0: writing to i2c device at 0x1c failed (error=-19)
[  516.579390] lgdt330x: i2c_read_demod_bytes: addr 0x0e select 0x58 error (ret == -19)
[  516.675223] em2882/3 #0: writing to i2c device at 0x1c failed (error=-19)
[  516.675261] lgdt330x: i2c_read_demod_bytes: addr 0x0e select 0x58 error (ret == -19)
[  516.675275] em2882/3 #0: writing to i2c device at 0x1c failed (error=-19)
[  516.675292] lgdt330x: i2c_write_demod_bytes error (addr 02 <- 00, err = -19)
[  516.679632] em2882/3 #0: writing to i2c device at 0x1c failed (error=-19)
[  516.679668] lgdt330x: i2c_read_demod_bytes: addr 0x0e select 0x58 error (ret == -19)
[  516.779918] em2882/3 #0: writing to i2c device at 0x1c failed (error=-19)
[  516.779956] lgdt330x: i2c_read_demod_bytes: addr 0x0e select 0x58 error (ret == -19)
[  516.880195] em2882/3 #0: writing to i2c device at 0x1c failed (error=-19)
[  516.880232] lgdt330x: i2c_read_demod_bytes: addr 0x0e select 0x58 error (ret == -19)
[  516.980476] em2882/3 #0: writing to i2c device at 0x1c failed (error=-19)
[  516.980513] lgdt330x: i2c_read_demod_bytes: addr 0x0e select 0x58 error (ret == -19)
[  517.080761] em2882/3 #0: writing to i2c device at 0x1c failed (error=-19)
[  517.080790] lgdt330x: i2c_read_demod_bytes: addr 0x0e select 0x58 error (ret == -19)
[  517.175648] em2882/3 #0: writing to i2c device at 0x1c failed (error=-19)
[  517.175686] lgdt330x: i2c_read_demod_bytes: addr 0x0e select 0x58 error (ret == -19)
[  517.175699] em2882/3 #0: writing to i2c device at 0x1c failed (error=-19)
[  517.175717] lgdt330x: i2c_write_demod_bytes error (addr 02 <- 00, err = -19)
[  517.181043] em2882/3 #0: writing to i2c device at 0x1c failed (error=-19)
[  517.181072] lgdt330x: i2c_read_demod_bytes: addr 0x0e select 0x58 error (ret == -19)
[  517.281324] em2882/3 #0: writing to i2c device at 0x1c failed (error=-19)
[  517.281353] lgdt330x: i2c_read_demod_bytes: addr 0x0e select 0x58 error (ret == -19)
[  517.381600] em2882/3 #0: writing to i2c device at 0x1c failed (error=-19)
[  517.381637] lgdt330x: i2c_read_demod_bytes: addr 0x0e select 0x58 error (ret == -19)
[  517.481894] em2882/3 #0: writing to i2c device at 0x1c failed (error=-19)
[  517.481930] lgdt330x: i2c_read_demod_bytes: addr 0x0e select 0x58 error (ret == -19)
[  517.582177] em2882/3 #0: writing to i2c device at 0x1c failed (error=-19)
[  517.582214] lgdt330x: i2c_read_demod_bytes: addr 0x0e select 0x58 error (ret == -19)
[  517.676069] em2882/3 #0: writing to i2c device at 0x1c failed (error=-19)
[  517.676107] lgdt330x: i2c_read_demod_bytes: addr 0x0e select 0x58 error (ret == -19)
[  517.676121] em2882/3 #0: writing to i2c device at 0x1c failed (error=-19)
[  517.676138] lgdt330x: i2c_write_demod_bytes error (addr 02 <- 00, err = -19)
[  517.682459] em2882/3 #0: writing to i2c device at 0x1c failed (error=-19)
[  517.682495] lgdt330x: i2c_read_demod_bytes: addr 0x0e select 0x58 error (ret == -19)
[  517.782742] em2882/3 #0: writing to i2c device at 0x1c failed (error=-19)
[  517.782779] lgdt330x: i2c_read_demod_bytes: addr 0x0e select 0x58 error (ret == -19)
[  518.176592] em2882/3 #0: writing to i2c device at 0x1c failed (error=-19)
[  518.176683] lgdt330x: i2c_read_demod_bytes: addr 0x0e select 0x58 error (ret == -19)
[  518.176716] em2882/3 #0: writing to i2c device at 0x1c failed (error=-19)
[  518.176759] lgdt330x: i2c_write_demod_bytes error (addr 02 <- 00, err = -19)
[  518.677002] em2882/3 #0: writing to i2c device at 0x1c failed (error=-19)
[  518.677089] lgdt330x: i2c_read_demod_bytes: addr 0x0e select 0x58 error (ret == -19)
[  518.677119] em2882/3 #0: writing to i2c device at 0x1c failed (error=-19)
[  518.677160] lgdt330x: i2c_write_demod_bytes error (addr 02 <- 00, err = -19)
[  519.177419] em2882/3 #0: writing to i2c device at 0x1c failed (error=-19)
[  519.177506] lgdt330x: i2c_read_demod_bytes: addr 0x0e select 0x58 error (ret == -19)
[  519.177535] em2882/3 #0: writing to i2c device at 0x1c failed (error=-19)
[  519.177576] lgdt330x: i2c_write_demod_bytes error (addr 02 <- 00, err = -19)
[  519.677827] em2882/3 #0: writing to i2c device at 0x1c failed (error=-19)
[  519.677917] lgdt330x: i2c_read_demod_bytes: addr 0x0e select 0x58 error (ret == -19)
[  519.677950] em2882/3 #0: writing to i2c device at 0x1c failed (error=-19)
[  519.677994] lgdt330x: i2c_write_demod_bytes error (addr 02 <- 00, err = -19)
[  519.850303] xc2028 19-0061: destroying instance

In summary, it seems that there are still two bugs:

a) the error patch during device initialization has likely bugs;

b) there are still some things missing on em28xx-alsa, in order to
properly handle device removal.

Yet, there are some improvements on this series. If nobody complains, I'll
likely merge this series in a few days.

> 
> 
> Frank Schäfer (8):
>   em28xx-v4l: fix device initialization in em28xx_v4l2_open() for radio
>     and VBI mode
>   em28xx: move usb buffer pre-allocation and transfer uninit from the
>     core to the dvb extension
>   em28xx: move usb transfer uninit on device disconnect from the core to
>     the v4l-extension
>   em28xx: move v4l2_device_disconnect() call from the core to the v4l
>     extension
>   em28xx-v4l: move v4l2_ctrl_handler freeing and v4l2_device
>     unregistration to em28xx_v4l2_fini
>   em28xx: move v4l2 dummy clock deregistration from the core to the v4l
>     extension
>   em28xx: always call em28xx_release_resources() in the usb disconnect
>     handler
>   em28xx-v4l: fix the freeing of the video devices memory
> 
>  drivers/media/usb/em28xx/em28xx-cards.c |   48 ++--------------
>  drivers/media/usb/em28xx/em28xx-dvb.c   |   23 ++++++++
>  drivers/media/usb/em28xx/em28xx-video.c |   91 +++++++++++++++++++------------
>  3 Dateien geändert, 85 Zeilen hinzugefügt(+), 77 Zeilen entfernt(-)
> 


-- 

Cheers,
Mauro
