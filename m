Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:53566 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751106Ab2AWQXm (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 23 Jan 2012 11:23:42 -0500
Message-ID: <4F1D898A.8020802@iki.fi>
Date: Mon, 23 Jan 2012 18:23:38 +0200
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@redhat.com>
CC: linux-media <linux-media@vger.kernel.org>
Subject: Re: DVBv5 test report
References: <4F17422E.1030408@iki.fi> <4F17FFA3.4040103@redhat.com> <4F18053D.1050404@iki.fi> <4F181B19.4060300@redhat.com>
In-Reply-To: <4F181B19.4060300@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 01/19/2012 03:31 PM, Mauro Carvalho Chehab wrote:
> [PATCH] dvb-usb: Don't abort stop on -EAGAIN/-EINTR
>
> Note: this patch is not complete. if the DVB demux device is opened on
> block mode, it should instead be returning -EAGAIN.
>
> Signed-off-by: Mauro Carvalho Chehab<mchehab@redhat.com>
>
> diff --git a/drivers/media/dvb/dvb-usb/dvb-usb-dvb.c b/drivers/media/dvb/dvb-usb/dvb-usb-dvb.c
> index ddf282f..215ce75 100644
> --- a/drivers/media/dvb/dvb-usb/dvb-usb-dvb.c
> +++ b/drivers/media/dvb/dvb-usb/dvb-usb-dvb.c
> @@ -30,7 +30,9 @@ static int dvb_usb_ctrl_feed(struct dvb_demux_feed *dvbdmxfeed, int onoff)
>   		usb_urb_kill(&adap->fe_adap[adap->active_fe].stream);
>
>   		if (adap->props.fe[adap->active_fe].streaming_ctrl != NULL) {
> -			ret = adap->props.fe[adap->active_fe].streaming_ctrl(adap, 0);
> +			do {
> +				ret = adap->props.fe[adap->active_fe].streaming_ctrl(adap, 0);
> +			} while ((ret == -EAGAIN) || (ret == -EINTR));
>   			if (ret<  0) {
>   				err("error while stopping stream.");
>   				return ret;
>

That fixes it. But it loops do {...} while around 100 times every I stop 
zap. Over 100 times is rather much...

And I think -EINTR is the only code to look, -EAGAIN is maybe for I2C 
and can be switched to native -EINTR also.

regards
Antti
-- 
http://palosaari.fi/
