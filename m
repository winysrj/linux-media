Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.horus.com ([78.46.148.228]:47232 "EHLO mail.horus.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753614AbdHUT2I (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 21 Aug 2017 15:28:08 -0400
Date: Mon, 21 Aug 2017 21:28:06 +0200
From: Matthias Reichl <hias@horus.com>
To: Sean Young <sean@mess.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        linux-media@vger.kernel.org
Subject: Re: [PATCH] keytable: ensure udev rule fires on rc input device
Message-ID: <20170821192805.73f264uf3gre3eqw@lenny.lan>
References: <20170717092038.3e7jbjtx7htu3lda@camel2.lan>
 <20170805213802.ni42iaht5rf5rye2@gofer.mess.org>
 <20170806085655.dkaq7hqpyzrc3abj@gofer.mess.org>
 <20170807070926.hvj5qvqb34xb2x3k@camel2.lan>
 <20170816165625.3554yrommvthkscq@gofer.mess.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170816165625.3554yrommvthkscq@gofer.mess.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sean!

On Wed, Aug 16, 2017 at 05:56:25PM +0100, Sean Young wrote:
> I've found a shorter way of doing this.

That's a really clever trick of dealing with the RUN/$id issue,
I like it a lot!

> ----
> From: Sean Young <sean@mess.org>
> Date: Wed, 16 Aug 2017 17:41:53 +0100
> Subject: [PATCH] keytable: ensure the udev rule fires on creation of the input
>  device
> 
> The rc device is created before the input device, so if ir-keytable runs
> too early the input device does not exist yet.
> 
> Ensure that rule fires on creation of a rc device's input device.
> 
> Note that this also prevents udev from starting ir-keytable on an
> transmit only device, which has no input device.
> 
> Note that $id in RUN will not work, since that is expanded after all the
> rules are matched, at which point the the parent might have been changed
> by another match in another rule. The argument to $env{key} is expanded
> immediately.
> 
> Signed-off-by: Sean Young <sean@mess.org>

Tested-by: Matthias Reichl <hias@horus.com>

so long & thanks for the fix,

Hias
> ---
>  utils/keytable/70-infrared.rules | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/utils/keytable/70-infrared.rules b/utils/keytable/70-infrared.rules
> index afffd951..41ca2089 100644
> --- a/utils/keytable/70-infrared.rules
> +++ b/utils/keytable/70-infrared.rules
> @@ -1,4 +1,4 @@
>  # Automatically load the proper keymaps after the Remote Controller device
>  # creation.  The keycode tables rules should be at /etc/rc_maps.cfg
>  
> -ACTION=="add", SUBSYSTEM=="rc", RUN+="/usr/bin/ir-keytable -a /etc/rc_maps.cfg -s $name"
> +ACTION=="add", SUBSYSTEM=="input", SUBSYSTEMS=="rc", KERNEL=="event*", ENV{.rc_sysdev}="$id", RUN+="/usr/bin/ir-keytable -a /etc/rc_maps.cfg -s $env{.rc_sysdev}"
> -- 
> 2.13.5
> 
