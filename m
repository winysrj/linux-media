Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wg0-f44.google.com ([74.125.82.44]:36908 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752208AbbCHV5a (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 8 Mar 2015 17:57:30 -0400
From: Lad Prabhakar <prabhakar.csengg@gmail.com>
To: LMML <linux-media@vger.kernel.org>,
	Hans Verkuil <hans.verkuil@cisco.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
	"Lad, Prabhakar" <prabhakar.csengg@gmail.com>
Subject: [PATCH 0/2] media: davinci: vpif: embed video_device in channel objects
Date: Sun,  8 Mar 2015 21:57:22 +0000
Message-Id: <1425851844-1917-1-git-send-email-prabhakar.csengg@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>

This patch series embeds video_device structure for
vpif capture & display driver in appropriate channel objects.

Lad, Prabhakar (2):
  media: davinci: vpif_capture: embed video_device struct in channel_obj
  media: davinci: vpif_display: embed video_device struct in channel_obj

 drivers/media/platform/davinci/vpif_capture.c | 52 ++++++---------------------
 drivers/media/platform/davinci/vpif_capture.h |  2 +-
 drivers/media/platform/davinci/vpif_display.c | 49 +++++--------------------
 drivers/media/platform/davinci/vpif_display.h |  2 +-
 4 files changed, 21 insertions(+), 84 deletions(-)

-- 
2.1.0

