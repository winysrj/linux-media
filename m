Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:48244 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728378AbeGYPXe (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 25 Jul 2018 11:23:34 -0400
Date: Wed, 25 Jul 2018 17:11:40 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Rui Miguel Silva <rui.silva@linaro.org>
Cc: mchehab@kernel.org, sakari.ailus@linux.intel.com,
        hverkuil@xs4all.nl, linux-media@vger.kernel.org,
        Fabio Estevam <fabio.estevam@nxp.com>,
        Ryan Harkin <ryan.harkin@linaro.org>
Subject: Re: [PATCH v7 2/2] media: ov2680: Add Omnivision OV2680 sensor driver
Message-ID: <20180725141140.4n6ooxtqlnoeyqgs@valkosipuli.retiisi.org.uk>
References: <20180703140803.19580-1-rui.silva@linaro.org>
 <20180703140803.19580-3-rui.silva@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180703140803.19580-3-rui.silva@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Jul 03, 2018 at 03:08:03PM +0100, Rui Miguel Silva wrote:
> This patch adds V4L2 sub-device driver for OV2680 image sensor.
> The OV2680 is a 1/5" CMOS color sensor from Omnivision.
> Supports output format: 10-bit Raw RGB.
> The OV2680 has a single lane MIPI interface.
> 
> The driver exposes following V4L2 controls:
> - auto/manual exposure,
> - exposure,
> - auto/manual gain,
> - gain,
> - horizontal/vertical flip,
> - test pattern menu.
> Supported resolution are only: QUXGA, 720P, UXGA.
> 
> Signed-off-by: Rui Miguel Silva <rui.silva@linaro.org>

Hi Rui,

Could you provide a MAINTAINERS entry patch for the driver as well as the
DT bindings? I'll squash that to the first one.

-- 
Regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi
