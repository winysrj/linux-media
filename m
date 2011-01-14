Return-path: <mchehab@pedra>
Received: from smtp-vbr10.xs4all.nl ([194.109.24.30]:2591 "EHLO
	smtp-vbr10.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757929Ab1ANQCg (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 14 Jan 2011 11:02:36 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: Re: [RFC] Cropping and scaling with subdev pad-level operations
Date: Fri, 14 Jan 2011 17:02:17 +0100
Cc: Sylwester Nawrocki <snjw23@gmail.com>, linux-media@vger.kernel.org,
	Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
References: <201101061633.30029.laurent.pinchart@ideasonboard.com> <4D2CE84E.8020700@gmail.com> <201101121006.45099.laurent.pinchart@ideasonboard.com>
In-Reply-To: <201101121006.45099.laurent.pinchart@ideasonboard.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201101141702.17308.hverkuil@xs4all.nl>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Laurent,

My apologies that this reply is so late, but I knew I had to sit down and think
carefully about this and I didn't have time for that until today.

I've decided not to quote your post but instead restate the problem in my own
words.

Seen abstractly you have an entity with inputs, outputs and a processing pipeline
that transforms the input(s) to the output(s) somehow. And each stage of that
pipeline has its own configuration.

You want to provide the developer that sets up such an entity with a systematic
and well-defined procedure while at the same time you want to keep the entity's
code as simple as possible.

Part of this procedure is already decided: you always start with defining the
inputs. The confusion begins with how to setup the configuration and the outputs.

I think the only reasonably way is to configure the pipeline stages in strict order
from the input to the output.

So you start with defining the inputs. For a scaler the next thing to set is the
crop rectangle. And then finally the output.

At each stage the entity will only check if the configuration parameters can work
with the input. It may make the rest of the pipeline invalid, but that's OK for
now.

The final step comes when the output is defined. If that returns OK, then you
know the whole pipeline is valid.

So what to do when you have an input and an output configured and someone suddenly
changes the crop configuration to a value that doesn't work with that input/output
combinations?

The two options I've seen are:

1) modify the crop configuration to fit the output
2) modify the output configuration to fit the crop

But there is a third option which I think works much better:

3) accept the crop configuration if it fits the input, but report back to the caller
   that it invalidates the output.

What the entity does with this crop configuration is purely up to the entity: it can
just store it in a shadow configuration and wait with applying it to the hardware
until it receives a consistent output format, or it can modify the output format to
fit the crop configuration. In any case, if changes are made, then they should be
made 'upstream'. This makes the behavior consistent. As long as you work your way
from input to output, you know that any configuration you've set for earlier stages
stay put and won't change unexpectedly.

And if you decide to change a 'mid-pipeline' configuration, then you will get a
status back that tells you whether or not you broke the upstream configuration.

The advantage is that at any stage the driver code just has to check whether the
new configuration is valid given the input (in which case the call will succeed)
and whether the new configuration is valid for the current output and report that
in a status field.

Note that 'input' and 'output' do not necessarily refer to pads, it may also refer
to stages of a pipeline. And the same principle should hold for both the subdev
API and for the 'main' V4L API (more about that later).

A suggested alternative was to do the configuration atomically. I do not think
that is a good idea because it is so very hard to do things atomically. It is
hard to use and it is hard to implement. The extended controls API for example has
been defined years ago and there are very few drivers that implement it (let alone
implement it correctly). It took the creation of the control framework (almost 2000
lines of code) to make it possible to implement it easily in drivers and I've just
started out converting all drivers to this framework. And this is just for simple
controls...

So this sounds simple, but in practice I think it will be a disaster. I like to
cut things up in small pieces, and working your way through a pipeline as proposed
makes each part much easier.

Since the subdev API is not yet set in stone it shouldn't be hard to provide such
feedback. For the existing V4L2 API it can be a bit harder:

VIDIOC_S_FMT: struct v4l2_pix_format has a priv field which I believe is never used.
So we might hijack that as a flags field instead.

VIDIOC_S_CROP: Can't do anything with that. However, we could define a TRY_CROP that
does give back the information (i.e. 'if you try this crop rectangle, then the
upstream pipeline will become invalid'). Not ideal, but it should work.

ROTATE control: two options: either use one of the top bits in the control ID field
(the top four bits are reserved as flags, one of them is the NEXT_CTRL flag). Or
change the reserved2 field to a flags field.

VIDIOC_S_STD: Can't be done.
VIDIOC_S_INPUT: Can't be done.
VIDIOC_S_OUTPUT: Can't be done.

For these three you might be able to store some sort of information in their ENUM
counterparts.

VIDIOC_S_DV_PRESET: easy to add.
VIDIOC_S_DV_TIMINGS: easy to add.

VIDIOC_S_AUDIO/VIDIOC_S_AUDOUT: easy to add, but not sure if it is needed.

I'm sure there are a lot of details to sort out if we apply this principle as
well to the V4L2 API, but I think that for subdevs this should be a decent way
of doing things. Unless of course I've forgotten about all sorts of subtleties
that I didn't take into account.

Regards,

	Hans

-- 
Hans Verkuil - video4linux developer - sponsored by Cisco
