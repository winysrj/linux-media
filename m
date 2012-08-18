Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-gg0-f174.google.com ([209.85.161.174]:37106 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755859Ab2HRPsx (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 18 Aug 2012 11:48:53 -0400
Received: by ggdk6 with SMTP id k6so4597404ggd.19
        for <linux-media@vger.kernel.org>; Sat, 18 Aug 2012 08:48:53 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <201208162049.35773.hverkuil@xs4all.nl>
References: <CALzAhNVEXexQELbbXzpzxeiUat-oXqhxQ1kiA7K1ibXTm8X+YQ@mail.gmail.com>
	<201208161649.43284.hverkuil@xs4all.nl>
	<CALzAhNWT3eNUNwNsGG_w+Jbz=ErRxogvv+_3GcKy8xZ+R-uZ=A@mail.gmail.com>
	<201208162049.35773.hverkuil@xs4all.nl>
Date: Sat, 18 Aug 2012 11:48:52 -0400
Message-ID: <CALzAhNXZx1+048S_rVsWH3fMg8sJnawo3o+bS6ygD5KRpjYZ3g@mail.gmail.com>
Subject: Re: [GIT PULL] ViewCast O820E capture support added
From: Steven Toth <stoth@kernellabs.com>
To: Hans Verkuil <hverkuil@xs4all.nl>,
	Mauro Chehab <mchehab@infradead.org>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux-Media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Mauro, please read below, a new set of patches I'm submitting for merge.

On Thu, Aug 16, 2012 at 2:49 PM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
> On Thu August 16 2012 19:39:51 Steven Toth wrote:
>> >> So, I've ran v4l2-compliance and it pointed out a few things that I've
>> >> fixed, but it also does a few things that (for some reason) I can't
>> >> seem to catch. One particular test is on (iirc) s_fmt. It attempts to
>> >> set ATSC but by ioctl callback never receives ATSC in the norm/id arg,
>> >> it actually receives 0x0. This feels more like a bug in the test.
>> >> Either way, I have some if (std & ATSC) return -EINVAL, but it still
>> >> appears to fail the test.
>>
>> Oddly enough. If I set tvnorms to something valid, then compliance
>> passes but gstreamer
>> fails to run, looks like some kind of confusion about either the
>> current established
>> norm, or a failure to establish a norm.
>>
>> For the time being I've set tvnorms to 0 (with a comment) and removed
>> current_norm.
>
> Well, this needs to be sorted, because something is clearly amiss.

Agreed. I just can't see what's wrong. I may need your advise /
eyeballs on this. I'd be willing to provide logs that show gstreamer
accessing the driver and exiting. It needs fixed, I've tried, I just
can't see why gstreamer fails.

On the main topic of merge.... As promised, I spent quite a bit of
time this week reworking the code based on the feedback. I also
flattened all of these patches into a single patchset and upgraded to
the latest re-org tree.

The source notes describe in a little more detail the major changes:
http://git.kernellabs.com/?p=stoth/media_tree.git;a=commit;h=f295dd63e2f7027e327daad730eb86f2c17e3b2c

Mauro, so, I hereby submit for your review/merge again, the updated
patchset. *** Please comment. ***

The following changes since commit 9b78c5a3007e10a172d4e83bea18509fdff2e8e3:

  [media] b2c2: export b2c2_flexcop_debug symbol (2012-08-17 11:09:19 -0300)

are available in the git repository at:
  git://git.kernellabs.com/stoth/media_tree.git o820e

Steven Toth (4):
      [media] adv7441a: Adding limited support for a new video decoder.
      [media] adv7441a: Adding the module author macro
      [media] pcm3052: Adding support for a new ADC.
      [media] vc8x0: Adding support for the ViewCast O820E Capture Card.

 drivers/media/i2c/Kconfig                 |   18 +
 drivers/media/i2c/Makefile                |    2 +
 drivers/media/i2c/adv7441a.c              | 4258 +++++++++++++++++++++++++++++
 drivers/media/i2c/pcm3052.c               |  248 ++
 drivers/media/pci/Kconfig                 |    1 +
 drivers/media/pci/Makefile                |    1 +
 drivers/media/pci/vc8x0/Kconfig           |   15 +
 drivers/media/pci/vc8x0/Makefile          |    9 +
 drivers/media/pci/vc8x0/vc8x0-audio.c     |  741 +++++
 drivers/media/pci/vc8x0/vc8x0-buffer.c    |  338 +++
 drivers/media/pci/vc8x0/vc8x0-cards.c     |  138 +
 drivers/media/pci/vc8x0/vc8x0-channel.c   |  805 ++++++
 drivers/media/pci/vc8x0/vc8x0-core.c      |  678 +++++
 drivers/media/pci/vc8x0/vc8x0-display.c   | 1359 +++++++++
 drivers/media/pci/vc8x0/vc8x0-dma.c       | 2677 ++++++++++++++++++
 drivers/media/pci/vc8x0/vc8x0-fw.c        |  466 ++++
 drivers/media/pci/vc8x0/vc8x0-i2c.c       |  368 +++
 drivers/media/pci/vc8x0/vc8x0-reg.h       |  214 ++
 drivers/media/pci/vc8x0/vc8x0-timestamp.c |  156 ++
 drivers/media/pci/vc8x0/vc8x0-video.c     | 2796 +++++++++++++++++++
 drivers/media/pci/vc8x0/vc8x0.h           |  732 +++++
 include/media/adv7441a.h                  |   88 +
 include/media/v4l2-chip-ident.h           |    6 +
 23 files changed, 16114 insertions(+), 0 deletions(-)
 create mode 100644 drivers/media/i2c/adv7441a.c
 create mode 100644 drivers/media/i2c/pcm3052.c
 create mode 100644 drivers/media/pci/vc8x0/Kconfig
 create mode 100644 drivers/media/pci/vc8x0/Makefile
 create mode 100644 drivers/media/pci/vc8x0/vc8x0-audio.c
 create mode 100644 drivers/media/pci/vc8x0/vc8x0-buffer.c
 create mode 100644 drivers/media/pci/vc8x0/vc8x0-cards.c
 create mode 100644 drivers/media/pci/vc8x0/vc8x0-channel.c
 create mode 100644 drivers/media/pci/vc8x0/vc8x0-core.c
 create mode 100644 drivers/media/pci/vc8x0/vc8x0-display.c
 create mode 100644 drivers/media/pci/vc8x0/vc8x0-dma.c
 create mode 100644 drivers/media/pci/vc8x0/vc8x0-fw.c
 create mode 100644 drivers/media/pci/vc8x0/vc8x0-i2c.c
 create mode 100644 drivers/media/pci/vc8x0/vc8x0-reg.h
 create mode 100644 drivers/media/pci/vc8x0/vc8x0-timestamp.c
 create mode 100644 drivers/media/pci/vc8x0/vc8x0-video.c
 create mode 100644 drivers/media/pci/vc8x0/vc8x0.h
 create mode 100644 include/media/adv7441a.h

Regards,

-- 
Steven Toth - Kernel Labs
http://www.kernellabs.com
