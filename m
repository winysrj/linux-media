Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr8.xs4all.nl ([194.109.24.28]:3116 "EHLO
	smtp-vbr8.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752595AbaH2LXd (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 29 Aug 2014 07:23:33 -0400
Received: from tschai.lan (173-38-208-169.cisco.com [173.38.208.169])
	(authenticated bits=0)
	by smtp-vbr8.xs4all.nl (8.13.8/8.13.8) with ESMTP id s7TBNTEW096478
	for <linux-media@vger.kernel.org>; Fri, 29 Aug 2014 13:23:31 +0200 (CEST)
	(envelope-from hverkuil@xs4all.nl)
Received: from [127.0.0.1] (localhost [127.0.0.1])
	by tschai.lan (Postfix) with ESMTPSA id A93D02A0757
	for <linux-media@vger.kernel.org>; Fri, 29 Aug 2014 13:23:26 +0200 (CEST)
Message-ID: <540062AE.2050200@xs4all.nl>
Date: Fri, 29 Aug 2014 13:23:26 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [GIT PULL FOR v3.18] Fix sparse warnings
References: <5400623C.5020505@xs4all.nl>
In-Reply-To: <5400623C.5020505@xs4all.nl>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 08/29/2014 01:21 PM, Hans Verkuil wrote:
> We still have too many sparse warnings, so this is another round of sparse
> warning cleanups.

I forgot to mention that this pull request combines these two patch series:

https://www.mail-archive.com/linux-media@vger.kernel.org/msg78429.html
https://www.mail-archive.com/linux-media@vger.kernel.org/msg78485.html

They are rebased but otherwise unchanged.

Regards,

	Hans

> 
> Regards,
> 
> 	Hans
> 
> The following changes since commit b250392f7b5062cf026b1423e27265e278fd6b30:
> 
>   [media] media: ttpci: fix av7110 build to be compatible with CONFIG_INPUT_EVDEV (2014-08-21 15:25:38 -0500)
> 
> are available in the git repository at:
> 
>   git://linuxtv.org/hverkuil/media_tree.git sparse
> 
> for you to fetch changes up to 7207dddb8cb0328c817f88f0447cd651703560a7:
> 
>   v4l2-compat-ioctl32: fix sparse warnings (2014-08-29 13:19:41 +0200)
> 
> ----------------------------------------------------------------
> Hans Verkuil (41):
>       img-ir: fix sparse warnings
>       solo6x10: fix sparse warnings
>       dibusb: fix sparse warnings
>       af9015: fix sparse warning
>       radio-tea5764: fix sparse warnings
>       dw2102: fix sparse warnings
>       mxl111sf: fix sparse warnings
>       opera1: fix sparse warnings
>       pctv452e: fix sparse warnings
>       go7007: fix sparse warnings
>       dib7000p: fix sparse warning
>       kinect: fix sparse warnings
>       ddbridge: fix sparse warnings
>       ngene: fix sparse warnings
>       drxj: fix sparse warnings
>       uvc: fix sparse warning
>       usbtv: fix sparse warnings
>       mb86a16/mb86a20s: fix sparse warnings
>       mantis: fix sparse warnings
>       wl128x: fix sparse warnings
>       bcm3510: fix sparse warnings
>       s2255drv: fix sparse warning
>       dvb_usb_core: fix sparse warning
>       pwc: fix sparse warning
>       stv0367: fix sparse warnings
>       si2165: fix sparse warning
>       imon: fix sparse warnings
>       v4l2-ioctl: fix sparse warnings
>       lirc_dev: fix sparse warnings
>       mt2063: fix sparse warnings
>       via-camera: fix sparse warning
>       cx25821: fix sparse warning
>       cx231xx: fix sparse warnings
>       dm1105: fix sparse warning
>       cxusb: fix sparse warning
>       cx23885: fix sparse warning
>       ivtv: fix sparse warnings
>       cx18: fix sparse warnings
>       em28xx: fix sparse warnings
>       videodev2.h: add __user to v4l2_ext_control pointers
>       v4l2-compat-ioctl32: fix sparse warnings
> 
>  drivers/media/dvb-frontends/bcm3510.c              |  4 ++--
>  drivers/media/dvb-frontends/dib7000p.c             |  2 +-
>  drivers/media/dvb-frontends/drx39xyj/drxj.c        | 38 +++++++++++++++++++-------------------
>  drivers/media/dvb-frontends/mb86a16.c              |  2 +-
>  drivers/media/dvb-frontends/mb86a20s.c             | 14 +++++++-------
>  drivers/media/dvb-frontends/si2165.c               |  2 +-
>  drivers/media/dvb-frontends/stv0367.c              |  4 ++--
>  drivers/media/pci/cx18/cx18-firmware.c             |  2 +-
>  drivers/media/pci/cx23885/cx23885-dvb.c            |  2 +-
>  drivers/media/pci/cx25821/cx25821-video-upstream.c |  5 +++--
>  drivers/media/pci/ddbridge/ddbridge-core.c         | 30 ++++++++++++++----------------
>  drivers/media/pci/ddbridge/ddbridge.h              | 12 +++++-------
>  drivers/media/pci/dm1105/dm1105.c                  |  2 +-
>  drivers/media/pci/ivtv/ivtv-irq.c                  | 12 +++++-------
>  drivers/media/pci/mantis/hopper_vp3028.c           |  2 +-
>  drivers/media/pci/mantis/mantis_common.h           |  2 +-
>  drivers/media/pci/mantis/mantis_vp1033.c           |  4 ++--
>  drivers/media/pci/mantis/mantis_vp1034.c           |  2 +-
>  drivers/media/pci/mantis/mantis_vp1041.c           |  4 ++--
>  drivers/media/pci/mantis/mantis_vp2033.c           |  4 ++--
>  drivers/media/pci/mantis/mantis_vp2040.c           |  4 ++--
>  drivers/media/pci/mantis/mantis_vp3030.c           |  4 ++--
>  drivers/media/pci/ngene/ngene-cards.c              |  2 +-
>  drivers/media/pci/ngene/ngene-core.c               | 14 ++++++--------
>  drivers/media/pci/ngene/ngene-dvb.c                |  5 ++---
>  drivers/media/pci/ngene/ngene.h                    |  2 +-
>  drivers/media/pci/solo6x10/solo6x10-disp.c         |  4 ++--
>  drivers/media/pci/solo6x10/solo6x10-eeprom.c       |  8 ++++----
>  drivers/media/pci/solo6x10/solo6x10.h              |  4 ++--
>  drivers/media/platform/via-camera.c                |  2 +-
>  drivers/media/radio/radio-tea5764.c                | 12 ++++++------
>  drivers/media/radio/wl128x/fmdrv_common.c          | 11 ++++++-----
>  drivers/media/radio/wl128x/fmdrv_rx.c              | 10 +++++-----
>  drivers/media/radio/wl128x/fmdrv_tx.c              |  2 +-
>  drivers/media/rc/img-ir/img-ir-hw.c                |  6 ------
>  drivers/media/rc/img-ir/img-ir-hw.h                |  6 ++++++
>  drivers/media/rc/imon.c                            |  8 ++++----
>  drivers/media/rc/lirc_dev.c                        | 14 +++++++-------
>  drivers/media/tuners/mt2063.c                      | 26 +++++++++++++-------------
>  drivers/media/usb/cx231xx/cx231xx-avcore.c         | 12 ++++++------
>  drivers/media/usb/cx231xx/cx231xx-core.c           |  2 +-
>  drivers/media/usb/cx231xx/cx231xx-dvb.c            |  4 ++--
>  drivers/media/usb/dvb-usb-v2/af9015.c              |  2 +-
>  drivers/media/usb/dvb-usb-v2/dvb_usb_core.c        |  2 +-
>  drivers/media/usb/dvb-usb-v2/mxl111sf.c            |  8 ++++----
>  drivers/media/usb/dvb-usb/cxusb.c                  |  2 +-
>  drivers/media/usb/dvb-usb/dibusb-common.c          | 12 ++++++------
>  drivers/media/usb/dvb-usb/dw2102.c                 | 14 +++++++-------
>  drivers/media/usb/dvb-usb/opera1.c                 |  4 ++--
>  drivers/media/usb/dvb-usb/pctv452e.c               |  8 ++++----
>  drivers/media/usb/em28xx/em28xx-cards.c            |  2 +-
>  drivers/media/usb/em28xx/em28xx-core.c             |  2 +-
>  drivers/media/usb/go7007/go7007-usb.c              |  4 ++--
>  drivers/media/usb/gspca/kinect.c                   | 12 ++++++------
>  drivers/media/usb/pwc/pwc-v4l.c                    |  2 +-
>  drivers/media/usb/s2255/s2255drv.c                 |  2 +-
>  drivers/media/usb/usbtv/usbtv-video.c              |  6 +++---
>  drivers/media/usb/uvc/uvc_video.c                  |  2 +-
>  drivers/media/v4l2-core/v4l2-compat-ioctl32.c      | 30 +++++++++++++++++++-----------
>  drivers/media/v4l2-core/v4l2-ioctl.c               |  4 ++--
>  include/uapi/linux/videodev2.h                     | 10 +++++-----
>  61 files changed, 220 insertions(+), 219 deletions(-)
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

