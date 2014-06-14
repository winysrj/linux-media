Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:39845 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754729AbaFNP3V (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 14 Jun 2014 11:29:21 -0400
Received: from avalon.localnet (unknown [91.178.211.37])
	by perceval.ideasonboard.com (Postfix) with ESMTPSA id 5530235A3C
	for <linux-media@vger.kernel.org>; Sat, 14 Jun 2014 17:28:45 +0200 (CEST)
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Subject: [GIT PULL FOR v3.16] OMAP4 ISS fix
Date: Sat, 14 Jun 2014 17:29:57 +0200
Message-ID: <4297622.KRtW0DhXJI@avalon>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

Please pull the following fix for v3.16. It fixes a build breakage due to the 
OMAP4 ISS driver.

The following changes since commit f7a27ff1fb77e114d1059a5eb2ed1cffdc508ce8:

  [media] xc5000: delay tuner sleep to 5 seconds (2014-05-25 17:50:16 -0300)

are available in the git repository at:

  git://linuxtv.org/pinchartl/media.git omap4iss/next

for you to fetch changes up to 00084ddf4f7d0d83007f179a4aedccabcdef69a4:

  staging: tighten omap4iss dependencies (2014-06-14 17:28:01 +0200)

----------------------------------------------------------------
Arnd Bergmann (1):
      staging: tighten omap4iss dependencies

 drivers/staging/media/omap4iss/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

-- 
Regards,

Laurent Pinchart

