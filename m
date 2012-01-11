Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-68.nebula.fi ([83.145.220.68]:38080 "EHLO
	smtp-68.nebula.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751005Ab2AKWau (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 11 Jan 2012 17:30:50 -0500
Date: Thu, 12 Jan 2012 00:30:46 +0200
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
Message-ID: <20120111223045.GS9323@valkosipuli.localdomain>
References: <ADF13DA15EB3FE4FBA487CCC7BEFDF36225500763A@bssrvexch01>
 <4ED8C61C.3060404@redhat.com>
 <20111202135748.GO29805@valkosipuli.localdomain>
 <4ED901C9.2050109@redhat.com>
 <20111206143538.GD938@valkosipuli.localdomain>
 <00da01ccb428$3c9522c0$b5bf6840$%debski@samsung.com>
 <20111209195440.GB1967@valkosipuli.localdomain>
 <003501ccb8b7$3617d800$a2478800$%debski@samsung.com>
 <20120101222928.GJ3677@valkosipuli.localdomain>
 <009b01cccaca$4e9a2070$ebce6150$%debski@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <009b01cccaca$4e9a2070$ebce6150$%debski@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Kamil,

On Wed, Jan 04, 2012 at 11:19:08AM +0100, Kamil Debski wrote:
...
> > > This takes care of the delay related problems by requiring more buffers.
> > > You have an initial delay then the frames are returned with a constant
> > rate.
> > >
> > > Dequeuing of any frame will be delayed until it is no longer used - it
> > doesn't
> > > matter whether it is a key (I) frame, P frame o r a B frame. Actually B
> > frames
> > > shouldn't be used as reference. Usually a frame is referencing only 2-3
> > previous
> > > and maybe 1 ahead (for B-frames) frames and they don't need to be I-frames.
> > Still
> > > the interval between I-frames may be 16 or even many, many, more.
> > 
> > Considering it can be 16 or even more, I see even more reason in returning
> > frames when hardware only reads them.
> 
> It can be 31337 P-frames after an I-frame but it doesn't matter, as the codec
> will never ever need more than X frames for reference. Usually the X is small, 
> like 2-3. I have never seen a number as high as 16. After this X frames are
> processed
> and kept it will allow to dequeue frames with no additional delay.
> This is a CONSTANT delay. 

It's constant, and you need up to that number more frames available for
decoding. There's no way around it.

> P-frames are equally good as reference as I-frames. No need to keep the I-frame
> for an indefinite time.
> 
> In other words: interval between I-frames is NOT the number of buffers that
> have to be kept as reference.

Referring to what Wikipedia has to say about H.264:

	Using previously-encoded pictures as references in a much more
	flexible way than in past standards, allowing up to 16 reference
	frames (or 32 reference fields, in the case of interlaced encoding)
	to be used in some cases. This is in contrast to prior standards,
	where the limit was typically one; or, in the case of conventional
	"B pictures", two. This particular feature usually allows modest
	improvements in bit rate and quality in most scenes. But in certain
	types of scenes, such as those with repetitive motion or
	back-and-forth scene cuts or uncovered background areas, it allows a
	significant reduction in bit rate while maintaining clarity.

<URL:http://en.wikipedia.org/wiki/H.264/MPEG-4_AVC>

We need to be prepared to the worst case, which, according to this, is 16.

Regards,

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi	jabber/XMPP/Gmail: sailus@retiisi.org.uk
