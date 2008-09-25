Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from as-10.de ([212.112.241.2] helo=mail.as-10.de)
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <halim.sahin@t-online.de>) id 1KivRp-0006T3-EX
	for linux-dvb@linuxtv.org; Thu, 25 Sep 2008 20:20:18 +0200
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.as-10.de (Postfix) with ESMTP id 6874B33A7DE
	for <linux-dvb@linuxtv.org>; Thu, 25 Sep 2008 20:19:44 +0200 (CEST)
Received: from mail.as-10.de ([127.0.0.1])
	by localhost (as-10.de [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id iWzIvalbyCFU for <linux-dvb@linuxtv.org>;
	Thu, 25 Sep 2008 20:19:44 +0200 (CEST)
Received: from halim.local (p54AE70F2.dip.t-dialin.net [84.174.112.242])
	(using TLSv1 with cipher ADH-AES256-SHA (256/256 bits))
	(No client certificate requested) (Authenticated sender: web11p28)
	by mail.as-10.de (Postfix) with ESMTPSA id 0D29933A7B8
	for <linux-dvb@linuxtv.org>; Thu, 25 Sep 2008 20:19:44 +0200 (CEST)
Date: Thu, 25 Sep 2008 20:19:43 +0200
From: Halim Sahin <halim.sahin@t-online.de>
To: linux-dvb@linuxtv.org
Message-ID: <20080925181943.GA12800@halim.local>
References: <002101c91f1a$b13c4e60$0401a8c0@asrock>
	<a3ef07920809250815k21948f99m7780e852088b96f@mail.gmail.com>
	<48DBBAC0.7030201@gmx.de>
	<d9def9db0809251044k7fbcaa1awdf046edb2ca9b020@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <d9def9db0809251044k7fbcaa1awdf046edb2ca9b020@mail.gmail.com>
Subject: Re: [linux-dvb] [ANNOUNCE] DVB API improvements End-user point
	of	viwer
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

Markus, =

Go on and ask the distributors to package your userspace stuff!
In fact nobody wants patched applications.
standardversion shipped with their distros will be prefered.



On Do, Sep 25, 2008 at 07:44:29 +0200, Markus Rechberger wrote:
> On Thu, Sep 25, 2008 at 6:22 PM, J=F6rg Knitter <joerg.knitter@gmx.de> wr=
ote:
> > VDR User wrote:
> >> 2008/9/25 Sacha <sacha@hemmail.se>:
> >>
> >>> Following your discussion from an end-user point of viwer I must say =
that I
> >>> wholy agree with this statement:
> >>>
> >>> <But 2 years to get a new API is really too much. And during these 2 =
years,
> >>> 2
> >>>
> >>> <different trees for 2 differents drivers was totally insane. We
> >>> (applications
> >>>
> >>> <devs) are always making our best to bring DVB to users as easily as
> >>> possible.
> >>>
> >>> <And trust me, the multiproto story has complicated users life A LOT.=
 This
> >>> must NEVER happen again.
> >>>
> >>> We, end-users want our stuff working now!
> >>>
> >>
> >> I assume you'd also like something that is well-designed, tested, and
> >> stable rather then slapped together and rushed...  But you know what
> >> they say about assumptions!
> >>
> >
> > I have to agree with the claim Sacha said.
> >
> > I am also "just" an end-user, got a TT3200 with VDR 1.7 working with all
> > the guides and even wrote an article on it. But it was and is still a
> > pain - for 2 years now.
> >
> > With the introduction of the alternative S2API I was hoping that this
> > long wait is over after waiting endlessly after the announcement,
> > multiproto is ready "in a few weeks".
> >
> > I have followed the discussion all the two (?) years, and I did just
> > filter out information about, when the API could be ready, and I was
> > shocked by all the really bad personal attacks that happened last year
> > (or the year before) and the splits that results now in four
> > "repositories" (kernel, multiproto, hvr4000-stuff and mcentral), often
> > with dozens of patches postet here or at vdrportal that need to be
> > applied to get a DVB card running.
> >
> > And the main reasons for this is not really technical, it seems to me
> > that they are personal. Open source projects claim to be better than
> > commercial products, but the things that happened and currently happen
> > are a good reason to see also the disadvantage of community development.
> >
> > I understand all sides:
> > 1) Manu does not want to to give up his work that he worked for long 2
> > years.
> > 2) Markus Rechberger also did a lot of work, but I remember him to be
> > very insulting to other developers - and quite uncooperative by starting
> > his own tree. Linux development with MCC as leader might indeed be hard
> > ;)...
> =

> just a small side note here, uncooperative because people wanted me to go=
 into
> a definitely wrong direction back then knowledge was limited by both
> parties (this
> is the final truth of it back then).
> On the other side it was the uncooperativeness and dumping of alot
> code and issues
> which have been solved back then already with the help of a lot people.
> I don't bother anymore I found other ways to have everything be
> possible to coexist
> in the kernel, and I actually prefer this coexisting solution now
> which also provides
> full support and even has a higher backward compatibility than the
> things which got
> pushed through back in time.
> =

> I'd rather prefer to forget about what happened here because it's a
> full mess caused
> by several people with limited knowledge years ago and todays position
> about it is totally
> different.
> You can also find patched enduser applications on mcentral.de which can b=
e used
> with other devices and provide extra features which are required in
> order to get devices
> work properly.
> There's gqradio patched to support lirc and digital audio
> automatically, same with vlc and tvtime
> (the last one also having different video output plugins which allow
> software rendering if xvideo
> hardware acceleration isn't available.
> =

> Still one fact till now is that not all devices which have worked in
> v4l-dvb-experimental back in time
> are now supported by v4l-dvb on linuxtv.org and nor all the em28xx
> based devices are yet in the
> em28xx-new tree, whereas the second one is the result of heavy
> refactoring and better manufacturer
> support for some back then reverse engineered components (-which is
> good that they got replaced in order
> to raise the signal strength).
> =

> Markus
> =

> > 3) The S2API guys are fed up with all the waiting. Maybe there is indeed
> > no technical reason behind the decision for S2API as I am also wondering
> > why there is no answer to THE question. But waiting endlessly really is
> > no solution...
> >
> > The situation I see can not be solved by endless discussion, and even if
> > MCC would switch to multiproto (again), there discussion would continue
> > endlessly.
> >
> > I just see two options to get a fair decision:
> > 1) Allowing both APIs exist parallel for a short time and see who is the
> > winner (as mentioned).
> > 2) Let the community decide (all interested developers and even
> > end-users like me and Sacha) with some kind of online vote. Communicate
> > clearly before which "important" developer favours which API. As none of
> > the API seems to have a real advantage/disadvantage, users like me will
> > have to vote for both or decide on personal taste ;)
> >
> > I favour option 2) as I also don=B4t like applications that rely on
> > certain hardware (if only one API is supported).
> >
> > With kind regards
> >
> > Joerg Knitter
> >
> > _______________________________________________
> > linux-dvb mailing list
> > linux-dvb@linuxtv.org
> > http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
> >
> =

> _______________________________________________
> linux-dvb mailing list
> linux-dvb@linuxtv.org
> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
Halim Sahin
E-Mail:				=

halim.sahin (at) t-online.de

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
