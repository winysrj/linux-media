Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from ug-out-1314.google.com ([66.249.92.173])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <freebeer.bouwsma@gmail.com>) id 1LHiLH-0008Vv-3f
	for linux-dvb@linuxtv.org; Tue, 30 Dec 2008 18:25:20 +0100
Received: by ug-out-1314.google.com with SMTP id x30so1052636ugc.16
	for <linux-dvb@linuxtv.org>; Tue, 30 Dec 2008 09:25:15 -0800 (PST)
Date: Tue, 30 Dec 2008 18:25:09 +0100 (CET)
From: BOUWSMA Barry <freebeer.bouwsma@gmail.com>
To: Thierry Lelegard <thierry.lelegard@tv-numeric.com>
In-Reply-To: <!~!UENERkVCMDkAAQACAAAAAAAAAAAAAAAAABgAAAAAAAAAJf2pBr8u1U+Z+cArRcz8PMKAAAAQAAAAqZxjmUXrTUWT7+gKrvH8EwEAAAAA@tv-numeric.com>
Message-ID: <alpine.DEB.2.00.0812301811130.29535@ybpnyubfg.ybpnyqbznva>
References: <!~!UENERkVCMDkAAQACAAAAAAAAAAAAAAAAABgAAAAAAAAAJf2pBr8u1U+Z+cArRcz8PMKAAAAQAAAAqZxjmUXrTUWT7+gKrvH8EwEAAAAA@tv-numeric.com>
MIME-Version: 1.0
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Compile error,
 bug in compat.h with kernel 2.6.27.9 ?
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

On Tue, 30 Dec 2008, Thierry Lelegard wrote:

> I have a compilation problem with the latest Linux DVB repository (Dec 30 2008)
> on kernel 2.6.27.9. The source of the error seems to be an incorrect test in
> compat.h.

> In <linux/pci.h>, the following has been added somewhere between 2.6.27.7
> and 2.6.27.9 (the two latest kernels I have on my Fedora 10 box):
> 
> #ifdef CONFIG_HAS_IOMEM
> static inline void __iomem *pci_ioremap_bar(struct pci_dev *pdev, int bar)

> But the test < KERNEL_VERSION(2, 6, 28) is not really correct since
> the definition of pci_ioremap_bar appeared in the kernel in the middle of
> 2.6.27.* (in .8 or .9).

This seems to be more a result of the versioning which
your distribution applies to the kernels, where certain
features seem to have been cherry-picked from 2.6.28 and
been added without bumping the version.

The above code is not present in the git kernel repo as
of the time 2.6.27 went out the door, but was added a
day before the 2.6.28-rc1 tag was applied during the two
week merge window of limbo-land (22.Oct), I think.

Unfortunately, I don't know myself of a more fine-grained
date-based versioning that can be useful for snapshots
made during the merge window -- but such would only apply
to the git 2.6 repository, and not to vendor versions.


> I do not see an obvious and general solution to this.

I wonder if you could modify compat.h to reverse the
test in the diff --
+#ifdef CONFIG_HAS_IOMEM
or if this is set/not-set elsewhere...  Well, it's an
idea.


barry bouwsma

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
