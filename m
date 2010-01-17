Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtpq1.gn.mail.iss.as9143.net ([212.54.34.164]:33172 "EHLO
	smtpq1.gn.mail.iss.as9143.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754083Ab0AQPFf (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 17 Jan 2010 10:05:35 -0500
Received: from [212.54.34.138] (helo=smtp7.gn.mail.iss.as9143.net)
	by smtpq1.gn.mail.iss.as9143.net with esmtp (Exim 4.69)
	(envelope-from <joep@groovytunes.nl>)
	id 1NWWKi-00055A-Vu
	for linux-media@vger.kernel.org; Sun, 17 Jan 2010 15:42:29 +0100
Received: from 84-105-5-223.cable.quicknet.nl ([84.105.5.223] helo=werkstation.localnet)
	by smtp7.gn.mail.iss.as9143.net with esmtp (Exim 4.69)
	(envelope-from <joep@groovytunes.nl>)
	id 1NWWKi-0008Qn-FN
	for linux-media@vger.kernel.org; Sun, 17 Jan 2010 15:42:28 +0100
From: joep admiraal <joep@groovytunes.nl>
To: V4L Mailing List <linux-media@vger.kernel.org>
Subject: prof 7300
Date: Sun, 17 Jan 2010 15:42:27 +0100
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_THyULJdUfSvXAEV"
Message-Id: <201001171542.27314.joep@groovytunes.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--Boundary-00=_THyULJdUfSvXAEV
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit

I had some troubles with a prof 7300 dvb s-2 card.
I am running OpenSuse 11.2 with a recent hg copy of the v4l-dvb repository.
It was detected as a Hauppauge WinTV instead of a prof 7300.
After some runs with info_printk statements I found a problem in 
linux/drivers/media/video/cx88.c
As far as I can understand the code I would say card[core->nr] will always be 
smaller than ARRAY_SIZE(cx88_boards).
Therefore core->boardnr is never looked up from the cx88_subids array.
After I removed the check with ARRAY_SIZE the correct card is detected and I 
can watch tv with both my prof 7300 cards.
Can someone confirm if the patch I made is correct or explain what the purpose 
is of the ARRAY_SIZE check?


For search references:
I was getting this error in dmesg:
cx88[1]/2: dvb_register failed (err = -22)
cx88[1]/2: cx8802 probe failed, err = -22 

Regards,
Joep Admiraal

--Boundary-00=_THyULJdUfSvXAEV
Content-Type: text/x-patch;
  charset="UTF-8";
  name="prof7300.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="prof7300.diff"

diff -r b76072d765c4 linux/drivers/media/video/cx88/cx88-cards.c
--- a/linux/drivers/media/video/cx88/cx88-cards.c	Tue Dec 29 18:48:04 2009 +0000
+++ b/linux/drivers/media/video/cx88/cx88-cards.c	Sat Jan 16 16:44:36 2010 +0100
@@ -3436,8 +3436,8 @@
 
 	/* board config */
 	core->boardnr = UNSET;
-	if (card[core->nr] < ARRAY_SIZE(cx88_boards))
-		core->boardnr = card[core->nr];
+	//if (card[core->nr] < ARRAY_SIZE(cx88_boards))
+	//	core->boardnr = card[core->nr];
 	for (i = 0; UNSET == core->boardnr && i < ARRAY_SIZE(cx88_subids); i++)
 		if (pci->subsystem_vendor == cx88_subids[i].subvendor &&
 		    pci->subsystem_device == cx88_subids[i].subdevice)

--Boundary-00=_THyULJdUfSvXAEV--
