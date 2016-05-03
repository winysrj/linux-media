Return-path: <linux-media-owner@vger.kernel.org>
Received: from www381.your-server.de ([78.46.137.84]:44820 "EHLO
	www381.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933775AbcECQCm (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 3 May 2016 12:02:42 -0400
Subject: Re: [PATCH] media: fix use-after-free in cdev_put() when app exits
 after driver unbind
To: Shuah Khan <shuahkh@osg.samsung.com>, mchehab@osg.samsung.com,
	laurent.pinchart@ideasonboard.com, sakari.ailus@iki.fi
References: <1461969452-9276-1-git-send-email-shuahkh@osg.samsung.com>
 <57272910.8090500@metafoo.de> <5728BE73.7020505@osg.samsung.com>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
From: Lars-Peter Clausen <lars@metafoo.de>
Message-ID: <5728CB9D.2090509@metafoo.de>
Date: Tue, 3 May 2016 18:02:37 +0200
MIME-Version: 1.0
In-Reply-To: <5728BE73.7020505@osg.samsung.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 05/03/2016 05:06 PM, Shuah Khan wrote:
> On 05/02/2016 04:16 AM, Lars-Peter Clausen wrote:
>> On 04/30/2016 12:37 AM, Shuah Khan wrote:
>> [...]
>>> diff --git a/include/media/media-devnode.h b/include/media/media-devnode.h
>>> index 5bb3b0e..ce9b051 100644
>>> --- a/include/media/media-devnode.h
>>> +++ b/include/media/media-devnode.h
>>> @@ -72,6 +72,7 @@ struct media_file_operations {
>>>   * @fops:	pointer to struct &media_file_operations with media device ops
>>>   * @dev:	struct device pointer for the media controller device
>>>   * @cdev:	struct cdev pointer character device
>>> + * @kobj:	struct kobject
>>>   * @parent:	parent device
>>>   * @minor:	device node minor number
>>>   * @flags:	flags, combination of the MEDIA_FLAG_* constants
>>> @@ -91,6 +92,7 @@ struct media_devnode {
>>>  	/* sysfs */
>>>  	struct device dev;		/* media device */
>>>  	struct cdev cdev;		/* character device */
>>> +	struct kobject kobj;		/* set as cdev parent kobj */
>>
>> As said during the previous review, the struct device should be used for
>> reference counting. Otherwise a use-after-free can still occur since you now
>> have two reference counted data structures with independent counters in the
>> same structure. For one of them the counter goes to zero before the other
>> and then you have the use-after-free.
>>
> 
> struct device is embedded in the media_devnode and media_devnode
> will not be released until cdev releases the kobject since it is
> set as cdeev kobj.parent. I am not seeing any use-fater-free with
> this scheme.

There might still be a reference to the struct device at that point, so if
you free the media_devnode there is a use-after-free.

