Return-path: <mchehab@pedra>
Received: from lo.gmane.org ([80.91.229.12]:45011 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752143Ab1FJIpR (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 10 Jun 2011 04:45:17 -0400
Received: from list by lo.gmane.org with local (Exim 4.69)
	(envelope-from <gldv-linux-media@m.gmane.org>)
	id 1QUxL9-0003a0-MV
	for linux-media@vger.kernel.org; Fri, 10 Jun 2011 10:45:15 +0200
Received: from p4FD49369.dip0.t-ipconnect.de ([79.212.147.105])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Fri, 10 Jun 2011 10:45:15 +0200
Received: from jannis_achstetter by p4FD49369.dip0.t-ipconnect.de with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Fri, 10 Jun 2011 10:45:15 +0200
To: linux-media@vger.kernel.org
From: Jannis Achstetter <jannis_achstetter@web.de>
Subject: Re: TechniSat SkyStar S2 / CX24120-13Z again
Date: Fri, 10 Jun 2011 08:45:03 +0000 (UTC)
Message-ID: <loom.20110610T104225-406@post.gmane.org>
References: <4DF124C3.6020309@web.de> <loom.20110609T223743-685@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Jannis Achstetter <jannis_achstetter <at> web.de> wrote:

> [...] I can't
> test functionality right now since I'm not at home where the device is but I
> will test first thing when I get home.

The card works absolutely fine. So it's not more than applying a single patch
against 2.6.39.1 to get the card supported (+ a firmware file from userspace). I
modified the patch a little to get rid of two compilation warnings and will
modify it further to comply with kernel coding-style rules and post it to this
list then.

Jannis

