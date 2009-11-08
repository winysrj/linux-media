Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail1.radix.net ([207.192.128.31]:39320 "EHLO mail1.radix.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751821AbZKHBjN (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 7 Nov 2009 20:39:13 -0500
Subject: Re: [PATCH 29/75] cx18: declare MODULE_FIRMWARE
From: Andy Walls <awalls@radix.net>
To: Ben Hutchings <ben@decadent.org.uk>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
	linux-media <linux-media@vger.kernel.org>
In-Reply-To: <1257630681.15927.423.camel@localhost>
References: <1257630681.15927.423.camel@localhost>
Content-Type: text/plain
Date: Sat, 07 Nov 2009 20:40:22 -0500
Message-Id: <1257644422.6895.8.camel@palomino.walls.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, 2009-11-07 at 21:51 +0000, Ben Hutchings wrote:
> Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
> ---
>  drivers/media/video/cx18/cx18-av-firmware.c |    1 +
>  drivers/media/video/cx18/cx18-dvb.c         |    2 ++
>  drivers/media/video/cx18/cx18-firmware.c    |    3 +++
>  3 files changed, 6 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/media/video/cx18/cx18-av-firmware.c b/drivers/media/video/cx18/cx18-av-firmware.c
> index b9e8cc5..137445c 100644
> --- a/drivers/media/video/cx18/cx18-av-firmware.c
> +++ b/drivers/media/video/cx18/cx18-av-firmware.c
> @@ -32,6 +32,7 @@
>  #define CX18_AI1_MUX_INVALID 0x30
>  
>  #define FWFILE "v4l-cx23418-dig.fw"
> +MODULE_FIRMWARE(FWFILE);
>  
>  static int cx18_av_verifyfw(struct cx18 *cx, const struct firmware *fw)
>  {
> diff --git a/drivers/media/video/cx18/cx18-dvb.c b/drivers/media/video/cx18/cx18-dvb.c
> index 51a0c33..9f70168 100644
> --- a/drivers/media/video/cx18/cx18-dvb.c
> +++ b/drivers/media/video/cx18/cx18-dvb.c
> @@ -131,6 +131,8 @@ static int yuan_mpc718_mt352_reqfw(struct cx18_stream *stream,
>  	return ret;
>  }
>  
> +MODULE_FIRMWARE("dvb-cx18-mpc718-mt352.fw");
> +

Ben,

This particular firmware is only needed by one relatively rare TV card.
Is there any way for MODULE_FIRMWARE advertisements to hint at
"mandatory" vs. "particular case(s)"?

Regards,
Andy

>  static int yuan_mpc718_mt352_init(struct dvb_frontend *fe)
>  {
>  	struct cx18_dvb *dvb = container_of(fe->dvb,
> diff --git a/drivers/media/video/cx18/cx18-firmware.c b/drivers/media/video/cx18/cx18-firmware.c
> index 83cd559..4ac4b81 100644
> --- a/drivers/media/video/cx18/cx18-firmware.c
> +++ b/drivers/media/video/cx18/cx18-firmware.c
> @@ -446,3 +446,6 @@ int cx18_firmware_init(struct cx18 *cx)
>  	cx18_write_reg_expect(cx, 0x14001400, 0xc78110, 0x00001400, 0x14001400);
>  	return 0;
>  }
> +
> +MODULE_FIRMWARE("v4l-cx23418-cpu.fw");
> +MODULE_FIRMWARE("v4l-cx23418-apu.fw");

