Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud6.xs4all.net ([194.109.24.31]:49401 "EHLO
        lb3-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750853AbdBMMqO (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 13 Feb 2017 07:46:14 -0500
Subject: Re: [PATCH v3 0/7] Add V4L2 SDR (DRIF & MAX2175) driver
To: Ramesh Shanmugasundaram <ramesh.shanmugasundaram@bp.renesas.com>,
        robh+dt@kernel.org, mark.rutland@arm.com, mchehab@kernel.org,
        sakari.ailus@linux.intel.com, crope@iki.fi
References: <1486479757-32128-1-git-send-email-ramesh.shanmugasundaram@bp.renesas.com>
Cc: chris.paterson2@renesas.com, laurent.pinchart@ideasonboard.com,
        geert+renesas@glider.be, linux-media@vger.kernel.org,
        devicetree@vger.kernel.org, linux-renesas-soc@vger.kernel.org
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <fe15c9ed-be08-c954-5891-c42ec7584b46@xs4all.nl>
Date: Mon, 13 Feb 2017 13:46:08 +0100
MIME-Version: 1.0
In-Reply-To: <1486479757-32128-1-git-send-email-ramesh.shanmugasundaram@bp.renesas.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 02/07/2017 04:02 PM, Ramesh Shanmugasundaram wrote:
> Hi Media, DT maintainers, All,
> 
> This patch set contains two drivers
>  - Renesas R-Car Digital Radio Interface (DRIF) driver
>  - Maxim's MAX2175 RF to Bits tuner driver
> 
> These patches were based on top of media-tree repo
> commit: 47b037a0512d9f8675ec2693bed46c8ea6a884ab
> 
> These two drivers combined together expose a V4L2 SDR device that is compliant with the V4L2 framework [1]. Agreed review comments are incorporated in this series.
> 
> The rcar_drif device is modelled using "renesas,bonding" property. The discussion on this property is available here [2].

Other than the single comment I had it all looks good. Once I have Acks for the
bindings and from Laurent for the rcar part I can merge it.

Regards,

	Hans

> 
> Change history:
> 
> v2 -> v3:
> rcar_drif:
>  - Reduced DRIF DT properties to expose tested I2S mode only (Hans - discussion on #v4l)
>  - Fixed error path clean up of ctrl_hdl on rcar_drif
> 
> v1 -> v2:
>  - SDR formats renamed as "planar" instead of sliced (Hans)
>  - Documentation formatting correction (Laurent)
> 
>  rcar_drif:
>  - DT model using "bonding" property
>  - Addressed Laurent's coments on bindings - DT optional parameters rename & rework
>  - Addressed Han's comments on driver
>  - Addressed Geert's comments on DT
> 
>  max2175:
>  - Avoided scaling using method proposed by Antti. Thanks
>  - Bindings is a separate patch (Rob)
>  - Addressed Rob's comment on bindings
>  - Added Custom controls documentation (Laurent)
> 
> [1] v4l2-compliance report
> 
> root@salvator-x:~# v4l2-compliance -S /dev/swradio0
> v4l2-compliance SHA   : 788b674f3827607c09c31be11c91638f816aa6ae
> 
> Driver Info:
>         Driver name   : rcar_drif
>         Card type     : R-Car DRIF
>         Bus info      : platform:R-Car DRIF
>         Driver version: 4.10.0
>         Capabilities  : 0x85310000
>                 SDR Capture
>                 Tuner
>                 Read/Write
>                 Streaming
>                 Extended Pix Format
>                 Device Capabilities
>         Device Caps   : 0x05310000
>                 SDR Capture
>                 Tuner
>                 Read/Write
>                 Streaming
>                 Extended Pix Format
> 
> Compliance test for device /dev/swradio0 (not using libv4l2):
> 
> Required ioctls:
>         test VIDIOC_QUERYCAP: OK
> 
> Allow for multiple opens:
>         test second sdr open: OK
>         test VIDIOC_QUERYCAP: OK
>         test VIDIOC_G/S_PRIORITY: OK
>         test for unlimited opens: OK
> 
> Debug ioctls:
>         test VIDIOC_DBG_G/S_REGISTER: OK
>         test VIDIOC_LOG_STATUS: OK
> 
> Input ioctls:
>         test VIDIOC_G/S_TUNER/ENUM_FREQ_BANDS: OK
>         test VIDIOC_G/S_FREQUENCY: OK
>         test VIDIOC_S_HW_FREQ_SEEK: OK (Not Supported)
>         test VIDIOC_ENUMAUDIO: OK (Not Supported)
>         test VIDIOC_G/S/ENUMINPUT: OK (Not Supported)
>         test VIDIOC_G/S_AUDIO: OK (Not Supported)
>         Inputs: 0 Audio Inputs: 0 Tuners: 1
> 
> Output ioctls:
>         test VIDIOC_G/S_MODULATOR: OK (Not Supported)
>         test VIDIOC_G/S_FREQUENCY: OK
>         test VIDIOC_ENUMAUDOUT: OK (Not Supported)
>         test VIDIOC_G/S/ENUMOUTPUT: OK (Not Supported)
>         test VIDIOC_G/S_AUDOUT: OK (Not Supported)
>         Outputs: 0 Audio Outputs: 0 Modulators: 0
> 
> Input/Output configuration ioctls:
>         test VIDIOC_ENUM/G/S/QUERY_STD: OK (Not Supported)
>         test VIDIOC_ENUM/G/S/QUERY_DV_TIMINGS: OK (Not Supported)
>         test VIDIOC_DV_TIMINGS_CAP: OK (Not Supported)
>         test VIDIOC_G/S_EDID: OK (Not Supported)
> 
>         Control ioctls:
>                 test VIDIOC_QUERY_EXT_CTRL/QUERYMENU: OK
>                 test VIDIOC_QUERYCTRL: OK
>                 test VIDIOC_G/S_CTRL: OK
>                 test VIDIOC_G/S/TRY_EXT_CTRLS: OK
>                 test VIDIOC_(UN)SUBSCRIBE_EVENT/DQEVENT: OK
>                 test VIDIOC_G/S_JPEGCOMP: OK (Not Supported)
>                 Standard Controls: 5 Private Controls: 3
> 
>         Format ioctls:
>                 test VIDIOC_ENUM_FMT/FRAMESIZES/FRAMEINTERVALS: OK
>                 test VIDIOC_G/S_PARM: OK (Not Supported)
>                 test VIDIOC_G_FBUF: OK (Not Supported)
>                 test VIDIOC_G_FMT: OK
>                 test VIDIOC_TRY_FMT: OK
>                 test VIDIOC_S_FMT: OK
>                 test VIDIOC_G_SLICED_VBI_CAP: OK (Not Supported)
>                 test Cropping: OK (Not Supported)
>                 test Composing: OK (Not Supported)
>                 test Scaling: OK (Not Supported)
> 
>         Codec ioctls:
>                 test VIDIOC_(TRY_)ENCODER_CMD: OK (Not Supported)
>                 test VIDIOC_G_ENC_INDEX: OK (Not Supported)
>                 test VIDIOC_(TRY_)DECODER_CMD: OK (Not Supported)
> 
>         Buffer ioctls:
>                 test VIDIOC_REQBUFS/CREATE_BUFS/QUERYBUF: OK
>                 test VIDIOC_EXPBUF: OK (Not Supported)
> 
> Test input 0:
> 
> 
> Total: 43, Succeeded: 43, Failed: 0, Warnings: 0
> root@salvator-x:~#
> 
> [2] "bonding" DT property discussion (https://www.mail-archive.com/linux-renesas-soc@vger.kernel.org/msg09415.html)
> 
> Ramesh Shanmugasundaram (7):
>   media: v4l2-ctrls: Reserve controls for MAX217X
>   dt-bindings: media: Add MAX2175 binding description
>   media: i2c: max2175: Add MAX2175 support
>   media: Add new SDR formats PC16, PC18 & PC20
>   doc_rst: media: New SDR formats PC16, PC18 & PC20
>   dt-bindings: media: Add Renesas R-Car DRIF binding
>   media: platform: rcar_drif: Add DRIF support
> 
>  .../devicetree/bindings/media/i2c/max2175.txt      |   61 +
>  .../devicetree/bindings/media/renesas,drif.txt     |  186 +++
>  .../devicetree/bindings/property-units.txt         |    1 +
>  .../media/uapi/v4l/pixfmt-sdr-pcu16be.rst          |   55 +
>  .../media/uapi/v4l/pixfmt-sdr-pcu18be.rst          |   55 +
>  .../media/uapi/v4l/pixfmt-sdr-pcu20be.rst          |   54 +
>  Documentation/media/uapi/v4l/sdr-formats.rst       |    3 +
>  Documentation/media/v4l-drivers/index.rst          |    1 +
>  Documentation/media/v4l-drivers/max2175.rst        |   60 +
>  drivers/media/i2c/Kconfig                          |    4 +
>  drivers/media/i2c/Makefile                         |    2 +
>  drivers/media/i2c/max2175/Kconfig                  |    8 +
>  drivers/media/i2c/max2175/Makefile                 |    4 +
>  drivers/media/i2c/max2175/max2175.c                | 1438 ++++++++++++++++++
>  drivers/media/i2c/max2175/max2175.h                |  108 ++
>  drivers/media/platform/Kconfig                     |   25 +
>  drivers/media/platform/Makefile                    |    1 +
>  drivers/media/platform/rcar_drif.c                 | 1534 ++++++++++++++++++++
>  drivers/media/v4l2-core/v4l2-ioctl.c               |    3 +
>  include/uapi/linux/v4l2-controls.h                 |    5 +
>  include/uapi/linux/videodev2.h                     |    3 +
>  21 files changed, 3611 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/media/i2c/max2175.txt
>  create mode 100644 Documentation/devicetree/bindings/media/renesas,drif.txt
>  create mode 100644 Documentation/media/uapi/v4l/pixfmt-sdr-pcu16be.rst
>  create mode 100644 Documentation/media/uapi/v4l/pixfmt-sdr-pcu18be.rst
>  create mode 100644 Documentation/media/uapi/v4l/pixfmt-sdr-pcu20be.rst
>  create mode 100644 Documentation/media/v4l-drivers/max2175.rst
>  create mode 100644 drivers/media/i2c/max2175/Kconfig
>  create mode 100644 drivers/media/i2c/max2175/Makefile
>  create mode 100644 drivers/media/i2c/max2175/max2175.c
>  create mode 100644 drivers/media/i2c/max2175/max2175.h
>  create mode 100644 drivers/media/platform/rcar_drif.c
> 
