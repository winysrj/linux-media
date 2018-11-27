Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:31459 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729387AbeK0UFy (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 27 Nov 2018 15:05:54 -0500
Date: Tue, 27 Nov 2018 11:08:38 +0200
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: Luca Ceresoli <luca@lucaceresoli.net>
Cc: bingbu.cao@intel.com, linux-media@vger.kernel.org,
        tfiga@chromium.org, andy.yeh@intel.com, bingbu.cao@linux.intel.com
Subject: Re: [PATCH] media: unify some sony camera sensors pattern naming
Message-ID: <20181127090838.gxtb7ljxxd5sr4ko@paasikivi.fi.intel.com>
References: <1543291261-26174-1-git-send-email-bingbu.cao@intel.com>
 <9f1be8b6-8736-e204-5e79-89f4c07becba@lucaceresoli.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9f1be8b6-8736-e204-5e79-89f4c07becba@lucaceresoli.net>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Luca,

On Tue, Nov 27, 2018 at 09:05:34AM +0100, Luca Ceresoli wrote:
> Hi Bingbu,
> 
> On 27/11/18 05:01, bingbu.cao@intel.com wrote:
> > From: Bingbu Cao <bingbu.cao@intel.com>
> > 
> > Some Sony camera sensors have same test pattern
> > definitions, this patch unify the pattern naming
> > to make it more clear to the userspace.
> > 
> > Suggested-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> > Signed-off-by: Bingbu Cao <bingbu.cao@intel.com>
> > ---
> >  drivers/media/i2c/imx258.c | 8 ++++----
> >  drivers/media/i2c/imx319.c | 8 ++++----
> >  drivers/media/i2c/imx355.c | 8 ++++----
> >  3 files changed, 12 insertions(+), 12 deletions(-)
> > 
> > diff --git a/drivers/media/i2c/imx258.c b/drivers/media/i2c/imx258.c
> > index 31a1e2294843..a8a2880c6b4e 100644
> > --- a/drivers/media/i2c/imx258.c
> > +++ b/drivers/media/i2c/imx258.c
> > @@ -504,10 +504,10 @@ struct imx258_mode {
> >  
> >  static const char * const imx258_test_pattern_menu[] = {
> >  	"Disabled",
> > -	"Color Bars",
> > -	"Solid Color",
> > -	"Grey Color Bars",
> > -	"PN9"
> > +	"Solid Colour",
> > +	"Eight Vertical Colour Bars",
> > +	"Colour Bars With Fade to Grey",
> > +	"Pseudorandom Sequence (PN9)",
> 
> I had a look at imx274, it has many more values but definitely some
> could be unified too.
> 
> However I noticed something strange in that driver: The "Horizontal
> Color Bars" pattern has vertical bars, side-by-side, as in ||||.
> "Vertical Color Bars" are one on top of the other, as in ==. Is it just
> me crazy, or are they swapped?
> 
> Only one minor nitpick about your patch. The USA spelling "color" seems
> a lot more frequent in the kernel sources than the UK "colour", so it's
> probably better to be consistent.

This has been around for some seven or so years in the smiapp driver, and
changing strings in uAPI isn't something we prefer to do in general.

I wonder what others think.

If that's changed, it should be a separate patch.

-- 
Sakari Ailus
sakari.ailus@linux.intel.com
