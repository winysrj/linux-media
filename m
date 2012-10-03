Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:44101 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753479Ab2JCJrI (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 3 Oct 2012 05:47:08 -0400
Message-ID: <506C0984.606@iki.fi>
Date: Wed, 03 Oct 2012 12:46:44 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@redhat.com>,
	linux-media <linux-media@vger.kernel.org>
CC: Hans-Frieder Vogt <hfvogt@gmx.net>,
	Dan Carpenter <dan.carpenter@oracle.com>
Subject: [GIT PULL FOR v3.7] small af9033 correction
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The following changes since commit 2425bb3d4016ed95ce83a90b53bd92c7f31091e4:

   em28xx: regression fix: use DRX-K sync firmware requests on em28xx 
(2012-10-02 17:15:22 -0300)

are available in the git repository at:

   git://linuxtv.org/anttip/media_tree.git for_v3.7_mauro-4

for you to fetch changes up to cac7edcf11c48801b40cb8bc32c545da506e8435:

   af9033: prevent unintended underflow (2012-10-03 12:36:53 +0300)

----------------------------------------------------------------
Hans-Frieder Vogt (1):
       af9033: prevent unintended underflow

  drivers/media/dvb-frontends/af9033.c | 16 +++++++++-------
  1 file changed, 9 insertions(+), 7 deletions(-)


-- 
http://palosaari.fi/

