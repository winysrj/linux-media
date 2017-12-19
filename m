Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:35212 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S933409AbdLSJLn (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 19 Dec 2017 04:11:43 -0500
Date: Tue, 19 Dec 2017 11:11:39 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Wenyou.Yang@microchip.com
Cc: mchehab@s-opensource.com, robh+dt@kernel.org, mark.rutland@arm.com,
        linux-kernel@vger.kernel.org, Nicolas.Ferre@microchip.com,
        devicetree@vger.kernel.org, corbet@lwn.net, hverkuil@xs4all.nl,
        linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org
Subject: Re: [PATCH v9 2/2] media: i2c: Add the ov7740 image sensor driver
Message-ID: <20171219091139.n2wmsj6ydcjntnf3@valkosipuli.retiisi.org.uk>
References: <20171211013146.2497-1-wenyou.yang@microchip.com>
 <20171211013146.2497-3-wenyou.yang@microchip.com>
 <1641aa67-b05e-47e2-600c-70b77571b450@iki.fi>
 <F9F4555C4E01D7469D37975B62D0EFBB8DDA56@CHN-SV-EXMX07.mchp-main.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <F9F4555C4E01D7469D37975B62D0EFBB8DDA56@CHN-SV-EXMX07.mchp-main.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Wenyou,

On Tue, Dec 19, 2017 at 02:11:28AM +0000, Wenyou.Yang@microchip.com wrote:
> Hi Sakari,
> 
> > -----Original Message-----
> > From: Sakari Ailus [mailto:sakari.ailus@iki.fi]
> > Sent: 2017年12月14日 4:06
> > To: Wenyou Yang - A41535 <Wenyou.Yang@microchip.com>; Mauro Carvalho
> > Chehab <mchehab@s-opensource.com>; Rob Herring <robh+dt@kernel.org>;
> > Mark Rutland <mark.rutland@arm.com>
> > Cc: linux-kernel@vger.kernel.org; Nicolas Ferre - M43238
> > <Nicolas.Ferre@microchip.com>; devicetree@vger.kernel.org; Jonathan Corbet
> > <corbet@lwn.net>; Hans Verkuil <hverkuil@xs4all.nl>; linux-arm-
> > kernel@lists.infradead.org; Linux Media Mailing List <linux-
> > media@vger.kernel.org>; Songjun Wu <songjun.wu@microchip.com>
> > Subject: Re: [PATCH v9 2/2] media: i2c: Add the ov7740 image sensor driver
> > 
> > Hi Wenyou,
> > 
> > Wenyou Yang wrote:
> > ...
> > > +static int ov7740_start_streaming(struct ov7740 *ov7740) {
> > > +	int ret;
> > > +
> > > +	if (ov7740->fmt) {
> > > +		ret = regmap_multi_reg_write(ov7740->regmap,
> > > +					     ov7740->fmt->regs,
> > > +					     ov7740->fmt->reg_num);
> > > +		if (ret)
> > > +			return ret;
> > > +	}
> > > +
> > > +	if (ov7740->frmsize) {
> > > +		ret = regmap_multi_reg_write(ov7740->regmap,
> > > +					     ov7740->frmsize->regs,
> > > +					     ov7740->frmsize->reg_num);
> > > +		if (ret)
> > > +			return ret;
> > > +	}
> > > +
> > > +	return __v4l2_ctrl_handler_setup(ov7740->subdev.ctrl_handler);
> > 
> > I believe you're still setting the controls after starting streaming.
> 
> Yes, it sees it does so.
> 
> The OV7740 sensor generates the stream pixel data at the constant frame
> rate, no such start or stop control.

That'd be odd but I guess hardware sometimes is. I'll apply the patches.

Thanks!

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi
