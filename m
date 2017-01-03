Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:57963 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1759745AbdACRQn (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 3 Jan 2017 12:16:43 -0500
Subject: Re: [PATCH] media: entity: Catch unbalanced media_pipeline_stop calls
To: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>,
        sakari.ailus@iki.fi
References: <1483449131-18075-1-git-send-email-kieran.bingham+renesas@ideasonboard.com>
 <2426604.oXt7iAeI8O@avalon>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        mchehab@kernel.org, linux-media@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org
From: Kieran Bingham <kieran.bingham@ideasonboard.com>
Message-ID: <f2029382-de41-3267-d1f2-6b1366bcae27@ideasonboard.com>
Date: Tue, 3 Jan 2017 17:05:58 +0000
MIME-Version: 1.0
In-Reply-To: <2426604.oXt7iAeI8O@avalon>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 03/01/17 13:36, Laurent Pinchart wrote:
> Hi Kieran,
> 
> Thank you for the patch.
> 
> On Tuesday 03 Jan 2017 13:12:11 Kieran Bingham wrote:
>> Drivers must not perform unbalanced calls to stop the entity pipeline,
>> however if they do they will fault in the core media code, as the
>> entity->pipe will be set as NULL. We handle this gracefully in the core
>> with a WARN for the developer.
>>
>> Replace the erroneous check on zero streaming counts, with a check on
>> NULL pipe elements instead, as this is the symptom of unbalanced
>> media_pipeline_stop calls.
>>
>> Signed-off-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
> 
> This looks good to me,
> 
> Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> 
> I'll let Sakari review and merge the patch.

Ahh, yes - I forgot to mention, although perhaps it will be obvious for
Sakari - but this patch is based on top of Sakari's pending media
pipeline and graph walk cleanup series :D

--
Regards

Kieran

> 
>> ---
>>  drivers/media/media-entity.c | 7 ++++++-
>>  1 file changed, 6 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/media/media-entity.c b/drivers/media/media-entity.c
>> index caa13e6f09f5..cb1fb2c17f85 100644
>> --- a/drivers/media/media-entity.c
>> +++ b/drivers/media/media-entity.c
>> @@ -534,8 +534,13 @@ void __media_pipeline_stop(struct media_entity *entity)
>> struct media_graph *graph = &entity->pipe->graph;
>>  	struct media_pipeline *pipe = entity->pipe;
>>
>> +	/*
>> +	 * If the following check fails, the driver has performed an
>> +	 * unbalanced call to media_pipeline_stop()
>> +	 */
>> +	if (WARN_ON(!pipe))
>> +		return;
>>
>> -	WARN_ON(!pipe->streaming_count);
>>  	media_graph_walk_start(graph, entity);
>>
>>  	while ((entity = media_graph_walk_next(graph))) {
> 
