Return-path: <linux-media-owner@vger.kernel.org>
Received: from mta1.srv.hcvlny.cv.net ([167.206.4.196]:62765 "EHLO
	mta1.srv.hcvlny.cv.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932166AbZHYW7A (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 25 Aug 2009 18:59:00 -0400
Received: from mbpwifi.kernelscience.com
 (ool-18bfe0d5.dyn.optonline.net [24.191.224.213]) by mta1.srv.hcvlny.cv.net
 (Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
 with ESMTP id <0KOY00IKLFUEFOL0@mta1.srv.hcvlny.cv.net> for
 linux-media@vger.kernel.org; Tue, 25 Aug 2009 18:59:02 -0400 (EDT)
Date: Tue, 25 Aug 2009 18:59:01 -0400
From: Steven Toth <stoth@kernellabs.com>
Subject: Re: Hauppauge 2250 - second tuner is only half working
In-reply-to: <283002305-1251239519-cardhu_decombobulator_blackberry.rim.net-845544064-@bxe1079.bisx.prod.on.blackberry>
To: seth@cyberseth.com
Cc: Steve Harrington <steve@Emel-Harrington.net>,
	linux-media@vger.kernel.org
Message-id: <4A946CB5.2010800@kernellabs.com>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7BIT
References: <283002305-1251239519-cardhu_decombobulator_blackberry.rim.net-845544064-@bxe1079.bisx.prod.on.blackberry>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

> After reading Steven Toth's reply I tried adding 1 and then 2 2-way
> splitters before the 2250 input. No joy.  I also tried feeding the cable
> directly into the 2250 with no splitters.  Again - no joy.
> Any other ideas?

Most likely this is dependent on what frequency the other tuner is tuned to, 
especially since Seth indicated it worked for a short time. And, again, I don't 
see the issue but two other people do.

RMA is probably not the answer.

When you next get a chance to test please use azap and keep track of what 
frequency the first tuner is currently tuned to even if tuner#1 is technically 
no longer streaming. I suspect varying the frequency on tuner#1 will vary your 
test results.

-- 
Steven Toth - Kernel Labs
http://www.kernellabs.com
