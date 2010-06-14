Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pv0-f174.google.com ([74.125.83.174]:52855 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755730Ab0FNU1A (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 14 Jun 2010 16:27:00 -0400
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: reiserfs-devel@vger.kernel.org, linux-bluetooth@vger.kernel.org,
	clemens@ladisch.de, debora@linux.vnet.ibm.com,
	dri-devel@lists.freedesktop.org, linux-i2c@vger.kernel.org,
	linux1394-devel@lists.sourceforge.net, linux-media@vger.kernel.org,
	"Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH 6/8]i2c:i2c_core Fix warning: variable 'dummy' set but not used
Date: Mon, 14 Jun 2010 13:26:46 -0700
Message-Id: <1276547208-26569-7-git-send-email-justinmattock@gmail.com>
In-Reply-To: <1276547208-26569-1-git-send-email-justinmattock@gmail.com>
References: <1276547208-26569-1-git-send-email-justinmattock@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

could be a right solution, could be wrong
here is the warning:
  CC      drivers/i2c/i2c-core.o
drivers/i2c/i2c-core.c: In function 'i2c_register_adapter':
drivers/i2c/i2c-core.c:757:15: warning: variable 'dummy' set but not used
 
 Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---
 drivers/i2c/i2c-core.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/i2c/i2c-core.c b/drivers/i2c/i2c-core.c
index 1cca263..79c6c26 100644
--- a/drivers/i2c/i2c-core.c
+++ b/drivers/i2c/i2c-core.c
@@ -794,6 +794,8 @@ static int i2c_register_adapter(struct i2c_adapter *adap)
 	mutex_lock(&core_lock);
 	dummy = bus_for_each_drv(&i2c_bus_type, NULL, adap,
 				 __process_new_adapter);
+	if(!dummy)
+		dummy = 0;
 	mutex_unlock(&core_lock);
 
 	return 0;
-- 
1.7.1.rc1.21.gf3bd6

