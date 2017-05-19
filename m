Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:46442
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1750954AbdESMKO (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 19 May 2017 08:10:14 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Masahiro Yamada <yamada.masahiro@socionext.com>
Subject: [PATCH 2/6] [media] av7110: avoid switch fall through
Date: Fri, 19 May 2017 09:10:00 -0300
Message-Id: <c087fe3ec71bad9bcba731c328b0eb6f306c0de6.1495195712.git.mchehab@s-opensource.com>
In-Reply-To: <4c9ef4f150589478ac0b26bc7db1216c0af207fb.1495195712.git.mchehab@s-opensource.com>
References: <4c9ef4f150589478ac0b26bc7db1216c0af207fb.1495195712.git.mchehab@s-opensource.com>
In-Reply-To: <4c9ef4f150589478ac0b26bc7db1216c0af207fb.1495195712.git.mchehab@s-opensource.com>
References: <4c9ef4f150589478ac0b26bc7db1216c0af207fb.1495195712.git.mchehab@s-opensource.com>
To: unlisted-recipients:; (no To-header on input)@bombadil.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On two switches, this driver have unannotated switch
fall through.

in the first case, it falls through a return. On the second
one, it prints undesired log messages on fall through.

Solve that by copying the commands that it should be
running. Gcc will very likely optimize it anyway, so this
sholdn't be causing any harm, and shuts up gcc warnings.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/media/pci/ttpci/av7110.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/media/pci/ttpci/av7110.c b/drivers/media/pci/ttpci/av7110.c
index df9395c87178..f2905bd80366 100644
--- a/drivers/media/pci/ttpci/av7110.c
+++ b/drivers/media/pci/ttpci/av7110.c
@@ -336,6 +336,7 @@ static int DvbDmxFilterCallback(u8 *buffer1, size_t buffer1_len,
 			av7110_p2t_write(buffer1, buffer1_len,
 					 dvbdmxfilter->feed->pid,
 					 &av7110->p2t_filter[dvbdmxfilter->index]);
+		return 0;
 	default:
 		return 0;
 	}
@@ -451,8 +452,12 @@ static void debiirq(unsigned long cookie)
 
 	case DATA_CI_PUT:
 		dprintk(4, "debi DATA_CI_PUT\n");
+		xfer = TX_BUFF;
+		break;
 	case DATA_MPEG_PLAY:
 		dprintk(4, "debi DATA_MPEG_PLAY\n");
+		xfer = TX_BUFF;
+		break;
 	case DATA_BMP_LOAD:
 		dprintk(4, "debi DATA_BMP_LOAD\n");
 		xfer = TX_BUFF;
-- 
2.9.3
