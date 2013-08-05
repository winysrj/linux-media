Return-path: <linux-media-owner@vger.kernel.org>
Received: from ams-iport-4.cisco.com ([144.254.224.147]:23517 "EHLO
	ams-iport-4.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755334Ab3HEI5l (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 5 Aug 2013 04:57:41 -0400
Received: from bwinther.cisco.com (dhcp-10-54-92-49.cisco.com [10.54.92.49])
	by ams-core-4.cisco.com (8.14.5/8.14.5) with ESMTP id r758vY7d001512
	for <linux-media@vger.kernel.org>; Mon, 5 Aug 2013 08:57:38 GMT
From: =?UTF-8?q?B=C3=A5rd=20Eirik=20Winther?= <bwinther@cisco.com>
To: linux-media@vger.kernel.org
Subject: [RFC PATCH 2/7] qv4l2: fix black screen with opengl after capture
Date: Mon,  5 Aug 2013 10:56:52 +0200
Message-Id: <a4cd4e55215374c17607b5ed8971506179d18c8b.1375692973.git.bwinther@cisco.com>
In-Reply-To: <1375693017-6079-1-git-send-email-bwinther@cisco.com>
References: <1375693017-6079-1-git-send-email-bwinther@cisco.com>
In-Reply-To: <8be0aea2a33100972c3f9c74a8c981fca0e7a2aa.1375692973.git.bwinther@cisco.com>
References: <8be0aea2a33100972c3f9c74a8c981fca0e7a2aa.1375692973.git.bwinther@cisco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Fixes the issue when the window was beeing resized/moved
and the frame image would become black.

Signed-off-by: Bård Eirik Winther <bwinther@cisco.com>
---
 utils/qv4l2/capture-win-gl.cpp | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/utils/qv4l2/capture-win-gl.cpp b/utils/qv4l2/capture-win-gl.cpp
index bae6569..edae60f 100644
--- a/utils/qv4l2/capture-win-gl.cpp
+++ b/utils/qv4l2/capture-win-gl.cpp
@@ -253,6 +253,12 @@ void CaptureWinGLEngine::paintGL()
 		changeShader();
 
 	if (m_frameData == NULL) {
+		glBegin(GL_QUADS);
+		glTexCoord2f(0.0f, 0.0f); glVertex2f(0.0, 0);
+		glTexCoord2f(1.0f, 0.0f); glVertex2f(m_frameWidth, 0);
+		glTexCoord2f(1.0f, 1.0f); glVertex2f(m_frameWidth, m_frameHeight);
+		glTexCoord2f(0.0f, 1.0f); glVertex2f(0, m_frameHeight);
+		glEnd();
 		return;
 	}
 
-- 
1.8.3.2

