Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:48208 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752213AbbBCUU7 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 3 Feb 2015 15:20:59 -0500
Date: Tue, 3 Feb 2015 18:20:54 -0200
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Luis de Bethencourt <luis@debethencourt.com>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [media] dvb-usb: fix spaces after commas
Message-ID: <20150203182054.39e647f4@recife.lan>
In-Reply-To: <20150128151122.GA22122@goodgumbo.baconseed.org>
References: <20150128151122.GA22122@goodgumbo.baconseed.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Wed, 28 Jan 2015 16:11:22 +0100
Luis de Bethencourt <luis@debethencourt.com> escreveu:

Please provide some description

> Signed-off-by: Luis de Bethencourt <luis.bg@samsung.com>

Also, if you're touching on those printks, you should be fixing the
scripts/checkpatch.pl warnings for that too:

WARNING: line over 80 characters
#28: FILE: drivers/media/usb/dvb-usb/dvb-usb-dvb.c:87:
+	deb_ts("start pid: 0x%04x, feedtype: %d\n", dvbdmxfeed->pid, dvbdmxfeed->type);

WARNING: line over 80 characters
#46: FILE: drivers/media/usb/dvb-usb/dvb-usb-dvb.c:111:
+		if (adap->dev->props.read_mac_address(adap->dev, adap->dvb_adap.proposed_mac) == 0)

total: 0 errors, 2 warnings, 50 lines checked

Regards,
Mauro

> ---
>  drivers/media/usb/dvb-usb/dvb-usb-dvb.c | 16 ++++++++--------
>  1 file changed, 8 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/media/usb/dvb-usb/dvb-usb-dvb.c b/drivers/media/usb/dvb-usb/dvb-usb-dvb.c
> index 719413b..c901d15 100644
> --- a/drivers/media/usb/dvb-usb/dvb-usb-dvb.c
> +++ b/drivers/media/usb/dvb-usb/dvb-usb-dvb.c
> @@ -84,14 +84,14 @@ static int dvb_usb_ctrl_feed(struct dvb_demux_feed *dvbdmxfeed, int onoff)
>  
>  static int dvb_usb_start_feed(struct dvb_demux_feed *dvbdmxfeed)
>  {
> -	deb_ts("start pid: 0x%04x, feedtype: %d\n", dvbdmxfeed->pid,dvbdmxfeed->type);
> -	return dvb_usb_ctrl_feed(dvbdmxfeed,1);
> +	deb_ts("start pid: 0x%04x, feedtype: %d\n", dvbdmxfeed->pid, dvbdmxfeed->type);
> +	return dvb_usb_ctrl_feed(dvbdmxfeed, 1);
>  }
>  
>  static int dvb_usb_stop_feed(struct dvb_demux_feed *dvbdmxfeed)
>  {
>  	deb_ts("stop pid: 0x%04x, feedtype: %d\n", dvbdmxfeed->pid, dvbdmxfeed->type);
> -	return dvb_usb_ctrl_feed(dvbdmxfeed,0);
> +	return dvb_usb_ctrl_feed(dvbdmxfeed, 0);
>  }
>  
>  int dvb_usb_adapter_dvb_init(struct dvb_usb_adapter *adap, short *adapter_nums)
> @@ -108,8 +108,8 @@ int dvb_usb_adapter_dvb_init(struct dvb_usb_adapter *adap, short *adapter_nums)
>  	adap->dvb_adap.priv = adap;
>  
>  	if (adap->dev->props.read_mac_address) {
> -		if (adap->dev->props.read_mac_address(adap->dev,adap->dvb_adap.proposed_mac) == 0)
> -			info("MAC address: %pM",adap->dvb_adap.proposed_mac);
> +		if (adap->dev->props.read_mac_address(adap->dev, adap->dvb_adap.proposed_mac) == 0)
> +			info("MAC address: %pM", adap->dvb_adap.proposed_mac);
>  		else
>  			err("MAC address reading failed.");
>  	}
> @@ -128,7 +128,7 @@ int dvb_usb_adapter_dvb_init(struct dvb_usb_adapter *adap, short *adapter_nums)
>  	adap->demux.stop_feed        = dvb_usb_stop_feed;
>  	adap->demux.write_to_decoder = NULL;
>  	if ((ret = dvb_dmx_init(&adap->demux)) < 0) {
> -		err("dvb_dmx_init failed: error %d",ret);
> +		err("dvb_dmx_init failed: error %d", ret);
>  		goto err_dmx;
>  	}
>  
> @@ -136,13 +136,13 @@ int dvb_usb_adapter_dvb_init(struct dvb_usb_adapter *adap, short *adapter_nums)
>  	adap->dmxdev.demux           = &adap->demux.dmx;
>  	adap->dmxdev.capabilities    = 0;
>  	if ((ret = dvb_dmxdev_init(&adap->dmxdev, &adap->dvb_adap)) < 0) {
> -		err("dvb_dmxdev_init failed: error %d",ret);
> +		err("dvb_dmxdev_init failed: error %d", ret);
>  		goto err_dmx_dev;
>  	}
>  
>  	if ((ret = dvb_net_init(&adap->dvb_adap, &adap->dvb_net,
>  						&adap->demux.dmx)) < 0) {
> -		err("dvb_net_init failed: error %d",ret);
> +		err("dvb_net_init failed: error %d", ret);
>  		goto err_net_init;
>  	}
>  
