Return-path: <linux-media-owner@vger.kernel.org>
Received: from ams-iport-4.cisco.com ([144.254.224.147]:6231 "EHLO
	ams-iport-4.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965082Ab3HHNrx (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 8 Aug 2013 09:47:53 -0400
Received: from bwinther.cisco.com (dhcp-10-54-92-90.cisco.com [10.54.92.90])
	by ams-core-4.cisco.com (8.14.5/8.14.5) with ESMTP id r78Dlk9n032678
	for <linux-media@vger.kernel.org>; Thu, 8 Aug 2013 13:47:50 GMT
From: =?UTF-8?q?B=C3=A5rd=20Eirik=20Winther?= <bwinther@cisco.com>
To: linux-media@vger.kernel.org
Subject: [PATCH 2/2] qv4l2: fix input parameters
Date: Thu,  8 Aug 2013 15:47:38 +0200
Message-Id: <89b8944a1b449451f26951cb6961706fb0c7b0f7.1375969534.git.bwinther@cisco.com>
In-Reply-To: <1375969658-20415-1-git-send-email-bwinther@cisco.com>
References: <1375969658-20415-1-git-send-email-bwinther@cisco.com>
In-Reply-To: <c45fad89698912cf93481ab0801a3445ee0ef18e.1375969534.git.bwinther@cisco.com>
References: <c45fad89698912cf93481ab0801a3445ee0ef18e.1375969534.git.bwinther@cisco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Bård Eirik Winther <bwinther@cisco.com>
---
 utils/qv4l2/qv4l2.cpp | 112 ++++++++++++++++++++++++++++++++++++++++++--------
 1 file changed, 96 insertions(+), 16 deletions(-)

diff --git a/utils/qv4l2/qv4l2.cpp b/utils/qv4l2/qv4l2.cpp
index 892d9c3..644abe6 100644
--- a/utils/qv4l2/qv4l2.cpp
+++ b/utils/qv4l2/qv4l2.cpp
@@ -1146,33 +1146,113 @@ void ApplicationWindow::closeEvent(QCloseEvent *event)
 
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
+
+		if (args[i] == "-d" || args[i] == "--device") {
+			++i;
+			if (i >= args.size()) {
+				usageError("--device");
+				return 0;
+			}
+
+			video_device = args.at(i);
+			if (video_device.startsWith("-")) {
+				usageError("--device");
+				return 0;
+			}
+			break;
+
+		} else if (args[i] == "-r" || args[i] == "--radio-device") {
+			++i;
+			if (i >= args.size()) {
+				usageError("--radio-device");
+				return 0;
+			}
+
+			radio_device = args.at(i);
+			if (radio_device.startsWith("-")) {
+				usageError("--radio-device");
+				return 0;
+			}
+			break;
+
+		} else if (args[i] == "-V" || args[i] == "--vbi-device") {
+			++i;
+			if (i >= args.size()) {
+				usageError("--vbi-device");
+				return 0;
+			}
+
+			vbi_device = args.at(i);
+			if (vbi_device.startsWith("-")) {
+				usageError("--vbi-device");
+				return 0;
+			}
+			break;
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
+			break;
+		} else {
+			printf("Unknown argument %s\n", args[i].toAscii().data());
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

