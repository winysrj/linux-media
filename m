Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail.gmx.net ([213.165.64.20])
	by www.linuxtv.org with smtp (Exim 4.63)
	(envelope-from <HWerner4@gmx.de>) id 1KZ8gO-0004Af-BW
	for linux-dvb@linuxtv.org; Fri, 29 Aug 2008 20:26:54 +0200
Date: Fri, 29 Aug 2008 20:26:18 +0200
From: "Hans Werner" <HWerner4@gmx.de>
In-Reply-To: <48B81DB6.9030206@linuxtv.org>
Message-ID: <20080829182618.74790@gmx.net>
MIME-Version: 1.0
References: <20080821173909.114260@gmx.net> <20080823200531.246370@gmx.net>
	<48B78AE6.1060205@gmx.net> <48B7A60C.4050600@kipdola.com>
	<48B802D8.7010806@linuxtv.org> <20080829154342.74800@gmx.net>
	<37219a840808290852k4cafb891tbf35162d3add6d60@mail.gmail.com>
	<48B81DB6.9030206@linuxtv.org>
To: Steven Toth <stoth@linuxtv.org>, linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] [PATCH] Future of DVB-S2
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

> >> I hope your and Darron's drivers (http://dev.kewl.org/hauppauge) are
> not seen as
> >> marginalized. The multifrontend (MFE) patch by you and Darron is the
> driver that I
> >> actually *use* for watching TV. It works nicely with Kaffeine without
> modification. And I,
> >> for one, appreciate your sane approach and the simplicity of the
> techniques you used to
> >> add DVB-S2 support (using sysctls for the SFE driver, and wrapping two
> ioctls to pull in
> >> extra parameters for the MFE driver). If the kernel API is changed
> sensibly it should be
> >> easy and quick to adapt your drivers to fit in.
> >>
> >>> The HVR4000 situation is under review, the wheels are slowly
> turning....
> >> If you are able to say anything about that I would be very interested.
> >>
> >> Now, to show how simple I think all this could be, here is a PATCH
> implementing what
> >> I think is the *minimal* API required to support DVB-S2.
> >>
> >> Notes:
> >>
> >> * same API structure, I just added some new enums and variables,
> nothing removed
> >> * no changes required to any existing drivers (v4l-dvb still compiles)
> >> * no changes required to existing applications (just need to be
> recompiled)
> >> * no drivers, but I think the HVR4000 MFE patch could be easily adapted
> >>

> >>
> >> Why should we not merge something simple like this immediately? This
> could have been done
> >> years ago. If it takes several rounds of API upgrades to reach all the
> feature people want then
> >> so be it, but a long journey begins with one step.
> > 
> > This will break binary compatibility with existing apps.  You're right
> > -- those apps will work with a recompile, but I believe that as a
> > whole, the linux-dvb kernel and userspace developers alike are looking
> > to avoid breaking binary compatibility.
> 

> Hans, thanks for your kind words.

You're welcome.

> I've seen patches similar to this from a number of people

Good, it was faster to write it than search for someone else's.

> but this only 
> solves today's problem, it doesn't help with ISDB-T, DVB-H, CMMB, 
> ATSC-MH etc.

I think today's problem (really yesterday's) is large enough to justify being solved 
-- DVB-S2 hardware is now very common amongst end users and popular and drivers
are written and working. It would allow most of the out-of-kernel drivers to be merged
wouldn't it?

Of course it would be nicer to support lots of other hardware but so far nobody has
merged the more capable multiproto API. It seems to be too big a pill to swallow.

Even if a more capable API were merged today, it would be unwise to consider the API 
fixed forever. It will need to continue to change as new hardware standards are developed.
Three of the four standards you mentioned are not even explicitly supported in multiproto
(is ATSC-M/H even final?). Anyway, perhaps by concentrating on solving the current problems
we can create an example and precedent of how to complete API upgrades successfully
without going off the rails for years.

> ... as I say, the wheels are turning so keep watching this mailing list.

Tantalising.... Do you mean you and Darron are working on something? Or you 
know of something else specific?

Hans

-- 
Release early, release often. Really, you should.

GMX startet ShortView.de. Hier findest Du Leute mit Deinen Interessen!
Jetzt dabei sein: http://www.shortview.de/wasistshortview.php?mc=sv_ext_mf@gmx

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
