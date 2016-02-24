Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:55162 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751760AbcBXLHV (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 24 Feb 2016 06:07:21 -0500
From: Hans de Goede <hdegoede@redhat.com>
To: mchehab@osg.samsung.com
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Hans de Goede <hdegoede@redhat.com>
Subject: [PATCH tvtime 4/4] default.tvtime.xml: Comment out V4LDevice so that we use the builtin default
Date: Wed, 24 Feb 2016 12:07:07 +0100
Message-Id: <1456312027-8484-4-git-send-email-hdegoede@redhat.com>
In-Reply-To: <1456312027-8484-1-git-send-email-hdegoede@redhat.com>
References: <1456312027-8484-1-git-send-email-hdegoede@redhat.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The builtin default V4LDevice is "auto" on Linux and "/dev/video0" on
other platforms. So we should not set a V4LDevice in our global
/etc/tvtime/tvtime.xml, as that will always be wrong on one platfrom
or the other.

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
---
 docs/html/default.tvtime.xml | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/docs/html/default.tvtime.xml b/docs/html/default.tvtime.xml
index 28aa6b4..285e27e 100644
--- a/docs/html/default.tvtime.xml
+++ b/docs/html/default.tvtime.xml
@@ -19,7 +19,9 @@
 
 
   <!-- This sets the default capture device to use. -->
+  <!--
   <option name="V4LDevice" value="/dev/video0"/>
+  -->
 
   <!--
     This sets the default capture card input to be opened by tvtime.
-- 
2.7.1

