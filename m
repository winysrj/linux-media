Return-path: <linux-media-owner@vger.kernel.org>
Received: from guitar.tcltek.co.il ([192.115.133.116]:50482 "EHLO
	mx.tkos.co.il" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752430AbaBYJzU (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 25 Feb 2014 04:55:20 -0500
Date: Tue, 25 Feb 2014 11:55:15 +0200
From: Baruch Siach <baruch@tkos.co.il>
To: Sylwester Nawrocki <s.nawrocki@samsung.com>
Cc: linux-media@vger.kernel.org, devicetree@vger.kernel.org,
	mark.rutland@arm.com, linux-samsung-soc@vger.kernel.org,
	a.hajda@samsung.com, kyungmin.park@samsung.com, robh+dt@kernel.org,
	galak@codeaurora.org, kgene.kim@samsung.com,
	linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v5 04/10] V4L: Add driver for s5k6a3 image sensor
Message-ID: <20140225095515.GV4869@tarshish>
References: <1393263322-28215-1-git-send-email-s.nawrocki@samsung.com>
 <1393263322-28215-5-git-send-email-s.nawrocki@samsung.com>
 <20140224193838.GL4869@tarshish>
 <530C6692.6090307@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <530C6692.6090307@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sylwester,

On Tue, Feb 25, 2014 at 10:46:58AM +0100, Sylwester Nawrocki wrote:
> On 24/02/14 20:38, Baruch Siach wrote:
> > On Mon, Feb 24, 2014 at 06:35:16PM +0100, Sylwester Nawrocki wrote:
> >> > This patch adds subdev driver for Samsung S5K6A3 raw image sensor.
> >> > As it is intended at the moment to be used only with the Exynos
> >> > FIMC-IS (camera ISP) subsystem it is pretty minimal subdev driver.
> >> > It doesn't do any I2C communication since the sensor is controlled
> >> > by the ISP and its own firmware.
> >> > This driver, if needed, can be updated in future into a regular
> >> > subdev driver where the main CPU communicates with the sensor
> >> > directly.
> >> > 
> >> > Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
> >> > Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
> >
> > [...]
> > 
> >> > +static int s5k6a3_open(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh)
> >> > +{
> >> > +	struct v4l2_mbus_framefmt *format = v4l2_subdev_get_try_format(fh, 0);
> >> > +
> >> > +	*format		= s5k6a3_formats[0];
> >> > +	format->width	= S5K6A3_DEFAULT_WIDTH;
> >> > +	format->height	= S5K6A3_DEFAULT_HEIGHT;
> >> > +
> >> > +	return 0;
> >> > +}
> >> > +
> >> > +static const struct v4l2_subdev_internal_ops s5k6a3_sd_internal_ops = {
> >> > +	.open = s5k6a3_open,
> >> > +};
> >
> > Where is this used?
> 
> This will be called when user process opens the corresponding /dev/v4l-subdev*
> device node. More details on the v4l2 sub-device interface can be found at [1],
> [2]. The device node is created by an aggregate media device driver, once all
> required sub-devices are registered to it.
> The above v4l2_subdev_internal_ops::open() implementation is pretty simple,
> it just sets V4L2_SUBDEV_FORMAT_TRY format to some initial default value.
> That's a per file handle value, so each process opening a set of sub-devices
> can try pipeline configuration independently. 
> 
> [1] http://linuxtv.org/downloads/v4l-dvb-apis/subdev.html
> [2] http://linuxtv.org/downloads/v4l-dvb-apis/vidioc-subdev-g-fmt.html

Thanks for the explanation. However, I've found no reference to the 
s5k6a3_sd_internal_ops struct in the driver code. There surly has to be at 
least one reference for the upper layer to access these ops.

baruch

-- 
     http://baruch.siach.name/blog/                  ~. .~   Tk Open Systems
=}------------------------------------------------ooO--U--Ooo------------{=
   - baruch@tkos.co.il - tel: +972.2.679.5364, http://www.tkos.co.il -
