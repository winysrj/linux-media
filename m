Return-path: <linux-media-owner@vger.kernel.org>
Received: from ist.d-labs.de ([213.239.218.44]:34550 "EHLO mx01.d-labs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753318Ab1HBPjo (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 2 Aug 2011 11:39:44 -0400
Date: Tue, 2 Aug 2011 17:39:42 +0200
From: Florian Mickler <florian@mickler.org>
To: mchehab@infradead.org
Cc: Dan Carpenter <error27@gmail.com>,
	Patrick Boettcher <patrick.boettcher@dibcom.fr>,
	pb@linuxtv.org, linux-media@vger.kernel.org
Subject: vp702x
Message-ID: <20110802173942.6f951c95@schatten.dmk.lab>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro! Hi Patrick!

I realized this morning, that I broke vp702x (if it was working before)
with my last patchseries. Sorry. :(

I'm gonna follow up on this mail with a patch to hopefully fix it, but
if nobody can test it, I'd say to rather revert my patchseries
for v3.1 . It will then still use on-stack dma buffers and will
produce a WARN() in the dmesg if it does so, but hopefully nothing bad
happens.

Patrick, do you still have the hardware to test this? I'm semi
confident that I did not make any silly mistakes. :| (it compiles)

Regards,
Flo

p.s.: or I could wipe up a dead simple patch that just kmalloc's a new
buffer everytime we need one...
