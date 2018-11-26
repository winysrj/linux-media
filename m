Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud9.xs4all.net ([194.109.24.26]:53624 "EHLO
        lb2-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726200AbeK0Aot (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 26 Nov 2018 19:44:49 -0500
Subject: Re: [PATCH v3] media: video-i2c: check if chip struct has set_power
 function
To: Sakari Ailus <sakari.ailus@linux.intel.com>,
        Matt Ranostay <matt.ranostay@konsulko.com>
Cc: linux-media@vger.kernel.org, Hans Verkuil <hansverk@cisco.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Akinobu Mita <akinobu.mita@gmail.com>
References: <20181124220323.13497-1-matt.ranostay@konsulko.com>
 <20181125165520.75v5ijfy7bnbxy2r@kekkonen.localdomain>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <8e5a382c-49c3-9892-a119-1b29edd1bc08@xs4all.nl>
Date: Mon, 26 Nov 2018 14:50:32 +0100
MIME-Version: 1.0
In-Reply-To: <20181125165520.75v5ijfy7bnbxy2r@kekkonen.localdomain>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 11/25/2018 05:55 PM, Sakari Ailus wrote:
> Hi Matt,
> 
> On Sat, Nov 24, 2018 at 02:03:23PM -0800, Matt Ranostay wrote:
>> Not all future supported video chips will always have power management
>> support, and so it is important to check before calling set_power() is
>> defined.
>>
>> Cc: Sakari Ailus <sakari.ailus@linux.intel.com>
>> Cc: Hans Verkuil <hansverk@cisco.com>
>> Cc: Mauro Carvalho Chehab <mchehab@kernel.org>
>> Cc: Akinobu Mita <akinobu.mita@gmail.com>
>> Signed-off-by: Matt Ranostay <matt.ranostay@konsulko.com>
>> ---
>>
>> Changes from v2:
>> - split out from mlx90640 patch series
>> - added to Cc list
>>
>> Changes from v1:
>> - none
>>
>>  drivers/media/i2c/video-i2c.c | 22 +++++++++++++++++-----
>>  1 file changed, 17 insertions(+), 5 deletions(-)
>>
>> diff --git a/drivers/media/i2c/video-i2c.c b/drivers/media/i2c/video-i2c.c
>> index b6ebb8d53e90..01dcf179f203 100644
>> --- a/drivers/media/i2c/video-i2c.c
>> +++ b/drivers/media/i2c/video-i2c.c
>> @@ -736,9 +736,11 @@ static int video_i2c_probe(struct i2c_client *client,
>>  	video_set_drvdata(&data->vdev, data);
>>  	i2c_set_clientdata(client, data);
>>  
>> -	ret = data->chip->set_power(data, true);
>> -	if (ret)
>> -		goto error_unregister_device;
>> +	if (data->chip->set_power) {
>> +		ret = data->chip->set_power(data, true);
>> +		if (ret)
>> +			goto error_unregister_device;
>> +	}
> 
> How about adding a macro to call the op if it's set? It could be used to
> call other ops when they're set, and ignore them when they're not. Just an
> idea. See e.g. v4l2_subdev_call() in include/media/v4l2-subdev.h .

Matt, is this something you want to do? If so, then I'll wait for a v4.

Regards,

	Hans

> 
>>  
>>  	pm_runtime_get_noresume(&client->dev);
>>  	pm_runtime_set_active(&client->dev);
>> @@ -767,7 +769,9 @@ static int video_i2c_probe(struct i2c_client *client,
>>  	pm_runtime_disable(&client->dev);
>>  	pm_runtime_set_suspended(&client->dev);
>>  	pm_runtime_put_noidle(&client->dev);
>> -	data->chip->set_power(data, false);
>> +
>> +	if (data->chip->set_power)
>> +		data->chip->set_power(data, false);
>>  
>>  error_unregister_device:
>>  	v4l2_device_unregister(v4l2_dev);
>> @@ -791,7 +795,9 @@ static int video_i2c_remove(struct i2c_client *client)
>>  	pm_runtime_disable(&client->dev);
>>  	pm_runtime_set_suspended(&client->dev);
>>  	pm_runtime_put_noidle(&client->dev);
>> -	data->chip->set_power(data, false);
>> +
>> +	if (data->chip->set_power)
>> +		data->chip->set_power(data, false);
>>  
>>  	video_unregister_device(&data->vdev);
>>  
>> @@ -804,6 +810,9 @@ static int video_i2c_pm_runtime_suspend(struct device *dev)
>>  {
>>  	struct video_i2c_data *data = i2c_get_clientdata(to_i2c_client(dev));
>>  
>> +	if (!data->chip->set_power)
>> +		return 0;
>> +
>>  	return data->chip->set_power(data, false);
>>  }
>>  
>> @@ -811,6 +820,9 @@ static int video_i2c_pm_runtime_resume(struct device *dev)
>>  {
>>  	struct video_i2c_data *data = i2c_get_clientdata(to_i2c_client(dev));
>>  
>> +	if (!data->chip->set_power)
>> +		return 0;
>> +
>>  	return data->chip->set_power(data, true);
>>  }
>>  
>> -- 
>> 2.17.1
>>
> 
