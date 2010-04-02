Return-path: <linux-media-owner@vger.kernel.org>
Received: from qw-out-2122.google.com ([74.125.92.26]:51499 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754480Ab0DBBvU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 1 Apr 2010 21:51:20 -0400
MIME-Version: 1.0
In-Reply-To: <20100401145632.5631756f@pedra>
References: <20100401145632.5631756f@pedra>
Date: Thu, 1 Apr 2010 21:44:12 -0400
Message-ID: <t2z9e4733911004011844pd155bbe8g13e4cbcc1a5bf1f6@mail.gmail.com>
Subject: Re: [PATCH 00/15] ir-core: Several improvements to allow adding LIRC
	and decoder plugins
From: Jon Smirl <jonsmirl@gmail.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: linux-input@vger.kernel.org,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Jarod Wilson <jarod@wilsonet.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Apr 1, 2010 at 1:56 PM, Mauro Carvalho Chehab
<mchehab@redhat.com> wrote:
> This series of 15 patches improves support for IR, as discussed at the
> "What are the goals for the architecture of an in-kernel IR system?"
> thread.
>
> It basically adds a raw decoder layer at ir-core, allowing decoders to plug
> into IR core, and preparing for the addition of a lirc_dev driver that will
> allow raw IR codes to be sent to userspace.
>
> There's no lirc patch in this series. I have also a few other patches from
> David Härdeman that I'm about to test/review probably later today, but
> as I prefer to first merge what I have at V4L/DVB tree, before applying
> them.

Has anyone ported the MSMCE driver onto these patches yet? That would
be a good check to make sure that rc-core has the necessary API.
Cooler if it works both through LIRC and with an internal protocol
decoder. The MSMCE driver in my old patches was very simplified, it
removed about half of the code from the LIRC version.

>
> There are two patches on this series that deserve a better analysis, IMO:
>
> -  V4L/DVB: ir-core: rename sysfs remote controller class from ir to rc
>
> As discussed, "IR" is not a good name, as this infrastructure could later
> be used by other types of Remote Controllers, as it has nothing that
> is specific to IR inside the code, except for the name. So, I'm proposing
> to replace the sysfs notes do "rc", instead of "ir". The sooner we do
> such changes, the better, as userspace apps using it are still under
> development. So, an API change is still possible, without causing
> much hurt.
>
> Also, as some RC devices allow RC code transmission, we probably need to add
> a TX node somewhere, associated with the same RX part (as some devices
> don't allow simultaneous usage of TX and RX).
>
> So, we have a few alternatives for the RC device sysfs node:
> a) /sys/class/rc/rc0
>                 |--> rx
>                 ---> tx
> b) /sys/class/rc/rcrcv0
>   /sys/class/rc/rctx0
>
> c) /sys/class/rc/rc0
>  and have there the RX and TX nodes/attributes mixed. IMO, (b) is a bad idea,
> so, I am between (a) and (c).
>
> -  V4L/DVB: input: Add support for EVIO[CS]GKEYCODEBIG
>
> Adds two new ioctls in order to handle with big keycode tables. As already
> said, we'll need another ioctl, in order to get the maximum keycode supported
> by a given device. I didn't wrote the patch for the new ioctl yet.
> This patch will probably have a small conflict with upstream input, but I
> prefer to keep it on my tree and fix the upstream conflicts when submiting
> it, as the rest of the new IR code is also on my tree, and this patch is
> needed to procced with the IR code development.
>
> Mauro Carvalho Chehab (15):
>  V4L/DVB: ir-core: be less pedantic with RC protocol name
>  V4L/DVB: saa7134: use a full scancode table for M135A
>  V4L/DVB: saa7134: add code to allow changing IR protocol
>  V4L/DVB: ir-core: Add logic to decode IR protocols at the IR core
>  V4L/DVB: ir-core: add two functions to report keyup/keydown events
>  V4L/DVB: ir-core/saa7134: Move ir keyup/keydown code to the ir-core
>  V4L/DVB: saa7134: don't wait too much to generate an IR event on raw_decode
>  V4L/DVB: ir-core: dynamically load the compiled IR protocols
>  V4L/DVB: ir-core: prepare to add more operations for ir decoders
>  V4L/DVB: ir-nec-decoder: Add sysfs node to enable/disable per irrcv
>  V4L/DVB: saa7134: clear warning noise
>  V4L/DVB: ir-core: rename sysfs remote controller class from ir to rc
>  V4L/DVB: ir-core: Add callbacks for input/evdev open/close on IR core
>  V4L/DVB: cx88: Only start IR if the input device is opened
>  V4L/DVB: input: Add support for EVIO[CS]GKEYCODEBIG
>
>  drivers/input/evdev.c                       |   39 +++
>  drivers/input/input.c                       |  260 ++++++++++++++++++--
>  drivers/media/IR/Kconfig                    |    9 +
>  drivers/media/IR/Makefile                   |    3 +-
>  drivers/media/IR/ir-keymaps.c               |   98 ++++----
>  drivers/media/IR/ir-keytable.c              |   75 ++++++-
>  drivers/media/IR/ir-nec-decoder.c           |  351 +++++++++++++++++++++++++++
>  drivers/media/IR/ir-raw-event.c             |  231 ++++++++++++++++++
>  drivers/media/IR/ir-sysfs.c                 |   29 ++-
>  drivers/media/video/cx88/cx88-input.c       |   69 +++++-
>  drivers/media/video/cx88/cx88-video.c       |    6 +-
>  drivers/media/video/cx88/cx88.h             |    6 +-
>  drivers/media/video/saa7134/saa7134-core.c  |    2 +-
>  drivers/media/video/saa7134/saa7134-input.c |  207 +++++++++++++++--
>  drivers/media/video/saa7134/saa7134.h       |    4 +-
>  include/linux/input.h                       |   40 +++-
>  include/media/ir-common.h                   |    9 +-
>  include/media/ir-core.h                     |   59 +++++-
>  18 files changed, 1368 insertions(+), 129 deletions(-)
>  create mode 100644 drivers/media/IR/ir-nec-decoder.c
>  create mode 100644 drivers/media/IR/ir-raw-event.c
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-input" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>



-- 
Jon Smirl
jonsmirl@gmail.com
