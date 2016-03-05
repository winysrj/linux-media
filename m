Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:36486 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751310AbcCEPAI (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 5 Mar 2016 10:00:08 -0500
Date: Sat, 5 Mar 2016 12:00:02 -0300
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
	Sakari Ailus <sakari.ailus@iki.fi>,
	LMML <linux-media@vger.kernel.org>,
	Javier Martinez Canillas <javier@osg.samsung.com>
Subject: Re: [RFC] Representing hardware connections via MC
Message-ID: <20160305120002.33358a56@recife.lan>
In-Reply-To: <6842554.fnEKTEcFg8@avalon>
References: <20160226091317.5a07c374@recife.lan>
	<1778959.zqGoLXbLC1@avalon>
	<56D7EDA4.7030907@xs4all.nl>
	<6842554.fnEKTEcFg8@avalon>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Thu, 03 Mar 2016 12:10:18 +0200
Laurent Pinchart <laurent.pinchart@ideasonboard.com> escreveu:

> > 4) The concept of splitting up multiplexed connectors has been in use in
> > V4L2 since the beginning. Without, to my knowledge, causing any problems on
> > either the driver or application side. It will have to be a hard sell to
> > convince me of changing this.  
> 
> V4L2 has an input API to handle video signal routing. I'm not challenging that 
> and I believe we should keep it. This actually appears to me as an argument to 
> create pads based on video signals rather than electrical signals.
> 
> When it comes to the MC graph, we have to keep in mind that the API is not 
> specific to V4L2, and the way we model connectors needs to take at least audio 
> and graphics into account. KMS is based on connectors and has a tendency to 
> have a simpler hardware design when it comes to signal routing. 

Well a "connection" can be directly associated with a connector. I don't
see any problems doing such map. We do that at V4L2 as well for inputs,
in the simple case where all inputs are directly connected to a single
physical connector.

The reverse is not true: if a single connector have multiple 
"connections" (e. g. either S-Video or Composite), mapping by
connectors will lose information.

> I don't have 
> enough experience with ALSA to comment on the audio side, this needs to be run 
> through audio experts.

We do have, as we mapped audio stereo inputs on media drivers.
Again, the concept of "connections" is useful, as it doesn't matter
if the external connector is a stereo jack or Audio-R RCA + Audio-L RCA:
ALSA should handle it as a single multi-channel capture (or playback)
interface.

> 
> Let's also not forget that the MC graph does not have to be modeled around the 
> V4L2 API. It does need to integrate well with V4L2, but not duplicate it.


-- 
Thanks,
Mauro
