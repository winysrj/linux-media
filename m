Return-path: <mchehab@pedra>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:39206 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755884Ab0KJNSB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 10 Nov 2010 08:18:01 -0500
Received: by bwz15 with SMTP id 15so731958bwz.19
        for <linux-media@vger.kernel.org>; Wed, 10 Nov 2010 05:18:00 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <AANLkTimmDcxZsNEruFrr+qwnairJRZGCsnOTJBA7BPQu@mail.gmail.com>
References: <1289228045-4512-1-git-send-email-manjunath.hadli@ti.com>
	<AANLkTimmDcxZsNEruFrr+qwnairJRZGCsnOTJBA7BPQu@mail.gmail.com>
Date: Wed, 10 Nov 2010 08:17:58 -0500
Message-ID: <AANLkTinYg0zPK4kmgTyUGftLCqqtn6enpTpO+xhz9X-5@mail.gmail.com>
Subject: Re: [PATCH 0/6] davinci vpbe: V4L2 Display driver for DM644X
From: Muralidharan Karicheri <mkaricheri@gmail.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: "Hadli, Manjunath" <manjunath.hadli@ti.com>,
	linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hans,

Is it possible to extend the sub device ops to include SoC ip sub
device specific ops? I remember I had posted this question some time
back and you had proposed to add something like this. Just want to
check if that is still valid. This would make this driver
implementation little more cleaner.

struct vpbe_osd_ops;

struct v4l2_subdev_ops {
        const struct v4l2_subdev_core_ops       *core;
        const struct v4l2_subdev_tuner_ops      *tuner;
        const struct v4l2_subdev_audio_ops      *audio;
        const struct v4l2_subdev_video_ops      *video;
        const struct v4l2_subdev_vbi_ops        *vbi;
        const struct v4l2_subdev_ir_ops         *ir;
        const struct v4l2_subdev_sensor_ops     *sensor;
        /* SoC IP specific ops */
        const struct vpbe_osd_ops  *vpbe_osd;
 };

The struct vpbe_osd_ops will be defined in the osd sub device header
file. This will allow the host/bridge driver to call osd specific
operations like standard sub dev ops.

Any comments?

On Wed, Nov 10, 2010 at 8:05 AM, Muralidharan Karicheri
<mkaricheri@gmail.com> wrote:
> Manjunath,
>
> Thank you for putting up this patch together. I didn't see the 1/6 of
> this series in the mailing list. Also it appears as if the patch came
> from me. Please add my sign-off as second, you being the first.
>
> Murali
> On Mon, Nov 8, 2010 at 9:54 AM, Manjunath Hadli <manjunath.hadli@ti.com> wrote:
>> This driver is written for Texas Instruments's DM644X VPBE IP.
>> This SoC supports 2 video planes and 2 OSD planes as part of its
>> OSD (On Screen Display) block. The OSD lanes predminantly support
>> RGB space and the Video planes support YUV data. Out of these 4,
>> the 2 video planes are supported as part of the V4L2 driver. These
>> would be enumerated as video2 and video3 dev nodes.
>> The blending and video timing generator unit (VENC- for Video Encoder)
>> is the unit which combines/blends the output of these 4 planes
>> into a single stream and this output is given to Video input devices
>> like TV and other digital LCDs. The software for VENC is designed as
>> a subdevice with support for SD(NTSC and PAL) modes and 2 outputs.
>> This SoC forms the iniial implementation of its later additions
>> like DM355 and DM365.
>>
>> Muralidharan Karicheri (6):
>>  davinci vpbe: V4L2 display driver for DM644X SoC
>>  davinci vpbe: VPBE display driver
>>  davinci vpbe: OSD(On Screen Display ) block
>>  davinci vpbe: VENC( Video Encoder) implementation
>>  davinci vpbe: platform specific additions
>>  davinci vpbe: Build infrastructure for VPBE driver
>>
>>  arch/arm/mach-davinci/board-dm644x-evm.c     |   85 +-
>>  arch/arm/mach-davinci/dm644x.c               |  181 ++-
>>  arch/arm/mach-davinci/include/mach/dm644x.h  |    4 +
>>  drivers/media/video/davinci/Kconfig          |   22 +
>>  drivers/media/video/davinci/Makefile         |    2 +
>>  drivers/media/video/davinci/vpbe.c           |  861 ++++++++++
>>  drivers/media/video/davinci/vpbe_display.c   | 2283 ++++++++++++++++++++++++++
>>  drivers/media/video/davinci/vpbe_osd.c       | 1208 ++++++++++++++
>>  drivers/media/video/davinci/vpbe_osd_regs.h  |  389 +++++
>>  drivers/media/video/davinci/vpbe_venc.c      |  617 +++++++
>>  drivers/media/video/davinci/vpbe_venc_regs.h |  189 +++
>>  include/media/davinci/vpbe.h                 |  187 +++
>>  include/media/davinci/vpbe_display.h         |  144 ++
>>  include/media/davinci/vpbe_osd.h             |  397 +++++
>>  include/media/davinci/vpbe_types.h           |  170 ++
>>  include/media/davinci/vpbe_venc.h            |   70 +
>>  16 files changed, 6790 insertions(+), 19 deletions(-)
>>  create mode 100644 drivers/media/video/davinci/vpbe.c
>>  create mode 100644 drivers/media/video/davinci/vpbe_display.c
>>  create mode 100644 drivers/media/video/davinci/vpbe_osd.c
>>  create mode 100644 drivers/media/video/davinci/vpbe_osd_regs.h
>>  create mode 100644 drivers/media/video/davinci/vpbe_venc.c
>>  create mode 100644 drivers/media/video/davinci/vpbe_venc_regs.h
>>  create mode 100644 include/media/davinci/vpbe.h
>>  create mode 100644 include/media/davinci/vpbe_display.h
>>  create mode 100644 include/media/davinci/vpbe_osd.h
>>  create mode 100644 include/media/davinci/vpbe_types.h
>>  create mode 100644 include/media/davinci/vpbe_venc.h
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-media" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
>
>
>
> --
> Murali Karicheri
> mkaricheri@gmail.com
>



-- 
Murali Karicheri
mkaricheri@gmail.com
