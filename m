Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:58761 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753065AbcC1VOi (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 28 Mar 2016 17:14:38 -0400
Subject: Re: [RFC PATCH 2/4] media: Add Media Device Allocator API
 documentation
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
References: <cover.1458966594.git.shuahkh@osg.samsung.com>
 <33083175297b174a68b937e9bf2d867add363e23.1458966594.git.shuahkh@osg.samsung.com>
 <20160328152821.18142532@recife.lan>
Cc: laurent.pinchart@ideasonboard.com, perex@perex.cz, tiwai@suse.com,
	hans.verkuil@cisco.com, chehabrafael@gmail.com,
	javier@osg.samsung.com, jh1009.sung@samsung.com,
	linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
	alsa-devel@alsa-project.org, Shuah Khan <shuahkh@osg.samsung.com>
From: Shuah Khan <shuahkh@osg.samsung.com>
Message-ID: <56F99EBB.3070007@osg.samsung.com>
Date: Mon, 28 Mar 2016 15:14:35 -0600
MIME-Version: 1.0
In-Reply-To: <20160328152821.18142532@recife.lan>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 03/28/2016 12:28 PM, Mauro Carvalho Chehab wrote:
> Em Fri, 25 Mar 2016 22:38:43 -0600
> Shuah Khan <shuahkh@osg.samsung.com> escreveu:
> 
>> Add Media Device Allocator API documentation.
> 
> Please merge this with the previous patch.

Yes. I will merge them.

-- Shuah
> 
>>
>> Signed-off-by: Shuah Khan <shuahkh@osg.samsung.com>
>> ---
>>  include/media/media-dev-allocator.h | 32 ++++++++++++++++++++++++++++++++
>>  1 file changed, 32 insertions(+)
>>
>> diff --git a/include/media/media-dev-allocator.h b/include/media/media-dev-allocator.h
>> index 2932c90..174840c 100644
>> --- a/include/media/media-dev-allocator.h
>> +++ b/include/media/media-dev-allocator.h
>> @@ -20,6 +20,38 @@
>>  
>>  #ifdef CONFIG_MEDIA_CONTROLLER
>>  /**
>> + * DOC: Media Controller Device Allocator API
>> + * There are known problems with media device life time management. When media
>> + * device is released while an media ioctl is in progress, ioctls fail with
>> + * use-after-free errors and kernel hangs in some cases.
>> + * 
>> + * Media Device can be in any the following states:
>> + * 
>> + * - Allocated
>> + * - Registered (could be tied to more than one driver)
>> + * - Unregistered, not in use (media device file is not open)
>> + * - Unregistered, in use (media device file is not open)
>> + * - Released
>> + * 
>> + * When media device belongs to  more than one driver, registrations should be
>> + * refcounted to avoid unregistering when one of the drivers does unregister.
>> + * A refcount field in the struct media_device covers this case. Unregister on
>> + * a Media Allocator media device is a kref_put() call. The media device should
>> + * be unregistered only when the last unregister occurs.
>> + * 
>> + * When a media device is in use when it is unregistered, it should not be
>> + * released until the application exits when it detects the unregistered
>> + * status. Media device that is in use when it is unregistered is moved to
>> + * to_delete_list. When the last unregister occurs, media device is unregistered
>> + * and becomes an unregistered, still allocated device. Unregister marks the
>> + * device to be deleted.
>> + * 
>> + * When media device belongs to more than one driver, as both drivers could be
>> + * unbound/bound, driver should not end up getting stale media device that is
>> + * on its way out. Moving the unregistered media device to to_delete_list helps
>> + * this case as well.
>> + */
>> +/**
>>   * media_device_get() - Allocate and return global media device
>>   *
>>   * @mdev
> 
> 

