Return-path: <linux-media-owner@vger.kernel.org>
Received: from sub5.mail.dreamhost.com ([208.113.200.129]:56379 "EHLO
        homiemail-a125.g.dreamhost.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1754955AbeF0Tqx (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 27 Jun 2018 15:46:53 -0400
Subject: Re: [PATCH] em28xx: Fix dual transport stream operation
To: Brad Love <brad@nextdimension.cc>, linux-media@vger.kernel.org,
        mchehab@infradead.org, dheitmueller@kernellabs.com
References: <1530128483-31662-1-git-send-email-brad@nextdimension.cc>
 <1530128483-31662-2-git-send-email-brad@nextdimension.cc>
From: Brad Love <brad@nextdimension.cc>
Message-ID: <25633bae-4893-8f64-1084-cf8778670a74@nextdimension.cc>
Date: Wed, 27 Jun 2018 14:46:51 -0500
MIME-Version: 1.0
In-Reply-To: <1530128483-31662-2-git-send-email-brad@nextdimension.cc>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-GB
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Apologies, forgot to note this patch requires:

https://patchwork.kernel.org/patch/10492053/



On 2018-06-27 14:41, Brad Love wrote:
> Addresses the following, which introduced a regression itself:
>
> Commit 509f89652f83 ("media: em28xx: fix a regression with HVR-950")
>
> The regression fix breaks dual transport stream support. When a
> tuner starts streaming it sets alt mode on the USB interface.
> The problem is both tuners share the same USB interface, so when
> the second tuner becomes active and sets alt mode on the interface
> it kills streaming on the other port.
>
> It was suggested to add a refcounter and only set alt mode if no
> tuners are currently active on the interface. This requires
> sharing some state amongst both tuner devices, with appropriate
> locking.
>
> What I've done here is the following:
> - Add a usage_count pointer to struct em28xx
> - Share usage_count between both em28xx devices
> - Only set alt mode if usage_count is zero
> - Increment usage_count when each tuner becomes active
> - Decrement usage_count when a tuner becomes idle
>
> With usage_count in the main em28xx struct, locking is handled as
> follows:
> - if a secondary tuner exists, lock dev->dev_next->lock
> - if no secondary tuner exists, lock dev->lock
>
> By using the above scheme a single tuner device, will lock itself,
> the first tuner in a dual tuner device will lock the second tuner,
> and the second tuner in a dual tuner device will lock itself aka
> the second tuner instance.
>
> Signed-off-by: Brad Love <brad@nextdimension.cc>
> ---
>  drivers/media/usb/em28xx/em28xx-cards.c |  6 ++++-
>  drivers/media/usb/em28xx/em28xx-dvb.c   | 47 +++++++++++++++++++++++++++++++--
>  drivers/media/usb/em28xx/em28xx.h       |  1 +
>  3 files changed, 51 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/media/usb/em28xx/em28xx-cards.c b/drivers/media/usb/em28xx/em28xx-cards.c
> index 48bc505..91f9787 100644
> --- a/drivers/media/usb/em28xx/em28xx-cards.c
> +++ b/drivers/media/usb/em28xx/em28xx-cards.c
> @@ -3374,8 +3374,10 @@ void em28xx_free_device(struct kref *ref)
>  	if (!dev->disconnected)
>  		em28xx_release_resources(dev);
>  
> -	if (dev->ts == PRIMARY_TS)
> +	if (dev->ts == PRIMARY_TS) {
>  		kfree(dev->alt_max_pkt_size_isoc);
> +		kfree(dev->usage_count);
> +	}
>  
>  	kfree(dev);
>  }
> @@ -3793,6 +3795,8 @@ static int em28xx_usb_probe(struct usb_interface *intf,
>  	dev->is_audio_only = has_vendor_audio && !(has_video || has_dvb);
>  	dev->has_video = has_video;
>  	dev->ifnum = ifnum;
> +	dev->usage_count = kcalloc(1, sizeof(unsigned int), GFP_KERNEL);
> +	*dev->usage_count = 0;
>  
>  	dev->ts = PRIMARY_TS;
>  	snprintf(dev->name, 28, "em28xx");
> diff --git a/drivers/media/usb/em28xx/em28xx-dvb.c b/drivers/media/usb/em28xx/em28xx-dvb.c
> index b778d8a..3a67831 100644
> --- a/drivers/media/usb/em28xx/em28xx-dvb.c
> +++ b/drivers/media/usb/em28xx/em28xx-dvb.c
> @@ -218,7 +218,19 @@ static int em28xx_start_streaming(struct em28xx_dvb *dvb)
>  		dvb_alt = dev->dvb_alt_isoc;
>  	}
>  
> -	usb_set_interface(udev, dev->ifnum, dvb_alt);
> +	if (dev->dev_next)
> +		mutex_lock(&dev->dev_next->lock);
> +	else
> +		mutex_lock(&dev->lock);
> +
> +	if (*dev->usage_count == 0)
> +		usb_set_interface(udev, dev->ifnum, dvb_alt);
> +
> +	if (dev->dev_next)
> +		mutex_unlock(&dev->dev_next->lock);
> +	else
> +		mutex_unlock(&dev->lock);
> +
>  	rc = em28xx_set_mode(dev, EM28XX_DIGITAL_MODE);
>  	if (rc < 0)
>  		return rc;
> @@ -250,6 +262,8 @@ static int em28xx_start_feed(struct dvb_demux_feed *feed)
>  {
>  	struct dvb_demux *demux  = feed->demux;
>  	struct em28xx_dvb *dvb = demux->priv;
> +	struct em28xx_i2c_bus *i2c_bus = dvb->adapter.priv;
> +	struct em28xx *dev = i2c_bus->dev;
>  	int rc, ret;
>  
>  	if (!demux->dmx.frontend)
> @@ -263,6 +277,19 @@ static int em28xx_start_feed(struct dvb_demux_feed *feed)
>  		ret = em28xx_start_streaming(dvb);
>  		if (ret < 0)
>  			rc = ret;
> +		else {
> +			if (dev->dev_next)
> +				mutex_lock(&dev->dev_next->lock);
> +			else
> +				mutex_lock(&dev->lock);
> +
> +			*dev->usage_count = *dev->usage_count + 1;
> +
> +			if (dev->dev_next)
> +				mutex_unlock(&dev->dev_next->lock);
> +			else
> +				mutex_unlock(&dev->lock);
> +		}
>  	}
>  
>  	mutex_unlock(&dvb->lock);
> @@ -273,14 +300,30 @@ static int em28xx_stop_feed(struct dvb_demux_feed *feed)
>  {
>  	struct dvb_demux *demux  = feed->demux;
>  	struct em28xx_dvb *dvb = demux->priv;
> +	struct em28xx_i2c_bus *i2c_bus = dvb->adapter.priv;
> +	struct em28xx *dev = i2c_bus->dev;
>  	int err = 0;
>  
>  	mutex_lock(&dvb->lock);
>  	dvb->nfeeds--;
>  
> -	if (!dvb->nfeeds)
> +	if (!dvb->nfeeds) {
>  		err = em28xx_stop_streaming(dvb);
>  
> +		if (dev->dev_next)
> +			mutex_lock(&dev->dev_next->lock);
> +		else
> +			mutex_lock(&dev->lock);
> +
> +		*dev->usage_count = *dev->usage_count - 1;
> +
> +		if (dev->dev_next)
> +			mutex_unlock(&dev->dev_next->lock);
> +		else
> +			mutex_unlock(&dev->lock);
> +	}
> +
> +
>  	mutex_unlock(&dvb->lock);
>  	return err;
>  }
> diff --git a/drivers/media/usb/em28xx/em28xx.h b/drivers/media/usb/em28xx/em28xx.h
> index 953caac..d245c4f 100644
> --- a/drivers/media/usb/em28xx/em28xx.h
> +++ b/drivers/media/usb/em28xx/em28xx.h
> @@ -775,6 +775,7 @@ struct em28xx {
>  
>  	struct em28xx	*dev_next;
>  	int ts;
> +	unsigned int *usage_count;
>  };
>  
>  #define kref_to_dev(d) container_of(d, struct em28xx, ref)
