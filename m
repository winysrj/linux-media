Return-path: <mchehab@pedra>
Received: from mailout-de.gmx.net ([213.165.64.22]:51292 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S932843Ab1FBJqQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 2 Jun 2011 05:46:16 -0400
Message-ID: <4DE75BE7.4050403@gmx.net>
Date: Thu, 02 Jun 2011 11:46:15 +0200
From: Lutz Sammer <johns98@gmx.net>
MIME-Version: 1.0
To: hselasky@c2i.net
CC: linux-media@vger.kernel.org
Subject: RE: [PATCH v3 - resend] Fix the derot zig-zag to work with TT-USB2.0
 TechnoTrend.
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hello Hans Petter,

I haven't tested your patch yet, but looking at the source I see some
problems.

What does your patch fix and how?

If you have problem locking channels, try my locking patch:
https://patchwork.kernel.org/patch/753382/

On each step (timing, carrier, data) you reset the derot:
     stb0899_set_derot(state, 0);
Why?

Afaik you destroy already locked frequencies, which slows
down the locking.

Than you do 8 loops:
    for (index = 0; index < 8; index++) {
Why?

All checks already contains some delays, if the delays are too
short, you should fix this delays.

Johns
