Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:45613 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030342AbbKECHu (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 4 Nov 2015 21:07:50 -0500
Received: from dyn3-82-128-185-10.psoas.suomi.net ([82.128.185.10] helo=localhost.localdomain)
	by mail.kapsi.fi with esmtpsa (TLS1.2:DHE_RSA_AES_128_CBC_SHA1:128)
	(Exim 4.80)
	(envelope-from <crope@iki.fi>)
	id 1Zu9xs-0008Ig-Tp
	for linux-media@vger.kernel.org; Thu, 05 Nov 2015 04:07:48 +0200
To: LMML <linux-media@vger.kernel.org>
From: Antti Palosaari <crope@iki.fi>
Subject: [GIT PULL 4.4] 2 small hackrf changes
Message-ID: <563AB9F4.2030301@iki.fi>
Date: Thu, 5 Nov 2015 04:07:48 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The following changes since commit 79f5b6ae960d380c829fb67d5dadcd1d025d2775:

   [media] c8sectpfe: Remove select on 
CONFIG_FW_LOADER_USER_HELPER_FALLBACK (2015-10-20 16:02:41 -0200)

are available in the git repository at:

   git://linuxtv.org/anttip/media_tree.git hackrf

for you to fetch changes up to 15b651b5e0a0f45a770ed1cd0f2b5511c8c103eb:

   hackrf: move RF gain ctrl enable behind module parameter (2015-10-24 
01:01:31 +0300)

----------------------------------------------------------------
Antti Palosaari (2):
       hackrf: fix possible null ptr on debug printing
       hackrf: move RF gain ctrl enable behind module parameter

  drivers/media/usb/hackrf/hackrf.c | 13 ++++++++++++-
  1 file changed, 12 insertions(+), 1 deletion(-)

-- 
http://palosaari.fi/
