Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:40422 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754495Ab3AJUFg (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 10 Jan 2013 15:05:36 -0500
Date: Thu, 10 Jan 2013 18:04:34 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: Manu Abraham <abraham.manu@gmail.com>
Cc: Jiri Slaby <jirislaby@gmail.com>,
	Michael Krufky <mkrufky@linuxtv.org>,
	Oliver Schinagl <oliver+list@schinagl.nl>,
	Johannes Stezenbach <js@linuxtv.org>,
	linux-media <linux-media@vger.kernel.org>, jmccrohan@gmail.com,
	Christoph Pfister <christophpfister@gmail.com>
Subject: Re: [RFC] Initial scan files troubles and brainstorming
Message-ID: <20130110180434.0681a7e1@redhat.com>
In-Reply-To: <CAHFNz9KWf=EtvpJ1kDGFPKSvqwd9S51O1=wVYcjNmZE-+_7Emg@mail.gmail.com>
References: <507FE752.6010409@schinagl.nl>
	<50D0E7A7.90002@schinagl.nl>
	<50EAA778.6000307@gmail.com>
	<50EAC41D.4040403@schinagl.nl>
	<20130108200149.GB408@linuxtv.org>
	<50ED3BBB.4040405@schinagl.nl>
	<20130109084143.5720a1d6@redhat.com>
	<CAOcJUbyKv-b7mC3-W-Hp62O9CBaRLVP8c=AWGcddWNJOAdRt7Q@mail.gmail.com>
	<20130109124158.50ddc834@redhat.com>
	<CAHFNz9+=awiUjve3QPgHtu5Vs2rbGqcLUMzyOojguHnY4wvnOA@mail.gmail.com>
	<50EF0A4F.1000604@gmail.com>
	<CAHFNz9LrW4GCZb-BwJ8v7b8iT-+8pe-LAy8ZRN+mBDNLsssGPg@mail.gmail.com>
	<50EF1034.7060100@gmail.com>
	<CAHFNz9KWf=EtvpJ1kDGFPKSvqwd9S51O1=wVYcjNmZE-+_7Emg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Fri, 11 Jan 2013 00:38:18 +0530
Manu Abraham <abraham.manu@gmail.com> escreveu:

> On 1/11/13, Jiri Slaby <jirislaby@gmail.com> wrote:
> > On 01/10/2013 07:46 PM, Manu Abraham wrote:
> >> The scan files and config files are very specific to dvb-apps, some
> >> applications
> >> do rely on these config files. It doesn't really make sense to have
> >> split out config
> >> files for these  small applications.
> >
> > I don't care where they are, really. However I'm strongly against
> > duplicating them. Feel free to remove the newly created repository, I'll
> > be fine with that.
> 
> I haven't duplicated anything at all. It is Mauro who has duplicated stuff,
> by creating a new tree altogether.

I only did it by request, and after having some consensus at the ML, and
after people explicitly asking me to do that.

I even tried to not express my opinion to anybody. But it seems I'm
forced by you to give it. So, let it be.

The last patches from you there were 11 months ago, and didn't bring any
new functionality there... they are just indentation fixes:
	http://www.linuxtv.org/hg/dvb-apps/

The last one with a new functionality seems to be this one, 15 months ago:
	http://www.linuxtv.org/hg/dvb-apps/rev/d4e8bf5658ce

Also, people find a very bad time when they submit any fixes for the driver
you wrote, as you doesn't seem to have enough time to review their patches.

So, I suspect that you're a very very busy person, with almost no time to
maintain your previous work. If something has changed, and you're now
finding more time, I'd pleased if you could review the patches that 
are there for a long time (there is one from 2011 that it is a rebase of
an even older patch) before re-doing Oliver's scanfile updates at dvb-tools:
	http://www.spinics.net/lists/linux-media/msg58283.html

Considering that nobody is having much time for the dvb-apps tree
nowadays, I really think that it would be great to get someone
with more time to maintain those files, as otherwise the update scan
files may be on the limbo for a long time, and releasing us to have
more time with development.

As proposed by Oliver, it seemed to be a good idea to have it on a
separate tree, as those scan files are actually independent of the 
dvb-apps, and can be used by other applications.

That's why I welcomed Oliver's initiative to maintain it, and I wish
him a good work with that.

> Eventually what will happen is that, as applications do get developed,
> the config files which are alongwith the applications will have proper
> compatibility with the applications while, the split out config files will
> be in a different state, providing nothing but pain for everyone.

The format of those files can't be changed without breaking other existing
applications that relies on its format, like mplayer, vlc, etc.

It could make sense, though, to convert them in the future to a more generic
format that would be delivery-system independent and that could easily be
converted into all application-specific formats, and add there some
format-change tool that would dynamically generate the files at 
vdr, dvb-apps, kaffeine... format.

By having it on a separate tree, with its own maintainer, Oliver can
focus on it, without needing to be bothered with maintaining the dvb-apps.

So, it makes all sense for me to have it maintained in separate.

That's said, there's no problem on having those files maintained on two
or more trees. Actually, there are already dozens of forks of it, as each
distribution has its own dvb-apps fork, some outdated and eventually some
with their own scan files there.

So, if no agreement is reached, I would just keep it as is for a while and
review it maybe an year later.

Regards,
Mauro
