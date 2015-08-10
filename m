Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud3.xs4all.net ([194.109.24.30]:45496 "EHLO
	lb3-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752998AbbHJNo2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 10 Aug 2015 09:44:28 -0400
Message-ID: <55C8AAA0.9030407@xs4all.nl>
Date: Mon, 10 Aug 2015 15:44:00 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
CC: media-workshop@linuxtv.org, linux-media@vger.kernel.org
Subject: Re: [media-workshop] [RFC] Media graph flow for an hybrid device
 as discussed at the media workshop
References: <20150808083330.7daf111f@recife.lan>	<55C89C86.2070707@xs4all.nl>	<20150810100524.09fb089f@recife.lan> <20150810101936.238ad3f7@recife.lan>
In-Reply-To: <20150810101936.238ad3f7@recife.lan>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 08/10/2015 03:19 PM, Mauro Carvalho Chehab wrote:
> Em Mon, 10 Aug 2015 10:05:24 -0300
> Mauro Carvalho Chehab <mchehab@osg.samsung.com> escreveu:
> 
>> Em Mon, 10 Aug 2015 14:43:50 +0200
>> Hans Verkuil <hverkuil@xs4all.nl> escreveu:
>>
>>> Hi Mauro,
>>
>> Thanks for the review!
>>
>>>
>>> On 08/08/2015 01:33 PM, Mauro Carvalho Chehab wrote:
>>>> During the discussions at the Media Workshop, we came with some dot files that
>>>> would describe a hybrid PC-consumer TV stick with radio, analog video, analog
>>>> TV and digital TV on it.
>>>>
>>>> I consolidated all the dot files we've worked there, and added the
>>>> connectors for RF, S-Video and Composite.
>>>>
>>>> The dot file and the corresponding picture is at:
>>>> 	http://linuxtv.org/downloads/presentations/mc_ws_2015/dvb-pipeline-v2.dot
>>>> 	http://linuxtv.org/downloads/presentations/mc_ws_2015/dvb-pipeline-v2.png
>>>>
>>>> As my plan is to start working on some real driver to produce such graph,
>>>> please validate if the entities, interfaces, data links and interface links
>>>> are correct, and if the namespace nomenclature is ok, or if I miss something.
>>>
>>> This looks OK to me, except for one small detail: I wouldn't use the name
>>> "Source entities" for connectors. Instead use "Connector entities" since
>>> such entities correspond to actual real connectors on a backplane. 
>>
>> Yeah. Well, they're actually "Source connector entities" ;) But I see
>> your point. All connectors should be marked with a different type at
>> the media_graph_obj.
>>
>>> A proper
>>> source entity would be a sensor or test pattern generator. Which actually
>>> can occur with the em28xx since it's used in webcams as well.
>>
>> Ah, true. I'll add that in the graph and use a different color to
>> distinguish between "source" and "connector" entities.
>>
>>>
>>> And a really, really small detail: in the legend the 'interface link' is an
>>> arrow, but it should be a line, since there is no direction. The graph itself
>>> is fine.
>>
>> Well, I didn't find a way to put a line there. The legend is produced by
>> an html code. I would need to have a "line" character, or to add an image.
>>
>> Perhaps I should look deeper to find a bold horizontal line at the UTF-8
>> charset. &#8212; and &#8213; are too thin. Do you know any char that would
>> look better there?
> 
> Found one character ;)
> 
> I also added a webcam sensor and fixed the legend. See below:
> 
> http://linuxtv.org/downloads/presentations/mc_ws_2015/dvb-pipeline-v3.png
> http://linuxtv.org/downloads/presentations/mc_ws_2015/dvb-pipeline-v3.dot

Looks good. But if you have a sensor, then there should also be a v4l-subdev2
interface for the sensor entity, and it is also controlled by video0, so that
interface-to-entity link is missing.

And the saa7115 output pads need to be renumbered to 4-6 (there are two pads '3'
at the moment and the mixer is linked to the input pad 3).

Regards,

	Hans

> 
>>
>>> As you mentioned on irc, the v4l-subdevX nodes won't be created for this device
>>> since all the configuration happens via the standard interfaces.
>>>
>>> But if they were to be created, then they would appear where they are in this
>>> example.
>>
>> Thanks!
>> Mauro
>>
>>>
>>> Regards,
>>>
>>> 	Hans
>>>
>>> _______________________________________________
>>> media-workshop mailing list
>>> media-workshop@linuxtv.org
>>> http://www.linuxtv.org/cgi-bin/mailman/listinfo/media-workshop
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

