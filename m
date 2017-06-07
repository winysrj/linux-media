Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:52139
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751536AbdFGNRd (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 7 Jun 2017 09:17:33 -0400
Date: Wed, 7 Jun 2017 10:17:21 -0300
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Ramesh Shanmugasundaram <ramesh.shanmugasundaram@bp.renesas.com>
Cc: robh+dt@kernel.org, mark.rutland@arm.com, mchehab@kernel.org,
        hverkuil@xs4all.nl, sakari.ailus@linux.intel.com, crope@iki.fi,
        chris.paterson2@renesas.com, laurent.pinchart@ideasonboard.com,
        geert+renesas@glider.be, linux-media@vger.kernel.org,
        devicetree@vger.kernel.org, linux-renesas-soc@vger.kernel.org
Subject: Re: [PATCH v6 3/7] media: i2c: max2175: Add MAX2175 support
Message-ID: <20170607101721.064aafe4@vento.lan>
In-Reply-To: <20170531084457.4800-4-ramesh.shanmugasundaram@bp.renesas.com>
References: <20170531084457.4800-1-ramesh.shanmugasundaram@bp.renesas.com>
        <20170531084457.4800-4-ramesh.shanmugasundaram@bp.renesas.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Wed, 31 May 2017 09:44:53 +0100
Ramesh Shanmugasundaram <ramesh.shanmugasundaram@bp.renesas.com> escreveu:

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

Hmm... There are other drivers at the subsystem that use I2S
(for audio - not for SDR - but I guess the issue is similar).

On such drivers, the bridge driver controls it directly, being sure
that I2S is enabled when it is expecting some data coming from the
I2S bus.

On some drivers, there are both I2S and A/D inputs at the
bridge chipset. On such drivers, enabling/disabling I2S is
done via VIDIOC_S_INPUT (and optionally via ALSA mixer), being
transparent to the user if the stream comes from a tuner via I2S
or from a directly connected A/D input.

I don't think it is a good idea to enable it via a control, as,
if the bridge driver is expecting data via I2S, disabling it will
cause timeouts at the videobuf handling.

Thanks,
Mauro
