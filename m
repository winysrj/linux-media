Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:36562 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751031AbdHOQJg (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 15 Aug 2017 12:09:36 -0400
Date: Tue, 15 Aug 2017 19:09:33 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Niklas =?iso-8859-1?Q?S=F6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
Cc: Sakari Ailus <sakari.ailus@linux.intel.com>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        linux-media@vger.kernel.org,
        Kieran Bingham <kieran.bingham@ideasonboard.com>,
        linux-renesas-soc@vger.kernel.org,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Sylwester Nawrocki <snawrocki@kernel.org>
Subject: Re: [PATCH 4/4] v4l: async: add comment about re-probing to
 v4l2_async_notifier_unregister()
Message-ID: <20170815160932.fizwqqkaivtz3nqu@valkosipuli.retiisi.org.uk>
References: <20170730223158.14405-1-niklas.soderlund+renesas@ragnatech.se>
 <20170730223158.14405-5-niklas.soderlund+renesas@ragnatech.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20170730223158.14405-5-niklas.soderlund+renesas@ragnatech.se>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Niklas,

Thanks for the patchset.

On Mon, Jul 31, 2017 at 12:31:58AM +0200, Niklas Söderlund wrote:
> The re-probing of subdevices when unregistering a notifier is tricky to
> understand, and implemented somewhat as a hack. Add a comment trying to
> explain why the re-probing is needed in the first place and why existing
> helper functions can't be used in this situation.
> 
> Signed-off-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
> ---
>  drivers/media/v4l2-core/v4l2-async.c | 17 +++++++++++++++++
>  1 file changed, 17 insertions(+)
> 
> diff --git a/drivers/media/v4l2-core/v4l2-async.c b/drivers/media/v4l2-core/v4l2-async.c
> index d91ff0a33fd3eaff..a3c5a1f6d4d2ab03 100644
> --- a/drivers/media/v4l2-core/v4l2-async.c
> +++ b/drivers/media/v4l2-core/v4l2-async.c
> @@ -234,6 +234,23 @@ void v4l2_async_notifier_unregister(struct v4l2_async_notifier *notifier)
>  
>  	mutex_unlock(&list_lock);
>  
> +	/*
> +	 * Try to re-probe the subdevices which where part of the notifier.
> +	 * This is done so subdevices which where part of the notifier will
> +	 * be re-probed to a pristine state and put back on the global
> +	 * list of subdevices so they can once more be found and associated
> +	 * with a new notifier.

Instead of tweaking the code trying to handle unhandleable error conditions
in notifier unregistration and adding lengthy stories on why this is done
the way it is, could we simply get rid of the driver re-probing?

I can't see why drivers shouldn't simply cope with the current interfaces
without re-probing to which I've never seen any reasoned cause. When a
sub-device driver is unbound, simply return the sub-device node to the list
of async sub-devices.

Or can someone come up with a valid reason why the re-probing code should
stay? :-)

> +	 *
> +	 * One might be tempted to use device_reprobe() to handle the re-
> +	 * probing. Unfortunately this is not possible since some video
> +	 * device drivers call v4l2_async_notifier_unregister() from
> +	 * there remove function leading to a dead lock situation on
> +	 * device_lock(dev->parent). This lock is held when video device
> +	 * drivers remove function is called and device_reprobe() also
> +	 * tries to take the same lock, so using it here could lead to a
> +	 * dead lock situation.
> +	 */
> +
>  	for (i = 0; i < count; i++) {
>  		/* If we handled USB devices, we'd have to lock the parent too */
>  		device_release_driver(dev[i]);

-- 
Regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi
