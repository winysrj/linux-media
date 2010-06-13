Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.186]:61922 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754451Ab0FMSLH (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 13 Jun 2010 14:11:07 -0400
Date: Sun, 13 Jun 2010 11:10:59 -0700 (PDT)
From: Christian Kujau <lists@nerdbynature.de>
To: Stefan Lippers-Hollmann <s.L-H@gmx.de>
cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Kernel Testers List <kernel-testers@vger.kernel.org>,
	Maciej Rutecki <maciej.rutecki@gmail.com>,
	Michael Ellerman <michael@ellerman.id.au>,
	linux-media@vger.kernel.org, mchehab@infradead.org
Subject: Re: [Bug #15589] 2.6.34-rc1: Badness at fs/proc/generic.c:316
In-Reply-To: <201006131722.44062.s.L-H@gmx.de>
Message-ID: <alpine.DEB.2.01.1006131103590.3964@bogon.housecafe.de>
References: <g77CuMUl7QI.A.5wF.V5OFMB@chimera> <YPGdyfWGvNK.A.C8B.d9OFMB@chimera> <201006131722.44062.s.L-H@gmx.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, 13 Jun 2010 at 17:22, Stefan Lippers-Hollmann wrote:
> Still existing in 2.6.34 and 2.6.35 HEAD, however a patch fixing the issue 
> for b2c2-flexcop/ flexcop-pci has been posted last week:

So, now we have two patches for slightly different issues?

* http://lkml.indiana.edu/hypermail/linux/kernel/1006.0/00137.html
  ...fixes the flexcop-pci.c driver.

* http://patchwork.ozlabs.org/patch/52978/
  ...fixes "some bogus firmwares include properties with "/" in their
  name". I'm not sure if this would make the flexcop-pci.c badness go 
  away too. 

Anyway, both patches are not upstream yet, but Michael mentioned that 
Grant Likely or Ben might push it eventually.

Thanks,
Christian.
-- 
BOFH excuse #363:

Out of cards on drive D:
