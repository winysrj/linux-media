Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:37849 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750717Ab1IWR03 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 23 Sep 2011 13:26:29 -0400
Received: by fxe4 with SMTP id 4so4023942fxe.19
        for <linux-media@vger.kernel.org>; Fri, 23 Sep 2011 10:26:28 -0700 (PDT)
To: Mauro Chehab <mchehab@infradead.org>
Subject: [GIT PATCHES FOR 3.2] fix type error in cx23885 and  altera-stapl move out from staging
Cc: linux-media@vger.kernel.org, Abylai Ospan <aospan@netup.ru>
From: "Igor M. Liplianin" <liplianin@me.by>
Date: Fri, 23 Sep 2011 20:26:31 +0300
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201109232026.31162.liplianin@me.by>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The following changes since commit 3a7a62378be538944ff00904b8e0b795fe16609a:

  [media] ati_remote: update Kconfig description (2011-09-22 10:55:10 -0300)

are available in the git repository at:
  http://linuxtv.org/git/liplianin/media_tree.git netup_patches

Igor M. Liplianin (2):
      cx23885: fix type error
      altera-stapl: it is time to move out from staging

 drivers/media/video/cx23885/Kconfig                |    2 +-
 drivers/media/video/cx23885/cx23885-cards.c        |    2 +-
 drivers/misc/Kconfig                               |    1 +
 drivers/misc/Makefile                              |    1 +
 drivers/{staging => misc}/altera-stapl/Kconfig     |    2 +
 drivers/misc/altera-stapl/Makefile                 |    3 ++
 .../{staging => misc}/altera-stapl/altera-comp.c   |    0
 .../{staging => misc}/altera-stapl/altera-exprt.h  |    0
 .../{staging => misc}/altera-stapl/altera-jtag.c   |    2 +-
 .../{staging => misc}/altera-stapl/altera-jtag.h   |    0
 .../{staging => misc}/altera-stapl/altera-lpt.c    |    0
 drivers/{staging => misc}/altera-stapl/altera.c    |   35 +++++++------------
 drivers/staging/Kconfig                            |    2 -
 drivers/staging/Makefile                           |    1 -
 drivers/staging/altera-stapl/Makefile              |    3 --
 .../staging/altera-stapl => include/misc}/altera.h |    0
 16 files changed, 23 insertions(+), 31 deletions(-)
 rename drivers/{staging => misc}/altera-stapl/Kconfig (77%)
 create mode 100644 drivers/misc/altera-stapl/Makefile
 rename drivers/{staging => misc}/altera-stapl/altera-comp.c (100%)
 rename drivers/{staging => misc}/altera-stapl/altera-exprt.h (100%)
 rename drivers/{staging => misc}/altera-stapl/altera-jtag.c (99%)
 rename drivers/{staging => misc}/altera-stapl/altera-jtag.h (100%)
 rename drivers/{staging => misc}/altera-stapl/altera-lpt.c (100%)
 rename drivers/{staging => misc}/altera-stapl/altera.c (99%)
 delete mode 100644 drivers/staging/altera-stapl/Makefile
 rename {drivers/staging/altera-stapl => include/misc}/altera.h (100%)
