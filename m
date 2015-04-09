Return-path: <linux-media-owner@vger.kernel.org>
Received: from nasmtp02.atmel.com ([204.2.163.16]:3886 "EHLO
	SJOEDG01.corp.atmel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S933798AbbDII66 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 9 Apr 2015 04:58:58 -0400
From: Josh Wu <josh.wu@atmel.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Nicolas Ferre <nicolas.ferre@atmel.com>,
	<linux-arm-kernel@lists.infradead.org>, Josh Wu <josh.wu@atmel.com>
Subject: [PATCH v2 0/3] media: atmel-isi: rework on the clock part and add runtime pm support
Date: Thu, 9 Apr 2015 17:01:45 +0800
Message-ID: <1428570108-4961-1-git-send-email-josh.wu@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch series fix the peripheral clock code and enable runtime pm
support.
Also it clean up the code which is for the compatiblity of mck.

Changes in v2:
- merged v1 two patch into one.
- use runtime_pm_put() instead of runtime_pm_put_sync()
- enable peripheral clock before access ISI registers.
- totally remove clock_start()/clock_stop() as they are optional.

Josh Wu (3):
  media: atmel-isi: remove the useless code which disable isi
  media: atmel-isi: add runtime pm support
  media: atmel-isi: remove mck back compatiable code as it's not need

 drivers/media/platform/soc_camera/atmel-isi.c | 101 ++++++++++++--------------
 1 file changed, 45 insertions(+), 56 deletions(-)

-- 
1.9.1

