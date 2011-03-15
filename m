Return-path: <mchehab@pedra>
Received: from slow3-v.mail.gandi.net ([217.70.178.89]:41947 "EHLO
	slow3-v.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754974Ab1COIld (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 15 Mar 2011 04:41:33 -0400
Received: from relay2-v.mail.gandi.net (relay2-v.mail.gandi.net [217.70.178.76])
	by slow3-v.mail.gandi.net (Postfix) with ESMTP id 18A6286412
	for <linux-media@vger.kernel.org>; Tue, 15 Mar 2011 09:41:25 +0100 (CET)
Received: from mfilter1-d.gandi.net (mfilter1-d.gandi.net [217.70.178.41])
	by relay2-v.mail.gandi.net (Postfix) with ESMTP id 24F13135E0
	for <linux-media@vger.kernel.org>; Tue, 15 Mar 2011 09:41:02 +0100 (CET)
Received: from relay2-v.mail.gandi.net ([217.70.178.76])
	by mfilter1-d.gandi.net (mfilter1-d.gandi.net [217.70.178.41]) (amavisd-new, port 10024)
	with ESMTP id 5e3j4HRapTVo for <linux-media@vger.kernel.org>;
	Tue, 15 Mar 2011 09:41:00 +0100 (CET)
Received: from sira.localnet (sira.upc.es [147.83.37.68])
	(Authenticated sender: leo@alaxarxa.net)
	by relay2-v.mail.gandi.net (Postfix) with ESMTPSA id A2037135E4
	for <linux-media@vger.kernel.org>; Tue, 15 Mar 2011 09:41:00 +0100 (CET)
From: "Leopold Palomo-Avellaneda" <leo@alaxarxa.net>
To: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: wis go7007 driver
Date: Tue, 15 Mar 2011 09:40:57 +0100
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201103150940.57931.leo@alaxarxa.net>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi,

I have asked to some people and they have point me to this list to ask. I hope 
this is the right place. :-)

We have a card Addlink PCI-MPG24 that has 4 bt878 and 4 wis go7007. We have 
used the driver from [1] and [2]. 

Also, I have compiled the kernel source staged (2.6.32) and 
although it compiles without problem, the driver doesn't works. I'm testing it 
with two application spook (rtsp server)  and gorecord: both complains about 
Unable to set compression params.

This driver have been working with an stock debian kernel 2.6.26 without 
problems. Now, I would like to make it works with the current stock kernel 
(2.6.32) and up.

So, please, could you help me to try to see what's happening and try to solve 
this issue? 

Best regards,

Leo



[1] http://nikosapi.org/wiki/index.php/WIS_Go7007_Linux_driver
[2] http://home.comcast.net/~bender647/go7007/
