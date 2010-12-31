Return-path: <mchehab@gaivota>
Received: from mx1.redhat.com ([209.132.183.28]:12871 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753623Ab0LaOzc (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 31 Dec 2010 09:55:32 -0500
Message-ID: <4D1DF072.7080408@redhat.com>
Date: Fri, 31 Dec 2010 16:02:10 +0100
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: nasty bug at qv4l2
References: <4D11E170.6050500@redhat.com> <4D14ABEE.40206@redhat.com> <201012241520.01460.hverkuil@xs4all.nl>
In-Reply-To: <201012241520.01460.hverkuil@xs4all.nl>
Content-Type: multipart/mixed;
 boundary="------------030702080403090803070503"
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

This is a multi-part message in MIME format.
--------------030702080403090803070503
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Hi,

Hans V. I've tested your patch for avoiding the double
conversion problem, and I can report it fixes the issue seen with
webcameras which need 90 degrees rotation.

While testing I found a bug in gspca, which gets triggered by
qv4l2 which makes it impossible to switch between userptr and
mmap mode. While fixing that I also found some locking issues in
gspca. As these all touch the gscpa core I'll send a patch set
to Jean Francois Moine for this.

With the issues in gspca fixed, I found a bug in qv4l2 when using
read mode in raw mode (not passing the correct src_size to
libv4lconvert_convert).

I've attached 2 patches to qv4l2, fixing the read issue and a similar
issue in mmap / userptr mode. These apply on top of your patch.

Regards,

Hans

--------------030702080403090803070503
Content-Type: text/plain;
 name="0001-qv4l2-Check-and-use-result-of-read.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="0001-qv4l2-Check-and-use-result-of-read.patch"

>From d3393364292441fca894186c406a7e9ee982d243 Mon Sep 17 00:00:00 2001
From: Hans de Goede <hdegoede@redhat.com>
Date: Fri, 31 Dec 2010 11:50:28 +0100
Subject: [PATCH 1/2] qv4l2: Check and use result of read()

qv4l2 was calling libv4lconvert_convert with a src size of fmt.pix.sizeimage,
rather then using the actual amount of bytes read. This causes decompressors
which check if they have consumed the entire compressed frame (ie pjpg) to
error out, because they were not being passed the actual frame size.

This patch fixes this, and also adds reporting of libv4lconvert_convert
errors.

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
---
 utils/qv4l2/qv4l2.cpp |   14 ++++++++++++--
 1 files changed, 12 insertions(+), 2 deletions(-)

diff --git a/utils/qv4l2/qv4l2.cpp b/utils/qv4l2/qv4l2.cpp
index a085f86..1876b3c 100644
--- a/utils/qv4l2/qv4l2.cpp
+++ b/utils/qv4l2/qv4l2.cpp
@@ -178,11 +178,18 @@ void ApplicationWindow::capFrame()
 	switch (m_capMethod) {
 	case methodRead:
 		s = read(m_frameData, m_capSrcFormat.fmt.pix.sizeimage);
+		if (s < 0) {
+			if (errno != EAGAIN) {
+				error("read");
+				m_capStartAct->setChecked(false);
+			}
+			return;
+		}
 		if (useWrapper())
-			memcpy(m_capImage->bits(), m_frameData, m_capSrcFormat.fmt.pix.sizeimage);
+			memcpy(m_capImage->bits(), m_frameData, s);
 		else
 			err = v4lconvert_convert(m_convertData, &m_capSrcFormat, &m_capDestFormat,
-				m_frameData, m_capSrcFormat.fmt.pix.sizeimage,
+				m_frameData, s,
 				m_capImage->bits(), m_capDestFormat.fmt.pix.sizeimage);
 		break;
 
@@ -227,6 +234,9 @@ void ApplicationWindow::capFrame()
 		qbuf(buf);
 		break;
 	}
+	if (err == -1)
+		error(v4lconvert_get_error_message(m_convertData));
+
 	m_capture->setImage(*m_capImage);
 	if (m_capture->frame() == 1)
 		refresh();
-- 
1.7.3.2


--------------030702080403090803070503
Content-Type: text/plain;
 name="0002-qv4l2-When-in-wrapped-mode-memcpy-the-actual-framesi.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename*0="0002-qv4l2-When-in-wrapped-mode-memcpy-the-actual-framesi.pa";
 filename*1="tch"

>From 4a3587e7466274f74d89a6608999887f3c62e66a Mon Sep 17 00:00:00 2001
From: Hans de Goede <hdegoede@redhat.com>
Date: Fri, 31 Dec 2010 11:55:44 +0100
Subject: [PATCH 2/2] qv4l2: When in wrapped mode memcpy the actual framesize

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
---
 utils/qv4l2/qv4l2.cpp |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/utils/qv4l2/qv4l2.cpp b/utils/qv4l2/qv4l2.cpp
index 1876b3c..bd1db3e 100644
--- a/utils/qv4l2/qv4l2.cpp
+++ b/utils/qv4l2/qv4l2.cpp
@@ -202,7 +202,7 @@ void ApplicationWindow::capFrame()
 
 		if (useWrapper())
 			memcpy(m_capImage->bits(), (unsigned char *)m_buffers[buf.index].start,
-					m_capSrcFormat.fmt.pix.sizeimage);
+					buf.bytesused);
 		else
 			err = v4lconvert_convert(m_convertData, &m_capSrcFormat, &m_capDestFormat,
 				(unsigned char *)m_buffers[buf.index].start, buf.bytesused,
@@ -225,7 +225,7 @@ void ApplicationWindow::capFrame()
 
 		if (useWrapper())
 			memcpy(m_capImage->bits(), (unsigned char *)buf.m.userptr,
-					m_capSrcFormat.fmt.pix.sizeimage);
+					buf.bytesused);
 		else
 			err = v4lconvert_convert(m_convertData, &m_capSrcFormat, &m_capDestFormat,
 				(unsigned char *)buf.m.userptr, buf.bytesused,
-- 
1.7.3.2


--------------030702080403090803070503--
