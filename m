Return-Path: <SRS0=Hr0N=OT=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E9B7DC04EB8
	for <linux-media@archiver.kernel.org>; Mon, 10 Dec 2018 12:29:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A9737208E7
	for <linux-media@archiver.kernel.org>; Mon, 10 Dec 2018 12:29:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=ideasonboard.com header.i=@ideasonboard.com header.b="GoFoFElq"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A9737208E7
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=ideasonboard.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-media-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727342AbeLJM3g (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 10 Dec 2018 07:29:36 -0500
Received: from perceval.ideasonboard.com ([213.167.242.64]:56752 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726324AbeLJM3g (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 10 Dec 2018 07:29:36 -0500
Received: from [192.168.0.21] (cpc89242-aztw30-2-0-cust488.18-1.cable.virginm.net [86.31.129.233])
        by perceval.ideasonboard.com (Postfix) with ESMTPSA id B0967549;
        Mon, 10 Dec 2018 13:29:33 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ideasonboard.com;
        s=mail; t=1544444973;
        bh=CWoNrhHRn+mcI7duoTPlwJQMiFvrA5mE8wp6D2YyN6Y=;
        h=Subject:From:To:Cc:References:Reply-To:Date:In-Reply-To:From;
        b=GoFoFElqJHnjxnEZDYaF2GJW4LY/zsdvQjFz5K5pFTd8YlADwzviDIzaTXBnzwLfl
         2tYVV/i3zvq4oVOg+wgZMAbyagw31IUV2R/9MZY/88ctKwUTqVjDGZcf1qTeE728Nw
         MhKup/7KuIKckEWsy+BtjAQ8JTg+TXUtiUNBe2hs=
Subject: Re: [PATCH] media: i2c: adv748x: Fix video standard selection
 register setting
From:   Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
To:     linux-renesas-soc@vger.kernel.org, linux-media@vger.kernel.org
Cc:     Koji Matsuoka <koji.matsuoka.xm@renesas.com>
References: <20181210120755.12966-1-kieran.bingham+renesas@ideasonboard.com>
Reply-To: kieran.bingham+renesas@ideasonboard.com
Openpgp: preference=signencrypt
Organization: Ideas on Board
Message-ID: <7f9d19bc-f5db-ef3a-03aa-4b4d72f279cd@ideasonboard.com>
Date:   Mon, 10 Dec 2018 12:29:30 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.2.1
MIME-Version: 1.0
In-Reply-To: <20181210120755.12966-1-kieran.bingham+renesas@ideasonboard.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi Matsuoka-san,

Thank you for the patch,

On 10/12/2018 12:07, Kieran Bingham wrote:
> From: Koji Matsuoka <koji.matsuoka.xm@renesas.com>
> 
> By video decoder user's manual, the bit 2 in Video Standard
> Selection register must be reserved with the value of 1.
> This driver cleared it with 0 when writing back.
> This patch corrects it.

I could not find this reference directly in the decoders hardware manual
- but the bit is present in the user guide shown only as bit set by
default, and otherwise undocumented.

I'll update the commit message here to clarify things.


> Signed-off-by: Koji Matsuoka <koji.matsuoka.xm@renesas.com>
> ---
>  drivers/media/i2c/adv748x/adv748x-afe.c | 3 ++-
>  drivers/media/i2c/adv748x/adv748x.h     | 1 +
>  2 files changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/media/i2c/adv748x/adv748x-afe.c b/drivers/media/i2c/adv748x/adv748x-afe.c
> index 71714634efb0..c4d9ffc50702 100644
> --- a/drivers/media/i2c/adv748x/adv748x-afe.c
> +++ b/drivers/media/i2c/adv748x/adv748x-afe.c
> @@ -151,7 +151,8 @@ static void adv748x_afe_set_video_standard(struct adv748x_state *state,
>  					  int sdpstd)
>  {
>  	sdp_clrset(state, ADV748X_SDP_VID_SEL, ADV748X_SDP_VID_SEL_MASK,
> -		   (sdpstd & 0xf) << ADV748X_SDP_VID_SEL_SHIFT);
> +		   (sdpstd & 0xf) << ADV748X_SDP_VID_SEL_SHIFT |
> +		   ADV748X_SDP_VID_RESERVED_BIT);
>  }
>  
>  static int adv748x_afe_s_input(struct adv748x_afe *afe, unsigned int input)
> diff --git a/drivers/media/i2c/adv748x/adv748x.h b/drivers/media/i2c/adv748x/adv748x.h
> index b482c7fe6957..f1f513f4327b 100644
> --- a/drivers/media/i2c/adv748x/adv748x.h
> +++ b/drivers/media/i2c/adv748x/adv748x.h
> @@ -265,6 +265,7 @@ struct adv748x_state {
>  #define ADV748X_SDP_INSEL		0x00	/* user_map_rw_reg_00 */
>  
>  #define ADV748X_SDP_VID_SEL		0x02	/* user_map_rw_reg_02 */
> +#define ADV748X_SDP_VID_RESERVED_BIT	0x04

For a 'bit' I would rather use the BIT(n) macro.

I'll update here, and add a comment stating that this bit is otherwise
undocumented.

>  #define ADV748X_SDP_VID_SEL_MASK	0xf0
>  #define ADV748X_SDP_VID_SEL_SHIFT	4

--
Regards

Kieran

