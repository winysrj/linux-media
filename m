Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([213.167.242.64]:40074 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725837AbeJJE2Z (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 10 Oct 2018 00:28:25 -0400
Subject: Re: [PATCH] media: tc358743: Remove unnecessary self assignment
To: Nathan Chancellor <natechancellor@gmail.com>,
        Mats Randgaard <matrandg@cisco.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20181008221128.22510-1-natechancellor@gmail.com>
Reply-To: kieran.bingham+renesas@ideasonboard.com
From: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
Message-ID: <b5f1c169-3770-96a7-cd1a-59939de8064b@ideasonboard.com>
Date: Tue, 9 Oct 2018 22:09:31 +0100
MIME-Version: 1.0
In-Reply-To: <20181008221128.22510-1-natechancellor@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Nathan,

Thank you for the patch,

On 08/10/18 23:11, Nathan Chancellor wrote:
> Clang warns when a variable is assigned to itself.
> 
> drivers/media/i2c/tc358743.c:1921:7: warning: explicitly assigning value
> of variable of type 'int' to itself [-Wself-assign]
>                 ret = ret;
>                 ~~~ ^ ~~~
> 1 warning generated.
> 
> Signed-off-by: Nathan Chancellor <natechancellor@gmail.com>

Certainly somewhat redundant.

Reviewed-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>

> ---
>  drivers/media/i2c/tc358743.c | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/drivers/media/i2c/tc358743.c b/drivers/media/i2c/tc358743.c
> index ca5d92942820..41d470d9ca94 100644
> --- a/drivers/media/i2c/tc358743.c
> +++ b/drivers/media/i2c/tc358743.c
> @@ -1918,7 +1918,6 @@ static int tc358743_probe_of(struct tc358743_state *state)
>  	ret = v4l2_fwnode_endpoint_alloc_parse(of_fwnode_handle(ep), &endpoint);
>  	if (ret) {
>  		dev_err(dev, "failed to parse endpoint\n");
> -		ret = ret;
>  		goto put_node;
>  	}
>  
> 
