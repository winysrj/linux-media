Return-path: <mchehab@pedra>
Received: from n5-vm1.bullet.mail.in.yahoo.com ([202.86.4.130]:43487 "HELO
	n5-vm1.bullet.mail.in.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1759801Ab0HLMRR convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 12 Aug 2010 08:17:17 -0400
Message-ID: <239550.42715.qm@web95111.mail.in2.yahoo.com>
References: <1280758003-16118-1-git-send-email-matti.j.aaltonen@nokia.com> <1280758003-16118-2-git-send-email-matti.j.aaltonen@nokia.com> <1280758003-16118-3-git-send-email-matti.j.aaltonen@nokia.com> <1280758003-16118-4-git-send-email-matti.j.aaltonen@nokia.com> <1280758003-16118-5-git-send-email-matti.j.aaltonen@nokia.com>
Date: Thu, 12 Aug 2010 17:40:34 +0530 (IST)
From: pramodh ag <pramodhag@yahoo.co.in>
Subject: Re: [PATCH v7 4/5] V4L2: WL1273 FM Radio: Controls for the FM radio.
To: "Matti J. Aaltonen" <matti.j.aaltonen@nokia.com>,
	linux-media@vger.kernel.org, hverkuil@xs4all.nl,
	eduardo.valentin@nokia.com, mchehab@redhat.com
In-Reply-To: <1280758003-16118-5-git-send-email-matti.j.aaltonen@nokia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@pedra>

Matti,

> +/**
> + * wl1273_fm_set_tx_power() -    Set the transmission power value.
> + * @core:            A pointer to the device struct.
> + * @power:            The new power value.
> + */
> +static int wl1273_fm_set_tx_power(struct wl1273_core *core, u16 power)
> +{
> +    int r;
> +
> +    if (core->mode == WL1273_MODE_OFF ||
> +        core->mode == WL1273_MODE_SUSPENDED)
> +        return -EPERM;
> +
> +    mutex_lock(&core->lock);
> +
> +    r = wl1273_fm_write_cmd(core, WL1273_POWER_LEV_SET, power);

Output power level is specified in units of dBuV (as explained at 
http://www.linuxtv.org/downloads/v4l-dvb-apis/ch01s09.html#fm-tx-controls).
Shouldn't it be converted to WL1273 specific power level value?

My understanding:
If output power level specified using "V4L2_CID_TUNE_POWER_LEVEL" is 122 
(dB/uV), then
power level value to be passed for WL1273 should be '0'.
Please correct me, if I got this conversion wrong.

Thanks and regards,
Pramodh




