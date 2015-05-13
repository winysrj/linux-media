Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud3.xs4all.net ([194.109.24.22]:34511 "EHLO
	lb1-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752412AbbEMHZb (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 13 May 2015 03:25:31 -0400
Message-ID: <5552FC63.3090900@xs4all.nl>
Date: Wed, 13 May 2015 09:25:23 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
CC: ovebryne@cisco.com, marbugge@cisco.com, matrandg@cisco.com
Subject: Re: [PATCHv2 0/5] cobalt: new HDMI Rx/Tx PCIe driver
References: <1431501764-44250-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1431501764-44250-1-git-send-email-hverkuil@xs4all.nl>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Oops, I forgot to mention that patches 1-4 are unchanged from v1. Also,
if there are no comments about this driver, then I intend to make a pull
request on Monday.

Regards,

	Hans


On 05/13/15 09:22, Hans Verkuil wrote:
> From: Hans Verkuil <hans.verkuil@cisco.com>
> 
> Changes since v1:
> 
> - Fixed a lockdep bug in the alsa driver
> - Moved the DMA descriptor allocation/freeing to buf_init and buf_cleanup,
>   which is where it belongs.
> - Rebased to the latest media_tree master.
> 
> Hi all,
> 
> This driver is for the Cisco Cobalt card, which is a PCIe device with four
> HDMI inputs (adv7604) and optionally one fifth input (adv7842) or one output
> (adv7511).
> 
> This board is not for sale (sadly) but it is used internally for testing and
> prototyping. Many of the HDMI/Digital Video related features that I have added
> to V4L2 over the last few years have been prototyped using this driver and I
> am planning more new features based on this board.
> 
> During the ELC in San Jose a month back I discussed whether it would be OK to
> upstream this driver, even though the hardware is not for sale. Mauro had no
> problem with this and given the fact that this driver is a good starting
> point for similar HDMI hardware, and that this allows me to upstream new
> API additions showing them off in this driver (so ensuring that they are
> actually used somewhere), I've decided to go ahead with this.
> 
> This patch series starts off with a few improvements to other drivers:
> 
> The adv7842 now makes the output pixel port format configurable, just like
> its cousin adv7604. Note that there is one user of adv7842_platform_data:
> arch/blackfin/mach-bf609/boards/ezkit.c. However, this board code has been
> broken from the beginning and nobody noticed since gcc doesn't support the
> bf609. You need a custom toolchain to compile this 
> 
> I can't do anything about this, someone (Scott Jiang?) will need to fix
> this.
> 
> The next patch makes it possible to requeue buffers in vb2 from the driver.
> It's a very small change, but the cobalt driver uses that while it is
> waiting for a stable video signal.
> 
> The next patch is from Jean-Michel Hautbois which hasn't been merged yet
> since no driver used that event, but in the next patch I implement it.
> 
> The final patch is the cobalt driver itself.
> 
> Note that the m00* headers are generated from our FPGA code (slightly
> cleaned up by hand), which is why there are many lines > 80 columns.
> It makes sense in this case and it does not affect the readability, and
> I don't want to edit them too much since that would make it hard to handle
> when they are regenerated due to FPGA changes.
> 
> And there are also a lot of volatile __iomem pointers: the memory-mapped
> registers are written and read directly using struct pointers, so you really
> need volatile __iomem there.
> 
> In the near future I plan on added CEC support (once the CEC framework has
> been merged), colorspace conversion support, possibly deep color support and
> more. But let's try to get this driver in first.
> 
> Regards,
> 
> 	Hans
> 	
> Hans Verkuil (4):
>   adv7842: Make output format configurable through pad format operations
>   vb2: allow requeuing buffers while streaming
>   adv7604/adv7842: replace FMT_CHANGED by V4L2_DEVICE_NOTIFY_EVENT
>   cobalt: add new driver
> 
> jean-michel.hautbois@vodalys.com (1):
>   v4l2-subdev: allow subdev to send an event to the v4l2_device notify
>     function
> 
>  Documentation/video4linux/v4l2-framework.txt       |    4 +
>  MAINTAINERS                                        |    8 +
>  drivers/media/i2c/adv7604.c                        |   12 +-
>  drivers/media/i2c/adv7842.c                        |  280 ++++-
>  drivers/media/pci/Kconfig                          |    1 +
>  drivers/media/pci/Makefile                         |    1 +
>  drivers/media/pci/cobalt/Kconfig                   |   18 +
>  drivers/media/pci/cobalt/Makefile                  |    5 +
>  drivers/media/pci/cobalt/cobalt-alsa-main.c        |  162 +++
>  drivers/media/pci/cobalt/cobalt-alsa-pcm.c         |  603 ++++++++++
>  drivers/media/pci/cobalt/cobalt-alsa-pcm.h         |   22 +
>  drivers/media/pci/cobalt/cobalt-alsa.h             |   41 +
>  drivers/media/pci/cobalt/cobalt-cpld.c             |  341 ++++++
>  drivers/media/pci/cobalt/cobalt-cpld.h             |   29 +
>  drivers/media/pci/cobalt/cobalt-driver.c           |  821 +++++++++++++
>  drivers/media/pci/cobalt/cobalt-driver.h           |  377 ++++++
>  drivers/media/pci/cobalt/cobalt-flash.c            |  132 ++
>  drivers/media/pci/cobalt/cobalt-flash.h            |   29 +
>  drivers/media/pci/cobalt/cobalt-i2c.c              |  396 ++++++
>  drivers/media/pci/cobalt/cobalt-i2c.h              |   25 +
>  drivers/media/pci/cobalt/cobalt-irq.c              |  254 ++++
>  drivers/media/pci/cobalt/cobalt-irq.h              |   25 +
>  drivers/media/pci/cobalt/cobalt-omnitek.c          |  341 ++++++
>  drivers/media/pci/cobalt/cobalt-omnitek.h          |   62 +
>  drivers/media/pci/cobalt/cobalt-v4l2.c             | 1260 ++++++++++++++++++++
>  drivers/media/pci/cobalt/cobalt-v4l2.h             |   22 +
>  .../cobalt/m00233_video_measure_memmap_package.h   |  115 ++
>  .../pci/cobalt/m00235_fdma_packer_memmap_package.h |   44 +
>  .../media/pci/cobalt/m00389_cvi_memmap_package.h   |   59 +
>  .../media/pci/cobalt/m00460_evcnt_memmap_package.h |   44 +
>  .../pci/cobalt/m00473_freewheel_memmap_package.h   |   57 +
>  .../m00479_clk_loss_detector_memmap_package.h      |   53 +
>  .../m00514_syncgen_flow_evcnt_memmap_package.h     |   88 ++
>  drivers/media/v4l2-core/videobuf2-core.c           |   11 +-
>  include/media/adv7604.h                            |    1 -
>  include/media/adv7842.h                            |   92 +-
>  include/media/v4l2-subdev.h                        |    2 +
>  37 files changed, 5743 insertions(+), 94 deletions(-)
>  create mode 100644 drivers/media/pci/cobalt/Kconfig
>  create mode 100644 drivers/media/pci/cobalt/Makefile
>  create mode 100644 drivers/media/pci/cobalt/cobalt-alsa-main.c
>  create mode 100644 drivers/media/pci/cobalt/cobalt-alsa-pcm.c
>  create mode 100644 drivers/media/pci/cobalt/cobalt-alsa-pcm.h
>  create mode 100644 drivers/media/pci/cobalt/cobalt-alsa.h
>  create mode 100644 drivers/media/pci/cobalt/cobalt-cpld.c
>  create mode 100644 drivers/media/pci/cobalt/cobalt-cpld.h
>  create mode 100644 drivers/media/pci/cobalt/cobalt-driver.c
>  create mode 100644 drivers/media/pci/cobalt/cobalt-driver.h
>  create mode 100644 drivers/media/pci/cobalt/cobalt-flash.c
>  create mode 100644 drivers/media/pci/cobalt/cobalt-flash.h
>  create mode 100644 drivers/media/pci/cobalt/cobalt-i2c.c
>  create mode 100644 drivers/media/pci/cobalt/cobalt-i2c.h
>  create mode 100644 drivers/media/pci/cobalt/cobalt-irq.c
>  create mode 100644 drivers/media/pci/cobalt/cobalt-irq.h
>  create mode 100644 drivers/media/pci/cobalt/cobalt-omnitek.c
>  create mode 100644 drivers/media/pci/cobalt/cobalt-omnitek.h
>  create mode 100644 drivers/media/pci/cobalt/cobalt-v4l2.c
>  create mode 100644 drivers/media/pci/cobalt/cobalt-v4l2.h
>  create mode 100644 drivers/media/pci/cobalt/m00233_video_measure_memmap_package.h
>  create mode 100644 drivers/media/pci/cobalt/m00235_fdma_packer_memmap_package.h
>  create mode 100644 drivers/media/pci/cobalt/m00389_cvi_memmap_package.h
>  create mode 100644 drivers/media/pci/cobalt/m00460_evcnt_memmap_package.h
>  create mode 100644 drivers/media/pci/cobalt/m00473_freewheel_memmap_package.h
>  create mode 100644 drivers/media/pci/cobalt/m00479_clk_loss_detector_memmap_package.h
>  create mode 100644 drivers/media/pci/cobalt/m00514_syncgen_flow_evcnt_memmap_package.h
> 
