Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from router.whitecitadel.com ([82.68.182.134]
	helo=mail.whitecitadel.com) by www.linuxtv.org with smtp (Exim 4.63)
	(envelope-from <paul@whitecitadel.com>) id 1LIghY-0007ZE-U4
	for linux-dvb@linuxtv.org; Fri, 02 Jan 2009 10:52:24 +0100
Message-ID: <6969.63.81.117.28.1230889937.squirrel@dagobah.whitecitadel.com>
Date: Fri, 2 Jan 2009 09:52:17 -0000 (UTC)
From: "Paul" <paul@whitecitadel.com>
To: linux-dvb@linuxtv.org
MIME-Version: 1.0
Subject: [linux-dvb]  RE : Compile error,
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

Thierry Lelegard thierry.lelegard at tv-numeric.com wrote:

> De : BOUWSMA Barry [mailto:freebeer.bouwsma at gmail.com]
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

<snip>

> > which is not yet in my latest 2.6.28 git kernel...
> >
> > These both seem to be present since -r1.1 through HEAD,
> > so I would guess you can special-case this check into
> > a 2.6.27 version test.
>
> Good idea. After some more checks, it seems reasonable. I consequently
> propose the following patch:
>
> ====[CUT HERE]====
< snip>				\
> ====[CUT HERE]====
>
> Quite dirty indeed, but isn't it the exact purpose of the compat.h file,
> being the dirty glue to compile latest kernel code inside older kernels ?
>
> I think this would help all Fedora users to have this little path
> committed
> into the linuxtv.org repository.

> Thanks Barry for your idea.
> -Thierry

I just ran into this issue trying to compile v4l-dvb from hg against the
latest fedora core 10 kernel 2.6.27.9-159.fc10.x86_64, I also tried the
core 10 original release kernel based on 2.6.25.5 with the same issue and
was wondering if this patch will be committed or had already been
committed at 14:00GMT (Jan 1st) yesterday when I pulled v4l-dvb?

Compile still fails for me with the original error posted by the original
poster, and I was curious if the patch will be committed, or if I would be
best to look at a vanilla kernel to work around the issue or avoid them
completely.

I have a new Hauppauge WinTV-NOVA-HD-S2 card and I believe that the latest
kernel from December 24th 2.6.28.40 contains a cx88 driver that supports
this card/Conexant CX24118A/Hauppauge WinTV-HVR4000(Lite) DVB-S/S2
[card=69,autodetected] natively, avoiding the need to compile the latest
dvb sources completly?

I would rather avoid manually editing compat.h if I can to keep things
simple for when I change things later and forget I did that.


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
