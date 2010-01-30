Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail1.radix.net ([207.192.128.31]:65052 "EHLO mail1.radix.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753057Ab0A3PM4 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 30 Jan 2010 10:12:56 -0500
Subject: Re: [PATCH] cx25840: Fix composite detection.
From: Andy Walls <awalls@radix.net>
To: Kusanagi Kouichi <slash@ac.auone-net.jp>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
	linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20100110003117.30E3C15C033@msa104.auone-net.jp>
References: <20100110003117.30E3C15C033@msa104.auone-net.jp>
Content-Type: text/plain
Date: Sat, 30 Jan 2010 10:12:28 -0500
Message-Id: <1264864348.4748.16.camel@palomino.walls.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, 2010-01-10 at 09:31 +0900, Kusanagi Kouichi wrote:
> If CX25840_VIN1_CH1 and the like is used, input is not detected as composite.
> 
> Signed-off-by: Kusanagi Kouichi <slash@ac.auone-net.jp>

This patch is fine for fixing the identified problem.  Thanks.

Reviewed-by: Andy Walls <awalls@radix.net>
Acked-by: Andy Walls <awalls@radix.net>

Note: I have not reviewed the correctness of the previous patch that
added component video input.  Not to say that it is right or wrong, just
that I have not reviewed it.


I really need to streamline this set_input() function in cx25840-core.c
module to be more like this version of set_input() the cx18-av-core.c
file:

http://linuxtv.org/hg/~awalls/cx18-pvr2100-component/file/9d3394f49a90/linux/drivers/media/video/cx18/cx18-av-core.c#l570

because the logic in the former is really getting convoluted, making
bugs hard to spot.

Regards,
Andy


> ---
>  drivers/media/video/cx25840/cx25840-core.c |    6 ++----
>  1 files changed, 2 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/media/video/cx25840/cx25840-core.c b/drivers/media/video/cx25840/cx25840-core.c
> index 385ecd5..764c811 100644
> --- a/drivers/media/video/cx25840/cx25840-core.c
> +++ b/drivers/media/video/cx25840/cx25840-core.c
> @@ -734,10 +734,8 @@ static int set_input(struct i2c_client *client, enum cx25840_video_input vid_inp
>  		v4l_dbg(1, cx25840_debug, client, "vid_input 0x%x\n",
>  			vid_input);
>  		reg = vid_input & 0xff;
> -		if ((vid_input & CX25840_SVIDEO_ON) == CX25840_SVIDEO_ON)
> -			is_composite = 0;
> -		else if ((vid_input & CX25840_COMPONENT_ON) == 0)
> -			is_composite = 1;
> +		is_composite = !is_component &&
> +			((vid_input & CX25840_SVIDEO_ON) != CX25840_SVIDEO_ON);
>  
>  		v4l_dbg(1, cx25840_debug, client, "mux cfg 0x%x comp=%d\n",
>  			reg, is_composite);

