Return-path: <linux-media-owner@vger.kernel.org>
Received: from web56903.mail.re3.yahoo.com ([66.196.97.92]:32551 "HELO
	web56903.mail.re3.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751706AbZCPSK5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 16 Mar 2009 14:10:57 -0400
Message-ID: <164695.77575.qm@web56903.mail.re3.yahoo.com>
Date: Mon, 16 Mar 2009 11:10:54 -0700 (PDT)
From: Corey Taylor <johnfivealive@yahoo.com>
Subject: Problems with Hauppauge HVR 1600 and cx18 driver
To: linux-media@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


Hi, I just recently bought a Hauppauge Win TV HVR-1600 card and am using it with MythTV running on Ubuntu Intrepid 8.10 64-bit edition.

My hardware is an Asus A8N VM-CSM Motherboard with an Athlon 64 single core CPU.

I'm using the cx18 driver compiled from Mercurial (as of last weekend) and download the latest firmware files available from Hauppauge.

The card is working and I'm able to tune in clear QAM channels on Comcast Cable in Boston.

The
problem is that when recording HD content I see excessive tearing in
the recorded video. I thought it might be my on-board video causing
this but I transferred a recording over to another machine and the
video plays back with the same artifacts and tearing as when I play it
on the machine that recorded the video.

I previously had the KWorld ATSC 110 running in the same machine and it recorded HD content with no noticeable visual artifacts on the same cable line.

I've tried tweaking many different settings both in MythTV and in X11 and nothing has made the problem go away.

Is this card perhaps more sensistive to signal disruptions in my cable line perhaps?

If
no, I was thinking that the problem could be due to driver problems in
the current development code. Are there any workaround for this problem
or should I give up and switch back to my KWorld card?

Thanks very much!


      
