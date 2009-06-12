Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.230]:56949 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760684AbZFLRgK (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 12 Jun 2009 13:36:10 -0400
From: Eduardo Valentin <eduardo.valentin@nokia.com>
To: "ext Hans Verkuil" <hverkuil@xs4all.nl>,
	"ext Mauro Carvalho Chehab" <mchehab@infradead.org>
Cc: "Nurkkala Eero.An (EXT-Offcode/Oulu)" <ext-Eero.Nurkkala@nokia.com>,
	"Aaltonen Matti.J (Nokia-D/Tampere)" <matti.j.aaltonen@nokia.com>,
	"ext Douglas Schilling Landgraf" <dougsland@gmail.com>,
	Linux-Media <linux-media@vger.kernel.org>,
	Eduardo Valentin <eduardo.valentin@nokia.com>
Subject: [PATCHv7 4/9] v4l2-ctl: Add support for FM TX controls
Date: Fri, 12 Jun 2009 20:30:35 +0300
Message-Id: <1244827840-886-5-git-send-email-eduardo.valentin@nokia.com>
In-Reply-To: <1244827840-886-4-git-send-email-eduardo.valentin@nokia.com>
References: <1244827840-886-1-git-send-email-eduardo.valentin@nokia.com>
 <1244827840-886-2-git-send-email-eduardo.valentin@nokia.com>
 <1244827840-886-3-git-send-email-eduardo.valentin@nokia.com>
 <1244827840-886-4-git-send-email-eduardo.valentin@nokia.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch adds simple support for FM TX extended controls
on v4l2-ctl utility.

Signed-off-by: Eduardo Valentin <eduardo.valentin@nokia.com>
---
 v4l2-apps/util/v4l2-ctl.cpp |   36 ++++++++++++++++++++++++++++++++++++
 1 files changed, 36 insertions(+), 0 deletions(-)

diff --git a/v4l2-apps/util/v4l2-ctl.cpp b/v4l2-apps/util/v4l2-ctl.cpp
index 2c7290f..45a2310 100644
--- a/v4l2-apps/util/v4l2-ctl.cpp
+++ b/v4l2-apps/util/v4l2-ctl.cpp
@@ -148,6 +148,7 @@ typedef std::vector<struct v4l2_ext_control> ctrl_list;
 static ctrl_list user_ctrls;
 static ctrl_list mpeg_ctrls;
 static ctrl_list camera_ctrls;
+static ctrl_list fm_tx_ctrls;
 
 typedef std::map<std::string, unsigned> ctrl_strmap;
 static ctrl_strmap ctrl_str2id;
@@ -2166,6 +2167,8 @@ set_vid_fmt_error:
 				mpeg_ctrls.push_back(ctrl);
 			else if (V4L2_CTRL_ID2CLASS(ctrl.id) == V4L2_CTRL_CLASS_CAMERA)
 				camera_ctrls.push_back(ctrl);
+			else if (V4L2_CTRL_ID2CLASS(ctrl.id) == V4L2_CTRL_CLASS_FM_TX)
+				fm_tx_ctrls.push_back(ctrl);
 			else
 				user_ctrls.push_back(ctrl);
 		}
@@ -2212,6 +2215,22 @@ set_vid_fmt_error:
 				}
 			}
 		}
+		if (fm_tx_ctrls.size()) {
+			ctrls.ctrl_class = V4L2_CTRL_CLASS_FM_TX;
+			ctrls.count = fm_tx_ctrls.size();
+			ctrls.controls = &fm_tx_ctrls[0];
+			if (doioctl(fd, VIDIOC_S_EXT_CTRLS, &ctrls, "VIDIOC_S_EXT_CTRLS")) {
+				if (ctrls.error_idx >= ctrls.count) {
+					fprintf(stderr, "Error setting FM Modulator controls: %s\n",
+						strerror(errno));
+				}
+				else {
+					fprintf(stderr, "%s: %s\n",
+						ctrl_id2str[fm_tx_ctrls[ctrls.error_idx].id].c_str(),
+						strerror(errno));
+				}
+			}
+		}
 	}
 
 	/* Get options */
@@ -2429,6 +2448,7 @@ set_vid_fmt_error:
 		mpeg_ctrls.clear();
 		camera_ctrls.clear();
 		user_ctrls.clear();
+		fm_tx_ctrls.clear();
 		for (ctrl_get_list::iterator iter = get_ctrls.begin();
 				iter != get_ctrls.end(); ++iter) {
 			struct v4l2_ext_control ctrl = { 0 };
@@ -2443,6 +2463,8 @@ set_vid_fmt_error:
 				mpeg_ctrls.push_back(ctrl);
 			else if (V4L2_CTRL_ID2CLASS(ctrl.id) == V4L2_CTRL_CLASS_CAMERA)
 				camera_ctrls.push_back(ctrl);
+			else if (V4L2_CTRL_ID2CLASS(ctrl.id) == V4L2_CTRL_CLASS_FM_TX)
+				fm_tx_ctrls.push_back(ctrl);
 			else
 				user_ctrls.push_back(ctrl);
 		}
@@ -2481,6 +2503,20 @@ set_vid_fmt_error:
 					printf("%s: %d\n", ctrl_id2str[ctrl.id].c_str(), ctrl.value);
 			}
 		}
+		if (fm_tx_ctrls.size()) {
+			ctrls.ctrl_class = V4L2_CTRL_CLASS_FM_TX;
+			ctrls.count = fm_tx_ctrls.size();
+			ctrls.controls = &fm_tx_ctrls[0];
+			doioctl(fd, VIDIOC_G_EXT_CTRLS, &ctrls, "VIDIOC_G_EXT_CTRLS");
+			for (unsigned i = 0; i < fm_tx_ctrls.size(); i++) {
+				struct v4l2_ext_control ctrl = fm_tx_ctrls[i];
+
+				if (ctrl_id2type[ctrl.id] == V4L2_CTRL_TYPE_STRING)
+					printf("%s: '%s'\n", ctrl_id2str[ctrl.id].c_str(), ctrl.string);
+				else
+					printf("%s: %d\n", ctrl_id2str[ctrl.id].c_str(), ctrl.value);
+			}
+		}
 	}
 
 	if (options[OptGetTuner]) {
-- 
1.6.2.GIT

