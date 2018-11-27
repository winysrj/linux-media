Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:35318 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1730114AbeK0UUN (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 27 Nov 2018 15:20:13 -0500
Date: Tue, 27 Nov 2018 11:22:55 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Bingbu Cao <bingbu.cao@linux.intel.com>
Cc: Sakari Ailus <sakari.ailus@linux.intel.com>, bingbu.cao@intel.com,
        linux-media@vger.kernel.org, tfiga@chromium.org,
        rajmohan.mani@intel.com, mchehab+samsung@kernel.org,
        hverkuil@xs4all.nl
Subject: Re: [PATCH 2/2] media: imx355: fix wrong order in test pattern menus
Message-ID: <20181127092255.xaemioeftx45yi7p@valkosipuli.retiisi.org.uk>
References: <1543218214-10767-1-git-send-email-bingbu.cao@intel.com>
 <1543218214-10767-2-git-send-email-bingbu.cao@intel.com>
 <20181126085732.vupidoa2lozp5ndo@paasikivi.fi.intel.com>
 <1f9d131f-8b99-3118-5112-ace6ed1b3d0d@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1f9d131f-8b99-3118-5112-ace6ed1b3d0d@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Nov 27, 2018 at 10:45:02AM +0800, Bingbu Cao wrote:
> 
> 
> On 11/26/2018 04:57 PM, Sakari Ailus wrote:
> > Hi Bing Bu,
> > 
> > On Mon, Nov 26, 2018 at 03:43:34PM +0800, bingbu.cao@intel.com wrote:
> > > From: Bingbu Cao <bingbu.cao@intel.com>
> > > 
> > > current imx355 test pattern order in ctrl menu
> > > is not correct, this patch fixes it.
> > > 
> > > Signed-off-by: Bingbu Cao <bingbu.cao@intel.com>
> > > ---
> > >   drivers/media/i2c/imx355.c | 2 +-
> > >   1 file changed, 1 insertion(+), 1 deletion(-)
> > > 
> > > diff --git a/drivers/media/i2c/imx355.c b/drivers/media/i2c/imx355.c
> > > index 20c8eea5db4b..9c9559dfd3dd 100644
> > > --- a/drivers/media/i2c/imx355.c
> > > +++ b/drivers/media/i2c/imx355.c
> > > @@ -876,8 +876,8 @@ struct imx355 {
> > >   static const char * const imx355_test_pattern_menu[] = {
> > >   	"Disabled",
> > > -	"100% color bars",
> > >   	"Solid color",
> > > +	"100% color bars",
> > >   	"Fade to gray color bars",
> > >   	"PN9"
> > >   };
> > While at it, could you use the existing test pattern naming as well for the
> > drivers? That could be a separate patch.
> > 
> > >From drivers/media/i2c/smiapp/smiapp-core.c :
> > 
> > static const char * const smiapp_test_patterns[] = {
> > 	"Disabled",
> > 	"Solid Colour",
> >    	"Eight Vertical Colour Bars",
> > 	"Colour Bars With Fade to Grey",
> > 	"Pseudorandom Sequence (PN9)",
> > };
> > 
> > It's not strictly necessary from interface point of view, but for the user
> > space it'd be good to align the naming.
> Sakari, ask a question that not really related to this patch.
> I am wondering whether there are some standardization for the camera sensor
> pattern generator.
> Currently there are varied patterns and every vendor has its own pattern types.

Some vendors (and some models) do have their specific patterns, but if you
look at a bunch of drivers, these ones repeat over and over. That's why I
think it'd make sense to have the menu entries aligned.

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi
