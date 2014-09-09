Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:32939 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750970AbaIINLK (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 9 Sep 2014 09:11:10 -0400
Received: from avalon.localnet (dsl-hkibrasgw3-50ddcc-40.dhcp.inet.fi [80.221.204.40])
	by galahad.ideasonboard.com (Postfix) with ESMTPSA id EE4D520015
	for <linux-media@vger.kernel.org>; Tue,  9 Sep 2014 15:10:10 +0200 (CEST)
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Subject: [GIT PULL FOR v3.18] Media core changes
Date: Tue, 09 Sep 2014 16:11:12 +0300
Message-ID: <1939223.IgehJYBKd7@avalon>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

The following changes since commit 91f96e8b7255537da3a58805cf465003521d7c5f:

  [media] tw68: drop bogus cpu_to_le32() call (2014-09-08 16:40:54 -0300)

are available in the git repository at:

  git://linuxtv.org/pinchartl/media.git v4l2/core

for you to fetch changes up to acac9bf2c8bfb78258230f9dd8e317e83242066e:

  media: Use strlcpy instead of custom code (2014-09-09 15:43:14 +0300)

----------------------------------------------------------------
Laurent Pinchart (1):
      media: Use strlcpy instead of custom code

 drivers/media/media-device.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

-- 
Regards,

Laurent Pinchart

