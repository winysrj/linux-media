Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:44486 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754324AbcBZNsW (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 26 Feb 2016 08:48:22 -0500
Date: Fri, 26 Feb 2016 10:48:16 -0300
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Javier Martinez Canillas <javier@osg.samsung.com>
Cc: LMML <linux-media@vger.kernel.org>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Sakari Ailus <sakari.ailus@iki.fi>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: Re: [RFC] Representing hardware connections via MC
Message-ID: <20160226104816.4e7784fe@recife.lan>
In-Reply-To: <56D04F8C.5070400@osg.samsung.com>
References: <20160226091317.5a07c374@recife.lan>
	<56D04F8C.5070400@osg.samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Fri, 26 Feb 2016 10:13:48 -0300
Javier Martinez Canillas <javier@osg.samsung.com> escreveu:

> Hello Mauro,
> 
> On 02/26/2016 09:13 AM, Mauro Carvalho Chehab wrote:
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
> 
> Thanks for writing down as a proposal what was discussed over IRC.
>   
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
> >
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
> >
> > Anyone disagree?
> >  
> 
> What you described is what I understood that was the last proposal
> and I believe everyone agreed that it was the way to move forward.
> 
> I've just one question, why the PAD's labels / symbolic names will
> be added as a property instead of just having a name or label field
> in struct media_pad?
> 
> For example, in the Terratec AV350 chip you mentioned, the AIP1{A,B}
> source pads are real pins in the tvp5150 package and are documented
> in the datasheet and a S-Video connector will always have a Y and C
> sinks pads for the 2 signals and a Composite connector a single pad.
> 
> So why can't the driver just set those when creating the connectors
> entities? Or maybe I'm misunderstanding how the properties API work.

Well, we could add a "label" to pads, but not all pads need it.
Adding optional fields to the structs will increase their size
for all PADs, even for the ones that won't need it. That's
even worse for labels, as we would spend something like 32 or
64 bytes for it.

The idea behind the properties API is to allow adding extra
fields to graph objects. Once we add it, the driver could fill the
labels where this is needed, without spending memory for the
graph objects that won't need.

OK, we need to see the actual patches for it. Sakari has been
working on it, but I've no idea if he has some patches to
submit for us to review, even as RFC, but he did a proposal
for it last year:
	https://www.spinics.net/lists/linux-media/msg90160.html

In this sense, on a device like:
	http://terratec.ultron.info/Video/Grabster/GrabsterAV250MX/Images/Grabster_AV_250_MX_L.jpg

We would represent the properties via the properties API with:

"entity": {
	"id": 1,
	"label": "S-Video",
	"color": "black",
	"connector": "4-pin mini-DIN"
}

"entity": {
	"id": 2,
	"label": "Composite",
	"color": "yellow",
	"connector": "RCA"
}

"pad": {
	"id": 3,
	"label": "A1P1A",
}

"pad": {
	"id": 4,
	"label": "A1P1B",
}

Representing the audio input (we would need a new entity function
for it) would be something like:

"entity": {
	"id": 5,
	"label": "Audio"
	"channels": 2
}

"pad": {
	"id": 6,
	"label": "L",
	"color" : "white",
	"connector": "RCA"
}

"pad": {
	"id": 7,
	"label": "R"
	"color" : "red",
	"connector": "RCA"
}


Please notice that we don't need to agree yet about the properties
API definitions, as this is a separate discussion that may be
required after we start discussing the properties API patchset,
after its submission.

-- 
Thanks,
Mauro
