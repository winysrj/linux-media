Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.irobotique.be ([92.243.18.41]:41753 "EHLO
	perceval.irobotique.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964865Ab0BZO2I (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 26 Feb 2010 09:28:08 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Muralidharan Karicheri <mkaricheri@gmail.com>
Subject: Re: More videobuf and streaming I/O questions
Date: Fri, 26 Feb 2010 15:29:05 +0100
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
	Pawel Osciak <p.osciak@samsung.com>,
	Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org
References: <201002201500.21118.hverkuil@xs4all.nl> <4B87B8E6.6040608@infradead.org> <55a3e0ce1002260505s798e3945ueb1e929dd87e6ea6@mail.gmail.com>
In-Reply-To: <55a3e0ce1002260505s798e3945ueb1e929dd87e6ea6@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201002261529.08099.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On Friday 26 February 2010 14:05:30 Muralidharan Karicheri wrote:
> On Fri, Feb 26, 2010 at 7:04 AM, Mauro Carvalho Chehab wrote:
> > Pawel Osciak wrote:
> >>> On Tuesday 23 February 2010 08:41:49 Pawel Osciak wrote:
> >>>>> On Mon, 22 Feb 2010 00:12:18 +0100
> >>>> 
> >>>>> Laurent Pinchart <laurent.pinchart@ideasonboard.com> wrote:
> >>>> As for the REQBUF, I've always thought it'd be nice to be able to ask
> >>>> the driver for the "recommended" number of buffers that should be
> >>>> used by issuing a REQBUF with count=0...
> >>> 
> >>> How would the driver come up with the number of recommended buffers ?
> >> 
> >> From the top of my head: when encoding a video stream, a codec driver
> >> could decide on the minimum number of input frames required (including
> >> reference frames, etc.).
> >> 
> >> Or maybe I am missing something, what is your opinion on that?
> > 
> > There are some cases where this feature could be useful. For example,
> > there are some devices used for surveillance that have one decoder
> > connected to several inputs. For example, several bttv boards have one
> > bt848 chip for each 8 inputs. Each input is connected to one camera. The
> > minimum recommended number of buffers is 16 (2 per each input). This is
> > poorly documented, on some wikis for some of the boards with such usage.
> > 
> > That's said, there's currently a few missing features for surveillance:
> > the user software need to manually switch from one input to another, and
> > the video buffer metadata doesn't indicate the input.
> > 
> > The better would be to provide a way to let the driver to switch to the
> > next camera just after the reception of a new buffer (generally at the
> > IRQ time), instead of letting the userspace software to do it at the
> > DQBUF.
> 
> This is an interesting use case and I would like to know some details
> on this use case.
> When you say application manually switch the input, Is it implementing some
> kind of input multiplexing during the session (open, stream on - stream off,
> close) ?

No, applications just call VIDIOC_S_INPUT while the stream is active.

> We have encountered a similar use case and I was wondering how this can be
> implemented in v4l2 driver. In my understanding, a v4l2 device is not
> allowed to switch input while streaming.

Switching input while streaming is allowed (if I'm not mistaken), as long as 
the format and size don't change (not sure about lowering the size, that needs 
to be double-checked).

This being said, VIDIOC_S_INPUT was designed to switch analog sources. I'm not 
sure it would be the best would to multiplex streams from two digital sensors 
for instance. Even for analog signals, using the ioctl from userspace usually 
results in at least one corrupt frame if you don't synchronize the switching 
to the analog signals, which requires hardware support.

Can you give us more details about the use case you're thinking about ?

> Does it require 2 buffers per input because every frame period, you have
> multiple frames to queue from the different inputs?

In this case there's a single video stream, so I don't think it would require 
2 buffers per input.

> Usually a minimum of 3 buffers are typically required in a SoC case to do
> streaming. Could you share the details if possible?

-- 
Regards,

Laurent Pinchart
