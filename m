Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:60606 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751187Ab2I0K2Y (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 27 Sep 2012 06:28:24 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
	Sangwook Lee <sangwook.lee@linaro.org>,
	linux-media@vger.kernel.org, kyungmin.park@samsung.com,
	hans.verkuil@cisco.com, linaro-dev@lists.linaro.org,
	patches@linaro.org, Francesco Lavra <francescolavra.fl@gmail.com>,
	Scott Bambrough <scott.bambrough@linaro.org>,
	Homin Lee <suapapa@insignal.co.kr>
Subject: Re: [RFC PATCH v8] media: add v4l2 subdev driver for S5K4ECGX sensor
Date: Thu, 27 Sep 2012 12:29:02 +0200
Message-ID: <26977337.5fKA5VVu6u@avalon>
In-Reply-To: <50637AF4.9080002@gmail.com>
References: <1347534134-6231-1-git-send-email-sangwook.lee@linaro.org> <20120926173233.01d64f9a@infradead.org> <50637AF4.9080002@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sylwester,

On Thursday 27 September 2012 00:00:20 Sylwester Nawrocki wrote:
> On 09/26/2012 10:32 PM, Mauro Carvalho Chehab wrote:
> > Em Thu, 13 Sep 2012 12:02:14 +0100 Sangwook Lee escreveu:
> >> This patch adds driver for S5K4ECGX sensor with embedded ISP SoC,
> >> S5K4ECGX, which is a 5M CMOS Image sensor from Samsung
> >> The driver implements preview mode of the S5K4ECGX sensor.
> >> capture (snapshot) operation, face detection are missing now.
> >> Following controls are supported:
> >> contrast/saturation/brightness/sharpness
> >> 
> >> Signed-off-by: Sangwook Lee<sangwook.lee@linaro.org>
> >> Reviewed-by: Sylwester Nawrocki<s.nawrocki@samsung.com>
> >> Cc: Francesco Lavra<francescolavra.fl@gmail.com>
> >> Cc: Scott Bambrough<scott.bambrough@linaro.org>
> >> Cc: Homin Lee<suapapa@insignal.co.kr>
> > 
> > ...
> > 
> >> +static int s5k4ecgx_load_firmware(struct v4l2_subdev *sd)
> >> +{
> >> +	const struct firmware *fw;
> >> +	const u8 *ptr;
> >> +	int err, i, regs_num;
> >> +	struct i2c_client *client = v4l2_get_subdevdata(sd);
> >> +	u16 val;
> >> +	u32 addr, crc, crc_file, addr_inc = 0;
> >> +
> >> +	err = request_firmware(&fw, S5K4ECGX_FIRMWARE, sd->v4l2_dev->dev);
> > 
> > The patch looks correct on my eyes... Yet, calling request_firmware()
> > might not be the right thing to do. The thing is that newer versions of
> > udev refuse to load firmware synchronously during probe/init time.
> > 
> > As this function is actually called by s_power, maybe this driver doesn't
> > suffer from that new udev behavior, so, I'll be merging it as-is. However,
> > I suggest you to take a deeper review on that and, if possible, test it
> > with the latest udev.
> 
> True, it's indeed a bit tricky. The host interface driver this sensor driver
> has been tested with calls s_power on a subdev only in response to a video
> device open(). During probe only subdev's .registered() callback is called.
> And there is no request_firmware() there, as it is not needed to boot the
> sensor's MCU. The "firmware" is really just a set of settings that are
> normally needed only before streaming needs to be started.

That triggers a red flag warning :-) What kind of settings do you have in the 
"firmware" ?

> We have analysed this issue and hopefully there should be no
> request_firmware() calls from within probe(), as long as the host interface
> driver doesn't call s_power from it's probe() callback. I'm afraid it's not
> the case for all bridge drivers though. If needed we could probably try and
> use request_firmware_nowait(), but it seems better to me to make sure the
> bridge drivers don't call s_power from within their probe() callback.

-- 
Regards,

Laurent Pinchart

