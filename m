Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:58532 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753934AbZASL3w (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 19 Jan 2009 06:29:52 -0500
Date: Mon, 19 Jan 2009 09:29:23 -0200
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: urishk@yahoo.com
Cc: Michael Krufky <mkrufky@linuxtv.org>, linux-media@vger.kernel.org,
	linuxtv-commits@linuxtv.org, linux-dvb <linux-dvb@linuxtv.org>
Subject: Re: Siano's patches
Message-ID: <20090119092923.7a9b808a@pedra.chehab.org>
In-Reply-To: <986893.55175.qm@web110808.mail.gq1.yahoo.com>
References: <49736FE6.9080309@linuxtv.org>
	<986893.55175.qm@web110808.mail.gq1.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Uri,

On Sun, 18 Jan 2009 10:37:32 -0800 (PST)
Uri Shkolnik <urishk@yahoo.com> wrote:

> > From: Michael Krufky <mkrufky@linuxtv.org>
> > Subject: Re: Siano's patches
> > To: urishk@yahoo.com
> > Cc: "Mauro Carvalho" <mchehab@infradead.org>, linux-media@vger.kernel.org, linuxtv-commits@linuxtv.org, "linux-dvb" <linux-dvb@linuxtv.org>
> > Date: Sunday, January 18, 2009, 8:07 PM
> > Uri Shkolnik wrote:
> > > Hi Mauro,
> > > 
> > > Hope you had a great weekend :-)

Yes, I had ;)

> > > 
> > > 
> > > I would like to know if you have already reached the
> > conclusion whether to use the Mercurial tree option or the
> > email option we discussed last week.   
> > > Regarding the patches that have been already submitted
> > to the linux-media@vger.kernel.org ML, any schedule for the
> > merge?   
> > Uri,
> > 
> > I've already responded to your last email -- You should
> > continue to submit patches to the mailing list.
> 
> Mauro suggested two options, I asked for the first (the Mercurial tree) which is more convenient for me. As it used by multiple parties here and if there is no objection based on some unknown (to me) reason, I would like to use that option.
> 
> 
> > 
> > As for your pending patches, I explained in my email that
> > they are in my queue.  I am in the midst of reviewing the
> > changes.  As you're already aware, your changes break
> > the Hauppauge device's functionality.  After merging
> > your changes, I will have to go back and re-implement the
> > Hauppauge-specific changes in the driver, using the new
> > methods in your pending patches.
> > 
> 
> Some of the patches in the list are pending from early September, 2008.
> ( I think it's time they will be popped out of the queue.... :-)
> 
> Regarding restoring, modifying, enhancing, etc. - Please do it successively, submitting my patches and your after them, so (1) the congruity between the Mercurial DVB tree change-sets and Siano's change-set will be kept, and (2) I, and other reviewers, may review your patches/changes in their own change-sets.
> 
> 
> > Once I have reviewed & merged your changes and after I
> > can restore the proper functionality to the hauppauge
> > devices, then I will post a new mercurial tree for testing
> > against all siano-based devices.
> > 
> 
> Please see above
> 
> > Please be patient -- this takes time.

Since the current Siano implementation is needed by some existing cards and
that, from what I understood from your request and Michael comments, those
patches could cause some regressions with the supported boards, we should wait
for Michael's reviews and tests, if this doesn't take that long.

Uri, I'm assuming that you're familiar with kernel development. If not, I
recommend you to read README.patches and the related docs at kernel's
Documentation tree. If you have any doubts about that, we're here to answer.

Those patches are late for kernel 2.6.29, since the merge window for that
kernel were already closed. So, we will have some time until the next open
window opens (we should have at least 5 weeks). This allows us to do a better
review the changesets to be sure that:
	they don't cause any regressions;
	they don't violate the DVB API;
	they don't create undocumented userspace API's;
	they are using the best development practices on kernel development;
	individual patches don't break compilation (to avoid breaking git bissect).

For a large changeset like Siano ones, such reviews take time.

Ah, next time, please number your changesets with something like [PATCH 01/xx].
This helps me to properly identify and honour the correct patch order.

Cheers,
Mauro
