Return-path: <linux-media-owner@vger.kernel.org>
Received: from resqmta-po-10v.sys.comcast.net ([96.114.154.169]:42142 "EHLO
	resqmta-po-10v.sys.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752863AbbLKX2F (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 11 Dec 2015 18:28:05 -0500
From: Shuah Khan <shuahkh@osg.samsung.com>
To: mchehab@osg.samsung.com, hans.verkuil@cisco.com
Cc: Shuah Khan <shuahkh@osg.samsung.com>, linux-media@vger.kernel.org
Subject: [PATCH] v4l-utils: mc_nextgen_test fix compile warnings
Date: Fri, 11 Dec 2015 16:28:01 -0700
Message-Id: <1449876481-5624-1-git-send-email-shuahkh@osg.samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Fix the following compile warnings:

  CC       mc_nextgen_test-mc_nextgen_test.o
mc_nextgen_test.c: In function ‘media_get_ifname’:
mc_nextgen_test.c:410:3: warning: ignoring return value of ‘asprintf’, declared with attribute warn_unused_result [-Wunused-result]
   asprintf(&name, "%s", devname);
   ^
mc_nextgen_test.c: In function ‘media_get_ifname_udev’:
mc_nextgen_test.c:335:4: warning: ignoring return value of ‘asprintf’, declared with attribute warn_unused_result [-Wunused-result]
    asprintf(&name, "%s", p);
    ^
mc_nextgen_test.c: In function ‘objname’:
mc_nextgen_test.c:249:2: warning: ignoring return value of ‘asprintf’, declared with attribute warn_unused_result [-Wunused-result]
  asprintf(&name, "%s%c%d", gobj_type(id), delimiter, media_localid(id));
  ^

Signed-off-by: Shuah Khan <shuahkh@osg.samsung.com>
---
 contrib/test/mc_nextgen_test.c | 19 ++++++++++++++-----
 1 file changed, 14 insertions(+), 5 deletions(-)

diff --git a/contrib/test/mc_nextgen_test.c b/contrib/test/mc_nextgen_test.c
index 743ddee..cf71bec 100644
--- a/contrib/test/mc_nextgen_test.c
+++ b/contrib/test/mc_nextgen_test.c
@@ -246,7 +246,11 @@ static inline const char *ent_function(uint32_t function)
 static char *objname(uint32_t id, char delimiter)
 {
 	char *name;
-	asprintf(&name, "%s%c%d", gobj_type(id), delimiter, media_localid(id));
+	int ret;
+
+	ret = asprintf(&name, "%s%c%d", gobj_type(id), delimiter, media_localid(id));
+	if (ret < 0)
+		return NULL;
 
 	return name;
 }
@@ -323,6 +327,7 @@ static char *media_get_ifname_udev(struct media_v2_intf_devnode *devnode, struct
 	dev_t devnum;
 	const char *p;
 	char *name = NULL;
+	int ret;
 
 	if (udev == NULL)
 		return NULL;
@@ -332,7 +337,9 @@ static char *media_get_ifname_udev(struct media_v2_intf_devnode *devnode, struct
 	if (device) {
 		p = udev_device_get_devnode(device);
 		if (p) {
-			asprintf(&name, "%s", p);
+			ret = asprintf(&name, "%s", p);
+			if (ret < 0)
+				return NULL;
 		}
 	}
 
@@ -406,9 +413,11 @@ char *media_get_ifname(struct media_v2_interface *intf, void *priv)
 	 * libudev.
 	 */
 	if (major(devstat.st_rdev) == intf->devnode.major &&
-	    minor(devstat.st_rdev) == intf->devnode.minor)
-		asprintf(&name, "%s", devname);
-
+	    minor(devstat.st_rdev) == intf->devnode.minor) {
+		ret = asprintf(&name, "%s", devname);
+		if (ret < 0)
+			return NULL;
+	}
 	return name;
 }
 
-- 
2.5.0

