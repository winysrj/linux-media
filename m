Return-path: <linux-media-owner@vger.kernel.org>
Received: from bhuna.collabora.co.uk ([46.235.227.227]:57258 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756732AbdDGOgh (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 7 Apr 2017 10:36:37 -0400
Subject: Re: [PATCH] [media] media-entity: only call dev_dbg_obj if mdev is
 not NULL
To: Sakari Ailus <sakari.ailus@iki.fi>
References: <1491507120-28112-1-git-send-email-helen.koike@collabora.com>
 <20170407074015.GB4192@valkosipuli.retiisi.org.uk>
Cc: linux-media@vger.kernel.org, mchehab@kernel.org,
        linux-kernel@vger.kernel.org
From: Helen Koike <helen.koike@collabora.com>
Message-ID: <f3f83e8f-41e3-3567-8ec6-c4e693e7297e@collabora.com>
Date: Fri, 7 Apr 2017 11:36:29 -0300
MIME-Version: 1.0
In-Reply-To: <20170407074015.GB4192@valkosipuli.retiisi.org.uk>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

On 2017-04-07 04:40 AM, Sakari Ailus wrote:
> Hi Helen,
>
> On Thu, Apr 06, 2017 at 04:32:00PM -0300, Helen Koike wrote:
>> Fix kernel Oops NULL pointer deference
>> Call dev_dbg_obj only after checking if gobj->mdev is not NULL
>>
>> Signed-off-by: Helen Koike <helen.koike@collabora.com>
>> ---
>>  drivers/media/media-entity.c | 4 ++--
>>  1 file changed, 2 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/media/media-entity.c b/drivers/media/media-entity.c
>> index 5640ca2..bc44193 100644
>> --- a/drivers/media/media-entity.c
>> +++ b/drivers/media/media-entity.c
>> @@ -199,12 +199,12 @@ void media_gobj_create(struct media_device *mdev,
>>
>>  void media_gobj_destroy(struct media_gobj *gobj)
>>  {
>> -	dev_dbg_obj(__func__, gobj);
>> -
>>  	/* Do nothing if the object is not linked. */
>>  	if (gobj->mdev == NULL)
>>  		return;
>>
>> +	dev_dbg_obj(__func__, gobj);
>> +
>>  	gobj->mdev->topology_version++;
>>
>>  	/* Remove the object from mdev list */
>
> Where is media_gobj_destroy() called with an object with NULL mdev?
>
> I do not object to the change, but would like to know because I don't think
> it's supposed to happen.


This happens when media_device_unregister(mdev) is called before 
unregistering the subdevices v4l2_device_unregister_subdev(sd) (which 
should be possible).

v4l2_device_unregister_subdev(sd) ends up calling v4l2_device_release() 
that calls media_device_unregister_entity() again (previously called by 
media_device_unregister(mdev)

Helen

>
> There are issues though, until the patches fixing object referencing are
> finished and merged. Unfortunately I haven't been able to work on those
> recently, will pick them up again soon...
>
