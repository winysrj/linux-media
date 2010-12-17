Return-path: <mchehab@gaivota>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:49177 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750942Ab0LQGGs (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 17 Dec 2010 01:06:48 -0500
Received: by wwa36 with SMTP id 36so333723wwa.1
        for <linux-media@vger.kernel.org>; Thu, 16 Dec 2010 22:06:47 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <AANLkTinUQiUnET8K8xR_m8EVc9h6-vev1cKRe=F+yh6S@mail.gmail.com>
References: <AANLkTi=_Wc-A2f2emjXrP1bwWF4T+esJfLkdeNXqDr74@mail.gmail.com>
	<AANLkTinUQiUnET8K8xR_m8EVc9h6-vev1cKRe=F+yh6S@mail.gmail.com>
Date: Fri, 17 Dec 2010 16:06:47 +1000
Message-ID: <AANLkTinu6+3Ep=58ephY9TOCBV+4Z9RSO9F0NP6ooiKg@mail.gmail.com>
Subject: Re: [mythtv-users] Leadtek DTV2000DS - no channel lock
From: David Whyte <david.whyte@gmail.com>
To: Discussion about MythTV <mythtv-users@mythtv.org>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

>
> I've had another bash at this, and I think that the 4.95.0 firmware
> makes it work. Or at least, one of the 4 tuners is working.
>

For my K-World tuners, which use the same firmware (from the top of my
head) I reverted to 4.65 (the default for Ubuntu 9.10) and found I had
better success.  4.95 and 5.10 would take forever to lock for me.
