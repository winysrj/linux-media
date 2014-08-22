Return-path: <linux-media-owner@vger.kernel.org>
Received: from ny01.nytud.hu ([193.6.194.1]:52427 "EHLO ny01.nytud.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750907AbaHVTJZ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 22 Aug 2014 15:09:25 -0400
Received: (from oravecz@localhost)
	by ny01.nytud.hu (8.11.6/8.11.6) id s7MJ3IT28956
	for linux-media@vger.kernel.org; Fri, 22 Aug 2014 21:03:18 +0200
Message-Id: <201408221903.s7MJ3IT28956@ny01.nytud.hu>
Subject: HVR 900 (USB ID 2040:6500) no analogue sound reloaded
To: linux-media@vger.kernel.org
Date: Fri, 22 Aug 2014 21:03:18 +0200 (CEST)
Reply-To: oravecz@nytud.mta.hu
From: Oravecz Csaba <oravecz@nytud.mta.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


I reported this issue earlier but for some reason it went pretty much
unnoticed. The essence is that with the newest em28xx drivers now present in
3.14 kernels (i'm on stock fedora 3.14.15-100.fc19.i686.PAE) I can't get
analogue sound from this card.

I see that the code snippet that produced this output in the pre 3.14 versions

em2882/3 #0: Config register raw data: 0x50
em2882/3 #0: AC97 vendor ID = 0xffffffff
em2882/3 #0: AC97 features = 0x6a90
em2882/3 #0: Empia 202 AC97 audio processor detected

is still there in em28xx-core.c, however, there is nothing like that in
current kernel logs so it seems that this part of the code is just skipped,
which I tend to think is not the intended behaviour. I have not gone any
further to investigate the issue, rather I've simply copied the 'old' em28xx
directory over the current one in the latest source and compiled the drivers
in this way and so got back the old em28xx version, which is working well in
the current kernel as well.

I don't consider this an optimal solution so 
I would very much appreciate any help in this issue.

best,
o.cs.


