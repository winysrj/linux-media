Return-Path: <SRS0=SCQz=PT=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BFBB4C43612
	for <linux-media@archiver.kernel.org>; Fri, 11 Jan 2019 16:05:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9216320872
	for <linux-media@archiver.kernel.org>; Fri, 11 Jan 2019 16:05:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=ideasonboard.com header.i=@ideasonboard.com header.b="Qx04Plum"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387540AbfAKQFM (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Fri, 11 Jan 2019 11:05:12 -0500
Received: from perceval.ideasonboard.com ([213.167.242.64]:60242 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1733300AbfAKQFL (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 11 Jan 2019 11:05:11 -0500
Received: from [192.168.0.21] (cpc89242-aztw30-2-0-cust488.18-1.cable.virginm.net [86.31.129.233])
        by perceval.ideasonboard.com (Postfix) with ESMTPSA id F072753E;
        Fri, 11 Jan 2019 17:05:08 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ideasonboard.com;
        s=mail; t=1547222709;
        bh=pCgoOzGHudZ69hwUuphHiGdBqakqqjNVCY4Cgc+8CMk=;
        h=Reply-To:Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=Qx04Plumau0TxEEIhB0mIJ2feSFwhbiS/Bixn3T/x5aIK0Rn2DFC0ukElsJT0/XmP
         DRxTE5en8b56/1A0LQMldW3Ee6qkvbkhPxBnJSZrCpwmBg2xpzXZEyNHzt1vzPiyVv
         8stIggm7qvdzL4F6aDzH4FWyiB8Lk9Fm0X6sEZV0=
Reply-To: kieran.bingham+renesas@ideasonboard.com
Subject: Re: [PATCH 1/2] media: i2c: adv7482: Fix wait procedure usleep_range
 from msleep
To:     linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org
Cc:     Koji Matsuoka <koji.matsuoka.xm@renesas.com>,
        Steve Longerbeam <steve_longerbeam@mentor.com>
References: <20190111154345.29145-1-kieran.bingham+renesas@ideasonboard.com>
From:   Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
Organization: Ideas on Board
Message-ID: <a57f0125-ead6-b190-c2f5-643cddf42504@ideasonboard.com>
Date:   Fri, 11 Jan 2019 16:05:07 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.2.1
MIME-Version: 1.0
In-Reply-To: <20190111154345.29145-1-kieran.bingham+renesas@ideasonboard.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi Matsuoka-san,

Thank you for the patch,

On 11/01/2019 15:43, Kieran Bingham wrote:>
> From: Koji Matsuoka <koji.matsuoka.xm@renesas.com>
>
> By Documentation/timers/timers-howto.txt, when waiting 20ms from 10us,
> it is correct to use usleep_range. this patch corrects it.
>
> Signed-off-by: Koji Matsuoka <koji.matsuoka.xm@renesas.com>
> (cherry picked from horms/renesas-bsp commit
af0cdba377bc8a784cdae6a77fb7a822cebc7083)
> Signed-off-by: Steve Longerbeam <steve_longerbeam@mentor.com>
> ---
>  drivers/media/i2c/adv748x/adv748x-core.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/media/i2c/adv748x/adv748x-core.c
b/drivers/media/i2c/adv748x/adv748x-core.c
> index 64eb1bfda581..097e5c3a8e7e 100644
> --- a/drivers/media/i2c/adv748x/adv748x-core.c
> +++ b/drivers/media/i2c/adv748x/adv748x-core.c
> @@ -273,7 +273,8 @@ static int adv748x_write_regs(struct adv748x_state
*state,
>
>  	while (regs->page != ADV748X_PAGE_EOR) {
>  		if (regs->page == ADV748X_PAGE_WAIT) {
> -			msleep(regs->value);
> +			usleep_range(regs->value * 1000,
> +				     (regs->value * 1000) + 1000);

I might propose simplifying this by moving the duplicated multiplication
to a local variable:

  		if (regs->page == ADV748X_PAGE_WAIT) {
			unsigned int usec = regs->value * 1000;
			usleep_range(usec, usec + 1000);
		} ...


There are three other usages of usleep_range in the driver which utilise
a 500 uSec range rather than 1000. However I don't see any real reason
to object to a range of 1000 and it will help the scheduling to be a bit
more relaxed.



In fact, It seems there is only a single usage of ADV748X_PAGE_WAIT ...
to perform a sw-reset, and that itself only has 3 register writes.

As part of the ongoing aim to remove the register tables from this code
- I think I will drop this patch and submit an alternative which
implements a function to handle the sw_reset, and removes all references
to ADV748X_PAGE_WAIT.

The PAGE_WAIT feels like a bit of an ugly hack due to the tables and I
think we can let it go.


>  		} else {
>  			ret = adv748x_write(state, regs->page, regs->reg,
>  				      regs->value);
>

Regards

Kieran

