Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f193.google.com ([209.85.192.193]:38873 "EHLO
        mail-pf0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751819AbdJAURA (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Sun, 1 Oct 2017 16:17:00 -0400
Received: by mail-pf0-f193.google.com with SMTP id a7so3673308pfj.5
        for <linux-media@vger.kernel.org>; Sun, 01 Oct 2017 13:16:59 -0700 (PDT)
Subject: Re: [PATCH RFC] media: staging/imx: fix complete handler
To: Russell King <rmk+kernel@armlinux.org.uk>
Cc: Philipp Zabel <p.zabel@pengutronix.de>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-media@vger.kernel.org, devel@driverdev.osuosl.org
References: <E1dy2zX-0003NB-5J@rmk-PC.armlinux.org.uk>
From: Steve Longerbeam <slongerbeam@gmail.com>
Message-ID: <9fccea49-c708-325f-bbce-269eecc6f350@gmail.com>
Date: Sun, 1 Oct 2017 13:16:53 -0700
MIME-Version: 1.0
In-Reply-To: <E1dy2zX-0003NB-5J@rmk-PC.armlinux.org.uk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Russell,


On 09/29/2017 02:38 PM, Russell King wrote:
> The complete handler walks all entities, expecting to find an imx
> subdevice for each and every entity.
>
> However, camera drivers such as smiapp can themselves contain multiple
> entities, for which there will not be an imx subdevice.  This causes
> imx_media_find_subdev_by_sd() to fail, making the imx capture system
> unusable with such cameras.
>
> Work around this by killing the error entirely, thereby allowing
> the imx capture to be used with such cameras.

Right, imx_media_add_vdev_to_pa() has followed a link to an
entity that imx is not aware of.

The only effect of this patch (besides allowing the driver to load
with smiapp cameras), is that no controls from the unknown entity
will be inherited to the capture device nodes. That's not a big deal
since the controls presumably can still be accessed from the subdev
node.

However, I still have some concerns about supporting smiapp cameras
in imx-media driver, and that is regarding pad indexes. The smiapp device
that exposes a source pad to the "outside world", which is either the binner
or the scaler entity, has a pad index of 1. But unless the device tree 
port for
the smiapp device is given a reg value of 1 for that port, imx-media
will assume it is pad 0, not 1.

I suppose 'reg = <1>;' for the smiapp source port is a workaround solution,
but I think more needs to be done to recognize smiapp in the imx-media
driver.

Can you please send output of 'media-ctrl --print-dot', I'd like to know 
what
your media graph looks like with smiapp.

Steve

>
> Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
> ---
> Not the best solution, but the only one I can think of to fix the
> regression that happened sometime between a previous revision of
> Steve's patch set and the version that got merged.
>
>   drivers/staging/media/imx/imx-media-dev.c | 7 +++++--
>   1 file changed, 5 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/staging/media/imx/imx-media-dev.c b/drivers/staging/media/imx/imx-media-dev.c
> index d96f4512224f..6ba59939dd7a 100644
> --- a/drivers/staging/media/imx/imx-media-dev.c
> +++ b/drivers/staging/media/imx/imx-media-dev.c
> @@ -345,8 +345,11 @@ static int imx_media_add_vdev_to_pad(struct imx_media_dev *imxmd,
>   
>   	sd = media_entity_to_v4l2_subdev(entity);
>   	imxsd = imx_media_find_subdev_by_sd(imxmd, sd);
> -	if (IS_ERR(imxsd))
> -		return PTR_ERR(imxsd);
> +	if (IS_ERR(imxsd)) {
> +		v4l2_err(&imxmd->v4l2_dev, "failed to find subdev for entity %s, sd %p err %ld\n",
> +			 entity->name, sd, PTR_ERR(imxsd));
> +		return 0;
> +	}
>   
>   	imxpad = &imxsd->pad[srcpad->index];
>   	vdev_idx = imxpad->num_vdevs;
