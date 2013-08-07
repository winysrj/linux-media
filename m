Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:53121 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751998Ab3HGWnT (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 7 Aug 2013 18:43:19 -0400
Received: from dyn3-82-128-186-228.psoas.suomi.net ([82.128.186.228] helo=localhost.localdomain)
	by mail.kapsi.fi with esmtpsa (TLS1.0:DHE_RSA_AES_256_CBC_SHA1:32)
	(Exim 4.72)
	(envelope-from <crope@iki.fi>)
	id 1V7CRp-0001oB-GK
	for linux-media@vger.kernel.org; Thu, 08 Aug 2013 01:43:17 +0300
Message-ID: <5202CD5D.1000509@iki.fi>
Date: Thu, 08 Aug 2013 01:42:37 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: LMML <linux-media@vger.kernel.org>
Subject: [GIT PULL 3.12] e4000 fixes
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The following changes since commit 1c26190a8d492adadac4711fe5762d46204b18b0:

   [media] exynos4-is: Correct colorspace handling at FIMC-LITE 
(2013-06-28 15:33:27 -0300)

are available in the git repository at:

   git://linuxtv.org/anttip/media_tree.git rtl2832u_e4000

for you to fetch changes up to 9b3fd8a3ff7ab8b02ef29fa17744323e786b4f2f:

   e4000: change remaining pr_warn to dev_warn (2013-07-26 13:00:02 +0300)

----------------------------------------------------------------
Antti Palosaari (4):
       e4000: implement DC offset correction
       e4000: use swap() macro
       e4000: make checkpatch.pl happy
       e4000: change remaining pr_warn to dev_warn

  drivers/media/tuners/e4000.c | 82 
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++----------------------
  drivers/media/tuners/e4000.h |  2 +-
  2 files changed, 61 insertions(+), 23 deletions(-)

-- 
http://palosaari.fi/
