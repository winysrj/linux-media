Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr13.xs4all.nl ([194.109.24.33]:3755 "EHLO
	smtp-vbr13.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751252Ab2HRS54 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 18 Aug 2012 14:57:56 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Steven Toth <stoth@kernellabs.com>
Subject: Re: [GIT PULL] ViewCast O820E capture support added
Date: Sat, 18 Aug 2012 20:56:22 +0200
Cc: Mauro Chehab <mchehab@infradead.org>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	"Linux-Media" <linux-media@vger.kernel.org>
References: <CALzAhNVEXexQELbbXzpzxeiUat-oXqhxQ1kiA7K1ibXTm8X+YQ@mail.gmail.com> <201208162049.35773.hverkuil@xs4all.nl> <CALzAhNXZx1+048S_rVsWH3fMg8sJnawo3o+bS6ygD5KRpjYZ3g@mail.gmail.com>
In-Reply-To: <CALzAhNXZx1+048S_rVsWH3fMg8sJnawo3o+bS6ygD5KRpjYZ3g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201208182056.22513.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat August 18 2012 17:48:52 Steven Toth wrote:
> Mauro, please read below, a new set of patches I'm submitting for merge.
> 
> On Thu, Aug 16, 2012 at 2:49 PM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
> > On Thu August 16 2012 19:39:51 Steven Toth wrote:
> >> >> So, I've ran v4l2-compliance and it pointed out a few things that I've
> >> >> fixed, but it also does a few things that (for some reason) I can't
> >> >> seem to catch. One particular test is on (iirc) s_fmt. It attempts to
> >> >> set ATSC but by ioctl callback never receives ATSC in the norm/id arg,
> >> >> it actually receives 0x0. This feels more like a bug in the test.
> >> >> Either way, I have some if (std & ATSC) return -EINVAL, but it still
> >> >> appears to fail the test.
> >>
> >> Oddly enough. If I set tvnorms to something valid, then compliance
> >> passes but gstreamer
> >> fails to run, looks like some kind of confusion about either the
> >> current established
> >> norm, or a failure to establish a norm.
> >>
> >> For the time being I've set tvnorms to 0 (with a comment) and removed
> >> current_norm.
> >
> > Well, this needs to be sorted, because something is clearly amiss.
> 
> Agreed. I just can't see what's wrong. I may need your advise /
> eyeballs on this. I'd be willing to provide logs that show gstreamer
> accessing the driver and exiting. It needs fixed, I've tried, I just
> can't see why gstreamer fails.

You definitely need to set tvnorms for the video node as well. Take a look
at v4l_s_std in v4l2-ioctl.c: if tvnorms == 0, then your s_std function
is called with a std of 0 as well. The v4l_s_std function could do with a
WARN_ON(!vfd->tvnorms), by the way. This is why that ATSC test is also
always failing (and so can be removed).

The tvnorms value for the vbi and video node must also be identical.

You can easily debug what gstreamer is doing by running:

	echo 2 >/sys/class/video4linux/video0/debug

This will turn on core logging of all v4l2 ioctls, and it should help you
figuring out why gstreamer is failing.

This debug facility is new and is very handy.

One small thing I saw in querycap: don't set cap->version. The core sets that
to the kernel version automatically (and if built with media_build, then it's
set to the kernel version of the media tree).

There are still a few blocking issues here that I've told you about before.
Ignore this if you were planning to do that in a next version of the patch.

- use the control framework in the bridge driver
- use struct v4l2_fh

It's all trivial to add and you get control events and prio handling all for
free. I'm almost tempted to do it for you since it's 1 hour work tops for me,
but that's not really my job.

- use the new dv_timings API for the HDTV formats, both in the bridge driver
  and in the adv7441a driver.

This really must be done. As I mentioned before: I didn't implement this for
nothing. It's easy to test this with the qv4l2 utility which fully supports the
new API.

If you need help with any of this, please mail me and we can set up an irc
session.

I also strongly recommend using vb2 instead of videobuf. It's so much better.

What I don't quite understand BTW is how you detect and set formats for the
adv7441 driver. You must have something similar to VIDIOC_QUERY_DV_TIMINGS or
VIDIOC_S_DV_TIMINGS, but I don't see it offhand. How does this work?

Regards,

	Hans

> On the main topic of merge.... As promised, I spent quite a bit of
> time this week reworking the code based on the feedback. I also
> flattened all of these patches into a single patchset and upgraded to
> the latest re-org tree.
> 
> The source notes describe in a little more detail the major changes:
> http://git.kernellabs.com/?p=stoth/media_tree.git;a=commit;h=f295dd63e2f7027e327daad730eb86f2c17e3b2c
> 
> Mauro, so, I hereby submit for your review/merge again, the updated
> patchset. *** Please comment. ***
> 
> The following changes since commit 9b78c5a3007e10a172d4e83bea18509fdff2e8e3:
> 
>   [media] b2c2: export b2c2_flexcop_debug symbol (2012-08-17 11:09:19 -0300)
> 
> are available in the git repository at:
>   git://git.kernellabs.com/stoth/media_tree.git o820e
> 
> Steven Toth (4):
>       [media] adv7441a: Adding limited support for a new video decoder.
>       [media] adv7441a: Adding the module author macro
>       [media] pcm3052: Adding support for a new ADC.
>       [media] vc8x0: Adding support for the ViewCast O820E Capture Card.
> 
>  drivers/media/i2c/Kconfig                 |   18 +
>  drivers/media/i2c/Makefile                |    2 +
>  drivers/media/i2c/adv7441a.c              | 4258 +++++++++++++++++++++++++++++
>  drivers/media/i2c/pcm3052.c               |  248 ++
>  drivers/media/pci/Kconfig                 |    1 +
>  drivers/media/pci/Makefile                |    1 +
>  drivers/media/pci/vc8x0/Kconfig           |   15 +
>  drivers/media/pci/vc8x0/Makefile          |    9 +
>  drivers/media/pci/vc8x0/vc8x0-audio.c     |  741 +++++
>  drivers/media/pci/vc8x0/vc8x0-buffer.c    |  338 +++
>  drivers/media/pci/vc8x0/vc8x0-cards.c     |  138 +
>  drivers/media/pci/vc8x0/vc8x0-channel.c   |  805 ++++++
>  drivers/media/pci/vc8x0/vc8x0-core.c      |  678 +++++
>  drivers/media/pci/vc8x0/vc8x0-display.c   | 1359 +++++++++
>  drivers/media/pci/vc8x0/vc8x0-dma.c       | 2677 ++++++++++++++++++
>  drivers/media/pci/vc8x0/vc8x0-fw.c        |  466 ++++
>  drivers/media/pci/vc8x0/vc8x0-i2c.c       |  368 +++
>  drivers/media/pci/vc8x0/vc8x0-reg.h       |  214 ++
>  drivers/media/pci/vc8x0/vc8x0-timestamp.c |  156 ++
>  drivers/media/pci/vc8x0/vc8x0-video.c     | 2796 +++++++++++++++++++
>  drivers/media/pci/vc8x0/vc8x0.h           |  732 +++++
>  include/media/adv7441a.h                  |   88 +
>  include/media/v4l2-chip-ident.h           |    6 +
>  23 files changed, 16114 insertions(+), 0 deletions(-)
>  create mode 100644 drivers/media/i2c/adv7441a.c
>  create mode 100644 drivers/media/i2c/pcm3052.c
>  create mode 100644 drivers/media/pci/vc8x0/Kconfig
>  create mode 100644 drivers/media/pci/vc8x0/Makefile
>  create mode 100644 drivers/media/pci/vc8x0/vc8x0-audio.c
>  create mode 100644 drivers/media/pci/vc8x0/vc8x0-buffer.c
>  create mode 100644 drivers/media/pci/vc8x0/vc8x0-cards.c
>  create mode 100644 drivers/media/pci/vc8x0/vc8x0-channel.c
>  create mode 100644 drivers/media/pci/vc8x0/vc8x0-core.c
>  create mode 100644 drivers/media/pci/vc8x0/vc8x0-display.c
>  create mode 100644 drivers/media/pci/vc8x0/vc8x0-dma.c
>  create mode 100644 drivers/media/pci/vc8x0/vc8x0-fw.c
>  create mode 100644 drivers/media/pci/vc8x0/vc8x0-i2c.c
>  create mode 100644 drivers/media/pci/vc8x0/vc8x0-reg.h
>  create mode 100644 drivers/media/pci/vc8x0/vc8x0-timestamp.c
>  create mode 100644 drivers/media/pci/vc8x0/vc8x0-video.c
>  create mode 100644 drivers/media/pci/vc8x0/vc8x0.h
>  create mode 100644 include/media/adv7441a.h
> 
> Regards,
> 
> 
