Return-path: <linux-media-owner@vger.kernel.org>
Received: from jordan.toaster.net ([69.36.241.228]:1404 "EHLO
	jordan.toaster.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750706AbZHEUas (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 5 Aug 2009 16:30:48 -0400
Received: from [127.0.0.1] (slazar@localhost.toaster.net [127.0.0.1])
	by jordan.toaster.net (8.13.3/8.12.11) with ESMTP id n75K8S4e026540
	for <linux-media@vger.kernel.org>; Wed, 5 Aug 2009 13:08:29 -0700 (PDT)
	(envelope-from knife@toaster.net)
Message-ID: <4A79E6A3.7050508@toaster.net>
Date: Wed, 05 Aug 2009 13:08:03 -0700
From: Sean <knife@toaster.net>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: capture-example.c crash on close_device()
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

I have compiled kernel 2.6.30 from kernel.org, and I have also compiled 
capture-example.c from the mercurial depository. These work on laptop 
hardware, but on my DM&P e-box 2300SX (with vortex86 cpu), 
capture-example.c crashes the system. Complete lockup, no keyboard, etc. 
I turned on all debuging in gspca_main, i.e. options gspca_main 
debug=0x1FF. I also put print statements in capture-example.c in main() 
before each function call. Here is the output below. Has anyone had this 
problem?

-------
# capture-example -r
<snip>
gspca: packet [28] o:28644 l:126
gspca: add t:2 l:126
gspca: packet [31] o:31713 l:630
pac207: SOF found, bytes to analyze: 630. Frame starts at byte #19
gspca: add t:3 l:14
gspca: frame complete len:26496 q:1 i:0 o:1
gspca: add t:1 l:0
gspca: add t:2 l:600
gspca: poll
gspca: read (202752)
gspca: dqbuf
gspca: frame wait q:1 i:0 o:0
gspca: autogain: lum: 252, desired: 102, steps: 5
gspca: dqbuf 1
gspca: qbuf 1
gspca: qbuf q:0 i:0 o:0
.stop_capturing()
uninit_device()
close_device()
gspca: capture-example close
gspca: kill transfer
gspca: isoc irq
gspca: isoc irq
gspca: isoc irq
