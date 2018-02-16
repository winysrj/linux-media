Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:56310 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S965644AbeBPMEX (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 16 Feb 2018 07:04:23 -0500
Date: Fri, 16 Feb 2018 10:04:13 -0200
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Jacopo Mondi <jacopo+renesas@jmondi.org>,
        Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [PATCHv2 4/9] staging: atomisp: i2c: Disable non-preview
 configurations
Message-ID: <20180216100413.06c8ab1c@vento.lan>
In-Reply-To: <20180216101220.ncl7gda4xq2vzcqw@valkosipuli.retiisi.org.uk>
References: <20180122123125.24709-1-hverkuil@xs4all.nl>
        <20180122123125.24709-5-hverkuil@xs4all.nl>
        <20180214142050.2ef515ee@vento.lan>
        <20180216101220.ncl7gda4xq2vzcqw@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Fri, 16 Feb 2018 12:12:20 +0200
Sakari Ailus <sakari.ailus@iki.fi> escreveu:

> Hi Mauro,
> 
> On Wed, Feb 14, 2018 at 02:20:50PM -0200, Mauro Carvalho Chehab wrote:
> > Em Mon, 22 Jan 2018 13:31:20 +0100
> > Hans Verkuil <hverkuil@xs4all.nl> escreveu:
> >   
> > > From: Sakari Ailus <sakari.ailus@linux.intel.com>
> > > 
> > > Disable configurations for non-preview modes until configuration selection
> > > is improved.  
> > 
> > Again, a poor description. It just repeats the subject.
> > A good subject/description should answer 3 questions:
> > 
> > 	what?
> > 	why?
> > 	how?
> > 
> > Anyway, looking at this patch's contents, it partially answers my
> > questions:
> > 
> > the previous patch do cause regressions at the code.
> > 
> > Ok, this is staging. So, we don't have very strict rules here,
> > but still causing regressions without providing a very good
> > reason why sucks.
> > 
> > I would also merge this with the previous one, in order to place all
> > regressions on a single patch.  
> 
> It's trivial to bring back the configurations disabled here by just
> reverting this patch. The other patch does not disable any. That's why
> they're separate.

Yes, and I'm not saying otherwise.

The main issue here is that it lacks a description (as what's
there is just a copy of the subject).

Why is it needed to "disable non-preview configurations"?

Also, as you're actually commenting the code with #if 0, I'm assuming
that you're thinking on re-enable the code (or re-implement with a
different logic) in the future.

So, please add a note before the #if 0, as otherwise I'm pretty
sure someone will end by sending us patches just stripping it.

Regards,
Mauro
