Return-path: <linux-media-owner@vger.kernel.org>
Received: from kdh-gw.itdev.co.uk ([89.21.227.133]:60036 "EHLO
	hermes.kdh.itdev.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755003AbcGHL2E (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 8 Jul 2016 07:28:04 -0400
From: Nick Dyer <nick@shmanahar.org>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-media@vger.kernel.org,
	Benjamin Tissoires <benjamin.tissoires@redhat.com>,
	Benson Leung <bleung@chromium.org>,
	Alan Bowens <Alan.Bowens@atmel.com>,
	Javier Martinez Canillas <javier@osg.samsung.com>,
	Chris Healy <cphealy@gmail.com>,
	Henrik Rydberg <rydberg@bitmath.org>,
	Andrew Duggan <aduggan@synaptics.com>,
	James Chen <james.chen@emc.com.tw>,
	Dudley Du <dudl@cypress.com>,
	Andrew de los Reyes <adlr@chromium.org>,
	sheckylin@chromium.org, Peter Hutterer <peter.hutterer@who-t.net>,
	Florian Echtler <floe@butterbrot.org>, mchehab@osg.samsung.com,
	jon.older@itdev.co.uk, nick.dyer@itdev.co.uk,
	Nick Dyer <nick@shmanahar.org>
Subject: [PATCH] v4l2-compliance: Changes to support touch sensors
Date: Fri,  8 Jul 2016 12:27:55 +0100
Message-Id: <1467977275-17821-1-git-send-email-nick@shmanahar.org>
In-Reply-To: <1467977164-17551-1-git-send-email-nick@shmanahar.org>
References: <1467977164-17551-1-git-send-email-nick@shmanahar.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Nick Dyer <nick@shmanahar.org>
---
 utils/v4l2-compliance/v4l2-compliance.cpp        |   51 +++++++++++++++++++++-
 utils/v4l2-compliance/v4l2-compliance.h          |    1 +
 utils/v4l2-compliance/v4l2-test-input-output.cpp |    4 +-
 3 files changed, 53 insertions(+), 3 deletions(-)

diff --git a/utils/v4l2-compliance/v4l2-compliance.cpp b/utils/v4l2-compliance/v4l2-compliance.cpp
index 48dc8b4..ca2eec7 100644
--- a/utils/v4l2-compliance/v4l2-compliance.cpp
+++ b/utils/v4l2-compliance/v4l2-compliance.cpp
@@ -55,6 +55,7 @@ enum Option {
 	OptSetRadioDevice = 'r',
 	OptStreaming = 's',
 	OptSetSWRadioDevice = 'S',
+	OptSetTouchDevice = 't',
 	OptTrace = 'T',
 	OptVerbose = 'v',
 	OptSetVbiDevice = 'V',
@@ -105,6 +106,7 @@ static struct option long_options[] = {
 	{"vbi-device", required_argument, 0, OptSetVbiDevice},
 	{"sdr-device", required_argument, 0, OptSetSWRadioDevice},
 	{"expbuf-device", required_argument, 0, OptSetExpBufDevice},
+	{"touch-device", required_argument, 0, OptSetTouchDevice},
 	{"help", no_argument, 0, OptHelp},
 	{"verbose", no_argument, 0, OptVerbose},
 	{"no-warnings", no_argument, 0, OptNoWarnings},
@@ -134,6 +136,9 @@ static void usage(void)
 	printf("  -S, --sdr-device=<dev>\n");
 	printf("                     Use device <dev> as the SDR device.\n");
 	printf("                     If <dev> starts with a digit, then /dev/swradio<dev> is used.\n");
+	printf("  -t, --touch-device=<dev>\n");
+	printf("                     Use device <dev> as the touch device.\n");
+	printf("                     If <dev> starts with a digit, then /dev/v4l-touch<dev> is used.\n");
 	printf("  -e, --expbuf-device=<dev>\n");
 	printf("                     Use device <dev> to obtain DMABUF handles.\n");
 	printf("                     If <dev> starts with a digit, then /dev/video<dev> is used.\n");
@@ -206,6 +211,8 @@ std::string cap2s(unsigned cap)
 		s += "\t\tSDR Capture\n";
 	if (cap & V4L2_CAP_SDR_OUTPUT)
 		s += "\t\tSDR Output\n";
+	if (cap & V4L2_CAP_TOUCH)
+		s += "\t\tTouch Capture\n";
 	if (cap & V4L2_CAP_TUNER)
 		s += "\t\tTuner\n";
 	if (cap & V4L2_CAP_HW_FREQ_SEEK)
@@ -533,7 +540,8 @@ static int testCap(struct node *node)
 	    memcmp(vcap.bus_info, "ISA:", 4) &&
 	    memcmp(vcap.bus_info, "I2C:", 4) &&
 	    memcmp(vcap.bus_info, "parport", 7) &&
-	    memcmp(vcap.bus_info, "platform:", 9))
+	    memcmp(vcap.bus_info, "platform:", 9) &&
+	    memcmp(vcap.bus_info, "rmi4:", 5))
 		return fail("missing bus_info prefix ('%s')\n", vcap.bus_info);
 	fail_on_test((vcap.version >> 16) < 3);
 	fail_on_test(check_0(vcap.reserved, sizeof(vcap.reserved)));
@@ -673,6 +681,8 @@ int main(int argc, char **argv)
 	struct node radio_node2;
 	struct node sdr_node;
 	struct node sdr_node2;
+	struct node touch_node;
+	struct node touch_node2;
 	struct node expbuf_node;
 
 	/* command args */
@@ -682,6 +692,7 @@ int main(int argc, char **argv)
 	const char *vbi_device = NULL;		/* -V device */
 	const char *radio_device = NULL;	/* -r device */
 	const char *sdr_device = NULL;		/* -S device */
+	const char *touch_device = NULL;	/* -t device */
 	const char *expbuf_device = NULL;	/* --expbuf-device device */
 	struct v4l2_capability vcap;		/* list_cap */
 	unsigned frame_count = 60;
@@ -750,6 +761,15 @@ int main(int argc, char **argv)
 				sdr_device = newdev;
 			}
 			break;
+		case OptSetTouchDevice:
+			touch_device = optarg;
+			if (touch_device[0] >= '0' && touch_device[0] <= '9' && strlen(touch_device) <= 3) {
+				static char newdev[20];
+
+				sprintf(newdev, "/dev/v4l-touch%s", touch_device);
+				touch_device = newdev;
+			}
+			break;
 		case OptSetExpBufDevice:
 			expbuf_device = optarg;
 			if (expbuf_device[0] >= '0' && expbuf_device[0] <= '9' && strlen(expbuf_device) <= 3) {
@@ -839,7 +859,8 @@ int main(int argc, char **argv)
 	if (v1 == 2 && v2 == 6)
 		kernel_version = v3;
 
-	if (!video_device && !vbi_device && !radio_device && !sdr_device)
+	if (!video_device && !vbi_device && !radio_device &&
+	    !sdr_device && !touch_device)
 		video_device = "/dev/video0";
 
 	if (video_device) {
@@ -886,6 +907,17 @@ int main(int argc, char **argv)
 		}
 	}
 
+	if (touch_device) {
+		touch_node.s_trace(options[OptTrace]);
+		touch_node.s_direct(direct);
+		fd = touch_node.open(touch_device, false);
+		if (fd < 0) {
+			fprintf(stderr, "Failed to open %s: %s\n", touch_device,
+				strerror(errno));
+			exit(1);
+		}
+	}
+
 	if (expbuf_device) {
 		expbuf_node.s_trace(options[OptTrace]);
 		expbuf_node.s_direct(true);
@@ -913,6 +945,10 @@ int main(int argc, char **argv)
 		node = sdr_node;
 		device = sdr_device;
 		node.is_sdr = true;
+	} else if (touch_node.g_fd() >= 0) {
+		node = touch_node;
+		device = touch_device;
+		node.is_touch = true;
 	}
 	node.device = device;
 
@@ -1013,6 +1049,17 @@ int main(int argc, char **argv)
 			node.node2 = &sdr_node2;
 		}
 	}
+	if (touch_device) {
+		touch_node2 = node;
+		printf("\ttest second touch open: %s\n",
+				ok(touch_node2.open(touch_device, false) >= 0 ? 0 : errno));
+		if (touch_node2.g_fd() >= 0) {
+			printf("\ttest VIDIOC_QUERYCAP: %s\n", ok(testCap(&touch_node2)));
+			printf("\ttest VIDIOC_G/S_PRIORITY: %s\n",
+					ok(testPrio(&node, &touch_node2)));
+			node.node2 = &touch_node2;
+		}
+	}
 	printf("\n");
 
 	storeState(&node);
diff --git a/utils/v4l2-compliance/v4l2-compliance.h b/utils/v4l2-compliance/v4l2-compliance.h
index 67ecbf5..60432b1 100644
--- a/utils/v4l2-compliance/v4l2-compliance.h
+++ b/utils/v4l2-compliance/v4l2-compliance.h
@@ -68,6 +68,7 @@ struct base_node {
 	bool is_radio;
 	bool is_vbi;
 	bool is_sdr;
+	bool is_touch;
 	bool is_m2m;
 	bool is_planar;
 	bool can_capture;
diff --git a/utils/v4l2-compliance/v4l2-test-input-output.cpp b/utils/v4l2-compliance/v4l2-test-input-output.cpp
index 05daf85..3b56968 100644
--- a/utils/v4l2-compliance/v4l2-test-input-output.cpp
+++ b/utils/v4l2-compliance/v4l2-test-input-output.cpp
@@ -371,7 +371,9 @@ static int checkInput(struct node *node, const struct v4l2_input &descr, unsigne
 		return fail("invalid index\n");
 	if (check_ustring(descr.name, sizeof(descr.name)))
 		return fail("invalid name\n");
-	if (descr.type != V4L2_INPUT_TYPE_TUNER && descr.type != V4L2_INPUT_TYPE_CAMERA)
+	if (descr.type != V4L2_INPUT_TYPE_TUNER &&
+      descr.type != V4L2_INPUT_TYPE_CAMERA &&
+      descr.type != V4L2_INPUT_TYPE_TOUCH)
 		return fail("invalid type\n");
 	if (descr.type == V4L2_INPUT_TYPE_CAMERA && descr.tuner)
 		return fail("invalid tuner\n");
-- 
1.7.9.5

