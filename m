Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:52918 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751819AbaAGPuu (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 7 Jan 2014 10:50:50 -0500
Date: Tue, 07 Jan 2014 23:50:47 +0800
From: kbuild test robot <fengguang.wu@intel.com>
To: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: linux-media@vger.kernel.org, kbuild-all@01.org
Subject: [linuxtv-media:master 395/499]
 drivers/media/usb/em28xx/em28xx-video.c:1151:28: sparse: symbol
 'em28xx_ctrl_ops' was not declared. Should it be static?
Message-ID: <52cc2257.SeWuc92AVYd//ecz%fengguang.wu@intel.com>
MIME-Version: 1.0
Content-Type: multipart/mixed;
 boundary="=_52cc2257.NqaXn/jPZh+QLeFMwmFzQprkUnvV9lxo0dPGXgVD/wKmC19y"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is a multi-part message in MIME format.

--=_52cc2257.NqaXn/jPZh+QLeFMwmFzQprkUnvV9lxo0dPGXgVD/wKmC19y
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

tree:   git://linuxtv.org/media_tree.git master
head:   2a9ecc17ed9f076ff199a4bf4ebd22b41badb505
commit: 01c2819330b1e0ec6b53dcfac76ad75ff2c8ba4f [395/499] [media] em28xx: make em28xx-video to be a separate module
reproduce: make C=1 CF=-D__CHECK_ENDIAN__


sparse warnings: (new ones prefixed by >>)

>> drivers/media/usb/em28xx/em28xx-video.c:1151:28: sparse: symbol 'em28xx_ctrl_ops' was not declared. Should it be static?
--
>> drivers/media/usb/em28xx/em28xx-cards.c:2164:36: sparse: cannot size expression

Please consider folding the attached diff :-)

---
0-DAY kernel build testing backend              Open Source Technology Center
http://lists.01.org/mailman/listinfo/kbuild                 Intel Corporation

--=_52cc2257.NqaXn/jPZh+QLeFMwmFzQprkUnvV9lxo0dPGXgVD/wKmC19y
Content-Type: text/x-diff;
 charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="make-it-static-01c2819330b1e0ec6b53dcfac76ad75ff2c8ba4f.diff"

From: Fengguang Wu <fengguang.wu@intel.com>
Subject: [PATCH linuxtv-media] em28xx: em28xx_ctrl_ops can be static
TO: Mauro Carvalho Chehab <m.chehab@samsung.com>
CC: linux-media@vger.kernel.org
CC: linux-media@vger.kernel.org 
CC: linux-kernel@vger.kernel.org 

CC: Mauro Carvalho Chehab <m.chehab@samsung.com>
CC: linux-media@vger.kernel.org
Signed-off-by: Fengguang Wu <fengguang.wu@intel.com>
---
 em28xx-video.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/usb/em28xx/em28xx-video.c b/drivers/media/usb/em28xx/em28xx-video.c
index 7d11a16..7a3a514 100644
--- a/drivers/media/usb/em28xx/em28xx-video.c
+++ b/drivers/media/usb/em28xx/em28xx-video.c
@@ -1148,7 +1148,7 @@ static int em28xx_s_ctrl(struct v4l2_ctrl *ctrl)
 	return (ret < 0) ? ret : 0;
 }
 
-const struct v4l2_ctrl_ops em28xx_ctrl_ops = {
+static const struct v4l2_ctrl_ops em28xx_ctrl_ops = {
 	.s_ctrl = em28xx_s_ctrl,
 };
 

--=_52cc2257.NqaXn/jPZh+QLeFMwmFzQprkUnvV9lxo0dPGXgVD/wKmC19y--
