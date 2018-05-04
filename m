Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:54082 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751196AbeEDORk (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 4 May 2018 10:17:40 -0400
Date: Fri, 4 May 2018 11:17:30 -0300
From: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: Alan Cox <gnomes@lxorguk.ukuu.org.uk>, linux-media@vger.kernel.org,
        andriy.shevchenko@intel.com
Subject: Re: atomisp: drop from staging ?
Message-ID: <20180504111730.5ef8bdf8@vento.lan>
In-Reply-To: <20180503083049.nidmolfegklwnsqr@valkosipuli.retiisi.org.uk>
References: <20180429011837.68859797@alans-desktop>
        <20180430094100.rbppnbpw5pnuoth4@valkosipuli.retiisi.org.uk>
        <20180503083049.nidmolfegklwnsqr@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Thu, 3 May 2018 11:30:50 +0300
Sakari Ailus <sakari.ailus@iki.fi> escreveu:

> On Mon, Apr 30, 2018 at 12:41:00PM +0300, Sakari Ailus wrote:
> > Hi Alan,
> > 
> > On Sun, Apr 29, 2018 at 01:18:37AM +0100, Alan Cox wrote:  
> > > 
> > > I think this is going to be the best option. When I started cleaning up
> > > the atomisp code I had time to work on it. Then spectre/meltdown
> > > happened (which btw is why the updating suddenly and mysteriously stopped
> > > last summer).
> > > 
> > > I no longer have time to work on it and it's becoming evident that the
> > > world of speculative side channel is going to be mean that I am
> > > not going to get time in the forseeable future despite me trying to find
> > > space to get back into atomisp cleaning up. It sucks because we made some
> > > good initial progress but shit happens.
> > > 
> > > There are at this point (unsurprisngly ;)) no other volunteers I can
> > > find crazy enough to take this on.  
> > 
> > The driver has been in the staging tree for quite some time now and is a
> > regular target of cleanup patches but little has been done to address the
> > growing list of entries in the associated TODO file to get it out of
> > staging. Beyond this, I don't have the hardware but as far as I understand,
> > the driver is not functional in its current state.
> > 
> > I agree with removing the driver. It can always be brought back if someone
> > wishes to continue working it.
> > 
> > I can send patches to remove it.  
> 
> The patch didn't make it to the list likely because it was too big --- even
> with -D option to git format-patch!
> 
> It's here:
> 
> <URL:https://git.linuxtv.org/sailus/media_tree.git/log/?h=atomisp-no-more>

I really hate remove things like that, but atomisp is on real bad shape.
I'm wandering if at least the sensor drivers could be converted before
dropping it.

That's said, I don't have atomisp hardware either, and, even if I had,
I probably won't have enough time to fix it. So, if you all won't be
able to do any work on it any time soon, and that's what you want
for now, I'm ok with removing it.

Sakari,

Please send me a pull request with the driver removal patch and I'll
apply it.


Thanks,
Mauro
