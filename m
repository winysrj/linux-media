Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:58424 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751160AbcC1Np5 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 28 Mar 2016 09:45:57 -0400
Subject: Re: [RFC PATCH 1/4] media: Add Media Device Allocator API
To: Joe Perches <joe@perches.com>, laurent.pinchart@ideasonboard.com,
	mchehab@osg.samsung.com, perex@perex.cz, tiwai@suse.com,
	hans.verkuil@cisco.com, chehabrafael@gmail.com,
	javier@osg.samsung.com, jh1009.sung@samsung.com
References: <cover.1458966594.git.shuahkh@osg.samsung.com>
 <41d017ef76e3206780c018399ec60b63d865f65c.1458966594.git.shuahkh@osg.samsung.com>
 <1458996622.23450.4.camel@perches.com>
Cc: linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
	alsa-devel@alsa-project.org, Shuah Khan <shuahkh@osg.samsung.com>
From: Shuah Khan <shuahkh@osg.samsung.com>
Message-ID: <56F93589.4020102@osg.samsung.com>
Date: Mon, 28 Mar 2016 07:45:45 -0600
MIME-Version: 1.0
In-Reply-To: <1458996622.23450.4.camel@perches.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 03/26/2016 06:50 AM, Joe Perches wrote:
> On Fri, 2016-03-25 at 22:38 -0600, Shuah Khan wrote:
>> Add Media Device Allocator API to manage Media Device life time problems.
>> There are known problems with media device life time management. When media
>> device is released while an media ioctl is in progress, ioctls fail with
>> use-after-free errors and kernel hangs in some cases.
> 
> Seems reasonable, thanks.
> 
> trivial:
> 
>> diff --git a/drivers/media/media-dev-allocator.c b/drivers/media/media-dev-allocator.c
> []
>> +static struct media_device *__media_device_get(struct device *dev,
>> +					       bool alloc, bool kref)
>> +{
> []
>> +	pr_info("%s: mdev=%p\n", __func__, &mdi->mdev);
> 
> All of the pr_info uses here seem like debugging
> and should likely be pr_debug instead.

Correct. These are for debug and I plan to either remove them completely
or make them pr_debug().

>> +struct media_device *media_device_find(struct device *dev)
>> +{
>> +	pr_info("%s\n", __func__);
> 
> These seem like function tracing and maybe could/should
> use ftrace instead.
> +/* don't allocate - increment kref if one is found */
>> +struct media_device *media_device_get_ref(struct device *dev)
>> +{
>> +	pr_info("%s\n", __func__);
> 

Same here. This is also debug. However, you gave me an idea, this could be a
tracevent, if I find it useful for event tracing. It might be useful to be able
to track kref holds on this.

thanks,
-- Shuah
