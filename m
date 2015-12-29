Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:36636 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753166AbbL2Hcq (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 29 Dec 2015 02:32:46 -0500
Date: Tue, 29 Dec 2015 05:32:35 -0200
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Greg KH <greg@kroah.com>
Cc: Andrey Utkin <andrey.utkin@corp.bluecherry.net>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	kernel-janitors <kernel-janitors@vger.kernel.org>,
	"kernel-mentors@selenic.com" <kernel-mentors@selenic.com>,
	Linux Media <linux-media@vger.kernel.org>,
	devel@driverdev.osuosl.org, andrey.od.utkin@gmail.com
Subject: Re: On Lindent shortcomings and massive style fixing
Message-ID: <20151229053235.1d2ccb9c@recife.lan>
In-Reply-To: <20151228153332.GA6159@kroah.com>
References: <CAM_ZknVmAnoa=+BA9Q+BSJ_dKwtBWWXHqZyJ_BH=FppqGLpFUg@mail.gmail.com>
	<20151228153332.GA6159@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Mon, 28 Dec 2015 07:33:32 -0800
Greg KH <greg@kroah.com> escreveu:

> On Mon, Dec 28, 2015 at 04:33:27PM +0200, Andrey Utkin wrote:
> > After some iterations of checkpatch.pl, on a new developed driver
> > (tw5864), now I have the following:
> > 
> >  $ grep 'WARNING\|ERROR' /src/checkpatch.tw5864 | sort | uniq -c
> >      31 ERROR: do not use C99 // comments
> >     147 WARNING: Block comments use a trailing */ on a separate line
> >     144 WARNING: Block comments use * on subsequent lines
> >     435 WARNING: line over 80 characters
> > 
> > At this point, Lindent was already used, and checkpatch.pl warnings
> > introduced by Lindent itself were fixed. Usage of "indent
> > --linux-style" (which behaves differently BTW) doesn't help anymore,
> > too.
> > 
> > Could anybody please advise how to sort out these issues
> > automatically, because they look like perfectly solvable in automated
> > fashion. Of course manual work would result in more niceness, but I am
> > not eager to go through hundreds of place of code just to fix "over 80
> > characters" issues now.
> 
> Shouldn't take very long to do so, all of the above can be fixed in less
> than a day's worth of work manually.  Or you can use indent to fix up
> the line length issues, but watch out for the results, sometimes it's
> better to refactor the code than to just blindly accept the output of
> that tool.

Yeah, on my experience, letting indent to break long lines end do be
a disaster with require more time to manually fix the driver, than using
some editor that shows the 80 cols break (like kate) and fix the lines
manually. IMHO, there are two problems by letting indent breaking long
lines:

1) indent would break strings on printks. This is something that we don't
want to break strings on multiple lines in the Kernel;

2) It doesn't actually solve the problem of having too complex loops,
with is why the 80 columns warning is meant to warn. Worse than that,
if a piece of code is inside more than 4 or 5 indentation levels, the
resulting code of using indent for 80-cols line break is a total crap.

That's said, on a quick look at the driver, it seems that the 80-cols
violations are mostly (if not all) on the comments, like:

	int i_poc_lsb = (frame_seqno_in_gop << 1); /* why multiplied by two? TODO try without multiplication */

and

#define TW5864_UNDEF_REG_0x0224 0x0224	/* Undeclared in spec (or not yet added to tw5864-reg.h) but used */
#define TW5864_UNDEF_REG_0x4014 0x4014	/* Undeclared in spec (or not yet added to tw5864-reg.h) but used */
#define TW5864_UNDEF_REG_0xA800 0xA800	/* Undeclared in spec (or not yet added to tw5864-reg.h) but used */

Btw, the content of tw5864-reg-undefined.h is weird... Why not just
add the stuff there at tw5864-reg.h and remove the comments for all
defines there?

Also, Lindent already did some crappy 80-cols like breaks, like:

static int pci_i2c_multi_read(struct tw5864_dev *dev, u8 devid, u8 devfn, u8 *buf,
		       u32 count)

(count is misaligned with the open parenthesis)

and:
		val =
		    (1 << 24) + ((devid & 0xfe) << 16) + (buf[i * 2 + 0] << 8) +
		    buf[i * 2 + 1];

Regards,
Mauro
