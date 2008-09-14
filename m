Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from [195.7.61.12] (helo=killala.koala.ie)
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <simon@koala.ie>) id 1Keybr-0006k6-3M
	for linux-dvb@linuxtv.org; Sun, 14 Sep 2008 22:54:19 +0200
Received: from [195.7.61.7] (cozumel.koala.ie [195.7.61.7])
	(authenticated bits=0)
	by killala.koala.ie (8.14.0/8.13.7) with ESMTP id m8EKsFBn006402
	for <linux-dvb@linuxtv.org>; Sun, 14 Sep 2008 21:54:15 +0100
From: Simon Kenyon <simon@koala.ie>
To: linux-dvb@linuxtv.org
In-Reply-To: <d9def9db0809141225q421828cdn8b97c0e61b99acac@mail.gmail.com>
References: <466109.26020.qm@web46101.mail.sp1.yahoo.com>
	<48C66829.1010902@grumpydevil.homelinux.org>
	<d9def9db0809090833v16d433a1u5ac95ca1b0478c10@mail.gmail.com>
	<48CC42D8.8080806@gmail.com> <1221419319.9803.0.camel@localhost>
	<d9def9db0809141225q421828cdn8b97c0e61b99acac@mail.gmail.com>
Date: Sun, 14 Sep 2008 21:54:15 +0100
Message-Id: <1221425655.10386.4.camel@localhost>
Mime-Version: 1.0
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

On Sun, 2008-09-14 at 21:25 +0200, Markus Rechberger wrote:
> On Sun, Sep 14, 2008 at 9:08 PM, Simon Kenyon <simon@koala.ie> wrote:
> > On Sun, 2008-09-14 at 02:46 +0400, Manu Abraham wrote:
> >> The initial set of DVB-S2 multistandard devices supported by the
> >> multiproto tree is follows. This is just the stb0899 based dvb-s2 driver
> >> alone. There are more additions by 2 more modules (not devices), but for
> >> the simple comparison here is the quick list of them, for which some of
> >> the manufacturers have shown support in some way. (There has been quite
> >> some contributions from the community as well.):
> >>
> >> (Also to be noted is that, some BSD chaps also have shown interest in
> >> the same)
> >
> > is there any issue with GPL code being merged into BSD?
> > just asking
> 
> Not with the code which comes from our side. They're at DVB-T right
> now which already works.
> That code is fully duallicensed.
> The Bridge code itself needs to get slightly refactored for analog TV.
> They are getting full technical and HW support.

not quite sure (in the context of your sentence) who "our side" is.
all the code on mcentral.de seems to be GPL 2 or greater with copyright
claimed by you and others. i've seen nothing on this mailing list about
dual licencing any linuxtv.org code.

i am in no way a gpl bigot. but legal niceties have to be dealt with.
--
simon


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
