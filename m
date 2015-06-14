Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:33811 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751320AbbFNKkG (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 14 Jun 2015 06:40:06 -0400
Received: from avalon.localnet (a91-152-136-245.elisa-laajakaista.fi [91.152.136.245])
	by galahad.ideasonboard.com (Postfix) with ESMTPSA id CB5A4203AA
	for <linux-media@vger.kernel.org>; Sun, 14 Jun 2015 12:39:13 +0200 (CEST)
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Subject: [GIT PULL FOR v4.2] OMAP3 ISP and OMAP4 ISS fixes
Date: Sun, 14 Jun 2015 13:40:49 +0300
Message-ID: <1775137.WdU9NR7h8G@avalon>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

The following changes since commit e42c8c6eb456f8978de417ea349eef676ef4385c:

  [media] au0828: move dev->boards atribuition to happen earlier (2015-06-10 
12:39:35 -0300)

are available in the git repository at:

  git://linuxtv.org/pinchartl/media.git omap3isp/next

for you to fetch changes up to 09601442b10db8b5dab4fc3e5782d343a1d5c99a:

  v4l: omap4iss: Remove video node crop support (2015-06-14 13:38:43 +0300)

----------------------------------------------------------------
Laurent Pinchart (2):
      v4l: omap4iss: Enable driver compilation as a module
      v4l: omap4iss: Remove video node crop support

Sakari Ailus (2):
      v4l: omap3isp: Fix async notifier registration order
      v4l: omap3isp: Fix sub-device power management code

 drivers/media/platform/omap3isp/isp.c      | 27 +++++++-------
 drivers/staging/media/omap4iss/Kconfig     |  2 +-
 drivers/staging/media/omap4iss/TODO        |  1 -
 drivers/staging/media/omap4iss/iss_video.c | 73 -----------------------------
 4 files changed, 16 insertions(+), 87 deletions(-)

-- 
Regards,

Laurent Pinchart

