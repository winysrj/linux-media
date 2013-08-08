Return-path: <linux-media-owner@vger.kernel.org>
Received: from ams-iport-3.cisco.com ([144.254.224.146]:45035 "EHLO
	ams-iport-3.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934211Ab3HHMbr (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 8 Aug 2013 08:31:47 -0400
Received: from bwinther.cisco.com (dhcp-10-54-92-90.cisco.com [10.54.92.90])
	by ams-core-2.cisco.com (8.14.5/8.14.5) with ESMTP id r78CVcjZ014622
	for <linux-media@vger.kernel.org>; Thu, 8 Aug 2013 12:31:44 GMT
From: =?UTF-8?q?B=C3=A5rd=20Eirik=20Winther?= <bwinther@cisco.com>
To: linux-media@vger.kernel.org
Subject: [PATCHv2 3/9] qv4l2: fix black screen with opengl after capture
Date: Thu,  8 Aug 2013 14:31:21 +0200
Message-Id: <5c62833aa65136029a9bd712c796d3fbd06caf29.1375964980.git.bwinther@cisco.com>
In-Reply-To: <1375965087-16318-1-git-send-email-bwinther@cisco.com>
References: <1375965087-16318-1-git-send-email-bwinther@cisco.com>
In-Reply-To: <cdb6d3a353ce89599cd716e763e85e704b92f79c.1375964980.git.bwinther@cisco.com>
References: <cdb6d3a353ce89599cd716e763e85e704b92f79c.1375964980.git.bwinther@cisco.com>
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
1.8.4.rc1

