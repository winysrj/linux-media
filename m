Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:60142 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754051AbbAVQQI (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 22 Jan 2015 11:16:08 -0500
Received: from avalon.localnet (dsl-hkibrasgw3-50ddcc-40.dhcp.inet.fi [80.221.204.40])
	by galahad.ideasonboard.com (Postfix) with ESMTPSA id B366920010
	for <linux-media@vger.kernel.org>; Thu, 22 Jan 2015 17:11:56 +0100 (CET)
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Subject: [GIT PULL FOR v3.20] OMAP4 ISS fix
Date: Thu, 22 Jan 2015 18:16:41 +0200
Message-ID: <2453727.XCtbcr7ZQv@avalon>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

The following changes since commit 1fc77d013ba85a29e2edfaba02fd21e8c8187fae:

  [media] cx23885: Hauppauge WinTV-HVR5525 (2014-12-30 10:48:04 -0200)

are available in the git repository at:

  git://linuxtv.org/pinchartl/media.git omap4iss/next

for you to fetch changes up to 45653d31beedc5fb69301c5a93f4b380a25a658c:

  Revert "[media] v4l: omap4iss: Add module debug parameter" (2015-01-22 
18:13:35 +0200)

This fixes a compilation breakage in your master branch, introduced by commit 
17028cdb74bf8bb5 ("[media] v4l2 core: improve debug flag handling"), scheduled 
for merge in v3.20.

----------------------------------------------------------------
Laurent Pinchart (1):
      Revert "[media] v4l: omap4iss: Add module debug parameter"

 drivers/staging/media/omap4iss/iss_video.c | 5 -----
 1 file changed, 5 deletions(-)

-- 
Regards,

Laurent Pinchart

