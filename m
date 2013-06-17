Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qc0-f178.google.com ([209.85.216.178]:52893 "EHLO
	mail-qc0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751885Ab3FQXgl (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 17 Jun 2013 19:36:41 -0400
Received: by mail-qc0-f178.google.com with SMTP id c11so1945786qcv.37
        for <linux-media@vger.kernel.org>; Mon, 17 Jun 2013 16:36:41 -0700 (PDT)
Date: Mon, 17 Jun 2013 19:36:55 -0400
From: Michael Krufky <mkrufky@linuxtv.org>
To: linux-media@vger.kernel.org
Cc: mchehab@redhat.com
Subject: [GIT PULL] git://linuxtv.org/mkrufky/tuners r820t
Message-ID: <20130617193655.76af2d32@vujade>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The following changes since commit
e049ca5e854263c821a15c0e25fe2ae202c365e1:

  [media] staging/media: lirc_imon: fix leaks in imon_probe()
  (2013-06-17 15:52:20 -0300)

are available in the git repository at:

  git://linuxtv.org/mkrufky/tuners r820t

for you to fetch changes up to a02dfce109f6dcddf1bfd973f9b3000cd74c3590:

  r820t: fix imr calibration (2013-06-17 19:32:45 -0400)

----------------------------------------------------------------
Gianluca Gennari (3):
      r820t: remove redundant initializations in r820t_attach()
      r820t: avoid potential memcpy buffer overflow in shadow_store()
      r820t: fix imr calibration

 drivers/media/tuners/r820t.c | 17 +++++++----------
 1 file changed, 7 insertions(+), 10 deletions(-)
