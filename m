Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vb0-f43.google.com ([209.85.212.43]:51242 "EHLO
	mail-vb0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751141Ab3HNFJD (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 14 Aug 2013 01:09:03 -0400
MIME-Version: 1.0
In-Reply-To: <CAK9yfHzMvmjZGX2veiQwy6gtb1eN6wf29EiNyr7N4rJegzC=vw@mail.gmail.com>
References: <1376455574-15560-1-git-send-email-arun.kk@samsung.com>
	<1376455574-15560-2-git-send-email-arun.kk@samsung.com>
	<CAK9yfHzMvmjZGX2veiQwy6gtb1eN6wf29EiNyr7N4rJegzC=vw@mail.gmail.com>
Date: Wed, 14 Aug 2013 10:39:02 +0530
Message-ID: <CALt3h7-rmYVX-mTKFb_-y54=q-9SsMGRhsGW_ZOjiZT-HsUDow@mail.gmail.com>
Subject: Re: [PATCH v5 01/13] [media] exynos5-is: Adding media device driver
 for exynos5
From: Arun Kumar K <arunkk.samsung@gmail.com>
To: Sachin Kamat <sachin.kamat@linaro.org>
Cc: linux-media <linux-media@vger.kernel.org>,
	linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
	devicetree@vger.kernel.org,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Stephen Warren <swarren@wwwdotorg.org>,
	Andrzej Hajda <a.hajda@samsung.com>,
	Shaik Ameer Basha <shaik.ameer@samsung.com>,
	kilyeon.im@samsung.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sachin,

On Wed, Aug 14, 2013 at 10:29 AM, Sachin Kamat <sachin.kamat@linaro.org> wrote:
> Hi Arun,
>
> On 14 August 2013 10:16, Arun Kumar K <arun.kk@samsung.com> wrote:
>> From: Shaik Ameer Basha <shaik.ameer@samsung.com>
>>
>> This patch adds support for media device for EXYNOS5 SoCs.
>> The current media device supports the following ips to connect
>> through the media controller framework.
>>
>> * MIPI-CSIS
>>   Support interconnection(subdev interface) between devices
>>
>> * FIMC-LITE
>>   Support capture interface from device(Sensor, MIPI-CSIS) to memory
>>   Support interconnection(subdev interface) between devices
>>
>> * FIMC-IS
>>   Camera post-processing IP having multiple sub-nodes.
>>
>> G-Scaler will be added later to the current media device.
>>
>> The media device creates two kinds of pipelines for connecting
>> the above mentioned IPs.
>> The pipeline0 is uses Sensor, MIPI-CSIS and FIMC-LITE which captures
>> image data and dumps to memory.
>> Pipeline1 uses FIMC-IS components for doing post-processing
>> operations on the captured image and give scaled YUV output.
>>
>> Pipeline0
>>   +--------+     +-----------+     +-----------+     +--------+
>>   | Sensor | --> | MIPI-CSIS | --> | FIMC-LITE | --> | Memory |
>>   +--------+     +-----------+     +-----------+     +--------+
>>
>> Pipeline1
>>  +--------+      +--------+     +-----------+     +-----------+
>>  | Memory | -->  |  ISP   | --> |    SCC    | --> |    SCP    |
>>  +--------+      +--------+     +-----------+     +-----------+
>>
>> Signed-off-by: Shaik Ameer Basha <shaik.ameer@samsung.com>
>> Signed-off-by: Arun Kumar K <arun.kk@samsung.com>
>> ---
>>  .../devicetree/bindings/media/exynos5-mdev.txt     |  130 +++
>>  drivers/media/platform/exynos5-is/exynos5-mdev.c   | 1218 ++++++++++++++++++++
>>  drivers/media/platform/exynos5-is/exynos5-mdev.h   |  160 +++
>>  3 files changed, 1508 insertions(+)
>>  create mode 100644 Documentation/devicetree/bindings/media/exynos5-mdev.txt
>>  create mode 100644 drivers/media/platform/exynos5-is/exynos5-mdev.c
>>  create mode 100644 drivers/media/platform/exynos5-is/exynos5-mdev.h
>>
>> diff --git a/Documentation/devicetree/bindings/media/exynos5-mdev.txt b/Documentation/devicetree/bindings/media/exynos5-mdev.txt
>> new file mode 100644
>> index 0000000..007ce21
>> --- /dev/null
>> +++ b/Documentation/devicetree/bindings/media/exynos5-mdev.txt
>> @@ -0,0 +1,130 @@
>> +Samsung EXYNOS5 SoC Camera Subsystem
>> +------------------------------------
>> +
>> +The Exynos5 SoC Camera subsystem comprises of multiple sub-devices
>> +represented by separate device tree nodes. Currently this includes: FIMC-LITE,
>> +MIPI CSIS and FIMC-IS.
>> +
>> +The sub-subdevices are defined as child nodes of the common 'camera' node which
>> +also includes common properties of the whole subsystem not really specific to
>> +any single sub-device, like common camera port pins or the CAMCLK clock outputs
>> +for external image sensors attached to an SoC.
>> +
>> +Common 'camera' node
>> +--------------------
>> +
>> +Required properties:
>> +
>> +- compatible   : must be "samsung,exynos5-fimc", "simple-bus"
>
> I think it was concluded that this should be "samsung,exynos5250-fimc".
>
>

Oh yes. Actually I modified it in the code, but missed updating the binding doc.
Thanks for catching it.
Will wait for Sylwester's comments to see if the whole series should
be posted again
or just this change can be made while applying.

Regards
Arun
