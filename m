Return-path: <linux-media-owner@vger.kernel.org>
Received: from sysphere.org ([97.107.129.246]:56395 "EHLO mail.sysphere.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754602Ab2AHW5K (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 8 Jan 2012 17:57:10 -0500
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.sysphere.org (Postfix) with ESMTP id 322DE8B9E
	for <linux-media@vger.kernel.org>; Sun,  8 Jan 2012 23:57:10 +0100 (CET)
Date: Sun, 8 Jan 2012 23:57:10 +0100
From: "Adrian C." <anrxc@sysphere.org>
To: linux-media@vger.kernel.org
Subject: Support for IR on terratec/skystarhd2 mantis cards
Message-ID: <alpine.LNX.2.00.1201082249010.28018@flfcurer.bet>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=US-ASCII
Content-ID: <alpine.LNX.2.00.1201082249021.28018@flfcurer.bet>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello, in May a patch for remote control support of some mantis cards 
was discussed here on the list. 

I've been using the latest revision of the patch from Christoph Pinkl up 
to linux 3.1.7, with very minor modifications on my Technisat SkyStar 
HD2. It's been working without a hitch on this card since May. I've been 
wondering is there's any chance this can be commited to mantis driver 
and enter the mainline?

My interest is to stop building and maintaining my own kernel packages. 
Patch broke linux 3.2 build and needed more minor changes, I'll come to 
a point where I can't solve all the problems.


This is my fifth attempt to get past the SPAM filter, I can't include 
any links or patches this time, as the postmaster didn't help. If 
revision of patch for linux 3.2 is needed please advise how to pass it 
on to you.
