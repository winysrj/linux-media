Return-path: <linux-media-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:44208 "EHLO
        atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726147AbeJNNym (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 14 Oct 2018 09:54:42 -0400
Date: Sun, 14 Oct 2018 08:14:38 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: linux-media@vger.kernel.org, hverkuil@xs4all.nl,
        tfiga@chromium.org, bingbu.cao@intel.com, jian.xu.zheng@intel.com,
        rajmohan.mani@intel.com, tian.shu.qiu@intel.com,
        ricardo.ribalda@gmail.com, grundler@chromium.org,
        ping-chung.chen@intel.com, andy.yeh@intel.com, jim.lai@intel.com,
        helmut.grohne@intenta.de, laurent.pinchart@ideasonboard.com,
        snawrocki@kernel.org
Subject: Re: [PATCH 2/5] v4l: controls: Add support for exponential bases,
 prefixes and units
Message-ID: <20181014061437.GA2976@localhost>
References: <20180925101434.20327-1-sakari.ailus@linux.intel.com>
 <20180925101434.20327-3-sakari.ailus@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180925101434.20327-3-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi!

> Add support for exponential bases, prefixes as well as units for V4L2
> controls. This makes it possible to convey information on the relation
> between the control value and the hardware feature being controlled.
> 
> Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>

Sounds good.

> +/* V4L2 control exponential bases */
> +#define V4L2_CTRL_BASE_UNDEFINED	0
> +#define V4L2_CTRL_BASE_LINEAR		1
> +#define V4L2_CTRL_BASE_2		2
> +#define V4L2_CTRL_BASE_10		10

Do we also want to support logarithmic and 1/x? 

For example focus is usually in diopters and thats 1/meter...

> +/* V4L2 control units */
> +#define V4L2_CTRL_UNIT_UNDEFINED	0
> +#define V4L2_CTRL_UNIT_NONE		1
> +#define V4L2_CTRL_UNIT_SECOND		2
> +#define V4L2_CTRL_UNIT_AMPERE		3
> +#define V4L2_CTRL_UNIT_LINE		4
> +#define V4L2_CTRL_UNIT_PIXEL		5
> +#define V4L2_CTRL_UNIT_PIXELS_PER_SEC	6
> +#define V4L2_CTRL_UNIT_HZ		7

And Hz is 1/second.

Should we also have some support for ISO-sensitivity and f/ aperture numbers?


Thanks,
								Pavel
