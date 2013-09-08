Return-path: <linux-media-owner@vger.kernel.org>
Received: from schorsch-tech.de ([88.198.48.118]:52918 "EHLO schorsch-tech.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752188Ab3IHLVz (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 8 Sep 2013 07:21:55 -0400
Received: from [127.0.0.1] (p57A33056.dip0.t-ipconnect.de [87.163.48.86])
	by schorsch-tech.de (Postfix) with ESMTPSA id 74E5F87606
	for <linux-media@vger.kernel.org>; Sun,  8 Sep 2013 13:13:08 +0200 (CEST)
Message-ID: <522C5BBC.9070406@schorsch-tech.de>
Date: Sun, 08 Sep 2013 13:13:00 +0200
From: Georg Gast <georg@schorsch-tech.de>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: cx23885: tvheadend-3.2 finds no hardware : first bad commit c1965eae65f0db2eee574f72aab4e8b34ecf8f9c
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

i use gentoo as my receiver platform. i have an Tevii S470 Card, which
works pretty fine. I used kernel 3.8.13, but there was an upgrade to
3.10.7 which broke it.

I bisected linux-stable.git to commit [2]

c1965eae65f0db2eee574f72aab4e8b34ecf8f9c is the first bad commit
commit c1965eae65f0db2eee574f72aab4e8b34ecf8f9c
Author: Konstantin Dimitrov <kosio.dimitrov@gmail.com>
Date:   Sun Dec 23 19:25:09 2012 -0300

I wrote already Konstantin Dimitrov <kosio.dimitrov@gmail.com> an email,
but he did not respond, so i thought it might be the right place to send
this to the ML.

On the 3.10.7 i digged a little and saw that the ts2020 module is
loaded, but tvheadened does not find hardware.

I reported that bug on gentoo [1], but it is also contained in
linux-stable.git. There you can find my bisect log [2] and all other
logs from me.

What can i do to resolve this bug? Is it a bug in tvheadend? But why
does it then work on 3.8.13 and 3.10.7 not? Is the separation from
ts2020 to a module faulty?

Bye
Georg

[1] https://bugs.gentoo.org/show_bug.cgi?id=483534
[2] https://483534.bugs.gentoo.org/attachment.cgi?id=357852
