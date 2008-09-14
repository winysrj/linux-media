Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
From: hermann pitton <hermann-pitton@arcor.de>
To: Markus Rechberger <mrechberger@gmail.com>
In-Reply-To: <d9def9db0809141533v12698fa3od765d09a4299f03c@mail.gmail.com>
References: <564277.58085.qm@web46102.mail.sp1.yahoo.com>
	<48CD41BD.8040508@linuxtv.org>
	<d9def9db0809141251r1edece84r96c8becd5a2d4ee3@mail.gmail.com>
	<48CD88CF.7060601@linuxtv.org>
	<d9def9db0809141533v12698fa3od765d09a4299f03c@mail.gmail.com>
Date: Mon, 15 Sep 2008 00:41:24 +0200
Message-Id: <1221432084.4566.7.camel@pc10.localdom.local>
Mime-Version: 1.0
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Multiproto API/Driver Update
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


Am Montag, den 15.09.2008, 00:33 +0200 schrieb Markus Rechberger:
> On Sun, Sep 14, 2008 at 11:57 PM, Steven Toth <stoth@linuxtv.org> wrote:
> > Markus Rechberger wrote:
> >>
> >> On Sun, Sep 14, 2008 at 6:54 PM, Steven Toth <stoth@linuxtv.org> wrote:
> >>>
> >>> barry bouwsma wrote:
> >>>>
> >>>> --- On Sun, 9/14/08, Steven Toth <stoth@linuxtv.org> wrote:
> >>>>
> >>>>> is that the BSD folks can't port the GPL license into BSD because it's
> >>>>> not compatible.
> >>>>
> >>>> I don't want to see any religious war here (trimmed to dvb
> >>>> list), but...
> >>>>
> >>>> There is GPL code distributed as part of *BSD sources,
> >>>> as you can see by reading the licensing in, for example,
> >>>> $ ls /lost+found/CVSUP/BSD/FreeBSD.cvs/src/sys/gnu/dev/sound/pci/
> >>>> Attic       emu10k1-alsa.h,v  maestro3_reg.h,v  p17v-alsa.h,v
> >>>> csaimg.h,v  maestro3_dsp.h,v  p16v-alsa.h,v
> >>>
> >>> Interesting.
> >>>
> >>>>
> >>>>> I owe it to myself to spend somehime reading the BSD licencing. Maybe
> >>>>> the GPL is compatible with BSD.
> >>>>
> >>>> It all depends on the intended use -- whether for optional
> >>>> kernel components as above.  In the distributions, though,
> >>>> it's kept separated.
> >>>>
> >>>> It's also possible to dual-licence source, and I see a good
> >>>> number of such files in NetBSD under, as an example,
> >>>> /lost+found/CVSUP/BSD/NetBSD.cvs/src/sys/dev/ic/
> >>>
> >>> I'm be quite happy to grant a second license on my work the the BSD
> >>> guys, as the copyright owner I can do that. The legal stuff gets messy
> >>> quickly and I don't claim to understand all of it.
> >>>
> >>
> >> Great move Steven! Can we move the TDA10048 code over, maybe adding
> >> a note that it's dual licensed would be nice?
> >
> > In principle yes.
> >
> > I'd like to see an example of dual license just to make sure it has no nasty
> > side effects.
> >
> > Can you point me at one of your dual-license drivers so I can review the
> > wording?
> >
> 
> videodev2.h is also dual licensed.
> 

That was to what I tried to point to.

Cheers,
Hermann



_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
