Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:44426 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752947AbcBZNN4 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 26 Feb 2016 08:13:56 -0500
Subject: Re: [RFC] Representing hardware connections via MC
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	LMML <linux-media@vger.kernel.org>
References: <20160226091317.5a07c374@recife.lan>
From: Javier Martinez Canillas <javier@osg.samsung.com>
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
	Sakari Ailus <sakari.ailus@iki.fi>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Message-ID: <56D04F8C.5070400@osg.samsung.com>
Date: Fri, 26 Feb 2016 10:13:48 -0300
MIME-Version: 1.0
In-Reply-To: <20160226091317.5a07c374@recife.lan>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Mauro,

On 02/26/2016 09:13 AM, Mauro Carvalho Chehab wrote:
> We had some discussions on Feb, 12 about how to represent connectors via
> the Media Controller:
> 	https://linuxtv.org/irc/irclogger_log/v4l?date=2016-02-12,Fri&sel=31#l27
>
> We tried to finish those discussions on the last two weeks, but people
> doesn't seem to be available at the same time for the discussions. So,
> let's proceed with the discussions via e-mail.
>
> So, I'd like to do such discussions via e-mail, as we need to close
> this question next week.
>
> QUESTION:
> ========
>
> How to represent the hardware connection for inputs (and outputs) like:
> 	- Composite TV video;
> 	- stereo analog audio;
> 	- S-Video;
> 	- HDMI
>
> Problem description:
> ===================
>
> During the MC summit last year, we decided to add an entity called
> "connector" for such things. So, we added, so far, 3 types of
> connectors:
>
> #define MEDIA_ENT_F_CONN_RF		(MEDIA_ENT_F_BASE + 10001)
> #define MEDIA_ENT_F_CONN_SVIDEO		(MEDIA_ENT_F_BASE + 10002)
> #define MEDIA_ENT_F_CONN_COMPOSITE	(MEDIA_ENT_F_BASE + 10003)
>
> However, while implementing it, we saw that the mapping on hardware
> is actually more complex, as one physical connector may have multiple
> signals with can eventually used on a different way.
>
> One simple example of this is the S-Video connector. It has internally
> two video streams, one for chrominance and another one for luminance.
>
> It is very common for vendors to ship devices with a S-Video input
> and a "S-Video to RCA" cable.
>
> At the driver's level, drivers need to know if such cable is
> plugged, as they need to configure a different input setting to
> enable either S-Video or composite decoding.
>
> So, the V4L2 API usually maps "S-Video" on a different input
> than "Composite over S-Video". This can be seen, for example, at the
> saa7134 driver, who gained recently support for MC.
>
> Additionally, it is interesting to describe the physical aspects
> of the connector (color, position, label, etc).
>
> Proposal:
> ========
>
> It seems that there was an agreement that the physical aspects of
> the connector should be mapped via the upcoming properties API,
> with the properties present only when it is possible to find them
> in the hardware. So, it seems that all such properties should be
> optional.
>
> However, we didn't finish the meeting, as we ran out of time. Yet,
> I guess the last proposal there fulfills the requirements. So,
> let's focus our discussions on it. So, let me formulate it as a
> proposal
>

Thanks for writing down as a proposal what was discussed over IRC.
  
> We should represent the entities based on the inputs. So, for the
> already implemented entities, we'll have, instead:
>
> #define MEDIA_ENT_F_INPUT_RF		(MEDIA_ENT_F_BASE + 10001)
> #define MEDIA_ENT_F_INPUT_SVIDEO	(MEDIA_ENT_F_BASE + 10002)
> #define MEDIA_ENT_F_INPUT_COMPOSITE	(MEDIA_ENT_F_BASE + 10003)
>
> The MEDIA_ENT_F_INPUT_RF and MEDIA_ENT_F_INPUT_COMPOSITE will have
> just one sink PAD each, as they carry just one signal. As we're
> describing the logical input, it doesn't matter the physical
> connector type. So, except for re-naming the define, nothing
> changes for them.
>
> Devices with S-Video input will have one MEDIA_ENT_F_INPUT_SVIDEO
> per each different S-Video input. Each one will have two sink pads,
> one for the Y signal and another for the C signal.
>
> So, a device like Terratec AV350, that has one Composite and one
> S-Video input[1] would be represented as:
> 	https://mchehab.fedorapeople.org/terratec_av350-modified.png
>
>
> [1] Physically, it has a SCART connector that could be enabled
> via a physical switch, but logically, the device will still switch
> from S-Video over SCART or composite over SCART.
>
> More complex devices would be represented like:
> 	https://hverkuil.home.xs4all.nl/adv7604.png
> 	https://hverkuil.home.xs4all.nl/adv7842.png
>
> NOTE:
>
> The labels at the PADs currently can't be represented, but the
> idea is adding it as a property via the upcoming properties API.
>
> Anyone disagree?
>

What you described is what I understood that was the last proposal
and I believe everyone agreed that it was the way to move forward.

I've just one question, why the PAD's labels / symbolic names will
be added as a property instead of just having a name or label field
in struct media_pad?

For example, in the Terratec AV350 chip you mentioned, the AIP1{A,B}
source pads are real pins in the tvp5150 package and are documented
in the datasheet and a S-Video connector will always have a Y and C
sinks pads for the 2 signals and a Composite connector a single pad.

So why can't the driver just set those when creating the connectors
entities? Or maybe I'm misunderstanding how the properties API work.

> Regards,
> Mauro
>

Best regards,
-- 
Javier Martinez Canillas
Open Source Group
Samsung Research America
