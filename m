Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:32947 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751150AbaIINW5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 9 Sep 2014 09:22:57 -0400
Received: from avalon.localnet (dsl-hkibrasgw3-50ddcc-40.dhcp.inet.fi [80.221.204.40])
	by galahad.ideasonboard.com (Postfix) with ESMTPSA id 4C95420015
	for <linux-media@vger.kernel.org>; Tue,  9 Sep 2014 15:21:57 +0200 (CEST)
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Subject: [GIT PULL FOR v3.18] Media core changes
Date: Tue, 09 Sep 2014 16:22:59 +0300
Message-ID: <1588396.D34QsCWOet@avalon>
In-Reply-To: <1939223.IgehJYBKd7@avalon>
References: <1939223.IgehJYBKd7@avalon>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

This pull request supersedes the "[GIT PULL FOR v3.18] Media core changes" 
pull request I've just sent. Sorry for the noise.

The following changes since commit 91f96e8b7255537da3a58805cf465003521d7c5f:

  [media] tw68: drop bogus cpu_to_le32() call (2014-09-08 16:40:54 -0300)

are available in the git repository at:

  git://linuxtv.org/pinchartl/media.git v4l2/core

for you to fetch changes up to 7616a92e9801122e432edebdda04d8a42f349c54:

  v4l: Fix ARGB32 fourcc value in the documentation (2014-09-09 16:20:59 
+0300)

----------------------------------------------------------------
Laurent Pinchart (3):
      media: Use strlcpy instead of custom code
      v4l: Add ARGB555X and XRGB555X pixel formats
      v4l: Fix ARGB32 fourcc value in the documentation

 Documentation/DocBook/media/v4l/pixfmt-packed-rgb.xml | 52 +++++++++++++++---
 drivers/media/media-device.c                          |  6 ++--
 include/uapi/linux/videodev2.h                        |  3 ++
 3 files changed, 53 insertions(+), 8 deletions(-)

-- 
Regards,

Laurent Pinchart

