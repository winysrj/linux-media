Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:55912 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752026AbaLWLDx (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 23 Dec 2014 06:03:53 -0500
Received: from dyn3-82-128-190-202.psoas.suomi.net ([82.128.190.202] helo=localhost.localdomain)
	by mail.kapsi.fi with esmtpsa (TLS1.0:DHE_RSA_AES_128_CBC_SHA1:16)
	(Exim 4.72)
	(envelope-from <crope@iki.fi>)
	id 1Y3NFm-00026V-VZ
	for linux-media@vger.kernel.org; Tue, 23 Dec 2014 13:03:50 +0200
Message-ID: <54994C16.5030603@iki.fi>
Date: Tue, 23 Dec 2014 13:03:50 +0200
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: LMML <linux-media@vger.kernel.org>
Subject: [GIT PULL] cx23885: Hauppauge WinTV-HVR5525
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The following changes since commit 654a731be1a0b6f606f3f3d12b50db08f2ae3c34:

   [media] media: s5p-mfc: use vb2_ops_wait_prepare/finish helper 
(2014-12-22 14:36:21 -0200)

are available in the git repository at:

   git://linuxtv.org/anttip/media_tree.git WinTV-HVR5525

for you to fetch changes up to 30a8af2761c4955ea0869b1baee5bc65fb6b949f:

   cx23885: Hauppauge WinTV-HVR5525 (2014-12-23 13:00:05 +0200)

----------------------------------------------------------------
Antti Palosaari (4):
       cx23885: do not unregister demod I2C client twice on error
       cx23885: correct some I2C client indentations
       cx23885: fix I2C scan printout
       cx23885: Hauppauge WinTV-HVR5525

  drivers/media/pci/cx23885/Kconfig         |   1 +
  drivers/media/pci/cx23885/cx23885-cards.c |  43 
+++++++++++++++++++++++++++++++++++++++++++
  drivers/media/pci/cx23885/cx23885-dvb.c   | 124 
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++--------------
  drivers/media/pci/cx23885/cx23885-i2c.c   |   4 ++--
  drivers/media/pci/cx23885/cx23885.h       |   1 +
  5 files changed, 157 insertions(+), 16 deletions(-)

-- 
http://palosaari.fi/
