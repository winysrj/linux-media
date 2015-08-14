Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud2.xs4all.net ([194.109.24.29]:60373 "EHLO
	lb3-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755393AbbHNPeB (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 14 Aug 2015 11:34:01 -0400
Message-ID: <55CE0A48.2060505@xs4all.nl>
Date: Fri, 14 Aug 2015 17:33:28 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
CC: Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [PATCH v4 6/6] media: use media_graph_obj inside links
References: <cover.1439563682.git.mchehab@osg.samsung.com> <b7b0a4f38b7ae2bb3bd69aeaf3476250f489d50a.1439563682.git.mchehab@osg.samsung.com> <55CE06C4.7080100@xs4all.nl>
In-Reply-To: <55CE06C4.7080100@xs4all.nl>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 08/14/2015 05:18 PM, Hans Verkuil wrote:
> On 08/14/2015 04:56 PM, Mauro Carvalho Chehab wrote:
>> Just like entities and pads, links also need to have unique
>> Object IDs along a given media controller.
>>
>> So, let's add a media_graph_obj inside it and initialize
>> the object then a new link is created.
>>
>> Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
>>
>> diff --git a/drivers/media/media-device.c b/drivers/media/media-device.c
>> index 3ac5803b327e..9f02939c2864 100644
>> --- a/drivers/media/media-device.c
>> +++ b/drivers/media/media-device.c
>> @@ -466,6 +466,8 @@ void media_device_unregister_entity(struct media_entity *entity)
>>  	graph_obj_remove(&entity->graph_obj);
>>  	for (i = 0; i < entity->num_pads; i++)
>>  		graph_obj_remove(&entity->pads[i].graph_obj);
>> +	for (i = 0; entity->num_links; i++)
>> +		graph_obj_remove(&entity->links[i].graph_obj);
>>  	list_del(&entity->list);
>>  	spin_unlock(&mdev->lock);
>>  	entity->parent = NULL;
>> diff --git a/drivers/media/media-entity.c b/drivers/media/media-entity.c
>> index d3dee6fc79d7..4f18bd10b162 100644
>> --- a/drivers/media/media-entity.c
>> +++ b/drivers/media/media-entity.c
>> @@ -50,6 +50,8 @@ void graph_obj_init(struct media_device *mdev,
>>  		gobj->id |= ++mdev->entity_id;
>>  	case MEDIA_GRAPH_PAD:
>>  		gobj->id |= ++mdev->pad_id;
>> +	case MEDIA_GRAPH_LINK:
>> +		gobj->id |= ++mdev->pad_id;
> 
> Same issue with missing breaks. Also for links you want to use link_id, not
> pad_id. Clearly a copy-and-paste mistake.
> 
> A bigger question is whether you actually need graph_obj for a link? Links are
> *between* graph objects, but are they really graph objects in their own right?
> 
> Currently a link is identified by the source/sink objects and I think that is
> all you need. I didn't realize that when reviewing the v3 patch series, but I'm
> now wondering about it.
> 
> If you *don't* make links a graph_obj, will anything break or become difficult
> to use? I don't think so, but let me know if I am overlooking something.

Hmm, you probably want the list part of a graph_obj since you need to link the
links (so to speak) in a list. I'm not sure if you need unique IDs for a link
object, but it doesn't hurt either. Just ignore my comments about using the
graph_obj in media_link.

Regards,

	Hans
