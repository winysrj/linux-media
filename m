Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:52096 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754055Ab3CXQNq (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 24 Mar 2013 12:13:46 -0400
Date: Sun, 24 Mar 2013 13:13:40 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org,
	Volokh Konstantin <volokh84@gmail.com>,
	Pete Eberlein <pete@sensoray.com>
Subject: Re: [GIT PULL FOR v3.10] go7007 driver overhaul
Message-ID: <20130324131340.720a59dd@redhat.com>
In-Reply-To: <201303221536.35993.hverkuil@xs4all.nl>
References: <201303221536.35993.hverkuil@xs4all.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Fri, 22 Mar 2013 15:36:35 +0100
Hans Verkuil <hverkuil@xs4all.nl> escreveu:

> Hi all,
> 
> This pull request updates the staging go7007 driver to the latest
> V4L2 frameworks and actually makes it work reliably.
> 
> This pull request assumes that pull request
> http://patchwork.linuxtv.org/patch/17568/ was merged first.
> 
> Some highlights:
> 
> - moved the custom i2c drivers to media/i2c.
> - replaced the s2250-loader by a common loader for all the supported
>   devices.
> - replaced all MPEG-related custom ioctls by standard ioctls and FMT
>   support.
> - added the saa7134-go7007 combination (similar to the saa7134-empress).
> - added support for ADS Tech DVD Xpress DX2.
> 
> In addition I've made some V4L2 core and saa7115 changes (the first 7
> patches):
> 
> - eliminate false lockdep warnings when dealing with nested control
>   handlers. This patch is a slightly modified version from the one Andy
>   posted a long time ago.
> - add support to easily test if any subdevices support a particular operation.
> - fix a few bugs in the code that tests if an ioctl is available: it didn't
>   take 'disabling of ioctls' into account.
> - added additional configuration flags to saa7115, needed by the go7007.
> - improved querystd support in saa7115.
> 
> This driver now passes all v4l2-compliance tests.
> 
> It has been tested with:
> 
> - Plextor PX-TV402U (PAL model)
> - Sensoray S2250S (generously provided by Sensoray, all audio inputs
>   now work!)
> - Sensoray Model 614 (saa7134+go7007 PCI board, generously provided by
>   Sensoray)
> - WIS X-Men II sensor board (generously provided by Sensoray)
> - Adlink PCI-MPG24 surveillance board
> - ADS Tech DVD Xpress DX2
> 
> Everything seems to work OK, but for two things:
> 
> - the WIS X-Men and tthe S2250 do not honor requested frameperiod changes
>   using S_PARM. The others work fine, and I have no idea why these work
>   differently.
> - the bttv part of the Adlink card doesn't work for me: I just get black
>   with fuzzy lines. This doesn't work in 3.8 either, so I don't know
>   what's going on here. It's not related to my patch series, that's for
>   sure.
> 
> What needs to be done to get this driver out of staging? The main thing
> is the motion detection support. Volokh has some additional code for that,
> and I want to experiment with motion detection for this card and the
> solo6x10 card and see if I can come up with a nice API for that.
> 
> It would also be nice to get the s2250-board.c code make use of the already
> existing i2c devices, but it is hooked up somewhat strangely, so I need to
> look at that some day.
> 
> Regarding the firmware: they are available here:
> 
> http://git.linuxtv.org/hverkuil/linux-firmware.git/shortlog/refs/heads/go7007
> 
> All firmwares relating to this driver have been collected in the go7007
> directory with correct licensing. Note that this means that the s2250 firmwares
> have been renamed. Should this be an issue I can change this back and leave
> those files where they are today, but since the go7007 firmware files were
> never included in linux-firmware (and therefor the driver never worked with
> just linux-firmware) and because it is still a staging driver I thought it
> cleaner to have all firmware files in one place.
> 
> Mauro, when should I make a pull request for the linux-firmware changes?
> After you have merged this pull request?
> 
> In the meantime, the firmware files are also available here:
> 
> http://hverkuil.home.xs4all.nl/go7007-fw.tar.bz2
> 
> Just unpack in /lib/firmware.
> 
> Regards,
> 
>         Hans
> 
> The following changes since commit 8bf1a5a826d06a9b6f65b3e8dffb9be59d8937c3:
> 
>   v4l2-ioctl: add precision when printing names. (2013-03-22 11:59:21 +0100)
> 
> are available in the git repository at:
> 
>   git://linuxtv.org/hverkuil/media_tree.git go7007
> 
> for you to fetch changes up to 651f19e2186eb92393296717afaa7fc0873d6c2f:
> 
>   go7007: add support for ADS Tech DVD Xpress DX2 (2013-03-22 15:20:46 +0100)
> 
> ----------------------------------------------------------------
> Andy Walls (1):
>       v4l2-ctrls: eliminate lockdep false alarms for struct v4l2_ctrl_handler.lock
> 
> Hans Verkuil (47):
>       v4l2-core: add code to check for specific ops.
>       v4l2-ioctl: check if an ioctl is valid.
>       v4l2-ctrls: add V4L2_CID_MPEG_VIDEO_REPEAT_SEQ_HEADER control
>       saa7115: add config flag to change the IDQ polarity.
>       saa7115: improve querystd handling for the saa7115.
>       saa7115: add support for double-rate ASCLK
>       go7007: fix i2c_xfer return codes.
>       tuner: add Sony BTF tuners
>       sony-btf-mpx: the MPX driver for the sony BTF PAL/SECAM tuner
>       ov7640: add new ov7640 driver
>       uda1342: add new uda1342 audio codec driver
>       tw9903: add new tw9903 video decoder.
>       tw2804: add support for the Techwell tw2804.
>       go7007: switch to standard tuner/i2c subdevs.
>       go7007: remove all wis* drivers.
>       go7007: add audio input ioctls.
>       s2250-loader: use usbv2_cypress_load_firmware
>       go7007: go7007: add device_caps and bus_info support to querycap.
>       go7007: remove current_norm.
>       go7007: fix DMA related errors.
>       go7007: remember boot firmware.
>       go7007: fix unregister/disconnect handling.
>       go7007: convert to the control framework and remove obsolete JPEGCOMP support.
>       s2250: convert to the control framework.
>       go7007: add prio and control event support.
>       go7007: add log_status support.
>       go7007: tuner/std related fixes.
>       go7007: standardize MPEG handling support.
>       go7007: simplify the PX-TV402U board ID handling.
>       go7007: set up the saa7115 audio clock correctly.
>       go7007: drop struct go7007_file
>       go7007: convert to core locking and vb2.
>       go7007: embed struct video_device
>       go7007: remove cropping functions
>       saa7134-go7007: add support for this combination.

I won't apply this one yet. A non-staging driver should not try to load a
staging one without a notice. That change would be ok if you were also
moving go7007 out of staging.

>       s2250: add comment describing the hardware.
>       go7007-loader: renamed from s2250-loader
>       go7007-loader: add support for the other devices and move fw files
>       go7007: update the README

You need to add there:
	- move cypress load firmware to drivers/media/common;

And some note about saa7134 integration.


>       MAINTAINERS: add the go7007 driver.
>       go7007: a small improvement to querystd handling.
>       go7007: add back 'repeat sequence header' control.
>       go7007: correct a header check: MPEG4 has a different GOP code.
>       go7007: drop firmware name in board config, make configs const.
>       go7007: don't continue if firmware can't be loaded.

This one didn't apply. Maybe due to the lack of saa7134-go7007.

Maybe it is just a trivial merging conflict, but better if you could
check it before forcing it.

Regards,
Mauro
