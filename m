Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:49902 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751978Ab2KFAHs (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 5 Nov 2012 19:07:48 -0500
Message-ID: <509854B7.40606@iki.fi>
Date: Tue, 06 Nov 2012 02:07:19 +0200
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Antonio Ospite <ospite@studenti.unina.it>
CC: linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Michael Krufky <mkrufky@linuxtv.org>,
	Patrick Boettcher <patrick.boettcher@desy.de>
Subject: Re: [PATCH 1/5] [media] dvb-usb: add a pre_init hook to struct dvb_usb_device_properties
References: <1352158096-17737-1-git-send-email-ospite@studenti.unina.it> <1352158096-17737-2-git-send-email-ospite@studenti.unina.it>
In-Reply-To: <1352158096-17737-2-git-send-email-ospite@studenti.unina.it>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 11/06/2012 01:28 AM, Antonio Ospite wrote:
> Some devices need to issue a pre-initialization command sequence via
> i2c in order to "enable" the communication with some adapter components.
>
> This happens for instance in the vp7049 USB DVB-T stick on which the
> frontend cannot be detected without first sending a certain sequence of
> commands via i2c.

I looked patch 3 and it is not I2C communication but direct M9206 memory 
access you did. I could guess it is GPIO sequence to reset & power demod 
and tuner. Due to that, correct place for this kind of initialization is 
inside demod and tuner attach.

With a USB power meter, some trial & error testing, and maybe fw disasm 
you could even detect those GPIOS :)


> Signed-off-by: Antonio Ospite <ospite@studenti.unina.it>
> ---
>
> If this approach is OK I can send a similar patch for dvb-usb-v2.

There is already such callbacks - but no callback between I2C init and 
FE attach. There is read_config() which is called first, good place to 
make probing device and detect hw config. Another new callback is 
.init() which is called after demod and tuner attach. Stuff like USB 
interface config should remain here. On USB power management case 
reset_resume() that function is called too in order re-configure reseted 
USB IF.

I don't see need yet another new callback.

> Are all the dvb-usb drivers going to be ported to dvb-usb-v2 eventually?

There is still quite many drivers to convert, so maybe it is not happen 
anytime soon or even later. Feel free to convert that driver. For bonus 
you will get for example power-management support for free.

>
>
>   drivers/media/usb/dvb-usb/dvb-usb.h      |    5 +++++
>   drivers/media/usb/dvb-usb/dvb-usb-init.c |    6 ++++++
>   2 files changed, 11 insertions(+)
>
> diff --git a/drivers/media/usb/dvb-usb/dvb-usb.h b/drivers/media/usb/dvb-usb/dvb-usb.h
> index aab0f99..1fcea68 100644
> --- a/drivers/media/usb/dvb-usb/dvb-usb.h
> +++ b/drivers/media/usb/dvb-usb/dvb-usb.h
> @@ -233,6 +233,9 @@ enum dvb_usb_mode {
>    * @size_of_priv: how many bytes shall be allocated for the private field
>    *  of struct dvb_usb_device.
>    *
> + * @pre_init: function executed after i2c initialization but
> + *   before the adapters get initialized
> + *
>    * @power_ctrl: called to enable/disable power of the device.
>    * @read_mac_address: called to read the MAC address of the device.
>    * @identify_state: called to determine the state (cold or warm), when it
> @@ -274,6 +277,8 @@ struct dvb_usb_device_properties {
>
>   	int size_of_priv;
>
> +	int (*pre_init) (struct dvb_usb_device *);
> +
>   	int num_adapters;
>   	struct dvb_usb_adapter_properties adapter[MAX_NO_OF_ADAPTER_PER_DEVICE];
>
> diff --git a/drivers/media/usb/dvb-usb/dvb-usb-init.c b/drivers/media/usb/dvb-usb/dvb-usb-init.c
> index 169196e..8ab916e 100644
> --- a/drivers/media/usb/dvb-usb/dvb-usb-init.c
> +++ b/drivers/media/usb/dvb-usb/dvb-usb-init.c
> @@ -31,6 +31,12 @@ static int dvb_usb_adapter_init(struct dvb_usb_device *d, short *adapter_nrs)
>   	struct dvb_usb_adapter *adap;
>   	int ret, n, o;
>
> +	if (d->props.pre_init) {
> +		ret = d->props.pre_init(d);
> +		if (ret < 0)
> +			return ret;
> +	}
> +
>   	for (n = 0; n < d->props.num_adapters; n++) {
>   		adap = &d->adapter[n];
>   		adap->dev = d;
>
regards
Antti
-- 
http://palosaari.fi/
