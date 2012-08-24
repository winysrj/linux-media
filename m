Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-out.m-online.net ([212.18.0.10]:50423 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757822Ab2HXJKi (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 24 Aug 2012 05:10:38 -0400
From: Anatolij Gustschin <agust@denx.de>
To: linux-media@vger.kernel.org
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Mauro Carvalho Chehab <mchehab@infradead.org>, dzu@denx.de
Subject: [PATCH 0/3] various updates for mt9v022 driver
Date: Fri, 24 Aug 2012 11:10:28 +0200
Message-Id: <1345799431-29426-1-git-send-email-agust@denx.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Anatolij Gustschin (3):
  mt9v022: add v4l2 controls for blanking and other register settings
  mt9v022: fix the V4L2_CID_EXPOSURE control
  mt9v022: set y_skip_top field to zero

 drivers/media/i2c/soc_camera/mt9v022.c |  117 ++++++++++++++++++++++++++++----
 1 files changed, 104 insertions(+), 13 deletions(-)

