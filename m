Return-path: <linux-media-owner@vger.kernel.org>
Received: from cmccmta1.chinamobile.com ([221.176.66.79]:5352 "EHLO
	cmccmta1.chinamobile.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750834AbcAOFXK (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 15 Jan 2016 00:23:10 -0500
From: Xiubo Li <lixiubo@cmss.chinamobile.com>
To: m.chehab@samsung.com
Cc: linux-media@vger.kernel.org,
	Xiubo Li <lixiubo@cmss.chinamobile.com>
Subject: [PATCH 0/3] [media] dvbdev: clean up the code
Date: Fri, 15 Jan 2016 13:14:57 +0800
Message-Id: <1452834900-28360-1-git-send-email-lixiubo@cmss.chinamobile.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


Xiubo Li (3):
  [media] dvbdev: replace kcalloc with kzalloc
  [media] dvbdev: the space is required after ','
  [media] dvbdev: remove useless parentheses after return

 drivers/media/dvb-core/dvbdev.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

-- 
1.8.3.1



