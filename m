Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:34585 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751485AbbJJQq4 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 10 Oct 2015 12:46:56 -0400
Received: from [82.128.187.23] (helo=localhost.localdomain)
	by mail.kapsi.fi with esmtpsa (TLS1.2:DHE_RSA_AES_128_CBC_SHA1:128)
	(Exim 4.80)
	(envelope-from <crope@iki.fi>)
	id 1ZkxIN-00062v-0j
	for linux-media@vger.kernel.org; Sat, 10 Oct 2015 19:46:55 +0300
To: LMML <linux-media@vger.kernel.org>
From: Antti Palosaari <crope@iki.fi>
Subject: [GIT PULL STABLE] rtl28xxu bugfix
Message-ID: <561940FE.4050406@iki.fi>
Date: Sat, 10 Oct 2015 19:46:54 +0300
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The following changes since commit ac4033e02a54a1dd3b22364d392ffe3da5d09a5f:

   [media] atmel-isi: parse the DT parameters for vsync/hsync/pixclock 
polarity (2015-09-25 17:42:12 -0300)

are available in the git repository at:

   git://linuxtv.org/anttip/media_tree.git rtl28xxu_bugfix

for you to fetch changes up to 24df7254d49dc6edd653b3fb412192a9696b92c7:

   rtl28xxu: fix control message flaws (2015-10-08 03:49:06 +0300)

----------------------------------------------------------------
Antti Palosaari (1):
       rtl28xxu: fix control message flaws

  drivers/media/usb/dvb-usb-v2/rtl28xxu.c | 15 +++++++++++++--
  drivers/media/usb/dvb-usb-v2/rtl28xxu.h |  2 +-
  2 files changed, 14 insertions(+), 3 deletions(-)

-- 
http://palosaari.fi/
