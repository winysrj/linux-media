Return-path: <mchehab@pedra>
Received: from skyboo.net ([82.160.187.4]:38725 "EHLO skyboo.net"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753018Ab0KLJmt (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 12 Nov 2010 04:42:49 -0500
Received: from localhost ([::1])
	by skyboo.net with esmtpsa (TLS1.0:RSA_AES_256_CBC_SHA1:32)
	(Exim 4.72)
	(envelope-from <manio@skyboo.net>)
	id 1PGq9a-0000vG-Sw
	for linux-media@vger.kernel.org; Fri, 12 Nov 2010 10:42:47 +0100
Message-ID: <4CDD0C1A.7060707@skyboo.net>
Date: Fri, 12 Nov 2010 10:42:50 +0100
From: Mariusz Bialonczyk <manio@skyboo.net>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
References: <4CC7D4C5.6000104@skyboo.net> <f071a1229ec4db0a922ffbf91d4f2b5f.squirrel@www.hardeman.nu> <4CC85C0B.3010106@skyboo.net> <20101027170709.GA926@hardeman.nu> <4CC86734.1080003@skyboo.net> <20101027204837.GA2906@hardeman.nu> <4CC90A13.4070709@skyboo.net> <e4db9cd2c5a4ddc5345f16d441dc4351.squirrel@www.hardeman.nu> <4CC9A45A.1000004@skyboo.net> <4CD30DFB.7030304@skyboo.net> <20101104194412.GB9107@hardeman.nu>
In-Reply-To: <20101104194412.GB9107@hardeman.nu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Subject: Fixing tbs-nec table after converting to cx88 driver ir-core
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hello
I am using Prof 7301 PCI card.
After converting cx88 driver to ir-core (thank you very much for your
work, David) the table rc-tbs-nec (for bundled remote) has incorrect
values.
I was comparing the results and there is a regularity (constant offset):
If i add 0x80 (128 decimal) value to every code in rc-tbs-nec.c then
original remote gives correct EV_KEY events (just like before cx88
conversion) :)
Despite the fact that my IR receiver is now able to work with many
remotes it is still using standard remote which is in mentioned table,
so I think that we should correct the table to have it correct, what do
you think?

I also need to mention that the table is incomplete.
Please have a look at remote:
http://www.prof-tuners.com/eng/images/review/review_prof_7301/prof_7301_6.jpg

As you can see there are two buttons (10+ and 10-), which the table
doesn't take into account. Correct me if i'm wrong, but i believe it
means: 10 channels up, and 10 channels down.
So my proposition is to add new definitions for this buttons.
Maybe: KEY_10CHANNELSUP and KEY_10CHANNELSDOWN, what do you think?
Unfortunately I can't test the button meaning, because i don't have
windows at home computer with original software for the card.

I can provide full and fixed rc-tbs-nec table patch then.

regards,
-- 
Mariusz Bialonczyk
jabber/e-mail: manio@skyboo.net
http://manio.skyboo.net
