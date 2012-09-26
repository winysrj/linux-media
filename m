Return-path: <linux-media-owner@vger.kernel.org>
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:33515
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752526Ab2IZUcn (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 26 Sep 2012 16:32:43 -0400
Date: Wed, 26 Sep 2012 17:32:33 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Sangwook Lee <sangwook.lee@linaro.org>
Cc: linux-media@vger.kernel.org, laurent.pinchart@ideasonboard.com,
	kyungmin.park@samsung.com, hans.verkuil@cisco.com,
	linaro-dev@lists.linaro.org, patches@linaro.org,
	Francesco Lavra <francescolavra.fl@gmail.com>,
	Scott Bambrough <scott.bambrough@linaro.org>,
	Homin Lee <suapapa@insignal.co.kr>
Subject: Re: [RFC PATCH v8] media: add v4l2 subdev driver for S5K4ECGX
 sensor
Message-ID: <20120926173233.01d64f9a@infradead.org>
In-Reply-To: <1347534134-6231-1-git-send-email-sangwook.lee@linaro.org>
References: <1347534134-6231-1-git-send-email-sangwook.lee@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Thu, 13 Sep 2012 12:02:14 +0100
Sangwook Lee <sangwook.lee@linaro.org> escreveu:

> This patch adds driver for S5K4ECGX sensor with embedded ISP SoC,
> S5K4ECGX, which is a 5M CMOS Image sensor from Samsung
> The driver implements preview mode of the S5K4ECGX sensor.
> capture (snapshot) operation, face detection are missing now.
> Following controls are supported:
> contrast/saturation/brightness/sharpness
> 
> Signed-off-by: Sangwook Lee <sangwook.lee@linaro.org>
> Reviewed-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
> Cc: Francesco Lavra <francescolavra.fl@gmail.com>
> Cc: Scott Bambrough <scott.bambrough@linaro.org>
> Cc: Homin Lee <suapapa@insignal.co.kr>

...

> +static int s5k4ecgx_load_firmware(struct v4l2_subdev *sd)
> +{
> +	const struct firmware *fw;
> +	const u8 *ptr;
> +	int err, i, regs_num;
> +	struct i2c_client *client = v4l2_get_subdevdata(sd);
> +	u16 val;
> +	u32 addr, crc, crc_file, addr_inc = 0;
> +
> +	err = request_firmware(&fw, S5K4ECGX_FIRMWARE, sd->v4l2_dev->dev);

The patch looks correct on my eyes... Yet, calling request_firmware()
might not be the right thing to do. The thing is that newer versions of
udev refuse to load firmware synchronously during probe/init time.

As this function is actually called by s_power, maybe this driver doesn't
suffer from that new udev behavior, so, I'll be merging it as-is. However,
I suggest you to take a deeper review on that and, if possible, test it with
the latest udev.


Cheers,
Mauro
