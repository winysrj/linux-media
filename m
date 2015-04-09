Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud2.xs4all.net ([194.109.24.25]:46465 "EHLO
	lb2-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751543AbbDIHeJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 9 Apr 2015 03:34:09 -0400
Message-ID: <55262B68.8040408@xs4all.nl>
Date: Thu, 09 Apr 2015 09:34:00 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Pavel Machek <pavel@ucw.cz>
CC: linux-media@vger.kernel.org, Sakari Ailus <sakari.ailus@iki.fi>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Subject: Re: [git:media_tree/master] [media] Add device tree support to adp1653
 flash driver
References: <E1Yg11T-00074E-Hx@www.linuxtv.org> <55261B75.1070400@xs4all.nl> <20150409073054.GA20325@amd>
In-Reply-To: <20150409073054.GA20325@amd>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 04/09/2015 09:30 AM, Pavel Machek wrote:
> Hi!
> 
>> Hi Pawel,
> 
> Me?

Oops, sorry. I meant Pavel. Apologies for misspelling your name.

> 
>> This driver doesn't compile:
>>
>> On 04/08/2015 10:46 PM, Mauro Carvalho Chehab wrote:
>>> This is an automatic generated email to let you know that the following patch were queued at the 
>>> http://git.linuxtv.org/cgit.cgi/media_tree.git tree:
>>>
> 
>>> --- a/drivers/media/i2c/adp1653.c
>>> +++ b/drivers/media/i2c/adp1653.c
>>> @@ -306,9 +309,17 @@ adp1653_init_device(struct adp1653_flash *flash)
>>>  static int
>>>  __adp1653_set_power(struct adp1653_flash *flash, int on)
>>>  {
>>> -	int ret;
>>> +	int ret = 0;
>>> +
>>> +	if (flash->platform_data->power) {
>>> +		ret = flash->platform_data->power(&flash->subdev, on);
>>> +	} else {
>>> +		gpio_set_value(flash->platform_data->power_gpio, on);
>>
>> The power_gpio field is not found in struct adp1653_platform_data.
> 
> Yes, int power_gpio should be added into that struct.
> 
>> Can you fix this?
>>
>> I'm also getting this warning:
> 
> Well, old version of patch was merged while new versions were getting
> discussed / developed in another mail thread.
> 
> I guess best course of action is to drop this from Mauro's tree, as
> conflicting patch exists in Sakari's tree...?

Sakari, do you agree? How did this patch manage to be merged? Was it not
marked Superseded?

Regards,

	Hans
