Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:58748 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1750908AbdJFHtN (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 6 Oct 2017 03:49:13 -0400
Date: Fri, 6 Oct 2017 10:49:10 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Tim Harvey <tharvey@gateworks.com>
Cc: linux-media <linux-media@vger.kernel.org>,
        Hans Verkuil <hansverk@cisco.com>,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Steve Longerbeam <slongerbeam@gmail.com>
Subject: Re: IMX CSI max pixel rate
Message-ID: <20171006074909.gy24vp2xvsnrtmzl@valkosipuli.retiisi.org.uk>
References: <CAJ+vNU1kx-mwBZZj=DrOX=Lq5+WuJS9gDj+N6rAaV+4XOW1zcA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJ+vNU1kx-mwBZZj=DrOX=Lq5+WuJS9gDj+N6rAaV+4XOW1zcA@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Oct 05, 2017 at 10:21:16AM -0700, Tim Harvey wrote:
> Greetings,
> 
> I'm working on a HDMI receiver driver for the TDA1997x
> (https://lwn.net/Articles/734692/) and wanted to throw an error if the
> detected input resolution/vidout-output-bus-format exceeded the max
> pixel rate of the SoC capture bus the chip connects to (in my case is
> the IMX6 CSI which has a limit of 180MP/sec).
> 
> Any recommendations on where a dt property should live, its naming,
> and location/naming and functions to validate the pixel rate or is
> there even any interest in this sort of check?

Why a DT property?

We do have V4L2_CID_PIXEL_RATE, would that be applicable for this?

<URL:https://hverkuil.home.xs4all.nl/spec/uapi/v4l/extended-controls.html#image-process-control-ids>

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi
