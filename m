Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:46542 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1753219AbdHIPhC (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 9 Aug 2017 11:37:02 -0400
Date: Wed, 9 Aug 2017 18:36:59 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Rui Miguel Silva <rmfrfs@gmail.com>
Cc: Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-media@vger.kernel.org, linux-leds@vger.kernel.org,
        jacek.anaszewski@gmail.com, laurent.pinchart@ideasonboard.com,
        Johan Hovold <johan@kernel.org>, Alex Elder <elder@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        greybus-dev@lists.linaro.org, devel@driverdev.osuosl.org,
        viresh.kumar@linaro.org
Subject: Re: [PATCH v2 1/3] staging: greybus: light: fix memory leak in v4l2
 register
Message-ID: <20170809153658.qa4g27q2dbpjt5hj@valkosipuli.retiisi.org.uk>
References: <20170809111555.30147-1-sakari.ailus@linux.intel.com>
 <20170809111555.30147-2-sakari.ailus@linux.intel.com>
 <20170809132002.GA10002@arch-late.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170809132002.GA10002@arch-late.localdomain>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Rui,

On Wed, Aug 09, 2017 at 02:20:02PM +0100, Rui Miguel Silva wrote:
> Hi Sakari,
> On Wed, Aug 09, 2017 at 02:15:53PM +0300, Sakari Ailus wrote:
> > From: Rui Miguel Silva <rmfrfs@gmail.com>
> > 
> > We are allocating memory for the v4l2 flash configuration structure and
> > leak it in the normal path. Just use the stack for this as we do not
> > use it outside of this function.
> > 
> > Fixes: 2870b52bae4c ("greybus: lights: add lights implementation")
> > Reported-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> > Signed-off-by: Rui Miguel Silva <rmfrfs@gmail.com>
> > Reviewed-by: Viresh Kumar <viresh.kumar@linaro.org>
> > ---
> 
> This patch is *not* the patch that I have send, here are the code
> differences from my patch to the one in this series:
> 
> <  	struct led_classdev_flash *iled = NULL;
> ---
> >  	struct led_classdev *iled = NULL;
> 51c57
> <  		iled = &channel_ind->fled;
> ---
> >  		iled = &channel_ind->fled.led_cdev;
> 89c95
> 
> So, this do not apply at all.
> Maybe you change something in your side.

It's been rebased on linux-next and in particular, patch 85f7ff9702bc
("media: v4l2-flash: Use led_classdev instead of led_classdev_flash for
indicator").

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
