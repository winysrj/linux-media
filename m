Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.188]:54745 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936749AbZDIVx0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 9 Apr 2009 17:53:26 -0400
Message-ID: <49DE6E52.40506@e-tobi.net>
Date: Thu, 09 Apr 2009 23:53:22 +0200
From: Tobi <listaccount@e-tobi.net>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: Re: Userspace issue with DVB driver includes
References: <49DDA100.1030205@e-tobi.net>	<20090409074534.2cf32df0@pedra.chehab.org>	<49DE2301.5090406@e-tobi.net> <20090409143407.218d68dc@pedra.chehab.org>
In-Reply-To: <20090409143407.218d68dc@pedra.chehab.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Mauro Carvalho Chehab wrote:

> persists? If the problem will still persist, then the better procedure is to open a
> bugzilla at bugzilla.kernel.org, and post an email about this at LKML, keeping
> LMML c/c, for us to follow the discussions.

Just for the record: Arnd Bergmann already prepared a patch for this,
which unfortunately didn't made it into 2.6.29. The changesets you
suggested were from Arnd Bergmann's patchset, but I think at least these
changes would be required too:

http://git.kernel.org/?p=linux/kernel/git/jaswinder/linux-2.6-tip.git;a=commit;h=3a471cbc081b6bf2b58a48db13d734ecd3b0d437

(haven't tested it yet with just those three changesets)

See:

http://lkml.indiana.edu/hypermail/linux/kernel/0902.3/index.html#00955
http://git.kernel.org/?p=linux/kernel/git/jaswinder/linux-2.6-tip.git;a=shortlog;h=core/header-fixes

I've just applied the whole patchset from the core/header-fixes branch and
 it works fine.

(Thx to Anssi Hannula for pointing me into the right direction:
http://lkml.indiana.edu/hypermail/linux/kernel/0902.3/00411.html)

Tobias
