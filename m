Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr1-f67.google.com ([209.85.221.67]:35597 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728527AbeGYLMc (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 25 Jul 2018 07:12:32 -0400
Received: by mail-wr1-f67.google.com with SMTP id a3-v6so6813949wrt.2
        for <linux-media@vger.kernel.org>; Wed, 25 Jul 2018 03:01:33 -0700 (PDT)
Subject: Re: [PATCH v3 18/35] media: camss: Add basic runtime PM support
To: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: mchehab@kernel.org, hans.verkuil@cisco.com,
        laurent.pinchart+renesas@ideasonboard.com,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1532343772-27382-1-git-send-email-todor.tomov@linaro.org>
 <1532343772-27382-19-git-send-email-todor.tomov@linaro.org>
 <20180724124916.iyanzu3nux35cudg@paasikivi.fi.intel.com>
From: Todor Tomov <todor.tomov@linaro.org>
Message-ID: <096a3fb4-01b8-3096-116f-8562cfb8b6b8@linaro.org>
Date: Wed, 25 Jul 2018 13:01:31 +0300
MIME-Version: 1.0
In-Reply-To: <20180724124916.iyanzu3nux35cudg@paasikivi.fi.intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

Thank you for review.

On 24.07.2018 15:49, Sakari Ailus wrote:
> Hi Todor,
> 
> On Mon, Jul 23, 2018 at 02:02:35PM +0300, Todor Tomov wrote:
>> There is a PM domain for each of the VFE hardware modules. Add
>> support for basic runtime PM support to be able to control the
>> PM domains. When a PM domain needs to be powered on - a device
>> link is created. When a PM domain needs to be powered off -
>> its device link is removed. This allows separate and
>> independent control of the PM domains.
>>
>> Suspend/Resume is still not supported.
>>
>> Signed-off-by: Todor Tomov <todor.tomov@linaro.org>
>> ---
>>  drivers/media/platform/qcom/camss/camss-csid.c   |  4 ++
>>  drivers/media/platform/qcom/camss/camss-csiphy.c |  5 ++
>>  drivers/media/platform/qcom/camss/camss-ispif.c  | 19 ++++++-
>>  drivers/media/platform/qcom/camss/camss-vfe.c    | 13 +++++
>>  drivers/media/platform/qcom/camss/camss.c        | 63 ++++++++++++++++++++++++
>>  drivers/media/platform/qcom/camss/camss.h        | 11 +++++
>>  6 files changed, 113 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/media/platform/qcom/camss/camss-csid.c b/drivers/media/platform/qcom/camss/camss-csid.c
>> index 627ef44..ea2b0ba 100644
>> --- a/drivers/media/platform/qcom/camss/camss-csid.c
>> +++ b/drivers/media/platform/qcom/camss/camss-csid.c
>> @@ -13,6 +13,7 @@
>>  #include <linux/kernel.h>
>>  #include <linux/of.h>
>>  #include <linux/platform_device.h>
>> +#include <linux/pm_runtime.h>
>>  #include <linux/regulator/consumer.h>
>>  #include <media/media-entity.h>
>>  #include <media/v4l2-device.h>
>> @@ -316,6 +317,8 @@ static int csid_set_power(struct v4l2_subdev *sd, int on)
>>  	if (on) {
>>  		u32 hw_version;
>>  
>> +		pm_runtime_get_sync(dev);
>> +
>>  		ret = regulator_enable(csid->vdda);
> 
> Shouldn't the regulator be enabled in the runtime_resume callback instead?

Ideally - yes, but it becomes more complex (different pipelines are possible
and we have only one callback) so (at least for now) I have left it as it is
and stated in the commit message that suspend/resume is still not supported.

> 
>>  		if (ret < 0)
>>  			return ret;
> 
> Note that you'll need pm_runtime_put() in in error handling here. Perhaps
> elsewhere, too.

Yes, I'll add it here and on all other places.

> 
> Can powering on the device (i.e. pm_runtime_get_sync() call)  fail?

I'd really like to say that it cannot fail :) at least the callback is
empty for now and cannot fail, but the logic in pm_runtime_get_sync()
is not that simple and I'm really not sure. I'll add checks in the code
in case it fails.

> 
>> @@ -348,6 +351,7 @@ static int csid_set_power(struct v4l2_subdev *sd, int on)
>>  		disable_irq(csid->irq);
>>  		camss_disable_clocks(csid->nclocks, csid->clock);
>>  		ret = regulator_disable(csid->vdda);
>> +		pm_runtime_put_sync(dev);
>>  	}
>>  
>>  	return ret;
>> diff --git a/drivers/media/platform/qcom/camss/camss-csiphy.c b/drivers/media/platform/qcom/camss/camss-csiphy.c
>> index 0383e94..2db78791 100644
>> --- a/drivers/media/platform/qcom/camss/camss-csiphy.c
>> +++ b/drivers/media/platform/qcom/camss/camss-csiphy.c
>> @@ -13,6 +13,7 @@
>>  #include <linux/kernel.h>
>>  #include <linux/of.h>
>>  #include <linux/platform_device.h>
>> +#include <linux/pm_runtime.h>
>>  #include <media/media-entity.h>
>>  #include <media/v4l2-device.h>
>>  #include <media/v4l2-subdev.h>
>> @@ -240,6 +241,8 @@ static int csiphy_set_power(struct v4l2_subdev *sd, int on)
>>  		u8 hw_version;
>>  		int ret;
>>  
>> +		pm_runtime_get_sync(dev);
>> +
>>  		ret = csiphy_set_clock_rates(csiphy);
>>  		if (ret < 0)
>>  			return ret;
> 
> Like here.

Yes, I'll add it here too.

-- 
Best regards,
Todor Tomov
