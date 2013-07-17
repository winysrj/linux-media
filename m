Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ve0-f174.google.com ([209.85.128.174]:48339 "EHLO
	mail-ve0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751003Ab3GQEz7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 17 Jul 2013 00:55:59 -0400
Received: by mail-ve0-f174.google.com with SMTP id oz10so1122627veb.5
        for <linux-media@vger.kernel.org>; Tue, 16 Jul 2013 21:55:58 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <51E5C33B.20804@gmail.com>
References: <1370005408-10853-1-git-send-email-arun.kk@samsung.com>
	<1370005408-10853-6-git-send-email-arun.kk@samsung.com>
	<201306260927.17210.hverkuil@xs4all.nl>
	<CALt3h79RD2cejJBDStMqcuhi9BUo5EAn+5trNzJHHo_s_zYr7g@mail.gmail.com>
	<51E5C33B.20804@gmail.com>
Date: Wed, 17 Jul 2013 10:25:58 +0530
Message-ID: <CALt3h7-2Wip8f6fmwAnDdxL+hnze8YFQNYHyAZy5Rn+viySmHQ@mail.gmail.com>
Subject: Re: [RFC v2 05/10] exynos5-fimc-is: Adds the sensor subdev
From: Arun Kumar K <arunkk.samsung@gmail.com>
To: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
	LMML <linux-media@vger.kernel.org>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	kilyeon.im@samsung.com, shaik.ameer@samsung.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sylwester,


On Wed, Jul 17, 2013 at 3:33 AM, Sylwester Nawrocki
<sylvester.nawrocki@gmail.com> wrote:
> Hi Arun,
>
>
> On 07/09/2013 02:04 PM, Arun Kumar K wrote:
>>
>> On Wed, Jun 26, 2013 at 12:57 PM, Hans Verkuil<hverkuil@xs4all.nl>  wrote:
>>>
>>> On Fri May 31 2013 15:03:23 Arun Kumar K wrote:
>>>>
>>>> FIMC-IS uses certain sensors which are exclusively controlled
>>>> from the IS firmware. This patch adds the sensor subdev for the
>>>> fimc-is sensors.
>>>>
>>>> Signed-off-by: Arun Kumar K<arun.kk@samsung.com>
>>>> Signed-off-by: Kilyeon Im<kilyeon.im@samsung.com>
>>>
>>>
>>> Not surprisingly I really hate the idea of sensor drivers that are tied
>>> to
>>> a specific SoC, since it completely destroys the reusability of such
>>> drivers.
>>>
>>
>> Yes agree to it.
>>
>>> I understand that you have little choice to do something special here,
>>> but
>>> I was wondering whether there is a way of keeping things as generic as
>>> possible.
>>>
>>> I'm just brainstorming here, but as far as I can see this driver is
>>> basically
>>> a partial sensor driver: it handles the clock, the format negotiation and
>>> power management. Any sensor driver needs that.
>>>
>>> What would be nice is if the fmic specific parts are replaced by
>>> callbacks
>>> into the bridge driver using v4l2_subdev_notify().
>>>
>>> The platform data (or DT) can also state if this sensor is firmware
>>> controlled
>>> or not. If not, then the missing bits can be implemented in the future by
>>> someone who needs that.
>>>
>>> That way the driver itself remains independent from fimc.
>>>
>>> And existing sensor drivers can be adapted to be usable with fimc as well
>>> by
>>> adding support for the notify callback.
>>>
>>> Would a scheme along those lines work?
>>>
>>
>> Yes this should make the implementation very generic.
>> Will check the feasibility of this approach.
>
>
> Is I suggested earlier, you likely could do without this call back to the
> FIMC-IS from within the sensor subdev. Look at your call chain right now:
>
>  /dev/video?     media-dev-driver    sensor-subdev         FIMC-IS
>     |                 |                   |                  |
>     | VIDIOC_STREAMON |                   |                  |
>     |---------------->#     s_stream()    |                  |
>     |                 #------------------># pipeline_open()  |
>     |                 |                   # ---------------->|
>     |                 |                   # pipeline_start() |
>     |                 |                   # ---------------->|
>     |                 |                   |                  |
>
> Couldn't you move pipeline_open(), pipeline_start() to s_stream handler
> of the ISP subdev ? It is currently empty. The media device driver could
> call s_stream on the ISP subdev each time it sees s_stream request on
> the sensor subdev. And you wouldn't need any hacks to get the pipeline
> pointer in the sensor subdev. Then it would be something like:
>
>  /dev/video?     media-dev-driver    sensor-subdev  FIMC-IS-ISP-subdev
>     |                 |                   |             |
>     | VIDIOC_STREAMON |                   |             |
>     |---------------->#     s_stream()    |             |
>     |                 #------------------>|             |
>     |                 #     s_stream()    |             |
>     |                 #-------------------+------------># pipeline_open()
>     |                 |                   |             # pipeline_start()
>     |                 |                   |             #
>
> I suppose pipeline_open() is better candidate for the s_power callback.
> It just needs to be ensured at the media device level the subdev
> operations sequences are correct.
>

It can be done this way. But my intention of putting these calls in
the sensor subdev was to use the sensor subdev independent of
isp subdev. This is for the usecase where the pipeline will only contain

is-sensor --> mipi-csis --> fimc-lite ---> memory

This way you can capture the bayer rgb data from sensor without using
any isp components at all.

The second pipeline which is isp --> scc --> scp
can be used for processing the sensor data and can be created and
used if needed.

In the method you mentioned, the isp subdev has to be used even
when it is not part of the pipeline. Is that allowed?
If its allowed as per media pipeline guidelines, then this definitely
is a better approach. Please suggest on this.

Regards
Arun
