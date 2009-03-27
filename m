Return-path: <linux-media-owner@vger.kernel.org>
Received: from emita2.mittwald.de ([85.199.129.253]:56755 "EHLO
	emita2.mittwald.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756719AbZC0HyR (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 27 Mar 2009 03:54:17 -0400
Received: from mx51.mymxserver.com (unknown [172.16.51.2])
	by emita2.mittwald.de (Postfix) with ESMTP id F2BCF5FE672
	for <linux-media@vger.kernel.org>; Fri, 27 Mar 2009 08:34:04 +0100 (CET)
From: Holger Schurig <hs4233@mail.mn-solutions.de>
To: linux-arm-kernel@lists.arm.linux.org.uk
Subject: Re: [PATCH 1/5] CSI camera interface driver for MX1
Date: Fri, 27 Mar 2009 08:33:27 +0100
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
	Dave Strauss <Dave.Strauss@zoran.com>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Darius Augulis <augulis.darius@gmail.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Paulius Zaleckas <paulius.zaleckas@teltonika.lt>,
	Sascha Hauer <s.hauer@pengutronix.de>
References: <49C89F00.1020402@gmail.com> <49CBF437.7030603@zoran.com> <20090326220713.GC32555@n2100.arm.linux.org.uk>
In-Reply-To: <20090326220713.GC32555@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200903270833.27864.hs4233@mail.mn-solutions.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

> Sparse is another tool which can be used while building the
> kernel to increase the build time checking, but it can be
> quite noisy, so please only look at stuff which pops up for
> your specific area.

To get rid of some of the warnings, you can analyze only the 
parts of the source that you're working on. You just need sparse 
in your PATH and issue:

$ make SUBDIRS=arch/arm/mach-mx2 C=2


Unfortunately, the arm tree is a bit different to mainline linux, 
because

$ make SUBDIRS=arch/arm C=2
arch/arm/Makefile:31: *** Recursive variable `KBUILD_CFLAGS' 
references itself (eventually).  Stop.
make: *** [_module_arch/arm] Error 2

breaks, with and without sparse:
