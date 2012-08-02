Return-path: <linux-media-owner@vger.kernel.org>
Received: from eu1sys200aog117.obsmtp.com ([207.126.144.143]:44638 "HELO
	eu1sys200aog117.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750807Ab2HBHku (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 2 Aug 2012 03:40:50 -0400
Received: by weyx43 with SMTP id x43so6868112wey.30
        for <linux-media@vger.kernel.org>; Thu, 02 Aug 2012 00:40:48 -0700 (PDT)
From: Dror Cohen <dror@liveu.tv>
To: linux-media@vger.kernel.org
Cc: mchehab@infradead.org, nsekhar@ti.com,
	davinci-linux-open-source@linux.davincidsp.com,
	Dror Cohen <dror@liveu.tv>
Subject: [PATCH 0/1] media/video: vpif: fixing function name start to vpif_config_params
Date: Thu,  2 Aug 2012 10:40:31 +0300
Message-Id: <1343893232-19543-1-git-send-email-dror@liveu.tv>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch address the issue that a function named config_vpif_params should
be vpif_config_params. This, however, conflicts with two structures defined
already. So I changed the structures to config_vpif_params_t (origin was
vpif_config_params)

Dror Cohen (1):
  fixing function name start to vpif_config_params

 drivers/media/video/davinci/vpif.c         |    6 +++---
 drivers/media/video/davinci/vpif_capture.c |    2 +-
 drivers/media/video/davinci/vpif_capture.h |    2 +-
 drivers/media/video/davinci/vpif_display.c |    2 +-
 drivers/media/video/davinci/vpif_display.h |    2 +-
 5 files changed, 7 insertions(+), 7 deletions(-)

-- 
1.7.5.4

