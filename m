Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:31702 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757828Ab3AIOmh (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 9 Jan 2013 09:42:37 -0500
Date: Wed, 9 Jan 2013 12:41:58 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: Michael Krufky <mkrufky@linuxtv.org>
Cc: Oliver Schinagl <oliver+list@schinagl.nl>,
	Johannes Stezenbach <js@linuxtv.org>,
	Jiri Slaby <jirislaby@gmail.com>,
	linux-media <linux-media@vger.kernel.org>, jmccrohan@gmail.com,
	Christoph Pfister <christophpfister@gmail.com>
Subject: Re: [RFC] Initial scan files troubles and brainstorming
Message-ID: <20130109124158.50ddc834@redhat.com>
In-Reply-To: <CAOcJUbyKv-b7mC3-W-Hp62O9CBaRLVP8c=AWGcddWNJOAdRt7Q@mail.gmail.com>
References: <507FE752.6010409@schinagl.nl>
	<50D0E7A7.90002@schinagl.nl>
	<50EAA778.6000307@gmail.com>
	<50EAC41D.4040403@schinagl.nl>
	<20130108200149.GB408@linuxtv.org>
	<50ED3BBB.4040405@schinagl.nl>
	<20130109084143.5720a1d6@redhat.com>
	<CAOcJUbyKv-b7mC3-W-Hp62O9CBaRLVP8c=AWGcddWNJOAdRt7Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Wed, 9 Jan 2013 06:08:44 -0500
Michael Krufky <mkrufky@linuxtv.org> escreveu:

> On Wed, Jan 9, 2013 at 5:41 AM, Mauro Carvalho Chehab
> <mchehab@redhat.com> wrote:
> > Em Wed, 09 Jan 2013 10:43:23 +0100
> > Oliver Schinagl <oliver+list@schinagl.nl> escreveu:
> >
> >> On 08-01-13 21:01, Johannes Stezenbach wrote:
> >> > On Mon, Jan 07, 2013 at 01:48:29PM +0100, Oliver Schinagl wrote:
> >> >> On 07-01-13 11:46, Jiri Slaby wrote:
> >> >>> On 12/18/2012 11:01 PM, Oliver Schinagl wrote:
> >> >>>> Unfortunatly, I have had zero replies.
> >> >>> Hmm, it's sad there is a silence in this thread from linux-media guys :/.
> >> >> In their defense, they are very very busy people ;) chatter on this
> >> >> thread does bring it up however.
> >> > This is such a nice thing to say :-)
> >> > But it might be that Mauro thinks the dvb-apps maintainer should
> >> > respond, but apparently there is no dvb-apps maintainer...
> >> > Maybe you should ask Mauro directly to create an account for you
> >> > to implement what you proposed.
> >> Mauro is CC'ed and I'd ask of course for this (I kinda did) but who
> >> decides what I suggested is a good idea? I personally obviously think it
> >> is ;) and even more so if dvb-apps are unmaintained.
> >>
> >> I guess the question now becomes 'who okay's this change? Who says
> >> 'okay, lets do it this way. Once that is answered we can go from there ;)
> >
> > If I understood it right, you want to split the scan files into a separate
> > git tree and maintain it, right?
> >
> > I'm ok with that.
> >
> > Regards,
> > Mauro
> 
> As a DVB maintainer, I am OK with this as well - It does indeed make
> sense to separate the c code sources from the regional frequency
> tables, and I'm sure we'll see much benefit from this change.

Done. I created a tree for Oliver to maintain it and an account for him.
I also created a new tree with just the DVB table commits to:
	http://git.linuxtv.org/dtv-scan-tables.git

I kept there both szap and scan files, although maybe it makes sense to
drop the szap table (channels-conf dir). It also makes sense to drop the
tables from the dvb-apps tree, to avoid duplicated stuff, and to avoid troubles
on distros that may want to have both packages.

Anyway, as Oliver has now access to both trees, I'll let him to handle
and maintain it.

Christoph,

Thank you for all the hard work over all those years!

Happy new year,
Mauro
