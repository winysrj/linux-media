Return-path: <linux-media-owner@vger.kernel.org>
Received: from proofpoint-cluster.metrocast.net ([65.175.128.136]:38024 "EHLO
	proofpoint-cluster.metrocast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752578Ab1JOQur (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 15 Oct 2011 12:50:47 -0400
Subject: Re: [git:v4l-dvb/for_v3.2] [media] cx25840: Enable support for
 non-tuner LR1/LR2 audio inputs
From: Andy Walls <awalls@md.metrocast.net>
To: linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: linuxtv-commits@linuxtv.org,
	"Igor M. Liplianin" <liplianin@netup.ru>,
	Steven Toth <stoth@kernellabs.com>
Date: Sat, 15 Oct 2011 12:52:36 -0400
In-Reply-To: <E1REoKF-0005w5-BM@www.linuxtv.org>
References: <E1REoKF-0005w5-BM@www.linuxtv.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Message-ID: <1318697558.3274.13.camel@palomino.walls.org>
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, 2011-10-14 at 22:15 +0200, Mauro Carvalho Chehab wrote:
> This is an automatic generated email to let you know that the following patch were queued at the 
> http://git.linuxtv.org/media_tree.git tree:
> 
> Subject: [media] cx25840: Enable support for non-tuner LR1/LR2 audio inputs
> Author:  Steven Toth <stoth@kernellabs.com>
> Date:    Mon Oct 10 11:09:55 2011 -0300
> 
> The change effects cx23885 boards only and preserves support for existing
> boards. Essentially, if we're using baseband audio into the cx23885 AV
> core then we have to patch registers. The cx23885 driver will call
> with either CX25840_AUDIO8 to signify tuner audio or AUDIO7 to
> signify baseband audio. If/When we become more comfortable with this change
> across a series of products then we may decide to relax the cx23885 only
> restriction.
> 
> [liplianin@netup.ru: fix missing state declaration]
> 
> Signed-off-by: Steven Toth <stoth@kernellabs.com>
> Signed-off-by: Igor M. Liplianin <liplianin@netup.ru>
> Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
> 
>  drivers/media/video/cx25840/cx25840-audio.c |   10 +++++++++-
>  drivers/media/video/cx25840/cx25840-core.c  |   11 +++++++++++
>  2 files changed, 20 insertions(+), 1 deletions(-)
> 
> ---
> 
> http://git.linuxtv.org/media_tree.git?a=commitdiff;h=2ccdd9a59b3a1ff3bd1be6390c4b1989a008e61c
> 
> diff --git a/drivers/media/video/cx25840/cx25840-audio.c b/drivers/media/video/cx25840/cx25840-audio.c
> index 34b96c7..005f110 100644
> --- a/drivers/media/video/cx25840/cx25840-audio.c
> +++ b/drivers/media/video/cx25840/cx25840-audio.c
> @@ -480,6 +480,7 @@ void cx25840_audio_set_path(struct i2c_client *client)
>  
>  static void set_volume(struct i2c_client *client, int volume)
>  {
> +	struct cx25840_state *state = to_state(i2c_get_clientdata(client));
>  	int vol;
>  
>  	/* Convert the volume to msp3400 values (0-127) */
> @@ -495,7 +496,14 @@ static void set_volume(struct i2c_client *client, int volume)
>  	}
>  
>  	/* PATH1_VOLUME */
> -	cx25840_write(client, 0x8d4, 228 - (vol * 2));
> +	if (is_cx2388x(state)) {
> +		/* for cx23885 volume doesn't work,
> +		 * the calculation always results in
> +		 * e4 regardless.
> +		 */
> +		cx25840_write(client, 0x8d4, volume);

Sigh.  All the comments I made in this thread still seem to apply:

http://www.mail-archive.com/linux-media@vger.kernel.org/msg21049.html

In the case of this conditional code branch:

"IIRC the change set also does not have a complementary conditional code
branch when reading out the volume value from the register.  (But I
don't have time to double check that right now [...]"

Regards,
Andy

> +	} else
> +		cx25840_write(client, 0x8d4, 228 - (vol * 2));
>  }
>  
>  static void set_balance(struct i2c_client *client, int balance)
> diff --git a/drivers/media/video/cx25840/cx25840-core.c b/drivers/media/video/cx25840/cx25840-core.c
> index 8896999..0316e41 100644
> --- a/drivers/media/video/cx25840/cx25840-core.c
> +++ b/drivers/media/video/cx25840/cx25840-core.c
> @@ -1074,6 +1074,17 @@ static int set_input(struct i2c_client *client, enum cx25840_video_input vid_inp
>  		cx25840_write(client, 0x919, 0x01);
>  	}
>  
> +	if (is_cx2388x(state) && (aud_input == CX25840_AUDIO7)) {
> +		/* Configure audio from LR1 or LR2 input */
> +		cx25840_write4(client, 0x910, 0);
> +		cx25840_write4(client, 0x8d0, 0x63073);
> +	} else
> +	if (is_cx2388x(state) && (aud_input == CX25840_AUDIO8)) {
> +		/* Configure audio from tuner/sif input */
> +		cx25840_write4(client, 0x910, 0x12b000c9);
> +		cx25840_write4(client, 0x8d0, 0x1f063870);
> +	}
> +
>  	return 0;
>  }
>  
> 
> _______________________________________________
> linuxtv-commits mailing list
> linuxtv-commits@linuxtv.org
> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linuxtv-commits


