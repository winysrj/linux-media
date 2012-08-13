Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr13.xs4all.nl ([194.109.24.33]:4411 "EHLO
	smtp-vbr13.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751673Ab2HMOGD (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 13 Aug 2012 10:06:03 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Steven Toth <stoth@kernellabs.com>
Subject: Re: [GIT PULL] ViewCast O820E capture support added
Date: Mon, 13 Aug 2012 16:04:28 +0200
Cc: "Linux-Media" <linux-media@vger.kernel.org>,
	Mauro Chehab <mchehab@infradead.org>
References: <CALzAhNVEXexQELbbXzpzxeiUat-oXqhxQ1kiA7K1ibXTm8X+YQ@mail.gmail.com>
In-Reply-To: <CALzAhNVEXexQELbbXzpzxeiUat-oXqhxQ1kiA7K1ibXTm8X+YQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201208131604.28675.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Steve!

On Mon August 13 2012 01:16:30 Steven Toth wrote:
> Hi Mauro,
> 
> A new PCIe bridge driver below. It was released a couple of months ago
> to the public, probably about time
> we got this into the request queue. I'll review the linux-firmware
> additions shortly, I have a firmware blob
> and flexible license for the distros.

I went through this driver from a high-level point of view, and I'm afraid I
have quite a number of issues with this driver.

One of the bigger ones is that vc8x0-ad7441.c should be implemented as
a subdevice. I have two other AD drivers in my queue (adv7604 and ad9389b),
so you can look at those for comparison.

See: http://www.spinics.net/lists/linux-media/msg51501.html

These Analog Devices chips are quite complex, and you really want to be able
to reuse drivers.

Some of the other issues are:

- Please use the control framework. All new drivers must use it, unless there
  are very, very good reasons not to. I'm gradually converting all drivers to
  the control framework, so I really don't want to introduce new drivers to
  that list.

- TRY_FMT can actually set the format, something that should never happen.

- Use the new DV_TIMINGS ioctls for the HDTV formats. S_FMT should not be used
  to select the HDTV format!

- The procfs additions seem unnecessary to me. VIDIOC_LOG_STATUS or perhaps
  debugfs are probably much more suitable.

- Using videobuf2 is very much recommended.

- Please run v4l2-compliance and fix any reported issues!

It's a pretty big driver, so I only looked skimmed the patch, but these are
IMHO fairly major issues. As it stands it is only suitable to be merged in
drivers/staging/media.

Regards,

	Hans

> 
> The following changes since commit da2cd767f537082be0a02d83f87e0da4270e25b2:
> 
>   [media] ttpci: add support for Omicom S2 PCI (2012-08-12 14:41:26 -0300)
> 
> are available in the git repository at:
>   git://git.kernellabs.com/stoth/media_tree.git o820e
> 
> Steven Toth (1):
>       [media] vc8x0: Add support for the ViewCast O820E card.
> 
>  drivers/media/video/Kconfig                 |    2 +
>  drivers/media/video/Makefile                |    1 +
>  drivers/media/video/vc8x0/Kconfig           |   14 +
>  drivers/media/video/vc8x0/Makefile          |   10 +
>  drivers/media/video/vc8x0/vc8x0-ad7441.c    | 3057 +++++++++++++++++++++++++++
>  drivers/media/video/vc8x0/vc8x0-audio.c     |  736 +++++++
>  drivers/media/video/vc8x0/vc8x0-buffer.c    |  338 +++
>  drivers/media/video/vc8x0/vc8x0-cards.c     |  138 ++
>  drivers/media/video/vc8x0/vc8x0-channel.c   |  934 ++++++++
>  drivers/media/video/vc8x0/vc8x0-core.c      |  887 ++++++++
>  drivers/media/video/vc8x0/vc8x0-display.c   | 1359 ++++++++++++
>  drivers/media/video/vc8x0/vc8x0-dma.c       | 2677 +++++++++++++++++++++++
>  drivers/media/video/vc8x0/vc8x0-eeprom.c    |   71 +
>  drivers/media/video/vc8x0/vc8x0-fw.c        |  429 ++++
>  drivers/media/video/vc8x0/vc8x0-i2c.c       |  290 +++
>  drivers/media/video/vc8x0/vc8x0-pcm3052.c   |  192 ++
>  drivers/media/video/vc8x0/vc8x0-reg.h       |  214 ++
>  drivers/media/video/vc8x0/vc8x0-timestamp.c |  156 ++
>  drivers/media/video/vc8x0/vc8x0-vga.c       |  430 ++++
>  drivers/media/video/vc8x0/vc8x0-video.c     | 2650 +++++++++++++++++++++++
>  drivers/media/video/vc8x0/vc8x0.h           |  995 +++++++++
>  21 files changed, 15580 insertions(+), 0 deletions(-)
>  create mode 100644 drivers/media/video/vc8x0/Kconfig
>  create mode 100644 drivers/media/video/vc8x0/Makefile
>  create mode 100644 drivers/media/video/vc8x0/vc8x0-ad7441.c
>  create mode 100644 drivers/media/video/vc8x0/vc8x0-audio.c
>  create mode 100644 drivers/media/video/vc8x0/vc8x0-buffer.c
>  create mode 100644 drivers/media/video/vc8x0/vc8x0-cards.c
>  create mode 100644 drivers/media/video/vc8x0/vc8x0-channel.c
>  create mode 100644 drivers/media/video/vc8x0/vc8x0-core.c
>  create mode 100644 drivers/media/video/vc8x0/vc8x0-display.c
>  create mode 100644 drivers/media/video/vc8x0/vc8x0-dma.c
>  create mode 100644 drivers/media/video/vc8x0/vc8x0-eeprom.c
>  create mode 100644 drivers/media/video/vc8x0/vc8x0-fw.c
>  create mode 100644 drivers/media/video/vc8x0/vc8x0-i2c.c
>  create mode 100644 drivers/media/video/vc8x0/vc8x0-pcm3052.c
>  create mode 100644 drivers/media/video/vc8x0/vc8x0-reg.h
>  create mode 100644 drivers/media/video/vc8x0/vc8x0-timestamp.c
>  create mode 100644 drivers/media/video/vc8x0/vc8x0-vga.c
>  create mode 100644 drivers/media/video/vc8x0/vc8x0-video.c
>  create mode 100644 drivers/media/video/vc8x0/vc8x0.h
> 
> Regards,
> 
> - Steve
> 
> 
