Return-path: <mchehab@gaivota>
Received: from proofpoint-cluster.metrocast.net ([65.175.128.136]:9710 "EHLO
	proofpoint-cluster.metrocast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751472Ab1AAByK (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 31 Dec 2010 20:54:10 -0500
Subject: [REGRESSION: wm8775, ivtv] Please revert commit
 fcb9757333df37cf4a7feccef7ef6f5300643864
From: Andy Walls <awalls@md.metrocast.net>
To: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Lawrence Rust <lawrence@softsystem.co.uk>
Cc: Eric Sharkey <eric@lisaneric.org>, auric <auric@aanet.com.au>,
	David Gesswein <djg@pdp8online.com>,
	Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
	ivtv-users@ivtvdriver.org, ivtv-devel@ivtvdriver.org
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 31 Dec 2010 19:55:43 -0500
Message-ID: <1293843343.7510.23.camel@localhost>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

Mauro,

Please revert at least the wm8775.c portion of commit
fcb9757333df37cf4a7feccef7ef6f5300643864:

http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=fcb9757333df37cf4a7feccef7ef6f5300643864

It completely trashes baseband line-in audio for PVR-150 cards, and
likely does the same for any other ivtv card that has a WM8775 chip.

Reported-by: Eric Sharkey <eric@lisaneric.org>
http://ivtvdriver.org/pipermail/ivtv-users/2010-December/010104.html

Reported-by: Auric <auric@aanet.com.au>
http://ivtvdriver.org/pipermail/ivtv-users/2010-December/010102.html

Reported by: David Gesswein <djg@pdp8online.com>
http://ivtvdriver.org/pipermail/ivtv-devel/2010-December/006619.html

I have also verified with my own PVR-150 that this commit is the cause.

Regards,
Andy


