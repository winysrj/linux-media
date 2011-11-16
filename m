Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:38057 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932140Ab1KPAhc (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 15 Nov 2011 19:37:32 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: Re: [PATCH v2 2/2] as3645a: Add driver for LED flash controller
Date: Wed, 16 Nov 2011 01:37:42 +0100
Cc: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>,
	linux-media@vger.kernel.org
References: <1321229950-31451-1-git-send-email-laurent.pinchart@ideasonboard.com> <201111151412.39333.laurent.pinchart@ideasonboard.com> <1321376155.30587.23.camel@smile>
In-Reply-To: <1321376155.30587.23.camel@smile>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201111160137.43212.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Andy,

On Tuesday 15 November 2011 17:55:55 Andy Shevchenko wrote:
> On Tue, 2011-11-15 at 14:12 +0100, Laurent Pinchart wrote:
> > > > +struct as3645a {
> > > > +	struct v4l2_subdev subdev;
> > > > +	struct as3645a_platform_data *platform_data;
> > > > +
> > > > +	struct mutex power_lock;
> > > > +	int power_count;
> > > > +
> > > > +	/* Static parameters */
> > > > +	u8 vref;
> > > > +	u8 peak;
> > > > +
> > > > +	/* Controls */
> > > > +	struct v4l2_ctrl_handler ctrls;
> > > > +
> > > > +	enum v4l2_flash_led_mode led_mode;
> > > > +	unsigned int timeout;
> > > > +	u8 flash_current;
> > > > +	u8 assist_current;
> > > > +	u8 indicator_current;
> > > > +	enum v4l2_flash_strobe_source strobe_source;
> > > 
> > > Do you think we should store this information in the controls instead,
> > > or not?
> > 
> > I've been thinking about that as well. The reason why the control values
> > were copied to the as3645a structure is that they were accessed in timer
> > context, where taking the control lock wasn't possible.
> > 
> > I could switch to accessing the information in controls directly now, but
> > that would require storing pointers to the controls in the as3645a
> > structure, which might not be that better :-) And the code will need to
> > change back to storing values when overheat protection will be
> > implemented anyway. If you still think it's better, I can change it.
> 
> We don't need to solve the issue which is absent. We have in-kernel
> adp1653 driver w/o overheat  protection. It requires to be updated
> anyway. I prefer to update drivers in common way when we will have
> overheat protection framework in place.

I'm fine with both solutions. This part of the code works correctly and is not 
particularly dirty in my opinion.

> > > > +	switch (man) {
> > > > +	case 1:
> > > > +		factory = "AMS, Austria Micro Systems";
> > > > +		break;
> > > > +	case 2:
> > > > +		factory = "ADI, Analog Devices Inc.";
> > > > +		break;
> > > > +	case 3:
> > > > +		factory = "NSC, National Semiconductor";
> > > > +		break;
> > > > +	case 4:
> > > > +		factory = "NXP";
> > > > +		break;
> > > > +	case 5:
> > > > +		factory = "TI, Texas Instrument";
> > > > +		break;
> > > > +	default:
> > > > +		factory = "Unknown";
> > > > +	}
> > > > +
> > > > +	dev_dbg(&client->dev, "Factory: %s(%d) Version: %d\n", factory,
> > > > man, +		version);
> > > 
> > > Is that really a factor or is it the chip vendor --- which might
> > > contract another factory to actually manufacture the chips?
> > 
> > I don't know :-)
> 
> I guess the vendor is proper word here. For example, lm3555 (NSC) is
> slightly different from as3645a.

OK, I'll fix that.

> And why dev_dbg? I think dev_info here might be suitable.

I agree, I'll fix that as well.

-- 
Regards,

Laurent Pinchart
