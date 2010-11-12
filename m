Return-path: <mchehab@pedra>
Received: from lo.gmane.org ([80.91.229.12]:48812 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752902Ab0KLOoF (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 12 Nov 2010 09:44:05 -0500
Received: from list by lo.gmane.org with local (Exim 4.69)
	(envelope-from <gldv-linux-media@m.gmane.org>)
	id 1PGurC-0000GR-Is
	for linux-media@vger.kernel.org; Fri, 12 Nov 2010 15:44:02 +0100
Received: from 193.160.199.2 ([193.160.199.2])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Fri, 12 Nov 2010 15:44:02 +0100
Received: from bjorn by 193.160.199.2 with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Fri, 12 Nov 2010 15:44:02 +0100
To: linux-media@vger.kernel.org
From: =?utf-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>
Subject: [GIT PATCHES FOR 2.6.38] mantis for_2.6.38
Date: Fri, 12 Nov 2010 15:43:42 +0100
Message-ID: <874obmiov5.fsf@nemi.mork.no>
References: <4CBB689F.1070100@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Marko Ristola <marko.ristola@kolumbus.fi>,
	Manu Abraham <abraham.manu@gmail.com>,
	Ben Hutchings <ben@decadent.org.uk>,
	Niklas Claesson <nicke.claesson@gmail.com>,
	Tuxoholic <tuxoholic@hotmail.de>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hello, 

I've been waiting for this list of patchwork patches to be included for
quite a while, and have now taken the liberty to clean them up as
necessary and add them to a git tree, based on the current media_tree
for_v2.6.38 branch, with exceptions as noted below:

> 		== mantis patches - Waiting for Manu Abraham <abraham.manu@gmail.com> == 
>
> Apr,15 2010: [5/8] ir-core: convert mantis from ir-functions.c                      http://patchwork.kernel.org/patch/92961   David HÃ¤rdeman <david@hardeman.nu>

already applied as commit f0bdee26a2dc904c463bae1c2ae9ad06f97f100d

> Jun,20 2010: Mantis DMA transfer cleanup, fixes data corruption and a race, improve http://patchwork.kernel.org/patch/107036  Marko Ristola <marko.ristola@kolumbus.fi>

duplicate of http://patchwork.kernel.org/patch/118173

> Jun,20 2010: [2/2] DVB/V4L: mantis: remove unused files                             http://patchwork.kernel.org/patch/107062  BjÃ¸rn Mork <bjorn@mork.no>
> Jun,20 2010: mantis: use dvb_attach to avoid double dereferencing on module removal http://patchwork.kernel.org/patch/107063  BjÃ¸rn Mork <bjorn@mork.no>
> Jun,21 2010: Mantis, hopper: use MODULE_DEVICE_TABLE use the macro to make modules  http://patchwork.kernel.org/patch/107147  Manu Abraham <abraham.manu@gmail.com>
> Jul, 3 2010: mantis: Rename gpio_set_bits to mantis_gpio_set_bits                   http://patchwork.kernel.org/patch/109972  Ben Hutchings <ben@decadent.org.uk>
> Jul, 8 2010: Mantis DMA transfer cleanup, fixes data corruption and a race, improve http://patchwork.kernel.org/patch/110909  Marko Ristola <marko.ristola@kolumbus.fi>

another duplicate of http://patchwork.kernel.org/patch/118173

> Jul, 9 2010: Mantis: append tasklet maintenance for DVB stream delivery             http://patchwork.kernel.org/patch/111090  Marko Ristola <marko.ristola@kolumbus.fi>
> Jul,10 2010: Mantis driver patch: use interrupt for I2C traffic instead of busy reg http://patchwork.kernel.org/patch/111245  Marko Ristola <marko.ristola@kolumbus.fi>
> Jul,19 2010: Twinhan DTV Ter-CI (3030 mantis)                                       http://patchwork.kernel.org/patch/112708  Niklas Claesson <nicke.claesson@gmail.com>

Missing Signed-off-by, and I'm also a bit confused wrt what the patch
actually is.  Needs further cleanup.

> Aug, 7 2010: Refactor Mantis DMA transfer to deliver 16Kb TS data per interrupt     http://patchwork.kernel.org/patch/118173  Marko Ristola <marko.ristola@kolumbus.fi>
> Oct,10 2010: [v2] V4L/DVB: faster DVB-S lock for mantis cards using stb0899 demod   http://patchwork.kernel.org/patch/244201  Tuxoholic <tuxoholic@hotmail.de>



The following changes since commit 

af9f14f7fc31f0d7b7cdf8f7f7f15a3c3794aea3    [media] IR: add tv power scancode to rc6 mce keymap

are available in the git repository at:

  git://git.mork.no/mantis.git for_2.6.38

Ben Hutchings (1):
      V4L/DVB: mantis: Rename gpio_set_bits to mantis_gpio_set_bits

Bjørn Mork (2):
      V4L/DVB: mantis: use dvb_attach to avoid double dereferencing on module removal
      V4L/DVB/V4L: mantis: remove unused files

Manu Abraham (1):
      Mantis, hopper: use MODULE_DEVICE_TABLE use the macro to make modules auto-loadable

Marko Ristola (3):
      V4L/DVB: mantis: append tasklet maintenance for DVB stream delivery
      Refactor Mantis DMA transfer to deliver 16Kb TS data per interrupt
      media: mantis: use interrupt for I2C traffic instead of busy registry polling

tuxoholic@hotmail.de (1):
      V4L/DVB: faster DVB-S lock for mantis cards using stb0899 demod

 drivers/media/dvb/frontends/stb0899_algo.c |   33 +++--
 drivers/media/dvb/mantis/hopper_cards.c    |    4 +-
 drivers/media/dvb/mantis/hopper_vp3028.c   |    6 +-
 drivers/media/dvb/mantis/mantis_cards.c    |   18 ++-
 drivers/media/dvb/mantis/mantis_common.h   |    9 +-
 drivers/media/dvb/mantis/mantis_core.c     |  235 ----------------------------
 drivers/media/dvb/mantis/mantis_core.h     |   57 -------
 drivers/media/dvb/mantis/mantis_dma.c      |   92 ++++-------
 drivers/media/dvb/mantis/mantis_dvb.c      |   17 ++-
 drivers/media/dvb/mantis/mantis_i2c.c      |  128 ++++++++++++----
 drivers/media/dvb/mantis/mantis_ioc.c      |    4 +-
 drivers/media/dvb/mantis/mantis_ioc.h      |    2 +-
 drivers/media/dvb/mantis/mantis_vp1033.c   |    2 +-
 drivers/media/dvb/mantis/mantis_vp1034.c   |   10 +-
 drivers/media/dvb/mantis/mantis_vp1041.c   |    6 +-
 drivers/media/dvb/mantis/mantis_vp2033.c   |    5 +-
 drivers/media/dvb/mantis/mantis_vp2040.c   |    4 +-
 drivers/media/dvb/mantis/mantis_vp3030.c   |    8 +-
 18 files changed, 208 insertions(+), 432 deletions(-)


Note that some of these patches will trigger checkpatch long line
warnings due to deliberate choices. I have no strong feelings about
reformatting them, but I believe the review is easier the less I have
changed the original patchworks patch...


I sincerely hope this will make your job easier.  Thanks for reviewing,


Bjørn

