Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:44150 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751949AbZCYXdr (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 25 Mar 2009 19:33:47 -0400
Date: Thu, 26 Mar 2009 00:33:39 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Sid Boyce <sboyce@blueyonder.co.uk>
cc: =?ISO-8859-1?Q?Erik_Andr=E9n?= <erik.andren@gmail.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Jean-Francois Moine <moinejf@free.fr>
Subject: gspca: Logitech QuickCam Messenger no go (was Re: Asus PG221 monitor
 camera sensor not recognised)
In-Reply-To: <49CABAF8.4030306@blueyonder.co.uk>
Message-ID: <Pine.LNX.4.64.0903260022450.5795@axis700.grange>
References: <Pine.LNX.4.64.0903252026380.5795@axis700.grange>
 <49CA9228.5030105@gmail.com> <49CABAF8.4030306@blueyonder.co.uk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

sorry for hijacking the thread, just a quick notice to say, that my 
Logitech QuickCam Messenger webcam (USB_DEVICE(0x046d, 0x08da)) is not 
working with recent kernels either, but, it used to work with out-of-tree 
gspca, I think, gspcav1-20071224 did work (I might still be able to bring 
up the machine with which I used it back then and even boot that kernel), 
so, it shouldn't be very difficult to fix it again. I noticed, that that 
older version used a different sensor with this camera, so, I tried 
"force_sensor=tas5130cxx" with 2.6.28, but it didn't help either.

Notice, this is not very high priority for me, that's why I'm only 
reporting it now, but it would be good to have it fixed some time...

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
