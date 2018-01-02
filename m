Return-path: <linux-media-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:48937 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751685AbeABK1U (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 2 Jan 2018 05:27:20 -0500
Date: Tue, 2 Jan 2018 13:26:45 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Julia Lawall <julia.lawall@lip6.fr>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        kernel-janitors@vger.kernel.org, Alan Cox <alan@linux.intel.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-media@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org, Kristian Beilke <beilke@posteo.de>
Subject: Re: [PATCH v1 05/10] staging: atomisp: Remove non-ACPI leftovers
Message-ID: <20180102102644.km2lb65ehesphso7@mwanda>
References: <20171219205957.10933-1-andriy.shevchenko@linux.intel.com>
 <20171219205957.10933-5-andriy.shevchenko@linux.intel.com>
 <20171220053828.5wphhl6oc2sl3su5@mwanda>
 <alpine.DEB.2.20.1712201127240.13140@hadrien>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.20.1712201127240.13140@hadrien>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Dec 20, 2017 at 11:30:01AM +0100, Julia Lawall wrote:
> 
> 
> On Wed, 20 Dec 2017, Dan Carpenter wrote:
> 
> > On Tue, Dec 19, 2017 at 10:59:52PM +0200, Andy Shevchenko wrote:
> > > @@ -914,9 +904,7 @@ static int lm3554_probe(struct i2c_client *client)
> > >  		dev_err(&client->dev, "gpio request/direction_output fail");
> > >  		goto fail2;
> > >  	}
> > > -	if (ACPI_HANDLE(&client->dev))
> > > -		err = atomisp_register_i2c_module(&flash->sd, NULL, LED_FLASH);
> > > -	return 0;
> > > +	return atomisp_register_i2c_module(&flash->sd, NULL, LED_FLASH);
> > >  fail2:
> > >  	media_entity_cleanup(&flash->sd.entity);
> > >  	v4l2_ctrl_handler_free(&flash->ctrl_handler);
> >
> > Actually every place where we directly return a function call is wrong
> > and needs error handling added.  I've been meaning to write a Smatch
> > check for this because it's a common anti-pattern we don't check the
> > last function call for errors.
> >
> > Someone could probably do the same in Coccinelle if they want.
> 
> I'm not sure what you are suggesting.  Is every case of return f(...);
> for any f wrong?  Or is it a particular function that is of concern?  Or
> would it be that every function call that has error handling somewhere
> should have error handling everywhere?  Or is it related to what seems to
> be the problem in the above code that err is initialized but nothing
> happens to it?
> 

I was just thinking that it's a common pattern to treat the last
function call differently and one mistake I often see looks like this:

	ret = frob();
	if (ret) {
		cleanup();
		return ret;
	}

	return another_function();

No error handling for the last function call.

regards,
dan carpenter
