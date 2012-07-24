Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:38836 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755741Ab2GXUiu (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 24 Jul 2012 16:38:50 -0400
Received: by bkwj10 with SMTP id j10so6661976bkw.19
        for <linux-media@vger.kernel.org>; Tue, 24 Jul 2012 13:38:49 -0700 (PDT)
Message-ID: <500F07D5.4070602@gmail.com>
Date: Tue, 24 Jul 2012 22:38:45 +0200
From: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
MIME-Version: 1.0
To: Sangwook Lee <sangwook.lee@linaro.org>
CC: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>,
	linux-media@vger.kernel.org, mchehab@infradead.org,
	laurent.pinchart@ideasonboard.com,
	sakari.ailus@maxwell.research.nokia.com, suapapa@insignal.co.kr,
	quartz.jang@samsung.com, linaro-dev@lists.linaro.org,
	patches@linaro.org, usman.ahmad@linaro.org,
	david.a.cohen@linux.intel.com
Subject: Re: [PATCH v2 1/2] v4l: Add factory register values form S5K4ECGX
 sensor
References: <1342700047-31806-1-git-send-email-sangwook.lee@linaro.org> <1342700047-31806-2-git-send-email-sangwook.lee@linaro.org> <500862C0.2000507@gmail.com> <CADPsn1bniYQQ-pefrX+XdbLk1n-Na_dSYWspORkGCwo5+XBtrw@mail.gmail.com> <CADPsn1YVOcE=XQk2ayzeLGyse4yYZKJt3voffOf7pVqhk+ZzpA@mail.gmail.com>
In-Reply-To: <CADPsn1YVOcE=XQk2ayzeLGyse4yYZKJt3voffOf7pVqhk+ZzpA@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sangwook,

On 07/20/2012 12:03 PM, Sangwook Lee wrote:
> Hi Sylwester
> 
> Thank for the review.
> 
> On 19 July 2012 20:40, Sylwester Nawrocki<sylvester.nawrocki@gmail.com>  wrote:
>> On 07/19/2012 02:14 PM, Sangwook Lee wrote:
...
>>> Add factory default settings for S5K4ECGX sensor registers.
>>> I copied them from the reference code of Samsung S.LSI.
>>
>> I'm pretty sure we can do better than that. I've started S5K6AAFX sensor
>> driver development with similar set of write-only register address/value
>> arrays, that stored mainly register default values after the device reset,
>> or were configuring presets that were never used.
>>
>> If you lok at the s5k6aa driver, you'll find only one relatively small
>> array of register values for the analog processing block settings.
>> It's true that I had to reverse engineer a couple of things, but I also
>>
>> had a relatively good datasheet for the sensor.
>>
> 
> Yes, I already saw analog settings in s5k6aa. Compared to s5k6aa,
> I couldn't also understand why the sensor has lots of initial values.
> Is it because s5k4ecgx is slightly more complicated than s5k6aa ?

IIRC, original S5K6AAFX driver had similar number of initial values that 
were being written during initialization through I2C bus. But that's true 
the s5k4ecgx is more complex, it has more still capture features built in.

>>> According to comments from the reference code, they do not
>>> recommend any changes of these settings.
>>
>> Yes, but it doesn't mean cannot convert, at least part of, those ugly
>> tables into function calls.
> 
> 
> Yes, the biggest table seems to be one time for boot-up, at least I need to
> remove one more macro (token)

That would be a good start. Also 2 most significant bytes of register
addresses seem redundant, you'll find there mostly 0xD000 and 0x7000.
Dropping the token and 2 MS address bytes would decrease the single entry 
size from 10 to 4 bytes. Given that there is about 3000 table entries 
the driver's code size would decrease by 18 kB.

BTW, you didn't make those arrays "const", so it's all copied to RAM
during initialization...

>>
>> Have you tried to contact Samsung S.LSI for a datasheet that would
>> contain better registers' description ?
> 
> 
> As you might know, there is a limitation for me to get those information. :-)

I find it odd, given that you guys work on software support for one of
official Exynos4 reference platforms. It's really surprising.
Maybe you should just contact the right persons ?

> Instead, if I look into the source code of Google Nexus S which uses s5k4ecgx,
> 
>    https://android.googlesource.com/kernel/samsung.git
> 
> I can discover that both Google and Samsung are using the same huge table
> just for initial settings from the sensor booting-up. I added the
> original author
> of this sensor driver. Hopes he might add some comments :-)

Yeah, that would be great.

I think, this pattern of using register/value arrays is good for quick
development of drivers for many different sensors - you just switch the 
tables and everything else mostly stays the same. However, V4L2 mainline 
standards are a bit different. It would be good to convert as many of 
those arrays to functions calls as possible.

Also using vmalloc is an overkill IMO. I suspect you could use this
function (with minimal adaptations):

8<-------------------------------------------------------------------
static int s5k6aa_write_array(struct v4l2_subdev *sd,
			      const struct s5k6aa_regval *msg)
{
	struct i2c_client *client = v4l2_get_subdevdata(sd);
	u16 addr_incr = 0;
	int ret = 0;

	while (msg->addr != S5K6AA_TERM) {
		if (addr_incr != 2)
			ret = s5k6aa_i2c_write(client, REG_CMDWR_ADDRL,
					       msg->addr);
		if (ret)
			break;
		ret = s5k6aa_i2c_write(client, REG_CMDBUF0_ADDR, msg->val);
		if (ret)
			break;
		/* Assume that msg->addr is always less than 0xfffc */
		addr_incr = (msg + 1)->addr - msg->addr;
		msg++;
	}

	return ret;
}
8<----------------------------------------------------------------------

instead of s5k4ecgx_prep_buffer() and s5k4ecgx_write_burst(). But that 
would have to be confirmed with the datasheet or by experimentation.

--

Thanks,
Sylwester
