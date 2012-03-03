Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:58089 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753762Ab2CCPNB (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 3 Mar 2012 10:13:01 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: linux-media@vger.kernel.org,
	Martin Hostettler <martin@neutronstar.dyndns.org>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: [PATCH v2 10/10] mt9m032: Use generic PLL setup code
Date: Sat, 03 Mar 2012 16:13:19 +0100
Message-ID: <1424226.qOeHxb5cja@avalon>
In-Reply-To: <20120302224126.GH15695@valkosipuli.localdomain>
References: <1330685047-12742-1-git-send-email-laurent.pinchart@ideasonboard.com> <1330685047-12742-11-git-send-email-laurent.pinchart@ideasonboard.com> <20120302224126.GH15695@valkosipuli.localdomain>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

Thanks for the review.

On Saturday 03 March 2012 00:41:26 Sakari Ailus wrote:
> On Fri, Mar 02, 2012 at 11:44:07AM +0100, Laurent Pinchart wrote:
> > Compute the PLL parameters at runtime using the generic Aptina PLL
> > helper.
> > 
> > Remove the PLL parameters from platform data and pass the external clock
> > and desired internal clock frequencies instead.
> > 
> > Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> > ---
> > 
> >  drivers/media/video/mt9m032.c |   61
> >  ++++++++++++++++++++++++++--------------- include/media/mt9m032.h      
> >  |    4 +--
> >  2 files changed, 40 insertions(+), 25 deletions(-)
> > 
> > diff --git a/drivers/media/video/mt9m032.c b/drivers/media/video/mt9m032.c
> > index 4cde779..45e8c68 100644
> > --- a/drivers/media/video/mt9m032.c
> > +++ b/drivers/media/video/mt9m032.c
> > @@ -35,6 +35,8 @@
> > 
> >  #include <media/v4l2-device.h>
> >  #include <media/v4l2-subdev.h>
> > 
> > +#include "aptina-pll.h"
> > +
> > 
> >  #define MT9M032_CHIP_VERSION			0x00
> >  #define     MT9M032_CHIP_VERSION_VALUE		0x1402
> >  #define MT9M032_ROW_START			0x01
> > 
> > @@ -61,6 +63,7 @@
> > 
> >  #define MT9M032_GAIN_BLUE			0x2c
> >  #define MT9M032_GAIN_RED			0x2d
> >  #define MT9M032_GAIN_GREEN2			0x2e
> > 
> > +
> > 
> >  /* write only */
> >  #define MT9M032_GAIN_ALL			0x35
> >  #define     MT9M032_GAIN_DIGITAL_MASK		0x7f
> > 
> > @@ -83,6 +86,8 @@
> > 
> >  #define     MT9P031_PLL_CONTROL_PWROFF		0x0050
> >  #define     MT9P031_PLL_CONTROL_PWRON		0x0051
> >  #define     MT9P031_PLL_CONTROL_USEPLL		0x0052
> > 
> > +#define MT9P031_PLL_CONFIG2			0x11
> > +#define     MT9P031_PLL_CONFIG2_P1_DIV_MASK	0x1f
> > 
> >  /*
> >  
> >   * width and height include active boundry and black parts
> > 
> > @@ -223,31 +228,43 @@ static int update_formatter2(struct mt9m032 *sensor,
> > bool streaming)> 
> >  static int mt9m032_setup_pll(struct mt9m032 *sensor)
> >  {
> >  
> >  	struct i2c_client *client = v4l2_get_subdevdata(&sensor->subdev);
> > 
> > -	struct mt9m032_platform_data* pdata = sensor->pdata;
> > -	u16 reg_pll1;
> > -	unsigned int pre_div;
> > +	struct mt9m032_platform_data *pdata = sensor->pdata;
> > +	struct aptina_pll_limits limits;
> > +	struct aptina_pll pll;
> > 
> >  	int ret;
> > 
> > -	/* TODO: also support other pre-div values */
> > -	if (pdata->pll_pre_div != 6) {
> > -		dev_warn(to_dev(sensor),
> > -			"Unsupported PLL pre-divisor value %u, using default 6\n",
> > -			pdata->pll_pre_div);
> > -	}
> > -	pre_div = 6;
> > -
> > -	sensor->pix_clock = pdata->ext_clock * pdata->pll_mul /
> > -		(pre_div * pdata->pll_out_div);
> > +	limits.ext_clock_min = 8000000;
> > +	limits.ext_clock_max = 16500000;
> > +	limits.int_clock_min = 2000000;
> > +	limits.int_clock_max = 24000000;
> > +	limits.out_clock_min = 322000000;
> > +	limits.out_clock_max = 693000000;
> > +	limits.pix_clock_max = 99000000;
> > +	limits.n_min = 1;
> > +	limits.n_max = 64;
> > +	limits.m_min = 16;
> > +	limits.m_max = 255;
> > +	limits.p1_min = 1;
> > +	limits.p1_max = 128;
> 
> You could make limits const and static.

Done.

> > +	pll.ext_clock = pdata->ext_clock;
> > +	pll.pix_clock = pdata->pix_clock;
> > +
> > +	ret = aptina_pll_configure(&client->dev, &pll, &limits);
> > +	if (ret < 0)
> > +		return ret;
> 
> Now that you're handling timing information in the sensor driver, including
> blanking --- AFAIU, what would you think about implementing the new sensor
> control interface for this one?

Sure, but in a further patch :-)

> > -	reg_pll1 = ((pdata->pll_out_div - 1) & 
MT9M032_PLL_CONFIG1_OUTDIV_MASK)
> > -		   | pdata->pll_mul << MT9M032_PLL_CONFIG1_MUL_SHIFT;
> > +	sensor->pix_clock = pll.pix_clock;
> > 
> > -	ret = mt9m032_write_reg(client, MT9M032_PLL_CONFIG1, reg_pll1);
> > +	ret = mt9m032_write_reg(client, MT9M032_PLL_CONFIG1,
> > +				(pll.m << MT9M032_PLL_CONFIG1_MUL_SHIFT)
> > +				| (pll.p1 - 1));
> > 
> >  	if (!ret)
> > 
> > -		ret = mt9m032_write_reg(client,
> > -					MT9P031_PLL_CONTROL,
> > -					MT9P031_PLL_CONTROL_PWRON | 
MT9P031_PLL_CONTROL_USEPLL);
> > -
> > +		ret = mt9m032_write_reg(client, MT9P031_PLL_CONFIG2, pll.n - 1);
> > +	if (!ret)
> > +		ret = mt9m032_write_reg(client, MT9P031_PLL_CONTROL,
> > +					MT9P031_PLL_CONTROL_PWRON |
> > +					MT9P031_PLL_CONTROL_USEPLL);
> > 
> >  	if (!ret)
> >  	
> >  		ret = mt9m032_write_reg(client, MT9M032_READ_MODE1, 0x8006);
> >  		
> >  							/* more reserved, Continuous */
> > 
> > diff --git a/include/media/mt9m032.h b/include/media/mt9m032.h
> > index 94cefc5..804e0a5 100644
> > --- a/include/media/mt9m032.h
> > +++ b/include/media/mt9m032.h
> > @@ -29,9 +29,7 @@
> > 
> >  struct mt9m032_platform_data {
> >  
> >  	u32 ext_clock;
> > 
> > -	u32 pll_pre_div;
> > -	u32 pll_mul;
> > -	u32 pll_out_div;
> > +	u32 pix_clock;
> > 
> >  	int invert_pixclock;
> >  
> >  };

-- 
Regards,

Laurent Pinchart

