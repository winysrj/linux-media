Return-path: <linux-media-owner@vger.kernel.org>
Received: from mta5.srv.hcvlny.cv.net ([167.206.4.200]:47663 "EHLO
	mta5.srv.hcvlny.cv.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750820AbZESTPz (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 19 May 2009 15:15:55 -0400
Received: from steven-toths-macbook-pro.local
 (ool-18bfe1a4.dyn.optonline.net [24.191.225.164]) by mta5.srv.hcvlny.cv.net
 (Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
 with ESMTP id <0KJW00K8SO6AM4A0@mta5.srv.hcvlny.cv.net> for
 linux-media@vger.kernel.org; Tue, 19 May 2009 15:15:47 -0400 (EDT)
Date: Tue, 19 May 2009 15:15:46 -0400
From: Steven Toth <stoth@kernellabs.com>
Subject: Recent Siano patches - testing required
To: urishk@yahoo.com, Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Message-id: <4A130562.105@kernellabs.com>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Mauro please review.

Uri,

Firstly I'd like to thank you and Siano for patching and helping to maintain the 
driver. :)

Second, this is a heck of a lot of change for the list to review! It's 
impossible to digest the level of rework and potential regressions.

I'd suggest you either host your own mercurial server and have testers pull your 
trees, helping to regression test your changes or ... someone gives you access 
to create trees at LinuxTV.org, then you can solicit testers feedback on the 
mailing list.

Either way, it's unusual for this amount of change to be merged without having 
some positive feedback from the Linux community of testers. If you have 
confirmation that all of the current devices are still working correct, without 
regression, then please indicate this in your patches / email.

If not, the patches should be hosted somewhere for test and review.

-- 
Steven Toth - Kernel Labs
http://www.kernellabs.com
