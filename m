Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:6565 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754488Ab1G2HKf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 29 Jul 2011 03:10:35 -0400
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
In-Reply-To: <201107281634.24288.laurent.pinchart@ideasonboard.com>
References: <20110727081522.GH32629@valkosipuli.localdomain>
	 <4db811899ccd7b5315080790a627974e3569c7cc.1311839940.git.andriy.shevchenko@linux.intel.com>
	 <201107281634.24288.laurent.pinchart@ideasonboard.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <1311923232.3903.45.camel@smile>
Mime-Version: 1.0
Subject: Re: [PATCHv2] adp1653: check error code of adp1653_init_controls
Date: Fri, 29 Jul 2011 10:10:03 +0300
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, 2011-07-28 at 16:34 +0200, Laurent Pinchart wrote: 
> > -	adp1653_init_controls(flash);
> > +	ret = adp1653_init_controls(flash);
> > +	if (ret)
> > +		goto free_and_quit;
> > 
> >  	ret = media_entity_init(&flash->subdev.entity, 0, NULL, 0);
> >  	if (ret < 0)
> > -		kfree(flash);
> > +		goto free_and_quit;
> > 
> > +	return 0;
> > +
> > +free_and_quit:
> > +	v4l2_ctrl_handler_free(&flash->ctrls);
> > +	kfree(flash);
> >  	return ret;

> What about
>         ret = adp1653_init_controls(flash);
>         if (ret)
>                 goto done;
> 
>         ret = media_entity_init(&flash->subdev.entity, 0, NULL, 0);
> 
> done:
>         if (ret < 0) {
>                 v4l2_ctrl_handler_free(&flash->ctrls);
>                 kfree(flash);
>         }
> 
>         return ret;
There is no difference at first glance. However, your variant is less
straight to understand for my opinion.

-- 
Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Intel Finland Oy
