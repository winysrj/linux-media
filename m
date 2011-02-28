Return-path: <mchehab@pedra>
Received: from mga09.intel.com ([134.134.136.24]:51303 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752249Ab1B1ALz (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 27 Feb 2011 19:11:55 -0500
Date: Mon, 28 Feb 2011 01:11:51 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: "Matti J. Aaltonen" <matti.j.aaltonen@nokia.com>
Cc: alsa-devel@alsa-project.org, broonie@opensource.wolfsonmicro.com,
	lrg@slimlogic.co.uk, mchehab@redhat.com, hverkuil@xs4all.nl,
	linux-media@vger.kernel.org
Subject: Re: [PATCH v19 1/3] MFD: WL1273 FM Radio: MFD driver for the FM
 radio.
Message-ID: <20110228001150.GA2749@sortiz-mobl>
References: <1297757626-3281-1-git-send-email-matti.j.aaltonen@nokia.com>
 <1297757626-3281-2-git-send-email-matti.j.aaltonen@nokia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1297757626-3281-2-git-send-email-matti.j.aaltonen@nokia.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Matti

On Tue, Feb 15, 2011 at 10:13:44AM +0200, Matti J. Aaltonen wrote:
> This is the core of the WL1273 FM radio driver, it connects
> the two child modules. The two child drivers are
> drivers/media/radio/radio-wl1273.c and sound/soc/codecs/wl1273.c.
> 
> The radio-wl1273 driver implements the V4L2 interface and communicates
> with the device. The ALSA codec offers digital audio, without it only
> analog audio is available.
The driver looks fine, but for Mauro to take this one you'd have to provide a
diff against the already existing wl1273-core.

I have some minor comments:

> diff --git a/drivers/mfd/wl1273-core.c b/drivers/mfd/wl1273-core.c
> new file mode 100644
> index 0000000..66e0ac9
> --- /dev/null
> +++ b/drivers/mfd/wl1273-core.c
> @@ -0,0 +1,295 @@
> +/*
> + * MFD driver for wl1273 FM radio and audio codec submodules.
> + *
> + * Copyright (C) 2010 Nokia Corporation
2011.


> +/**
> + * wl1273_fm_set_volume() -	Set volume.
> + * @core:			A pointer to the device struct.
> + * @volume:			The new volume value.
> + */
> +static int wl1273_fm_set_volume(struct wl1273_core *core, unsigned int volume)
> +{
> +	u16 val;
> +	int r;
> +
> +	if (volume > WL1273_MAX_VOLUME)
> +		return -EINVAL;
> +
> +	if (core->volume == volume)
> +		return 0;
> +
> +	val = volume;
> +	r = wl1273_fm_read_reg(core, WL1273_VOLUME_SET, &val);
> +	if (r)
> +		return r;
> +
> +	core->volume = volume;
> +	return 0;
> +}
I'm confused with this one: Isn't WL1273_VOLUME_SET a command ? Also, how can
reading from it set the volume ?


> +static int wl1273_core_remove(struct i2c_client *client)
> +{
> +	struct wl1273_core *core = i2c_get_clientdata(client);
> +
> +	dev_dbg(&client->dev, "%s\n", __func__);
> +
> +	mfd_remove_devices(&client->dev);
> +	i2c_set_clientdata(client, NULL)
Not needed.

> +err:
> +	i2c_set_clientdata(client, NULL);
Ditto.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
