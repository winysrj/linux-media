Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:52730 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754179AbZC1D7O (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 27 Mar 2009 23:59:14 -0400
Date: Sat, 28 Mar 2009 00:58:59 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: hermann pitton <hermann-pitton@arcor.de>
Cc: klaas de waal <klaas.de.waal@gmail.com>,
	Oliver Endriss <o.endriss@gmx.de>,
	Michael Krufky <mkrufky@linuxtv.org>,
	linux-media@vger.kernel.org, linux-dvb@linuxtv.org,
	erik_bies@hotmail.com
Subject: Re: [linux-dvb] TechnoTrend C-1501 - Locking issues on 388Mhz
Message-ID: <20090328005859.044431a8@pedra.chehab.org>
In-Reply-To: <1238196235.6530.38.camel@pc07.localdom.local>
References: <7b41dd970903251353n46f55bbfg687c1cfa42c5b824@mail.gmail.com>
	<1238111503.4783.23.camel@pc07.localdom.local>
	<20090326210929.32235862@pedra.chehab.org>
	<1238114810.4783.32.camel@pc07.localdom.local>
	<20090326220225.72b122b2@pedra.chehab.org>
	<1238117947.4783.48.camel@pc07.localdom.local>
	<20090327073858.25d11327@pedra.chehab.org>
	<1238196235.6530.38.camel@pc07.localdom.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, 28 Mar 2009 00:23:55 +0100
hermann pitton <hermann-pitton@arcor.de> wrote:

> Hi,
> 
> Am Freitag, den 27.03.2009, 07:38 -0300 schrieb Mauro Carvalho Chehab:
> > On Fri, 27 Mar 2009 02:39:07 +0100
> > hermann pitton <hermann-pitton@arcor.de> wrote:
> > 
> > > But my main concern is, if it once arrived at patchwork formally, it is
> > > out of sight for most of us and might miss proper review, except you are
> > > sure you can always guarantee that. I don't want to start to argue about
> > > all what happened in the past.
> > > 
> > > So, at least, if some patch arrived there mysteriously ;), the
> > > linux-media list should be informed that it is there now and last time
> > > to speak off, in case anything is not fully clear, before vanishing into
> > > some black hole until you find it in the next kernel release ...
> > 
> > The only way to send patches to patchwork is to submit it via linux-media list.
> > There's no other way. So, all patch discussions and reviews should happen at
> > the ML, by replying at the patch email (or by replying another reply).
> > Patchwork will keep track of such replies as well.
> > 
> 
> What happened so far with this patches is quite funny,
> for me some black hole seems to be involved.
> 
> Klaas did send them the first time, also directly to me, on Tue, 24 Mar
> 2009 23:14:11 +0100.
> 
> Now I can see you have pulled them in already on Wednesday.
> http://linuxtv.org/hg/v4l-dvb/rev/5efa9fbc8a88
> 
> There is no trace anymore on patchwork visible to me.
> http://patchwork.kernel.org/project/linux-media/list
> So I don't know how you processed them.

The above link uses the default patchwork filtering. By default it shows only
patches where there's an action required (e. g. New or Under Review patches).

To view a full list of the patches, you need to click at filters and select any.

You'll see all patches:
	http://patchwork.kernel.org/project/linux-media/list/?state=*

In the specific case od Klaas, this is his patch:

http://patchwork.kernel.org/patch/14405/

> Most confusing is, that Klaas obviously did not receive a mail
> notification from linuxtv-commits that his patch came in.

> 
> Last message date: Fri Feb 15 19:45:02 CET 2008
> Archived on: Fri Feb 15 19:45:04 CET 2008 
> 
> Is it broken or only the archive not up to date?
> 

I've received the notification here:

From: Patch from klaas de waal  <hg-commit@linuxtv.org>
To: linuxtv-commits@linuxtv.org
Cc: , Mauro Carvalho Chehab <mchehab@redhat.com>, klaas de waal <klaas.de.waal@gmail.com>
Subject: [linuxtv-commits] [hg:v4l-dvb] tda827x: fix locking issues with DVB-C
Date: Fri, 27 Mar 2009 18:05:01 +0100
Reply-To: klaas de waal via Mercurial <klaas.de.waal@gmail.com>
Sender: linuxtv-commits-bounces@linuxtv.org

The patch number 11236 was added via Mauro Carvalho Chehab <mchehab@redhat.com>
to http://linuxtv.org/hg/v4l-dvb master development tree.

Klaas should be received this also. Maybe some anti-spam filtering on his side?

You'll probably see this also at the linuxtv-commits archives.

> Why else he would have posted a second time on
> Wed, 25 Mar 2009 21:53:02 +0100 not knowing anything about the status of
> his patches, which made me believe I should try to help him?
> 
> The timestamp on your mercurial commit of them is
> Wed Mar 25 20:53:02 2009 +0000 (2 days ago)
> That is the time when his second email arrived converted to Greenwich
> time? Or how could you commit within the same second that mail arrived?

> This is the time the patches have on both of his original mails.
> --- a/linux/drivers/media/common/tuners/tda827x.c Tue Mar 24 21:12:47 2009 +0000
> --- a/linux/drivers/media/common/tuners/tda827x.c Tue Mar 24 21:12:47 2009 +0000

The import scripts will try to preserve the original date of the sent email.

So, the date there is when the code were presented to public.

> How can I ever know when they were really added and if they went through
> patchwork :)
> 
> I was just about to suggest Klaas should try again with [PATCH] in the
> subject until they are listed at patchwork.

If the patch was received by patchwork, and "disappeared", all you need to do
is to click on filter and select a proper filter, like:

http://patchwork.kernel.org/project/linux-media/list/?submitter=klaas&state=*

This will present all patches authored by "klaas", and their state. Ah, if you
click on the patch, you'll see all the patch history, including the
sent/received emails. Even this email should be added there by patchwork ;)

Cheers,
Mauro
