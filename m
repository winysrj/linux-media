Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:57397 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933333AbdKAVGI (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 1 Nov 2017 17:06:08 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Shuah Khan <shuah@kernel.org>,
        Max Kellermann <max.kellermann@gmail.com>,
        Colin Ian King <colin.king@canonical.com>,
        Satendra Singh Thakur <satendra.t@samsung.com>,
        stable@vger.kernel.org
Subject: [PATCH v2 02/26] media: dvb_frontend: be sure to init dvb_frontend_handle_ioctl() return code
Date: Wed,  1 Nov 2017 17:05:39 -0400
Message-Id: <b0e50d28cd43e85b7a5123cd6301f5bae302ba12.1509569763.git.mchehab@s-opensource.com>
In-Reply-To: <c4389ab1c02bb08c1a55012fdb859c8b10bdc47e.1509569763.git.mchehab@s-opensource.com>
References: <c4389ab1c02bb08c1a55012fdb859c8b10bdc47e.1509569763.git.mchehab@s-opensource.com>
In-Reply-To: <c4389ab1c02bb08c1a55012fdb859c8b10bdc47e.1509569763.git.mchehab@s-opensource.com>
References: <c4389ab1c02bb08c1a55012fdb859c8b10bdc47e.1509569763.git.mchehab@s-opensource.com>
To: unlisted-recipients:; (no To-header on input)@bombadil.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

As smatch warned:
	drivers/media/dvb-core/dvb_frontend.c:2468 dvb_frontend_handle_ioctl() error: uninitialized symbol 'err'.

The ioctl handler actually got a regression here: before changeset
d73dcf0cdb95 ("media: dvb_frontend: cleanup ioctl handling logic"),
the code used to return -EOPNOTSUPP if an ioctl handler was not
implemented on a driver. After the change, it may return a random
value.

Fixes: d73dcf0cdb95 ("media: dvb_frontend: cleanup ioctl handling logic")
# For 4.14
Cc: stable@vger.kernel.org
Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/media/dvb-core/dvb_frontend.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/media/dvb-core/dvb_frontend.c b/drivers/media/dvb-core/dvb_frontend.c
index daaf969719e4..bcf0cbcbf7b2 100644
--- a/drivers/media/dvb-core/dvb_frontend.c
+++ b/drivers/media/dvb-core/dvb_frontend.c
@@ -2109,7 +2109,7 @@ static int dvb_frontend_handle_ioctl(struct file *file,
 	struct dvb_frontend *fe = dvbdev->priv;
 	struct dvb_frontend_private *fepriv = fe->frontend_priv;
 	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
-	int i, err;
+	int i, err = -EOPNOTSUPP;
 
 	dev_dbg(fe->dvb->device, "%s:\n", __func__);
 
@@ -2144,6 +2144,7 @@ static int dvb_frontend_handle_ioctl(struct file *file,
 			}
 		}
 		kfree(tvp);
+		err = 0;
 		break;
 	}
 	case FE_GET_PROPERTY: {
@@ -2195,6 +2196,7 @@ static int dvb_frontend_handle_ioctl(struct file *file,
 			return -EFAULT;
 		}
 		kfree(tvp);
+		err = 0;
 		break;
 	}
 
-- 
2.13.6
