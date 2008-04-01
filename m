Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from el-out-1112.google.com ([209.85.162.180])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <anothersname@googlemail.com>) id 1JgV5s-0002X3-Ev
	for linux-dvb@linuxtv.org; Tue, 01 Apr 2008 03:15:23 +0200
Received: by el-out-1112.google.com with SMTP id o28so664897ele.2
	for <linux-dvb@linuxtv.org>; Mon, 31 Mar 2008 18:15:15 -0700 (PDT)
Message-ID: <a413d4880803311815x2009eddex2351adc11525db3d@mail.gmail.com>
Date: Tue, 1 Apr 2008 02:15:14 +0100
From: "Another Sillyname" <anothersname@googlemail.com>
To: linux-dvb@linuxtv.org
In-Reply-To: <d9def9db0803311627i6df82e04wc7a6bf8898440637@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
References: <a413d4880803301640u20b77b9cya5a812efec8ee25c@mail.gmail.com>
	<c8b4dbe10803311302n6edc8d0dtb1f816099e020946@mail.gmail.com>
	<d9def9db0803311559p3b4fe2a7gfb20477a2ac47144@mail.gmail.com>
	<d9def9db0803311627i6df82e04wc7a6bf8898440637@mail.gmail.com>
Subject: Re: [linux-dvb] Lifeview DVB-T from v4l-dvb and Pinnacle Hybrid USb
	from v4l-dvb-kernel......help
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

Markus thanks for the response.

Am I correct in saying that your work will be on the v4l-dvb-kernel
branch and focused purely on the em28xx devices? Then you'll then be
migrating this work to v4l-dvb?

Or are you looking to 'clean up' the code that's currently in
v4l-dvb-kernel? without migrating it to v4l-dvb?

Obviously as I'm looking to get one device working from each branch
I'm a bit hamstrung at the moment.

Regards  and Thanks

On 01/04/2008, Markus Rechberger <mrechberger@gmail.com> wrote:
> On 4/1/08, Markus Rechberger <mrechberger@gmail.com> wrote:
>  > On 3/31/08, Aidan Thornton <makosoft@googlemail.com> wrote:
>  > > On Mon, Mar 31, 2008 at 12:40 AM, Another Sillyname
>  > > <anothersname@googlemail.com> wrote:
>  > > > I have a machine that has an internal card that's a Lifeview DVB and
>  > > > works fine using the v4l-dvb mercurial sources.
>  > > >
>  > > > I want to add a Pinnacle USB Hybrid stick (em28xx) that does not work
>  > > > using the v4l-dvb sources but does work using the v4l-dvb-kernel
>  > > > version.
>  > > >
>  > > > 1. Will the number of em28xx cards supported by v4l-dvb be increased
>  > > > shortly? (My card id was 94 IIRC ).
>  > >
>  > > If it's supported by v4l-dvb-kernel, it's entirely possible, yes.
>  > >
>  > > > 2. Can I mix and match from the sources...i.e. can I graft the em28xx
>  > > > stuff from v4l-dvb-kernel into the v4l-dvb source and compile
>  > > > successfully or has the underlying code changed at a more strategic
>  > > > level?
>  > >
>  > > Not trivially, since v4l-dvb-kernel contains changes to the core code
>  > > that the em28xx driver relies on and that are incompatible with
>  > > changes in the main v4l-dvb repository since. You can try
>  > > http://www.makomk.com/hg/v4l-dvb-makomk - it's the em28xx and xc3028
>  > > drivers grafted onto a version of v4l-dvb that's about 5 months old at
>  > > this point - though it's really not a great starting point for porting
>  > > them onto newer versions, since you'd want to drop the xc3028 driver
>  > > in favour of the newer one
>  > >
>  >
>  > Makomk,
>  > spreading around your even more broken tree won't help anyone.
>  >
>  > This device already had some issues with the v4l-dvb-kernel tree, this
>  > is what I'll do in April.
>  >
>  > > > 3. Why did the sources branch? Was there a good technical reason for
>  > > this?
>  > >
>  > > Supporting the xc3028 silicon tuner needed some changes to support
>  > > hybrid analog/digital tuners better. Unfortunately, Markus couldn't
>  > > come to an agreement with the rest of the developers on how to do it.
>  > > (I think the main concern were that the changes he were proposing were
>  > > rather more invasive than they needed to be and risked breaking
>  > > existing drivers). In the end, someone else coded the equivalent
>  > > functionality in a more backwards-compatible way and merged it in
>  > > stages.
>  > >
>  > > (It's actually relatively easy to port code from Markus' hybrid tuner
>  > > framework to the v4l-dvb one, though he will never admit so.)
>  > >
>  >
>  > The reason is my trust is gone I asked in September if it's possible
>  > to get those devices work with what's available and I got the answer
>  > it's not.
>  > This stupid fight lasts for more than 2 years already, but I'm the one
>  > who spent weeks on writing code for getting those things supported and
>  > even rewrote code although there was no serious participation in the
>  > discussions I tried to trigger...
>  >
>  > If I tell a company that I will add support for something till a given
>  > date I'll do so to keep up the good contacts. Unfortunately this is
>  > not how some people at linuxtv behave and it slows down everything
>  > even for other manufacturers where I'm not involved.
>  >
>  > It's me who mostly spent his time on writing any code on mcentral.de,
>  > the code didn't write itself especially Aidan has no respect about
>  > that, neither do some other people. Maybe it's really better to
>  > provide binary only blobs to remember especially such people that it
>  > requires alot work to get those things work.
>  >
>
>
> there is still one thing which I remember when I attended the European
>  Linux Kernel summit 2007.
>  Jonathan Corbet held a presentation about kernel development, and
>  there was one sentence "we mustn't loose another developer".
>  This whole issue could be solved within 1 hour, and the fight of 2
>  years could be over immediately nearly without any work.
>  There's not much more to write about this.
>
>
>  > > > 4. If I can't use the v4l-dvb sources to get my em28xx working what's
>  > > > the chances of getting the v4l-dvb-kernel stuff working for the
>  > > > lifeview flydvb card?
>  > >
>  > > Not good. Its support for other hardware is, if anything, going to be
>  > > slowly getting worse over time as other drivers have to be modified or
>  > > disabled to make it compile on newer kernels.
>  > >
>  >
>  > that for the other repository (em28xx-userspace2/userspace-drivers on
>  > mcentral.de/hg) is available, although it needs some work with that
>  > device.
>  >
>  > Markus
>  >
>

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
