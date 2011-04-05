Return-path: <mchehab@pedra>
Received: from perceval.ideasonboard.com ([95.142.166.194]:43019 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752518Ab1DEH5L (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 5 Apr 2011 03:57:11 -0400
Received: from localhost.localdomain (unknown [91.178.236.143])
	by perceval.ideasonboard.com (Postfix) with ESMTPSA id 2AE9E35B68
	for <linux-media@vger.kernel.org>; Tue,  5 Apr 2011 07:57:10 +0000 (UTC)
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Subject: [PATCH 01/14] media: Use correct ioctl name in MEDIA_IOC_SETUP_LINK documentation
Date: Tue,  5 Apr 2011 09:57:23 +0200
Message-Id: <1301990256-6963-2-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1301990256-6963-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1301990256-6963-1-git-send-email-laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

The documentation incorrectly refers to MEDIA_IOC_ENUM_LINKS, fix it.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 Documentation/DocBook/v4l/media-ioc-setup-link.xml |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/Documentation/DocBook/v4l/media-ioc-setup-link.xml b/Documentation/DocBook/v4l/media-ioc-setup-link.xml
index 2331e76..cec97af 100644
--- a/Documentation/DocBook/v4l/media-ioc-setup-link.xml
+++ b/Documentation/DocBook/v4l/media-ioc-setup-link.xml
@@ -34,7 +34,7 @@
       <varlistentry>
 	<term><parameter>request</parameter></term>
 	<listitem>
-	  <para>MEDIA_IOC_ENUM_LINKS</para>
+	  <para>MEDIA_IOC_SETUP_LINK</para>
 	</listitem>
       </varlistentry>
       <varlistentry>
-- 
1.7.3.4

