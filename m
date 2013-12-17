Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:57828 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752026Ab3LQAco (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 16 Dec 2013 19:32:44 -0500
Received: from dyn3-82-128-185-139.psoas.suomi.net ([82.128.185.139] helo=localhost.localdomain)
	by mail.kapsi.fi with esmtpsa (TLS1.0:DHE_RSA_AES_256_CBC_SHA1:32)
	(Exim 4.72)
	(envelope-from <crope@iki.fi>)
	id 1VsiaZ-0007jX-13
	for linux-media@vger.kernel.org; Tue, 17 Dec 2013 02:32:43 +0200
Message-ID: <52AF9BAA.1090305@iki.fi>
Date: Tue, 17 Dec 2013 02:32:42 +0200
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: LMML <linux-media@vger.kernel.org>
Subject: [GIT PULL 3.13] new RTL2832U USB ID
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

As that is simple ID addition it should be possible to send RC Kernel 
3.13 at that late.

Antti

The following changes since commit 675722b0e3917c6c917f1aa5f6d005cd3a0479f5:

   Merge branch 'upstream-fixes' into patchwork (2013-12-13 05:04:00 -0200)

are available in the git repository at:


   git://linuxtv.org/anttip/media_tree.git rtl28xxu_id

for you to fetch changes up to 702e94fc1bd1475428014710cd93620d6d8400f8:

   rtl28xxu: Add USB IDs for Winfast DTV Dongle Mini-D (2013-12-17 
02:24:17 +0200)

----------------------------------------------------------------
Robert Backhaus (1):
       rtl28xxu: Add USB IDs for Winfast DTV Dongle Mini-D

  drivers/media/dvb-core/dvb-usb-ids.h    | 1 +
  drivers/media/usb/dvb-usb-v2/rtl28xxu.c | 2 ++
  2 files changed, 3 insertions(+)


-- 
http://palosaari.fi/
