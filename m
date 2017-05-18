Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:40365
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1754637AbdERMiu (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 18 May 2017 08:38:50 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Markus Elfring <elfring@users.sourceforge.net>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Alexey Khoroshilov <khoroshilov@ispras.ru>
Subject: [PATCH 3/5] [media] bt8xx: add missing break
Date: Thu, 18 May 2017 09:38:37 -0300
Message-Id: <1925356ac01b511f01331b56e41944aa86fbd4d9.1495110899.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1495110899.git.mchehab@s-opensource.com>
References: <cover.1495110899.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1495110899.git.mchehab@s-opensource.com>
References: <cover.1495110899.git.mchehab@s-opensource.com>
To: unlisted-recipients:; (no To-header on input)@bombadil.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The logic that handles CA_SET_PID is clearly missing a
break: it prints that the command succeeded, but, due to the
missing break, it would be returning -EOPNOTSUPP, as if the
driver weren't supporting such ioctl.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/media/pci/bt8xx/dst_ca.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/media/pci/bt8xx/dst_ca.c b/drivers/media/pci/bt8xx/dst_ca.c
index 04d06c564602..90f4263452d3 100644
--- a/drivers/media/pci/bt8xx/dst_ca.c
+++ b/drivers/media/pci/bt8xx/dst_ca.c
@@ -637,6 +637,7 @@ static long dst_ca_ioctl(struct file *file, unsigned int cmd, unsigned long ioct
 			goto free_mem_and_exit;
 		}
 		dprintk(verbose, DST_CA_INFO, 1, " -->CA_SET_PID Success !");
+		break;
 	default:
 		result = -EOPNOTSUPP;
 	}
-- 
2.9.3
