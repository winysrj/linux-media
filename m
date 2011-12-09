Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-68.nebula.fi ([83.145.220.68]:51309 "EHLO
	smtp-68.nebula.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750878Ab1LIT6F (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 9 Dec 2011 14:58:05 -0500
Date: Fri, 9 Dec 2011 21:58:01 +0200
From: 'Sakari Ailus' <sakari.ailus@iki.fi>
To: Kamil Debski <k.debski@samsung.com>
Cc: 'Mauro Carvalho Chehab' <mchehab@redhat.com>,
	linux-media@vger.kernel.org,
	'Laurent Pinchart' <laurent.pinchart@ideasonboard.com>,
	'Sebastian =?iso-8859-1?Q?Dr=F6ge'?=
	<sebastian.droege@collabora.co.uk>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>
Subject: Re: [RFC] Resolution change support in video codecs in v4l2
Message-ID: <20111209195801.GC1967@valkosipuli.localdomain>
References: <ADF13DA15EB3FE4FBA487CCC7BEFDF36225500763A@bssrvexch01>
 <4ED8C61C.3060404@redhat.com>
 <20111202135748.GO29805@valkosipuli.localdomain>
 <4ED901C9.2050109@redhat.com>
 <20111206143538.GD938@valkosipuli.localdomain>
 <4EDE40D0.9080704@redhat.com>
 <20111206224134.GE938@valkosipuli.localdomain>
 <00f401ccb4d1$12dcda50$38968ef0$%debski@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <00f401ccb4d1$12dcda50$38968ef0$%debski@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Dec 07, 2011 at 12:12:08PM +0100, Kamil Debski wrote:
> 
> > From: Sakari Ailus [mailto:sakari.ailus@iki.fi]
> > Sent: 06 December 2011 23:42
> > 
> 
> [...]
> 
> > 
> > > >>>That's a good point. It's more related to changes in stream properties
> > ---
> > > >>>the frame rate of the stream could change, too. That might be when you
> > could
> > > >>>like to have more buffers in the queue. I don't think this is critical
> > > >>>either.
> > > >>>
> > > >>>This could also depend on the properties of the codec. Again, I'd wish
> > a
> > > >>>comment from someone who knows codecs well. Some codecs need to be able
> > to
> > > >>>access buffers which have already been decoded to decode more buffers.
> > Key
> > > >>>frames, simply.
> > > >>
> > > >>Ok, but let's not add unneeded things at the API if you're not sure. If
> > we have
> > > >>such need for a given hardware, then add it. Otherwise, keep it simple.
> > > >
> > > >This is not so much dependent on hardware but on the standards which the
> > > >cdoecs implement.
> > >
> > > Could you please elaborate it? On what scenario this is needed?
> > 
> > This is a property of the stream, not a property of the decoder. To
> > reconstruct each frame, a part of the stream is required and already decoded
> > frames may be used to accelerate the decoding. What those parts are. depends
> > on the codec, not a particular implementation.
> 
> They are not used to accelerate decoding. They are used to predict what
> should be displayed. If that frame is missing or modified it will cause
> corruption in consecutive frames.
> 
> I want to make it clear - they are necessary, not optional to accelerate
> decoding speed.

I think we're talking about the same thing. They are being used to
accelerate it --- instead of reconstructing the previous frame from the
compressed stream, the codecjust reuses it. In practice this is always done
and the implementations probably require it.

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi	jabber/XMPP/Gmail: sailus@retiisi.org.uk
