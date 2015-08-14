Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:57895 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753001AbbHNX1w (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 14 Aug 2015 19:27:52 -0400
Date: Fri, 14 Aug 2015 20:27:46 -0300
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [PATCH v4 0/6] MC preparation patches
Message-ID: <20150814202746.179f78e4@recife.lan>
In-Reply-To: <20150814223744.GE28370@valkosipuli.retiisi.org.uk>
References: <cover.1439563682.git.mchehab@osg.samsung.com>
	<20150814223744.GE28370@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Sat, 15 Aug 2015 01:37:44 +0300
Sakari Ailus <sakari.ailus@iki.fi> escreveu:

> Hi Mauro,
> 
> On Fri, Aug 14, 2015 at 11:56:37AM -0300, Mauro Carvalho Chehab wrote:
> > Those are the initial patches from my previous series of MC changes.
> > 
> > The first patch removes an unused parameter when creating links.
> > 
> > The next 5 patches warrant that all object types (entities, pads and
> > links) will have an unique ID, as agreed at the MC workshop.
> > 
> > They prepare for the addition of the media interfaces and interface
> > links.
> 
> Having looked the set through, I don't think the patches in the set are
> strictly necessary for adding media interfaces. Again, I need to stress I'd
> very much prefer to keep things simple in order to get support for media
> interfaces in soon, as I understand your intention is as well.

Well, the new API we've agreed requires unique IDs. So, those patches are
a mandatory requirement. Also, the ID is a requirement for links (see
patch 9/16 and latter patches on my RFC v3).

> We could make things more dynamic later on, and represent associations using
> links --- if there's a use case for that.
> 
> I don't as such object the patchset, but my question is: where will this all
> lead to? I'd like to see that, or at least some more, before finally acking
> the patches. I sense these should be closely related to supporting the
> property API rather than media interfaces (or DVB), but unfortunately I
> won't have time to work on the property API for the following ~ three weeks.

Well my goals are different then yours and so my test environment.

Currently, I have only the hybrid PC-consumer TV devices handy for test
and my goal is to address what's needed for them to be properly and fully
supported. Nothing more, nothing less.

Yet, I'm aiming to future support TV sets and Set Top Boxes. Even the
simpler of such hardware would be at least 4x or 5x more complex than
a PC consumer devices. So, whenever I need to take some design decision,
I'll have those complex hardware in mind.

With regards to properties, I don't intend to touch on them. Those are
on your action items, so I'm counting that you'll be doing that ;)

I might need to add something to internally replace the entity->type on
some future patch, but I'm not there yet, and, if I need to do, I'll
try to do the minimal amount required for my patches to work.

> struct media_interface could be pointed to from entities using a statically
> allocated array of pointers, a bit like links (except that they're not
> pointers). I think we'd get quite far with this already while making much
> fewer changes to the framework.

No, I won't be coding links using arrays, nor using a different
struct to represent the links. We need dynamic link addition/removal.
Doing it using realloc would fragment the memory and cause lots of
harm.

So, my plan is do it right, in a way that will allow us to share the
same code and data model, and to future allow graph traversals though
interface links too. Graph traversal using both pad/pad and interface/entity
links is needed to properly address conflicts when multiple drivers and
multiple interfaces may control the same piece of the hardware.

> One thing that wasn't discussed at length in the meeting, but which I
> understood was generally agreed on, was DMA engines as entities (vs. having
> a pad for the sake of the interface in the video node entity, which is
> ugly). IMHO a sound foundation is important for the proposed changes.

Not sure if I understood. Anyway, the comments below are actually
unrelated to this patch series, and looks more like a RFC ;)

---

At the V4L2 case, DMA engines will be mapped as entities (on non-USB
hardware). We still need to agree how we'll name such entities.

It should be noticed that:

- On V4L2, the video/VBI stream output is not the DMA engine. The DMA
engine is actually linked to the USB EHCI/UHCI/xHCI driver. the
USB driver sends a block of data to the V4L2 driver, with decapsulate
the data packages and copy into a transfer buffer. Such buffer
is mapped to userspace or made available via I/O (read() sysctl).

- Some hardware may not provide a stream sink. This is the case of
  DVB devices that are compliant with the ETSI encryption standards.
  All userspace can do is to control the pipeline to direct the
  unencrypted streams to the GPU and to the ASoC hardware;

- On DVB, the DMA is internal to the Kernel, even on PCI/SoC
  hardware. The Kernel splits the Transport Stream data into
  several ring buffers. The ring buffers are sent to userspace -
  currently, only via I/O (read() sysctl. We're planning to improve
  it, but we need to keep supporting the old way, as several hardware
  can only work on that mode;

- On Radio, it may or may not have DMA. Some devices work via
  reading the audio samples on some register. This can even be done
  on some firmware inside the device. The radio output can be:
	- a wire from the radio board into the Motherboard's audio
	  card;
	- an I/O read() operation at ALSA.

So, I won't be calling the hardware that may or may not be doing
DMA as "DMA". I guess we can simply call it as:

For output:
	- video stream output
	- vbi stream output
	- TS stream output
	- audio stream playback

For input:
	- video stream capture
	- vbi stream capture
	- TS stream capture
	- audio stream capture

Or something equivalent.

Just my 2 euro cents ;)


> 
> Just my one euro cent --- got some left from Italy. :-)
> 
