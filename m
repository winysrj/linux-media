Return-path: <linux-media-owner@vger.kernel.org>
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:46983 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755810Ab1LGNt3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 7 Dec 2011 08:49:29 -0500
Date: Wed, 7 Dec 2011 13:49:00 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Andreas Oberritter <obi@linuxtv.org>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	HoP <jpetrous@gmail.com>,
	Florian Fainelli <f.fainelli@gmail.com>,
	Alan Cox <alan@lxorguk.ukuu.org.uk>,
	linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC] vtunerc: virtual DVB device - is it ok to NACK driver
 because of worrying about possible misusage?
Message-ID: <20111207134848.GB18837@opensource.wolfsonmicro.com>
References: <20111202231909.1ca311e2@lxorguk.ukuu.org.uk>
 <CAJbz7-0Xnd30nJsb7SfT+j6uki+6PJpD77DY4zARgh_29Z=-+g@mail.gmail.com>
 <4EDC9B17.2080701@gmail.com>
 <CAJbz7-2maWS6mx9WHUWLiW8gC-2PxLD3nc-3y7o9hMtYxN6ZwQ@mail.gmail.com>
 <4EDD01BA.40208@redhat.com>
 <4EDD2C82.7040804@linuxtv.org>
 <20111206112153.GC17194@sirena.org.uk>
 <4EDE0427.2050307@linuxtv.org>
 <20111206141929.GE17731@opensource.wolfsonmicro.com>
 <4EDE2B3B.2080905@linuxtv.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4EDE2B3B.2080905@linuxtv.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Dec 06, 2011 at 03:48:27PM +0100, Andreas Oberritter wrote:
> On 06.12.2011 15:19, Mark Brown wrote:

> > Your assertatation that applications should ignore the underlying
> > transport (which seems to be a big part of what you're saying) isn't
> > entirely in line with reality.

> Did you notice that we're talking about a very particular application?

*sigh*

> VoIP really is totally off-topic. The B in DVB stands for broadcast.
> There's only one direction in which MPEG payload is to be sent (using
> RTP for example). You can't just re-encode the data on the fly without
> loss of information.

This is pretty much exactly the case for VoIP some of the time (though
obviously bidirectional use cases are rather common there's things like
conferencing).  I would really expect similar considerations to apply
for video content as they certainly do in videoconferencing VoIP
applications - if the application knows about the network it can tailor
what it's doing to that network.  

For example, if it is using a network with a guaranteed bandwidth it can
assume that bandwidth.  If it knows something about the structure of the
network it may be able to arrange to work around choke points.
Depending on the situation even something lossy may be the answer - if
it's the difference between working at all and not working then the cost
may be worth it.
