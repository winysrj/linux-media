Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:42294 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757705AbZDFWkW (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 6 Apr 2009 18:40:22 -0400
Received: from int-mx2.corp.redhat.com (int-mx2.corp.redhat.com [172.16.27.26])
	by mx2.redhat.com (8.13.8/8.13.8) with ESMTP id n36MeLc9017980
	for <linux-media@vger.kernel.org>; Mon, 6 Apr 2009 18:40:21 -0400
Received: from ns3.rdu.redhat.com (ns3.rdu.redhat.com [10.11.255.199])
	by int-mx2.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n36MeMNL021688
	for <linux-media@vger.kernel.org>; Mon, 6 Apr 2009 18:40:23 -0400
Received: from pedra.chehab.org (vpn-12-109.rdu.redhat.com [10.11.12.109])
	by ns3.rdu.redhat.com (8.13.8/8.13.8) with ESMTP id n36MeJ9g008745
	for <linux-media@vger.kernel.org>; Mon, 6 Apr 2009 18:40:20 -0400
Date: Mon, 6 Apr 2009 19:40:12 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Fw: [PATCH resend] PWC: fix build error when CONFIG_INPUT=m
Message-ID: <20090406194012.3f51428a@pedra.chehab.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



Forwarded message:

Date: Mon, 6 Apr 2009 14:59:31 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>,        lkml <linux-kernel@vger.kernel.org>
Cc: Laurent Pinchart <laurent.pinchart@skynet.be>,        "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: [PATCH resend] PWC: fix build error when CONFIG_INPUT=m


From: Randy Dunlap <randy.dunlap@oracle.com>

Fix build errors when USB_PWC=y and INPUT=m.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 drivers/media/video/pwc/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- mmotm-2009-0214-0049.orig/drivers/media/video/pwc/Kconfig
+++ mmotm-2009-0214-0049/drivers/media/video/pwc/Kconfig
@@ -39,7 +39,7 @@ config USB_PWC_DEBUG
 config USB_PWC_INPUT_EVDEV
 	bool "USB Philips Cameras input events device support"
 	default y
-	depends on USB_PWC && INPUT
+	depends on USB_PWC=INPUT || INPUT=y
 	---help---
 	  This option makes USB Philips cameras register the snapshot button as
 	  an input device to report button events.


-- 

Cheers,
Mauro
