Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:39767 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1759415AbcHaMmp (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 31 Aug 2016 08:42:45 -0400
Subject: Re: [PATCH 5/5] smiapp: Switch to gpiod API for GPIO control
To: Sebastian Reichel <sre@kernel.org>
Cc: linux-media@vger.kernel.org
References: <1472629325-30875-1-git-send-email-sakari.ailus@linux.intel.com>
 <1472629325-30875-6-git-send-email-sakari.ailus@linux.intel.com>
 <20160831120956.2ij6bslmf6jg3gpy@earth>
From: Sakari Ailus <sakari.ailus@linux.intel.com>
Message-ID: <57C6D0B8.4090306@linux.intel.com>
Date: Wed, 31 Aug 2016 15:42:32 +0300
MIME-Version: 1.0
In-Reply-To: <20160831120956.2ij6bslmf6jg3gpy@earth>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sebastian,

Thanks for the review!

On 08/31/16 15:09, Sebastian Reichel wrote:
> Hi Sakari,
> 
> On Wed, Aug 31, 2016 at 10:42:05AM +0300, Sakari Ailus wrote:
>> -	if (gpio_is_valid(sensor->hwcfg->xshutdown)) {
>> +	if (client->dev.of_node) {
>> +		sensor->xshutdown =
>> +			devm_gpiod_get_optional(&client->dev, "xshutdown",
>> +						GPIOD_OUT_LOW);
>> +	} else if (gpio_is_valid(sensor->hwcfg->xshutdown)) {
>>  		rval = devm_gpio_request_one(
>>  			&client->dev, sensor->hwcfg->xshutdown, 0,
>>  			"SMIA++ xshutdown");
>> @@ -2581,8 +2582,13 @@ static int smiapp_init(struct smiapp_sensor *sensor)
>>  				sensor->hwcfg->xshutdown);
>>  			return rval;
>>  		}
>> +
>> +		sensor->xshutdown = gpio_to_desc(sensor->hwcfg->xshutdown);
>>  	}
> 
> You can drop the devm_gpio_request_one() part and xshutdown from
> smiapp_platform_data. The gpiod consumer interface can also be
> used with data provided from boardfiles as documented in
> Documentation/gpio/board.txt, section "Platform Data". It basically
> works like assigning regulators to devices from platform data.

Good point. I'll fix that.

-- 
Sakari Ailus
sakari.ailus@linux.intel.com
