Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vc0-f179.google.com ([209.85.220.179]:52985 "EHLO
	mail-vc0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934511Ab3DHBY3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 7 Apr 2013 21:24:29 -0400
Received: by mail-vc0-f179.google.com with SMTP id gf12so4591796vcb.10
        for <linux-media@vger.kernel.org>; Sun, 07 Apr 2013 18:24:28 -0700 (PDT)
Date: Sun, 7 Apr 2013 21:24:32 -0400
From: Michael Krufky <mkrufky@linuxtv.org>
To: linux-media@vger.kernel.org
Subject: [PULL] git://linuxtv.org/mkrufky/dvb demods
Message-ID: <20130407212432.0e89fb5b@vujade>
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

for you to fetch changes up to 15222aeea8e40ece4785cae1e82968fc906ddd78:

  cx24123: improve precision when calculating symbol rate ratio
  (2013-04-07 20:11:53 -0400)

----------------------------------------------------------------
Mauro Carvalho Chehab (6):
      mb86a20s: Use a macro for the number of layers
      mb86a20s: fix audio sub-channel check
      mb86a20s: Use 'layer' instead of 'i' on all places
      mb86a20s: Fix estimate_rate setting
      mb86a20s: better name temp vars at mb86a20s_layer_bitrate()
      cx24123: improve precision when calculating symbol rate ratio

 drivers/media/dvb-frontends/cx24123.c  |   28 +++---------
 drivers/media/dvb-frontends/mb86a20s.c |  213
 +++++++++++++++++++++++++++++++++++++++++++++++---------------------------------------------
 2 files changed, 115 insertions(+), 126 deletions(-)
