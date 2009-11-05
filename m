Return-path: <linux-media-owner@vger.kernel.org>
Received: from ey-out-2122.google.com ([74.125.78.27]:19755 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756654AbZKEOCB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 5 Nov 2009 09:02:01 -0500
Received: by ey-out-2122.google.com with SMTP id 25so22807eya.19
        for <linux-media@vger.kernel.org>; Thu, 05 Nov 2009 06:02:04 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <26256.64.213.30.2.1257398603.squirrel@webmail.exetel.com.au>
References: <20764.64.213.30.2.1257390002.squirrel@webmail.exetel.com.au>
	 <829197380911042051l295e9796g65fe1b163f72a70c@mail.gmail.com>
	 <26256.64.213.30.2.1257398603.squirrel@webmail.exetel.com.au>
Date: Thu, 5 Nov 2009 09:02:04 -0500
Message-ID: <829197380911050602t30bc69d0sd0b269c39bf759e@mail.gmail.com>
Subject: Re: bisected regression in tuner-xc2028 on DVICO dual digital 4
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Robert Lowery <rglowery@exemail.com.au>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Nov 5, 2009 at 12:23 AM, Robert Lowery <rglowery@exemail.com.au> wrote:
> Hi Devin,
>
> Thanks for your reply.
>
> I don't think your suggestion to use disable_power_mgmt will work as I
> already tried setting the no_poweroff=1 kernel module without success (and
> even tried recompiling with xc2028_sleep returning 0 immediately, but
> until I stopped the .sleep being set at all in xc2028_dvb_tuner_ops, the
> problem kept happening.
>
> The only thing that fixed it without code change was to set
> dvb_powerdown_on_sleep=0.
>
> Looking at the below code from dvb_frontend.c, the only difference I could
> see between setting no_poweroff=1 and not setting .sleep is the latter
> stops i2c_gate_ctrl being called.
>
>        if (dvb_powerdown_on_sleep) {
>                if (fe->ops.set_voltage)
>                        fe->ops.set_voltage(fe, SEC_VOLTAGE_OFF);
>                if (fe->ops.tuner_ops.sleep) {
>                        if (fe->ops.i2c_gate_ctrl)
>                                fe->ops.i2c_gate_ctrl(fe, 1);
>                        fe->ops.tuner_ops.sleep(fe);
>                        if (fe->ops.i2c_gate_ctrl)
>                                fe->ops.i2c_gate_ctrl(fe, 0);
>                }
>                if (fe->ops.sleep)
>                        fe->ops.sleep(fe);
>        }
>
> I'm not very familiar with this code.  Am I missing something?
>
> -Rob

Could you please clarify exactly which card you have (PCI/USB ID)?

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
