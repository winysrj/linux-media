Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vb0-f48.google.com ([209.85.212.48]:43331 "EHLO
	mail-vb0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750705Ab3IFEdc (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 6 Sep 2013 00:33:32 -0400
MIME-Version: 1.0
In-Reply-To: <5228E34B.307@gmail.com>
References: <1377066881-5423-1-git-send-email-arun.kk@samsung.com>
	<1377066881-5423-14-git-send-email-arun.kk@samsung.com>
	<5228E34B.307@gmail.com>
Date: Fri, 6 Sep 2013 10:03:31 +0530
Message-ID: <CALt3h7_ZjAfqdDbMzW8Ge++3cAGrodZkBwvwQLWMMRda=G=qGQ@mail.gmail.com>
Subject: Re: [PATCH v7 13/13] V4L: Add driver for s5k4e5 image sensor
From: Arun Kumar K <arunkk.samsung@gmail.com>
To: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
Cc: LMML <linux-media@vger.kernel.org>,
	linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
	devicetree@vger.kernel.org,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
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

Will make the changes you suggested.
Will re-spin this entire series with some more minor fixes after more
rigorous testing.

Regards
Arun

On Fri, Sep 6, 2013 at 1:32 AM, Sylwester Nawrocki
<sylvester.nawrocki@gmail.com> wrote:
> On 08/21/2013 08:34 AM, Arun Kumar K wrote:
>>
>> This patch adds subdev driver for Samsung S5K4E5 raw image sensor.
>> Like s5k6a3, it is also another fimc-is firmware controlled
>> sensor. This minimal sensor driver doesn't do any I2C communications
>> as its done by ISP firmware. It can be updated if needed to a
>> regular sensor driver by adding the I2C communication.
>>
>> Signed-off-by: Arun Kumar K<arun.kk@samsung.com>
>> Reviewed-by: Sylwester Nawrocki<s.nawrocki@samsung.com>
>> ---
>>   .../devicetree/bindings/media/i2c/s5k4e5.txt       |   43 +++
>>   drivers/media/i2c/Kconfig                          |    8 +
>>   drivers/media/i2c/Makefile                         |    1 +
>>   drivers/media/i2c/s5k4e5.c                         |  361
>> ++++++++++++++++++++
>>   4 files changed, 413 insertions(+)
>>   create mode 100644
>> Documentation/devicetree/bindings/media/i2c/s5k4e5.txt
>>   create mode 100644 drivers/media/i2c/s5k4e5.c
>>
>> diff --git a/Documentation/devicetree/bindings/media/i2c/s5k4e5.txt
>> b/Documentation/devicetree/bindings/media/i2c/s5k4e5.txt
>> new file mode 100644
>> index 0000000..5af462c
>> --- /dev/null
>> +++ b/Documentation/devicetree/bindings/media/i2c/s5k4e5.txt
>> @@ -0,0 +1,43 @@
>> +* Samsung S5K4E5 Raw Image Sensor
>> +
>> +S5K4E5 is a raw image sensor with maximum resolution of 2560x1920
>> +pixels. Data transfer is carried out via MIPI CSI-2 port and controls
>> +via I2C bus.
>> +
>> +Required Properties:
>> +- compatible   : must be "samsung,s5k4e5"
>> +- reg          : I2C device address
>> +- gpios                : reset gpio pin
>
>
> I guess this should be "reset-gpios". How about changing description to:
>
> - reset-gpios   : specifier of a GPIO connected to the RESET pin;
>
>
> ?
>>
>> +- clocks       : clock specifier for the clock-names property
>
>
> Perhaps something along the lines of:
>
> - clocks : "should contain the sensor's MCLK clock specifier, from
>                   the common clock bindings"
>
> ?
>>
>> +- clock-names  : must contain "mclk" entry
>
>
> Is name of the clock input pin really MCLK ?
>
>
>> +- svdda-supply : core voltage supply
>> +- svddio-supply        : I/O voltage supply
>> +
>> +Optional Properties:
>> +- clock-frequency : operating frequency for the sensor
>> +                    default value will be taken if not provided.
>
>
> How about clarifying it a bit, as Stephen suggested, e.g.:
>
> - clock-frequency : the frequency at which the "mclk" clock should be
>                     configured to operate, in Hz; if this property is not
>                     specified default 24 MHz value will be used.
>
>
>> +The device node should be added to respective control bus controller
>> +(e.g. I2C0) nodes and linked to the csis port node, using the common
>> +video interfaces bindings, defined in video-interfaces.txt.
>
>
> This seems misplaced, S5K4E5 image sensor has nothingto do with csis nodes.
> How about something like this instead:
>
> "The common video interfaces bindings (see video-interfaces.txt) should be
> used to specify link to the image data receiver. The S5K6A3(YX) device
> node should contain one 'port' child node with an 'endpoint' subnode.
>
> Following properties are valid for the endpoint node:
> ..."
>
>
>> +Example:
>> +
>> +       i2c-isp@13130000 {
>> +               s5k4e5@20 {
>> +                       compatible = "samsung,s5k4e5";
>> +                       reg =<0x20>;
>> +                       gpios =<&gpx1 2 1>;
>> +                       clock-frequency =<24000000>;
>> +                       clocks =<&clock 129>;
>> +                       clock-names = "mclk";
>> +                       svdda-supply =<...>;
>> +                       svddio-supply =<...>;
>> +                       port {
>> +                               is_s5k4e5_ep: endpoint {
>> +                                       data-lanes =<1 2 3 4>;
>> +                                       remote-endpoint =<&csis0_ep>;
>> +                               };
>> +                       };
>> +               };
>> +       };
>
>
> --
> Thanks,
> Sylwester
