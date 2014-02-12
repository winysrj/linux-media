Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:57196 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753640AbaBLTms (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 12 Feb 2014 14:42:48 -0500
Message-ID: <52FBCEB6.8010007@iki.fi>
Date: Wed, 12 Feb 2014 21:42:46 +0200
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: LMML <linux-media@vger.kernel.org>
CC: Dan Carpenter <dan.carpenter@oracle.com>
Subject: [GIT PULL] tda10071 changes
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The following changes since commit 37e59f876bc710d67a30b660826a5e83e07101ce:

   [media, edac] Change my email address (2014-02-07 08:03:07 -0200)

are available in the git repository at:

   git://linuxtv.org/anttip/media_tree.git tda10071

for you to fetch changes up to a47dd5674fda7c48d693cd785f48f92fcc20b8c9:

   tda10071: coding style issues (2014-02-12 20:17:33 +0200)

----------------------------------------------------------------
Antti Palosaari (2):
       tda10071: do not check tuner PLL lock on read_status()
       tda10071: coding style issues

Dan Carpenter (1):
       tda10071: remove a duplicative test

  drivers/media/dvb-frontends/tda10071.c | 68 
++++++++++++++++++++++++++++++++++++--------------------------------
  drivers/media/dvb-frontends/tda10071.h |  2 +-
  2 files changed, 37 insertions(+), 33 deletions(-)


-- 
http://palosaari.fi/
