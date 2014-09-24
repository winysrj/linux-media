Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:37161 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751352AbaIXODH (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 24 Sep 2014 10:03:07 -0400
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Shuah Khan <shuah.kh@samsung.com>, Ole Ernst <olebowle@gmx.com>
Subject: [PATCH 2/4] [media] dvb_frontend: Fix __user namespace
Date: Wed, 24 Sep 2014 11:02:27 -0300
Message-Id: <a987ff50f94ecd9e5264b7685e11b29bd81d6f35.1411567328.git.mchehab@osg.samsung.com>
In-Reply-To: <e64ef973881ac3f5d98ee52f275a0fb9c3d07a56.1411567328.git.mchehab@osg.samsung.com>
References: <e64ef973881ac3f5d98ee52f275a0fb9c3d07a56.1411567328.git.mchehab@osg.samsung.com>
In-Reply-To: <e64ef973881ac3f5d98ee52f275a0fb9c3d07a56.1411567328.git.mchehab@osg.samsung.com>
References: <e64ef973881ac3f5d98ee52f275a0fb9c3d07a56.1411567328.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

As reported by smatch:

drivers/media/dvb-core/dvb_frontend.c:1960:45: warning: incorrect type in argument 2 (different address spaces)
drivers/media/dvb-core/dvb_frontend.c:1960:45:    expected void const [noderef] <asn:1>*from
drivers/media/dvb-core/dvb_frontend.c:1960:45:    got struct dtv_property *[noderef] <asn:1>props
drivers/media/dvb-core/dvb_frontend.c:1992:45: warning: incorrect type in argument 2 (different address spaces)
drivers/media/dvb-core/dvb_frontend.c:1992:45:    expected void const [noderef] <asn:1>*from
drivers/media/dvb-core/dvb_frontend.c:1992:45:    got struct dtv_property *[noderef] <asn:1>props
drivers/media/dvb-core/dvb_frontend.c:2014:38: warning: incorrect type in argument 1 (different address spaces)
drivers/media/dvb-core/dvb_frontend.c:2014:38:    expected void [noderef] <asn:1>*to
drivers/media/dvb-core/dvb_frontend.c:2014:38:    got struct dtv_property *[noderef] <asn:1>props
drivers/media/dvb-core/dvb_frontend.c:1946:17: warning: dereference of noderef expression
drivers/media/dvb-core/dvb_frontend.c:1947:17: warning: dereference of noderef expression
drivers/media/dvb-core/dvb_frontend.c:1951:22: warning: dereference of noderef expression
drivers/media/dvb-core/dvb_frontend.c:1951:42: warning: dereference of noderef expression
drivers/media/dvb-core/dvb_frontend.c:1954:31: warning: dereference of noderef expression
drivers/media/dvb-core/dvb_frontend.c:1960:41: warning: dereference of noderef expression
drivers/media/dvb-core/dvb_frontend.c:1960:54: warning: dereference of noderef expression
drivers/media/dvb-core/dvb_frontend.c:1965:33: warning: dereference of noderef expression
drivers/media/dvb-core/dvb_frontend.c:1978:17: warning: dereference of noderef expression
drivers/media/dvb-core/dvb_frontend.c:1979:17: warning: dereference of noderef expression
drivers/media/dvb-core/dvb_frontend.c:1983:22: warning: dereference of noderef expression
drivers/media/dvb-core/dvb_frontend.c:1983:42: warning: dereference of noderef expression
drivers/media/dvb-core/dvb_frontend.c:1986:31: warning: dereference of noderef expression
drivers/media/dvb-core/dvb_frontend.c:1992:41: warning: dereference of noderef expression
drivers/media/dvb-core/dvb_frontend.c:1992:54: warning: dereference of noderef expression
drivers/media/dvb-core/dvb_frontend.c:2007:33: warning: dereference of noderef expression
drivers/media/dvb-core/dvb_frontend.c:2014:34: warning: dereference of noderef expression
drivers/media/dvb-core/dvb_frontend.c:2014:52: warning: dereference of noderef expression

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

diff --git a/drivers/media/dvb-core/dvb_frontend.c b/drivers/media/dvb-core/dvb_frontend.c
index c862ad732d9e..b8579ee68bd6 100644
--- a/drivers/media/dvb-core/dvb_frontend.c
+++ b/drivers/media/dvb-core/dvb_frontend.c
@@ -1934,15 +1934,13 @@ static int dvb_frontend_ioctl_properties(struct file *file,
 	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
 	int err = 0;
 
-	struct dtv_properties *tvps = NULL;
+	struct dtv_properties *tvps = parg;
 	struct dtv_property *tvp = NULL;
 	int i;
 
 	dev_dbg(fe->dvb->device, "%s:\n", __func__);
 
-	if(cmd == FE_SET_PROPERTY) {
-		tvps = (struct dtv_properties __user *)parg;
-
+	if (cmd == FE_SET_PROPERTY) {
 		dev_dbg(fe->dvb->device, "%s: properties.num = %d\n", __func__, tvps->num);
 		dev_dbg(fe->dvb->device, "%s: properties.props = %p\n", __func__, tvps->props);
 
@@ -1957,7 +1955,8 @@ static int dvb_frontend_ioctl_properties(struct file *file,
 			goto out;
 		}
 
-		if (copy_from_user(tvp, tvps->props, tvps->num * sizeof(struct dtv_property))) {
+		if (copy_from_user(tvp, (void __user *)tvps->props,
+				   tvps->num * sizeof(struct dtv_property))) {
 			err = -EFAULT;
 			goto out;
 		}
@@ -1972,10 +1971,7 @@ static int dvb_frontend_ioctl_properties(struct file *file,
 		if (c->state == DTV_TUNE)
 			dev_dbg(fe->dvb->device, "%s: Property cache is full, tuning\n", __func__);
 
-	} else
-	if(cmd == FE_GET_PROPERTY) {
-		tvps = (struct dtv_properties __user *)parg;
-
+	} else if (cmd == FE_GET_PROPERTY) {
 		dev_dbg(fe->dvb->device, "%s: properties.num = %d\n", __func__, tvps->num);
 		dev_dbg(fe->dvb->device, "%s: properties.props = %p\n", __func__, tvps->props);
 
@@ -1990,7 +1986,8 @@ static int dvb_frontend_ioctl_properties(struct file *file,
 			goto out;
 		}
 
-		if (copy_from_user(tvp, tvps->props, tvps->num * sizeof(struct dtv_property))) {
+		if (copy_from_user(tvp, (void __user *)tvps->props,
+				   tvps->num * sizeof(struct dtv_property))) {
 			err = -EFAULT;
 			goto out;
 		}
@@ -2012,7 +2009,8 @@ static int dvb_frontend_ioctl_properties(struct file *file,
 			(tvp + i)->result = err;
 		}
 
-		if (copy_to_user(tvps->props, tvp, tvps->num * sizeof(struct dtv_property))) {
+		if (copy_to_user((void __user *)tvps->props, tvp,
+				 tvps->num * sizeof(struct dtv_property))) {
 			err = -EFAULT;
 			goto out;
 		}
-- 
1.9.3

