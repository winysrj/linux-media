Return-path: <linux-media-owner@vger.kernel.org>
Received: from bubo.tul.cz ([147.230.16.1]:50422 "EHLO bubo.tul.cz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752206AbdEAETO (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 1 May 2017 00:19:14 -0400
From: Petr Cvek <petr.cvek@tul.cz>
Subject: [PATCH 0/4] [media] pxa_camera: Fixing bugs and missing colorformats
To: robert.jarzmik@free.fr
Cc: linux-media@vger.kernel.org
Message-ID: <19820fae-fae3-9579-8f37-5b515e0edb66@tul.cz>
Date: Mon, 1 May 2017 06:20:19 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patchset is just a grouping of a few bugfixes I've found during
the ov9640 sensor support re-adding. The remaining Bayer 8 formats are
just a permutation of the channels (pxa_camera treats them as raw data).
The missing/incorrect test in the image size generation was just re-added
from the soc_camera. The (un)subscribe_event ioctl calls were added
in a same way as other media drivers. The call with an uninitialized
pointer is a revert of a part of the patch, which broke it.

The series are based on the kernel commit after

	[media] pxa_camera: fix module remove codepath for v4l2 clock

Petr Cvek (4):
  [media] pxa_camera: Add remaining Bayer 8 formats
  [media] pxa_camera: Fix incorrect test in the image size generation
  [media] pxa_camera: Add (un)subscribe_event ioctl
  [media] pxa_camera: Fix a call with an uninitialized device pointer

 drivers/media/platform/pxa_camera.c | 51 ++++++++++++++++++++++++++++---------
 1 file changed, 39 insertions(+), 12 deletions(-)

-- 
2.11.0
