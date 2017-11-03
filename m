Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:52180 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751805AbdKCXl2 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 3 Nov 2017 19:41:28 -0400
Subject: Re: [PATCH v1 15/15] media: i2c: adv748x: Remove duplicate NULL check
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        linux-i2c@vger.kernel.org, Wolfram Sang <wsa@the-dreams.de>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org
References: <20171031142149.32512-1-andriy.shevchenko@linux.intel.com>
 <20171031142149.32512-15-andriy.shevchenko@linux.intel.com>
From: Kieran Bingham <kieran.bingham@ideasonboard.com>
Message-ID: <fe9de50f-aacc-de87-cc6e-81cf32e83756@ideasonboard.com>
Date: Fri, 3 Nov 2017 23:41:25 +0000
MIME-Version: 1.0
In-Reply-To: <20171031142149.32512-15-andriy.shevchenko@linux.intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Andy,

Thankyou for the patch.

On 31/10/17 14:21, Andy Shevchenko wrote:
> Since i2c_unregister_device() became NULL-aware we may remove duplicate
> NULL check.
> 
> Cc: Kieran Bingham <kieran.bingham@ideasonboard.com>
> Cc: Mauro Carvalho Chehab <mchehab@kernel.org>
> Cc: linux-media@vger.kernel.org
> Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

Acked-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>

> ---
>  drivers/media/i2c/adv748x/adv748x-core.c | 6 ++----
>  1 file changed, 2 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/media/i2c/adv748x/adv748x-core.c b/drivers/media/i2c/adv748x/adv748x-core.c
> index 5ee14f2c2747..10c3d469175c 100644
> --- a/drivers/media/i2c/adv748x/adv748x-core.c
> +++ b/drivers/media/i2c/adv748x/adv748x-core.c
> @@ -225,10 +225,8 @@ static void adv748x_unregister_clients(struct adv748x_state *state)
>  {
>  	unsigned int i;
>  
> -	for (i = 1; i < ARRAY_SIZE(state->i2c_clients); ++i) {
> -		if (state->i2c_clients[i])
> -			i2c_unregister_device(state->i2c_clients[i]);
> -	}
> +	for (i = 1; i < ARRAY_SIZE(state->i2c_clients); ++i)
> +		i2c_unregister_device(state->i2c_clients[i]);
>  }
>  
>  static int adv748x_initialise_clients(struct adv748x_state *state)
> 
