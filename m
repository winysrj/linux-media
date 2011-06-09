Return-path: <mchehab@pedra>
Received: from lo.gmane.org ([80.91.229.12]:60861 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754611Ab1FIUzK (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 9 Jun 2011 16:55:10 -0400
Received: from list by lo.gmane.org with local (Exim 4.69)
	(envelope-from <gldv-linux-media@m.gmane.org>)
	id 1QUmFu-00048S-SE
	for linux-media@vger.kernel.org; Thu, 09 Jun 2011 22:55:06 +0200
Received: from frnk-4d009362.pool.mediaWays.net ([77.0.147.98])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Thu, 09 Jun 2011 22:55:06 +0200
Received: from jannis_achstetter by frnk-4d009362.pool.mediaWays.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Thu, 09 Jun 2011 22:55:06 +0200
To: linux-media@vger.kernel.org
From: Jannis Achstetter <jannis_achstetter@web.de>
Subject: Re: TechniSat SkyStar S2 / CX24120-13Z again
Date: Thu, 9 Jun 2011 20:47:38 +0000 (UTC)
Message-ID: <loom.20110609T223743-685@post.gmane.org>
References: <4DF124C3.6020309@web.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Jannis Achstetter <jannis_achstetter <at> web.de> wrote:

> [...]
> There is the mentioned binary driver. And s.o. made a patch against DVB
> s2-liplianin (http://mercurial.intuxication.org/hg/s2-liplianin/) that
> adds support for the CX24120. It's not exactly a patch but a "run"-file
> with script-header and a tar-archive that extracts the patch and applies
> it directly.

What I forgot: The run-file can be found here:
 http://linuxdvb.org.ru/wbb/index.php?page=Thread&postID=16141#post16141

Right now I tried for the first time to apply this patch directly to the
mainline linux 2.6.39.1. With some offsets, the patch applied fine and I had the
frontend in menuconfig. Compiling throws two warnings but finishes okay. I can't
test functionality right now since I'm not at home where the device is but I
will test first thing when I get home.

Jannis

