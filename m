Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:44364 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751754AbcCJOaM (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 10 Mar 2016 09:30:12 -0500
Subject: Re: [PATCH v3 06/22] media: Media Controller enable/disable source
 handler API
To: Sakari Ailus <sakari.ailus@iki.fi>
References: <cover.1455233150.git.shuahkh@osg.samsung.com>
 <2d8b035ec723346dfeed5db859aba67738e049cc.1455233153.git.shuahkh@osg.samsung.com>
 <20160310073500.GK11084@valkosipuli.retiisi.org.uk>
Cc: mchehab@osg.samsung.com, tiwai@suse.com, clemens@ladisch.de,
	hans.verkuil@cisco.com, laurent.pinchart@ideasonboard.com,
	sakari.ailus@linux.intel.com, javier@osg.samsung.com,
	pawel@osciak.com, m.szyprowski@samsung.com,
	kyungmin.park@samsung.com, perex@perex.cz, arnd@arndb.de,
	dan.carpenter@oracle.com, tvboxspy@gmail.com, crope@iki.fi,
	ruchandani.tina@gmail.com, corbet@lwn.net, chehabrafael@gmail.com,
	k.kozlowski@samsung.com, stefanr@s5r6.in-berlin.de,
	inki.dae@samsung.com, jh1009.sung@samsung.com,
	elfring@users.sourceforge.net, prabhakar.csengg@gmail.com,
	sw0312.kim@samsung.com, p.zabel@pengutronix.de,
	ricardo.ribalda@gmail.com, labbott@fedoraproject.org,
	pierre-louis.bossart@linux.intel.com, ricard.wanderlof@axis.com,
	julian@jusst.de, takamichiho@gmail.com, dominic.sacre@gmx.de,
	misterpib@gmail.com, daniel@zonque.org, gtmkramer@xs4all.nl,
	normalperson@yhbt.net, joe@oampo.co.uk, linuxbugs@vittgam.net,
	johan@oljud.se, klock.android@gmail.com, nenggun.kim@samsung.com,
	j.anaszewski@samsung.com, geliangtang@163.com, albert@huitsing.nl,
	linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
	alsa-devel@alsa-project.org, Shuah Khan <shuahkh@osg.samsung.com>
From: Shuah Khan <shuahkh@osg.samsung.com>
Message-ID: <56E184E7.80603@osg.samsung.com>
Date: Thu, 10 Mar 2016 07:29:59 -0700
MIME-Version: 1.0
In-Reply-To: <20160310073500.GK11084@valkosipuli.retiisi.org.uk>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 03/10/2016 12:35 AM, Sakari Ailus wrote:
> Hi Shuah,
> 
> On Thu, Feb 11, 2016 at 04:41:22PM -0700, Shuah Khan wrote:
>> Add new fields to struct media_device to add enable_source, and
>> disable_source handlers, and source_priv to stash driver private
>> data that is used to run these handlers. The enable_source handler
>> finds source entity for the passed in entity and checks if it is
>> available. When link is found, it activates it. Disable source
>> handler deactivates the link.
>>
>> Bridge driver is expected to implement and set these handlers.
>>
>> Signed-off-by: Shuah Khan <shuahkh@osg.samsung.com>
>> ---
>>  include/media/media-device.h | 30 ++++++++++++++++++++++++++++++
>>  1 file changed, 30 insertions(+)
>>
>> diff --git a/include/media/media-device.h b/include/media/media-device.h
>> index 075a482..1a04644 100644
>> --- a/include/media/media-device.h
>> +++ b/include/media/media-device.h
>> @@ -302,6 +302,11 @@ struct media_entity_notify {
>>   * @entity_notify: List of registered entity_notify callbacks
>>   * @lock:	Entities list lock
>>   * @graph_mutex: Entities graph operation lock
>> + *
>> + * @source_priv: Driver Private data for enable/disable source handlers
>> + * @enable_source: Enable Source Handler function pointer
>> + * @disable_source: Disable Source Handler function pointer
>> + *
>>   * @link_notify: Link state change notification callback
>>   *
>>   * This structure represents an abstract high-level media device. It allows easy
>> @@ -313,6 +318,26 @@ struct media_entity_notify {
>>   *
>>   * @model is a descriptive model name exported through sysfs. It doesn't have to
>>   * be unique.
>> + *
>> + * @enable_source is a handler to find source entity for the
>> + * sink entity  and activate the link between them if source
>> + * entity is free. Drivers should call this handler before
>> + * accessing the source.
>> + *
>> + * @disable_source is a handler to find source entity for the
>> + * sink entity  and deactivate the link between them. Drivers
>> + * should call this handler to release the source.
>> + *
> 
> Is there a particular reason you're not simply (de)activating the link, but
> instead add a new callback?

These two handlers are separate for a couple of reasons:

1. Explicit and symmetric API is easier to use and maintain.
   Similar what we do in other cases, register/unregister
   get/put etc.
2. This is more important. Disable handler makes sure the
   owner is releasing the resource. Otherwise, when some
   other application does enable, the owner could loose
   the resource, if enable and disable are the same.

   e.g: Video app is holding the resource, DVB app does
   enable. Disable handler makes sure Video/owner  is the one
   that is asking to do the release.

thanks,
-- Shuah

> 
>> + * Note: Bridge driver is expected to implement and set the
>> + * handler when media_device is registered or when
>> + * bridge driver finds the media_device during probe.
>> + * Bridge driver sets source_priv with information
>> + * necessary to run enable/disable source handlers.
>> + *
>> + * Use-case: find tuner entity connected to the decoder
>> + * entity and check if it is available, and activate the
>> + * the link between them from enable_source and deactivate
>> + * from disable_source.
>>   */
>>  struct media_device {
>>  	/* dev->driver_data points to this struct. */
>> @@ -344,6 +369,11 @@ struct media_device {
>>  	/* Serializes graph operations. */
>>  	struct mutex graph_mutex;
>>  
>> +	void *source_priv;
>> +	int (*enable_source)(struct media_entity *entity,
>> +			     struct media_pipeline *pipe);
>> +	void (*disable_source)(struct media_entity *entity);
>> +
>>  	int (*link_notify)(struct media_link *link, u32 flags,
>>  			   unsigned int notification);
>>  };
> 


-- 
Shuah Khan
Sr. Linux Kernel Developer
Open Source Innovation Group
Samsung Research America (Silicon Valley)
shuahkh@osg.samsung.com | (970) 217-8978
