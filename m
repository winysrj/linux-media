Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from ik-out-1112.google.com ([66.249.90.179])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <hansson.patrik@gmail.com>) id 1Jecbm-0005qE-O3
	for linux-dvb@linuxtv.org; Wed, 26 Mar 2008 21:52:34 +0100
Received: by ik-out-1112.google.com with SMTP id b32so1558181ika.1
	for <linux-dvb@linuxtv.org>; Wed, 26 Mar 2008 13:52:19 -0700 (PDT)
Message-ID: <8ad9209c0803261352s664d40fdud2fcbf877b10484b@mail.gmail.com>
Date: Wed, 26 Mar 2008 21:52:02 +0100
From: "Patrik Hansson" <patrik@wintergatan.com>
To: linux-dvb <linux-dvb@linuxtv.org>
In-Reply-To: <1206563002.8947.2.camel@youkaida>
MIME-Version: 1.0
Content-Disposition: inline
References: <1206139910.12138.34.camel@youkaida> <1206185051.22131.5.camel@tux>
	<1206190455.6285.20.camel@youkaida> <1206270834.4521.11.camel@shuttle>
	<1206348478.6370.27.camel@youkaida>
	<1206546831.8967.13.camel@acropora>
	<af2e95fa0803261142r33a0cdb1u31f9b8abc2193265@mail.gmail.com>
	<1206563002.8947.2.camel@youkaida>
Subject: Re: [linux-dvb] Now with debug info - Nova-T-500 disconnects - They
	are back!
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

On Wed, Mar 26, 2008 at 9:23 PM, Nicolas Will <nico@youplala.net> wrote:
>
>  On Wed, 2008-03-26 at 19:42 +0100, Henrik Beckman wrote:
>  > I know how you feel.
>  >
>  > I=B4ve been there but now my box is stable,
>  > root@media:~# uname -a
>  > Linux media 2.6.22-14-generic #1 SMP Tue Dec 18 08:02:57 UTC 2007 i686
>  > GNU/Linux
>
>  Sure, my system was stable with 2.6.22 too.
>
Linux IKA 2.6.22-14-generic #1 SMP Tue Dec 18 08:02:57 UTC 2007 i686 GNU/Li=
nux
Not stable at all here, got 2 disconnects in 2 hours.
So it can't just be the kernel.

>
>  >
>  > My v4l-dvb is from 2008-01-28 and I have patched it with (or atleast
>  > the patches in that dir are),
>  > dib0700-start-streaming-fix.patch
>  > dib300mc_tuning_fix.diff
>  > MT1060_IF1_freq_set.diff
>  > and a patch wich I think is for UHF.
>
>  I am well aware of those, I am trying to keep the wiki page updated as
>  much as I can (camelreef is me).
>
>  If you grab a recent tree, all those patches have been merged and you
>  will not need to apply them anymore.
>
>  There is only last patch on the wiki that gives remote key repeats, but
>  it should get in the main tree soon, Patrick put it in his branch.
>
>
>
>  Nico
>
>
>  _______________________________________________
>  linux-dvb mailing list
>  linux-dvb@linuxtv.org
>  http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
