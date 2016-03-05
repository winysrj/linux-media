Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:36471 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752649AbcCEOSg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 5 Mar 2016 09:18:36 -0500
Date: Sat, 5 Mar 2016 11:18:30 -0300
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Sakari Ailus <sakari.ailus@iki.fi>,
	LMML <linux-media@vger.kernel.org>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Javier Martinez Canillas <javier@osg.samsung.com>
Subject: Re: [RFC] Representing hardware connections via MC
Message-ID: <20160305111830.5106aef4@recife.lan>
In-Reply-To: <1778959.zqGoLXbLC1@avalon>
References: <20160226091317.5a07c374@recife.lan>
 <20160302141643.GH11084@valkosipuli.retiisi.org.uk>
 <20160302124029.0e6cee85@recife.lan>
 <1778959.zqGoLXbLC1@avalon>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Thu, 03 Mar 2016 00:58:31 +0200
Laurent Pinchart <laurent.pinchart@ideasonboard.com> escreveu:

> Hi Mauro,
> 
> (Disclaimer: There are lots of thoughts in this e-mail, sometimes in a bit of 
> a random order. I would thus recommend reading through it completely before 
> starting to write a reply.)
> 
> On Wednesday 02 March 2016 12:40:29 Mauro Carvalho Chehab wrote:
> > Em Wed, 02 Mar 2016 16:16:43 +0200 Sakari Ailus escreveu:  
> > > On Fri, Feb 26, 2016 at 09:13:17AM -0300, Mauro Carvalho Chehab wrote:  
> > >> We had some discussions on Feb, 12 about how to represent connectors via
> > >> the Media Controller:
> > >> 	  
> https://linuxtv.org/irc/irclogger_log/v4l?date=2016-02-12,Fri&sel=31#l27
> > >> 
> > >> We tried to finish those discussions on the last two weeks, but people
> > >> doesn't seem to be available at the same time for the discussions. So,
> > >> let's proceed with the discussions via e-mail.
> > >> 
> > >> So, I'd like to do such discussions via e-mail, as we need to close
> > >> this question next week.  
> > > 
> > > While I agree that we shouldn't waste time in designing new APIs, we also
> > > musn't merge unfinished work, and especially not when it comes to user
> > > space APIs. Rather, we have to come up with a sound user space API/ABI
> > > and *then* get it to mainline and *not* the other way around.  
> > 
> > Well, we've agreed with connectors during the MC workshop in August,
> > 2015.
> > 
> > The problem is that, when mapping the connectors on a particular
> > driver (saa7134), we noticed that things are not so simple, because
> > of the way it implements S-Video.  
> 
> I couldn't have said better :-) We've agreed on a design idea during the 
> workshop, and now that we're finally trying to put it into use we notice it 
> can't work due to issues we hadn't foreseen. There's nothing new under the 
> sun, this happens all the time during development, it just highlights the 
> importance of really testing designs (and I'd even argue that this is only the 
> visible part of the iceberg, we're testing the design by trying to apply it 
> manually to a couple of existing hardware platforms, but haven't started 
> testing it with real userspace applications).
> 
> So, in my opinion, the bottom line is that we should not slow down but keep 
> refining the design until we achieve a stable and sound result. That's a 
> methodology that we've applied so far with mostly good results.

Sure, but, IMHO, we should focus on solving the current problem (S-video),
as the HDMI problem will happen only when someone tries to map it 
via the API.

> 
> > > I just read the IRC discussion beginning from when I needed to leave, and
> > > it looks like to me that we need to have a common understanding of the
> > > relevant concepts before we can even reach a common understanding what is
> > > being discussed. I'm not certain we're even at that level yet.
> > > 
> > > Besides that, concepts should not be mixed. Things such as
> > > MEDIA_ENT_F_CONN_SVIDEO should not exist, as it suggests that there's an
> > > S-video connector (which doesn't really exist). The signal is S-video and
> > > the connector is variable, but often RCA.  
> > 
> > Well, "CONN" can be an alias for "connection", with is what we're actually
> > representing.  
> 
> Now I really second Sakari's request, if you've understood F_CONN as 
> F_CONNECTION and I as F_CONNECTOR, then we really need to define the terms 
> we're using.

It was originally proposed as "connector", but we're actually talking about
connections, as one entity may have multiple physical connectors (as in the
(d) scenario you described below). Also, "connector" is linked to the
endpoint of a piggyback cable. Some devices have different piggyback
cables, with would be really hard to map, as usually there's no way to
discover what kind of cable it was connected on given moment in time.

> > "Signal" is something else. As discussed, a single S-Video connection has 2
> > signals: Y and C.
> >   
> > > At least connector, input (and output I presume?) and signal need to be
> > > defined. My problem with terms such as input and output at this level of
> > > the API is that they're really generic terms, and we chose not to use
> > > them in MC in the past exactly for that reason.  
> > 
> > After all the discussions, I guess "CONN" for connection is the best way
> > to represent it.  
> 
> How do you define a connection ?

See my patch:
	https://patchwork.linuxtv.org/patch/33287/

I guess connection is well defined there, but basically it is the
logical representation of the connection point to external devices.
Physically, a connection can have one or more connectors.

> 
> > > For instance, luminance and chrominance certainly are signals, but is
> > > S-video a signal as well? I'd say so.  
> > 
> > No. S-video has 2 signals only: luminace and chrominance. Nothing else.  
> 
> For analog video we could define signal in the electrical sense, as a voltage 
> or current carries over a wire or trace. S-Video would then have two signals, 
> composite a single one, and component video three. A connector could have one 
> pad per signal if we use that definition.
> 
> That definition is harder to apply to digital video though.

Well, even in digital world, the word "signal" has the same definition:
it is still an electrical signal, carried though a wire.

> I don't think we 
> should model an HDMI connector with one pad for each electrical signal. Should 
> we avoid using the word signal for digital video then, or give it a different 
> meaning ?

I don't mind grouping the signals. For example, in DVB side, DTV demods
can either output data in parallel or in serial. We should still represent
the data via one PAD, as there's no sense at all to map it as 8 parallel
PADs.

So, IMHO, an DVI input could be mapped as an entity with 2 pads:
	- DVI-A (mapping the signals inside the analog pins)
	- DVI-I (mapping the signals on the digital pins)

(and, eventually, DDC, if ever needed - but this is probably overkill)

> 
> I'm lacking a good term other than video signal to describe one or multiple 
> electrical signals that together carry an analog video stream, such as the Y+C 
> combination in S-Video or the R+G+B combination in component video. I'll use 
> video signal for such that purpose in the rest of this e-mail, but please feel 
> free to propose a better term.

Heh, finding a word to describe those is hard ;) That's why I think
the "connection" word can fit in.

> 
> > > But should we make a difference between the two?  
> > 
> > For S-Video, we may not need to represent two pads.  
> 
> Unless I'm mistaken, that's one of the fundamental questions we've been trying 
> to answer through our discussions on this topic. And I really think we should 
> answer it, it's the core of the problem we're trying to solve.

No, this is not the problem. I really don't mind if we use one or two pads
for S-Video. The problem is:
	how to map composite over the S-Video connector

On saa7134 (as on other drivers), this is a different input
configuration than Composite or S-Video inside its harware
audio/video mux (and it requires an extra piggyback cable to
"convert" from RCA to 4-pin miniDIN).

If we map by physical connectors, we won't be able to properly map the
audio/video mux setup. As Hans said, on ENUM_INPUT & friends, we map
since the beginning per input (what I call here as "connection"), and
moving to something else is a big NACK, as it will break things
(except if one can prove it will work for all existing cases).

So, in the case where a S-Video connector can support both S-Video
and composite inputs, this should map as two separate "connections":
	- a S-Video connection
	- a Composite over S-Video connection

That is the agreement we're trying to achieve right now.

> > For HDMI, for sure we'll need to represent multiple signals, as they're
> > routed on a different way (CEC, for example is a bus, that can be connected
> > to multiple HDMI inputs and outputs).  
> 
> Yes, CEC is an odd beast, and I'm not sure exactly how it should be handled. 
> We have to draw the line and decide what we want to include in the graph and 
> we we want to leave out. While I would I think be inclined to include CEC, I 
> currently think DDC shouldn't be represented, but that's obviously open for 
> discussions.

I agree with you: on a first glance, it seems to make sense to map CEC,
and not map DDC, but the best is to wait for someone actually map a
complex hdmi hardware. Such person will have better arguments about how
it should be mapped and why.

> Let's not forget that we currently have no bus-type links in MC, 
> all the links we've used so far are unidirectional. We'll have to find out how 
> to represent CEC or other similar buses (I2S is another example).

I don't see a big issue here, but you're right: this is another point
to be discussed for CEC.

We do have some I2S cases at the analog TV side, but, thankfully,
we can represent them as unidirectional, as they're used to send
audio from the audio demod (usually msp34xx) to the bridge chipset.

> 
> > > Connectors are easy, everyone knows what they are. Having
> > > read the meeting IRC log, I guess the word "input" was likely used to
> > > refer signals transmitted over multiple physical wires, at least some of
> > > the time. I'd prefer not to guess.
> > >   
> > >> QUESTION:
> > >> ========
> > >> 
> > >> How to represent the hardware connection for inputs (and outputs) like:
> > >> 	- Composite TV video;
> > >> 	- stereo analog audio;
> > >> 	- S-Video;
> > >> 	- HDMI
> > >> 
> > >> Problem description:
> > >> ===================
> > >> 
> > >> During the MC summit last year, we decided to add an entity called
> > >> "connector" for such things. So, we added, so far, 3 types of
> > >> connectors:
> > >> 
> > >> #define MEDIA_ENT_F_CONN_RF		(MEDIA_ENT_F_BASE + 10001)
> > >> #define MEDIA_ENT_F_CONN_SVIDEO		(MEDIA_ENT_F_BASE + 10002)
> > >> #define MEDIA_ENT_F_CONN_COMPOSITE	(MEDIA_ENT_F_BASE + 10003)
> > >> 
> > >> However, while implementing it, we saw that the mapping on hardware
> > >> is actually more complex, as one physical connector may have multiple
> > >> signals with can eventually used on a different way.
> > >> 
> > >> One simple example of this is the S-Video connector. It has internally
> > >> two video streams, one for chrominance and another one for luminance.
> > >> 
> > >> It is very common for vendors to ship devices with a S-Video input
> > >> and a "S-Video to RCA" cable.
> > >> 
> > >> At the driver's level, drivers need to know if such cable is
> > >> plugged, as they need to configure a different input setting to
> > >> enable either S-Video or composite decoding.
> > >> 
> > >> So, the V4L2 API usually maps "S-Video" on a different input
> > >> than "Composite over S-Video". This can be seen, for example, at the
> > >> saa7134 driver, who gained recently support for MC.
> > >> 
> > >> Additionally, it is interesting to describe the physical aspects
> > >> of the connector (color, position, label, etc).
> > >> 
> > >> Proposal:
> > >> ========
> > >> 
> > >> It seems that there was an agreement that the physical aspects of
> > >> the connector should be mapped via the upcoming properties API,
> > >> with the properties present only when it is possible to find them
> > >> in the hardware. So, it seems that all such properties should be
> > >> optional.
> > >> 
> > >> However, we didn't finish the meeting, as we ran out of time. Yet,
> > >> I guess the last proposal there fulfills the requirements. So,
> > >> let's focus our discussions on it. So, let me formulate it as a
> > >> proposal
> > >> 
> > >> We should represent the entities based on the inputs. So, for the
> > >> already implemented entities, we'll have, instead:
> > >> 
> > >> #define MEDIA_ENT_F_INPUT_RF		(MEDIA_ENT_F_BASE + 10001)
> > >> #define MEDIA_ENT_F_INPUT_SVIDEO	(MEDIA_ENT_F_BASE + 10002)
> > >> #define MEDIA_ENT_F_INPUT_COMPOSITE	(MEDIA_ENT_F_BASE + 10003)  
> > > 
> > > I presume INPUT would be for both input and output? We already have
> > > MEDIA_ENT_F_IO and that's something quite different.
> > > 
> > > I'd really like to have a better name for this.  
> > 
> > See above.
> >   
> > > Another question indeed is whether modelling signals consisting of
> > > multiple electrical signals is the way to go (vs. connectors, where the
> > > discussion started). That's certainly another viewpoint.
> > > 
> > > However it disconnects the actual connectors from the signals. What the
> > > user sees in a device are connectors, not the signals themselves.
> > > Naturally that approach does have its issues as well (such as break-out
> > > boxes), but connectors are hardware and I believe we're not making a
> > > wrong choice if our basic unit of modelling is a connector. I can't say
> > > the same on modelling sets of signals instead.  
> 
> I tend to agree with that, unless we really can't find a way to use such a 
> model cleanly, I would favour a connector-based approach. Given the 
> craziness^Wingenuity of hardware engineers I don't think any model will cover 
> 100% of the cases without any quirk, so I'm more interested in how the model 
> can represent the hardware cleanly in most cases and not be too quirky in the 
> corner cases.

The problem with connectors is that different piggyback cables can be
connected to them, producing different results. The simplest case is
the RCA<==>4pin miniDIN cable, with allows to connect a composite
source to a S-Video input (but, as I said before, from the logical
standpoint, this is a different input to be set at the hardware
registers).

> 
> > > Applications that present information to the user would likely be much
> > > better off with connectors, and such applications certainly are a valid
> > > use case.  
> > 
> > Huh? you said above that you're against using "connectors"... now you're
> > saying that you prefer using it???
> > 
> > The problem with "connector" is: sometimes the same physical connector is
> > used to carry on different types of signals. This is very common with the
> > S-video connector. We need to be able to distinguish between:
> > 
> > 	- Composite via a composite RCA connector;
> > 	- S-Video (with Y+C signals) via a S-Video 4-pin miniDIN connector;
> > 	- Composite using a S-Video 4-pin miniDIN connector.  
> 
> Let's assume we try to model connectors (not a decision set in stone, but we 
> have to start somewhere), here are a few comments. I'm deliberately addressing 
> the complex cases at the end only, so please don't judge the first proposals 
> as not applicable due to that reason before having read through the whole e-
> mail.

As I said before, that's easier said than done. The Terratec AV350 hardware
is very simple, but it can use 2 different types of connectors, selected via
a hardware switch (not visible in software).

It has one SCART connector (with both S-video (Y and C) and one composite
signal inside it) or it can be one 4-pin miniDIN and 3 RCA inputs (1 for
video, 2 for audio).

>From the Video/Audio mux hardware perspective, it has only 2 connections:
	- Composite
	- S-Video

The audio/video mux hardware has no knowledge about the actual
connector that was physically selected by the user.

Mapping by connector is not logical and will lead in mistakes and
"hints" to make it barely work.

Mapping by connection is easy, and this is the way the driver works
when selecting via ENUM/G/S_INPUT ioctls.

The MC diagram should reflect what the above V4L2 ioctls call
"inputs". Doing anything else seems wrong and will lead into
confusion to the users.

> - RCA and BNC connectors are pretty easy in that they can carry a single 
> signal. They thus have a single source pad, there's no big question about how 
> to model them.

True.

> 
> - When several RCA or BNC connectors are meant to be used together without any 
> meaningful option to use them independently their relationship should be 
> conveyed to the user. This could be done through a (to be defined) method to 
> group entities (possibly through properties).

I'm against doing a 1:1 map between physical connectors and entities.
This will explode the graph for no good reason, and make things really
complex, as all such entities would require to be controlled together.

This will be a nightmare to implement.

> - Another option for grouped connectors would be to expose a single connector 
> entity to represent the group.

This is almost what I called "connection", except that your concept
seems to be linked to the physical connector, where I'm calling
"connection" as a logical representation of signals inside the
connectors.

> Properties would then be used to describe the 
> type and other parameters of each physical connector inside the group. The 
> entity could still have one source pad per signal, but to make full use of the 
> grouped connectors abstraction a single source pad that would represent the 
> combination of all the signals that make the video signal might be best. That 
> would simplify the MC representation by lowering the number of pads and links, 
> and thus potentially simplify userspace.
> 
> - Mini-DIN connectors, when they're used to carry a single video signal (such 
> as an S-Video video signal on a mini-DIN 4 connector for instance), can be 
> represented by a single connector entity. As in the grouped RCA or BNC 
> connectors case, we have the option to use one source pad per pin or a single 
> source pad to represent the group of pins. The pros and cons of each option 
> are in my opinion identical to those of the grouped RCAR or BNC connectors 
> case.
> 
> - The source pad or source pads of the connector entities obviously need to be 
> linked, usually to a video decoder. Two good examples were provided by Hans 
> for the adv7604 and adv7842 chips at
> 
> http://hverkuil.home.xs4all.nl/adv7604.png
> 
> This board has four physical connectors : HDMI1 (entity 16), HDMI2 (entity 
> 17), VGA (entity 15) and component video (entity 13, this could be multiple 
> physical connectors, I'm not sure about it).
> 
> http://hverkuil.home.xs4all.nl/adv7842.png
> 
> This board has five physical connectors : HDMI (entity 17), DVI-I (split into 
> entities 16 for the digital side and 15 for the analog side), component video 
> (entity 13, this could be multiple physical connectors, I'm not sure about 
> it), and two BNC connectors that can be used either together for one S-Video 
> signal (use case modeled by entity 19) or separately for one composite signal 
> on the first BNC connector (use case modeled by entity 18).
> 
> Similarly to the above cases where pads can be instantiated for each pin or 
> for each group of pin, the same options are possible on the video decoder 
> side. We can, as in the graphs above, use one pad per analog input pin, or one 
> pad per group of input pins. This gives us four possibilities to model links 
> depending on whether we use the one pad per pin (1:1) or one pad per pins 
> group (1:n) option on the connector (left-hand side of ->) and video decoder 
> (right-hand side of ->).
> 
> a) 1:1 -> 1:1 - A straightforward case, one link would be created per 
> electrical signal. Nothing would explicitly show those links as being related 
> though, unless we provide some kind of link grouping, possibly through 
> properties (but that might not be a useful feature).

This will be a nightmare to implement and will make the graph changes
slow, as entities and their corresponding pads will need to be set in group.

I don't see any reason to implement it.

> 
> b) 1:1 -> 1:n - All the connector(s) source pads would be linked to the same 
> video decoder sink pad. This seems confusing to me, as up to now we have only 
> used sink fanout in case of mutually exclusive links that can be selected by 
> userspace. We could obviously change that, but I see little value in this 
> option.
> 
> c) 1:n -> 1:1 - The single connector source pad would be linked to multiple 
> video decoder sink pads. As with option b) this seems confusing to me, as this 
> denotes until now the same signal being routed to multiple destinations. Once 
> again we could change that, but I see little value in this option.

Sorry, but I failed to understand the above scenarios.

> 
> d) 1:n -> 1:n - The single connector source pad would be linked to a single 
> video decoder sink pad. The link would represent multiple electrical signals 
> and a single video signal. Nothing would explicitly show make the electrical 
> signals apparent, unless we add properties to links for such purpose (but 
> again that might not be a useful feature).

Grouping things seems to be the way to go: a single entity per
connection (where a connection is a group of signals that work together
to provide a single interface - like S-Video interface, HDMI interface,
etc).

The PADs can be a group of signals or one signal per PAD. I guess
both work fine. We can define if the signals will be grouped into
a single PAD or not when we add the connector and co documentation and the


> 
> I would recommend option a) or option d), I believe options b) and c) are not 
> good fits for what we're trying to achieve.
> 
> - It should be noted that whether to use a single source pad or multiple 
> source pads in the above cases (and thus whether to use option a) or option d) 
> for the links) are not mutually exclusive options. We could, if desired, 
> standardize both options and offer them either at the discretion of driver 
> developers, or with guidelines regarding how and when to use each.
> 
> - The single pad option produces more compact graphs that model video signals, 
> which is what I would expect userspace applications, and by extension their 
> users, to be interested in. On the cons side the option is slightly less 
> versatile, which could cause issues in more complex cases, especially the 
> multiplex connectors use cases. I'll detail this below.
> 
> - The multiple pads option produces more verbose graphs that model electrical 
> signals, which offers more versatility. On the cons side is the increased 
> verbosity that can be confusing applications, and by extension their users, as 
> the graph makes it cumbersome to extract the list of available inputs (in the 
> V4L2 input sense) and their relationships, at least when directly modeling 
> physical connectors as entities.
> 
> - The adv7842 example shows how the multiple pads model could be used to solve 
> the multiplexed connectors problem. by trying to model logical inputs instead 
> of physical connectors as entities. Entities 18 and 19 represent two mutually 
> exclusive (due to sharing electrical signals) usages of the two BNC 
> connectors. The mutual exclusion is shown by the two entities being linked to 
> the same sink pad of the video decoder.
> 
> This has several drawbacks though.
> 
> a) The DVI-I connector is split into two unrelated entities, which I believe 
> is confusing for applications as the graph can't be used to tell whether the 
> two entities correspond to a single DVI-I connector or two separate DVI-A and 
> DVI-D connectors. This can in my opinion be fixed by merging the two entities 
> into a six source pads entity without impacting the other similar uses of the 
> logical input model in the graph.
> 
> b) The two BNC connectors are not apparent, they're modeled by two entities 
> that hint there would be a connector for composite video with a single pin and 
> a connector for S-Video with two pins. Again, I believe this is confusing for 
> applications for the reasons already explained above.
> 
> c) The two links to pad AIN10 of the video decoder are also problematic in my 
> opinion. A single electrical signal is in this case modeled by two separate 
> links, for the purpose of making the mutual exclusion between the two logical 
> inputs apparent. The adv7842 driver will still need to expose the S_INPUT API, 
> as we can't expect applications to switch to using link setup with existing 
> drivers (nor should we probably for new drivers similar to the existing 
> consumer-oriented drivers). What will thus be the dynamic behaviour of those 
> links ?
> 
> d) The number of entities will grow exponentially if more analog signals are 
> exposed. If the board had four BNC connectors, any of them usable for a 
> composite video signal, and any two of them usable for an S-Video video 
> signal, you will need 16 logical inputs with the above model. I hope I don't 
> have to convince anyone that the resulting graph would be very confusing for 
> applications.
> 
> - Let's also keep in mind that the MC graph won't come out of nowhere, it will 
> need to be constructed based on a hardware description. For PCI boards this 
> shouldn't be too much of a problem given that drivers are free to describe the 
> board in any way they wish. However, for DT-based systems, DT bindings mandate 
> a system model that describes the hardware.

Nobody is saying otherwise.

> We already have DT bindings for 
> physical connectors, proposing competing DT bindings that would model logical 
> inputs doesn't seem to have high chances of being accepted. 

Well, a connection is associated with one or more physical connectors. I fail
to see why this would not be accepted. A connection basically describes
a set of pins inside an audio and/or video mux or linked into some other
hardware component. It is a hardware description.

> We could, of 
> course, create an input-based graph based on the physical DT description, but 
> that might be challenging. We need to verify that it would be doable before 
> committing to a model that we might end up not being able to construct.
> 
> - As Hans stated, calling the entities inputs isn't a good idea as we also 
> need to use the same model for outputs (given that outputs could create issues 
> specific to them, has any given it a try by the way ?). Furthermore, as Sakari 
> mentioned, the words input and output are very vague and would have a high 
> chance of being confusing. For these reason I believe the word connector to be 
> a better description (and I know this is being challenged by a counterproposal 
> that uses the word connection as a generic term for both logical inputs and 
> outputs). Using connector entities to model something that isn't a physical 
> connector but a logical input or output should in my opinion be avoided.
> 
> - Using connector entities with a single pad per video signal (possibly 
> grouping multiple physical signals), with option d) for the link model, would 
> have the interesting benefit of creating a 1:1 mapping between sink pads of 
> the video decoders and the inputs it exposes through the V4L2 INPUT API, at 
> least in the non-multiplexed connectors cases.
> 
> - Connectors are obviously not specific to video, and I don't think we have 
> run the current proposal through the ALSA core developers. I believe we 
> shouldn't standardize such an important part of the API without making sure 
> that it can be usable for audio as well as video.

I guess the same thing applies to audio: in the case of a stereo input
with RCA cables, they likely map it as a single 2-channel input. We
do that on the media devices with stereo audio input: it is a single
stereo input.

> - The problem of multiplexed connectors remains if we model physical 
> connectors as entities. I believe that's solvable though, I'll try to comment 
> more about that tomorrow as I still have to refine my thoughts on the subject 
> (all the above already took quite some time to clarify and write down).

I doubt this would be solvable, but being sure about that would be
really hard, as you would need to get lots of legacy hardware to be
able to proof that those could be mapped on a different way than
what we currently do for ENUM_INPUT. I won't accept any patches
mapping by physical connectiors without a very comprehensive set
of tests on those legacy hardware.

> > From software perspective, Composite over S-Video is a different
> > mux configuration than S-Video (see saa7134 driver, for example).
> > 
> > Yet, if we represent the connection entity as proposed, using one
> > entity for each different input/output alternative, and PADs for
> > signals, we cover all cases.
> > 
> > We can even associate the physical connector associated with the
> > connection via the properties API in the future.  
> 
> That's an essential feature of the MC API, I don't want to leave it out of the 
> design. We don't have to implement it now, but I want to make sure it will 
> work as expected when used with the MC mode we're trying to design for 
> connectors (regardless of what model we choose).
> 
> I hope the above thoughts show that the problem isn't straightforward and 
> needs to be handled with all the diligent care that an upstream API should 
> receive.
> 


-- 
Thanks,
Mauro
