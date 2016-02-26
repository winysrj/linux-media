Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:44558 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932738AbcBZO13 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 26 Feb 2016 09:27:29 -0500
Date: Fri, 26 Feb 2016 11:27:23 -0300
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: LMML <linux-media@vger.kernel.org>,
	Sakari Ailus <sakari.ailus@iki.fi>,
	Javier Martinez Canillas <javier@osg.samsung.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: Re: [RFC] Representing hardware connections via MC
Message-ID: <20160226112723.6298c464@recife.lan>
In-Reply-To: <56D05C25.60605@xs4all.nl>
References: <20160226091317.5a07c374@recife.lan>
	<56D051DC.5070900@xs4all.nl>
	<20160226110055.2acf936f@recife.lan>
	<56D05C25.60605@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Fri, 26 Feb 2016 15:07:33 +0100
Hans Verkuil <hverkuil@xs4all.nl> escreveu:

> On 02/26/2016 03:00 PM, Mauro Carvalho Chehab wrote:
> > Em Fri, 26 Feb 2016 14:23:40 +0100
> > Hans Verkuil <hverkuil@xs4all.nl> escreveu:
> >   
> >> On 02/26/2016 01:13 PM, Mauro Carvalho Chehab wrote:  

...

> >>> We should represent the entities based on the inputs. So, for the
> >>> already implemented entities, we'll have, instead:
> >>>
> >>> #define MEDIA_ENT_F_INPUT_RF		(MEDIA_ENT_F_BASE + 10001)
> >>> #define MEDIA_ENT_F_INPUT_SVIDEO	(MEDIA_ENT_F_BASE + 10002)
> >>> #define MEDIA_ENT_F_INPUT_COMPOSITE	(MEDIA_ENT_F_BASE + 10003)
> >>>
> >>> The MEDIA_ENT_F_INPUT_RF and MEDIA_ENT_F_INPUT_COMPOSITE will have
> >>> just one sink PAD each, as they carry just one signal. As we're
> >>> describing the logical input, it doesn't matter the physical
> >>> connector type. So, except for re-naming the define, nothing
> >>> changes for them.    
> >>
> >> What if my device has an SVIDEO output (e.g. ivtv)? 'INPUT' denotes
> >> the direction, and I don't think that's something you want in the
> >> define for the connector entity.
> >>
> >> As was discussed on irc we are really talking about signals received
> >> or transmitted by/from a connector. I still prefer F_SIG_ or F_SIGNAL_
> >> or F_CONN_SIG_ or something along those lines.
> >>
> >> I'm not sure where F_INPUT came from, certainly not from the irc
> >> discussion.  
> > 
> > Well, the idea of "F_CONN_SIG" came when we were talking about
> > representing each signal, and not the hole thing.
> > 
> > I think using it would be a little bit misleading, but I'm OK
> > with that, provided that we make clear that a MEDIA_ENT_F_CONN_SIG_SVIDEO
> > should contain two pads, one for each signal.  
> 
> I hate naming discussions :-)

Me too :) 

> It's certainly not F_INPUT since, well, there are outputs too :-)
> 
> And you are right that the signal idea was abandoned later in the discussion.
> I'd forgotten about that. Basically the different signals are now represented
> as pads (TMDS and CEC for example).
> 
> I think F_CONN_ isn't such a bad name after all.

I guess we can stick with F_CONN, just making sure that it is
properly documented.

Regards,Mauro
