Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:46435
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1750831AbdESMKO (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 19 May 2017 08:10:14 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Wolfram Sang <wsa-dev@sang-engineering.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Julia Lawall <Julia.Lawall@lip6.fr>
Subject: [PATCH 5/6] [media] s2255drv: avoid a switch fall through
Date: Fri, 19 May 2017 09:10:03 -0300
Message-Id: <ec33fbd585f76b0803a90ee66804fa6f937dccaa.1495195712.git.mchehab@s-opensource.com>
In-Reply-To: <4c9ef4f150589478ac0b26bc7db1216c0af207fb.1495195712.git.mchehab@s-opensource.com>
References: <4c9ef4f150589478ac0b26bc7db1216c0af207fb.1495195712.git.mchehab@s-opensource.com>
In-Reply-To: <4c9ef4f150589478ac0b26bc7db1216c0af207fb.1495195712.git.mchehab@s-opensource.com>
References: <4c9ef4f150589478ac0b26bc7db1216c0af207fb.1495195712.git.mchehab@s-opensource.com>
To: unlisted-recipients:; (no To-header on input)@bombadil.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On this driver, it can fall through a switch. I tried to
annotate it, in order to shut up a gcc warning, but that
didn't work, as the logic there is somewhat complex.

So, instead, let's just repeat the code. gcc should likely
optimize it anyway, and this makes the code better readable,
IMHO.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/media/usb/s2255/s2255drv.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/media/usb/s2255/s2255drv.c b/drivers/media/usb/s2255/s2255drv.c
index a9d4484f7626..6a88b1dbb3a0 100644
--- a/drivers/media/usb/s2255/s2255drv.c
+++ b/drivers/media/usb/s2255/s2255drv.c
@@ -1803,6 +1803,8 @@ static int save_frame(struct s2255_dev *dev, struct s2255_pipeinfo *pipe_info)
 				default:
 					pr_info("s2255 unknown resp\n");
 				}
+				pdata++;
+				break;
 			default:
 				pdata++;
 				break;
-- 
2.9.3
