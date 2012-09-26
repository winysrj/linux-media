Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:34447 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751928Ab2IZWAZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 26 Sep 2012 18:00:25 -0400
Received: by weyt9 with SMTP id t9so262821wey.19
        for <linux-media@vger.kernel.org>; Wed, 26 Sep 2012 15:00:23 -0700 (PDT)
Message-ID: <50637AF4.9080002@gmail.com>
Date: Thu, 27 Sep 2012 00:00:20 +0200
From: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@infradead.org>
CC: Sangwook Lee <sangwook.lee@linaro.org>,
	linux-media@vger.kernel.org, laurent.pinchart@ideasonboard.com,
	kyungmin.park@samsung.com, hans.verkuil@cisco.com,
	linaro-dev@lists.linaro.org, patches@linaro.org,
	Francesco Lavra <francescolavra.fl@gmail.com>,
	Scott Bambrough <scott.bambrough@linaro.org>,
	Homin Lee <suapapa@insignal.co.kr>
Subject: Re: [RFC PATCH v8] media: add v4l2 subdev driver for S5K4ECGX sensor
References: <1347534134-6231-1-git-send-email-sangwook.lee@linaro.org> <20120926173233.01d64f9a@infradead.org>
In-Reply-To: <20120926173233.01d64f9a@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 09/26/2012 10:32 PM, Mauro Carvalho Chehab wrote:
> Em Thu, 13 Sep 2012 12:02:14 +0100
> Sangwook Lee<sangwook.lee@linaro.org>  escreveu:
> 
>> This patch adds driver for S5K4ECGX sensor with embedded ISP SoC,
>> S5K4ECGX, which is a 5M CMOS Image sensor from Samsung
>> The driver implements preview mode of the S5K4ECGX sensor.
>> capture (snapshot) operation, face detection are missing now.
>> Following controls are supported:
>> contrast/saturation/brightness/sharpness
>>
>> Signed-off-by: Sangwook Lee<sangwook.lee@linaro.org>
>> Reviewed-by: Sylwester Nawrocki<s.nawrocki@samsung.com>
>> Cc: Francesco Lavra<francescolavra.fl@gmail.com>
>> Cc: Scott Bambrough<scott.bambrough@linaro.org>
>> Cc: Homin Lee<suapapa@insignal.co.kr>
> 
> ...
> 
>> +static int s5k4ecgx_load_firmware(struct v4l2_subdev *sd)
>> +{
>> +	const struct firmware *fw;
>> +	const u8 *ptr;
>> +	int err, i, regs_num;
>> +	struct i2c_client *client = v4l2_get_subdevdata(sd);
>> +	u16 val;
>> +	u32 addr, crc, crc_file, addr_inc = 0;
>> +
>> +	err = request_firmware(&fw, S5K4ECGX_FIRMWARE, sd->v4l2_dev->dev);
> 
> The patch looks correct on my eyes... Yet, calling request_firmware()
> might not be the right thing to do. The thing is that newer versions of
> udev refuse to load firmware synchronously during probe/init time.
> 
> As this function is actually called by s_power, maybe this driver doesn't
> suffer from that new udev behavior, so, I'll be merging it as-is. However,
> I suggest you to take a deeper review on that and, if possible, test it with
> the latest udev.

True, it's indeed a bit tricky. The host interface driver this sensor driver
has been tested with calls s_power on a subdev only in response to a video
device open(). During probe only subdev's .registered() callback is called.
And there is no request_firmware() there, as it is not needed to boot the 
sensor's MCU. The "firmware" is really just a set of settings that are 
normally needed only before streaming needs to be started. We have analysed 
this issue and hopefully there should be no request_firmware() calls from 
within probe(), as long as the host interface driver doesn't call s_power 
from it's probe() callback. I'm afraid it's not the case for all bridge 
drivers though. If needed we could probably try and use 
request_firmware_nowait(), but it seems better to me to make sure the bridge
drivers don't call s_power from within their probe() callback.

--

Thanks,
Sylwester
