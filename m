Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:34952 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752655AbeBSMY1 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 19 Feb 2018 07:24:27 -0500
Date: Mon, 19 Feb 2018 14:24:24 +0200
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Sakari Ailus <sakari.ailus@iki.fi>,
        Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
        Jacopo Mondi <jacopo+renesas@jmondi.org>,
        Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [PATCHv2 4/9] staging: atomisp: i2c: Disable non-preview
 configurations
Message-ID: <20180219122423.cps5jzrdkb6t6uxx@paasikivi.fi.intel.com>
References: <20180122123125.24709-1-hverkuil@xs4all.nl>
 <20180122123125.24709-5-hverkuil@xs4all.nl>
 <20180214142050.2ef515ee@vento.lan>
 <20180216101220.ncl7gda4xq2vzcqw@valkosipuli.retiisi.org.uk>
 <20180216100413.06c8ab1c@vento.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180216100413.06c8ab1c@vento.lan>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

On Fri, Feb 16, 2018 at 10:04:13AM -0200, Mauro Carvalho Chehab wrote:
> Em Fri, 16 Feb 2018 12:12:20 +0200
> Sakari Ailus <sakari.ailus@iki.fi> escreveu:
> 
> > Hi Mauro,
> > 
> > On Wed, Feb 14, 2018 at 02:20:50PM -0200, Mauro Carvalho Chehab wrote:
> > > Em Mon, 22 Jan 2018 13:31:20 +0100
> > > Hans Verkuil <hverkuil@xs4all.nl> escreveu:
> > >   
> > > > From: Sakari Ailus <sakari.ailus@linux.intel.com>
> > > > 
> > > > Disable configurations for non-preview modes until configuration selection
> > > > is improved.  
> > > 
> > > Again, a poor description. It just repeats the subject.
> > > A good subject/description should answer 3 questions:
> > > 
> > > 	what?
> > > 	why?
> > > 	how?
> > > 
> > > Anyway, looking at this patch's contents, it partially answers my
> > > questions:
> > > 
> > > the previous patch do cause regressions at the code.
> > > 
> > > Ok, this is staging. So, we don't have very strict rules here,
> > > but still causing regressions without providing a very good
> > > reason why sucks.
> > > 
> > > I would also merge this with the previous one, in order to place all
> > > regressions on a single patch.  
> > 
> > It's trivial to bring back the configurations disabled here by just
> > reverting this patch. The other patch does not disable any. That's why
> > they're separate.
> 
> Yes, and I'm not saying otherwise.
> 
> The main issue here is that it lacks a description (as what's
> there is just a copy of the subject).
> 
> Why is it needed to "disable non-preview configurations"?
> 
> Also, as you're actually commenting the code with #if 0, I'm assuming
> that you're thinking on re-enable the code (or re-implement with a
> different logic) in the future.

Yes, that's the intention. This being atomisp, I don't want to invest a lot
of time on this until we know the driver has a future in the kernel.

> 
> So, please add a note before the #if 0, as otherwise I'm pretty
> sure someone will end by sending us patches just stripping it.

Good point. I'll respin the patch, with updated commit description and a
comment there.

-- 
Regards,

Sakari Ailus
sakari.ailus@linux.intel.com
