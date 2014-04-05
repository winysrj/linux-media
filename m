Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:58830 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753578AbaDEUYD (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 5 Apr 2014 16:24:03 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH 0/4] 3.15 fixes reported by Coverity
Date: Sat,  5 Apr 2014 23:23:40 +0300
Message-Id: <1396729424-17576-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

There was also one e4000 driver issue reported, but I am not able to see what is problem. Help please :)

*** CID 1196504:  Resource leak  (RESOURCE_LEAK)
http://pastebin.com/x1wD086K

regards
Antti

Antti Palosaari (4):
  msi001: fix possible integer overflow
  msi3101: remove unused variable assignment
  msi3101: check I/O return values on stop streaming
  xc2028: add missing break to switch

 drivers/media/tuners/tuner-xc2028.c         |  1 +
 drivers/staging/media/msi3101/msi001.c      |  2 +-
 drivers/staging/media/msi3101/sdr-msi3101.c | 15 ++++++++++-----
 3 files changed, 12 insertions(+), 6 deletions(-)

-- 
1.9.0

