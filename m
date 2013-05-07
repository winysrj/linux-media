Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:53993 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753823Ab3EGU72 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 7 May 2013 16:59:28 -0400
Date: Tue, 7 May 2013 23:59:22 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
	linux-media <linux-media@vger.kernel.org>,
	Volokh Konstantin <volokh84@gmail.com>,
	Pete Eberlein <pete@sensoray.com>,
	Ismael Luceno <ismael.luceno@corp.bluecherry.net>,
	Sylwester Nawrocki <sylvester.nawrocki@gmail.com>,
	Kamil Debski <k.debski@samsung.com>
Subject: Re: [RFC] Motion Detection API
Message-ID: <20130507205922.GF1075@valkosipuli.retiisi.org.uk>
References: <201304121736.16542.hverkuil@xs4all.nl>
 <1925455.QCByddZe4C@avalon>
 <201305061541.41204.hverkuil@xs4all.nl>
 <2428502.07isB1rKTR@avalon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2428502.07isB1rKTR@avalon>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent, Hans and others,

On Tue, May 07, 2013 at 02:09:54PM +0200, Laurent Pinchart wrote:
> (CC'ing Sakari, I know he's missing reviewing V4L2 patches ;-))

Thanks for cc'ing me! :-) I know I've been very quite recently, but it's not
going to stay like that permanently. Let's say I've been very, very busy
elsewhere.

> On Monday 06 May 2013 15:41:41 Hans Verkuil wrote:
> > On Mon April 29 2013 22:52:31 Laurent Pinchart wrote:
> > > On Friday 12 April 2013 17:36:16 Hans Verkuil wrote:
> > > > This RFC looks at adding support for motion detection to V4L2. This is
> > > > the main missing piece that prevents the go7007 and solo6x10 drivers
> > > > from being moved into mainline from the staging directory.
> > > > 
> > > > Step one is to look at existing drivers/hardware:
> > > > 
> > > > 1) The go7007 driver:
> > > > 	- divides the frame into blocks of 16x16 pixels each (that's 45x36
> > > > 	  blocks for PAL)
> > > > 	- each block can be assigned to region 0, 1, 2 or 3
> > > > 	- each region has:
> > > > 		- a pixel change threshold
> > > > 		- a motion vector change threshold
> > > > 		- a trigger level; if this is 0, then motion detection for this
> > > > 		  region is disabled
> > > > 	- when streaming the reserved field of v4l2_buffer is used as a
> > > > 	  bitmask: one bit for each region where motion is detected.
> > > > 
> > > > 2) The solo6x10 driver:
> > > > 	- divides the frame into blocks of 16x16 pixels each
> > > > 	- each block has its own threshold
> > > > 	- the driver adds one MOTION_ON buffer flag and one MOTION_DETECTED
> > > > 	  buffer flag.
> > > > 	- motion detection can be disabled or enabled.
> > > > 	- the driver has a global motion detection mode with just one
> > > > 	  threshold: in that case all blocks are set to the same threshold.
> > > > 	- there is also support for displaying a border around the image if
> > > > 	  motion is detected (very hardware specific).
> > > > 
> > > > 3) The tw2804 video encoder (based on the datasheet, not implemented in
> > > > the driver):
> > > > 	- divides the image in 12x12 blocks (block size will differ for NTSC
> > > > 	  vs PAL)
> > > > 	- motion detection can be enabled or disabled for each block
> > > > 	- there are four controls:
> > > > 		- luminance level change threshold
> > > > 		- spatial sensitivity threshold
> > > > 		- temporal sensitivity threshold
> > > > 		- velocity control (determines how well slow motions are
> > > > 		  detected)
> > > > 	- detection is reported by a hardware pin in this case
> > > > 
> > > > Comparing these three examples of motion detection I see quite a lot of
> > > > similarities, enough to make a proposal for an API:
> > > > 
> > > > - Add a MOTION_DETECTION menu control:
> > > > 	- Disabled
> > > > 	- Global Motion Detection
> > > > 	- Regional Motion Detection
> > > > 
> > > > If 'Global Motion Detection' is selected, then various threshold
> > > > controls become available. What sort of thresholds are available seems
> > > > to be quite variable, so I am inclined to leave this as private
> > > > controls.
> > > > 
> > > > - Add new buffer flags when motion is detected. The go7007 driver would
> > > > need 4 bits (one for each region), the others just one. This can be
> > > > done by taking 4 bits from the v4l2_buffer flags field. There are still
> > > > 16 bits left there, and if it becomes full, then we still have two
> > > > reserved fields. I see no reason for adding a 'MOTION_ON' flag as the
> > > > solo6x10 driver does today: just check the MOTION_DETECTION control if
> > > > you want to know if motion detection is on or not.
> > > 
> > > We're really starting to shove metadata in buffer flags. Isn't it time to
> > > add a proper metadata API ? I don't really like the idea of using
> > > (valuable) buffer flags for a feature supported by three drivers only.
> > 
> > There are still 18 (not 16) bits remaining, so we are hardly running out of
> > bits. And I feel it is overkill to create a new metadata API for just a few
> > bits.
> 
> Creating a metadata API for any of the small piece of metadata information is 
> overkil, but when we add them up all together it definitely makes sense. We've 
> been postponing that API for some time now, it's in my opinion time to work on 
> it :-)

I agree.

Without that proposal, I'd first suggested events, but a separate metadata
API does indeed sound like a nice idea. There's face detection information
to deliver, for instance. That was discussed long time ago but no conclusion
was reached on that (essentially the proposal was suggesting a very specific
object detection IOCTL which would have no other uses).

On buffer flags --- if one driver uses a single flag to tell about the
motion and another uses four, how does the application still know which
flags to look for and how to interpret them? I think that if it'd be more
than just a single flag with more sophisticated information available by
other means, I wouldn't think buffer flags as the first option. Also ---
think of multiple streams originating from a single source (e.g. in
omap3isp, should it support motion detection). Which one should contain the
relevant buffer flags? In other words, it'd be nice that this was separate
from video buffers themselves; that way it could work on most embedded
systems and desktops in a similar fashion.

The metadata covered by a possible metadata API should probably not cover
all kinds of metadata; for instance, many sensors, such as some SMIA
compatible ones, provide metadata, but there's a but: this metadata is
cumbersome and time-consuming to interpret; reading a single property from
the metadata requies parsing the whole metadata block up to the property of
interest. Also, the metadata consists of very low level properties: register
values used to expose a frame.

I also vaguely remember a Samsung sensor producing floating point numbers in
the metadata. IMHO the above kind of metadata should be parsed in the user
space based on what the user space requires. Designing a stable, useful,
long-lived and complete kernel API for that is unlikely to be feasible.
Beyond that, the metadata itself should likely use video buffers like the
image statistics discussed previously.

So the two above kind of examples of low-level metadata should likely be
excluded from this interface.

But with the two examples of motion detection and face (object) detection, I
think it's entirely possible to start drafting a more generic API. For
object detection more than 64 bytes per event may be needed, and that could
be covered by extended events (when the payload exceeds the space available
in v4l2_event). VIDIOC_QEVENT sounds like an option --- that would allow
passing larger buffers to the V4L2 framework to store the event data into.
That'd be a practicable even if a little rough interface: larger event
buffers would be used whenever the payload exceeds 64 bytes or available.

I think I'd base the metadata API to events: that's an existing, extensible
mechanism that already implements parts of what's needed. Then there are
options, like whether a single event could contain multiple metadata
entries. That's a question of efficiency perhaps; we could also provide
VIDIOC_DQEVENTS that could be used to dequeue multiple events at one go,
thus avoding the need to issue an IOCTL per dequeued event.

> > It's actually quite rare that bits are added here, so I am OK with this
> > myself.
> > 
> > I will produce an RFCv2 though (the current API doesn't really extend to
> > 1080p motion detection due to the limited number of blocks), and I will
> > take another look at this. Although I don't really know off-hand how to
> > implement it. One idea that I had (just a brainstorm at this moment) is to
> > associate V4L2 events with a buffer. So internally buffers would have an
> > event queue and events could be added there once the driver is done with
> > the buffer.

Events already have a frame sequence number, so they can be associated to
video buffers (or rather any video buffer the hardware provides of an image
from the image source). Albeit I admit that there's a catch here: it may be
difficult to know that a motion detection event has not arrived when there
none coming.

Attaching the motion detection information to the video buffer isn't a
silver bullet either since the information whether there's been motion could
be only available after the frame itself (depending on the hardware). For
generic applications it might be just practicable to determine there's no
motion event coming if it wasn't there before the frame itself.

> > An event buffer flag would be set, signalling to userspace that events are
> > available for this buffer and DQEVENT can be used to determine which events
> > there are (e.g. a motion detection event).
> > 
> > This makes it easy to associate many types of event with a buffer (motion
> > detection, face/smile/whatever detection) using standard ioctls, but it
> > feels a bit convoluted at the same time. It's probably worth pursuing,
> > though, as it is nicely generic.
> 
> It's an interesting idea, but maybe a bit convoluted as you mentioned.
> 
> What about using a metadata plane ? Alternatively we could add a metadata flag 

I'm all for a metadata plane for low level sensor metadata as an option ---
sometimes the DMA engine writing that metadata to the system memory is a
different one than the one that writes the actual buffer there. The fact is
that this low-level metadata is typically available much before the actual
frame, and sometimes its availability to user space is time-critical.

> and turn the two reserved fields into a metadata buffer pointer. Or add ioctls 
> to retrieve the metadata buffer associated with a v4l2_buffer (those are rough 
> ideas as well).

I have to say I don't find this option very attractive. There are many, many
IOCTLs in V4L2 for which it's evident they'd better been implemented
differently... S_INPUT, for instance. This approach would have high chances
of being one more to that list. :-)

Long-lived and generic interfaces can be reached by following the Unix
philosophy. Use case specific interfaces seldom are such.

> > An alternative might be to set a 'DETECT' buffer flag, and rename
> > 'reserved2' to 'detect_mask', thus having up to 32 things to detect. The
> > problem with that is that we have no idea yet how to do face detection or
> > any other type of detection since we have no experience with it at all. So
> > 32 bits may also be insufficient, and I'd rather not use up a full field.

On top of that, there are few if any ways to use those bits in a generic
fashion and the user knowing precisely what they mean. If the information is
just bit-based, then probably a single bit would do (motion / no motion).

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
