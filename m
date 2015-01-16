Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f177.google.com ([209.85.212.177]:42064 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751819AbbAPU15 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 16 Jan 2015 15:27:57 -0500
Received: by mail-wi0-f177.google.com with SMTP id l15so6204565wiw.4
        for <linux-media@vger.kernel.org>; Fri, 16 Jan 2015 12:27:56 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1421411720-2364-2-git-send-email-olli.salonen@iki.fi>
References: <1421411720-2364-1-git-send-email-olli.salonen@iki.fi> <1421411720-2364-2-git-send-email-olli.salonen@iki.fi>
From: Prabhakar Lad <prabhakar.csengg@gmail.com>
Date: Fri, 16 Jan 2015 20:20:48 +0000
Message-ID: <CA+V-a8vVCqT6Gnm0hJXSUewgfAcmYAzMfhr76L2Mp3RnK28E=A@mail.gmail.com>
Subject: Re: [PATCH 2/2] si2168: add support for 1.7MHz bandwidth
To: Olli Salonen <olli.salonen@iki.fi>
Cc: linux-media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Olli,

Thanks for the patch.


On Fri, Jan 16, 2015 at 12:35 PM, Olli Salonen <olli.salonen@iki.fi> wrote:
> This patch is based on Antti's silabs branch.
>
> Add support for 1.7 MHz bandwidth. Supported in all versions of Si2168 according to short data sheets.
>
> Signed-off-by: Olli Salonen <olli.salonen@iki.fi>
> ---
>  drivers/media/dvb-frontends/si2168.c | 2 ++
>  1 file changed, 2 insertions(+)
>
> diff --git a/drivers/media/dvb-frontends/si2168.c b/drivers/media/dvb-frontends/si2168.c
> index 7fef5ab..ec893ee 100644
> --- a/drivers/media/dvb-frontends/si2168.c
> +++ b/drivers/media/dvb-frontends/si2168.c
> @@ -185,6 +185,8 @@ static int si2168_set_frontend(struct dvb_frontend *fe)
>                 dev_err(&client->dev, "automatic bandwidth not supported");
>                 goto err;
>         }
> +       else if (c->bandwidth_hz <= 2000000)
> +               bandwidth = 0x02;

Please fix checkpatch errors for this patch aswel.

Thanks,
--Prabhakar Lad
