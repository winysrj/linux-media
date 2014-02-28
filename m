Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qa0-f42.google.com ([209.85.216.42]:41933 "EHLO
	mail-qa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751950AbaB1CbN (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 27 Feb 2014 21:31:13 -0500
Received: by mail-qa0-f42.google.com with SMTP id k15so104618qaq.1
        for <linux-media@vger.kernel.org>; Thu, 27 Feb 2014 18:31:12 -0800 (PST)
Date: Thu, 27 Feb 2014 21:31:09 -0500
From: Michael Krufky <mkrufky@linuxtv.org>
To: linux-media@vger.kernel.org
Cc: m.chehab@samsung.com
Subject: [GIT PULL] feb27 - git://linuxtv.org/mkrufky/dvb dvb
Message-ID: <20140227213109.70696707@vujade>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I added two patches to this branch - This request supersedes yesterday's
pull request.

The following changes since commit
efab6b6a6ea9364ececb955f69a9d3ffc6b782a1:

  [media] vivi: queue_setup improvements (2014-02-24 10:59:15 -0300)

are available in the git repository at:

  git://linuxtv.org/mkrufky/dvb dvb

for you to fetch changes up to 121be88a350f841083c9a84aab5ca06dea49736d:

  au0828: rework GPIO management for HVR-950q. (2014-02-27 21:19:18
  -0500)

----------------------------------------------------------------
Alexander Shiyan (1):
      stb6100: fix buffer length check in stb6100_write_reg_range()

Dan Carpenter (1):
      stv0900: remove an unneeded check

Devin Heitmueller (1):
      au0828: rework GPIO management for HVR-950q.

Heinrich Schuchardt (1):
      ds3000: fix reading array out of bound in ds3000_read_snr

Malcolm Priestley (2):
      m88rs2000: add caps FE_CAN_INVERSION_AUTO
      m88rs2000: prevent frontend crash on continuous transponder scans

 drivers/media/dvb-frontends/ds3000.c     |  2 +-
 drivers/media/dvb-frontends/m88rs2000.c  | 19 ++++++++++++++++++-
 drivers/media/dvb-frontends/stb6100.c    |  2 +-
 drivers/media/dvb-frontends/stv0900_sw.c |  2 +-
 drivers/media/usb/au0828/au0828-cards.c  | 21 ++++++++++++++-------
 5 files changed, 35 insertions(+), 11 deletions(-)
