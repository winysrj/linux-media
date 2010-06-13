Return-path: <linux-media-owner@vger.kernel.org>
Received: from dd6222.kasserver.com ([85.13.131.10]:47210 "EHLO
	dd6222.kasserver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752361Ab0FMP2g (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 13 Jun 2010 11:28:36 -0400
Received: from [192.168.1.3] (p5B0D9C38.dip0.t-ipconnect.de [91.13.156.56])
	by dd6222.kasserver.com (Postfix) with ESMTP id 0BA3938A7B3
	for <linux-media@vger.kernel.org>; Sun, 13 Jun 2010 17:28:34 +0200 (CEST)
Message-ID: <4C14F922.1020802@coronamundi.de>
Date: Sun, 13 Jun 2010 17:28:34 +0200
From: Silamael <Silamael@coronamundi.de>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: Re: PROBLEM: 2.6.34-rc7 kernel panics "BUG: unable to handle kernel
 NULL pointer dereference at (null)" while channel scan runnin
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello!

In the meanwhile i tried several different kernel versions:
- 2.6.26 (as included in Debian Lenny): crash
- 2.6.32-3 (as in Debian Squeeze): crash
- 2.6.32-5 (updated version in Debian Squeeze): crash
- 2.6.34: crash

In every kernel version I've tested, the crashdump looks the same. Each
time there's an NULL pointer given to saa7146_buffer_next().

Would be nice if someone could give me some hints. I'm not sure whether
it's a broken driver or it's due to broken hardware or some other issues.

Thanks a lot!

Greetings,
Matthias
