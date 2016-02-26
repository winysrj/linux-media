Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:44505 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751449AbcBZOBB (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 26 Feb 2016 09:01:01 -0500
Date: Fri, 26 Feb 2016 11:00:55 -0300
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: LMML <linux-media@vger.kernel.org>,
	Sakari Ailus <sakari.ailus@iki.fi>,
	Javier Martinez Canillas <javier@osg.samsung.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: Re: [RFC] Representing hardware connections via MC
Message-ID: <20160226110055.2acf936f@recife.lan>
In-Reply-To: <56D051DC.5070900@xs4all.nl>
References: <20160226091317.5a07c374@recife.lan>
	<56D051DC.5070900@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Fri, 26 Feb 2016 14:23:40 +0100
Hans Verkuil <hverkuil@xs4all.nl> escreveu:

> On 02/26/2016 01:13 PM, Mauro Carvalho Chehab wrote:
> > We had some discussions on Feb, 12 about how to represent connectors via
> > the Media Controller:
> > 	https://linuxtv.org/irc/irclogger_log/v4l?date=2016-02-12,Fri&sel=31#l27
> > 
> > We tried to finish those discussions on the last two weeks, but people
> > doesn't seem to be available at the same time for the discussions. So,
> > let's proceed with the discussions via e-mail.
> > 
> > So, I'd like to do such discussions via e-mail, as we need to close
> > this question next week.
> > 
> > QUESTION:
> > ========
> > 
> > How to represent the hardware connection for inputs (and outputs) like:
> > 	- Composite TV video;
> > 	- stereo analog audio;
> > 	- S-Video;
> > 	- HDMI
> > 
> > Problem description:
> > ===================
> > 
> > During the MC summit last year, we decided to add an entity called
> > "connector" for such things. So, we added, so far, 3 types of
> > connectors:
> > 
> > #define MEDIA_ENT_F_CONN_RF		(MEDIA_ENT_F_BASE + 10001)
> > #define MEDIA_ENT_F_CONN_SVIDEO		(MEDIA_ENT_F_BASE + 10002)
> > #define MEDIA_ENT_F_CONN_COMPOSITE	(MEDIA_ENT_F_BASE + 10003)
> > 
> > However, while implementing it, we saw that the mapping on hardware
> > is actually more complex, as one physical connector may have multiple
> > signals with can eventually used on a different way.
> > 
> > One simple example of this is the S-Video connector. It has internally
> > two video streams, one for chrominance and another one for luminance.
> > 
> > It is very common for vendors to ship devices with a S-Video input
> > and a "S-Video to RCA" cable.
> > 
> > At the driver's level, drivers need to know if such cable is
> > plugged, as they need to configure a different input setting to
> > enable either S-Video or composite decoding.
> > 
> > So, the V4L2 API usually maps "S-Video" on a different input
> > than "Composite over S-Video". This can be seen, for example, at the
> > saa7134 driver, who gained recently support for MC.
> > 
> > Additionally, it is interesting to describe the physical aspects
> > of the connector (color, position, label, etc).
> > 
> > Proposal:
> > ========
> > 
> > It seems that there was an agreement that the physical aspects of
> > the connector should be mapped via the upcoming properties API,
> > with the properties present only when it is possible to find them
> > in the hardware. So, it seems that all such properties should be
> > optional.
> > 
> > However, we didn't finish the meeting, as we ran out of time. Yet,
> > I guess the last proposal there fulfills the requirements. So,
> > let's focus our discussions on it. So, let me formulate it as a
> > proposal
> > 
> > We should represent the entities based on the inputs. So, for the
> > already implemented entities, we'll have, instead:
> > 
> > #define MEDIA_ENT_F_INPUT_RF		(MEDIA_ENT_F_BASE + 10001)
> > #define MEDIA_ENT_F_INPUT_SVIDEO	(MEDIA_ENT_F_BASE + 10002)
> > #define MEDIA_ENT_F_INPUT_COMPOSITE	(MEDIA_ENT_F_BASE + 10003)
> > 
> > The MEDIA_ENT_F_INPUT_RF and MEDIA_ENT_F_INPUT_COMPOSITE will have
> > just one sink PAD each, as they carry just one signal. As we're
> > describing the logical input, it doesn't matter the physical
> > connector type. So, except for re-naming the define, nothing
> > changes for them.  
> 
> What if my device has an SVIDEO output (e.g. ivtv)? 'INPUT' denotes
> the direction, and I don't think that's something you want in the
> define for the connector entity.
> 
> As was discussed on irc we are really talking about signals received
> or transmitted by/from a connector. I still prefer F_SIG_ or F_SIGNAL_
> or F_CONN_SIG_ or something along those lines.
> 
> I'm not sure where F_INPUT came from, certainly not from the irc
> discussion.

Well, the idea of "F_CONN_SIG" came when we were talking about
representing each signal, and not the hole thing.

I think using it would be a little bit misleading, but I'm OK
with that, provided that we make clear that a MEDIA_ENT_F_CONN_SIG_SVIDEO
should contain two pads, one for each signal.

> 
> > Devices with S-Video input will have one MEDIA_ENT_F_INPUT_SVIDEO
> > per each different S-Video input. Each one will have two sink pads,
> > one for the Y signal and another for the C signal.
> > 
> > So, a device like Terratec AV350, that has one Composite and one
> > S-Video input[1] would be represented as:
> > 	https://mchehab.fedorapeople.org/terratec_av350-modified.png
> > 
> > 
> > [1] Physically, it has a SCART connector that could be enabled
> > via a physical switch, but logically, the device will still switch
> > from S-Video over SCART or composite over SCART.
> > 
> > More complex devices would be represented like:
> > 	https://hverkuil.home.xs4all.nl/adv7604.png
> > 	https://hverkuil.home.xs4all.nl/adv7842.png
> > 
> > NOTE:
> > 
> > The labels at the PADs currently can't be represented, but the
> > idea is adding it as a property via the upcoming properties API.  
> 
> I think this is a separate discussion. It's not needed for now.

Agreed.

> When working on the adv7604/7842 examples I realized that pad names help
> understand the topology a lot better, but they are not needed for the actual
> functionality.

Yes. PAD names help a lot when someone needs to view the topology as
a graph. It could also be useful when the driver needs to do the
connections themselves (for example, connecting VBI and VIDEO pads
on a tv demux).

Yet, this is a separate discussion, to be done when we add the 
properties API.

> 
> > 
> > Anyone disagree?  
> 
> I agree except for the naming.
> 
> Regards,
> 
> 	Hans


-- 
Thanks,
Mauro
