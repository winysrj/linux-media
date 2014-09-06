Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:34811 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751909AbaIFXbE (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 6 Sep 2014 19:31:04 -0400
Message-ID: <540B9932.5080008@iki.fi>
Date: Sun, 07 Sep 2014 02:30:58 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: LMML <linux-media@vger.kernel.org>
CC: Olli Salonen <olli.salonen@iki.fi>
Subject: [GIT PULL] si2168 and si2157 firmware download improvements
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The following changes since commit 89fffac802c18caebdf4e91c0785b522c9f6399a:

   [media] drxk_hard: fix bad alignments (2014-09-03 19:19:18 -0300)

are available in the git repository at:

   git://linuxtv.org/anttip/media_tree.git silabs_prevent_fw_dl

for you to fetch changes up to 5d8440f3f7ac82942df1afaa28e46174dd310e69:

   si2168: avoid firmware loading if it has been loaded previously 
(2014-09-07 02:28:43 +0300)

----------------------------------------------------------------
Olli Salonen (3):
       si2157: change command for sleep
       si2157: avoid firmware loading if it has been loaded previously
       si2168: avoid firmware loading if it has been loaded previously

  drivers/media/dvb-frontends/si2168.c      | 31 
++++++++++++++++++++++++++++---
  drivers/media/dvb-frontends/si2168_priv.h |  1 +
  drivers/media/tuners/si2157.c             | 18 +++++++++++++-----
  drivers/media/tuners/si2157_priv.h        |  1 +
  4 files changed, 43 insertions(+), 8 deletions(-)

-- 
http://palosaari.fi/
