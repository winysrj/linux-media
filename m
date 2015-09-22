Return-path: <linux-media-owner@vger.kernel.org>
Received: from bgl-iport-4.cisco.com ([72.163.197.28]:8731 "EHLO
	bgl-iport-4.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752862AbbIVO1d (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 22 Sep 2015 10:27:33 -0400
Received: from pla-VB.cisco.com ([173.39.30.135])
	by bgl-core-3.cisco.com (8.14.5/8.14.5) with ESMTP id t8MERVxh031427
	for <linux-media@vger.kernel.org>; Tue, 22 Sep 2015 14:27:31 GMT
From: Prashant Laddha <prladdha@cisco.com>
To: linux-media@vger.kernel.org
Subject: [RFC v2 0/4] vivid: reduced fps support
Date: Tue, 22 Sep 2015 19:57:27 +0530
Message-Id: <1442932051-24972-1-git-send-email-prladdha@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

Please find RFC v2 for adding reduced fps support in vivid video
transmit and receive.

Changes since v1:
1. Added helper function to check if all necessary conditions for
reduced fps are met.
2. This function can now common for  vivid-vid-out and vivid-vid-cap
3. Same helper function can also be used by v4l2-dv-timings before
setting the flag for reduced fps.
4. Incorporated other review comments. Also split patches into
smaller and well separated changes.

Please review and share your comments.

Regards,
Prashant

Prashant Laddha (4):
  v4l2-dv-timings: add condition checks for reduced fps
  vivid: add support for reduced fps in video out
  vivid-capture: add control for reduced frame rate
  vivid: add support for reduced frame rate in video capture

 drivers/media/platform/vivid/vivid-core.h    |  1 +
 drivers/media/platform/vivid/vivid-ctrls.c   | 15 +++++++++++++++
 drivers/media/platform/vivid/vivid-vid-cap.c | 10 +++++++++-
 drivers/media/platform/vivid/vivid-vid-out.c |  9 ++++++++-
 drivers/media/v4l2-core/v4l2-dv-timings.c    |  5 +++++
 include/media/v4l2-dv-timings.h              | 21 +++++++++++++++++++++
 6 files changed, 59 insertions(+), 2 deletions(-)

-- 
1.9.1

