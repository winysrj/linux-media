Return-path: <linux-media-owner@vger.kernel.org>
Received: from rcsinet10.oracle.com ([148.87.113.121]:23324 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753946Ab0G1ROh (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 28 Jul 2010 13:14:37 -0400
Date: Wed, 28 Jul 2010 10:13:58 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>,
	lirc-list@lists.sourceforge.net, Jarod Wilson <jarod@wilsonet.com>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
	Maxim Levitsky <maximlevitsky@gmail.com>,
	linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Re: linux-next: Tree for July 28 (lirc)
Message-Id: <20100728101358.e0dcd54d.randy.dunlap@oracle.com>
In-Reply-To: <20100728162855.4968e561.sfr@canb.auug.org.au>
References: <20100728162855.4968e561.sfr@canb.auug.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, 28 Jul 2010 16:28:55 +1000 Stephen Rothwell wrote:

> Hi all,
> 
> Changes since 20100727:


when CONFIG_MODULES is not enabled:

drivers/staging/lirc/lirc_parallel.c:243: error: implicit declaration of function 'module_refcount'
drivers/staging/lirc/lirc_it87.c:150: error: implicit declaration of function 'module_refcount'
drivers/built-in.o: In function `it87_probe':
lirc_it87.c:(.text+0x4079b0): undefined reference to `init_chrdev'
lirc_it87.c:(.text+0x4079cc): undefined reference to `drop_chrdev'
drivers/built-in.o: In function `lirc_it87_exit':
lirc_it87.c:(.exit.text+0x38a5): undefined reference to `drop_chrdev'

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
