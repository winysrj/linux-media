Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.irobotique.be ([92.243.18.41]:45066 "EHLO
	perceval.irobotique.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964823Ab0BZOXX (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 26 Feb 2010 09:23:23 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: More videobuf and streaming I/O questions
Date: Fri, 26 Feb 2010 15:24:10 +0100
Cc: Pawel Osciak <p.osciak@samsung.com>,
	"'Hans Verkuil'" <hverkuil@xs4all.nl>, linux-media@vger.kernel.org
References: <201002201500.21118.hverkuil@xs4all.nl> <001b01cab6b6$631d05f0$295711d0$%osciak@samsung.com> <4B87B8E6.6040608@infradead.org>
In-Reply-To: <4B87B8E6.6040608@infradead.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201002261524.12960.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Pawel and Mauro,

On Friday 26 February 2010 13:04:54 Mauro Carvalho Chehab wrote:
> Pawel Osciak wrote:
> >> On Tuesday 23 February 2010 08:41:49 Pawel Osciak wrote:
> >>>> On Mon, 22 Feb 2010 00:12:18 +0100
> >>> 
> >>>> Laurent Pinchart <laurent.pinchart@ideasonboard.com> wrote:
> >>> As for the REQBUF, I've always thought it'd be nice to be able to ask
> >>> the driver for the "recommended" number of buffers that should be used
> >>> by issuing a REQBUF with count=0...
> >> 
> >> How would the driver come up with the number of recommended buffers ?
> > 
> > From the top of my head: when encoding a video stream, a codec driver
> > could decide on the minimum number of input frames required (including
> > reference frames, etc.).

Drivers can always raise or lower the number of buffers passed as the 
VIDIOC_REQBUFS argument, so we already have a way to handle hardware 
requirements there.

If we really need a way to tell the driver "please decide on the number of 
buffers for me", we could use a flag/magic value for the buffer count instead 
of using 0. The V4L2 specification clearly states that a count of 0 frees the 
buffers, and several applications rely on that feature.

> > Or maybe I am missing something, what is your opinion on that?
> 
> There are some cases where this feature could be useful. For example, there
> are some devices used for surveillance that have one decoder connected to
> several inputs. For example, several bttv boards have one bt848 chip for
> each 8 inputs. Each input is connected to one camera. The minimum
> recommended number of buffers is 16 (2 per each input).

Why two per input ? There's a single video stream, buffers are not queued 
separately for each input.

Beside, even if the number of recommended buffers was 2 per input, I would 
expect applications to know about that. If an application decides to open a 
single video node and call VIDIOC_S_INPUT during streaming (or configure the 
driver to do it automatically at IRQ time, which is conceptually similar), the 
application should be able to compute the required number of buffers.

> This is poorly documented, on some wikis for some of the boards with such
> usage.
> 
> That's said, there's currently a few missing features for surveillance: the
> user software need to manually switch from one input to another, and the
> video buffer metadata doesn't indicate the input.

There's actually an input field in v4l2_buffer. As far as I know it's only 
used by an out-of-tree, closed source driver that nobody is using anymore (I'm 
the one who requested a reserved field to be turned into the input field back 
then). Now that I'm a bit more knowledgeable about V4L2 and Linux in general, 
I don't think that's the best way to pass metadata around. The v4l2_buffer 
structure won't be able to hold all metadata we need in the future.

> The better would be to provide a way to let the driver to switch to the
> next camera just after the reception of a new buffer (generally at the IRQ
> time), instead of letting the userspace software to do it at the DQBUF.

That would be an improvement, but even then it might be too late. The only way 
to handle analog input switching reliably is to synchronize the input switch 
to the analog signal, and that must be done by the hardware. That kind of 
feature is not commonly found in cheap bttv boards.

-- 
Regards,

Laurent Pinchart
