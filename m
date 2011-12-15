Return-path: <linux-media-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:37700 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757339Ab1LOKMQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 15 Dec 2011 05:12:16 -0500
Message-ID: <4EE9C7FA.8070607@infradead.org>
Date: Thu, 15 Dec 2011 08:12:10 -0200
From: Mauro Carvalho Chehab <mchehab@infradead.org>
MIME-Version: 1.0
To: Javier Martin <javier.martin@vista-silicon.com>
CC: linux-media@vger.kernel.org, hverkuil@xs4all.nl
Subject: Re: [PATCH 1/2] media: tvp5150 Fix default input selection.
References: <1323941987-23428-1-git-send-email-javier.martin@vista-silicon.com>
In-Reply-To: <1323941987-23428-1-git-send-email-javier.martin@vista-silicon.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 15-12-2011 07:39, Javier Martin wrote:
> In page 23 of the datasheet of this chip (SLES098A)
> it is stated that de default input for this chip
> is Composite AIP1A which is the same as COMPOSITE0
> in the driver.
> 
> Signed-off-by: Javier Martin <javier.martin@vista-silicon.com>
> ---
>  drivers/media/video/tvp5150.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/media/video/tvp5150.c b/drivers/media/video/tvp5150.c
> index e927d25..26cc75b 100644
> --- a/drivers/media/video/tvp5150.c
> +++ b/drivers/media/video/tvp5150.c
> @@ -993,7 +993,7 @@ static int tvp5150_probe(struct i2c_client *c,
>  	}
>  
>  	core->norm = V4L2_STD_ALL;	/* Default is autodetect */
> -	core->input = TVP5150_COMPOSITE1;
> +	core->input = TVP5150_COMPOSITE0;
>  	core->enable = 1;
>  
>  	v4l2_ctrl_handler_init(&core->hdl, 4);

Changing this could break em28xx that might be expecting it
to be set to composite1. On a quick look, the code there seems to be
doing the right thing: during the probe procedure, it explicitly 
calls s_routing, in order to initialize the device input to the
first input type found at the cards structure. So, this patch
is likely harmless.

Yet, why do you need to change it? Any bridge driver that uses it should
be doing the same: at initialization, it should set the input to a
value that it is compatible with the way the device is wired, and not
to assume a particular arrangement.

Regards,
Mauro

