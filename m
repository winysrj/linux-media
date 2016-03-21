Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qk0-f193.google.com ([209.85.220.193]:34678 "EHLO
	mail-qk0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750797AbcCUGjV (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 21 Mar 2016 02:39:21 -0400
Received: by mail-qk0-f193.google.com with SMTP id u128so6724314qkh.1
        for <linux-media@vger.kernel.org>; Sun, 20 Mar 2016 23:39:20 -0700 (PDT)
Received: from mail-qk0-f176.google.com (mail-qk0-f176.google.com. [209.85.220.176])
        by smtp.gmail.com with ESMTPSA id j68sm11621207qge.41.2016.03.20.23.39.19
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 20 Mar 2016 23:39:20 -0700 (PDT)
Received: by mail-qk0-f176.google.com with SMTP id s5so75920103qkd.0
        for <linux-media@vger.kernel.org>; Sun, 20 Mar 2016 23:39:19 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <145833668973.2935.1789623774430960345.stgit@woodpecker.blarg.de>
References: <145833668973.2935.1789623774430960345.stgit@woodpecker.blarg.de>
Date: Mon, 21 Mar 2016 08:39:19 +0200
Message-ID: <CAAZRmGxb8XqOgQtd+kcLCgDi5CypxrikxScC+0MeROYVdLPRNw@mail.gmail.com>
Subject: Re: [PATCH 1/2] media/dvb-core: fix inverted check
From: Olli Salonen <olli.salonen@iki.fi>
To: Max Kellermann <max@duempel.org>
Cc: linux-kernel@vger.kernel.org,
	linux-media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Max,

Already in the tree:
http://git.linuxtv.org/media_tree.git/commit/drivers/media/dvb-core?id=711f3fba6ffd3914fd1b5ed9faf8d22bab6f2203

Cheers,
-olli

On 18 March 2016 at 23:31, Max Kellermann <max@duempel.org> wrote:
> Breakage caused by commit f50d51661a
>
> Signed-off-by: Max Kellermann <max@duempel.org>
> ---
>  drivers/media/dvb-core/dvbdev.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/media/dvb-core/dvbdev.c b/drivers/media/dvb-core/dvbdev.c
> index 560450a..c756d4b 100644
> --- a/drivers/media/dvb-core/dvbdev.c
> +++ b/drivers/media/dvb-core/dvbdev.c
> @@ -682,7 +682,7 @@ int dvb_create_media_graph(struct dvb_adapter *adap,
>         if (demux && ca) {
>                 ret = media_create_pad_link(demux, 1, ca,
>                                             0, MEDIA_LNK_FL_ENABLED);
> -               if (!ret)
> +               if (ret)
>                         return -ENOMEM;
>         }
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
