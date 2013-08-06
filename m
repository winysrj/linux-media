Return-path: <linux-media-owner@vger.kernel.org>
Received: from ams-iport-2.cisco.com ([144.254.224.141]:6081 "EHLO
	ams-iport-2.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754540Ab3HFKWZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 6 Aug 2013 06:22:25 -0400
Received: from bwinther.cisco.com (dhcp-10-54-92-83.cisco.com [10.54.92.83])
	by ams-core-4.cisco.com (8.14.5/8.14.5) with ESMTP id r76AMGhI015841
	for <linux-media@vger.kernel.org>; Tue, 6 Aug 2013 10:22:22 GMT
From: =?UTF-8?q?B=C3=A5rd=20Eirik=20Winther?= <bwinther@cisco.com>
To: linux-media@vger.kernel.org
Subject: [PATCH 3/9] qv4l2: fix black screen with opengl after capture
Date: Tue,  6 Aug 2013 12:21:47 +0200
Message-Id: <f8b30154d21d2a795a97e2ce60bb7a75ead72163.1375784415.git.bwinther@cisco.com>
In-Reply-To: <1375784513-18701-1-git-send-email-bwinther@cisco.com>
References: <1375784513-18701-1-git-send-email-bwinther@cisco.com>
In-Reply-To: <f8457ccfdceb6e73b7990efe95f9e3b61d973747.1375784415.git.bwinther@cisco.com>
References: <f8457ccfdceb6e73b7990efe95f9e3b61d973747.1375784415.git.bwinther@cisco.com>
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
index 6071410..c8238c5 100644
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

