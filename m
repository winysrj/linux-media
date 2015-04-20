Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx02.posteo.de ([89.146.194.165]:49205 "EHLO mx02.posteo.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750930AbbDTH1Y (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 20 Apr 2015 03:27:24 -0400
Date: Mon, 20 Apr 2015 09:27:20 +0200
From: Patrick Boettcher <patrick.boettcher@posteo.de>
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PULL] For 4.2 (or even 4.1?) add support for cx24120/Technisat
 SkyStar S2
Message-ID: <20150420092720.3cb092ba@dibcom294.coe.adi.dibcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

Would you please pull the following two patches for finally
mainlining the Technisat SkyStar S2 (and its frontend cx24120).

Ideally for 4.1, but I assume it is too late. So for 4.2.

Please also tell whether a pull-request is OK for you or whether you
prefer patches.

I'm based on the current media-tree's master. But can rebase myself
on anything you wish for your convenience.

Thanks,
--
Patrick.


The following changes since commit e183201b9e917daf2530b637b2f34f1d5afb934d:

  [media] uvcvideo: add support for VIDIOC_QUERY_EXT_CTRL (2015-04-10 10:29:27 -0300)

are available in the git repository at:

  https://github.com/pboettch/linux.git cx24120-v2

for you to fetch changes up to 3a6500da369a632c9fd405b1191dcbf5e5e07504:

  [media] cx24120: minor checkpatch fixes (2015-04-17 11:11:40 +0200)

----------------------------------------------------------------
Jemma Denson (1):
      [media] Add support for TechniSat Skystar S2

Patrick Boettcher (1):
      [media] cx24120: minor checkpatch fixes

 drivers/media/common/b2c2/Kconfig            |    1 +
 drivers/media/common/b2c2/flexcop-fe-tuner.c |   51 +-
 drivers/media/common/b2c2/flexcop-misc.c     |    1 +
 drivers/media/common/b2c2/flexcop-reg.h      |    1 +
 drivers/media/dvb-frontends/Kconfig          |    7 +
 drivers/media/dvb-frontends/Makefile         |    1 +
 drivers/media/dvb-frontends/cx24120.c        | 1574 ++++++++++++++++++++++++++
 drivers/media/dvb-frontends/cx24120.h        |   56 +
 8 files changed, 1685 insertions(+), 7 deletions(-)
 create mode 100644 drivers/media/dvb-frontends/cx24120.c
 create mode 100644 drivers/media/dvb-frontends/cx24120.h
