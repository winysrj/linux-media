Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-in-05.arcor-online.net ([151.189.21.45]:34190 "EHLO
	mail-in-05.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753339AbZAUCGx (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 20 Jan 2009 21:06:53 -0500
Subject: Re: [linux-dvb] Terratec XS HD support?
From: hermann pitton <hermann-pitton@arcor.de>
To: linux-media@vger.kernel.org
Cc: BOUWSMA Barry <freebeer.bouwsma@gmail.com>,
	DVB mailin' list thingy <linux-dvb@linuxtv.org>,
	em28xx@mcentral.de
In-Reply-To: <d9def9db0901170216g5be0ed16sa1eeb4c4f9acce76@mail.gmail.com>
References: <496C9FDE.2040408@hemmail.se>
	 <d9def9db0901131101y59cd5c1ct2344052f86b42feb@mail.gmail.com>
	 <d9def9db0901151028k6ab8bd79q6627c7516020aabe@mail.gmail.com>
	 <alpine.DEB.2.00.0901171037230.18169@ybpnyubfg.ybpnyqbznva>
	 <d9def9db0901170216g5be0ed16sa1eeb4c4f9acce76@mail.gmail.com>
Content-Type: text/plain
Date: Wed, 21 Jan 2009 03:07:08 +0100
Message-Id: <1232503628.2685.5.camel@pc10.localdom.local>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


Am Samstag, den 17.01.2009, 11:16 +0100 schrieb Markus Rechberger:
> On Sat, Jan 17, 2009 at 10:57 AM, BOUWSMA Barry
> <freebeer.bouwsma@gmail.com> wrote:
> > Hi Markus, I follow your list as a non-subscriber, but I thought
> > it would be worthwhile to post this to linux-dvb as well, and
> > eventually to linux-media...
> >
> > On Thu, 15 Jan 2009, Markus Rechberger wrote:
> >
> >> On Tue, Jan 13, 2009 at 8:01 PM, Markus Rechberger
> >> <mrechberger@gmail.com> wrote:
> >
> >> >> Is there any news about Terratec HTC USB XS HD support?
> >
> >> > it's upcoming soon.
> >
> > Thanks Markus, that's good news for me, and for several people
> > who have written me as well!
> >
> >
> >> http://mcentral.de/wiki/index.php5/Terratec_HTC_XS
> >> you might track that site for upcoming information.
> >
> > Interesting.  You say that your code will make use of a BSD
> > setup.  Can you or someone say something about this, or point
> > to past discussion which explains this?  Would this be the
> > userspace_tuner link on your wiki?
> >
> > In particular, I'm wondering whether this is completely
> > compatible with the standard DVB utilities -- dvbscan,
> > dvbstream, and the like, or whether a particular higher-
> > level end-user application is required.
> >
> >
> 
> The design goes hand in hand with some discussions that have been made
> with some BSD developers.
> The setup makes use of usbdevfs and pci configspace access from
> userland, some work still has to be done there, it (will give/gives)
> manufacturers the freedom to release opensource and binary drivers for
> userland.
> I'm a friend of open development and not of some kind of monopoly
> where a few people rule everything (linux).

I do remember when BSD shared some tuner code with GNU/LINUX ;)

What you try to make up from it now is in best case a joke.

Please enjoy further, but it is totally unrelated to you,
concerning sharing.

Cheers,
Hermann


