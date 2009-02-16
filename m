Return-path: <linux-media-owner@vger.kernel.org>
Received: from webmail.icp-qv1-irony-out1.iinet.net.au ([203.59.1.146]:12334
	"EHLO webmail.icp-qv1-irony-out1.iinet.net.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754335AbZBPLvG convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 16 Feb 2009 06:51:06 -0500
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
From: "sonofzev@iinet.net.au" <sonofzev@iinet.net.au>
To: linux-media@vger.kernel.org,
	"'sonofzev @ iinet . net . au'" <sonofzev@iinet.net.au>
Subject: Re: Fwd: [linux-dvb] dvico dual express continuuing issues.
Reply-To: sonofzev@iinet.net.au
Date: Mon, 16 Feb 2009 20:51:03 +0900
Message-Id: <50636.1234785063@iinet.net.au>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


>
>Hi All 
>
>In december I posted a message regarding some issues with the dvico driver.
>
>http://www.linuxtv.org/pipermail/linux-dvb/2008-December/031137.html
>
>The kernel is reporting incorrect callback of the firmware. Also, if the tuner
>isn't being used for a few hours, I then get errors from mythtv about it not
>being able to contact the backend and only rebooting the system will fix the
>problem (restarting mythbackend and frontend does not help).
>
>I eventually reported this as fixed to do with bios settings but I was wrong.
>
>I have done alot more testing and have found that it seems to be only after
>mythtv has accessed the device where this problem beings begins... 
>
>I will try the latest hg version and see what happens. I will also try another tv
>application and see if that makes a difference (but I really would like to
>continue using mythtv as I have 2 other frontends). 
>
>More information.. (and questions). 
>I know I definitely didn't have this problem with earlier versions of the driver
>(roughly pre September.. Chris Pascoe's original version actually seemed more
>stable although didn't report correct signal strength) 
>The cpu is a an opteron 170 
>2GB of OCZ DDR500 RAM (clocked at standard 400 of course, not overclocking this
>thing actually unless watching HD it is usually sitting at 1000MHZ)
>Nvidia 7600 GS video card (as I read horrible things about my onboard ATI
>chipset) using nvidia drivers not using xvmc however. 
>I have eliminated the motherboard as since I originally reported the issue I have
>changed mobo (from nvidia nforce4 chipset to ati chipset.... primarily to get a
>micro atx mobo for my HTPC case). 
>Fairly standard kernel with pre-emption (should I be using an rt patched kernel??)
>Are there any other kernel options I should remove or add??? 
>I am using the most recent unstable Gentoo release of mythtv (0.21_p19046) but
>saw the same problem on the most recent stable release too. 
>Are there any compile time options (or USE flags) I need to set or unset??
>The system also houses my third tuner/second card, a dvico fusion lite (older pci
>version rock solid stable).. Are there any modules.conf settings I need to look
>out for (although it worked before ...).... 
>
>As I said, I will try out the latest hg version tonight.. but any advice would be
>appreciated greatly!!!
>
>cheers
>
>Allan 
>

Same result with the hg version updated tonight. 

I haven't had a chance to use another tv app yet as we are currently watching TV. 

I will send a further update later. 
