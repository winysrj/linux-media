Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from [194.250.18.140] (helo=tv-numeric.com)
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <thierry.lelegard@tv-numeric.com>) id 1LHj6k-00037g-QS
	for linux-dvb@linuxtv.org; Tue, 30 Dec 2008 19:14:23 +0100
From: "Thierry Lelegard" <thierry.lelegard@tv-numeric.com>
To: "'BOUWSMA Barry'" <freebeer.bouwsma@gmail.com>,
	<linux-dvb@linuxtv.org>
Date: Tue, 30 Dec 2008 19:13:48 +0100
Message-ID: <!~!UENERkVCMDkAAQACAAAAAAAAAAAAAAAAABgAAAAAAAAAJf2pBr8u1U+Z+cArRcz8PAKHAAAQAAAAaoT72bWgvUOpMz3wlvxejAEAAAAA@tv-numeric.com>
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.00.0812301811130.29535@ybpnyubfg.ybpnyqbznva>
Subject: [linux-dvb] RE :  Compile error,
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

De : BOUWSMA Barry 

> On Tue, 30 Dec 2008, Thierry Lelegard wrote:
> 
> > I have a compilation problem with the latest Linux DVB 
> repository (Dec 30 2008)
> > on kernel 2.6.27.9. The source of the error seems to be an 
> incorrect test in
> > compat.h.
> 
> > In <linux/pci.h>, the following has been added somewhere 
> between 2.6.27.7
> > and 2.6.27.9 (the two latest kernels I have on my Fedora 10 box):
> > 
> > #ifdef CONFIG_HAS_IOMEM
> > static inline void __iomem *pci_ioremap_bar(struct pci_dev 
> *pdev, int bar)
> 
> > But the test < KERNEL_VERSION(2, 6, 28) is not really correct since
> > the definition of pci_ioremap_bar appeared in the kernel in 
> the middle of
> > 2.6.27.* (in .8 or .9).
> 
> This seems to be more a result of the versioning which
> your distribution applies to the kernels, where certain
> features seem to have been cherry-picked from 2.6.28 and
> been added without bumping the version.
> 
> The above code is not present in the git kernel repo as
> of the time 2.6.27 went out the door, but was added a
> day before the 2.6.28-rc1 tag was applied during the two
> week merge window of limbo-land (22.Oct), I think.

OK, looking into the source RPM for the latest Fedora 10 update
kernel (kernel-2.6.27.9-159.fc10.src.rpm), it appears that
the definition of pci_ioremap_bar in pci.h was introduced by
linux-2.6.27.7-alsa-driver-fixups.patch

I assume that this is a Fedora-specific patch (or more generally Red Hat),
back-porting 2.6.28 stuff.

Too bad...

> > I do not see an obvious and general solution to this.
> 
> I wonder if you could modify compat.h to reverse the
> test in the diff --
> +#ifdef CONFIG_HAS_IOMEM
> or if this is set/not-set elsewhere...  Well, it's an
> idea.

Well, looking into the vanilla 2.6.17 kernel (linux-2.6.27.tar.bz2),
it seems that CONFIG_HAS_IOMEM is defined by default almost everywhere.
So, it seems to be a bit dangerous to play with that.

Really a pain since Fedora is a quite successful distro. The next "yum update"
will be painful to most most DVB users with devices which need the latest
update from linuxtv.org. Hopefully, they read this mailing list...

-Thierry


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
