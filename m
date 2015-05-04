Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:51819 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751400AbbEDKVp (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 4 May 2015 06:21:45 -0400
Message-ID: <1430734901.3722.30.camel@pengutronix.de>
Subject: Re: [PATCH v5 1/5] [media] DocBook media: document mem2mem draining
 flow
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, Pawel Osciak <pawel@osciak.com>,
	Kamil Debski <k.debski@samsung.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Nicolas Dufresne <nicolas.dufresne@collabora.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	kernel@pengutronix.de
Date: Mon, 04 May 2015 12:21:41 +0200
In-Reply-To: <553E3836.80606@xs4all.nl>
References: <1429518504-14880-1-git-send-email-p.zabel@pengutronix.de>
	 <1429518504-14880-2-git-send-email-p.zabel@pengutronix.de>
	 <553E3836.80606@xs4all.nl>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans, Kamil,

thank you for your comments.

Am Montag, den 27.04.2015, 15:23 +0200 schrieb Hans Verkuil:
> Hi Philipp,
> 
> I finally got around to reviewing this patch series. Sorry for the delay, but
> here are my comments:
>
> On 04/20/2015 10:28 AM, Philipp Zabel wrote:
> > Document the interaction between VIDIOC_DECODER_CMD V4L2_DEC_CMD_STOP and
> > VIDIOC_ENCODER_CMD V4L2_ENC_CMD_STOP to start the draining, the V4L2_EVENT_EOS
> > event signalling all capture buffers are finished and ready to be dequeud,
> > the new V4L2_BUF_FLAG_LAST buffer flag indicating the last buffer being dequeued
> > from the capture queue, and the poll and VIDIOC_DQBUF ioctl return values once
> > the queue is drained.
> > 
> > Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
> > ---
> > Changes since v4:
> >  - Split out documentation changes into a separate patch
> >  - Changed wording following Pawel's suggestions.
> > ---
> >  Documentation/DocBook/media/v4l/io.xml                 | 10 ++++++++++
> >  Documentation/DocBook/media/v4l/vidioc-decoder-cmd.xml |  9 ++++++++-
> >  Documentation/DocBook/media/v4l/vidioc-encoder-cmd.xml |  8 +++++++-
> >  Documentation/DocBook/media/v4l/vidioc-qbuf.xml        |  8 ++++++++
> >  4 files changed, 33 insertions(+), 2 deletions(-)
> > 
> > diff --git a/Documentation/DocBook/media/v4l/io.xml b/Documentation/DocBook/media/v4l/io.xml
> > index 1c17f80..f561037 100644
> > --- a/Documentation/DocBook/media/v4l/io.xml
> > +++ b/Documentation/DocBook/media/v4l/io.xml
> > @@ -1129,6 +1129,16 @@ in this buffer has not been created by the CPU but by some DMA-capable unit,
> >  in which case caches have not been used.</entry>
> >  	  </row>
> >  	  <row>
> > +	    <entry><constant>V4L2_BUF_FLAG_LAST</constant></entry>
> > +	    <entry>0x00100000</entry>
> > +	    <entry>Last buffer produced by the hardware. mem2mem codec drivers
> > +set this flag on the capture queue for the last buffer when the
> > +<link linkend="vidioc-querybuf">VIDIOC_QUERYBUF</link> or
> > +<link linkend="vidioc-qbuf">VIDIOC_DQBUF</link> ioctl is called. Any subsequent
> > +call to the <link linkend="vidioc-qbuf">VIDIOC_DQBUF</link> ioctl will not block
> > +anymore, but return an &EPIPE;.</entry>
> 
> As Kamil mentioned in his review, we should allow for bytesused == 0 here.

How about:

@@ -1134,9 +1134,11 @@ in which case caches have not been used.</entry>
            <entry>Last buffer produced by the hardware. mem2mem codec drivers
 set this flag on the capture queue for the last buffer when the
 <link linkend="vidioc-querybuf">VIDIOC_QUERYBUF</link> or
-<link linkend="vidioc-qbuf">VIDIOC_DQBUF</link> ioctl is called. Any subsequent
-call to the <link linkend="vidioc-qbuf">VIDIOC_DQBUF</link> ioctl will not block
-anymore, but return an &EPIPE;.</entry>
+<link linkend="vidioc-qbuf">VIDIOC_DQBUF</link> ioctl is called. Due to hardware
+limitations, the last buffer may be empty. In this case the driver will set the
+<structfield>bytesused</structfield> field to 0, regardless of the format. Any
+Any subsequent call to the <link linkend="vidioc-qbuf">VIDIOC_DQBUF</link> ioctl
+will not block anymore, but return an &EPIPE;.</entry>
          </row>
          <row>
            <entry><constant>V4L2_BUF_FLAG_TIMESTAMP_MASK</constant></entry>

> > +	  </row>
> > +	  <row>
> >  	    <entry><constant>V4L2_BUF_FLAG_TIMESTAMP_MASK</constant></entry>
> >  	    <entry>0x0000e000</entry>
> >  	    <entry>Mask for timestamp types below. To test the
> > diff --git a/Documentation/DocBook/media/v4l/vidioc-decoder-cmd.xml b/Documentation/DocBook/media/v4l/vidioc-decoder-cmd.xml
> > index 9215627..6502d82 100644
> > --- a/Documentation/DocBook/media/v4l/vidioc-decoder-cmd.xml
> > +++ b/Documentation/DocBook/media/v4l/vidioc-decoder-cmd.xml
> > @@ -197,7 +197,14 @@ be muted when playing back at a non-standard speed.
> >  this command does nothing. This command has two flags:
> >  if <constant>V4L2_DEC_CMD_STOP_TO_BLACK</constant> is set, then the decoder will
> >  set the picture to black after it stopped decoding. Otherwise the last image will
> > -repeat. If <constant>V4L2_DEC_CMD_STOP_IMMEDIATELY</constant> is set, then the decoder
> > +repeat. mem2mem decoders will stop producing new frames altogether. They will send
> > +a <constant>V4L2_EVENT_EOS</constant> event when the last frame has been decoded
> > +and all frames are ready to be dequeued and will set the
> > +<constant>V4L2_BUF_FLAG_LAST</constant> buffer flag on the last buffer of the
> 
> Make a note here as well that the last buffer might be an empty buffer.

@@ -201,9 +201,12 @@ repeat. mem2mem decoders will stop producing new frames altogether. They will se
 a <constant>V4L2_EVENT_EOS</constant> event when the last frame has been decoded
 and all frames are ready to be dequeued and will set the
 <constant>V4L2_BUF_FLAG_LAST</constant> buffer flag on the last buffer of the
-capture queue to indicate there will be no new buffers produced to dequeue. Once
-this flag was set, the <link linkend="vidioc-qbuf">VIDIOC_DQBUF</link> ioctl
-will not block anymore, but return an &EPIPE;.
+capture queue to indicate there will be no new buffers produced to dequeue. This
+buffer may be empty, indicated by the driver setting the
+<structfield>bytesused</structfield> field to 0. Once the
+<constant>V4L2_BUF_FLAG_LAST</constant> flag was set, the
+<link linkend="vidioc-qbuf">VIDIOC_DQBUF</link> ioctl will not block anymore,
+but return an &EPIPE;.
 If <constant>V4L2_DEC_CMD_STOP_IMMEDIATELY</constant> is set, then the decoder
 stops immediately (ignoring the <structfield>pts</structfield> value), otherwise it
 will keep decoding until timestamp >= pts or until the last of the pending data from

> > +capture queue to indicate there will be no new buffers produced to dequeue. Once
> > +this flag was set, the <link linkend="vidioc-qbuf">VIDIOC_DQBUF</link> ioctl
> > +will not block anymore, but return an &EPIPE;.
> > +If <constant>V4L2_DEC_CMD_STOP_IMMEDIATELY</constant> is set, then the decoder
> >  stops immediately (ignoring the <structfield>pts</structfield> value), otherwise it
> >  will keep decoding until timestamp >= pts or until the last of the pending data from
> >  its internal buffers was decoded.
> > diff --git a/Documentation/DocBook/media/v4l/vidioc-encoder-cmd.xml b/Documentation/DocBook/media/v4l/vidioc-encoder-cmd.xml
> > index 0619ca5..3cdb841 100644
> > --- a/Documentation/DocBook/media/v4l/vidioc-encoder-cmd.xml
> > +++ b/Documentation/DocBook/media/v4l/vidioc-encoder-cmd.xml
> > @@ -129,7 +129,13 @@ this command.</entry>
> >  encoding will continue until the end of the current <wordasword>Group
> >  Of Pictures</wordasword>, otherwise encoding will stop immediately.
> >  When the encoder is already stopped, this command does
> > -nothing.</entry>
> > +nothing. mem2mem encoders will send a <constant>V4L2_EVENT_EOS</constant> event
> > +when the last frame has been decoded and all frames are ready to be dequeued and
> > +will set the <constant>V4L2_BUF_FLAG_LAST</constant> buffer flag on the last
> > +buffer of the capture queue to indicate there will be no new buffers produced to
> 
> Ditto.

@@ -133,7 +133,9 @@ nothing. mem2mem encoders will send a <constant>V4L2_EVENT_EOS</constant> event
 when the last frame has been decoded and all frames are ready to be dequeued and
 will set the <constant>V4L2_BUF_FLAG_LAST</constant> buffer flag on the last
 buffer of the capture queue to indicate there will be no new buffers produced to
-dequeue. Once this flag was set, the
+dequeue. This buffer may be empty, indicated by the driver setting the
+<structfield>bytesused</structfield> field to 0. Once the
+<constant>V4L2_BUF_FLAG_LAST</constant> flag was set, the
 <link linkend="vidioc-qbuf">VIDIOC_DQBUF</link> ioctl will not block anymore,
 but return an &EPIPE;.</entry>
          </row>

regards
Philipp

