Return-path: <linux-media-owner@vger.kernel.org>
Received: from web110806.mail.gq1.yahoo.com ([67.195.13.229]:24505 "HELO
	web110806.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1758989AbZASNCK (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 19 Jan 2009 08:02:10 -0500
Date: Mon, 19 Jan 2009 05:02:09 -0800 (PST)
From: Uri Shkolnik <urishk@yahoo.com>
Reply-To: urishk@yahoo.com
Subject: Re: Siano's patches
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: Michael Krufky <mkrufky@linuxtv.org>, linux-media@vger.kernel.org,
	linuxtv-commits@linuxtv.org, linux-dvb <linux-dvb@linuxtv.org>
In-Reply-To: <20090119092923.7a9b808a@pedra.chehab.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <244108.33255.qm@web110806.mail.gq1.yahoo.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>




--- On Mon, 1/19/09, Mauro Carvalho Chehab <mchehab@infradead.org> wrote:

> From: Mauro Carvalho Chehab <mchehab@infradead.org>
> Subject: Re: Siano's patches
> To: urishk@yahoo.com
> Cc: "Michael Krufky" <mkrufky@linuxtv.org>, linux-media@vger.kernel.org, linuxtv-commits@linuxtv.org, "linux-dvb" <linux-dvb@linuxtv.org>
> Date: Monday, January 19, 2009, 1:29 PM
> Hi Uri,
> 
> On Sun, 18 Jan 2009 10:37:32 -0800 (PST)
> Uri Shkolnik <urishk@yahoo.com> wrote:
> 
> > > From: Michael Krufky <mkrufky@linuxtv.org>
> > > Subject: Re: Siano's patches
> > > To: urishk@yahoo.com
> > > Cc: "Mauro Carvalho"
> <mchehab@infradead.org>, linux-media@vger.kernel.org,
> linuxtv-commits@linuxtv.org, "linux-dvb"
> <linux-dvb@linuxtv.org>
> > > Date: Sunday, January 18, 2009, 8:07 PM
> > > Uri Shkolnik wrote:
> > > > Hi Mauro,
> > > > 
> > > > Hope you had a great weekend :-)
> 
> Yes, I had ;)
> 
> > > > 
> > > > 
> > > > I would like to know if you have already
> reached the
> > > conclusion whether to use the Mercurial tree
> option or the
> > > email option we discussed last week.   
> > > > Regarding the patches that have been already
> submitted
> > > to the linux-media@vger.kernel.org ML, any
> schedule for the
> > > merge?   
> > > Uri,
> > > 
> > > I've already responded to your last email --
> You should
> > > continue to submit patches to the mailing list.
> > 
> > Mauro suggested two options, I asked for the first
> (the Mercurial tree) which is more convenient for me. As it
> used by multiple parties here and if there is no objection
> based on some unknown (to me) reason, I would like to use
> that option.
> > 
> > 
> > > 
> > > As for your pending patches, I explained in my
> email that
> > > they are in my queue.  I am in the midst of
> reviewing the
> > > changes.  As you're already aware, your
> changes break
> > > the Hauppauge device's functionality.  After
> merging
> > > your changes, I will have to go back and
> re-implement the
> > > Hauppauge-specific changes in the driver, using
> the new
> > > methods in your pending patches.
> > > 
> > 
> > Some of the patches in the list are pending from early
> September, 2008.
> > ( I think it's time they will be popped out of the
> queue.... :-)
> > 
> > Regarding restoring, modifying, enhancing, etc. -
> Please do it successively, submitting my patches and your
> after them, so (1) the congruity between the Mercurial DVB
> tree change-sets and Siano's change-set will be kept,
> and (2) I, and other reviewers, may review your
> patches/changes in their own change-sets.
> > 
> > 
> > > Once I have reviewed & merged your changes
> and after I
> > > can restore the proper functionality to the
> hauppauge
> > > devices, then I will post a new mercurial tree
> for testing
> > > against all siano-based devices.
> > > 
> > 
> > Please see above
> > 
> > > Please be patient -- this takes time.
> 
> Since the current Siano implementation is needed by some
> existing cards and
> that, from what I understood from your request and Michael
> comments, those
> patches could cause some regressions with the supported
> boards, we should wait
> for Michael's reviews and tests, if this doesn't
> take that long.
> 
> Uri, I'm assuming that you're familiar with kernel
> development. If not, I
> recommend you to read README.patches and the related docs
> at kernel's
> Documentation tree. If you have any doubts about that,
> we're here to answer.
> 
> Those patches are late for kernel 2.6.29, since the merge
> window for that
> kernel were already closed. So, we will have some time
> until the next open
> window opens (we should have at least 5 weeks). This allows
> us to do a better
> review the changesets to be sure that:
> 	they don't cause any regressions;
> 	they don't violate the DVB API;
> 	they don't create undocumented userspace API's;
> 	they are using the best development practices on kernel
> development;
> 	individual patches don't break compilation (to avoid
> breaking git bissect).
> 
> For a large changeset like Siano ones, such reviews take
> time.
> 
> Ah, next time, please number your changesets with something
> like [PATCH 01/xx].
> This helps me to properly identify and honour the correct
> patch order.
> 
> Cheers,
> Mauro

Hi Mauro,

Thanks for your detailed response.
Some comments and remarks -

Please note that the vast majority of the added (new files) code is SDIO and SPI bus interfaces, (and also big endian support). I don't know anyone reading this ML (Mike is included), who has the tools to test this code, which has been tested thoroughly. However, comments about coding style and kernel-coding related remarks are most welcome (I already submitted a patch for review to fix some endianity issue Trent Piepho commented about).
Please note that the SDIO patches has been written by none other than Pierre Ossman, who is the Linux kernel MMC maintainer (who wrote this code back in August 2008).

Siano has some dozens of commercial Linux-based customers using the discussed sources. Those customers have their own QA engineers additionally to Siano internal QA team (which includes dedicated engineer for this task). Some of those companies products are already in the market (production level). 

Second note, regarding regressions - the current code in the Mercurial tree includes code that Mike added without any review, which manipulate the chip-set's general purpose I/O. This code includes logical errors that causes boards with different layouts than Mike's to either deteriorate in performances (reception quality) or to stop functioning altogether. This issue got "blocker" status on my issues' list (the most severe type on my scale) and it prevents the various companies and individuals to use the Mercurial (and the kernel git) as a reliable source for Linux TV.

I am fully aware that Mike need to add/modify some code in order to support current/additional HPG cards (boards). All those modification are (1) Related to single source file (sms-cards.c) and (2) Can and should be done *after* submitting Siano's patches. (3) Pass a review, like any other patch, *before* submitting them to the main Mercurial tree.

Regarding "violate the DVB API" & "don't create undocumented userspace API's" - I guess you refers to the 'Siano Sub-system'. Well, .... this subject has been discussed a lot, and I don't mind at all to give it another round of discussions... 

DVB v3 never supported CMMB, T-DMB, ISDB-T and some other MDTV standards. DVB v5/S2 yet to support them. 
Those standards are used by ~2 Billion people. (yep, only little countries like Japan, China, S. Korea, Brazil, the entire Middle East and the Arab peninsula and "very few" others countries use these standards).... :-))))

Siano added some kernel support (tiny sub system) and user-space library.
The kernel code is of course GPLv2. 
*Everything* is available to *all*, include detailed documentation. You can see on the ML some recent posts about it (people who use it to get DAB streams with very little effort).

I strongly support any effort (and will help it myself) to have a single, unified, all-in-one API that will support all DTV standards. But we are not there, we are not even close :-(((

Until that time, when such generic, all-inclusive API will be introduced, we still have to support those "negligible" ~2 Billion people with some kind of additional API, *only* for those unsupported DTV standards.

Best regard,

Uri


      
