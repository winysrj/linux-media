Return-path: <linux-media-owner@vger.kernel.org>
Received: from zencphosting06.zen.co.uk ([82.71.204.9]:60573 "EHLO
	zencphosting06.zen.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751664AbcF0KpK (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 27 Jun 2016 06:45:10 -0400
Subject: Re: [PATCH] sur40: drop unnecessary format description
To: Hans Verkuil <hverkuil@xs4all.nl>
References: <74bf380b-0c5f-8f55-5340-afd4db77e82e@xs4all.nl>
From: Nick Dyer <nick.dyer@itdev.co.uk>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Florian Echtler <floe@butterbrot.org>
Message-ID: <51805566-c2df-d6b8-5902-d63cbf31a458@itdev.co.uk>
Date: Mon, 27 Jun 2016 11:44:56 +0100
MIME-Version: 1.0
In-Reply-To: <74bf380b-0c5f-8f55-5340-afd4db77e82e@xs4all.nl>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 27/06/2016 11:25, Hans Verkuil wrote:
> Don't fill in the format description. This is now done in the V4L2 core to ensure
> consistent descriptions.
> 
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>

Acked-by: Nick Dyer <nick.dyer@itdev.co.uk>

> 
> diff --git a/drivers/input/touchscreen/sur40.c b/drivers/input/touchscreen/sur40.c
> index 880c40b..5f1617b 100644
> --- a/drivers/input/touchscreen/sur40.c
> +++ b/drivers/input/touchscreen/sur40.c
> @@ -793,7 +793,6 @@ static int sur40_vidioc_enum_fmt(struct file *file, void *priv,
>  {
>  	if (f->index != 0)
>  		return -EINVAL;
> -	strlcpy(f->description, "8-bit greyscale", sizeof(f->description));
>  	f->pixelformat = V4L2_PIX_FMT_GREY;
>  	f->flags = 0;
>  	return 0;
> 
