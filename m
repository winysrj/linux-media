Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:50927 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754893AbcBBXSH (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 2 Feb 2016 18:18:07 -0500
Subject: Re: [PATCH] media: Media Controller fix to not let stream_count go
 negative
To: Sakari Ailus <sakari.ailus@iki.fi>, mchehab@osg.samsung.com
References: <1454184652-2427-1-git-send-email-shuahkh@osg.samsung.com>
 <20160202225321.GS14876@valkosipuli.retiisi.org.uk>
 <56B13612.1050101@osg.samsung.com>
 <20160202230908.GT14876@valkosipuli.retiisi.org.uk>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
	Shuah Khan <shuahkh@osg.samsung.com>
From: Shuah Khan <shuahkh@osg.samsung.com>
Message-ID: <56B1392D.6070800@osg.samsung.com>
Date: Tue, 2 Feb 2016 16:18:05 -0700
MIME-Version: 1.0
In-Reply-To: <20160202230908.GT14876@valkosipuli.retiisi.org.uk>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 02/02/2016 04:09 PM, Sakari Ailus wrote:
> Hi Shuah,
> 
> On Tue, Feb 02, 2016 at 04:04:50PM -0700, Shuah Khan wrote:
>> On 02/02/2016 03:53 PM, Sakari Ailus wrote:
>>> Hi Shuah,
>>>
>>> On Sat, Jan 30, 2016 at 01:10:52PM -0700, Shuah Khan wrote:
>>>> Change media_entity_pipeline_stop() to not decrement
>>>> stream_count of an inactive media pipeline. Doing so,
>>>> results in preventing starting the pipeline.
>>>>
>>>> Signed-off-by: Shuah Khan <shuahkh@osg.samsung.com>
>>>> ---
>>>>  drivers/media/media-entity.c | 18 ++++++++++++------
>>>>  1 file changed, 12 insertions(+), 6 deletions(-)
>>>>
>>>> diff --git a/drivers/media/media-entity.c b/drivers/media/media-entity.c
>>>> index e89d85a..f2e4360 100644
>>>> --- a/drivers/media/media-entity.c
>>>> +++ b/drivers/media/media-entity.c
>>>> @@ -452,9 +452,12 @@ error:
>>>>  	media_entity_graph_walk_start(graph, entity_err);
>>>>  
>>>>  	while ((entity_err = media_entity_graph_walk_next(graph))) {
>>>> -		entity_err->stream_count--;
>>>> -		if (entity_err->stream_count == 0)
>>>> -			entity_err->pipe = NULL;
>>>> +		/* don't let the stream_count go negative */
>>>> +		if (entity->stream_count > 0) {
>>>> +			entity_err->stream_count--;
>>>> +			if (entity_err->stream_count == 0)
>>>> +				entity_err->pipe = NULL;
>>>> +		}
>>>>  
>>>>  		/*
>>>>  		 * We haven't increased stream_count further than this
>>>> @@ -486,9 +489,12 @@ void media_entity_pipeline_stop(struct media_entity *entity)
>>>>  	media_entity_graph_walk_start(graph, entity);
>>>>  
>>>>  	while ((entity = media_entity_graph_walk_next(graph))) {
>>>> -		entity->stream_count--;
>>>> -		if (entity->stream_count == 0)
>>>> -			entity->pipe = NULL;
>>>> +		/* don't let the stream_count go negative */
>>>> +		if (entity->stream_count > 0) {
>>>> +			entity->stream_count--;
>>>> +			if (entity->stream_count == 0)
>>>> +				entity->pipe = NULL;
>>>> +		}
>>>>  	}
>>>>  
>>>>  	if (!--pipe->streaming_count)
>>>
>>> Have you seen issues with a certain driver, for instance?
>>>
>>> In the original design the streaming count is really a count --- streaming
>>> starts when count becomes non-zero, and stops when it reaches zero again.
>>>
>>> The calls to media_entity_pipeline_start() and media_entity_pipeline_stop()
>>> should thus always be balanced. I'm fine with the patch, but the framework
>>> should shout loud when the count would be decremented when it's zero.
>>>
>>> That was some four or more years ago. I have to say I really haven't been
>>> able to see good reasons for making this a count --- rather what's needed is
>>> to mark the entity as busy so that its link configuration isn't touched. The
>>> request API is a completely different matter then.
>>>
>>> Such change would require more discussion IMHO.
>>>
>>
>> Yes. I found problems with au0828 and ALSA
>> media controller use-case. It got into a state
>> where pipeline was essentially locked in a state.
>> It took some work to debug and find that the
>> stream_count was negative.
>>
>> Granted the start and stop should be balanced, however,
>> the media_entity_pipeline_stop() still needs to protect
>> the stream_count from going negative.
> 
> Agreed; I'm fine with the patch, except I think it should complain when that
> happens rather than silently ignoring it.
> 
> WARN_ON(1) perhaps? Or how about dev_err() loudly complaining about a driver
> bug?
> 

Yes. I can add a WARN_ON(1). Looks like we are using
it in other places in media-entity.c

thanks,
-- Shuah

-- 
Shuah Khan
Sr. Linux Kernel Developer
Open Source Innovation Group
Samsung Research America (Silicon Valley)
shuahkh@osg.samsung.com | (970) 217-8978
