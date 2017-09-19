Return-path: <linux-media-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:19948 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750952AbdISImg (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 19 Sep 2017 04:42:36 -0400
Date: Tue, 19 Sep 2017 11:42:16 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: SF Markus Elfring <elfring@users.sourceforge.net>
Cc: linux-media@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 4/6] [media] go7007: Use common error handling code in
 s2250_probe()
Message-ID: <20170919084216.ctvwpmswr3ckhwzc@mwanda>
References: <b36ece3f-0f31-9bb6-14ae-c4abf7cd23ee@users.sourceforge.net>
 <c4d2e584-39ca-6e30-43ee-56088905149e@users.sourceforge.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c4d2e584-39ca-6e30-43ee-56088905149e@users.sourceforge.net>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Sep 18, 2017 at 03:57:21PM +0200, SF Markus Elfring wrote:
> From: Markus Elfring <elfring@users.sourceforge.net>
> Date: Mon, 18 Sep 2017 13:50:45 +0200
> 
> Adjust jump targets so that a bit of exception handling can be better
> reused at the end of this function.
> 
> This refactoring might fix also an error situation where the
> function "i2c_unregister_device" was not called after a software failure
> was noticed by the data member "hdl.error".
> 
> Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
> ---
>  drivers/media/usb/go7007/s2250-board.c | 37 +++++++++++++++++-----------------
>  1 file changed, 18 insertions(+), 19 deletions(-)
> 
> diff --git a/drivers/media/usb/go7007/s2250-board.c b/drivers/media/usb/go7007/s2250-board.c
> index 1fd4c09dd516..1bd9a7f2e7a3 100644
> --- a/drivers/media/usb/go7007/s2250-board.c
> +++ b/drivers/media/usb/go7007/s2250-board.c
> @@ -510,6 +510,7 @@ static int s2250_probe(struct i2c_client *client,
>  	u8 *data;
>  	struct go7007 *go = i2c_get_adapdata(adapter);
>  	struct go7007_usb *usb = go->hpi_context;
> +	int code;

It should be called "int rc" to match the rest of the driver.  "ret" or
"err" would also have been acceptable.

>  
>  	audio = i2c_new_dummy(adapter, TLV320_ADDRESS >> 1);
>  	if (!audio)
> @@ -517,8 +518,8 @@ static int s2250_probe(struct i2c_client *client,
>  
>  	state = kzalloc(sizeof(*state), GFP_KERNEL);
>  	if (!state) {
> -		i2c_unregister_device(audio);
> -		return -ENOMEM;
> +		code = -ENOMEM;
> +		goto unregister_device;
>  	}
>  
>  	sd = &state->sd;
> @@ -538,11 +539,8 @@ static int s2250_probe(struct i2c_client *client,
>  		V4L2_CID_HUE, -512, 511, 1, 0);
>  	sd->ctrl_handler = &state->hdl;
>  	if (state->hdl.error) {
> -		int err = state->hdl.error;
> -
> -		v4l2_ctrl_handler_free(&state->hdl);
> -		kfree(state);
> -		return err;
> +		code = state->hdl.error;
> +		goto free_handler;
>  	}
>  
>  	state->std = V4L2_STD_NTSC;
> @@ -555,17 +553,13 @@ static int s2250_probe(struct i2c_client *client,
>  	/* initialize the audio */
>  	if (write_regs(audio, aud_regs) < 0) {
>  		dev_err(&client->dev, "error initializing audio\n");
> -		goto fail;
> +		goto e_io;

Preserve the error code.

regards,
dan carpenter
