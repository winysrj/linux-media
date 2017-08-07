Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.horus.com ([78.46.148.228]:34334 "EHLO mail.horus.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751247AbdHGHJ2 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 7 Aug 2017 03:09:28 -0400
Date: Mon, 7 Aug 2017 09:09:26 +0200
From: Matthias Reichl <hias@horus.com>
To: Sean Young <sean@mess.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        linux-media@vger.kernel.org
Subject: Re: [PATCH] keytable: ensure udev rule fires on rc input device
Message-ID: <20170807070926.hvj5qvqb34xb2x3k@camel2.lan>
References: <20170717092038.3e7jbjtx7htu3lda@camel2.lan>
 <20170805213802.ni42iaht5rf5rye2@gofer.mess.org>
 <20170806085655.dkaq7hqpyzrc3abj@gofer.mess.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170806085655.dkaq7hqpyzrc3abj@gofer.mess.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sean!

On Sun, Aug 06, 2017 at 09:56:55AM +0100, Sean Young wrote:
> The rc device is created before the input device, so if ir-keytable runs
> too early the input device does not exist yet.
> 
> Ensure that rule fires on creation of a rc device's input device.
> 
> Note that this also prevents udev from starting ir-keytable on an
> transmit only device, which has no input device.
> 
> Signed-off-by: Sean Young <sean@mess.org>

Signed-off-by: Matthias Reichl <hias@horus.com>

One comment though, see below

> ---
>  utils/keytable/70-infrared.rules | 10 +++++++++-
>  1 file changed, 9 insertions(+), 1 deletion(-)
> 
> Matthias, can I have your Signed-off-by please? Thank you.
> 
> 
> diff --git a/utils/keytable/70-infrared.rules b/utils/keytable/70-infrared.rules
> index afffd951..b3531727 100644
> --- a/utils/keytable/70-infrared.rules
> +++ b/utils/keytable/70-infrared.rules
> @@ -1,4 +1,12 @@
>  # Automatically load the proper keymaps after the Remote Controller device
>  # creation.  The keycode tables rules should be at /etc/rc_maps.cfg
>  
> -ACTION=="add", SUBSYSTEM=="rc", RUN+="/usr/bin/ir-keytable -a /etc/rc_maps.cfg -s $name"
> +ACTION!="add", SUBSYSTEMS!="rc", GOTO="rc_dev_end"

This line doesn't quite what we want it to do.

As SUBSYSTEMS!="rc" is basically a no-op and would only be
evaluated on change/remove events anyways that line boils down to

ACTION!="add", GOTO="rc_dev_end"

and the following rules are evaluated on all add events.

While that'll still work it'll do unnecessary work, like importing
rc_sydev for all input devices and could bite us (or users) later
if we change/extend the ruleset.

Better do it like in my original comment (using positive logic and
a GOTO="begin") or use ACTION!="add", GOTO="rc_dev_end" and add
SUBSYSTEMS=="rc" to the IMPORT and RUN rules below.

so long,

Hias

> +
> +SUBSYSTEM=="rc", ENV{rc_sysdev}="$name"
> +
> +SUBSYSTEM=="input", IMPORT{parent}="rc_sysdev"
> +
> +KERNEL=="event[0-9]*", ENV{rc_sysdev}=="?*", RUN+="/usr/bin/ir-keytable -a /etc/rc_maps.cfg -s $env{rc_sysdev}"
> +
> +LABEL="rc_dev_end"
> -- 
> 2.11.0
> 
