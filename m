Return-path: <linux-media-owner@vger.kernel.org>
Received: from eu1sys200aog107.obsmtp.com ([207.126.144.123]:57042 "HELO
	eu1sys200aog107.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751831Ab2HIGeO (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 9 Aug 2012 02:34:14 -0400
Received: by wgbdr13 with SMTP id dr13so60205wgb.13
        for <linux-media@vger.kernel.org>; Wed, 08 Aug 2012 23:34:12 -0700 (PDT)
From: Dror Cohen <dror@liveu.tv>
To: linux-media@vger.kernel.org
Cc: mchehab@infradead.org, nsekhar@ti.com,
	davinci-linux-open-source@linux.davincidsp.com,
	Dror Cohen <dror@liveu.tv>
Subject: [PATCH 0/1 v2] media/video: vpif: fixing function name start to vpif_config_params
Date: Thu,  9 Aug 2012 09:33:36 +0300
Message-Id: <1344494017-18099-1-git-send-email-dror@liveu.tv>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch address the issue that a function named config_vpif_params should
be vpif_config_params. However this name is shared with two structures defined
already. So I changed the structures to config_vpif_params (origin was
vpif_config_params)

v2 changes: softer wording in description and the structs are now
defined without _t

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

