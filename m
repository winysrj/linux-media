Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mta4.srv.hcvlny.cv.net ([167.206.4.199])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <stoth@linuxtv.org>) id 1JbJvG-0000eL-EL
	for linux-dvb@linuxtv.org; Mon, 17 Mar 2008 19:19:01 +0100
Received: from steven-toths-macbook-pro.local
	(ool-18bac60f.dyn.optonline.net [24.186.198.15]) by
	mta4.srv.hcvlny.cv.net
	(Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
	with ESMTP id <0JXW006P606NF170@mta4.srv.hcvlny.cv.net> for
	linux-dvb@linuxtv.org; Mon, 17 Mar 2008 14:18:24 -0400 (EDT)
Date: Mon, 17 Mar 2008 14:18:23 -0400
From: Steven Toth <stoth@linuxtv.org>
In-reply-to: <C82A808D35A16542ACB16AF56367E0580A7968FE@exchange01.nsighttel.com>
To: Mark A Jenks <Mark.Jenks@nsighttel.com>, linux-dvb <linux-dvb@linuxtv.org>
Message-id: <47DEB5EF.8010207@linuxtv.org>
MIME-version: 1.0
References: <C82A808D35A16542ACB16AF56367E0580A7968E9@exchange01.nsighttel.com>
	<c70a981c0803170530w711784f3me773ae49dd876e3d@mail.gmail.com>
	<c70a981c0803170531jdbe8396j41ecd8394b97b5bb@mail.gmail.com>
	<c70a981c0803170701k3ab93c60k6a59414ce8807398@mail.gmail.com>
	<47DE9362.4050706@linuxtv.org>
	<C82A808D35A16542ACB16AF56367E0580A7968FE@exchange01.nsighttel.com>
Subject: Re: [linux-dvb] HVR-1250, Suse 10.3, scan hangs, taints kernel.
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

CC'ing the mailing list back in.

Mark A Jenks wrote:
> Do you think I should push the kernel to 2.6.25? 

I maintain the driver on ubuntu 7.10, which I think has is 2.6.22-14 - 
or close to.

I have another AMD system at home that the driver completely freezes on, 
no idea why, total system lockup. I don't trust the PCIe chipset on it, 
it's an early chipset and a little flakey.

Other than that the driver's been pretty reliable.

Lots of noise recently on the mailing lists about video_buf related 
issues and potential race conditions.

Try running the system with a single cpu core and report back, also, 
just for the hell of it, run memtest also.

- Steve




_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
