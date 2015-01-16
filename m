Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-we0-f179.google.com ([74.125.82.179]:32918 "EHLO
	mail-we0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752007AbbAPOcC (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 16 Jan 2015 09:32:02 -0500
Received: by mail-we0-f179.google.com with SMTP id q59so20532802wes.10
        for <linux-media@vger.kernel.org>; Fri, 16 Jan 2015 06:31:59 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1421411720-2364-1-git-send-email-olli.salonen@iki.fi>
References: <1421411720-2364-1-git-send-email-olli.salonen@iki.fi>
From: Prabhakar Lad <prabhakar.csengg@gmail.com>
Date: Fri, 16 Jan 2015 14:31:28 +0000
Message-ID: <CA+V-a8s6A_xon3MPG7o2tv1sFJ4ndZ5XxFNDD-y6JoboyQX3-A@mail.gmail.com>
Subject: Re: [PATCH 1/2] si2168: return error if set_frontend is called with
 invalid parameters
To: Olli Salonen <olli.salonen@iki.fi>
Cc: linux-media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Olli,

Thanks for the patch.

On Fri, Jan 16, 2015 at 12:35 PM, Olli Salonen <olli.salonen@iki.fi> wrote:
> This patch should is based on Antti's silabs branch.
>
> According to dvb-frontend.h set_frontend may be called with bandwidth_hz set to 0 if automatic bandwidth is required. Si2168 does not support automatic bandwidth and does not declare FE_CAN_BANDWIDTH_AUTO in caps.
>
> This patch will change the behaviour in a way that EINVAL is returned if bandwidth_hz is 0.
>
> Cc-to: Antti Palosaari <crope@iki.fi>
> Signed-off-by: Olli Salonen <olli.salonen@iki.fi>
> ---
>  drivers/media/dvb-frontends/si2168.c | 7 ++++++-
>  1 file changed, 6 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/media/dvb-frontends/si2168.c b/drivers/media/dvb-frontends/si2168.c
> index 7f966f3..7fef5ab 100644
> --- a/drivers/media/dvb-frontends/si2168.c
> +++ b/drivers/media/dvb-frontends/si2168.c
> @@ -180,7 +180,12 @@ static int si2168_set_frontend(struct dvb_frontend *fe)
>                 goto err;
>         }
>
> -       if (c->bandwidth_hz <= 5000000)
> +       if (c->bandwidth_hz == 0) {
> +               ret = -EINVAL;
> +               dev_err(&client->dev, "automatic bandwidth not supported");
> +               goto err;
> +       }
> +       else if (c->bandwidth_hz <= 5000000)
>                 bandwidth = 0x05;

Checkpatch should catch it. did you run checkpatch ?

Thanks,
--Prabhakar Lad
