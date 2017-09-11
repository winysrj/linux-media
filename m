Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:38904 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751078AbdIKTAh (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 11 Sep 2017 15:00:37 -0400
Subject: Re: A patch for a bug in adv748x
To: Simon Yuan <Simon.Yuan@navico.com>,
        =?UTF-8?Q?Niklas_S=c3=b6derlund?= <niklas.soderlund@ragnatech.se>,
        Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Koji Matsuoka <koji.matsuoka.xm@renesas.com>,
        linux-renesas-soc@vger.kernel.org
References: <2665746.VTkvgi0PVy@siyuan>
From: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
Reply-To: kieran.bingham@ideasonboard.com
Message-ID: <30d192d5-adeb-e7b8-2e9c-7ce9a06eb525@ideasonboard.com>
Date: Mon, 11 Sep 2017 20:00:33 +0100
MIME-Version: 1.0
In-Reply-To: <2665746.VTkvgi0PVy@siyuan>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-GB
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Simon,

On 11/09/17 05:30, Simon Yuan wrote:
> Hi Niklas,
>
> How are you doing? I've picked you as my contact since I met you earlier this
> year at ELC2017. Not sure if you still remember, but we had a very brief chat
> about the status of the adv748x driver.

I'll let Niklas reply to this bit :D


> Anyway, the real reason for this email is due to a bug I found in the driver
> while integrating it into our product. I've attached a patch which should be
> self explanatory. If you are the wrong person to contact, feel free to forward
> this email to the right person, or let me know who I should contact.


Thanks for trying out the driver!

You're right, I think you have indeed found a bug - but I'm not certain the fix
is correct...

Comment inline on the patch below...


> I've also made significant changes to the driver in order to satisfy our video
> path requirements. We need to be able to dynamically switch between HDMI/
> composite input connected to TXA.
>
> Is there a plan to make the current driver more flexible? The way I worked
> around the current limitations is by introducing a media_entity for each
> connector (e.g. HDMI and 18 types of analog input) physically connected to the
> video decoder, and dynamically change the internal routing based on the user
> selected connector linked to CP/SDP.

We did try to design the driver such that we could extend the flexibility later,
but have pushed the driver upstream as the current version.

I hope to add CEC, and hotplug support later ... but I don't know when that work
will be scheduled yet. - Of course - I'm happy to review patches :D

> I'm not entirely satisfied with my workaround, so I won't embarrass myself by
> sending a patch for the modified routing scheme.

I would be interested in seeing your implementation, feel free to send off lists
if you prefer :D - I won't judge!

Regards

Kieran




> From 35eea62811d15c096341221c02abab3daadb9a19 Mon Sep 17 00:00:00 2001
> From: Simon Yuan <simon.yuan@navico.com>
> Date: Mon, 11 Sep 2017 16:07:40 +1200
> Subject: [PATCH] media: i2c: adv748x: Map v4l2_std_id to the internal reg
>  value
> 
> The video standard was not mapped to the corresponding value of the
> internal video standard in adv748x_afe_querystd, causing the wrong
> video standard to be selected.
> ---
>  drivers/media/i2c/adv748x/adv748x-afe.c | 7 ++++++-
>  1 file changed, 6 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/media/i2c/adv748x/adv748x-afe.c b/drivers/media/i2c/adv748x/adv748x-afe.c
> index b33ccfc08708..9692e9ea2b70 100644
> --- a/drivers/media/i2c/adv748x/adv748x-afe.c
> +++ b/drivers/media/i2c/adv748x/adv748x-afe.c
> @@ -217,6 +217,7 @@ static int adv748x_afe_querystd(struct v4l2_subdev *sd, v4l2_std_id *std)
>  {
>  	struct adv748x_afe *afe = adv748x_sd_to_afe(sd);
>  	struct adv748x_state *state = adv748x_afe_to_state(afe);
> +	int afe_std;
>  	int ret;
>  
>  	mutex_lock(&state->mutex);
> @@ -235,8 +236,12 @@ static int adv748x_afe_querystd(struct v4l2_subdev *sd, v4l2_std_id *std)
>  	/* Read detected standard */
>  	ret = adv748x_afe_status(afe, NULL, std);
>  
> +	afe_std = adv748x_afe_std(std);

I think this should get the afe_std for the afe->curr_norm. This function should
leave the hardware in the configured state (not the detected state).

If you agree, I'll update the patch and send to the mailinglists for integration.

> +	if (afe_std < 0)
> +		goto unlock;
> +
>  	/* Restore original state */
> -	adv748x_afe_set_video_standard(state, afe->curr_norm);
> +	adv748x_afe_set_video_standard(state, afe_std);
>  
>  unlock:
>  	mutex_unlock(&state->mutex);
> -- 
> 2.14.1



> Best regards,
> Simon
> 
