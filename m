Return-Path: <SRS0=3Wpa=PB=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6DD6BC43387
	for <linux-media@archiver.kernel.org>; Mon, 24 Dec 2018 11:23:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3E6A22184C
	for <linux-media@archiver.kernel.org>; Mon, 24 Dec 2018 11:23:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725601AbeLXLXe (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 24 Dec 2018 06:23:34 -0500
Received: from smtp.gentoo.org ([140.211.166.183]:52784 "EHLO smtp.gentoo.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725268AbeLXLXe (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 24 Dec 2018 06:23:34 -0500
Received: from [IPv6:2001:a62:180a:4401:23b6:57c7:ac31:7c25] (unknown [IPv6:2001:a62:180a:4401:23b6:57c7:ac31:7c25])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: zzam)
        by smtp.gentoo.org (Postfix) with ESMTPSA id 2787E335C5D;
        Mon, 24 Dec 2018 11:23:31 +0000 (UTC)
Subject: Re: [PATCH] media: mt312: fix a missing check of mt312 reset
To:     Kangjie Lu <kjlu@umn.edu>
Cc:     pakki001@umn.edu, Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20181221070722.60234-1-kjlu@umn.edu>
From:   Matthias Schwarzott <zzam@gentoo.org>
Message-ID: <4c8a6a16-eced-db2c-2edf-8cdaf0122382@gentoo.org>
Date:   Mon, 24 Dec 2018 12:23:28 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <20181221070722.60234-1-kjlu@umn.edu>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Am 21.12.18 um 08:07 schrieb Kangjie Lu:
> mt312_reset() may fail. Although it is called in the end of
> mt312_set_frontend(), we better check its status and return its error
> code upstream instead of 0.
> 
> Signed-off-by: Kangjie Lu <kjlu@umn.edu>

Thanks for submitting this patch. It looks correct.

Reviewed-by: Matthias Schwarzott <zzam@gentoo.org>

> ---
>  drivers/media/dvb-frontends/mt312.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/media/dvb-frontends/mt312.c b/drivers/media/dvb-frontends/mt312.c
> index 03e74a729168..bfbb879469f2 100644
> --- a/drivers/media/dvb-frontends/mt312.c
> +++ b/drivers/media/dvb-frontends/mt312.c
> @@ -645,7 +645,9 @@ static int mt312_set_frontend(struct dvb_frontend *fe)
>  	if (ret < 0)
>  		return ret;
>  
> -	mt312_reset(state, 0);
> +	ret = mt312_reset(state, 0);
> +	if (ret < 0)
> +		return ret;
>  
>  	return 0;
>  }
> 

