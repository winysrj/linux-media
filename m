Return-path: <linux-media-owner@vger.kernel.org>
Received: from ams-iport-3.cisco.com ([144.254.224.146]:22846 "EHLO
	ams-iport-3.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754658Ab3HALFh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 1 Aug 2013 07:05:37 -0400
Received: from bwinther.localnet (dhcp-10-54-92-49.cisco.com [10.54.92.49])
	by ams-core-2.cisco.com (8.14.5/8.14.5) with ESMTP id r71B5X3H019443
	for <linux-media@vger.kernel.org>; Thu, 1 Aug 2013 11:05:33 GMT
From: =?ISO-8859-1?Q?B=E5rd?= Eirik Winther <bwinther@cisco.com>
To: linux-media@vger.kernel.org
Subject: Re: [PATCHv2 FINAL 6/6] qv4l2: add OpenGL rendering
Date: Thu, 01 Aug 2013 13:05:34 +0200
Message-ID: <1688697.agkONg0tYT@bwinther>
In-Reply-To: <fc31f05e803a960fbe31bd3b150567ff4fc3b362.1375172029.git.bwinther@cisco.com>
References: <fe355bb3e887a32d91640eb394ab9c069c8104a6.1375172029.git.bwinther@cisco.com> <fc31f05e803a960fbe31bd3b150567ff4fc3b362.1375172029.git.bwinther@cisco.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tuesday, July 30, 2013 10:15:24 AM you wrote:
> [PATCHv2 FINAL 6/6] qv4l2: add OpenGL rendering
>From 505e803da95dd7c4aeb9d7ec4661c83bb743da1e Mon Sep 17 00:00:00 2001
Message-Id: <505e803da95dd7c4aeb9d7ec4661c83bb743da1e.1375355021.git.bwinther@cisco.com>
From: =?UTF-8?q?B=C3=A5rd=20Eirik=20Winther?= <bwinther@cisco.com>
Date: Thu, 1 Aug 2013 13:02:43 +0200
Subject: [PATCH] qv4l2: fix compile error
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Fixes a compile error caused when opengl is not available

Signed-off-by: Bård Eirik Winther <bwinther@cisco.com>
---
 utils/qv4l2/capture-win-gl.cpp | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/utils/qv4l2/capture-win-gl.cpp b/utils/qv4l2/capture-win-gl.cpp
index 807d9e9..52412c7 100644
--- a/utils/qv4l2/capture-win-gl.cpp
+++ b/utils/qv4l2/capture-win-gl.cpp
@@ -26,7 +26,9 @@
 
 CaptureWinGL::CaptureWinGL()
 {
+#ifdef ENABLE_GL
 	CaptureWin::buildWindow(&m_videoSurface);
+#endif
 	CaptureWin::setWindowTitle("V4L2 Capture (OpenGL)");
 }
 
-- 
1.8.3.2


