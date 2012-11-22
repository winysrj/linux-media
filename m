Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:55309 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751790Ab2KVXIC (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 22 Nov 2012 18:08:02 -0500
Message-ID: <50AEB034.3040507@iki.fi>
Date: Fri, 23 Nov 2012 01:07:32 +0200
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@redhat.com>,
	linux-media <linux-media@vger.kernel.org>
Subject: [GIT PULL FOR 3.8] fc2580: write some registers conditionally
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The following changes since commit 304a0807a22852fe3095a62c24b25c4d0e16d003:

   [media] drivers/media/usb/hdpvr/hdpvr-core.c: fix error return code 
(2012-11-22 14:22:31 -0200)

are available in the git repository at:

   git://linuxtv.org/anttip/media_tree.git for_v3.8-fc2580

for you to fetch changes up to a91e0faf4074c4b160a33a5448cc1084d4fab419:

   fc2580: write some registers conditionally (2012-11-23 01:01:01 +0200)

----------------------------------------------------------------
Antti Palosaari (1):
       fc2580: write some registers conditionally

  drivers/media/tuners/fc2580.c | 61 
+++++++++++++++++++++++++++++++++++--------------------------
  1 file changed, 35 insertions(+), 26 deletions(-)



-- 
http://palosaari.fi/

