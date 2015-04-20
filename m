Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.w1.samsung.com ([210.118.77.14]:12659 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754537AbbDTK7C (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 20 Apr 2015 06:59:02 -0400
Received: from eucpsbgm1.samsung.com (unknown [203.254.199.244])
 by mailout4.w1.samsung.com
 (Oracle Communications Messaging Server 7.0.5.31.0 64bit (built May  5 2014))
 with ESMTP id <0NN300IUYQPY6YA0@mailout4.w1.samsung.com> for
 linux-media@vger.kernel.org; Mon, 20 Apr 2015 12:03:34 +0100 (BST)
From: Kamil Debski <k.debski@samsung.com>
To: 'Philipp Zabel' <p.zabel@pengutronix.de>
Cc: 'Pawel Osciak' <pawel@osciak.com>,
	'LMML' <linux-media@vger.kernel.org>,
	'Hans Verkuil' <hverkuil@xs4all.nl>,
	'Laurent Pinchart' <laurent.pinchart@ideasonboard.com>,
	'Nicolas Dufresne' <nicolas.dufresne@collabora.com>,
	'Sakari Ailus' <sakari.ailus@linux.intel.com>,
	kernel@pengutronix.de
References: <1427219214-5368-1-git-send-email-p.zabel@pengutronix.de>
 <1427219214-5368-3-git-send-email-p.zabel@pengutronix.de>
 <CAMm-=zAwQJ-_jp5B7cRiQEi523a57BaijUwnqCwLUPScCL7_kQ@mail.gmail.com>
 <1428941715.3192.133.camel@pengutronix.de>
 <064601d0781e$ace2ef90$06a8ceb0$%debski@samsung.com>
 <1429518466.3178.4.camel@pengutronix.de>
In-reply-to: <1429518466.3178.4.camel@pengutronix.de>
Subject: RE: [PATCH v4 2/4] [media] videobuf2: return -EPIPE from DQBUF after
 the last buffer
Date: Mon, 20 Apr 2015 12:58:57 +0200
Message-id: <"073401d07b59$019d3490$04d79db0$@debski"@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=utf-8
Content-transfer-encoding: 7bit
Content-language: pl
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi, 

> From: Philipp Zabel [mailto:p.zabel@pengutronix.de]
> Sent: Monday, April 20, 2015 10:28 AM
> To: Kamil Debski
> Cc: 'Pawel Osciak'; 'LMML'; 'Hans Verkuil'; 'Laurent Pinchart';
> 'Nicolas Dufresne'; 'Sakari Ailus'; kernel@pengutronix.de
> Subject: Re: [PATCH v4 2/4] [media] videobuf2: return -EPIPE from DQBUF
> after the last buffer
> 
> Am Donnerstag, den 16.04.2015, 10:23 +0200 schrieb Kamil Debski:
> [...]
> > > > But, in general, in what kind of scenario would the driver want
> to
> > > > call this function, as opposed to vb2 clearing this flag by
> itself on
> > > > STREAMOFF?
> > >
> > > There is VIDIOC_DECODER_CMD / V4L2_DEC_CMD_START.
> > > I'd expect this timeline for decoder draining and restart:
> > >
> > > - userspace calls VIDIOC_DECODER_CMD, cmd=V4L2_DEC_CMD_STOP
> > >   after queueing the last output buffer to be decoded
> > > - the driver processes remaining output buffers into capture
> buffers
> > >   and sets the V4L2_BUF_FLAG_LAST set on the last capture Buffet
> >
> > I would like to confirm that it will work with MFC. Am I right that
> the
> > below will work? Did you take that into account?
> 
> I see no reason why it wouldn't. The only difference is that userspace
> has to be able to handle the empty frame.

I just checked the notes from the codec meeting in Dusseldorf. When we
talked about the draining flow, we agreed to mention in the documentation
that a buffer with the V4L2_BUF_FLAG_LAST can be empty. Thus the userspace
applications should check the size of last frame.

Could you please add that the last buffer can be empty (zero size) in the
DocBook patch?

> 
> > So in MFC's case the V4L2_BUF_FLAG_LAST will be set on the one buffer
> after
> > the last one and the bytesused of that buffer would be set to 0.
> >
> > The problem of MFC is that it will signal that the last frame was
> decoded
> > after it was decoded. To particularize:
> > - a frame is decoded, an irq is sent by MFC - we have a new decoded
> picture
> > - next an irq is sent with an internal MFC flag that the buffer is
> empty
> >   (last picture was already decoded)
> 
> Doesn't MFC userspace currently stop on the empty frame? That empty
> frame will still be dequeued as before, the only difference is the
> added
> V4L2_BUF_FLAG_LAST on it, and that subsequent calls to DQBUF would
> return -EPIPE.

Ok, I see this.
 
> regards
> Philipp

Best wishes,
-- 
Kamil Debski
Samsung R&D Institute Poland


