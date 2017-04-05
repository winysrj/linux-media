Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:39985
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1755252AbdDENX1 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 5 Apr 2017 09:23:27 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        Jonathan Corbet <corbet@lwn.net>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org
Subject: [PATCH v2 19/21] usb: composite.h: fix two warnings when building docs
Date: Wed,  5 Apr 2017 10:23:13 -0300
Message-Id: <fd7aeb6ee6ca44df70235d5f5e2f5e0aac8f17d5.1491398120.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1491398120.git.mchehab@s-opensource.com>
References: <cover.1491398120.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1491398120.git.mchehab@s-opensource.com>
References: <cover.1491398120.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

By definition, we use /* private: */ tag when we won't be documenting
a parameter. However, those two parameters are documented:

./include/linux/usb/composite.h:510: warning: Excess struct/union/enum/typedef member 'setup_pending' description in 'usb_composite_dev'
./include/linux/usb/composite.h:510: warning: Excess struct/union/enum/typedef member 'os_desc_pending' description in 'usb_composite_dev'

So, we need to use /* public: */ to avoid a warning.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 include/linux/usb/composite.h | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/include/linux/usb/composite.h b/include/linux/usb/composite.h
index 30a063e98c19..f665d2ceac20 100644
--- a/include/linux/usb/composite.h
+++ b/include/linux/usb/composite.h
@@ -504,8 +504,9 @@ struct usb_composite_dev {
 	/* protects deactivations and delayed_status counts*/
 	spinlock_t			lock;
 
-	unsigned			setup_pending:1;
-	unsigned			os_desc_pending:1;
+	/* public: */
+	unsigned int			setup_pending:1;
+	unsigned int			os_desc_pending:1;
 };
 
 extern int usb_string_id(struct usb_composite_dev *c);
-- 
2.9.3
