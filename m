Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qc0-f174.google.com ([209.85.216.174]:48637 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754091Ab3JCMSK (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 3 Oct 2013 08:18:10 -0400
Received: by mail-qc0-f174.google.com with SMTP id n9so1546823qcw.33
        for <linux-media@vger.kernel.org>; Thu, 03 Oct 2013 05:18:10 -0700 (PDT)
Date: Thu, 3 Oct 2013 08:18:05 -0400
From: Michael Krufky <mkrufky@linuxtv.org>
To: linux-media@vger.kernel.org
Cc: m.chehab@samsung.com, Luis Alves <ljalvs@gmail.com>,
	Antti Palosaari <crope@iki.fi>
Subject: [GIT PULL] Adding support for the cx24117 frontend with tbs6980 or
 tbs6981
Message-ID: <20131003081805.379ad2ad@vujade>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The following changes since commit
ed94e614c82b4d41d92c82052e915d99614d8b5c:

  dib9000: fix typo in spelling the word empty (2013-09-30 12:24:48
  -0400)

are available in the git repository at:

  git://linuxtv.org/mkrufky/dvb cx24117

for you to fetch changes up to 5dfa5d28c8e636ddb6468defc7e5e7ed07af6945:

  cx24117: use hybrid_tuner_request/release_state to share state
  between multiple instances (2013-10-03 07:39:17 -0400)

----------------------------------------------------------------
Luis Alves (3):
      dvb: add cx24117 frontend
      cx23885: add support for cx24117 with tbs6980 or tbs6981
      cx24117: use hybrid_tuner_request/release_state to share state between multiple instances

 drivers/media/dvb-frontends/Kconfig       |    7 +
 drivers/media/dvb-frontends/Makefile      |    1 +
 drivers/media/dvb-frontends/cx24117.c     | 1651 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 drivers/media/dvb-frontends/cx24117.h     |   47 +++++
 drivers/media/pci/cx23885/Kconfig         |    1 +
 drivers/media/pci/cx23885/cx23885-cards.c |   67 +++++++
 drivers/media/pci/cx23885/cx23885-dvb.c   |   24 +++
 drivers/media/pci/cx23885/cx23885-input.c |   12 ++
 drivers/media/pci/cx23885/cx23885.h       |    2 + 9 files changed,
 1812 insertions(+) create mode 100644
 drivers/media/dvb-frontends/cx24117.c create mode 100644
 drivers/media/dvb-frontends/cx24117.h
