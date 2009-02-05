Return-path: <linux-media-owner@vger.kernel.org>
Received: from web23207.mail.ird.yahoo.com ([217.146.189.62]:33124 "HELO
	web23207.mail.ird.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756365AbZBEJnh convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 5 Feb 2009 04:43:37 -0500
Date: Thu, 5 Feb 2009 09:43:35 +0000 (GMT)
From: Newsy Paper <newspaperman_germany@yahoo.com>
Reply-To: newspaperman_germany@yahoo.com
Subject: Re: [linux-dvb] Re : Technotrend Budget S2-3200 Digital artefacts on HDchannels
To: linux-media@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Message-ID: <582762.49889.qm@web23207.mail.ird.yahoo.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

it's really disappointing that this error exists for long time and everybody ran out of idea how to fix it :(


regards

Newsy

--- Jonas Kvinge <linuxtv@night-light.net> schrieb am Di, 3.2.2009:

> Von: Jonas Kvinge <linuxtv@night-light.net>
> Betreff: Re: [linux-dvb] Re : Technotrend Budget S2-3200 Digital artefacts on HDchannels]
> An: linux-dvb@linuxtv.org
> Datum: Dienstag, 3. Februar 2009, 20:00
> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA1
>
>
> Manu Abraham wrote:
> > Alex Betis wrote:
> >> On Tue, Jan 27, 2009 at 9:56 PM, Manu Abraham
> <abraham.manu@gmail.com>wrote:
> >>
> >>>> Hmm OK, but is there by any chance a fix
> for those issues somewhere or
> >>>> in the pipe at least? I am willing to test
> (as I already offered), I
> >>>> can compile the drivers, spread printk or
> whatever else is needed to
> >>>> get useful reports. Let me know if I can
> help sort this problem. BTW in
> >>>> my case it is DVB-S2 30000 SR and FEC 5/6.
> >>> It was quite not appreciable on my part to
> provide a fix or reply in
> >>> time nor spend much time on it earlier, but
> that said i was quite
> >>> stuck up with some other things.
> >>>
> >>> Can you please pull a copy of the multiproto
> tree
> >>> http://jusst.de/hg/multiproto or the v4l-dvb
> tree from
> >>> http://jusst.de/hg/v4l-dvb
> >>>
> >>> and apply the following patch and comment what
> your result is ?
> >>> Before applying please do check whether you
> still have the issues.
> >> Manu,
> >> I've tried to increase those timers long ago
> when played around with my card
> >> (Twinhan 1041) and scan utility.
> >> I must say that I've concentrated mostly on
> DVB-S channels that wasn't
> >> always locking.
> >> I didn't notice much improvements. The thing
> that did help was increasing
> >> the resolution of scan zigzags.
> >
> > With regards to the zig-zag, one bug is fixed in the
> v4l-dvb tree.
> > Most likely you haven't tried that change.
> >
> >> I've sent a patch on that ML and people were
> happy with the results.
> >
> > I did look at your patch, but that was completely
> against the tuning
> > algorithm.
> >
> > [..]
> >
> >> I believe DVB-S2 lock suffer from the same
> problem, but in that case the
> >> zigzag is done in the chip and not in the driver.
> >
> > Along with the patch i sent, does the attached patch
> help you in
> > anyway (This works out for DVB-S2 only)?
> >
> >
> >
>
> - From what I understand the driver still has some issues.
> Got feedback
> from another guy with Canal Digital in Norway that he has
> the same
> issues as me.
>
> Not sure if the diff was an attempt to fix the digital
> artefacts but I
> tried applying the diff manually on the source I grabbed
> from
> http://jusst.de/hg/v4l-dvb/ but did not notice any
> improvements or
> difference with the artefacts. Would any logs be helpful?
>
> If there is anything else I could try I'm willing to
> try it out. I
> appreciate your effort. Thanks.
>
>
> Jonas
> -----BEGIN PGP SIGNATURE-----
> Version: GnuPG v2.0.9 (GNU/Linux)
> Comment: Using GnuPG with SUSE - http://enigmail.mozdev.org
>
> iEYEARECAAYFAkmIlGoACgkQpvOo+MDrK1H4yACdHPoej4cSsfPvp7m4NUGsAjAz
> 36EAn3cz9MffjPWztzyMEOcs0VcxhQdD
> =h9tA
> -----END PGP SIGNATURE-----
>
> _______________________________________________
> linux-dvb users mailing list
> For V4L/DVB development, please use instead
> linux-media@vger.kernel.org
> linux-dvb@linuxtv.org
> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb



      
