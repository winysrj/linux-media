Return-path: <mchehab@localhost>
Received: from mailout4.w1.samsung.com ([210.118.77.14]:48803 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754248Ab1GFJYu (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 6 Jul 2011 05:24:50 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN
Received: from spt2.w1.samsung.com ([210.118.77.14]) by mailout4.w1.samsung.com
 (Sun Java(tm) System Messaging Server 6.3-8.04 (built Jul 29 2009; 32bit))
 with ESMTP id <0LNW003XONHDD120@mailout4.w1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 06 Jul 2011 10:24:49 +0100 (BST)
Received: from linux.samsung.com ([106.116.38.10])
 by spt2.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0LNW002Q0NHCVE@spt2.w1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 06 Jul 2011 10:24:48 +0100 (BST)
Date: Wed, 06 Jul 2011 11:24:40 +0200
From: Tomasz Stanislawski <t.stanislaws@samsung.com>
Subject: [PATCH 2/2] v4l2-ctl: fix wrapped open/close
To: linux-media@vger.kernel.org
Cc: m.szyprowski@samsung.com, t.stanislaws@samsung.com,
	kyungmin.park@samsung.com, mchehab@redhat.com, pawel@osciak.com,
	hdegoede@redhat.com
Message-id: <1309944280-11936-1-git-send-email-t.stanislaws@samsung.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@infradead.org>

When running in libv4l2 warp mode, the application did not use
v4l2_open and v4l2_close in some cases. This patch fixes this
issue substituting open/close calls with test_open/test_close
which are libv4l2-aware.

Signed-off-by: Tomasz Stanislawski <t.stanislaws@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 utils/v4l2-ctl/v4l2-ctl.cpp |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/utils/v4l2-ctl/v4l2-ctl.cpp b/utils/v4l2-ctl/v4l2-ctl.cpp
index 227ce1a..02f97e4 100644
--- a/utils/v4l2-ctl/v4l2-ctl.cpp
+++ b/utils/v4l2-ctl/v4l2-ctl.cpp
@@ -1604,13 +1604,13 @@ static void list_devices()
 
 	for (dev_vec::iterator iter = files.begin();
 			iter != files.end(); ++iter) {
-		int fd = open(iter->c_str(), O_RDWR);
+		int fd = test_open(iter->c_str(), O_RDWR);
 		std::string bus_info;
 
 		if (fd < 0)
 			continue;
 		doioctl(fd, VIDIOC_QUERYCAP, &vcap);
-		close(fd);
+		test_close(fd);
 		bus_info = (const char *)vcap.bus_info;
 		if (cards[bus_info].empty())
 			cards[bus_info] += std::string((char *)vcap.card) + " (" + bus_info + "):\n";
@@ -2535,7 +2535,7 @@ int main(int argc, char **argv)
 		return 1;
 	}
 
-	if ((fd = open(device, O_RDWR)) < 0) {
+	if ((fd = test_open(device, O_RDWR)) < 0) {
 		fprintf(stderr, "Failed to open %s: %s\n", device,
 			strerror(errno));
 		exit(1);
@@ -3693,6 +3693,6 @@ int main(int argc, char **argv)
 			perror("VIDIOC_QUERYCAP");
 	}
 
-	close(fd);
+	test_close(fd);
 	exit(app_result);
 }
-- 
1.7.5.4

