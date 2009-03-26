Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr15.xs4all.nl ([194.109.24.35]:1601 "EHLO
	smtp-vbr15.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751004AbZCZHYh (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 26 Mar 2009 03:24:37 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: "Udo A. Steinberg" <udo@hypervisor.org>
Subject: Re: [PATCH] Allow the user to restrict the RC5 address
Date: Thu, 26 Mar 2009 08:24:01 +0100
Cc: mchehab@redhat.com, Darron Broad <darron@kewl.org>,
	v4l-dvb-maintainer@linuxtv.org, linux-media@vger.kernel.org,
	Steven Toth <stoth@hauppauge.com>
References: <20090326033453.7d90236d@laptop.hypervisor.org>
In-Reply-To: <20090326033453.7d90236d@laptop.hypervisor.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200903260824.01970.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thursday 26 March 2009 03:34:53 Udo A. Steinberg wrote:
> Mauro,
>
> This patch allows users with multiple remotes to specify an RC5 address
> for a remote from which key codes will be accepted. If no address is
> specified, the default value of 0 accepts key codes from any remote. This
> replaces the current hard-coded address checks, which are too
> restrictive.

I think this should be reviewed by Steve Toth first (CC-ed him).

One thing that this patch breaks is if you have multiple Hauppauge remotes, 
some sending 0x1e, some 0x1f. With this patch I can't use both, only one.

It might be better to have an option to explicitly allow old Hauppauge 
remotes that send 0x00.

Or an heuristic: if you see a remote with device 0x1e or 0x1f, then filter 
remotes with device 0x00 afterwards.

A third option might be to extend the hauppauge option, allowing you to 
specify '2=Old WinTV remote' or something like that, and if set device 0x00 
will be allowed.

Regards,

	Hans

>
>
> Signed-off-by: Udo Steinberg <udo@hypervisor.org>
>
>
> --- linux-2.6.29/drivers/media/video/ir-kbd-i2c.c	2009-03-24
> 00:12:14.000000000 +0100 +++
> linux-2.6.29/drivers/media/video/ir-kbd-i2c.new	2009-03-26
> 03:12:11.000000000 +0100 @@ -58,6 +58,9 @@
>  module_param(hauppauge, int, 0644);    /* Choose Hauppauge remote */
>  MODULE_PARM_DESC(hauppauge, "Specify Hauppauge remote: 0=black, 1=grey
> (defaults to 0)");
>
> +static unsigned int device;
> +module_param(device, uint, 0644);    /* RC5 device address */
> +MODULE_PARM_DESC(device, "Specify device address: 0=any (defaults to
> 0)");
>
>  #define DEVNAME "ir-kbd-i2c"
>  #define dprintk(level, fmt, arg...)	if (debug >= level) \
> @@ -104,8 +107,8 @@
>  		/* invalid key press */
>  		return 0;
>
> -	if (dev!=0x1e && dev!=0x1f)
> -		/* not a hauppauge remote */
> +	if (device && device != dev)
> +		/* not an acceptable remote */
>  		return 0;
>
>  	if (!range)



-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG
