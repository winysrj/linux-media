Return-path: <linux-media-owner@vger.kernel.org>
Received: from ams-iport-3.cisco.com ([144.254.224.146]:27993 "EHLO
	ams-iport-3.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966169Ab3HIMMh (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 9 Aug 2013 08:12:37 -0400
From: =?UTF-8?q?B=C3=A5rd=20Eirik=20Winther?= <bwinther@cisco.com>
To: linux-media@vger.kernel.org
Cc: baard.e.winther@wintherstormer.no
Subject: [PATCH FINAL 4/6] qv4l2: fix program input parameters
Date: Fri,  9 Aug 2013 14:12:10 +0200
Message-Id: <d55b463020f0f7f693379043c23bcc46be9fe2d9.1376049957.git.bwinther@cisco.com>
In-Reply-To: <1376050332-27290-1-git-send-email-bwinther@cisco.com>
References: <1376050332-27290-1-git-send-email-bwinther@cisco.com>
In-Reply-To: <42a47889f837e362abc7a527c1029329e62034b0.1376049957.git.bwinther@cisco.com>
References: <42a47889f837e362abc7a527c1029329e62034b0.1376049957.git.bwinther@cisco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Bård Eirik Winther <bwinther@cisco.com>
---
 utils/qv4l2/qv4l2.cpp | 137 ++++++++++++++++++++++++++++++++++++++++++++------
 1 file changed, 121 insertions(+), 16 deletions(-)

diff --git a/utils/qv4l2/qv4l2.cpp b/utils/qv4l2/qv4l2.cpp
index 7e2dba0..a0f21cd 100644
--- a/utils/qv4l2/qv4l2.cpp
+++ b/utils/qv4l2/qv4l2.cpp
@@ -1158,33 +1158,138 @@ void ApplicationWindow::closeEvent(QCloseEvent *event)
 
 ApplicationWindow *g_mw;
 
+static void usage()
+{
+	printf("  Usage:\n"
+	       "  qv4l2 [-R] [-h] [-d <dev>] [-r <dev>] [-V <dev>]\n"
+	       "\n  -d, --device=<dev> use device <dev> as the video device\n"
+	       "                     if <dev> is a number, then /dev/video<dev> is used\n"
+	       "  -r, --radio-device=<dev> use device <dev> as the radio device\n"
+	       "                     if <dev> is a number, then /dev/radio<dev> is used\n"
+	       "  -V, --vbi-device=<dev> use device <dev> as the vbi device\n"
+	       "                     if <dev> is a number, then /dev/vbi<dev> is used\n"
+	       "  -h, --help         display this help message\n"
+	       "  -R, --raw          open device in raw mode.\n");
+}
+
+static void usageError(const char *msg)
+{
+	printf("Missing parameter for %s\n", msg);
+	usage();
+}
+
+static QString getDeviceName(QString dev, QString &name)
+{
+	bool ok;
+	name.toInt(&ok);
+	return ok ? QString("%1%2").arg(dev).arg(name) : name;
+}
+
 int main(int argc, char **argv)
 {
 	QApplication a(argc, argv);
-	QString device = "/dev/video0";
 	bool raw = false;
-	bool help = false;
-	int i;
+	QString device;
+	QString video_device;
+	QString radio_device;
+	QString vbi_device;
 
 	a.setWindowIcon(QIcon(":/qv4l2.png"));
 	g_mw = new ApplicationWindow();
 	g_mw->setWindowTitle("V4L2 Test Bench");
-	for (i = 1; i < argc; i++) {
-		const char *arg = a.argv()[i];
 
-		if (!strcmp(arg, "-r"))
+	QStringList args = a.arguments();
+	for (int i = 1; i < args.size(); i++) {
+		if (args[i] == "-d" || args[i] == "--device") {
+			++i;
+			if (i >= args.size()) {
+				usageError("-d");
+				return 0;
+			}
+
+			video_device = args[i];
+			if (video_device.startsWith("-")) {
+				usageError("-d");
+				return 0;
+			}
+
+		} else if (args[i] == "-r" || args[i] == "--radio-device") {
+			++i;
+			if (i >= args.size()) {
+				usageError("-r");
+				return 0;
+			}
+
+			radio_device = args[i];
+			if (radio_device.startsWith("-")) {
+				usageError("-r");
+				return 0;
+			}
+
+		} else if (args[i] == "-V" || args[i] == "--vbi-device") {
+			++i;
+			if (i >= args.size()) {
+				usageError("-V");
+				return 0;
+			}
+
+			vbi_device = args[i];
+			if (vbi_device.startsWith("-")) {
+				usageError("-V");
+				return 0;
+			}
+
+		} else if (args[i].startsWith("--device")) {
+			QStringList param = args[i].split("=");
+			if (param.size() == 2) {
+				video_device = param[1];
+			} else {
+				usageError("--device");
+				return 0;
+			}
+
+		} else if (args[i].startsWith("--radio-device")) {
+			QStringList param = args[i].split("=");
+			if (param.size() == 2) {
+				radio_device = param[1];
+			} else {
+				usageError("--radio-device");
+				return 0;
+			}
+
+
+		} else if (args[i].startsWith("--vbi-device")) {
+			QStringList param = args[i].split("=");
+			if (param.size() == 2) {
+				vbi_device = param[1];
+			} else {
+				usageError("--vbi-device");
+				return 0;
+			}
+
+		} else if (args[i] == "-h" || args[i] == "--help") {
+			usage();
+			return 0;
+
+		} else if (args[i] == "-R" || args[i] == "--raw") {
 			raw = true;
-		else if (!strcmp(arg, "-h"))
-			help = true;
-		else if (arg[0] != '-')
-			device = arg;
-	}
-	if (help) {
-		printf("qv4l2 [-r] [-h] [device node]\n\n"
-		       "-h\tthis help message\n"
-		       "-r\topen device node in raw mode\n");
-		return 0;
+
+
+		} else {
+			printf("Invalid argument %s\n", args[i].toAscii().data());
+			return 0;
+		}
 	}
+
+	if (video_device != NULL)
+		device = getDeviceName("/dev/video", video_device);
+	else if (radio_device != NULL)
+		device = getDeviceName("/dev/radio", radio_device);
+	else if (vbi_device != NULL)
+		device = getDeviceName("/dev/vbi", vbi_device);
+	else
+		device = "/dev/video0";
+
 	g_mw->setDevice(device, raw);
 	g_mw->show();
 	a.connect(&a, SIGNAL(lastWindowClosed()), &a, SLOT(quit()));
-- 
1.8.4.rc1

