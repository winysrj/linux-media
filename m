Return-path: <linux-media-owner@vger.kernel.org>
Received: from qmta08.emeryville.ca.mail.comcast.net ([76.96.30.80]:43318 "EHLO
	qmta08.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752713AbaB1VXI (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 28 Feb 2014 16:23:08 -0500
From: Shuah Khan <shuah.kh@samsung.com>
To: m.chehab@samsung.com
Cc: Shuah Khan <shuah.kh@samsung.com>, linux-media@vger.kernel.org,
	linux-kernel@vger.kernel.org, shuahkhan@gmail.com
Subject: [PATCH 2/3] media/drx39xyj: remove return that prevents DJH_DEBUG code to run
Date: Fri, 28 Feb 2014 14:23:01 -0700
Message-Id: <d865504befcaa340f49299af872e8cd47576881e.1393621530.git.shuah.kh@samsung.com>
In-Reply-To: <cover.1393621530.git.shuah.kh@samsung.com>
References: <cover.1393621530.git.shuah.kh@samsung.com>
In-Reply-To: <cover.1393621530.git.shuah.kh@samsung.com>
References: <cover.1393621530.git.shuah.kh@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

drxbsp_i2c_write_read() has return that prevents DJH_DEBUG code to run.
Remove it.

Signed-off-by: Shuah Khan <shuah.kh@samsung.com>
---
 drivers/media/dvb-frontends/drx39xyj/drxj.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/media/dvb-frontends/drx39xyj/drxj.c b/drivers/media/dvb-frontends/drx39xyj/drxj.c
index a78af4e..72c541a 100644
--- a/drivers/media/dvb-frontends/drx39xyj/drxj.c
+++ b/drivers/media/dvb-frontends/drx39xyj/drxj.c
@@ -1550,8 +1550,6 @@ int drxbsp_i2c_write_read(struct i2c_device_addr *w_dev_addr,
 		return -EREMOTEIO;
 	}
 
-	return 0;
-
 #ifdef DJH_DEBUG
 	struct drx39xxj_state *state = w_dev_addr->user_data;
 
-- 
1.8.3.2

