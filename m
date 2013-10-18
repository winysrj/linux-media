Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vb0-f44.google.com ([209.85.212.44]:37519 "EHLO
	mail-vb0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755783Ab3JRCpV (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 17 Oct 2013 22:45:21 -0400
MIME-Version: 1.0
In-Reply-To: <5260186C.1040109@samsung.com>
References: <1380279558-21651-1-git-send-email-arun.kk@samsung.com>
	<1380279558-21651-13-git-send-email-arun.kk@samsung.com>
	<5260186C.1040109@samsung.com>
Date: Fri, 18 Oct 2013 08:15:20 +0530
Message-ID: <CALt3h7_pMQsfXcEtr6VRUU1P561qAV=2XtfUfQXD-3zpdn1T+g@mail.gmail.com>
Subject: Re: [PATCH v9 12/13] V4L: s5k6a3: Change sensor min/max resolutions
From: Arun Kumar K <arunkk.samsung@gmail.com>
To: Sylwester Nawrocki <s.nawrocki@samsung.com>
Cc: LMML <linux-media@vger.kernel.org>,
	linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
	devicetree@vger.kernel.org, Hans Verkuil <hverkuil@xs4all.nl>,
	Stephen Warren <swarren@wwwdotorg.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Pawel Moll <Pawel.Moll@arm.com>,
	Kumar Gala <galak@codeaurora.org>,
	Andrzej Hajda <a.hajda@samsung.com>,
	Sachin Kamat <sachin.kamat@linaro.org>,
	Shaik Ameer Basha <shaik.ameer@samsung.com>,
	kilyeon.im@samsung.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sylwester,

On Thu, Oct 17, 2013 at 10:33 PM, Sylwester Nawrocki
<s.nawrocki@samsung.com> wrote:
> Hi Arun,
>
> My apologies for the delay.
>
> On 27/09/13 12:59, Arun Kumar K wrote:
>> s5k6a3 sensor has actual pixel resolution of 1408x1402 against
>> the active resolution 1392x1392. The real resolution is needed
>> when raw sensor SRGB data is dumped to memory by fimc-lite.
>>
>> Signed-off-by: Arun Kumar K <arun.kk@samsung.com>
>> Reviewed-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
>> ---
>>  drivers/media/i2c/s5k6a3.c |   10 ++++++----
>>  1 file changed, 6 insertions(+), 4 deletions(-)
>>
>> diff --git a/drivers/media/i2c/s5k6a3.c b/drivers/media/i2c/s5k6a3.c
>> index ccbb4fc..e70e217 100644
>> --- a/drivers/media/i2c/s5k6a3.c
>> +++ b/drivers/media/i2c/s5k6a3.c
>> @@ -25,10 +25,12 @@
>>  #include <media/v4l2-async.h>
>>  #include <media/v4l2-subdev.h>
>>
>> -#define S5K6A3_SENSOR_MAX_WIDTH              1392
>> -#define S5K6A3_SENSOR_MAX_HEIGHT     1392
>> -#define S5K6A3_SENSOR_MIN_WIDTH              32
>> -#define S5K6A3_SENSOR_MIN_HEIGHT     32
>> +#define S5K6A3_SENSOR_MAX_WIDTH              1408
>> +#define S5K6A3_SENSOR_MAX_HEIGHT     1402
>
> Where these numbers come from ? I digged in the datasheet and the pixel
> array size for S5K6A3YX is 1412 x 1412 pixels. I will use this value
> in my updated s5k6a3 driver patch I'm going to post today. And I will
> drop this patch from this series.
>

These are the numbers used in the the reference driver. I will check if
the values 1412x1412 works or not. There are also limitations imposed by the
fimc-is firmware too as we just pass on the sensor_id to the firmware and I can
see from the firmware log that it assumes max size of 1408x1402 for 6a3.

>> +#define S5K6A3_SENSOR_ACTIVE_WIDTH   1392
>> +#define S5K6A3_SENSOR_ACTIVE_HEIGHT  1392
>
>
> S5K6A3_SENSOR_ACTIVE_* macros are not used anywhere ? Can they be dropped ?
> Same applies to your S5K4E5 driver patch.
>

Yes I will drop them.
In my next series, I will drop this 6a3 patch and keep only 4e5 sensor.

Regards
Arun
