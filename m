Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:42111 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753830AbZASALk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 18 Jan 2009 19:11:40 -0500
Date: Sun, 18 Jan 2009 22:11:13 -0200
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Klaus Schmidinger <Klaus.Schmidinger@cadsoft.de>
Cc: linux-media@vger.kernel.org
Subject: Re: [linux-media] Re: [linux-dvb] Cross-posting linux-media,
 linux-dvb etc
Message-ID: <20090118221113.539f292d@caramujo.chehab.org>
In-Reply-To: <4972FC26.8080808@cadsoft.de>
References: <alpine.LRH.1.10.0901161545540.28478@pub2.ifh.de>
	<alpine.DEB.2.00.0901170002430.18012@ybpnyubfg.ybpnyqbznva>
	<a3ef07920901162151r270cdb16w92c0d7d6b7e770a1@mail.gmail.com>
	<4972FC26.8080808@cadsoft.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, 18 Jan 2009 10:53:42 +0100
Klaus Schmidinger <Klaus.Schmidinger@cadsoft.de> wrote:

> On 17.01.2009 06:51, user.vdr wrote:
> > I think it's a lame idea to clump all media related stuff into one
> > mailing list from separate ml's because 1) it's too general of a topic
> > and 2) those ml's already had a lot of activity on their own.  The
> > idea of sifting through tons of posts of no interest is quite a hassle
> > to say the least.  This "solution" just doesn't seem very well thought
> > out imo but it is what it is I guess.
> 
> I also don't like the high traffic on linux-media. linux-dvb was exactly
> dedicated to DVB, and that's all that interests me. I'm not interested
> in analog video or cameras or whatever stuff that's discussed on
> linux-media.

>From driver development POV, there's no sense of splitting analog and digital
stuff.

A large amount of drivers support both analog and digital API (bttv, cx88,
saa7134, saa7146, pvrusb2, em28xx, cx18, cx23885...). With the previous
situation, all discussions for those drivers would require cross-postings. This
is bad, since developers needed to read the same message twice (or even three
times, due to v4l-dvb-maintainers ML). So, their precious time that would
otherwise be used in development were lost just to read the same message again
and again.

Also, if you look at the recent past posts on V4L ML, several of them are related to
DVB stuff.There were several cross-postings there as well.

I can't see a clear solution to reduce the traffic on linux-media. We could
eventually think on having some per-driver ML's, but I'm afraid that this
wouldn't work nice... For example, an issue on an saa7134 driver with xc3028
should be posted at saa7134 or at xc3028 ML?


Cheers,
Mauro
