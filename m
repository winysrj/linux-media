Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:36852 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1754844AbcHVOCe (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 22 Aug 2016 10:02:34 -0400
Date: Mon, 22 Aug 2016 17:02:31 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-media@vger.kernel.org, m.chehab@osg.samsung.com,
        shuahkh@osg.samsung.com, laurent.pinchart@ideasonboard.com
Subject: Re: [RFC v2 17/17] omap3isp: Don't rely on devm for memory resource
 management
Message-ID: <20160822140231.GE12130@valkosipuli.retiisi.org.uk>
References: <1471602228-30722-1-git-send-email-sakari.ailus@linux.intel.com>
 <1471602228-30722-18-git-send-email-sakari.ailus@linux.intel.com>
 <e0d07a7a-100f-9415-9b25-678d1a4101a1@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e0d07a7a-100f-9415-9b25-678d1a4101a1@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On Mon, Aug 22, 2016 at 02:40:39PM +0200, Hans Verkuil wrote:
> On 08/19/2016 12:23 PM, Sakari Ailus wrote:
> > devm functions are fine for managing resources that are directly related
> > to the device at hand and that have no other dependencies. However, a
> > process holding a file handle to a device created by a driver for a device
> > may result in the file handle left behind after the device is long gone.
> > This will result in accessing released (and potentially reallocated)
> > memory.
> > 
> > Instead, rely on the media device which will stick around until all users
> > are gone.
> > 
> > Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> > ---
> >  drivers/media/platform/omap3isp/isp.c         | 38 ++++++++++++++++++++-------
> >  drivers/media/platform/omap3isp/ispccp2.c     |  3 ++-
> >  drivers/media/platform/omap3isp/isph3a_aewb.c | 20 +++++++++-----
> >  drivers/media/platform/omap3isp/isph3a_af.c   | 20 +++++++++-----
> >  drivers/media/platform/omap3isp/isphist.c     |  5 ++--
> >  drivers/media/platform/omap3isp/ispstat.c     |  2 ++
> >  6 files changed, 63 insertions(+), 25 deletions(-)
> > 
> > diff --git a/drivers/media/platform/omap3isp/isp.c b/drivers/media/platform/omap3isp/isp.c
> > index 217d4da..3488ed3 100644
> > --- a/drivers/media/platform/omap3isp/isp.c
> > +++ b/drivers/media/platform/omap3isp/isp.c
> > @@ -1370,7 +1370,7 @@ static int isp_get_clocks(struct isp_device *isp)
> >  	unsigned int i;
> >  
> >  	for (i = 0; i < ARRAY_SIZE(isp_clocks); ++i) {
> > -		clk = devm_clk_get(isp->dev, isp_clocks[i]);
> 
> I wonder, would it be possible to use the media device itself for these devm_
> functions? Since the media device is the last one to be released...

Do you happen to mean... struct media_device->devnode.dev?

Interesting idea, I can't see why not. That'd actually make the required
driver changes to fix the drivers quite a bit easier to make. And we could
still use devm_() functions.

-- 
Regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
