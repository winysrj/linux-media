Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.samsung.com ([203.254.224.24]:49033 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759842Ab3CZQGX (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 26 Mar 2013 12:06:23 -0400
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org
Cc: kyungmin.park@samsung.com, myungjoo.ham@samsung.com,
	dh09.lee@samsung.com, shaik.samsung@gmail.com, arun.kk@samsung.com,
	a.hajda@samsung.com, linux-samsung-soc@vger.kernel.org,
	Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [REVIEW PATCH 0/3] s5p-fimc driver updates
Date: Tue, 26 Mar 2013 17:06:03 +0100
Message-id: <1364313966-18868-1-git-send-email-s.nawrocki@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch series contains mostly conversion of the video capture node
drivers to videobuf2 ioctl/fop helpers.

Sylwester Nawrocki (3):
  s5p-fimc: Use video entity for marking media pipeline as streaming
  s5p-fimc: Use vb2 ioctl/fop helpers in FIMC capture driver
  s5p-fimc: Use vb2 ioctl helpers in fimc-lite

 drivers/media/platform/s5p-fimc/fimc-capture.c |  178 +++++++-----------------
 drivers/media/platform/s5p-fimc/fimc-lite.c    |  177 +++++++----------------
 drivers/media/platform/s5p-fimc/fimc-m2m.c     |    9 +-
 3 files changed, 100 insertions(+), 264 deletions(-)

--
1.7.9.5

