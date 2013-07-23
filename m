Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:34684 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756618Ab3GWMhk (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 23 Jul 2013 08:37:40 -0400
Received: from dyn3-82-128-186-228.psoas.suomi.net ([82.128.186.228] helo=localhost.localdomain)
	by mail.kapsi.fi with esmtpsa (TLS1.0:DHE_RSA_AES_256_CBC_SHA1:32)
	(Exim 4.72)
	(envelope-from <crope@iki.fi>)
	id 1V1bqV-0007dt-QA
	for linux-media@vger.kernel.org; Tue, 23 Jul 2013 15:37:39 +0300
Message-ID: <51EE78EC.3090201@iki.fi>
Date: Tue, 23 Jul 2013 15:37:00 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: LMML <linux-media@vger.kernel.org>
Subject: [GIT PULL] dvb_usb_v2: fix Kconfig dependency when RC_CORE=m
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The following changes since commit 1c26190a8d492adadac4711fe5762d46204b18b0:

   [media] exynos4-is: Correct colorspace handling at FIMC-LITE 
(2013-06-28 15:33:27 -0300)

are available in the git repository at:

   git://linuxtv.org/anttip/media_tree.git kconfig_fix

for you to fetch changes up to 93d3452e72b2b5db15161a9f2d99949e55428caf:

   dvb-usb-v2: fix Kconfig dependency when RC_CORE=m (2013-07-23 
15:15:31 +0300)

----------------------------------------------------------------
Antti Palosaari (1):
       dvb-usb-v2: fix Kconfig dependency when RC_CORE=m

  drivers/media/usb/dvb-usb-v2/Kconfig | 2 +-
  1 file changed, 1 insertion(+), 1 deletion(-)

-- 
http://palosaari.fi/
