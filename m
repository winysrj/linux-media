Return-path: <mchehab@pedra>
Received: from smtp.nokia.com ([192.100.122.230]:56371 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758763Ab0HLM3l (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 12 Aug 2010 08:29:41 -0400
Subject: Re: [PATCH v7 4/5] V4L2: WL1273 FM Radio: Controls for the FM
 radio.
From: "Matti J. Aaltonen" <matti.j.aaltonen@nokia.com>
Reply-To: matti.j.aaltonen@nokia.com
To: ext pramodh ag <pramodhag@yahoo.co.in>
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"hverkuil@xs4all.nl" <hverkuil@xs4all.nl>,
	"Valentin Eduardo (Nokia-MS/Helsinki)" <eduardo.valentin@nokia.com>,
	"mchehab@redhat.com" <mchehab@redhat.com>
In-Reply-To: <239550.42715.qm@web95111.mail.in2.yahoo.com>
References: <1280758003-16118-1-git-send-email-matti.j.aaltonen@nokia.com>
	 <1280758003-16118-2-git-send-email-matti.j.aaltonen@nokia.com>
	 <1280758003-16118-3-git-send-email-matti.j.aaltonen@nokia.com>
	 <1280758003-16118-4-git-send-email-matti.j.aaltonen@nokia.com>
	 <1280758003-16118-5-git-send-email-matti.j.aaltonen@nokia.com>
	 <239550.42715.qm@web95111.mail.in2.yahoo.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 12 Aug 2010 15:28:54 +0300
Message-ID: <1281616134.14489.86.camel@masi.mnp.nokia.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@pedra>

Hello.

On Thu, 2010-08-12 at 14:10 +0200, ext pramodh ag wrote:
> Matti,
> 
> > +/**
> > + * wl1273_fm_set_tx_power() -    Set the transmission power value.
> > + * @core:            A pointer to the device struct.
> > + * @power:            The new power value.
> > + */
> > +static int wl1273_fm_set_tx_power(struct wl1273_core *core, u16 power)
> > +{
> > +    int r;
> > +
> > +    if (core->mode == WL1273_MODE_OFF ||
> > +        core->mode == WL1273_MODE_SUSPENDED)
> > +        return -EPERM;
> > +
> > +    mutex_lock(&core->lock);
> > +
> > +    r = wl1273_fm_write_cmd(core, WL1273_POWER_LEV_SET, power);
> 
> Output power level is specified in units of dBuV (as explained at 
> http://www.linuxtv.org/downloads/v4l-dvb-apis/ch01s09.html#fm-tx-controls).
> Shouldn't it be converted to WL1273 specific power level value?
> 
> My understanding:
> If output power level specified using "V4L2_CID_TUNE_POWER_LEVEL" is 122 
> (dB/uV), then
> power level value to be passed for WL1273 should be '0'.
> Please correct me, if I got this conversion wrong.

Thank you for pointing that out. I'll check and fix it...

Regards,
Matti

> Thanks and regards,
> Pramodh
> 
> 
> 
> 


