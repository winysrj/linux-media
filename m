Return-path: <mchehab@pedra>
Received: from mail.kapsi.fi ([217.30.184.167]:58147 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753254Ab1CEKto (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 5 Mar 2011 05:49:44 -0500
Message-ID: <4D721546.3090904@iki.fi>
Date: Sat, 05 Mar 2011 12:49:42 +0200
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: adq <adq@lidskialf.net>
CC: linux-media@vger.kernel.org
Subject: Re: [patch] Fix AF9015 Dual tuner i2c write failures
References: <AANLkTi=rcfL_pku9hhx68C_Fb_76KsW2Yy+Oys10a7+4@mail.gmail.com>	<4D7163FD.9030604@iki.fi>	<AANLkTimjC99zhJ=huHZiGgbENCoyHy5KT87iujjTT8w3@mail.gmail.com>	<4D716ECA.4060900@iki.fi>	<AANLkTimHa6XFwhvpLbhtRm7Vee-jYPkHpx+D8L2=+vQb@mail.gmail.com> <AANLkTik9cSnAFWNdTUv3NNU3K2SoeECDO2036Htx-OAi@mail.gmail.com>
In-Reply-To: <AANLkTik9cSnAFWNdTUv3NNU3K2SoeECDO2036Htx-OAi@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On 03/05/2011 03:43 AM, adq wrote:
> +static int af9015_lock_i2c_gate_ctrl(struct dvb_frontend *fe, int enable)
> +{
> +	int result;
> +	struct dvb_usb_adapter *adap = fe->dvb->priv;
> +	struct af9015_state *state = adap->dev->priv;
> +
> +	if (enable)
> +		if (mutex_lock_interruptible(&adap->dev->usb_mutex))
> +			return -EAGAIN;
> +
> +	result = state->i2c_gate_ctrl[adap->id](fe, enable);
> +	
> +	if (!enable)
> +		mutex_unlock(&adap->dev->usb_mutex);
> +	
> +	return result;
> +}

I think this will cause problems in case of tuner driver calls more than 
one time gate close or gate enable one after the other.


Antti

-- 
http://palosaari.fi/
