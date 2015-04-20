Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:39616 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753854AbbDTI1v (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 20 Apr 2015 04:27:51 -0400
Message-ID: <1429518466.3178.4.camel@pengutronix.de>
Subject: Re: [PATCH v4 2/4] [media] videobuf2: return -EPIPE from DQBUF
 after the last buffer
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Kamil Debski <k.debski@samsung.com>
Cc: 'Pawel Osciak' <pawel@osciak.com>,
	'LMML' <linux-media@vger.kernel.org>,
	'Hans Verkuil' <hverkuil@xs4all.nl>,
	'Laurent Pinchart' <laurent.pinchart@ideasonboard.com>,
	'Nicolas Dufresne' <nicolas.dufresne@collabora.com>,
	'Sakari Ailus' <sakari.ailus@linux.intel.com>,
	kernel@pengutronix.de
Date: Mon, 20 Apr 2015 10:27:46 +0200
In-Reply-To: <064601d0781e$ace2ef90$06a8ceb0$%debski@samsung.com>
References: <1427219214-5368-1-git-send-email-p.zabel@pengutronix.de>
	 <1427219214-5368-3-git-send-email-p.zabel@pengutronix.de>
	 <CAMm-=zAwQJ-_jp5B7cRiQEi523a57BaijUwnqCwLUPScCL7_kQ@mail.gmail.com>
	 <1428941715.3192.133.camel@pengutronix.de>
	 <064601d0781e$ace2ef90$06a8ceb0$%debski@samsung.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am Donnerstag, den 16.04.2015, 10:23 +0200 schrieb Kamil Debski:
[...]
> > > But, in general, in what kind of scenario would the driver want to
> > > call this function, as opposed to vb2 clearing this flag by itself on
> > > STREAMOFF?
> > 
> > There is VIDIOC_DECODER_CMD / V4L2_DEC_CMD_START.
> > I'd expect this timeline for decoder draining and restart:
> > 
> > - userspace calls VIDIOC_DECODER_CMD, cmd=V4L2_DEC_CMD_STOP
> >   after queueing the last output buffer to be decoded
> > - the driver processes remaining output buffers into capture buffers
> >   and sets the V4L2_BUF_FLAG_LAST set on the last capture Buffet
>
> I would like to confirm that it will work with MFC. Am I right that the
> below will work? Did you take that into account?

I see no reason why it wouldn't. The only difference is that userspace
has to be able to handle the empty frame.

> So in MFC's case the V4L2_BUF_FLAG_LAST will be set on the one buffer after
> the last one and the bytesused of that buffer would be set to 0. 
> 
> The problem of MFC is that it will signal that the last frame was decoded
> after it was decoded. To particularize:
> - a frame is decoded, an irq is sent by MFC - we have a new decoded picture
> - next an irq is sent with an internal MFC flag that the buffer is empty
>   (last picture was already decoded)

Doesn't MFC userspace currently stop on the empty frame? That empty
frame will still be dequeued as before, the only difference is the added
V4L2_BUF_FLAG_LAST on it, and that subsequent calls to DQBUF would
return -EPIPE.

regards
Philipp


