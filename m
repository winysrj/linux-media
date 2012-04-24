Return-path: <linux-media-owner@vger.kernel.org>
Received: from goedel.dlitz.net ([64.5.53.201]:49936 "EHLO goedel.dlitz.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753579Ab2DXAqu (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 23 Apr 2012 20:46:50 -0400
Received: from rivest.dlitz.net (75-119-251-37.dsl.teksavvy.com [75.119.251.37])
	by goedel.dlitz.net (Postfix) with ESMTP id 465F97E08C
	for <linux-media@vger.kernel.org>; Mon, 23 Apr 2012 20:41:13 -0400 (EDT)
Date: Mon, 23 Apr 2012 20:41:12 -0400
From: "Dwayne C. Litzenberger" <dlitz@dlitz.net>
To: linux-media@vger.kernel.org
Subject: CX23102 audio; need datasheet
Message-ID: <20120424004112.GA27441@rivest.dlitz.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi there,

I'm working on adding support for another board to the cx231xx driver.  I'm 
doing this work on my own time as a volunteer, so I don't have an existing 
relationship with Conexant.

I bought an "AVerMedia DVD EZMaker 7" USB analog video digitizer, which is 
a board with basically just a CX23102 and some RCA cables connected to it. 
I have it mostly working, but the audio is silent (outputs all zeros).  
It's probably something really simple to fix, but it's a real pain without 
the datasheet.

This might help with other, similar boards, like the Hauppauge USB-Live2, 
which is similar and also doesn't work according to the linuxtv wiki[1].

Could someone help me obtain a copy of the CX23102 datasheet?  I'm hoping 
to get this done over the next 2 weeks on my vacation[2].

Cheers,
- Dwayne

-- 
Dwayne C. Litzenberger <dlitz@dlitz.net>
  OpenPGP: 19E1 1FE8 B3CF F273 ED17  4A24 928C EC13 39C2 5CF7

[1] http://www.linuxtv.org/wiki/index.php/Hauppauge_USB-Live-2
[2] Yes, I actually write device drivers to relax. :-)
