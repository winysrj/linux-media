Return-path: <linux-media-owner@vger.kernel.org>
Received: from web27006.mail.ukl.yahoo.com ([217.146.177.6]:36427 "HELO
	web27006.mail.ukl.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751294AbZKOVPO convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 15 Nov 2009 16:15:14 -0500
Message-ID: <865524.48833.qm@web27006.mail.ukl.yahoo.com>
Date: Sun, 15 Nov 2009 21:08:38 +0000 (GMT)
From: bifferos <bifferos@yahoo.co.uk>
Subject: libv4l2: error dequeuing buf: Input/output error
To: linux-media@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


Hi all,

Can anyone give any clue as to why I might get this error 
when capturing from a PAC207 webcam?  It happens after a 6-7 
second delay when capturing.

I've seen this with 2.6.30.1, 2.6.30.5 and 2.6.32-rc7, however 
I can run the same camera on another (much faster) system using 
the same kernel(s) and same gspca driver and it works fine, 
making me think this is a timing issue.

I'm testing with the v4lgrab.c program, compiled statically 
against libv4l2.  A quick google indicates I'm not the only
one encountering the problem. 

thanks,
Biff.


      
