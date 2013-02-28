Return-path: <linux-media-owner@vger.kernel.org>
Received: from intranet.asianux.com ([58.214.24.6]:64647 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751417Ab3B1HI2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 28 Feb 2013 02:08:28 -0500
Message-ID: <512F0252.3050802@asianux.com>
Date: Thu, 28 Feb 2013 15:08:02 +0800
From: Chen Gang <gang.chen@asianux.com>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Greg KH <gregkh@linuxfoundation.org>,
	linux-media@vger.kernel.org,
	"devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>
Subject: [PATCH] drivers/staging/media/as102: using ccflags-y instead of EXTRA_FLAGS
 in Makefile
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


  need using ccflags-y instead of EXTRA_CFLAGS
    can reference scripts/checkpatch.pl (1755..1766)

  when make EXTRA_CFLAGS=-W, the compiling issue will be occured.


Signed-off-by: Chen Gang <gang.chen@asianux.com>
---
 drivers/staging/media/as102/Makefile |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/media/as102/Makefile b/drivers/staging/media/as102/Makefile
index d8dfb75..8916d8a 100644
--- a/drivers/staging/media/as102/Makefile
+++ b/drivers/staging/media/as102/Makefile
@@ -3,4 +3,4 @@ dvb-as102-objs := as102_drv.o as102_fw.o as10x_cmd.o as10x_cmd_stream.o \
 
 obj-$(CONFIG_DVB_AS102) += dvb-as102.o
 
-EXTRA_CFLAGS += -Idrivers/media/dvb-core
+ccflags-y += -Idrivers/media/dvb-core
-- 
1.7.7.6
