Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from bombadil.infradead.org ([18.85.46.34])
	by www.linuxtv.org with esmtp (Exim 4.63) (envelope-from
	<SRS0+78812c0465fa576c722c+1958+infradead.org+mchehab@bombadil.srs.infradead.org>)
	id 1LIqvV-0003vj-7h
	for linux-dvb@linuxtv.org; Fri, 02 Jan 2009 21:47:25 +0100
Date: Fri, 2 Jan 2009 18:47:11 -0200
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: "Thierry Lelegard" <thierry.lelegard@tv-numeric.com>
Message-ID: <20090102184711.17e0bd1a@pedra.chehab.org>
In-Reply-To: <!~!UENERkVCMDkAAQACAAAAAAAAAAAAAAAAABgAAAAAAAAAJf2pBr8u1U+Z+cArRcz8PAKHAAAQAAAAKD9Q4NAVr0+H0MAg3L7x3gEAAAAA@tv-numeric.com>
References: <alpine.DEB.2.00.0812302027170.29535@ybpnyubfg.ybpnyqbznva>
	<!~!UENERkVCMDkAAQACAAAAAAAAAAAAAAAAABgAAAAAAAAAJf2pBr8u1U+Z+cArRcz8PAKHAAAQAAAAKD9Q4NAVr0+H0MAg3L7x3gEAAAAA@tv-numeric.com>
Mime-Version: 1.0
Cc: linux-dvb@linuxtv.org,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [linux-dvb] RE :  Compile error,
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

Hi Thierry,

On Wed, 31 Dec 2008 09:45:22 +0100
"Thierry Lelegard" <thierry.lelegard@tv-numeric.com> wrote:

> 
> De : BOUWSMA Barry [mailto:freebeer.bouwsma@gmail.com] 
> > 
> > On Tue, 30 Dec 2008, Thierry Lelegard wrote:
> > 
> > > OK, looking into the source RPM for the latest Fedora 10 update
> > > kernel (kernel-2.6.27.9-159.fc10.src.rpm), it appears that
> > > the definition of pci_ioremap_bar in pci.h was introduced by
> > > linux-2.6.27.7-alsa-driver-fixups.patch
> > > 
> > > I assume that this is a Fedora-specific patch (or more 
> > generally Red Hat),
> > > back-porting 2.6.28 stuff.
> > 
> > There may be hope for a dirty hack...

> Quite dirty indeed, but isn't it the exact purpose of the compat.h file,
> being the dirty glue to compile latest kernel code inside older kernels ?
> 
> I think this would help all Fedora users to have this little path committed
> into the linuxtv.org repository.

Too dirty for my eyes ;) 

Generally, the better way for working around of compilation issues that are
specific to some patched kernel is to add a rule at
v4l/scripts/make_config_compat.pl.

Instead of testing based on some kernel version, all you need to do is to write
a small regex match rule, against one of kernel .h file. If the rule matches,
you'll enable (or disable) a specific compatibility code at compat.h.

For example, some kernel versions need to use a different interface for
network. This started on kernels equal or newer than 2.6.18. So, for example,
all the standard 2.6.16 kernels use the old way, while the newer kernels use
the newer way. However, as network drivers are generally backport very often,
there are several 2.6.16 variants that use the new way as well. Just checking
for version doesn't work.

To fix this, we've added this check at make_config_compat.pl:

sub check_spin_lock()
{
        my $file = "$kdir/include/linux/netdevice.h";
        my $old_syntax = 1;

        open INNET, "<$file" or die "File not found: $file";
        while (<INNET>) {
                if (m/netif_tx_lock_bh/) {
                        $old_syntax = 0;
                        last;
                }
        }

        if ($old_syntax) {
                $out.= "\n#define OLD_XMIT_LOCK 1\n";
        }
        close INNET;
}

So, if we find netif_tx_lock_bh at netdevice.h, this means that the newer
network locking API should be used.

The compat handling, in this case, is done by this:

#ifdef OLD_XMIT_LOCK    /* Kernels equal or lower than 2.6.17 */
        spin_lock_bh(&dev->xmit_lock);
#else
#if LINUX_VERSION_CODE <= KERNEL_VERSION(2, 6, 26)
        netif_tx_lock_bh(dev);
#else
        netif_addr_lock_bh(dev);
#endif
#endif

If you do something like this for Fedora, it is likely that it will work much
better, without risking to break compat with other kernels.

Cheers,
Mauro

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
