Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:56656 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753671AbbBZLyY (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 26 Feb 2015 06:54:24 -0500
Message-ID: <54EF096B.1060603@iki.fi>
Date: Thu, 26 Feb 2015 13:54:19 +0200
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
CC: Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [PATCH 2/2 v2] dvb-usb-v2: create one media_dev per adapter
References: <5f768a83b8035c8c17a7812388c1382b69e1bdf1.1424950218.git.mchehab@osg.samsung.com>
In-Reply-To: <5f768a83b8035c8c17a7812388c1382b69e1bdf1.1424950218.git.mchehab@osg.samsung.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 02/26/2015 01:34 PM, Mauro Carvalho Chehab wrote:
> Instead of assuming just one adapter, change the code to store
> one media controller per adapter.
>
> This works fine for dvb-usb, as, on all drivers here, it is not
> possible to write a media graph that would mix resources between
> the two different adapters.
>
> Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

Acked-by: Antti Palosaari <crope@iki.fi>

Antti


>
> v2:
>
> - Fix unregister logic
>
> diff --git a/drivers/media/usb/dvb-usb-v2/dvb_usb.h b/drivers/media/usb/dvb-usb-v2/dvb_usb.h
> index dbac1633312a..023d91f7e654 100644
> --- a/drivers/media/usb/dvb-usb-v2/dvb_usb.h
> +++ b/drivers/media/usb/dvb-usb-v2/dvb_usb.h
> @@ -392,10 +392,6 @@ struct dvb_usb_device {
>   	struct delayed_work rc_query_work;
>
>   	void *priv;
> -
> -#if defined(CONFIG_MEDIA_CONTROLLER_DVB)
> -	struct media_device *media_dev;
> -#endif
>   };
>
>   extern int dvb_usbv2_probe(struct usb_interface *,
> diff --git a/drivers/media/usb/dvb-usb-v2/dvb_usb_core.c b/drivers/media/usb/dvb-usb-v2/dvb_usb_core.c
> index 94a7f6390f46..0666c8f33ac7 100644
> --- a/drivers/media/usb/dvb-usb-v2/dvb_usb_core.c
> +++ b/drivers/media/usb/dvb-usb-v2/dvb_usb_core.c
> @@ -400,11 +400,11 @@ skip_feed_stop:
>   	return ret;
>   }
>
> -static void dvb_usbv2_media_device_register(struct dvb_usb_device *d)
> +static void dvb_usbv2_media_device_register(struct dvb_usb_adapter *adap)
>   {
>   #ifdef CONFIG_MEDIA_CONTROLLER_DVB
> -
>   	struct media_device *mdev;
> +	struct dvb_usb_device *d = adap_to_d(adap);
>   	struct usb_device *udev = d->udev;
>   	int ret;
>
> @@ -429,22 +429,23 @@ static void dvb_usbv2_media_device_register(struct dvb_usb_device *d)
>   		return;
>   	}
>
> -	d->media_dev = mdev;
> +	adap->dvb_adap.mdev = mdev;
>
>   	dev_info(&d->udev->dev, "media controller created\n");
>
>   #endif
>   }
>
> -static void dvb_usbv2_media_device_unregister(struct dvb_usb_device *d)
> +static void dvb_usbv2_media_device_unregister(struct dvb_usb_adapter *adap)
>   {
>   #ifdef CONFIG_MEDIA_CONTROLLER_DVB
> -	if (!d->media_dev)
> +
> +	if (!adap->dvb_adap.mdev)
>   		return;
>
> -	media_device_unregister(d->media_dev);
> -	kfree(d->media_dev);
> -	d->media_dev = NULL;
> +	media_device_unregister(adap->dvb_adap.mdev);
> +	kfree(adap->dvb_adap.mdev);
> +	adap->dvb_adap.mdev = NULL;
>
>   #endif
>   }
> @@ -453,6 +454,7 @@ static int dvb_usbv2_adapter_dvb_init(struct dvb_usb_adapter *adap)
>   {
>   	int ret;
>   	struct dvb_usb_device *d = adap_to_d(adap);
> +
>   	dev_dbg(&d->udev->dev, "%s: adap=%d\n", __func__, adap->id);
>
>   	ret = dvb_register_adapter(&adap->dvb_adap, d->name, d->props->owner,
> @@ -466,8 +468,7 @@ static int dvb_usbv2_adapter_dvb_init(struct dvb_usb_adapter *adap)
>   	adap->dvb_adap.priv = adap;
>
>   #ifdef CONFIG_MEDIA_CONTROLLER_DVB
> -	dvb_usbv2_media_device_register(d);
> -	adap->dvb_adap.mdev = d->media_dev;
> +	dvb_usbv2_media_device_register(adap);
>   #endif
>
>   	if (d->props->read_mac_address) {
> @@ -518,7 +519,7 @@ err_dvb_net_init:
>   err_dvb_dmxdev_init:
>   	dvb_dmx_release(&adap->demux);
>   err_dvb_dmx_init:
> -	dvb_usbv2_media_device_unregister(d);
> +	dvb_usbv2_media_device_unregister(adap);
>   	dvb_unregister_adapter(&adap->dvb_adap);
>   err_dvb_register_adapter:
>   	adap->dvb_adap.priv = NULL;
> @@ -537,7 +538,7 @@ static int dvb_usbv2_adapter_dvb_exit(struct dvb_usb_adapter *adap)
>   		adap->demux.dmx.close(&adap->demux.dmx);
>   		dvb_dmxdev_release(&adap->dmxdev);
>   		dvb_dmx_release(&adap->demux);
> -		dvb_usbv2_media_device_unregister(d);
> +		dvb_usbv2_media_device_unregister(adap);
>   		dvb_unregister_adapter(&adap->dvb_adap);
>   	}
>
> @@ -701,7 +702,7 @@ static int dvb_usbv2_adapter_frontend_init(struct dvb_usb_adapter *adap)
>   		}
>   	}
>
> -	dvb_create_media_graph(d->media_dev);
> +	dvb_create_media_graph(adap->dvb_adap.mdev);
>
>   	return 0;
>
>

-- 
http://palosaari.fi/
