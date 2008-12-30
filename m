Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from [194.250.18.140] (helo=tv-numeric.com)
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <thierry.lelegard@tv-numeric.com>) id 1LHgz3-0003bS-G0
	for linux-dvb@linuxtv.org; Tue, 30 Dec 2008 16:58:17 +0100
From: "Thierry Lelegard" <thierry.lelegard@tv-numeric.com>
To: <linux-dvb@linuxtv.org>
Date: Tue, 30 Dec 2008 16:57:42 +0100
Message-ID: <!~!UENERkVCMDkAAQACAAAAAAAAAAAAAAAAABgAAAAAAAAAJf2pBr8u1U+Z+cArRcz8PMKAAAAQAAAAqZxjmUXrTUWT7+gKrvH8EwEAAAAA@tv-numeric.com>
MIME-Version: 1.0
Subject: [linux-dvb] Compile error, bug in compat.h with kernel 2.6.27.9 ?
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

Hello,

I have a compilation problem with the latest Linux DVB repository (Dec 30 2008)
on kernel 2.6.27.9. The source of the error seems to be an incorrect test in
compat.h.

------------------------------------------------------------

I get the following compile error:

  CC [M]  /home/tlelegard/v4l-dvb/v4l/bttv-input.o
In file included from /home/tlelegard/v4l-dvb/v4l/bttvp.h:37,
                 from /home/tlelegard/v4l-dvb/v4l/bttv-input.c:29:
include/linux/pci.h:1126: error: expected declaration specifiers or '...' before '(' token
include/linux/pci.h:1126: error: expected declaration specifiers or '...' before '(' token
include/linux/pci.h:1126: error: static declaration of 'ioremap_nocache' follows non-static declaration
include/asm/io_32.h:111: error: previous declaration of 'ioremap_nocache' was here
include/linux/pci.h: In function 'ioremap_nocache':
include/linux/pci.h:1127: error: number of arguments doesn't match prototype
include/asm/io_32.h:111: error: prototype declaration
include/linux/pci.h:1131: error: 'pdev' undeclared (first use in this function)
include/linux/pci.h:1131: error: (Each undeclared identifier is reported only once
include/linux/pci.h:1131: error: for each function it appears in.)
include/linux/pci.h:1131: error: 'bar' undeclared (first use in this function)

------------------------------------------------------------

In "compat.h" from Linux DVB, there is:

#if LINUX_VERSION_CODE < KERNEL_VERSION(2, 6, 28)
#define snd_BUG_ON(cond)	WARN((cond), "BUG? (%s)\n", __stringify(cond))

#define pci_ioremap_bar(pci, a)				\
	 ioremap_nocache(pci_resource_start(pci, a),	\
			 pci_resource_len(pci, a))
#endif

------------------------------------------------------------

In <linux/pci.h>, the following has been added somewhere between 2.6.27.7
and 2.6.27.9 (the two latest kernels I have on my Fedora 10 box):

#ifdef CONFIG_HAS_IOMEM
static inline void __iomem *pci_ioremap_bar(struct pci_dev *pdev, int bar)
{
	/*
	 * Make sure the BAR is actually a memory resource, not an IO resource
	 */
	if (!(pci_resource_flags(pdev, bar) & IORESOURCE_MEM)) {
		WARN_ON(1);
		return NULL;
	}
	return ioremap_nocache(pci_resource_start(pdev, bar),
				     pci_resource_len(pdev, bar));
}
#endif

------------------------------------------------------------

This means that pci_ioremap_bar is defined twice (a macro in v4l's compat.h).

In compat.h, there is an obvious attempt to define an equivalent of
pci_ioremap_bar when it is not yet defined in the kernel.

But the test < KERNEL_VERSION(2, 6, 28) is not really correct since
the definition of pci_ioremap_bar appeared in the kernel in the middle of
2.6.27.* (in .8 or .9).

For my own usage on kernel 2.6.27.9, I simply modified compat.h with
< KERNEL_VERSION(2, 6, 27) but this is obviously and definitely not the
right thing to do in the repository.

I do not see an obvious and general solution to this.

-Thierry 


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
