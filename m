Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:57407 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755462AbcCBPkf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 2 Mar 2016 10:40:35 -0500
Date: Wed, 2 Mar 2016 12:40:29 -0300
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: LMML <linux-media@vger.kernel.org>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Javier Martinez Canillas <javier@osg.samsung.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: Re: [RFC] Representing hardware connections via MC
Message-ID: <20160302124029.0e6cee85@recife.lan>
In-Reply-To: <20160302141643.GH11084@valkosipuli.retiisi.org.uk>
References: <20160226091317.5a07c374@recife.lan>
	<20160302141643.GH11084@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Wed, 02 Mar 2016 16:16:43 +0200
Sakari Ailus <sakari.ailus@iki.fi> escreveu:

> Hi Mauro,
> 
> On Fri, Feb 26, 2016 at 09:13:17AM -0300, Mauro Carvalho Chehab wrote:
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
> 
> While I agree that we shouldn't waste time in designing new APIs, we also
> musn't merge unfinished work, and especially not when it comes to user space
> APIs. Rather, we have to come up with a sound user space API/ABI and *then*
> get it to mainline and *not* the other way around.

Well, we've agreed with connectors during the MC workshop in August,
2015.

The problem is that, when mapping the connectors on a particular
driver (saa7134), we noticed that things are not so simple, because
of the way it implements S-Video.

> I just read the IRC discussion beginning from when I needed to leave, and it
> looks like to me that we need to have a common understanding of the relevant
> concepts before we can even reach a common understanding what is being
> discussed. I'm not certain we're even at that level yet.
> 
> Besides that, concepts should not be mixed. Things such as
> MEDIA_ENT_F_CONN_SVIDEO should not exist, as it suggests that there's an
> S-video connector (which doesn't really exist). The signal is S-video and
> the connector is variable, but often RCA.

Well, "CONN" can be an alias for "connection", with is what we're actually
representing. "Signal" is something else. As discussed, a single S-Video
connection has 2 signals: Y and C.

> 
> At least connector, input (and output I presume?) and signal need to be
> defined. My problem with terms such as input and output at this level of the
> API is that they're really generic terms, and we chose not to use them in MC
> in the past exactly for that reason.

After all the discussions, I guess "CONN" for connection is the best way
to represent it.

> 
> For instance, luminance and chrominance certainly are signals, but is
> S-video a signal as well? I'd say so. 

No. S-video has 2 signals only: luminace and chrominance. Nothing else.

> But should we make a difference between the two?

For S-Video, we may not need to represent two pads. For HDMI, for sure
we'll need to represent multiple signals, as they're routed on a different
way (CEC, for example is a bus, that can be connected to multiple HDMI
inputs and outputs).

> Connectors are easy, everyone knows what they are. Having
> read the meeting IRC log, I guess the word "input" was likely used to refer
> signals transmitted over multiple physical wires, at least some of the time.
> I'd prefer not to guess.
> 
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
> 
> I presume INPUT would be for both input and output? We already have
> MEDIA_ENT_F_IO and that's something quite different.
> 
> I'd really like to have a better name for this.

See above.

> Another question indeed is whether modelling signals consisting of multiple
> electrical signals is the way to go (vs. connectors, where the discussion
> started). That's certainly another viewpoint.
> 
> However it disconnects the actual connectors from the signals. What the user
> sees in a device are connectors, not the signals themselves. Naturally that
> approach does have its issues as well (such as break-out boxes), but
> connectors are hardware and I believe we're not making a wrong choice if our
> basic unit of modelling is a connector. I can't say the same on modelling
> sets of signals instead.
> 
> Applications that present information to the user would likely be much
> better off with connectors, and such applications certainly are a valid use
> case.

Huh? you said above that you're against using "connectors"... now you're
saying that you prefer using it???

The problem with "connector" is: sometimes the same physical connector is
used to carry on different types of signals. This is very common with the
S-video connector. We need to be able to distinguish between:

	- Composite via a composite RCA connector;
	- S-Video (with Y+C signals) via a S-Video 4-pin miniDIN connector;
	- Composite using a S-Video 4-pin miniDIN connector.

>From software perspective, Composite over S-Video is a different
mux configuration than S-Video (see saa7134 driver, for example).

Yet, if we represent the connection entity as proposed, using one
entity for each different input/output alternative, and PADs for
signals, we cover all cases.

We can even associate the physical connector associated with the 
connection via the properties API in the future.

Thanks,
Mauro
