Return-path: <linux-media-owner@vger.kernel.org>
Received: from aer-iport-1.cisco.com ([173.38.203.51]:50093 "EHLO
	aer-iport-1.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964833AbbHKNfF (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 11 Aug 2015 09:35:05 -0400
Message-ID: <55C9F97E.7070601@cisco.com>
Date: Tue, 11 Aug 2015 15:32:46 +0200
From: Hans Verkuil <hansverk@cisco.com>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Kukjin Kim <kgene@kernel.org>,
	Krzysztof Kozlowski <k.kozlowski@samsung.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Arnd Bergmann <arnd@arndb.de>,
	Dan Carpenter <dan.carpenter@oracle.com>,
	Tina Ruchandani <ruchandani.tina@gmail.com>,
	Akihiro Tsukada <tskd08@gmail.com>,
	Antti Palosaari <crope@iki.fi>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Prabhakar Lad <prabhakar.csengg@gmail.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Boris BREZILLON <boris.brezillon@free-electrons.com>,
	Lars-Peter Clausen <lars@metafoo.de>,
	Markus Elfring <elfring@users.sourceforge.net>,
	linux-arm-kernel@lists.infradead.org,
	linux-samsung-soc@vger.kernel.org, devel@driverdev.osuosl.org
Subject: Re: [PATCH RFC v2 09/16] media: use media_graph_obj for link endpoints
References: <cover.1439292977.git.mchehab@osg.samsung.com>	<6d02794028ea4f7ad33e3ba0e07e0c690e2feee2.1439292977.git.mchehab@osg.samsung.com>	<55C9E9AE.5020602@cisco.com> <20150811102201.5abaf64d@recife.lan>
In-Reply-To: <20150811102201.5abaf64d@recife.lan>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

>>> diff --git a/include/media/media-entity.h b/include/media/media-entity.h
>>> index 403019035424..f6e2136480f1 100644
>>> --- a/include/media/media-entity.h
>>> +++ b/include/media/media-entity.h
>>> @@ -43,6 +43,17 @@ enum media_graph_type {
>>>  	MEDIA_GRAPH_LINK,
>>>  };
>>>  
>>> +/**
>>> + * enum media_graph_link_dir - direction of a link
>>> + *
>>> + * @MEDIA_LINK_DIR_BIDIRECTIONAL	Link is bidirectional
>>> + * @MEDIA_LINK_DIR_PAD_0_TO_1		Link is unidirectional,
>>> + *					from port 0 (source) to port 1 (sink)
>>> + */
>>> +enum media_graph_link_dir {
>>> +	MEDIA_LINK_DIR_BIDIRECTIONAL,
>>> +	MEDIA_LINK_DIR_PORT0_TO_PORT1,
>>> +};
>>
>> 1) the comment and the actual enum are out-of-sync
> 
> Ah, yes. I was in doubt about using PAD or PORT here. I ended by using
> port at the links, as the endpoints can either be an interface/entity
> or a pad. So, I decided to use port.

It's either bi-directional (between interface and entity) or directional
(between two pads), so I think PAD is better here. We don't use the term
port anywhere else in the MC, so I think it is a bit confusing to
introduce a new name here.

> 
>> 2) why not just make a 'BIRECTIONAL' link flag instead of inventing
>>    a new enum? Adding yet another field seems overkill to me. Have a
>>    'BIDIRECTIONAL' flag seems perfectly OK to me (and useful for the
>>    application as well).
> 
> Yeah, we can use flags, instead. I decided to use an enum here just
> to make it clearer about the two possible options.
> 
> I was actually considering to rename media_link source/sink to
> port0/port1, as using "source"/"sink" names on a bidirection link
> doesn't make sense. I'm still in doubt about such rename, though,
> as it would make harder to inspect the graph traversal routines.

Right. I really wouldn't rename it. As suggested below using an
anonymous union would allow you to create proper names.

> Also, I want to force all places that create a link to choose
> between either BIRECTIONAL or PORT0_TO_PORT1, as this makes easier
> to review if the code is doing the right thing when inspecting it.

By creating two different functions? I think that would be very useful.
E.g. make_pad_link() and make_intf_to_ent_link() or something like
that. That would also hide the link direction. I still prefer a flag,
though :-) That's mostly personal preference, though.

> 
> In summary, I would prefer to keep this internally as a separate
>  enum, at least for now. We can latter simplify it and use a flag
> for that (or maybe two flags?).
> 
>>
>>>  
>>>  /* Structs to represent the objects that belong to a media graph */
>>>  
>>> @@ -72,9 +83,9 @@ struct media_pipeline {
>>>  
>>>  struct media_link {
>>>  	struct list_head list;
>>> -	struct media_graph_obj			graph_obj;
>>> -	struct media_pad *source;	/* Source pad */
>>> -	struct media_pad *sink;		/* Sink pad  */
>>> +	struct media_graph_obj		graph_obj;
>>> +	enum media_graph_link_dir	dir;
>>> +	struct media_graph_obj		*source, *sink;
>>
>> I'm not too keen about all the gobj_to_foo(obj) macros that this requires. It
>> is rather ugly code.
>>
>> What about this:
>>
>> 	union {
>> 		struct media_graph_obj *source;
>> 		struct media_pad *source_pad;
>> 		struct media_interface *source_intf;
>> 	};
>> 	union {
>> 		struct media_graph_obj *sink;
>> 		struct media_pad *sink_pad;
>> 		struct media_entity *sink_ent;
>> 	};
>>
>> Now the code can just use ->source_pad etc.
> 
> good idea. Will do that on a version 3. I think that, in this case, the
> best is to write a note that the first element at pad/entity/interface
> should be the graph_obj.
> 
> I would actually call port0_intf and port1_ent on the above structs,
> as it makes no sense to call sink/source for interface->entity links.

How about this:

 	union {
 		struct media_graph_obj *port0;
 		struct media_interface *port0_intf;	// perhaps just intf or interface?
 		struct media_pad *source;
 	};
 	union {
 		struct media_graph_obj *port1;
 		struct media_entity *port1_ent;	// perhaps just ent or entity?
 		struct media_pad *sink;
 	};

This has the advantage that the source/sink pads are still called source and
sink and you don't have to rename the existing code.

Regards,

	Hans
