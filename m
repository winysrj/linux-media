Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:37486 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754311AbZH0AXm (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 26 Aug 2009 20:23:42 -0400
Date: Wed, 26 Aug 2009 21:23:31 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: Kevin Hilman <khilman@deeprootsystems.com>
Cc: "Karicheri, Muralidharan" <m-karicheri2@ti.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: davinci vs. v4l2: lots of conflicts in merge for linux-next
Message-ID: <20090826212331.30eb1655@pedra.chehab.org>
In-Reply-To: <636c5030908260200t1d2182a8oabf6b61d31b1849b@mail.gmail.com>
References: <636c5030908260200t1d2182a8oabf6b61d31b1849b@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Wed, 26 Aug 2009 12:00:11 +0300
Kevin Hilman <khilman@deeprootsystems.com> escreveu:

> OK, this has gotten a bit out of control, to the point where I cannot
> solve this myself.  This is partially due to me being on the road and
> not keeping a close enough eye on the various video patches.
> 
> I've pushed a new 'davinci-next' branch to davinci git[1] which is
> what I would like to make available for linux-next.  This includes all
> the patches from davinci git master which touch
> arch/arm/mach-davinci/*.
> 
> I then went to do a test a merge of the master branch of Mauro's
> linux-next tree, and there are lots of conflicts.  Some are trivial to
> resolve (the various I2C_BOARD_INFO() conflicts) but others are more
> difficult, and someone more familar with the video drivers should sort
> them out.
> 
> The two patches from davinci master that seem to be causing all the
> problems are:
> 
>   ARM: DaVinci: DM646x Video: Platform and board specific setup
>   davinci: video: restructuring to support vpif capture driver

> These cause the conflicts with the v4l2 next tree.  So, in
> davinci-next I've dropped these two patches.

Hmm... here, I got a different set of patches...

I've created a quilt tree with the DaVinci patches I have here:
	http://linuxtv.org/downloads/patches-davinci/

There are 3 patches touching arch/arm:

$ grep -l arch/arm *
arch_arm_mach_davinci_platform_and_board_specific_setup_for_dm646x_evm.patch
v4l_dvb_dm355_platform_changes_for_vpfe_capture_driver.patch
v4l_dvb_dm6446_platform_changes_for_vpfe_capture_driver.patch

All those three files touches just arch/arm files:

$ diffstat -p1 `grep -l arch/arm *`
 arch/arm/mach-davinci/board-dm355-evm.c     |   76 ++++++++++++++++-
 arch/arm/mach-davinci/board-dm644x-evm.c    |   72 ++++++++++++++++
 arch/arm/mach-davinci/board-dm646x-evm.c    |  122 ++++++++++++++++++++++++++++
 arch/arm/mach-davinci/dm355.c               |   83 +++++++++++++++++++
 arch/arm/mach-davinci/dm644x.c              |   56 ++++++++++++
 arch/arm/mach-davinci/dm646x.c              |   62 ++++++++++++++
 arch/arm/mach-davinci/include/mach/dm355.h  |    2
 arch/arm/mach-davinci/include/mach/dm644x.h |    2
 arch/arm/mach-davinci/include/mach/dm646x.h |   24 +++++
 arch/arm/mach-davinci/include/mach/mux.h    |    9 ++
 10 files changed, 503 insertions(+), 5 deletions(-)

If I move those tree files out, the remaining ones are touching only on
drivers/media and include/media:

$ diffstat -p1 *
 drivers/media/video/Kconfig                    |   71
 drivers/media/video/Makefile                   |    4
 drivers/media/video/davinci/Makefile           |   15
 drivers/media/video/davinci/ccdc_hw_device.h   |  110 +
 drivers/media/video/davinci/dm355_ccdc.c       |  978 +++++++++++
 drivers/media/video/davinci/dm355_ccdc_regs.h  |  310 +++
 drivers/media/video/davinci/dm644x_ccdc.c      |  878 ++++++++++
 drivers/media/video/davinci/dm644x_ccdc_regs.h |  145 +
 drivers/media/video/davinci/vpfe_capture.c     | 2124 +++++++++++++++++++++++++
 drivers/media/video/davinci/vpif.c             |  234 ++
 drivers/media/video/davinci/vpif.h             |  632 +++++++
 drivers/media/video/davinci/vpif_display.c     | 1697 +++++++++++++++++++
 drivers/media/video/davinci/vpif_display.h     |  175 ++
 drivers/media/video/davinci/vpss.c             |  301 +++
 drivers/media/video/tvp514x.c                  | 1150 +++++--------
 drivers/media/video/tvp514x_regs.h             |   10
 include/media/davinci/ccdc_types.h             |   43
 include/media/davinci/dm355_ccdc.h             |  321 +++
 include/media/davinci/dm644x_ccdc.h            |  184 ++
 include/media/davinci/vpfe_capture.h           |  198 ++
 include/media/davinci/vpfe_types.h             |   51
 include/media/davinci/vpss.h                   |   69
 include/media/tvp514x.h                        |    4

> 
> 
> I think the way to fix this is for someone to take all the board
> changes from the v4l2 tree and rebase them on top of my davinci-next,
> dropping them from v4l2 next. I'll then merge them into davinci-next,
> and this should make the two trees merge properly in linux-next.
> 
> We need to get this sorted out soon so that they can be merged for the
> next merge window.
> 
> Going forward, I would prefer that all changes to arch/arm/* stuff go
> through davinci git and all drivers/* stuff goes through V4L2.  This
> will avoid this kind of overlap/conflict in the future since DaVinci
> core code is going through lots of changes.

Agreed. I dropped the 3 arch patches from my tree:
	http://linuxtv.org/downloads/patches-davinci/arch_arm_mach_davinci_platform_and_board_specific_setup_for_dm646x_evm.patch
	http://linuxtv.org/downloads/patches-davinci/v4l_dvb_dm355_platform_changes_for_vpfe_capture_driver.patch
	http://linuxtv.org/downloads/patches-davinci/v4l_dvb_dm6446_platform_changes_for_vpfe_capture_driver.patch

Could you please check those 3 patches and see what's missing on your tree?

That's said, we need to make sure that Stephen will merge both trees, otherwise
compilation will break for DaVinci. As the Makefiles are the last ones on my
tree, provided that I merge the DaVinci patches after you, we shouldn't have
troubles upstream.

P. S. I've removed DaVinci ML, as it is a subscription-only list and I'm not subscribed there.
> 
> Kevin
> 
> [1] git://git.kernel.org/pub/scm/linux/kernel/git/khilman/linux-davinci.git


-- 

Cheers,
Mauro
