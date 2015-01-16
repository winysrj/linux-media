Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wg0-f54.google.com ([74.125.82.54]:59322 "EHLO
	mail-wg0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752066AbbAPO2W (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 16 Jan 2015 09:28:22 -0500
Received: by mail-wg0-f54.google.com with SMTP id z12so20797962wgg.13
        for <linux-media@vger.kernel.org>; Fri, 16 Jan 2015 06:28:21 -0800 (PST)
Received: from [192.168.1.5] (52484E89.cm-4-1b.dynamic.ziggo.nl. [82.72.78.137])
        by mx.google.com with ESMTPSA id b13sm3224646wiw.13.2015.01.16.06.28.21
        for <linux-media@vger.kernel.org>
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 16 Jan 2015 06:28:21 -0800 (PST)
Message-ID: <54B92004.1080001@gmail.com>
Date: Fri, 16 Jan 2015 15:28:20 +0100
From: =?windows-1252?Q?Tycho_L=FCrsen?= <tycholursen@gmail.com>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: Re: [PATCH 2/2] si2168: add support for 1.7MHz bandwidth
References: <1421411720-2364-1-git-send-email-olli.salonen@iki.fi> <1421411720-2364-2-git-send-email-olli.salonen@iki.fi>
In-Reply-To: <1421411720-2364-2-git-send-email-olli.salonen@iki.fi>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Olli,
did you commit this anywhere?
Regards,
Tycho.

Op 16-01-15 om 13:35 schreef Olli Salonen:
> This patch is based on Antti's silabs branch.
>
> Add support for 1.7 MHz bandwidth. Supported in all versions of Si2168 according to short data sheets.
>
> Signed-off-by: Olli Salonen <olli.salonen@iki.fi>
> ---
>   drivers/media/dvb-frontends/si2168.c | 2 ++
>   1 file changed, 2 insertions(+)
>
> diff --git a/drivers/media/dvb-frontends/si2168.c b/drivers/media/dvb-frontends/si2168.c
> index 7fef5ab..ec893ee 100644
> --- a/drivers/media/dvb-frontends/si2168.c
> +++ b/drivers/media/dvb-frontends/si2168.c
> @@ -185,6 +185,8 @@ static int si2168_set_frontend(struct dvb_frontend *fe)
>   		dev_err(&client->dev, "automatic bandwidth not supported");
>   		goto err;
>   	}
> +	else if (c->bandwidth_hz <= 2000000)
> +		bandwidth = 0x02;
>   	else if (c->bandwidth_hz <= 5000000)
>   		bandwidth = 0x05;
>   	else if (c->bandwidth_hz <= 6000000)

