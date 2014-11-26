Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lb0-f182.google.com ([209.85.217.182]:37846 "EHLO
	mail-lb0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751139AbaKZMzt (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 26 Nov 2014 07:55:49 -0500
Received: by mail-lb0-f182.google.com with SMTP id f15so2521486lbj.41
        for <linux-media@vger.kernel.org>; Wed, 26 Nov 2014 04:55:47 -0800 (PST)
Message-ID: <5475CDD2.1010104@cogentembedded.com>
Date: Wed, 26 Nov 2014 15:55:46 +0300
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
MIME-Version: 1.0
To: Takanari Hayama <taki@igel.co.jp>, linux-media@vger.kernel.org
CC: linux-sh@vger.kernel.org
Subject: Re: [PATCH 2/2] v4l: vsp1: Always enable virtual RPF when BRU is
 in use
References: <1416982792-11917-1-git-send-email-taki@igel.co.jp> <1416982792-11917-3-git-send-email-taki@igel.co.jp>
In-Reply-To: <1416982792-11917-3-git-send-email-taki@igel.co.jp>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello.

On 11/26/2014 9:19 AM, Takanari Hayama wrote:

> Regardless of a number of inputs, we should always enable virtual RPF
> when BRU is used. This allows the case when there's only one input to
> BRU, and a size of the input is smaller than a size of an output of BRU.

> Signed-off-by: Takanari Hayama <taki@igel.co.jp>
> ---
>   drivers/media/platform/vsp1/vsp1_wpf.c | 11 ++++++-----
>   1 file changed, 6 insertions(+), 5 deletions(-)

> diff --git a/drivers/media/platform/vsp1/vsp1_wpf.c b/drivers/media/platform/vsp1/vsp1_wpf.c
> index 6e05776..29ea28b 100644
> --- a/drivers/media/platform/vsp1/vsp1_wpf.c
> +++ b/drivers/media/platform/vsp1/vsp1_wpf.c
> @@ -92,19 +92,20 @@ static int wpf_s_stream(struct v4l2_subdev *subdev, int enable)
>   		return 0;
>   	}
>
> -	/* Sources. If the pipeline has a single input configure it as the
> -	 * master layer. Otherwise configure all inputs as sub-layers and
> -	 * select the virtual RPF as the master layer.
> +	/* Sources. If the pipeline has a single input and BRU is not used,
> +	 * configure it as the master layer. Otherwise configure all
> +	 * inputs as sub-layers and select the virtual RPF as the master
> +	 * layer.
>   	 */
>   	for (i = 0; i < pipe->num_inputs; ++i) {
>   		struct vsp1_rwpf *input = pipe->inputs[i];
>
> -		srcrpf |= pipe->num_inputs == 1
> +		srcrpf |= ((!pipe->bru) && (pipe->num_inputs == 1))

    Inner parens not needed, especially in the first case.

>   			? VI6_WPF_SRCRPF_RPF_ACT_MST(input->entity.index)
>   			: VI6_WPF_SRCRPF_RPF_ACT_SUB(input->entity.index);
>   	}
>
> -	if (pipe->num_inputs > 1)
> +	if ((pipe->bru) || (pipe->num_inputs > 1))

    Likewise.

[...]

WBR, Sergei

