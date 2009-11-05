Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f227.google.com ([209.85.218.227]:61584 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755090AbZKEEvw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 4 Nov 2009 23:51:52 -0500
Received: by bwz27 with SMTP id 27so9679013bwz.21
        for <linux-media@vger.kernel.org>; Wed, 04 Nov 2009 20:51:56 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20764.64.213.30.2.1257390002.squirrel@webmail.exetel.com.au>
References: <20764.64.213.30.2.1257390002.squirrel@webmail.exetel.com.au>
Date: Wed, 4 Nov 2009 23:51:55 -0500
Message-ID: <829197380911042051l295e9796g65fe1b163f72a70c@mail.gmail.com>
Subject: Re: bisected regression in tuner-xc2028 on DVICO dual digital 4
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Robert Lowery <rglowery@exemail.com.au>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Nov 4, 2009 at 10:00 PM, Robert Lowery <rglowery@exemail.com.au> wrote:
> Hi,
>
> I have been having some difficulties getting my DVICO dual digital 4
> (rev1) working with recent kernels, failing to tune and getting errors
> like the following
>
> kernel: [ 315.032076] dvb-usb: bulk message failed: -110 (4/0)
> kernel: [ 315.032080] cxusb: i2c read failed
>
> and making the machine very slow as documented at
> https://bugs.launchpad.net/ubuntu/+source/linux-meta/+bug/459523
>
> Using the v4l-dvb tree, I was able to bisect the issue down to
> http://linuxtv.org/hg/v4l-dvb/rev/7276a5854219
>
> At first I though I could workaround the issue by setting no_poweroff=1,
> but that did not work.  The following diff did however resolve the issue.
>
> diff -r 43878f8dbfb0 linux/drivers/media/common/tuners/tuner-xc2028.c
> --- a/linux/drivers/media/common/tuners/tuner-xc2028.c        Sun Nov 01
> 07:17:46
> 2009 -0200
> +++ b/linux/drivers/media/common/tuners/tuner-xc2028.c        Tue Nov 03
> 14:24:05
> 2009 +1100
> @@ -1240,7 +1240,7 @@
>         .get_frequency     = xc2028_get_frequency,
>         .get_rf_strength   = xc2028_signal,
>         .set_params        = xc2028_set_params,
> -        .sleep             = xc2028_sleep,
> +        //.sleep             = xc2028_sleep,
>  #if 0
>         int (*get_bandwidth)(struct dvb_frontend *fe, u32 *bandwidth);
>         int (*get_status)(struct dvb_frontend *fe, u32 *status);
>
> This led me to dvb_frontend.c where I could see i2c_gate_ctrl() was being
> called if .sleep was non zero.  Setting dvb_powerdown_on_sleep=0 worked
> around the issue by stoppign i2c_gate_ctrl() being called, so I suspect
> i2c_gate_ctrl() is triggering the issue somehow.
>
> Any thoughts on a proper solution for this issue?
>
> -Rob

Hello Rob,

The problem is not actually the i2c_gate_ctrl().  It's the fact that
the xc3028 is being put to sleep but cannot be woken up.

The GPIOs are probably setup for this card improperly in the board
profile.  This will result in the xc3028 being put to sleep, but then
it cannot be woken up because the wrong GPIO is being pulled low to
reset the chip in the xc3028 reset callback.

Yet another case where blindly enabling the power management on the
xc3028 by default was a really crappy idea.

You can either track down the which GPIO is actually connected to the
xc3028 reset pin for your board, or disable the xc3028 power
management by setting the disable_power_mgmt field in the xc3028
config when the call is made to xc2028_set_config for your card.

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
