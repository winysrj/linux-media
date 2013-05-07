Return-path: <linux-media-owner@vger.kernel.org>
Received: from ams-iport-2.cisco.com ([144.254.224.141]:46477 "EHLO
	ams-iport-2.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758022Ab3EGMgJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 7 May 2013 08:36:09 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: Re: [RFC] Motion Detection API
Date: Tue, 7 May 2013 14:35:30 +0200
Cc: "linux-media" <linux-media@vger.kernel.org>,
	Volokh Konstantin <volokh84@gmail.com>,
	Pete Eberlein <pete@sensoray.com>,
	Ismael Luceno <ismael.luceno@corp.bluecherry.net>,
	Sylwester Nawrocki <sylvester.nawrocki@gmail.com>,
	Kamil Debski <k.debski@samsung.com>, sakari.ailus@iki.fi
References: <201304121736.16542.hverkuil@xs4all.nl> <201305061541.41204.hverkuil@xs4all.nl> <2428502.07isB1rKTR@avalon>
In-Reply-To: <2428502.07isB1rKTR@avalon>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201305071435.30062.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue 7 May 2013 14:09:54 Laurent Pinchart wrote:
> Hi Hans,
> 
> (CC'ing Sakari, I know he's missing reviewing V4L2 patches ;-))
> 
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
> 
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
> > 
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
> and turn the two reserved fields into a metadata buffer pointer. Or add ioctls 
> to retrieve the metadata buffer associated with a v4l2_buffer (those are rough 
> ideas as well).

A metadata plane works well if you have substantial amounts of data (e.g. histogram
data) but it has the disadvantage of requiring you to use the MPLANE buffer types,
something which standard apps do not support. I definitely think that is overkill
for things like this.

Another problem with a metadata plane is how to interpret it. If you have lots of
different properties that you want to store it becomes hard to read. An event
queue-like solution would be more effective, it is a good fit for collecting
random pieces of small information. It would certainly be suitable for things
like face/motion/smile/whatever detection scenarios, especially since you can
select() on that if you want and since the whole infrastructure for this
already exists.

I think I'd like to study this possibility a bit further, see how easy it is
to put this together.

Personally I think the metadata planes are more suitable for information that
is there for every frame, whereas per-buffer events are more suitable for
information that is event-driven: 'There is motion', 'There are faces',
'Someone has closed their eyes', etc. Using the event API actually makes a
lot of sense if you look at it that way.

Regards,

	Hans
