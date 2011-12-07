Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.samsung.com ([203.254.224.24]:58707 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753744Ab1LGLM5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 7 Dec 2011 06:12:57 -0500
Received: from epcpsbgm2.samsung.com (mailout1.samsung.com [203.254.224.24])
 by mailout1.samsung.com
 (Oracle Communications Messaging Exchange Server 7u4-19.01 64bit (built Sep  7
 2010)) with ESMTP id <0LVT00GHLZ5JGI00@mailout1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 07 Dec 2011 20:12:55 +0900 (KST)
Received: from AMDN157 ([106.116.48.215])
 by mmp1.samsung.com (Oracle Communications Messaging Exchange Server 7u4-19.01
 64bit (built Sep  7 2010)) with ESMTPA id <0LVT00IT8Z5ECM40@mmp1.samsung.com>
 for linux-media@vger.kernel.org; Wed, 07 Dec 2011 20:12:55 +0900 (KST)
From: Kamil Debski <k.debski@samsung.com>
To: 'Sakari Ailus' <sakari.ailus@iki.fi>,
	'Mauro Carvalho Chehab' <mchehab@redhat.com>
Cc: linux-media@vger.kernel.org,
	'Laurent Pinchart' <laurent.pinchart@ideasonboard.com>,
	=?iso-8859-1?Q?'Sebastian_Dr=F6ge'?=
	<sebastian.droege@collabora.co.uk>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>
References: <ADF13DA15EB3FE4FBA487CCC7BEFDF36225500763A@bssrvexch01>
 <4ED8C61C.3060404@redhat.com> <20111202135748.GO29805@valkosipuli.localdomain>
 <4ED901C9.2050109@redhat.com> <20111206143538.GD938@valkosipuli.localdomain>
 <4EDE40D0.9080704@redhat.com> <20111206224134.GE938@valkosipuli.localdomain>
In-reply-to: <20111206224134.GE938@valkosipuli.localdomain>
Subject: RE: [RFC] Resolution change support in video codecs in v4l2
Date: Wed, 07 Dec 2011 12:12:08 +0100
Message-id: <00f401ccb4d1$12dcda50$38968ef0$%debski@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=iso-8859-1
Content-transfer-encoding: 7bit
Content-language: en-gb
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


> From: Sakari Ailus [mailto:sakari.ailus@iki.fi]
> Sent: 06 December 2011 23:42
> 

[...]

> 
> > >>>That's a good point. It's more related to changes in stream properties
> ---
> > >>>the frame rate of the stream could change, too. That might be when you
> could
> > >>>like to have more buffers in the queue. I don't think this is critical
> > >>>either.
> > >>>
> > >>>This could also depend on the properties of the codec. Again, I'd wish
> a
> > >>>comment from someone who knows codecs well. Some codecs need to be able
> to
> > >>>access buffers which have already been decoded to decode more buffers.
> Key
> > >>>frames, simply.
> > >>
> > >>Ok, but let's not add unneeded things at the API if you're not sure. If
> we have
> > >>such need for a given hardware, then add it. Otherwise, keep it simple.
> > >
> > >This is not so much dependent on hardware but on the standards which the
> > >cdoecs implement.
> >
> > Could you please elaborate it? On what scenario this is needed?
> 
> This is a property of the stream, not a property of the decoder. To
> reconstruct each frame, a part of the stream is required and already decoded
> frames may be used to accelerate the decoding. What those parts are. depends
> on the codec, not a particular implementation.

They are not used to accelerate decoding. They are used to predict what
should be displayed. If that frame is missing or modified it will cause
corruption in consecutive frames.

I want to make it clear - they are necessary, not optional to accelerate
decoding speed.
 
> Anyone with more knowledge of codecs than myself might be able to give a
> concrete example. Sebastian?
> 

--
Kamil Debski
Linux Platform Group
Samsung Poland R&D Center

