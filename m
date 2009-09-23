Return-path: <linux-media-owner@vger.kernel.org>
Received: from bear.ext.ti.com ([192.94.94.41]:46746 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751039AbZIWXlw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 23 Sep 2009 19:41:52 -0400
From: "Hiremath, Vaibhav" <hvaibhav@ti.com>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
CC: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	Roel Kluin <roel.kluin@gmail.com>
Date: Thu, 24 Sep 2009 05:11:32 +0530
Subject: RE: [PATCH] media/tvp514x: recognize the error case in
 tvp514x_read_reg()
Message-ID: <19F8576C6E063C45BE387C64729E73940436C44064@dbde02.ent.ti.com>
References: <20090922183429.GA8585@Chamillionaire.breakpoint.cc>
In-Reply-To: <20090922183429.GA8585@Chamillionaire.breakpoint.cc>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


> -----Original Message-----
> From: Sebastian Andrzej Siewior [mailto:bigeasy@linutronix.de]
> Sent: Wednesday, September 23, 2009 12:04 AM
> To: Mauro Carvalho Chehab
> Cc: linux-media@vger.kernel.org; Hiremath, Vaibhav; Roel Kluin
> Subject: [PATCH] media/tvp514x: recognize the error case in
> tvp514x_read_reg()
> 
> From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
> 
> i2c_smbus_read_byte_data() returns a negative value on error. It is
> very
> likely to be != -1 (-EPERM).
> 
> Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
> ---
> Noticed by strange results during signal beeing pending.
> 
>  drivers/media/video/tvp514x.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/media/video/tvp514x.c
> b/drivers/media/video/tvp514x.c
> index 2443726..26b4e71 100644
> --- a/drivers/media/video/tvp514x.c
> +++ b/drivers/media/video/tvp514x.c
> @@ -272,7 +272,7 @@ static int tvp514x_read_reg(struct v4l2_subdev
> *sd, u8 reg)
>  read_again:
> 
>  	err = i2c_smbus_read_byte_data(client, reg);
> -	if (err == -1) {
> +	if (err < 0) {
>  		if (retry <= I2C_RETRY_COUNT) {
>  			v4l2_warn(sd, "Read: retry ... %d\n", retry);
>  			retry++;
[Hiremath, Vaibhav] Thanks Sebastian, good catch.

Acked by Vaibhav Hiremath.

Hans, can you apply this patch to your tree.

Thanks,
Vaibhav
> --
> 1.6.3.3
> 

