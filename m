Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vb0-f44.google.com ([209.85.212.44]:62403 "EHLO
	mail-vb0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755783Ab3JRCqN (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 17 Oct 2013 22:46:13 -0400
MIME-Version: 1.0
In-Reply-To: <526019F0.3070406@samsung.com>
References: <1380279558-21651-1-git-send-email-arun.kk@samsung.com>
	<1380279558-21651-14-git-send-email-arun.kk@samsung.com>
	<526019F0.3070406@samsung.com>
Date: Fri, 18 Oct 2013 08:16:12 +0530
Message-ID: <CALt3h7-vYWS0KpNqm-hUWph-HrfgK0Y8mv8rrzgOQLCA4C9h5g@mail.gmail.com>
Subject: Re: [PATCH v9 13/13] V4L: Add driver for s5k4e5 image sensor
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

On Thu, Oct 17, 2013 at 10:40 PM, Sylwester Nawrocki
<s.nawrocki@samsung.com> wrote:
> On 27/09/13 12:59, Arun Kumar K wrote:
>> This patch adds subdev driver for Samsung S5K4E5 raw image sensor.
>> Like s5k6a3, it is also another fimc-is firmware controlled
>> sensor. This minimal sensor driver doesn't do any I2C communications
>> as its done by ISP firmware. It can be updated if needed to a
>> regular sensor driver by adding the I2C communication.
>>
>> Signed-off-by: Arun Kumar K <arun.kk@samsung.com>
>> Reviewed-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
>> ---
>>  .../devicetree/bindings/media/i2c/s5k4e5.txt       |   45 +++
>>  drivers/media/i2c/Kconfig                          |    8 +
>>  drivers/media/i2c/Makefile                         |    1 +
>>  drivers/media/i2c/s5k4e5.c                         |  347 ++++++++++++++++++++
>>  4 files changed, 401 insertions(+)
>>  create mode 100644 Documentation/devicetree/bindings/media/i2c/s5k4e5.txt
>>  create mode 100644 drivers/media/i2c/s5k4e5.c
>>
>> diff --git a/Documentation/devicetree/bindings/media/i2c/s5k4e5.txt b/Documentation/devicetree/bindings/media/i2c/s5k4e5.txt
>> new file mode 100644
>> index 0000000..0fca087
>> --- /dev/null
>> +++ b/Documentation/devicetree/bindings/media/i2c/s5k4e5.txt
>
> Could you make a separate patch adding DT binding only ?
> And can you please rename this file to:
> Documentation/devicetree/bindings/media/samsung-s5k4e5.txt, like
> it's done in case of other sensors ?

Ok will do that.

>
> Should I apply patches 02...11/13 already or would you like send
> the whole series updated ? AFAICS there are minor things pointed
> out by Hans not addressed yet ?

Yes I will send the full series with the review comments addressed.

Regards
Arun
