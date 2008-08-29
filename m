Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail.gmx.net ([213.165.64.20])
	by www.linuxtv.org with smtp (Exim 4.63)
	(envelope-from <HWerner4@gmx.de>) id 1KZ75F-0004y9-8M
	for linux-dvb@linuxtv.org; Fri, 29 Aug 2008 18:44:26 +0200
Date: Fri, 29 Aug 2008 18:43:52 +0200
From: "Hans Werner" <HWerner4@gmx.de>
In-Reply-To: <37219a840808290852k4cafb891tbf35162d3add6d60@mail.gmail.com>
Message-ID: <20080829164352.74800@gmx.net>
MIME-Version: 1.0
References: <20080821173909.114260@gmx.net> <20080823200531.246370@gmx.net>
	<48B78AE6.1060205@gmx.net> <48B7A60C.4050600@kipdola.com>
	<48B802D8.7010806@linuxtv.org> <20080829154342.74800@gmx.net>
	<37219a840808290852k4cafb891tbf35162d3add6d60@mail.gmail.com>
To: "Michael Krufky" <mkrufky@linuxtv.org>, linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] [PATCH] Future of DVB-S2
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>


> > Now, to show how simple I think all this could be, here is a PATCH
> implementing what
> > I think is the *minimal* API required to support DVB-S2.
> >
> > Notes:
> >
> > * same API structure, I just added some new enums and variables, nothing
> removed
> > * no changes required to any existing drivers (v4l-dvb still compiles)
> > * no changes required to existing applications (just need to be
> recompiled)
> > * no drivers, but I think the HVR4000 MFE patch could be easily adapted
> >
> > I added the fe_caps2 enum because we're running out of bits in the
> capabilities bitfield.
> > More elegant would be to have separate bitfields for FEC capabilities
> and modulation
> > capabilities but that would require (easy) changes to (a lot of) drivers
> and applications.
> >
> > Why should we not merge something simple like this immediately? This
> could have been done
> > years ago. If it takes several rounds of API upgrades to reach all the
> feature people want then
> > so be it, but a long journey begins with one step.
> =

> This will break binary compatibility with existing apps.  You're right
> -- those apps will work with a recompile, but I believe that as a
> whole, the linux-dvb kernel and userspace developers alike are looking
> to avoid breaking binary compatibility.

Michael,
thank you for your comment.

I understand, but I think binary compatibility *should* be broken in this c=
ase. It makes
everything else simpler.

I know that not breaking binary compatibility *can* be done (as in the HVR4=
000 SFE and
MFE patches) but at what cost?  The resulting code is very odd. Look at mul=
tiproto which =

bizarrely implements both the 3.2 and the 3.3 API and a compatibility layer=
 as well, at huge cost
in terms of development time and complexity of understanding. The wrappers =
used in the MFE
patches are a neat and simple trick, but not something you would release in=
 the kernel.

If you take the position the binary interface cannot *ever* change then you=
 are severely
restricting the changes that can be made and you doom yourself to an API th=
at is no longer
suited to the job. And the complexity kills. As we have seen, it makes the =
whole process grind to a
halt. =


Recompilation is not a big deal. All distros recompile every application fo=
r each release (in fact much more frequently -- updates too), so most users=
 will never even notice.  It is much better to make the right, elegant chan=
ges to the API and require a recompilation. It's better for the application=
 developers because they get a sane evolution of the API and can more easil=
y add new features. Anyone who
really cannot recompile existing userspace binaries will also have plenty o=
f other restrictions and
should not be trying to drop a new kernel into a fixed userspace.

I would be interested to hear your opinion on how we can move forward rapid=
ly.

Regards,
Hans

-- =

Release early, release often. Really, you should.

GMX Kostenlose Spiele: Einfach online spielen und Spa=DF haben mit Pastry P=
assion!
http://games.entertainment.gmx.net/de/entertainment/games/free/puzzle/61691=
96

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
