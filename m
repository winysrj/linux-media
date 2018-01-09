Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga05.intel.com ([192.55.52.43]:27169 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751294AbeAIWuv (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 9 Jan 2018 17:50:51 -0500
Date: Wed, 10 Jan 2018 00:50:45 +0200
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: Alan Cox <gnomes@lxorguk.ukuu.org.uk>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Alan Cox <alan@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: Re: [PATCH 2/2] media: staging: atomisp: cleanup whitespaces
Message-ID: <20180109225044.tk5tt2gwzmhbosee@kekkonen.localdomain>
References: <96780202f1f7ffe13f6e0426394c8c93a2cbaa77.1515091119.git.mchehab@s-opensource.com>
 <ab42c265e347855bb95809ef03e043653ab84a21.1515091119.git.mchehab@s-opensource.com>
 <20180108142121.wsinvtmhngokhpp7@paasikivi.fi.intel.com>
 <20180108142639.5ac53fe1@alans-desktop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180108142639.5ac53fe1@alans-desktop>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Alan,

On Mon, Jan 08, 2018 at 02:26:39PM +0000, Alan Cox wrote:
> On Mon, 8 Jan 2018 16:21:21 +0200
> Sakari Ailus <sakari.ailus@linux.intel.com> wrote:
> 
> > Hi Mauro,
> > 
> > On Thu, Jan 04, 2018 at 02:44:41PM -0500, Mauro Carvalho Chehab wrote:
> > > There are lots of bad whitespaces at atomisp driver.
> > > 
> > > Fix them.
> > > 
> > > Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
> > > ---
> > > 
> > > Sakari/Alan,
> > > 
> > > This is a script-generated patch that can be re-generated anytime.
> > > If you prefer to not touch on it now, i'm perfectly fine.
> > > 
> > > I'm sending it just as completeness, as I'm doing a similar
> > > cleanup under drivers/media, where  a number of <TAB><SPACE>
> > > sequences accumulated over the time.   
> > 
> > Thanks for the patch.
> > 
> > In principle this is a worthwhile patch; I'd postpone it for the time being
> > though: I understand that a few people are bisecting and / or applying
> > out-of-tree patches to the driver to debug it on a few different hardware
> > platforms. Let's wait until that work is done, and then apply this.
> 
> Given the kind of debug going on and the amount of time it's taking (plus
> AtomISP for reasons people now know got mostly dropped from my work queue
> since June) I'm happy if they get applied.
> 
> Can we apply the core ISP2401 merge from Vincent first though ?

I'm not sure which patches do you mean here --- there are no recent atomisp
patches from Vincent I'm aware of.

-- 
Regards,

Sakari Ailus
sakari.ailus@linux.intel.com
