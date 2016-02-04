Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:54892 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965793AbcBDPAc (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 4 Feb 2016 10:00:32 -0500
Subject: Re: [PATCH v2 06/22] media: Media Controller non-locking
 __media_entity_pipeline_start/stop()
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
References: <cover.1454557589.git.shuahkh@osg.samsung.com>
 <5c5a74a0d87db11dd1519248d8fda5c8fa9826be.1454557589.git.shuahkh@osg.samsung.com>
 <20160204071803.29d3682d@recife.lan>
Cc: tiwai@suse.com, clemens@ladisch.de, hans.verkuil@cisco.com,
	laurent.pinchart@ideasonboard.com, sakari.ailus@linux.intel.com,
	javier@osg.samsung.com, pawel@osciak.com, m.szyprowski@samsung.com,
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
	j.anaszewski@samsung.com, geliangtang@163.com,
	linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
	alsa-devel@alsa-project.org, Shuah Khan <shuahkh@osg.samsung.com>
From: Shuah Khan <shuahkh@osg.samsung.com>
Message-ID: <56B36787.4060304@osg.samsung.com>
Date: Thu, 4 Feb 2016 08:00:23 -0700
MIME-Version: 1.0
In-Reply-To: <20160204071803.29d3682d@recife.lan>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 02/04/2016 02:18 AM, Mauro Carvalho Chehab wrote:
> Em Wed, 03 Feb 2016 21:03:38 -0700
> Shuah Khan <shuahkh@osg.samsung.com> escreveu:
> 
>> Add non-locking __media_entity_pipeline_start/stop() interfaces
>> to be called from code paths that hold the graph_mutex. For this
>> change, the media_entity_pipeline_start() routine is renamed to
>> __media_entity_pipeline_start() minus the graph_mutex lock and
>> unlock. media_entity_pipeline_start() now calls the non-locking
>> __media_entity_pipeline_start() holding the graph_lock. The stop
>> interface, media_entity_pipeline_stop() routine is renamed to
>> __media_entity_pipeline_stop() minus the graph_mutex lock and
>> unlock. media_entity_pipeline_stop() now calls the non-locking
>> __media_entity_pipeline_stop() holding the graph_lock.
> 
> Please write a better patch descriptions. The above could easily
> be split into 3 or 4 paragraphs, with would make it easier to
> read.
> 

Removed linux-api from cc list


ok - I updated several changelogs based on your earlier
comments and this one slipped by.

-- Shuah
> Also, too much details, written on a spaghetti style;)
> 
> It is obvious by anyone that looked at the patch that
> "media_entity_pipeline_start() routine is renamed to 
> __media_entity_pipeline_start() minus the graph_mutex lock and
> unlock."
> 
> I read exactly the same thing at the C code, *and* at the
> subject of the e-mail. Patch subject/description should tell
> what, why and how (but you should not repeat what can easily
> be inferred from looking at the diff).
> 
> I would describe it as:
> 
>    Currently, media pipeline graph traversal routines take
>    the graph_mutex lock.
> 
>    While this works for the current code, we'll need 
>    unlocked versions of them because
>    (some explanation *why* you need it, with is the main
>     thing that should be at the description).
> 
>    So, add non-locking media_entity_pipeline_start/stop()
>    variations.
> 
>>
>> Signed-off-by: Shuah Khan <shuahkh@osg.samsung.com>
>> ---
>>  drivers/media/media-entity.c | 34 ++++++++++++++++++++++++----------
>>  include/media/media-entity.h | 12 ++++++++++++
>>  2 files changed, 36 insertions(+), 10 deletions(-)
>>
>> diff --git a/drivers/media/media-entity.c b/drivers/media/media-entity.c
>> index 9b4d712..b78e4c2 100644
>> --- a/drivers/media/media-entity.c
>> +++ b/drivers/media/media-entity.c
>> @@ -365,8 +365,8 @@ EXPORT_SYMBOL_GPL(media_entity_graph_walk_next);
>>   * Pipeline management
>>   */
>>  
>> -__must_check int media_entity_pipeline_start(struct media_entity *entity,
>> -					     struct media_pipeline *pipe)
>> +__must_check int __media_entity_pipeline_start(struct media_entity *entity,
>> +					       struct media_pipeline *pipe)
>>  {
>>  	struct media_device *mdev = entity->graph_obj.mdev;
>>  	struct media_entity_graph *graph = &pipe->graph;
>> @@ -374,8 +374,6 @@ __must_check int media_entity_pipeline_start(struct media_entity *entity,
>>  	struct media_link *link;
>>  	int ret;
>>  
>> -	mutex_lock(&mdev->graph_mutex);
>> -
>>  	if (!pipe->streaming_count++) {
>>  		ret = media_entity_graph_walk_init(&pipe->graph, mdev);
>>  		if (ret)
>> @@ -456,8 +454,6 @@ __must_check int media_entity_pipeline_start(struct media_entity *entity,
>>  		}
>>  	}
>>  
>> -	mutex_unlock(&mdev->graph_mutex);
>> -
>>  	return 0;
>>  
>>  error:
>> @@ -487,19 +483,28 @@ error_graph_walk_start:
>>  	if (!--pipe->streaming_count)
>>  		media_entity_graph_walk_cleanup(graph);
>>  
>> -	mutex_unlock(&mdev->graph_mutex);
>> +	return ret;
>> +}
>> +EXPORT_SYMBOL_GPL(__media_entity_pipeline_start);
>>  
>> +__must_check int media_entity_pipeline_start(struct media_entity *entity,
>> +					     struct media_pipeline *pipe)
>> +{
>> +	struct media_device *mdev = entity->graph_obj.mdev;
>> +	int ret;
>> +
>> +	mutex_lock(&mdev->graph_mutex);
>> +	ret = __media_entity_pipeline_start(entity, pipe);
>> +	mutex_unlock(&mdev->graph_mutex);
>>  	return ret;
>>  }
>>  EXPORT_SYMBOL_GPL(media_entity_pipeline_start);
>>  
>> -void media_entity_pipeline_stop(struct media_entity *entity)
>> +void __media_entity_pipeline_stop(struct media_entity *entity)
>>  {
>> -	struct media_device *mdev = entity->graph_obj.mdev;
>>  	struct media_entity_graph *graph = &entity->pipe->graph;
>>  	struct media_pipeline *pipe = entity->pipe;
>>  
>> -	mutex_lock(&mdev->graph_mutex);
>>  
>>  	WARN_ON(!pipe->streaming_count);
>>  	media_entity_graph_walk_start(graph, entity);
>> @@ -516,6 +521,15 @@ void media_entity_pipeline_stop(struct media_entity *entity)
>>  	if (!--pipe->streaming_count)
>>  		media_entity_graph_walk_cleanup(graph);
>>  
>> +}
>> +EXPORT_SYMBOL_GPL(__media_entity_pipeline_stop);
>> +
>> +void media_entity_pipeline_stop(struct media_entity *entity)
>> +{
>> +	struct media_device *mdev = entity->graph_obj.mdev;
>> +
>> +	mutex_lock(&mdev->graph_mutex);
>> +	__media_entity_pipeline_stop(entity);
>>  	mutex_unlock(&mdev->graph_mutex);
>>  }
>>  EXPORT_SYMBOL_GPL(media_entity_pipeline_stop);
>> diff --git a/include/media/media-entity.h b/include/media/media-entity.h
>> index fe485d3..c7583db 100644
>> --- a/include/media/media-entity.h
>> +++ b/include/media/media-entity.h
>> @@ -832,6 +832,12 @@ media_entity_graph_walk_next(struct media_entity_graph *graph);
>>   */
>>  __must_check int media_entity_pipeline_start(struct media_entity *entity,
>>  					     struct media_pipeline *pipe);
>> +/**
>> + * non-locking __media_entity_pipeline_start() can be called from
>> + * code paths that hold the graph_mutex
>> + */
>> +__must_check int __media_entity_pipeline_start(struct media_entity *entity,
>> +					       struct media_pipeline *pipe);
>>  
>>  /**
>>   * media_entity_pipeline_stop - Mark a pipeline as not streaming
>> @@ -848,6 +854,12 @@ __must_check int media_entity_pipeline_start(struct media_entity *entity,
>>  void media_entity_pipeline_stop(struct media_entity *entity);
>>  
>>  /**
>> + * non-locking __media_entity_pipeline_stop() can be called from
>> + * code paths that hold the graph_mutex
>> + */
>> +void __media_entity_pipeline_stop(struct media_entity *entity);
>> +
>> +/**
>>   * media_devnode_create() - creates and initializes a device node interface
>>   *
>>   * @mdev:	pointer to struct &media_device


-- 
Shuah Khan
Sr. Linux Kernel Developer
Open Source Innovation Group
Samsung Research America (Silicon Valley)
shuahkh@osg.samsung.com | (970) 217-8978
