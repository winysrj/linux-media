Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f179.google.com ([209.85.212.179]:33548 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933134AbbJAMFJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 1 Oct 2015 08:05:09 -0400
Received: by wiclk2 with SMTP id lk2so29856323wic.0
        for <linux-media@vger.kernel.org>; Thu, 01 Oct 2015 05:05:08 -0700 (PDT)
From: Mikhail Ulyanov <mikhail.ulyanov@cogentembedded.com>
To: hverkuil@xs4all.nl, horms@verge.net.au, magnus.damm@gmail.com,
	robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
	mchehab@osg.samsung.com
Cc: laurent.pinchart@ideasonboard.com, j.anaszewski@samsung.com,
	kamil@wypas.org, sergei.shtylyov@cogentembedded.com,
	devicetree@vger.kernel.org, linux-media@vger.kernel.org,
	linux-sh@vger.kernel.org,
	Mikhail Ulyanov <mikhail.ulyanov@cogentembedded.com>
Subject: [PATCH 0/2] media: platform: rcar_jpu: code cleanup and release function changes
Date: Thu,  1 Oct 2015 15:03:30 +0300
Message-Id: <1443701012-20730-1-git-send-email-mikhail.ulyanov@cogentembedded.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This series of patches includes improvements and code cleanup for rcar_jpu driver.

Mikhail Ulyanov (2):
  V4L2: platform: rcar_jpu: remove redundant code
  V4L2: platform: rcar_jpu: switch off clock on release later

 drivers/media/platform/rcar_jpu.c | 13 +++++--------
 1 file changed, 5 insertions(+), 8 deletions(-)

-- 
2.5.1

