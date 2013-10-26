Return-path: <linux-media-owner@vger.kernel.org>
Received: from kripserver.net ([91.143.80.239]:45840 "EHLO mail.kripserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753489Ab3JZVEW (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 26 Oct 2013 17:04:22 -0400
Received: from localhost (localhost [127.0.0.1])
	by mail.kripserver.net (Postfix) with ESMTP id 09B473AE08F
	for <linux-media@vger.kernel.org>; Sat, 26 Oct 2013 21:04:21 +0000 (UTC)
Received: from mail.kripserver.net ([91.143.80.239])
	by localhost (mail.kripserver.net [127.0.0.1]) (amavisd-new, port 10024)
	with LMTP id Ame4yZVsqn3m for <linux-media@vger.kernel.org>;
	Sat, 26 Oct 2013 21:04:20 +0000 (UTC)
Received: from [192.168.1.98] (frnk-590d5c98.pool.mediaWays.net [89.13.92.152])
	(using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mail.kripserver.net (Postfix) with ESMTPSA id E022C3AE08E
	for <linux-media@vger.kernel.org>; Sat, 26 Oct 2013 21:04:19 +0000 (UTC)
Message-ID: <526C2E53.8080204@kripserver.net>
Date: Sat, 26 Oct 2013 23:04:19 +0200
From: Jannis <jannis-lists@kripserver.net>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: Re: NAS for recording DVB-S2
References: <52663659.3040205@gmx.net> <526A1864.7020800@kripserver.net> <CAJbz7-1J2=Fz7sB0Uu2iCEDG-MNiJWJPQgbFN7XQHZsCFohK1A@mail.gmail.com> <526A4090.6020008@gmx.net>
In-Reply-To: <526A4090.6020008@gmx.net>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am 25.10.2013 11:57, schrieb JPT:
> I think I will trust both your statements that it's likeley to work, so
> it's not necessary to test. Thanks. :)

Since I'm a curious person, I tried it myself today. The SykStar USB HD
works on my hardkernel ODROID-U2 (Cortex-A9 Quad) after I added the
driver to the kernel. Furthermore, the parameter "coherent_pool=6M"
needed to be added to the kernel's command line since there were kernel
errors otherwise. Since then, everything works as expected. Channel
scan, SD and HD programs as well as complete MPEG2 transport streams
(well, the TS is filtered in software anyways). All tested using
gstreamer-1.2 and dvbsrc.

Best regards,
	Jannis

