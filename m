Return-path: <mchehab@gaivota>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:44901 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751866Ab0KFVde (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 6 Nov 2010 17:33:34 -0400
From: Arnaud Lacombe <lacombar@gmail.com>
To: linux-kbuild@vger.kernel.org, linux-media@vger.kernel.org
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Michal Marek <mmarek@suse.cz>,
	Arnaud Lacombe <lacombar@gmail.com>
Subject: [PATCH 0/5] Re: REGRESSION: Re: [GIT] kconfig rc fixes
Date: Sat,  6 Nov 2010 17:30:22 -0400
Message-Id: <1289079027-3037-1-git-send-email-lacombar@gmail.com>
In-Reply-To: <4CD300AC.3010708@redhat.com>
References: <4CD300AC.3010708@redhat.com>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

Hi,

This should do the job.

A.

Arnaud Lacombe (5):
  kconfig: add an option to determine a menu's visibility
  kconfig: regen parser
  Revert "i2c: Fix Kconfig dependencies"
  media/video: convert Kconfig to use the menu's `visible' keyword
  i2c/algos: convert Kconfig to use the menu's `visible' keyword

 drivers/i2c/Kconfig                  |    3 +-
 drivers/i2c/algos/Kconfig            |   14 +-
 drivers/media/video/Kconfig          |    2 +-
 scripts/kconfig/expr.h               |    1 +
 scripts/kconfig/lkc.h                |    1 +
 scripts/kconfig/menu.c               |   11 +
 scripts/kconfig/zconf.gperf          |    1 +
 scripts/kconfig/zconf.hash.c_shipped |  122 ++++----
 scripts/kconfig/zconf.tab.c_shipped  |  570 +++++++++++++++++----------------
 scripts/kconfig/zconf.y              |   21 +-
 10 files changed, 393 insertions(+), 353 deletions(-)

-- 
1.7.2.30.gc37d7.dirty

