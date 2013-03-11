Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr8.xs4all.nl ([194.109.24.28]:4487 "EHLO
	smtp-vbr8.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754156Ab3CKLrR (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 11 Mar 2013 07:47:17 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Volokh Konstantin <volokh84@gmail.com>,
	Pete Eberlein <pete@sensoray.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: =?UTF-8?q?=5BREVIEW=20PATCH=2042/42=5D=20MAINTAINERS=3A=20add=20the=20go7007=20driver=2E?=
Date: Mon, 11 Mar 2013 12:46:20 +0100
Message-Id: <6f8851517f7495c0aefaca92cca74680c23dd97e.1363000605.git.hans.verkuil@cisco.com>
In-Reply-To: <1363002380-19825-1-git-send-email-hverkuil@xs4all.nl>
References: <1363002380-19825-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <38bc3cc42d0c021432afd29c2c1e22cf380b06e0.1363000605.git.hans.verkuil@cisco.com>
References: <38bc3cc42d0c021432afd29c2c1e22cf380b06e0.1363000605.git.hans.verkuil@cisco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 MAINTAINERS |    5 +++++
 1 file changed, 5 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index ff2fcc9..5703edd 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -7550,6 +7550,11 @@ M:	David Täht <d@teklibre.com>
 S:	Odd Fixes
 F:	drivers/staging/frontier/
 
+STAGING - GO7007 MPEG CODEC
+M:	Hans Verkuil <hans.verkuil@cisco.com>
+S:	Maintained
+F:	drivers/staging/media/go7007/
+
 STAGING - INDUSTRIAL IO
 M:	Jonathan Cameron <jic23@cam.ac.uk>
 L:	linux-iio@vger.kernel.org
-- 
1.7.10.4

