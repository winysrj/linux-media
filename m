Return-path: <linux-media-owner@vger.kernel.org>
Received: from joe.mail.tiscali.it ([213.205.33.54]:41930 "EHLO
	joe.mail.tiscali.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754207AbZKLWY7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 12 Nov 2009 17:24:59 -0500
Received: from [192.168.0.60] (78.14.35.101) by joe.mail.tiscali.it (8.0.022)
        id 4AF29EE20036F2E6 for linux-media@vger.kernel.org; Thu, 12 Nov 2009 23:25:04 +0100
Message-ID: <4AFC8B2C.4010905@email.it>
Date: Thu, 12 Nov 2009 23:24:44 +0100
From: xwang1976@email.it
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: How can I create a patch?
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi to all,
I've a usb hybrid tuner which does not work with the main v4l driver.
I've found a way to use it modifying some lines in the em28xx-dvb.c and 
em28xx-cards.c files (thanks to Dainius Ridzevicius).
Can someone explain me how to create a diff between the main v4l
driver and the patched version so that I can share it in order to have 
it merged upstream?
Thank you,
Xwang
