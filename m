Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.177]:50107 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756811AbZDIR42 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 9 Apr 2009 13:56:28 -0400
Message-ID: <49DE36C8.3030303@e-tobi.net>
Date: Thu, 09 Apr 2009 19:56:24 +0200
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

> If you're compiling with a new kernel, you'll be expected to have installed the
> new kernel headers at /usr/include/linux.

Of course I've installed the kernel headers. After all these headers are
causing the trouble.

The change from asm/types.h to linux/types.h causes some POSIX types
beeing declared, which are also defined in glibc's stdint.h.


> persists? If the problem will still persist, then the better procedure is to open a
> bugzilla at bugzilla.kernel.org, and post an email about this at LKML, keeping

As soon as I've decided whether it is a glibc or kernel issue, I'll do so.

Thanks for your help!

Tobias
