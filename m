Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:45731 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751085AbcCBKep (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 2 Mar 2016 05:34:45 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: LMML <linux-media@vger.kernel.org>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Sakari Ailus <sakari.ailus@iki.fi>,
	Javier Martinez Canillas <javier@osg.samsung.com>
Subject: Re: [RFC] Representing hardware connections via MC
Date: Wed, 02 Mar 2016 12:34:42 +0200
Message-ID: <1753279.MBUKgSvGQl@avalon>
In-Reply-To: <20160226091317.5a07c374@recife.lan>
References: <20160226091317.5a07c374@recife.lan>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

Thank you for the summary.

On Friday 26 February 2016 09:13:17 Mauro Carvalho Chehab wrote:
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
> in the hardware.

Agreed for most of them, I'm still unsure about the connector type, but that's 
probably a detail.

> So, it seems that all such properties should be optional.
> 
> However, we didn't finish the meeting, as we ran out of time. Yet,
> I guess the last proposal there fulfills the requirements. So,
> let's focus our discussions on it. So, let me formulate it as a
> proposal
> 
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

Whether to add labels to pads, and more generically how to differentiate them 
from userspace, is an interesting question. I'd like to decouple it from the 
connectors entities discussion if possible, in such a way that using labels 
wouldn't be required to leave the discussion open on that topic. If we foresee 
a dependency on labels for pads then we should open that discussion now.

> Anyone disagree?

I'll reply one of the later mails in this thread in a minute about this to 
capture Javier and Hans' inputs.

-- 
Regards,

Laurent Pinchart

