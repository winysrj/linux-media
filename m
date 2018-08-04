Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud7.xs4all.net ([194.109.24.28]:44006 "EHLO
        lb2-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726744AbeHDOob (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 4 Aug 2018 10:44:31 -0400
Subject: Re: [PATCH v6 0/8] Cedrus driver for the Allwinner Video Engine,
 using media requests
To: Paul Kocialkowski <paul.kocialkowski@bootlin.com>,
        linux-media@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        devel@driverdev.osuosl.org
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Maxime Ripard <maxime.ripard@bootlin.com>,
        Chen-Yu Tsai <wens@csie.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        linux-sunxi@googlegroups.com,
        Hugues Fruchet <hugues.fruchet@st.com>,
        Randy Li <ayaka@soulik.info>,
        Ezequiel Garcia <ezequiel@collabora.com>,
        Tomasz Figa <tfiga@chromium.org>,
        Alexandre Courbot <acourbot@chromium.org>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>
References: <20180725100256.22833-1-paul.kocialkowski@bootlin.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <4e8a0286-7e49-5622-1895-ac3268224152@xs4all.nl>
Date: Sat, 4 Aug 2018 14:43:48 +0200
MIME-Version: 1.0
In-Reply-To: <20180725100256.22833-1-paul.kocialkowski@bootlin.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 07/25/2018 12:02 PM, Paul Kocialkowski wrote:
> This is the sixth iteration of the updated Cedrus driver,
> that supports the Video Engine found in most Allwinner SoCs, starting
> with the A10. It was tested on the A13, A20, A33 and H3.
> 
> The initial version of this driver[0] was originally written and
> submitted by Florent Revest using a previous version of the request API
> that is necessary to provide coherency between controls and the buffers
> they apply to.
> 
> The driver was adapted to use the latest version of the media request
> API[1], as submitted by Hand Verkuil. Media request API support is a
> hard requirement for the Cedrus driver.
> 
> The driver itself currently only supports MPEG2 and more codecs will be
> added to the driver eventually. The output frames provided by the
> Video Engine are in a multi-planar 32x32-tiled YUV format, with a plane
> for luminance (Y) and a plane for chrominance (UV). A specific format is
> introduced in the V4L2 API to describe it.
> 
> This implementation is based on the significant work that was conducted
> by various members of the linux-sunxi community for understanding and
> documenting the Video Engine's innards.
> 
> In addition to the media requests API, the following series are required
> for Cedrus:
> * vicodec: the Virtual Codec driver

This will appear in for 4.19.

> * allwinner: a64: add SRAM controller / system control
> * SRAM patches from the Cedrus VPU driver series version 5

What about these? Are they queued up for 4.19 as well?

I'll post a rebased reqv17 later today that includes the
"add v4l2_ctrl_request_hdl_find/put/ctrl_find functions" patch.

Regards,

	Hans
