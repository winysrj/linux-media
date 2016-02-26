Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud3.xs4all.net ([194.109.24.26]:55189 "EHLO
	lb2-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750922AbcBZOHi (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 26 Feb 2016 09:07:38 -0500
Subject: Re: [RFC] Representing hardware connections via MC
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
References: <20160226091317.5a07c374@recife.lan> <56D051DC.5070900@xs4all.nl>
 <20160226110055.2acf936f@recife.lan>
Cc: LMML <linux-media@vger.kernel.org>,
	Sakari Ailus <sakari.ailus@iki.fi>,
	Javier Martinez Canillas <javier@osg.samsung.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <56D05C25.60605@xs4all.nl>
Date: Fri, 26 Feb 2016 15:07:33 +0100
MIME-Version: 1.0
In-Reply-To: <20160226110055.2acf936f@recife.lan>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 02/26/2016 03:00 PM, Mauro Carvalho Chehab wrote:
> Em Fri, 26 Feb 2016 14:23:40 +0100
> Hans Verkuil <hverkuil@xs4all.nl> escreveu:
> 
>> On 02/26/2016 01:13 PM, Mauro Carvalho Chehab wrote:
>>> We had some discussions on Feb, 12 about how to represent connectors via
>>> the Media Controller:
>>> 	https://linuxtv.org/irc/irclogger_log/v4l?date=2016-02-12,Fri&sel=31#l27
>>>
>>> We tried to finish those discussions on the last two weeks, but people
>>> doesn't seem to be available at the same time for the discussions. So,
>>> let's proceed with the discussions via e-mail.
>>>
>>> So, I'd like to do such discussions via e-mail, as we need to close
>>> this question next week.
>>>
>>> QUESTION:
>>> ========
>>>
>>> How to represent the hardware connection for inputs (and outputs) like:
>>> 	- Composite TV video;
>>> 	- stereo analog audio;
>>> 	- S-Video;
>>> 	- HDMI
>>>
>>> Problem description:
>>> ===================
>>>
>>> During the MC summit last year, we decided to add an entity called
>>> "connector" for such things. So, we added, so far, 3 types of
>>> connectors:
>>>
>>> #define MEDIA_ENT_F_CONN_RF		(MEDIA_ENT_F_BASE + 10001)
>>> #define MEDIA_ENT_F_CONN_SVIDEO		(MEDIA_ENT_F_BASE + 10002)
>>> #define MEDIA_ENT_F_CONN_COMPOSITE	(MEDIA_ENT_F_BASE + 10003)
>>>
>>> However, while implementing it, we saw that the mapping on hardware
>>> is actually more complex, as one physical connector may have multiple
>>> signals with can eventually used on a different way.
>>>
>>> One simple example of this is the S-Video connector. It has internally
>>> two video streams, one for chrominance and another one for luminance.
>>>
>>> It is very common for vendors to ship devices with a S-Video input
>>> and a "S-Video to RCA" cable.
>>>
>>> At the driver's level, drivers need to know if such cable is
>>> plugged, as they need to configure a different input setting to
>>> enable either S-Video or composite decoding.
>>>
>>> So, the V4L2 API usually maps "S-Video" on a different input
>>> than "Composite over S-Video". This can be seen, for example, at the
>>> saa7134 driver, who gained recently support for MC.
>>>
>>> Additionally, it is interesting to describe the physical aspects
>>> of the connector (color, position, label, etc).
>>>
>>> Proposal:
>>> ========
>>>
>>> It seems that there was an agreement that the physical aspects of
>>> the connector should be mapped via the upcoming properties API,
>>> with the properties present only when it is possible to find them
>>> in the hardware. So, it seems that all such properties should be
>>> optional.
>>>
>>> However, we didn't finish the meeting, as we ran out of time. Yet,
>>> I guess the last proposal there fulfills the requirements. So,
>>> let's focus our discussions on it. So, let me formulate it as a
>>> proposal
>>>
>>> We should represent the entities based on the inputs. So, for the
>>> already implemented entities, we'll have, instead:
>>>
>>> #define MEDIA_ENT_F_INPUT_RF		(MEDIA_ENT_F_BASE + 10001)
>>> #define MEDIA_ENT_F_INPUT_SVIDEO	(MEDIA_ENT_F_BASE + 10002)
>>> #define MEDIA_ENT_F_INPUT_COMPOSITE	(MEDIA_ENT_F_BASE + 10003)
>>>
>>> The MEDIA_ENT_F_INPUT_RF and MEDIA_ENT_F_INPUT_COMPOSITE will have
>>> just one sink PAD each, as they carry just one signal. As we're
>>> describing the logical input, it doesn't matter the physical
>>> connector type. So, except for re-naming the define, nothing
>>> changes for them.  
>>
>> What if my device has an SVIDEO output (e.g. ivtv)? 'INPUT' denotes
>> the direction, and I don't think that's something you want in the
>> define for the connector entity.
>>
>> As was discussed on irc we are really talking about signals received
>> or transmitted by/from a connector. I still prefer F_SIG_ or F_SIGNAL_
>> or F_CONN_SIG_ or something along those lines.
>>
>> I'm not sure where F_INPUT came from, certainly not from the irc
>> discussion.
> 
> Well, the idea of "F_CONN_SIG" came when we were talking about
> representing each signal, and not the hole thing.
> 
> I think using it would be a little bit misleading, but I'm OK
> with that, provided that we make clear that a MEDIA_ENT_F_CONN_SIG_SVIDEO
> should contain two pads, one for each signal.

I hate naming discussions :-)

It's certainly not F_INPUT since, well, there are outputs too :-)

And you are right that the signal idea was abandoned later in the discussion.
I'd forgotten about that. Basically the different signals are now represented
as pads (TMDS and CEC for example).

I think F_CONN_ isn't such a bad name after all.

Regards,

	Hans
