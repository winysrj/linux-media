Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:44971 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751232AbbBDLiW (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 4 Feb 2015 06:38:22 -0500
Message-ID: <1423049893.3726.21.camel@pengutronix.de>
Subject: Re: [RFC PATCH 2/2] [media] videobuf2: return -EPIPE from DQBUF
 after the last buffer
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
	Kamil Debski <k.debski@samsung.com>,
	Pawel Osciak <pawel@osciak.com>, kernel@pengutronix.de,
	Nicolas Dufresne <nicolas.dufresne@collabora.com>,
	linux-media@vger.kernel.org
Date: Wed, 04 Feb 2015 12:38:13 +0100
In-Reply-To: <4994964.UYaXg1ctzs@avalon>
References: <1421926118-29535-1-git-send-email-p.zabel@pengutronix.de>
	 <1421926118-29535-3-git-send-email-p.zabel@pengutronix.de>
	 <54CF8313.5020207@xs4all.nl> <4994964.UYaXg1ctzs@avalon>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

Am Dienstag, den 03.02.2015, 13:20 +0200 schrieb Laurent Pinchart:
> On Monday 02 February 2015 15:00:51 Hans Verkuil wrote:
> > On 01/22/2015 12:28 PM, Philipp Zabel wrote:
> > > If the last buffer was dequeued from a capture queue, let poll return
> > > immediately and let DQBUF return -EPIPE to signal there will no more
> > > buffers to dequeue until STREAMOFF.
> > 
> > This looks OK to me, although I would like to see comments from others as
> > well. Of course, this needs to be documented in the spec as well.
> 
> I haven't followed the V4L2 codec API discussion during ELC-E. Could someone 
> briefly expose the rationale for this and the codec draining flow ? The 
> explanation should probably included in the documentation.

This is the draining flow as written down in the notes:

  The decoder draining flow starts with the application making the
  driver aware of its intentions by calling VIDIOC_DECODER_CMD with
  V4L2_DEC_CMD_STOP.

  The driver processes the remaining buffers on the OUTPUT queue.
  Once all CAPTURE buffers produced from those are ready to dequeue, it 
  sends a V4L2_EVENT_EOS.

  The application then dequeues buffers from the CAPTURE queue until it
  encounters a buffer with V4L2_BUF_FLAG_LAST set. This buffer may
  already be empty due to hardware limitations.
  Alternatively, the application may simply continue to dequeue
  (possibly empty) buffers until the VIDIOC_DQBUF ioctl returns -EPIPE.

  To resume decoding, the application can call VIDIOC_DECODER_CMD with
  V4L2_CMD_START without the need to stop streaming.

This should work the same for encoding.
The rationale for using -EPIPE was IIRC that it allows for simpler code
(DQBUF loop until error). Also it works without the newest kernel
headers that #define V4L2_BUF_FLAG_LAST.

I don't remember if we talked about what should happen to new buffers
queued via QBUF on the OUTPUT queue while in draining mode, but I
suppose the driver should just hold them until V4L2_CMD_START is called.

> Existing applications will receive -EPIPE from DQBUF now. Have potential 
> breakages been taken into account ?

We can continue to produce empty frames this way, which are currently
used to signal the last frame in s5p-mfc. I am not aware of other
unspecified mechanisms in use.

regards
Philipp

