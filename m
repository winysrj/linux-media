Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qa0-f49.google.com ([209.85.216.49]:59453 "EHLO
	mail-qa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751114AbaBZCtw (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 25 Feb 2014 21:49:52 -0500
Received: by mail-qa0-f49.google.com with SMTP id j7so320018qaq.36
        for <linux-media@vger.kernel.org>; Tue, 25 Feb 2014 18:49:52 -0800 (PST)
Date: Tue, 25 Feb 2014 21:49:47 -0500
From: Michael Krufky <mkrufky@linuxtv.org>
To: linux-media@vger.kernel.org
Cc: m.chehab@samsung.com
Subject: [GIT PULL] git://linuxtv.org/mkrufky/dvb dvb
Message-ID: <20140225214947.1122caa0@vujade>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The following changes since commit
efab6b6a6ea9364ececb955f69a9d3ffc6b782a1:

  [media] vivi: queue_setup improvements (2014-02-24 10:59:15 -0300)

are available in the git repository at:

  git://linuxtv.org/mkrufky/dvb dvb

for you to fetch changes up to e9abfeefb9d35229669f4d899832070ee623058e:

  stb6100: fix buffer length check in stb6100_write_reg_range()
  (2014-02-25 21:41:14 -0500)

----------------------------------------------------------------
Alexander Shiyan (1):
      stb6100: fix buffer length check in stb6100_write_reg_range()

Dan Carpenter (1):
      stv0900: remove an unneeded check

Malcolm Priestley (2):
      m88rs2000: add caps FE_CAN_INVERSION_AUTO
      m88rs2000: prevent frontend crash on continuous transponder scans

 drivers/media/dvb-frontends/m88rs2000.c  | 19 ++++++++++++++++++-
 drivers/media/dvb-frontends/stb6100.c    |  2 +-
 drivers/media/dvb-frontends/stv0900_sw.c |  2 +-
 3 files changed, 20 insertions(+), 3 deletions(-)
