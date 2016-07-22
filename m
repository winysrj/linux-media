Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lf0-f46.google.com ([209.85.215.46]:35527 "EHLO
	mail-lf0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751124AbcGVTuE (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 22 Jul 2016 15:50:04 -0400
Received: by mail-lf0-f46.google.com with SMTP id f93so92475710lfi.2
        for <linux-media@vger.kernel.org>; Fri, 22 Jul 2016 12:50:03 -0700 (PDT)
Subject: Re: [PATCH v6 1/4] media: adv7604: automatic "default-input"
 selection
To: Ulrich Hecht <ulrich.hecht+renesas@gmail.com>,
	hans.verkuil@cisco.com, niklas.soderlund@ragnatech.se
References: <1469178554-20719-1-git-send-email-ulrich.hecht+renesas@gmail.com>
 <1469178554-20719-2-git-send-email-ulrich.hecht+renesas@gmail.com>
Cc: linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
	magnus.damm@gmail.com, laurent.pinchart@ideasonboard.com,
	william.towle@codethink.co.uk, geert@linux-m68k.org
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Message-ID: <42f525c3-9d1c-80c4-0e9f-b8242484ffc7@cogentembedded.com>
Date: Fri, 22 Jul 2016 22:50:00 +0300
MIME-Version: 1.0
In-Reply-To: <1469178554-20719-2-git-send-email-ulrich.hecht+renesas@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 07/22/2016 12:09 PM, Ulrich Hecht wrote:

> Fall back to input 0 if "default-input" property is not present.
>
> Additionally, documentation in commit bf9c82278c34 ("[media]
> media: adv7604: ability to read default input port from DT") states
> that the "default-input" property should reside directly in the node
> for adv7612. Hence, also adjust the parsing to make the implementation
> consistent with this.
>
> Based on patch by William Towle <william.towle@codethink.co.uk>.
>
> Signed-off-by: Ulrich Hecht <ulrich.hecht+renesas@gmail.com>
> ---
>  drivers/media/i2c/adv7604.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/media/i2c/adv7604.c b/drivers/media/i2c/adv7604.c
> index 4003831..055c9df 100644
> --- a/drivers/media/i2c/adv7604.c
> +++ b/drivers/media/i2c/adv7604.c
> @@ -3077,10 +3077,13 @@ static int adv76xx_parse_dt(struct adv76xx_state *state)
>  	if (!of_property_read_u32(endpoint, "default-input", &v))
>  		state->pdata.default_input = v;
>  	else
> -		state->pdata.default_input = -1;
> +		state->pdata.default_input = 0;
>
>  	of_node_put(endpoint);
>
> +	if (!of_property_read_u32(np, "default-input", &v))
> +		state->pdata.default_input = v;

	of_property_read_u32(np, "default-input",
			     &state->pdata.default_input));

should be equivalent...

MBR, Sergei

