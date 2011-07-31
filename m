Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailer-b4.gwdg.de ([134.76.10.28]:41748 "EHLO mailer-b4.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753061Ab1GaXkI (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 31 Jul 2011 19:40:08 -0400
Received: from gwdexc-fe2.exc.top.gwdg.de ([134.76.26.172] helo=vsmtpgwdexc.exc.top.gwdg.de)
	by mailer.gwdg.de with smtp (Exim 4.72)
	(envelope-from <henning.hollermann@stud.uni-goettingen.de>)
	id 1Qnf0l-0001Qb-Jj
	for linux-media@vger.kernel.org; Mon, 01 Aug 2011 01:01:31 +0200
Message-ID: <4E35DECA.2090700@stud.uni-goettingen.de>
Date: Mon, 01 Aug 2011 01:01:30 +0200
From: Henning Hollermann <henning.hollermann@stud.uni-goettingen.de>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: Missing package "Proc::ProcessTable" is in debian: libproc-processtable-perl
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I just tried to install the latest media-build-package via git. I got an
error because of a missing package, but the script could not provide a
hint about the name of the missing package. One quick search made clear,
that it was perl's ProcessTable package, which was missing. This is
named "libproc-processtable-perl" in debian, so you could add this as hint.

Cheers,
Henning

---------------------
What i did and uname:

~$ git clone git://linuxtv.org/media_build.git

~$ cd media_build

~/media_build$ ./build.sh
Checking if the needed tools are present
./check_needs.pl
ERROR: please install "Proc::ProcessTable", otherwise, build won't work.
I don't know distro . So, I can't provide you a hint with the package names.
Be welcome to contribute with a patch for media-build, by submitting a
distro-specific hint
to linux-media@vger.kernel.org
Build can't procceed as 1 dependency is missing at ./check_needs.pl line
132.
*** ERROR. Aborting ***

~/media_build:$ uname -a
Linux henning-laptop 2.6.38-2-amd64 #1 SMP Sun May 8 13:51:57 UTC 2011
x86_64 GNU/Linux
