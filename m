Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx4.wp.pl ([212.77.101.8]:42139 "EHLO mx4.wp.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751831Ab0EUMov (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 21 May 2010 08:44:51 -0400
Received: from static-ip-77-89-72-69.promax.media.pl (HELO belafonte2.lan) (p4trykx@[77.89.72.69])
          (envelope-sender <p4trykx@wp.pl>)
          by smtp.wp.pl (WP-SMTPD) with AES128-SHA encrypted SMTP
          for <linux-media@vger.kernel.org>; 21 May 2010 14:38:00 +0200
Content-Type: text/plain; charset=iso-8859-2; format=flowed; delsp=yes
Subject: bug in konicawc webcam driver
Date: Fri, 21 May 2010 14:37:48 +0200
To: linux-media@vger.kernel.org
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
From: Patryk <p4trykx@wp.pl>
Message-ID: <op.vc12pam6d4yz1b@belafonte2.lan>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


I have a problem with usb camera driver. It's konicawc. It was working
in previous kernels 2.4 for sure (I have an old installation of Slackware  
2.4.26)
and perhaps in 2.6. Now in the latest kernel it doesn't work.
The file is /drivers/media/video/usbvideo/konicawc.c
I couldn't find anyone in MAINTAINERS for this driver and also
can't google how to fix this bug.

The error message is "Lost sync on frames" the same as here
https://lists.linux-foundation.org/pipermail/bugme-new/2004-August/010977.html
There is a patch but it seems it's already applied in current source.

If it could help.I can try older version of 2.6 to find out when this  
driver broke.

-- 
Patryk
