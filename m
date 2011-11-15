Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:60277 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755643Ab1KOQz7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 15 Nov 2011 11:55:59 -0500
Message-ID: <1321376155.30587.23.camel@smile>
Subject: Re: [PATCH v2 2/2] as3645a: Add driver for LED flash controller
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>,
	linux-media@vger.kernel.org
Date: Tue, 15 Nov 2011 18:55:55 +0200
In-Reply-To: <201111151412.39333.laurent.pinchart@ideasonboard.com>
References: <1321229950-31451-1-git-send-email-laurent.pinchart@ideasonboard.com>
	 <1321229950-31451-3-git-send-email-laurent.pinchart@ideasonboard.com>
	 <4EC0E0C1.6090101@maxwell.research.nokia.com>
	 <201111151412.39333.laurent.pinchart@ideasonboard.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, 2011-11-15 at 14:12 +0100, Laurent Pinchart wrote:

> > > +struct as3645a {
> > > +	struct v4l2_subdev subdev;
> > > +	struct as3645a_platform_data *platform_data;
> > > +
> > > +	struct mutex power_lock;
> > > +	int power_count;
> > > +
> > > +	/* Static parameters */
> > > +	u8 vref;
> > > +	u8 peak;
> > > +
> > > +	/* Controls */
> > > +	struct v4l2_ctrl_handler ctrls;
> > > +
> > > +	enum v4l2_flash_led_mode led_mode;
> > > +	unsigned int timeout;
> > > +	u8 flash_current;
> > > +	u8 assist_current;
> > > +	u8 indicator_current;
> > > +	enum v4l2_flash_strobe_source strobe_source;
> > 
> > Do you think we should store this information in the controls instead,
> > or not?
> 
> I've been thinking about that as well. The reason why the control values were 
> copied to the as3645a structure is that they were accessed in timer context, 
> where taking the control lock wasn't possible.
> 
> I could switch to accessing the information in controls directly now, but that 
> would require storing pointers to the controls in the as3645a structure, which 
> might not be that better :-) And the code will need to change back to storing 
> values when overheat protection will be implemented anyway. If you still think 
> it's better, I can change it.
We don't need to solve the issue which is absent. We have in-kernel
adp1653 driver w/o overheat  protection. It requires to be updated
anyway. I prefer to update drivers in common way when we will have
overheat protection framework in place.

> > > +	switch (man) {
> > > +	case 1:
> > > +		factory = "AMS, Austria Micro Systems";
> > > +		break;
> > > +	case 2:
> > > +		factory = "ADI, Analog Devices Inc.";
> > > +		break;
> > > +	case 3:
> > > +		factory = "NSC, National Semiconductor";
> > > +		break;
> > > +	case 4:
> > > +		factory = "NXP";
> > > +		break;
> > > +	case 5:
> > > +		factory = "TI, Texas Instrument";
> > > +		break;
> > > +	default:
> > > +		factory = "Unknown";
> > > +	}
> > > +
> > > +	dev_dbg(&client->dev, "Factory: %s(%d) Version: %d\n", factory, man,
> > > +		version);
> > 
> > Is that really a factor or is it the chip vendor --- which might
> > contract another factory to actually manufacture the chips?
> 
> I don't know :-)
I guess the vendor is proper word here. For example, lm3555 (NSC) is
slightly different from as3645a.

And why dev_dbg? I think dev_info here might be suitable.

-- 
Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Intel Finland Oy
