Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr14.xs4all.nl ([194.109.24.34]:3631 "EHLO
	smtp-vbr14.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932761Ab3LIQSB (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 9 Dec 2013 11:18:01 -0500
Message-ID: <52A5ED25.4050500@xs4all.nl>
Date: Mon, 09 Dec 2013 17:17:41 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <m.chehab@samsung.com>
CC: linux-media@vger.kernel.org, Dinesh.Ram@cern.ch,
	edubezval@gmail.com, Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [PATCHv2 11/11] si4713: coding style cleanups
References: <1386325034-19344-1-git-send-email-hverkuil@xs4all.nl> <1386325034-19344-12-git-send-email-hverkuil@xs4all.nl> <20131209135144.17aa47f6@samsung.com>
In-Reply-To: <20131209135144.17aa47f6@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 12/09/2013 04:51 PM, Mauro Carvalho Chehab wrote:
> Em Fri,  6 Dec 2013 11:17:14 +0100
> Hans Verkuil <hverkuil@xs4all.nl> escreveu:
> 
>> From: Hans Verkuil <hans.verkuil@cisco.com>
>>
>> Fix most checkpatch errors/warnings.
>>
>> It's mostly whitespace changes, except for replacing msleep with
>> usleep_range and the jiffies comparison with time_is_after_jiffies().
>>
>> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
>> ---
>>  drivers/media/radio/si4713/radio-usb-si4713.c |   4 +-
>>  drivers/media/radio/si4713/si4713.c           | 104 +++++++++++++-------------
>>  2 files changed, 55 insertions(+), 53 deletions(-)
>>
>> diff --git a/drivers/media/radio/si4713/radio-usb-si4713.c b/drivers/media/radio/si4713/radio-usb-si4713.c
>> index d978844..691e487 100644
>> --- a/drivers/media/radio/si4713/radio-usb-si4713.c
>> +++ b/drivers/media/radio/si4713/radio-usb-si4713.c
>> @@ -207,7 +207,7 @@ static int si4713_send_startup_command(struct si4713_usb_device *radio)
>>  		}
>>  		if (time_is_before_jiffies(until_jiffies))
>>  			return -EIO;
>> -		msleep(3);
>> +		usleep_range(3000, 5000);
>>  	}
>>  
>>  	return retval;
>> @@ -354,7 +354,7 @@ static int si4713_i2c_read(struct si4713_usb_device *radio, char *data, int len)
>>  			data[0] = 0;
>>  			return 0;
>>  		}
>> -		msleep(3);
>> +		usleep_range(3000, 5000);
>>  	}
>>  }
>>  
>> diff --git a/drivers/media/radio/si4713/si4713.c b/drivers/media/radio/si4713/si4713.c
>> index 6f28a2b..451b9c0 100644
>> --- a/drivers/media/radio/si4713/si4713.c
>> +++ b/drivers/media/radio/si4713/si4713.c
>> @@ -50,12 +50,12 @@ MODULE_VERSION("0.0.1");
>>  #define DEFAULT_RDS_PS_REPEAT_COUNT	0x0003
>>  #define DEFAULT_LIMITER_RTIME		0x1392
>>  #define DEFAULT_LIMITER_DEV		0x102CA
>> -#define DEFAULT_PILOT_FREQUENCY 	0x4A38
>> +#define DEFAULT_PILOT_FREQUENCY		0x4A38
>>  #define DEFAULT_PILOT_DEVIATION		0x1A5E
>>  #define DEFAULT_ACOMP_ATIME		0x0000
>>  #define DEFAULT_ACOMP_RTIME		0xF4240L
>>  #define DEFAULT_ACOMP_GAIN		0x0F
>> -#define DEFAULT_ACOMP_THRESHOLD 	(-0x28)
>> +#define DEFAULT_ACOMP_THRESHOLD		(-0x28)
>>  #define DEFAULT_MUTE			0x01
>>  #define DEFAULT_POWER_LEVEL		88
>>  #define DEFAULT_FREQUENCY		8800
>> @@ -252,8 +252,8 @@ static int si4713_send_command(struct si4713_device *sdev, const u8 command,
>>  
>>  		if (client->irq)
>>  			return -EBUSY;
>> -		msleep(1);
>> -	} while (jiffies <= until_jiffies);
>> +		usleep_range(1000, 2000);
>> +	} while (time_is_after_jiffies(until_jiffies));
> 
> Condition seems to be wrong here: it should be time_is_before_jiffies().

No, the condition is good. 'time_is_after_jiffies(until_jiffies)' means
'until_jiffies > jiffies' which is 'jiffies <= until_jiffies'.

> Also, the better is to put this on a separate patch.

OK. 

Regards,

	Hans
