Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f47.google.com ([74.125.82.47]:36104 "EHLO
	mail-wm0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752008AbcFIRGr (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 9 Jun 2016 13:06:47 -0400
Received: by mail-wm0-f47.google.com with SMTP id n184so234326742wmn.1
        for <linux-media@vger.kernel.org>; Thu, 09 Jun 2016 10:06:46 -0700 (PDT)
From: Kieran Bingham <kieran@ksquared.org.uk>
To: laurent.pinchart@ideasonboard.com, mchehab@osg.samsung.com,
	linux-media@vger.kernel.org
Cc: linux-renesas-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
	Kieran Bingham <kieran@ksquared.org.uk>
Subject: [PATCH] v4l: Extend FCP compatible list to support the FDP
Date: Thu,  9 Jun 2016 18:06:42 +0100
Message-Id: <1465492003-1554-1-git-send-email-kieran@bingham.xyz>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The following patch extends Laurents FCP driver to support the FCP for
FDP (FCPF) which is used by the FDP driver currently in development

This patch is of course dependant upon Laurents FCP driver series [0]
which has not yet hit mainline

[0] http://www.spinics.net/lists/linux-media/msg97302.html

Kieran Bingham (1):
  v4l: Extend FCP compatible list to support the FDP

 drivers/media/platform/rcar-fcp.c | 1 +
 1 file changed, 1 insertion(+)

-- 
2.7.4

