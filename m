Return-path: <linux-media-owner@vger.kernel.org>
Received: from mta3.srv.hcvlny.cv.net ([167.206.4.198]:33881 "EHLO
	mta3.srv.hcvlny.cv.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751022AbZESVap (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 19 May 2009 17:30:45 -0400
Received: from steven-toths-macbook-pro.local
 (ool-18bfe1a4.dyn.optonline.net [24.191.225.164]) by mta3.srv.hcvlny.cv.net
 (Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
 with ESMTP id <0KJW005R7UF64750@mta3.srv.hcvlny.cv.net> for
 linux-media@vger.kernel.org; Tue, 19 May 2009 17:30:42 -0400 (EDT)
Date: Tue, 19 May 2009 17:30:42 -0400
From: Steven Toth <stoth@kernellabs.com>
Subject: Re: Recent Siano patches - testing required
In-reply-to: <492881.32224.qm@web110808.mail.gq1.yahoo.com>
To: Uri Shkolnik <urishk@yahoo.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Message-id: <4A132502.6070103@kernellabs.com>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7BIT
References: <492881.32224.qm@web110808.mail.gq1.yahoo.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

> However any test that will be performed, will benefit all (including Siano.... :-)
> 

Agreed. Yes, I happen to know Hauppauge very well.

I'm very happy to see that the driver is being improved but I'll be even happier 
to see actual testers report success before any of this stuff is merged. My 
concern is the vast amount of change coming through this list and expected to be 
merged blindly into the kernel.

If we have no testers then, at least for Hauppauge products, we'll find some. 
Let me know if I can help with this.

Until then nothing should be blindly merged that could regress existing product 
support.

Mauro?

-- 
Steven Toth - Kernel Labs
http://www.kernellabs.com
