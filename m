Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:51109 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752507AbZDFWkH (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 6 Apr 2009 18:40:07 -0400
Received: from int-mx2.corp.redhat.com (int-mx2.corp.redhat.com [172.16.27.26])
	by mx2.redhat.com (8.13.8/8.13.8) with ESMTP id n36Me5xO017959
	for <linux-media@vger.kernel.org>; Mon, 6 Apr 2009 18:40:05 -0400
Received: from ns3.rdu.redhat.com (ns3.rdu.redhat.com [10.11.255.199])
	by int-mx2.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n36Me6jV021648
	for <linux-media@vger.kernel.org>; Mon, 6 Apr 2009 18:40:07 -0400
Received: from pedra.chehab.org (vpn-12-109.rdu.redhat.com [10.11.12.109])
	by ns3.rdu.redhat.com (8.13.8/8.13.8) with ESMTP id n36Me369008558
	for <linux-media@vger.kernel.org>; Mon, 6 Apr 2009 18:40:04 -0400
Date: Mon, 6 Apr 2009 19:39:56 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Fw: [PATCH resend] UVC: uvc_status_cleanup(): undefined reference
 to `input_unregister_device'
Message-ID: <20090406193956.3aff488e@pedra.chehab.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



Forwarded message:

Date: Mon, 6 Apr 2009 14:57:55 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>,        lkml <linux-kernel@vger.kernel.org>
Cc: Laurent Pinchart <laurent.pinchart@skynet.be>,        "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: [PATCH resend] UVC: uvc_status_cleanup(): undefined reference to `input_unregister_device'


From: Randy Dunlap <randy.dunlap@oracle.com>

Fix build errors when USB_VIDEO_CLASS=y and INPUT=m.
Fixes kernel bugzilla #12671.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Acked-by: Laurent Pinchart <laurent.pinchart@skynet.be>
---
 drivers/media/video/uvc/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- mmotm-2009-0214-0049.orig/drivers/media/video/uvc/Kconfig
+++ mmotm-2009-0214-0049/drivers/media/video/uvc/Kconfig
@@ -9,7 +9,7 @@ config USB_VIDEO_CLASS
 config USB_VIDEO_CLASS_INPUT_EVDEV
 	bool "UVC input events device support"
 	default y
-	depends on USB_VIDEO_CLASS && INPUT
+	depends on USB_VIDEO_CLASS=INPUT || INPUT=y
 	---help---
 	  This option makes USB Video Class devices register an input device
 	  to report button events.



-- 

Cheers,
Mauro
