Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:56240 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751817AbbLFBqP (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 5 Dec 2015 20:46:15 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	devel@driverdev.osuosl.org
Subject: Re: [PATCH v8 37/55] [media] omap4iss: stop MEDIA_ENT_T_V4L2_SUBDEV abuse
Date: Sun, 06 Dec 2015 03:46:28 +0200
Message-ID: <1463986.OOuIkiWRAs@avalon>
In-Reply-To: <ac6f2a7a8afe83affe3b688e8b8f509987a13c96.1440902901.git.mchehab@osg.samsung.com>
References: <cover.1440902901.git.mchehab@osg.samsung.com> <ac6f2a7a8afe83affe3b688e8b8f509987a13c96.1440902901.git.mchehab@osg.samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

Thank you for the patch.

On Sunday 30 August 2015 00:06:48 Mauro Carvalho Chehab wrote:
> This driver is abusing MEDIA_ENT_T_V4L2_SUBDEV, as it uses a
> hack to check if the remote entity is a subdev. Get rid of it.

While I agree with the idea of the patch I don't think this is a hack, it was 
a totally valid implementation with the existing API.

> Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
> 
> diff --git a/drivers/staging/media/omap4iss/iss_ipipe.c
> b/drivers/staging/media/omap4iss/iss_ipipe.c index
> e1a7b7ba7362..eb91ec48a21e 100644
> --- a/drivers/staging/media/omap4iss/iss_ipipe.c
> +++ b/drivers/staging/media/omap4iss/iss_ipipe.c
> @@ -447,8 +447,11 @@ static int ipipe_link_setup(struct media_entity
> *entity, struct iss_ipipe_device *ipipe = v4l2_get_subdevdata(sd);
>  	struct iss_device *iss = to_iss_device(ipipe);
> 
> -	switch (local->index | media_entity_type(remote->entity)) {
> -	case IPIPE_PAD_SINK | MEDIA_ENT_T_V4L2_SUBDEV:
> +	if (!is_media_entity_v4l2_subdev(remote->entity))
> +		return -EINVAL;
> +

Furthermore the ipipe entity is never connected to anything else than a 
subdev, so you can remove this check completely.

I'd rewrite the subject line as "omap4iss: ipipe: Don't check entity type 
needlessly during link setup" and update the commit message accordingly.

> +	switch (local->index) {
> +	case IPIPE_PAD_SINK:
>  		/* Read from IPIPEIF. */
>  		if (!(flags & MEDIA_LNK_FL_ENABLED)) {
>  			ipipe->input = IPIPE_INPUT_NONE;
> @@ -463,7 +466,7 @@ static int ipipe_link_setup(struct media_entity *entity,
> 
>  		break;
> 
> -	case IPIPE_PAD_SOURCE_VP | MEDIA_ENT_T_V4L2_SUBDEV:
> +	case IPIPE_PAD_SOURCE_VP:
>  		/* Send to RESIZER */
>  		if (flags & MEDIA_LNK_FL_ENABLED) {
>  			if (ipipe->output & ~IPIPE_OUTPUT_VP)

-- 
Regards,

Laurent Pinchart

