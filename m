Return-Path: <SRS0=h5dj=RI=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_NEOMUTT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A50ECC43381
	for <linux-media@archiver.kernel.org>; Tue,  5 Mar 2019 21:25:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7E867204EC
	for <linux-media@archiver.kernel.org>; Tue,  5 Mar 2019 21:25:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726518AbfCEVZL (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 5 Mar 2019 16:25:11 -0500
Received: from gofer.mess.org ([88.97.38.141]:40583 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726214AbfCEVZL (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 5 Mar 2019 16:25:11 -0500
Received: by gofer.mess.org (Postfix, from userid 1000)
        id 5AA2C6031C; Tue,  5 Mar 2019 21:16:48 +0000 (GMT)
Date:   Tue, 5 Mar 2019 21:16:48 +0000
From:   Sean Young <sean@mess.org>
To:     Kangjie Lu <kjlu@umn.edu>
Cc:     pakki001@umn.edu, Mauro Carvalho Chehab <mchehab@kernel.org>,
        Wolfram Sang <wsa@the-dreams.de>,
        Peter Rosin <peda@axentia.se>, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] media: drxk: add a missed check of the return value of
 write16
Message-ID: <20190305211647.srkivgazz37vvfqn@gofer.mess.org>
References: <20181225080308.68178-1-kjlu@umn.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181225080308.68178-1-kjlu@umn.edu>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On Tue, Dec 25, 2018 at 02:03:07AM -0600, Kangjie Lu wrote:
> write16() could fail. The fix inserts a check for its return value
> in case it fails.
> 
> Signed-off-by: Kangjie Lu <kjlu@umn.edu>

Unless it is tested on the actual hardware we can't apply this. This could
introduce regressions.

Sean

> ---
>  drivers/media/dvb-frontends/drxk_hard.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/media/dvb-frontends/drxk_hard.c b/drivers/media/dvb-frontends/drxk_hard.c
> index 84ac3f73f8fe..b7579ffae690 100644
> --- a/drivers/media/dvb-frontends/drxk_hard.c
> +++ b/drivers/media/dvb-frontends/drxk_hard.c
> @@ -6610,7 +6610,9 @@ static int drxk_get_stats(struct dvb_frontend *fe)
>  	if (status < 0)
>  		goto error;
>  	pkt_error_count = reg16;
> -	write16(state, SCU_RAM_FEC_ACCUM_PKT_FAILURES__A, 0);
> +	status = write16(state, SCU_RAM_FEC_ACCUM_PKT_FAILURES__A, 0);
> +	if (status < 0)
> +		goto error;
>  
>  	post_bit_err_count *= post_bit_error_scale;
>  
> -- 
> 2.17.2 (Apple Git-113)
