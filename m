Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.230]:51931 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753571AbZGXQwu (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 24 Jul 2009 12:52:50 -0400
From: Eduardo Valentin <eduardo.valentin@nokia.com>
To: "ext Hans Verkuil" <hverkuil@xs4all.nl>,
	"ext Mauro Carvalho Chehab" <mchehab@infradead.org>
Cc: "ext Douglas Schilling Landgraf" <dougsland@gmail.com>,
	"Nurkkala Eero.An (EXT-Offcode/Oulu)" <ext-Eero.Nurkkala@nokia.com>,
	"Aaltonen Matti.J (Nokia-D/Tampere)" <matti.j.aaltonen@nokia.com>,
	Linux-Media <linux-media@vger.kernel.org>,
	Eduardo Valentin <eduardo.valentin@nokia.com>
Subject: [PATCH 1/1] v4l2-ctl: Add G_MODULATOR before set/get frequency
Date: Fri, 24 Jul 2009 19:42:12 +0300
Message-Id: <1248453732-1966-1-git-send-email-eduardo.valentin@nokia.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

As there can be modulator devices with get/set frequency
callbacks, this patch adds support to them in v4l2-ctl utility.

Signed-off-by: Eduardo Valentin <eduardo.valentin@nokia.com>
---
 v4l2-apps/util/v4l2-ctl.cpp |   10 +++++++++-
 1 files changed, 9 insertions(+), 1 deletions(-)

diff --git a/v4l2-apps/util/v4l2-ctl.cpp b/v4l2-apps/util/v4l2-ctl.cpp
index fc9e459..ff74177 100644
--- a/v4l2-apps/util/v4l2-ctl.cpp
+++ b/v4l2-apps/util/v4l2-ctl.cpp
@@ -1962,12 +1962,16 @@ int main(int argc, char **argv)
 
 	if (options[OptSetFreq]) {
 		double fac = 16;
+		struct v4l2_modulator mt;
 
+		memset(&mt, 0, sizeof(struct v4l2_modulator));
 		if (doioctl(fd, VIDIOC_G_TUNER, &tuner, "VIDIOC_G_TUNER") == 0) {
 			fac = (tuner.capability & V4L2_TUNER_CAP_LOW) ? 16000 : 16;
+			vf.type = tuner.type;
+		} else if (doioctl(fd, VIDIOC_G_MODULATOR, &mt, "VIDIOC_G_MODULATOR") == 0) {
+			fac = (mt.capability & V4L2_TUNER_CAP_LOW) ? 16000 : 16;
 		}
 		vf.tuner = 0;
-		vf.type = tuner.type;
 		vf.frequency = __u32(freq * fac);
 		if (doioctl(fd, VIDIOC_S_FREQUENCY, &vf,
 			"VIDIOC_S_FREQUENCY") == 0)
@@ -2418,9 +2422,13 @@ set_vid_fmt_error:
 
 	if (options[OptGetFreq]) {
 		double fac = 16;
+		struct v4l2_modulator mt;
 
+		memset(&mt, 0, sizeof(struct v4l2_modulator));
 		if (doioctl(fd, VIDIOC_G_TUNER, &tuner, "VIDIOC_G_TUNER") == 0) {
 			fac = (tuner.capability & V4L2_TUNER_CAP_LOW) ? 16000 : 16;
+		} else if (doioctl(fd, VIDIOC_G_MODULATOR, &mt, "VIDIOC_G_MODULATOR") == 0) {
+			fac = (mt.capability & V4L2_TUNER_CAP_LOW) ? 16000 : 16;
 		}
 		vf.tuner = 0;
 		if (doioctl(fd, VIDIOC_G_FREQUENCY, &vf, "VIDIOC_G_FREQUENCY") == 0)
-- 
1.6.2.GIT

