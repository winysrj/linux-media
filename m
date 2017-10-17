Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:35748 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S934439AbdJQI02 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 17 Oct 2017 04:26:28 -0400
Date: Tue, 17 Oct 2017 11:26:25 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: "Tobin C. Harding" <me@tobin.cc>
Cc: Hans de Goede <hdegoede@redhat.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alan Cox <alan@linux.intel.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        devel@driverdev.osuosl.org, linux-media@vger.kernel.org
Subject: Re: [PATCH] stagin: atomisp: Fix oops by unbalanced clk
 enable/disable call
Message-ID: <20171017082624.e52z3vpx4wfrlp5o@valkosipuli.retiisi.org.uk>
References: <20171016123448.12014-1-hdegoede@redhat.com>
 <20171016211015.GL16106@eros>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171016211015.GL16106@eros>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Oct 17, 2017 at 08:10:15AM +1100, Tobin C. Harding wrote:
> On Mon, Oct 16, 2017 at 02:34:48PM +0200, Hans de Goede wrote:
> > diff --git a/drivers/staging/media/atomisp/platform/intel-mid/atomisp_gmin_platform.c b/drivers/staging/media/atomisp/platform/intel-mid/atomisp_gmin_platform.c
> > index 828fe5abd832..6671ebe4ecc9 100644
> > --- a/drivers/staging/media/atomisp/platform/intel-mid/atomisp_gmin_platform.c
> > +++ b/drivers/staging/media/atomisp/platform/intel-mid/atomisp_gmin_platform.c
> > @@ -29,6 +29,7 @@ struct gmin_subdev {
> >  	struct v4l2_subdev *subdev;
> >  	int clock_num;
> >  	int clock_src;
> > +	bool clock_on;
> >  	struct clk *pmc_clk;
> >  	struct gpio_desc *gpio0;
> >  	struct gpio_desc *gpio1;
> > @@ -583,6 +584,9 @@ static int gmin_flisclk_ctrl(struct v4l2_subdev *subdev, int on)
> >  	struct gmin_subdev *gs = find_gmin_subdev(subdev);
> >  	struct i2c_client *client = v4l2_get_subdevdata(subdev);
> >  
> > +	if (gs->clock_on == !!on)
> > +		return 0;
> > +
> >  	if (on) {
> >  		ret = clk_set_rate(gs->pmc_clk, gs->clock_src);
> 
> Which tree [and branch] are you working off please? In the staging-next branch of Greg's staging
> tree this function does not appear as it is in this patch.

Media tree master.

<URL:https://git.linuxtv.org/media_tree.git/log/>

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi
