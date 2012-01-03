Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:46268 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751462Ab2ACIig (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 3 Jan 2012 03:38:36 -0500
Message-ID: <4F02BEC5.2080204@redhat.com>
Date: Tue, 03 Jan 2012 09:39:33 +0100
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: Vasily Khoruzhick <anarsoul@gmail.com>
CC: Hans de Goede <j.w.r.degoede@hhs.nl>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH] libv4l: add hflip quirk for dealextreme cam sku #44507
References: <1325535901-15251-1-git-send-email-anarsoul@gmail.com>
In-Reply-To: <1325535901-15251-1-git-send-email-anarsoul@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,


Thanks for the patch.

I'm sorry, but a quick google shows that your cam has a usb id used by various generic
cameras, including some microscopes, see:
http://blog.littleimpact.de/index.php/2011/10/16/using-biolux-nv-on-ubuntu-linux/

Enabling flipping on all these models because one has the sensor mounted upside down
is the wrong thing to do.

Instead you could add the following to your /etc/profile
export LIBV4LCONTROL_FLAGS=3

Note this will flip the image from all cameras you plug into your computer, or you
can keep a patched libv4l around for yourself.

Regards,

Hans


On 01/02/2012 09:25 PM, Vasily Khoruzhick wrote:
> Signed-off-by: Vasily Khoruzhick<anarsoul@gmail.com>
> ---
>   lib/libv4lconvert/control/libv4lcontrol.c |    2 ++
>   1 files changed, 2 insertions(+), 0 deletions(-)
>
> diff --git a/lib/libv4lconvert/control/libv4lcontrol.c b/lib/libv4lconvert/control/libv4lcontrol.c
> index 12fa874..a9908ac 100644
> --- a/lib/libv4lconvert/control/libv4lcontrol.c
> +++ b/lib/libv4lconvert/control/libv4lcontrol.c
> @@ -51,6 +51,8 @@ static const struct v4lcontrol_flags_info v4lcontrol_flags[] = {
>   	/* Genius E-M 112 (also want whitebalance by default) */
>   	{ 0x093a, 0x2476, 0, NULL, NULL,
>   		V4LCONTROL_HFLIPPED|V4LCONTROL_VFLIPPED | V4LCONTROL_WANTS_WB, 1500 },
> +	/* uvc-compatible cam from dealextreme (sku #44507) */
> +	{ 0x18ec, 0x3366, 0, NULL, NULL, V4LCONTROL_HFLIPPED },
>
>   	/* Laptops (and all in one PC's) */
>   	{ 0x0402, 0x5606, 0,
