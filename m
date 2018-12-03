Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga03.intel.com ([134.134.136.65]:52737 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725983AbeLCKZc (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 3 Dec 2018 05:25:32 -0500
Date: Mon, 3 Dec 2018 12:25:04 +0200
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: Bingbu Cao <bingbu.cao@linux.intel.com>
Cc: Tomasz Figa <tfiga@chromium.org>,
        Cao Bing Bu <bingbu.cao@intel.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        "Yeh, Andy" <andy.yeh@intel.com>
Subject: Re: [PATCH] media: unify some sony camera sensors pattern naming
Message-ID: <20181203102503.j5ts32pchn6jdsfk@paasikivi.fi.intel.com>
References: <1543291261-26174-1-git-send-email-bingbu.cao@intel.com>
 <CAAFQd5Dzk2AxMXA+QUFJ+LqRudVe6T6-tt2wY1q4Zpw2Hhhhrw@mail.gmail.com>
 <28de442c-5893-adc4-5801-c54f45a82849@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <28de442c-5893-adc4-5801-c54f45a82849@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Bing Bu, Tomasz,

On Mon, Dec 03, 2018 at 10:53:34AM +0800, Bingbu Cao wrote:
> 
> 
> On 12/01/2018 02:08 AM, Tomasz Figa wrote:
> > Hi Bingbu,
> > 
> > On Mon, Nov 26, 2018 at 7:56 PM <bingbu.cao@intel.com> wrote:
> > > From: Bingbu Cao <bingbu.cao@intel.com>
> > > 
> > > Some Sony camera sensors have same test pattern
> > > definitions, this patch unify the pattern naming
> > > to make it more clear to the userspace.
> > > 
> > > Suggested-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> > > Signed-off-by: Bingbu Cao <bingbu.cao@intel.com>
> > > ---
> > >   drivers/media/i2c/imx258.c | 8 ++++----
> > >   drivers/media/i2c/imx319.c | 8 ++++----
> > >   drivers/media/i2c/imx355.c | 8 ++++----
> > >   3 files changed, 12 insertions(+), 12 deletions(-)
> > > 
> > Thanks for the patch! One comment inline.
> > 
> > > diff --git a/drivers/media/i2c/imx258.c b/drivers/media/i2c/imx258.c
> > > index 31a1e2294843..a8a2880c6b4e 100644
> > > --- a/drivers/media/i2c/imx258.c
> > > +++ b/drivers/media/i2c/imx258.c
> > > @@ -504,10 +504,10 @@ struct imx258_mode {
> > > 
> > >   static const char * const imx258_test_pattern_menu[] = {
> > >          "Disabled",
> > > -       "Color Bars",
> > > -       "Solid Color",
> > > -       "Grey Color Bars",
> > > -       "PN9"
> > > +       "Solid Colour",
> > > +       "Eight Vertical Colour Bars",
> > Is it just me or "solid color" and "color bars" are being swapped
> > here? Did the driver had the names mixed up before or the order of
> > modes is different between these sensors?
> The test pattern value order of the 3 camera sensors should be same.
> All are:
> 0 - Disabled
> 1 - Solid Colour
> 2 - Eight Vertical Colour Bars
> ...
> 
> This patch swapped the first 2 item for imx258 (wrong order before) and use unified
> name for all 3 sensors.

I guess this isn't based on Jason's patch (now merged) that fixed the
issue. I'll rebase this; it's trivial.

commit 53f6f81da7db96557fe2bff9b15bd6b83d301f9f
Author: Chen, JasonX Z <jasonx.z.chen@intel.com>
Date:   Wed Nov 7 21:47:34 2018 -0500

    media: imx258: remove test pattern map from driver
    
    change bayer order when using test pattern mode.
    remove test pattern mapping method
    
    [Sakari Ailus: Drop extra added newline]
    
    Signed-off-by: Chen, JasonX Z <jasonx.z.chen@intel.com>
    Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
    Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>

-- 
Regards,

Sakari Ailus
sakari.ailus@linux.intel.com
