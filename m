Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m9MHvGQo010364
	for <video4linux-list@redhat.com>; Wed, 22 Oct 2008 13:57:16 -0400
Received: from sk.insite.com.br (sk.insite.com.br [66.135.32.93])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m9MHubuo009783
	for <video4linux-list@redhat.com>; Wed, 22 Oct 2008 13:56:37 -0400
Received: from [201.82.105.195] (helo=[192.168.1.101])
	by sk.insite.com.br with esmtps (TLSv1:AES256-SHA:256) (Exim 4.69)
	(envelope-from <diniz@wimobilis.com.br>) id 1Kshvs-00062P-D7
	for video4linux-list@redhat.com; Wed, 22 Oct 2008 15:55:45 -0200
From: Rafael Diniz <diniz@wimobilis.com.br>
To: video4linux-list@redhat.com
Date: Wed, 22 Oct 2008 16:02:09 -0200
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_hq2/IbV89pPxA8b"
Message-Id: <200810221602.09913.diniz@wimobilis.com.br>
Subject: [PATCH] Documentation update for cx88
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

--Boundary-00=_hq2/IbV89pPxA8b
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Attached is a patch that updates the cx88 documentation to add the fact the 
closed caption works for at least NTSC capture.

ps: I also updated the wiki at:
http://www.linuxtv.org/v4lwiki/index.php/Text_capture#cx88_devices

Thanks,
Rafael Diniz

--Boundary-00=_hq2/IbV89pPxA8b
Content-Type: text/x-diff; charset="us-ascii"; name="cx88-doc-update.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="cx88-doc-update.diff"

diff -r 963a30f13bbf linux/Documentation/video4linux/README.cx88
--- a/linux/Documentation/video4linux/README.cx88	Wed Sep 03 09:49:20 2008 +0100
+++ b/linux/Documentation/video4linux/README.cx88	Wed Oct 22 15:58:09 2008 -0200
@@ -27,8 +27,8 @@
 	  sound card) should be possible, but there is no code yet ...
 
 vbi
-	- some code present.  Doesn't crash any more, but also doesn't
-	  work yet ...
+	- Code present. Works for NTSC closed caption. PAL and other
+	  TV norms may or may not work.
 
 
 how to add support for new cards

--Boundary-00=_hq2/IbV89pPxA8b
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
--Boundary-00=_hq2/IbV89pPxA8b--
