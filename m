Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr16.xs4all.nl ([194.109.24.36]:4764 "EHLO
	smtp-vbr16.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750709Ab2JHJh1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 8 Oct 2012 05:37:27 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Andrey Smirnov <andrey.smirnov@convergeddevices.net>
Subject: Re: [PATCH v2 0/6] A driver for Si476x series of chips
Date: Mon, 8 Oct 2012 11:37:15 +0200
Cc: andrey.smrinov@convergeddevices.net, mchehab@redhat.com,
	sameo@linux.intel.com, broonie@opensource.wolfsonmicro.com,
	perex@perex.cz, tiwai@suse.de, linux-media@vger.kernel.org,
	linux-kernel@vger.kernel.org
References: <1349488502-11293-1-git-send-email-andrey.smirnov@convergeddevices.net>
In-Reply-To: <1349488502-11293-1-git-send-email-andrey.smirnov@convergeddevices.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201210081137.15857.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Andrey!

On Sat October 6 2012 03:54:56 Andrey Smirnov wrote:
> This is a second version of the patchset originaly posted here:
> https://lkml.org/lkml/2012/9/13/590
> 
> To save everyone's time I'll repost the original description of it:
> 
> 
> This patchset contains a driver for a Silicon Laboratories 476x series
> of radio tuners. The driver itself is implemented as an MFD devices
> comprised of three parts: 1. Core device that provides all the other
> devices with basic functionality and locking scheme. 2. Radio device
> that translates between V4L2 subsystem requests into Core device
> commands. 3. Codec device that does similar to the earlier described
> task, but for ALSA SoC subsystem.
> 
> This driver has been tested to work in two different sytems: 1. A
>  custom Tegra-based ARM board(design is based on Harmony board)
>  running linux kernel 3.1.10 kernel 2. A standalone USB-connected
>  board that has a dedicated Cortex M3 working as a transparent USB to
>  I2C bridge which was connected to a off-the-shelf x86-64 laptop
>  running Ubuntu with 3.2.0 kernel.
> 
> As far as SubmitChecklist is concerned following criteria should be
> satisfied: 2b, 3, 5, 7, 9, 10
> 
> 
> Now it is made against git.linuxtv.org/media_tree.git repository
> instead of linux-stable.
> 
> I tried to take into account all the flaws pointed by Mark and Hans,
> but since the amount of changes I had to made was not trivial I
> wouldn't be surprized if I missed something that was shown to me. I
> would like to appologize in advance if this patchset contains some
> unfixed problems pointed out in the previous version.

It looks a lot better. I reviewed the patches, and as you can see I had
a bunch of comments, most of which shouldn't be too hard to correct.

The main open issues are the custom ioctls and custom controls.

I need more information on those. As I mentioned in my reviews, I think
(most of) the controls can be standardized, but I have serious doubts
about the usefulness of the ioctls. But without documentation and some
argumentation of why they are needed it is hard for me to make a decision.
I do suspect that VIDIOC_LOG_STATUS might be all you need here.

Thanks for all the work!

Regards,

	Hans

> Andrey Smirnov (6):
>   Add header files and Kbuild plumbing for SI476x MFD core
>   Add the main bulk of core driver for SI476x code
>   Add commands abstraction layer for SI476X MFD
>   Add chip properties handling code for SI476X MFD
>   Add a V4L2 driver for SI476X MFD
>   Add a codec driver for SI476X MFD
> 
>  drivers/media/radio/Kconfig        |   17 +
>  drivers/media/radio/Makefile       |    1 +
>  drivers/media/radio/radio-si476x.c | 1159 ++++++++++++++++++++++++++++
>  drivers/mfd/Kconfig                |   14 +
>  drivers/mfd/Makefile               |    3 +
>  drivers/mfd/si476x-cmd.c           | 1493 ++++++++++++++++++++++++++++++++++++
>  drivers/mfd/si476x-i2c.c           |  974 +++++++++++++++++++++++
>  drivers/mfd/si476x-prop.c          |  477 ++++++++++++
>  include/linux/mfd/si476x-core.h    |  529 +++++++++++++
>  include/media/si476x.h             |  449 +++++++++++
>  sound/soc/codecs/Kconfig           |    4 +
>  sound/soc/codecs/Makefile          |    2 +
>  sound/soc/si476x.c                 |  255 ++++++
>  13 files changed, 5377 insertions(+)
>  create mode 100644 drivers/media/radio/radio-si476x.c
>  create mode 100644 drivers/mfd/si476x-cmd.c
>  create mode 100644 drivers/mfd/si476x-i2c.c
>  create mode 100644 drivers/mfd/si476x-prop.c
>  create mode 100644 include/linux/mfd/si476x-core.h
>  create mode 100644 include/media/si476x.h
>  create mode 100644 sound/soc/si476x.c
> 
> 
