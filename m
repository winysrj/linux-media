Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:54464 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933069AbcCRNhH (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 18 Mar 2016 09:37:07 -0400
Subject: Re: [PATCH] media: fix media_device_unregister() to destroy media
 device device resource
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
References: <1458254796-7727-1-git-send-email-shuahkh@osg.samsung.com>
 <20160318065231.67f2cd8b@recife.lan>
Cc: tiwai@suse.de, linux-media@vger.kernel.org,
	linux-kernel@vger.kernel.org, Shuah Khan <shuahkh@osg.samsung.com>
From: Shuah Khan <shuahkh@osg.samsung.com>
Message-ID: <56EC0479.3050405@osg.samsung.com>
Date: Fri, 18 Mar 2016 07:36:57 -0600
MIME-Version: 1.0
In-Reply-To: <20160318065231.67f2cd8b@recife.lan>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 03/18/2016 03:52 AM, Mauro Carvalho Chehab wrote:
> Em Thu, 17 Mar 2016 16:46:36 -0600
> Shuah Khan <shuahkh@osg.samsung.com> escreveu:
> 
>> When all drivers except usb-core driver is unbound, destroy the media device
>> resource. Other wise, media device resource will persist in a defunct state.
>> This leads to use-after-free and bad access errors during a subsequent bind.
>> Fix it to destroy the media device resource when last reference is released
>> in media_device_unregister().
>>
>> Signed-off-by: Shuah Khan <shuahkh@osg.samsung.com>
>> ---
>>  drivers/media/media-device.c | 28 ++++++++++++++++++++++------
>>  1 file changed, 22 insertions(+), 6 deletions(-)
>>
>> diff --git a/drivers/media/media-device.c b/drivers/media/media-device.c
>> index 070421e..7312612 100644
>> --- a/drivers/media/media-device.c
>> +++ b/drivers/media/media-device.c
>> @@ -822,22 +822,38 @@ printk("%s: mdev=%p\n", __func__, mdev);
>>  	dev_dbg(mdev->dev, "Media device unregistered\n");
>>  }
>>  
>> +static void media_device_release_devres(struct device *dev, void *res)
>> +{
>> +}
>> +
>> +static void media_device_destroy_devres(struct device *dev)
>> +{
>> +	int ret;
>> +
>> +	ret = devres_destroy(dev, media_device_release_devres, NULL, NULL);
>> +	pr_debug("%s: devres_destroy() returned %d\n", __func__, ret);
>> +}
>> +
>>  void media_device_unregister(struct media_device *mdev)
>>  {
>> +	int ret;
>> +	struct device *dev;
>>  printk("%s: mdev=%p\n", __func__, mdev);
>>  	if (mdev == NULL)
>>  		return;
>>  
>> -	mutex_lock(&mdev->graph_mutex);
>> -	kref_put(&mdev->kref, do_media_device_unregister);
>> -	mutex_unlock(&mdev->graph_mutex);
>> +	ret = kref_put_mutex(&mdev->kref, do_media_device_unregister,
>> +			     &mdev->graph_mutex);
>> +	if (ret) {
>> +		/* do_media_device_unregister() has run */
>> +		dev = mdev->dev;
>> +		mutex_unlock(&mdev->graph_mutex);
> 
> 
>> +		media_device_destroy_devres(dev);
> 
> This doesn't seem right: what happens on drivers that don't use
> devres to allocate struct media_device?
> 

That is okay. devres_destroy() won't find the resource. The way it works
is it will try to find the resource with the match routine and data and
that step will fail it will return -ENOENT. At that point nothing more
is done.

ret = devres_destroy(dev, media_device_release_devres, NULL, NULL);
pr_debug("%s: devres_destroy() returned %d\n", __func__, ret);

devres_destroy() combines the devres_find() and remove. So we are good
here.

thanks,
-- Shuah


-- 
Shuah Khan
Sr. Linux Kernel Developer
Open Source Innovation Group
Samsung Research America (Silicon Valley)
shuahkh@osg.samsung.com | (970) 217-8978
