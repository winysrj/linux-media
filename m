Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vc0-f171.google.com ([209.85.220.171]:36487 "EHLO
	mail-vc0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934703Ab3DHDBe (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 7 Apr 2013 23:01:34 -0400
Received: by mail-vc0-f171.google.com with SMTP id ha11so4483025vcb.16
        for <linux-media@vger.kernel.org>; Sun, 07 Apr 2013 20:01:33 -0700 (PDT)
Date: Sun, 7 Apr 2013 23:01:38 -0400
From: Michael Krufky <mkrufky@linuxtv.org>
To: linux-media@vger.kernel.org
Subject: [PULL] git://linuxtv.org/mkrufky/dvb demods
Message-ID: <20130407230138.170d1854@vujade>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The following changes since commit
53faa685fa7df0e12751eebbda30bc7e7bb5e71a:

  [media] siano: Fix array boundary at smscore_translate_msg()
  (2013-04-04 14:35:40 -0300)

are available in the git repository at:

  git://linuxtv.org/mkrufky/dvb demods

for you to fetch changes up to bc6c1391e498c649cb22c9654a2203b328cca253:

  cxd2820r_t2: Multistream support (MultiPLP) (2013-04-07 22:56:46
  -0400)

----------------------------------------------------------------
Evgeny Plehov (1):
      cxd2820r_t2: Multistream support (MultiPLP)

Mauro Carvalho Chehab (6):
      mb86a20s: Use a macro for the number of layers
      mb86a20s: fix audio sub-channel check
      mb86a20s: Use 'layer' instead of 'i' on all places
      mb86a20s: Fix estimate_rate setting
      mb86a20s: better name temp vars at mb86a20s_layer_bitrate()
      cx24123: improve precision when calculating symbol rate ratio

 drivers/media/dvb-frontends/cx24123.c       |   28 +++---------
 drivers/media/dvb-frontends/cxd2820r_core.c |    3 +-
 drivers/media/dvb-frontends/cxd2820r_t2.c   |   17 +++++++
 drivers/media/dvb-frontends/mb86a20s.c      |  213
 ++++++++++++++++++++++++++++++++++++++++++++-------------------------------------------
 4 files changed, 134 insertions(+), 127 deletions(-)
