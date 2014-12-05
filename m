Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud3.xs4all.net ([194.109.24.22]:46981 "EHLO
	lb1-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751561AbaLEPZn (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 5 Dec 2014 10:25:43 -0500
Received: from [127.0.0.1] (localhost [127.0.0.1])
	by tschai.lan (Postfix) with ESMTPSA id 0D9822A002F
	for <linux-media@vger.kernel.org>; Fri,  5 Dec 2014 16:25:38 +0100 (CET)
Message-ID: <5481CE71.60804@xs4all.nl>
Date: Fri, 05 Dec 2014 16:25:37 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [GIT PULL FOR v3.19] Media cleanups
References: <5481A57F.5030501@xs4all.nl>
In-Reply-To: <5481A57F.5030501@xs4all.nl>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 12/05/2014 01:30 PM, Hans Verkuil wrote:
> Hi Mauro,
> 
> This patch series contains a bunch of cleanups:
> 
> - Remove emacs editor comments throughout drivers/media
> - Move deprecated drivers to staging. I plan to remove these for 3.20.
> - Switch last users of the deprecated get/set_crop pad ops to
>   get/set_selection.
> - Drop obsolete get/set_crop and the unused enum_mbus_fmt ops.
> - Small Kconfig improvement.
> 
> Regards,
> 
> 	Hans
> 
> 
> The following changes since commit 71947828caef0c83d4245f7d1eaddc799b4ff1d1:
> 
>   [media] mn88473: One function call less in mn88473_init() after error (2014-12-04 16:00:47 -0200)
> 
> are available in the git repository at:
> 
>   git://linuxtv.org/hverkuil/media_tree.git for-v3.19l
> 
> for you to fetch changes up to db7a942eaf398fe02769ca1e29ca426dd9a6f7d4:
> 
>   media/i2c/Kconfig: drop superfluous MEDIA_CONTROLLER (2014-12-05 13:28:54 +0100)
> 
> ----------------------------------------------------------------
> Hans Verkuil (8):
>       media: remove emacs editor variables
>       vino/saa7191: move to staging in preparation for removal
>       tlg2300: move to staging in preparation for removal
>       bq/c-qcam, w9966, pms: move to staging in preparation for removal

I'd really like to get these first four patches in for 3.19. All they do is
remove editor comments and move drivers to staging. No code is actually changed.

The remaining four patches below can go to 3.20 if you prefer.

Regards,

	Hans

>       v4l2 subdevs: replace get/set_crop by get/set_selection
>       v4l2-subdev: drop get/set_crop pad ops
>       v4l2-subdev: drop unused op enum_mbus_fmt
>       media/i2c/Kconfig: drop superfluous MEDIA_CONTROLLER
> 
>  Documentation/DocBook/media/v4l/vidioc-dv-timings-cap.xml  |  8 --------
>  Documentation/DocBook/media/v4l/vidioc-enum-dv-timings.xml |  8 --------
>  drivers/media/Kconfig                                      |  1 -
>  drivers/media/Makefile                                     |  2 +-
>  drivers/media/common/btcx-risc.c                           |  6 ------
>  drivers/media/common/btcx-risc.h                           |  6 ------
>  drivers/media/dvb-frontends/au8522.h                       |  5 -----
>  drivers/media/dvb-frontends/lg2160.c                       |  6 ------
>  drivers/media/dvb-frontends/lgdt3305.c                     |  6 ------
>  drivers/media/dvb-frontends/lgdt330x.c                     |  6 ------
>  drivers/media/dvb-frontends/lgdt330x.h                     |  6 ------
>  drivers/media/dvb-frontends/lgdt330x_priv.h                |  6 ------
>  drivers/media/dvb-frontends/nxt200x.h                      |  6 ------
>  drivers/media/dvb-frontends/or51132.c                      |  6 ------
>  drivers/media/dvb-frontends/or51132.h                      |  6 ------
>  drivers/media/dvb-frontends/s5h1409.c                      |  6 ------
>  drivers/media/dvb-frontends/s5h1409.h                      |  5 -----
>  drivers/media/dvb-frontends/s5h1411.c                      |  5 -----
>  drivers/media/dvb-frontends/s5h1411.h                      |  5 -----
>  drivers/media/i2c/Kconfig                                  | 15 +++------------
>  drivers/media/i2c/Makefile                                 |  1 -
>  drivers/media/i2c/msp3400-driver.c                         |  8 --------
>  drivers/media/i2c/mt9m032.c                                | 42 +++++++++++++++++++++++-----------------
>  drivers/media/i2c/mt9p031.c                                | 41 ++++++++++++++++++++++-----------------
>  drivers/media/i2c/mt9t001.c                                | 41 ++++++++++++++++++++++-----------------
>  drivers/media/i2c/mt9v032.c                                | 43 +++++++++++++++++++++++------------------
>  drivers/media/i2c/s5k6aa.c                                 | 44 +++++++++++++++++++++++++-----------------
>  drivers/media/pci/bt8xx/bt878.c                            |  6 ------
>  drivers/media/pci/bt8xx/bttv-cards.c                       |  7 -------
>  drivers/media/pci/bt8xx/bttv-driver.c                      |  6 ------
>  drivers/media/pci/bt8xx/bttv-gpio.c                        |  6 ------
>  drivers/media/pci/bt8xx/bttv-if.c                          |  6 ------
>  drivers/media/pci/bt8xx/bttv-risc.c                        |  6 ------
>  drivers/media/pci/bt8xx/bttv-vbi.c                         |  7 -------
>  drivers/media/pci/bt8xx/bttv.h                             |  5 -----
>  drivers/media/pci/bt8xx/bttvp.h                            |  6 ------
>  drivers/media/pci/cx88/cx88-core.c                         |  7 -------
>  drivers/media/pci/cx88/cx88-mpeg.c                         |  7 -------
>  drivers/media/pci/cx88/cx88-tvaudio.c                      |  7 -------
>  drivers/media/platform/Kconfig                             |  8 --------
>  drivers/media/platform/Makefile                            |  3 ---
>  drivers/media/tuners/mt20xx.c                              |  8 --------
>  drivers/media/tuners/mt2131.c                              |  5 -----
>  drivers/media/tuners/mt2131.h                              |  5 -----
>  drivers/media/tuners/mt2131_priv.h                         |  5 -----
>  drivers/media/tuners/mxl5007t.c                            |  8 --------
>  drivers/media/tuners/mxl5007t.h                            |  9 ---------
>  drivers/media/tuners/tda18271-fe.c                         |  8 --------
>  drivers/media/tuners/tda18271-maps.c                       |  8 --------
>  drivers/media/tuners/tda18271-priv.h                       |  8 --------
>  drivers/media/tuners/tda827x.c                             |  8 --------
>  drivers/media/tuners/tda8290.c                             |  8 --------
>  drivers/media/tuners/tda9887.c                             |  8 --------
>  drivers/media/tuners/tuner-simple.c                        |  8 --------
>  drivers/media/usb/Kconfig                                  |  1 -
>  drivers/media/usb/Makefile                                 |  1 -
>  drivers/media/usb/dvb-usb-v2/mxl111sf-demod.c              |  6 ------
>  drivers/media/usb/dvb-usb-v2/mxl111sf-demod.h              |  6 ------
>  drivers/media/usb/dvb-usb-v2/mxl111sf-gpio.c               |  6 ------
>  drivers/media/usb/dvb-usb-v2/mxl111sf-gpio.h               |  6 ------
>  drivers/media/usb/dvb-usb-v2/mxl111sf-i2c.c                |  6 ------
>  drivers/media/usb/dvb-usb-v2/mxl111sf-i2c.h                |  6 ------
>  drivers/media/usb/dvb-usb-v2/mxl111sf-phy.c                |  6 ------
>  drivers/media/usb/dvb-usb-v2/mxl111sf-phy.h                |  6 ------
>  drivers/media/usb/dvb-usb-v2/mxl111sf-reg.h                |  6 ------
>  drivers/media/usb/dvb-usb-v2/mxl111sf-tuner.c              |  8 --------
>  drivers/media/usb/dvb-usb-v2/mxl111sf-tuner.h              |  9 ---------
>  drivers/media/usb/dvb-usb-v2/mxl111sf.c                    |  6 ------
>  drivers/media/usb/dvb-usb-v2/mxl111sf.h                    |  6 ------
>  drivers/media/usb/dvb-usb/m920x.c                          |  5 -----
>  drivers/media/usb/pvrusb2/pvrusb2-audio.c                  | 10 ----------
>  drivers/media/usb/pvrusb2/pvrusb2-audio.h                  | 10 ----------
>  drivers/media/usb/pvrusb2/pvrusb2-context.c                | 11 -----------
>  drivers/media/usb/pvrusb2/pvrusb2-context.h                |  9 ---------
>  drivers/media/usb/pvrusb2/pvrusb2-cs53l32a.c               | 11 -----------
>  drivers/media/usb/pvrusb2/pvrusb2-cs53l32a.h               | 10 ----------
>  drivers/media/usb/pvrusb2/pvrusb2-ctrl.c                   | 11 -----------
>  drivers/media/usb/pvrusb2/pvrusb2-ctrl.h                   | 10 ----------
>  drivers/media/usb/pvrusb2/pvrusb2-cx2584x-v4l.c            | 12 ------------
>  drivers/media/usb/pvrusb2/pvrusb2-cx2584x-v4l.h            | 10 ----------
>  drivers/media/usb/pvrusb2/pvrusb2-debug.h                  | 10 ----------
>  drivers/media/usb/pvrusb2/pvrusb2-debugifc.c               | 11 -----------
>  drivers/media/usb/pvrusb2/pvrusb2-debugifc.h               | 10 ----------
>  drivers/media/usb/pvrusb2/pvrusb2-devattr.c                | 10 ----------
>  drivers/media/usb/pvrusb2/pvrusb2-devattr.h                | 10 ----------
>  drivers/media/usb/pvrusb2/pvrusb2-eeprom.c                 | 10 ----------
>  drivers/media/usb/pvrusb2/pvrusb2-eeprom.h                 | 10 ----------
>  drivers/media/usb/pvrusb2/pvrusb2-encoder.c                | 11 -----------
>  drivers/media/usb/pvrusb2/pvrusb2-encoder.h                | 10 ----------
>  drivers/media/usb/pvrusb2/pvrusb2-fx2-cmd.h                | 10 ----------
>  drivers/media/usb/pvrusb2/pvrusb2-hdw-internal.h           | 10 ----------
>  drivers/media/usb/pvrusb2/pvrusb2-hdw.h                    | 10 ----------
>  drivers/media/usb/pvrusb2/pvrusb2-i2c-core.c               | 10 ----------
>  drivers/media/usb/pvrusb2/pvrusb2-i2c-core.h               | 11 -----------
>  drivers/media/usb/pvrusb2/pvrusb2-io.c                     | 11 -----------
>  drivers/media/usb/pvrusb2/pvrusb2-io.h                     | 10 ----------
>  drivers/media/usb/pvrusb2/pvrusb2-ioread.c                 | 11 -----------
>  drivers/media/usb/pvrusb2/pvrusb2-ioread.h                 | 10 ----------
>  drivers/media/usb/pvrusb2/pvrusb2-main.c                   | 11 -----------
>  drivers/media/usb/pvrusb2/pvrusb2-std.c                    | 11 -----------
>  drivers/media/usb/pvrusb2/pvrusb2-std.h                    | 10 ----------
>  drivers/media/usb/pvrusb2/pvrusb2-sysfs.c                  | 11 -----------
>  drivers/media/usb/pvrusb2/pvrusb2-sysfs.h                  | 10 ----------
>  drivers/media/usb/pvrusb2/pvrusb2-util.h                   | 10 ----------
>  drivers/media/usb/pvrusb2/pvrusb2-v4l2.c                   | 10 ----------
>  drivers/media/usb/pvrusb2/pvrusb2-v4l2.h                   | 10 ----------
>  drivers/media/usb/pvrusb2/pvrusb2-video-v4l.c              | 11 -----------
>  drivers/media/usb/pvrusb2/pvrusb2-video-v4l.h              | 10 ----------
>  drivers/media/usb/pvrusb2/pvrusb2-wm8775.c                 | 12 ------------
>  drivers/media/usb/pvrusb2/pvrusb2-wm8775.h                 | 10 ----------
>  drivers/media/usb/pvrusb2/pvrusb2.h                        | 10 ----------
>  drivers/media/usb/usbvision/usbvision-core.c               |  8 --------
>  drivers/media/usb/usbvision/usbvision-i2c.c                |  8 --------
>  drivers/media/usb/usbvision/usbvision-video.c              |  8 --------
>  drivers/media/usb/usbvision/usbvision.h                    |  8 --------
>  drivers/media/v4l2-core/v4l2-dev.c                         |  7 -------
>  drivers/media/v4l2-core/v4l2-subdev.c                      |  8 --------
>  drivers/staging/media/Kconfig                              |  6 ++++++
>  drivers/staging/media/Makefile                             |  3 +++
>  drivers/staging/media/davinci_vpfe/dm365_isif.c            | 69 ++++++++++++++++++++++++++++++++++--------------------------------
>  drivers/{ => staging}/media/parport/Kconfig                | 24 +++++++++++++++++++----
>  drivers/{ => staging}/media/parport/Makefile               |  0
>  drivers/{ => staging}/media/parport/bw-qcam.c              |  0
>  drivers/{ => staging}/media/parport/c-qcam.c               |  0
>  drivers/{ => staging}/media/parport/pms.c                  |  0
>  drivers/{ => staging}/media/parport/w9966.c                |  0
>  drivers/{media/usb => staging/media}/tlg2300/Kconfig       |  6 +++++-
>  drivers/{media/usb => staging/media}/tlg2300/Makefile      |  0
>  drivers/{media/usb => staging/media}/tlg2300/pd-alsa.c     |  0
>  drivers/{media/usb => staging/media}/tlg2300/pd-common.h   |  0
>  drivers/{media/usb => staging/media}/tlg2300/pd-dvb.c      |  0
>  drivers/{media/usb => staging/media}/tlg2300/pd-main.c     |  0
>  drivers/{media/usb => staging/media}/tlg2300/pd-radio.c    |  0
>  drivers/{media/usb => staging/media}/tlg2300/pd-video.c    |  0
>  drivers/{media/usb => staging/media}/tlg2300/vendorcmds.h  |  0
>  drivers/staging/media/vino/Kconfig                         | 24 +++++++++++++++++++++++
>  drivers/staging/media/vino/Makefile                        |  3 +++
>  drivers/{media/platform => staging/media/vino}/indycam.c   |  0
>  drivers/{media/platform => staging/media/vino}/indycam.h   |  0
>  drivers/{media/i2c => staging/media/vino}/saa7191.c        |  0
>  drivers/{media/i2c => staging/media/vino}/saa7191.h        |  0
>  drivers/{media/platform => staging/media/vino}/vino.c      |  0
>  drivers/{media/platform => staging/media/vino}/vino.h      |  0
>  include/media/v4l2-subdev.h                                |  6 ------
>  include/media/videobuf-dvb.h                               |  6 ------
>  145 files changed, 221 insertions(+), 1011 deletions(-)
>  rename drivers/{ => staging}/media/parport/Kconfig (65%)
>  rename drivers/{ => staging}/media/parport/Makefile (100%)
>  rename drivers/{ => staging}/media/parport/bw-qcam.c (100%)
>  rename drivers/{ => staging}/media/parport/c-qcam.c (100%)
>  rename drivers/{ => staging}/media/parport/pms.c (100%)
>  rename drivers/{ => staging}/media/parport/w9966.c (100%)
>  rename drivers/{media/usb => staging/media}/tlg2300/Kconfig (63%)
>  rename drivers/{media/usb => staging/media}/tlg2300/Makefile (100%)
>  rename drivers/{media/usb => staging/media}/tlg2300/pd-alsa.c (100%)
>  rename drivers/{media/usb => staging/media}/tlg2300/pd-common.h (100%)
>  rename drivers/{media/usb => staging/media}/tlg2300/pd-dvb.c (100%)
>  rename drivers/{media/usb => staging/media}/tlg2300/pd-main.c (100%)
>  rename drivers/{media/usb => staging/media}/tlg2300/pd-radio.c (100%)
>  rename drivers/{media/usb => staging/media}/tlg2300/pd-video.c (100%)
>  rename drivers/{media/usb => staging/media}/tlg2300/vendorcmds.h (100%)
>  create mode 100644 drivers/staging/media/vino/Kconfig
>  create mode 100644 drivers/staging/media/vino/Makefile
>  rename drivers/{media/platform => staging/media/vino}/indycam.c (100%)
>  rename drivers/{media/platform => staging/media/vino}/indycam.h (100%)
>  rename drivers/{media/i2c => staging/media/vino}/saa7191.c (100%)
>  rename drivers/{media/i2c => staging/media/vino}/saa7191.h (100%)
>  rename drivers/{media/platform => staging/media/vino}/vino.c (100%)
>  rename drivers/{media/platform => staging/media/vino}/vino.h (100%)
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

