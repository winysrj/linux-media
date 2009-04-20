Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:36640 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755754AbZDTUr2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 20 Apr 2009 16:47:28 -0400
Date: Mon, 20 Apr 2009 17:47:19 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Laurent Pinchart <laurent.pinchart@skynet.be>
Cc: Alexey Klimov <klimov.linux@gmail.com>,
	linux-media@vger.kernel.org, Hans Verkuil <hverkuil@xs4all.nl>
Subject: Re: [patch review] uvc_driver: fix compile warning
Message-ID: <20090420174719.3018143f@pedra.chehab.org>
In-Reply-To: <200904202212.47382.laurent.pinchart@skynet.be>
References: <1240171389.12537.3.camel@tux.localhost>
	<200904201925.00656.laurent.pinchart@skynet.be>
	<20090420145031.2ffd860a@pedra.chehab.org>
	<200904202212.47382.laurent.pinchart@skynet.be>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, 20 Apr 2009 22:12:47 +0200
Laurent Pinchart <laurent.pinchart@skynet.be> wrote:

> Hi Mauro,
> 
> On Monday 20 April 2009 19:50:31 Mauro Carvalho Chehab wrote:
> > On Mon, 20 Apr 2009 19:25:00 +0200
> >
> > Laurent Pinchart <laurent.pinchart@skynet.be> wrote:
> > > Hi Alexey,
> > >
> > > On Sunday 19 April 2009 22:03:09 Alexey Klimov wrote:
> > > > Hello, all
> > > > I saw warnings in v4l-dvb daily build.
> > > > May this patch be helpful?
> > >
> > > I can't reproduce the problem with gcc 4.3.2.
> > >
> > > Hans, what's the policy for fixing gcc-related issues ? Should the code
> > > use uninitialized_var() to make every gcc version happy, or can ignore
> > > the warnings when a newer gcc version fixes the problem
> >
> > Laurent,
> >
> > The kernel way is to use unitialized_var() on such cases.
> >
> > Personally, I don't like very much this approach, since it will get rid
> > forever of such error for that var. However, a future patch could make that
> > var truly uninitialized. So, an extra care should be taken on every patch
> > touching a var that uses uninitialized_var() macro.
> >
> > From my side, I accept patches with both ways to fix it.
> 
> I wasn't talking about ' = 0' vs. 'uninitialized_var()', but rather about 
> submitting a patch vs. considering the problem fixed because gcc 4.3.2 doesn't 
> spit a warning while gcc 4.3.1 does.

Since 4.3.1 is a supported gcc version, it is better to fix the warning for it.

Cheers,
Mauro
