Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud3.xs4all.net ([194.109.24.22]:56324 "EHLO
        lb1-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752490AbdEEMOV (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 5 May 2017 08:14:21 -0400
Subject: Re: [PATCH v4 3/7] media: i2c: max2175: Add MAX2175 support
To: Ramesh Shanmugasundaram <ramesh.shanmugasundaram@bp.renesas.com>,
        robh+dt@kernel.org, mark.rutland@arm.com, mchehab@kernel.org,
        sakari.ailus@linux.intel.com, crope@iki.fi
References: <20170502132615.42134-1-ramesh.shanmugasundaram@bp.renesas.com>
 <20170502132615.42134-4-ramesh.shanmugasundaram@bp.renesas.com>
Cc: chris.paterson2@renesas.com, laurent.pinchart@ideasonboard.com,
        geert+renesas@glider.be, linux-media@vger.kernel.org,
        devicetree@vger.kernel.org, linux-renesas-soc@vger.kernel.org
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <f4cda576-5ed1-05d0-1651-bc284387022c@xs4all.nl>
Date: Fri, 5 May 2017 14:13:59 +0200
MIME-Version: 1.0
In-Reply-To: <20170502132615.42134-4-ramesh.shanmugasundaram@bp.renesas.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 05/02/17 15:26, Ramesh Shanmugasundaram wrote:
> This patch adds driver support for the MAX2175 chip. This is Maxim
> Integrated's RF to Bits tuner front end chip designed for software-defined
> radio solutions. This driver exposes the tuner as a sub-device instance
> with standard and custom controls to configure the device.
> 
> Signed-off-by: Ramesh Shanmugasundaram <ramesh.shanmugasundaram@bp.renesas.com>
> ---
> v4:
>  - Addressed v4l2_ctrl name string convention (Hans)
>   - "HSLS above/below" to "HSLS Above/Below"
>   - "RX MODE" to "RX Mode"
> ---
>  Documentation/media/v4l-drivers/index.rst   |    1 +
>  Documentation/media/v4l-drivers/max2175.rst |   60 ++
>  drivers/media/i2c/Kconfig                   |    4 +
>  drivers/media/i2c/Makefile                  |    2 +
>  drivers/media/i2c/max2175/Kconfig           |    8 +
>  drivers/media/i2c/max2175/Makefile          |    4 +
>  drivers/media/i2c/max2175/max2175.c         | 1437 +++++++++++++++++++++++++++
>  drivers/media/i2c/max2175/max2175.h         |  108 ++
>  8 files changed, 1624 insertions(+)
>  create mode 100644 Documentation/media/v4l-drivers/max2175.rst
>  create mode 100644 drivers/media/i2c/max2175/Kconfig
>  create mode 100644 drivers/media/i2c/max2175/Makefile
>  create mode 100644 drivers/media/i2c/max2175/max2175.c
>  create mode 100644 drivers/media/i2c/max2175/max2175.h
> 
> diff --git a/Documentation/media/v4l-drivers/index.rst b/Documentation/media/v4l-drivers/index.rst
> index a606d1cdac13..d8cade53d496 100644
> --- a/Documentation/media/v4l-drivers/index.rst
> +++ b/Documentation/media/v4l-drivers/index.rst
> @@ -42,6 +42,7 @@ For more details see the file COPYING in the source distribution of Linux.
>  	davinci-vpbe
>  	fimc
>  	ivtv
> +        max2175
>  	meye
>  	omap3isp
>  	omap4_camera
> diff --git a/Documentation/media/v4l-drivers/max2175.rst b/Documentation/media/v4l-drivers/max2175.rst
> new file mode 100644
> index 000000000000..201af8f217e9
> --- /dev/null
> +++ b/Documentation/media/v4l-drivers/max2175.rst
> @@ -0,0 +1,60 @@
> +Maxim Integrated MAX2175 RF to bits tuner driver
> +================================================
> +
> +The MAX2175 driver implements the following driver-specific controls:
> +
> +``V4L2_CID_MAX2175_I2S_ENABLE``
> +-------------------------------
> +    Enable/Disable I2S output of the tuner.
> +
> +.. flat-table::
> +    :header-rows:  0
> +    :stub-columns: 0
> +    :widths:       1 4
> +
> +    * - ``(0)``
> +      - I2S output is disabled.
> +    * - ``(1)``
> +      - I2S output is enabled.
> +
> +``V4L2_CID_MAX2175_HSLS``
> +-------------------------
> +    The high-side/low-side (HSLS) control of the tuner for a given band.
> +
> +.. flat-table::
> +    :header-rows:  0
> +    :stub-columns: 0
> +    :widths:       1 4
> +
> +    * - ``(0)``
> +      - The LO frequency position is below the desired frequency.
> +    * - ``(1)``
> +      - The LO frequency position is above the desired frequency.
> +
> +``V4L2_CID_MAX2175_RX_MODE (menu)``
> +-----------------------------------
> +    The Rx mode controls a number of preset parameters of the tuner like sck

'sck' is short of 'sample clock' or something like that? I recommend that you
write this in full at least once in this documentation.

> +    rate, sampling rate etc. These multiple settings are provided under one
> +    single label called Rx mode in the datasheet. The list below shows the
> +    supported modes with a brief description.
> +
> +.. flat-table::
> +    :header-rows:  0
> +    :stub-columns: 0
> +    :widths:       1 4
> +
> +    * - ``"Europe modes"``
> +    * - ``"FM 1.2" (0)``
> +      - This configures FM band with a sample rate of 0.512 million
> +        samples/sec with a 10.24 MHz sck.
> +    * - ``"DAB 1.2" (1)``
> +      - This configures VHF band with a sample rate of 2.048 million
> +        samples/sec with a 32.768 MHz sck.
> +
> +    * - ``"North America modes"``
> +    * - ``"FM 1.0" (0)``
> +      - This configures FM band with a sample rate of 0.7441875 million
> +        samples/sec with a 14.88375 MHz sck.
> +    * - ``"DAB 1.2" (1)``
> +      - This configures FM band with a sample rate of 0.372 million
> +        samples/sec with a 7.441875 MHz sck.

Regards,

	Hans
