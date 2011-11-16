Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:15034 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755569Ab1KPKwa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 16 Nov 2011 05:52:30 -0500
Message-ID: <1321440745.30587.28.camel@smile>
Subject: Re: [PATCH 6/9] as3645a: free resources in case of error properly
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-media@vger.kernel.org,
	sakari.ailus@maxwell.research.nokia.com
Date: Wed, 16 Nov 2011 12:52:25 +0200
In-Reply-To: <201111161137.54083.laurent.pinchart@ideasonboard.com>
References: <1321374065-20063-3-git-send-email-laurent.pinchart@ideasonboard.com>
	 <cover.1321379276.git.andriy.shevchenko@linux.intel.com>
	 <20ff3c96498a0e9e0a1c1d09690fbbf6a59bee15.1321379276.git.andriy.shevchenko@linux.intel.com>
	 <201111161137.54083.laurent.pinchart@ideasonboard.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, 2011-11-16 at 11:37 +0100, Laurent Pinchart wrote: 
> > @@ -812,13 +814,12 @@ static int as3645a_probe(struct i2c_client *client,
> > 
> >  	flash->led_mode = V4L2_FLASH_LED_MODE_NONE;
> > 
> > -	ret = as3645a_init_controls(flash);
> > -	if (ret < 0) {
> > -		kfree(flash);
> > -		return ret;
> > -	}
> > -
> 
> Would you mind if I replace this code below
> 
> >  	return 0;
> > +
> > +free_and_quit:
> > +	v4l2_ctrl_handler_free(&flash->ctrls);
> > +	kfree(flash);
> > +	return ret;
> 
> with
> 
> done:
> 	if (ret < 0) {
> 		v4l2_ctrl_handler_free(&flash->ctrls);
> 		kfree(flash);
> 	}
> 
> 	return ret;
> 

I'm okay with it. However, I don't know if the compiler could optimize
double check here.


-- 
Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Intel Finland Oy
