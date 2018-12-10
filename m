Return-Path: <SRS0=Hr0N=OT=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CB67CC04EB8
	for <linux-media@archiver.kernel.org>; Mon, 10 Dec 2018 12:55:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F308420870
	for <linux-media@archiver.kernel.org>; Mon, 10 Dec 2018 12:55:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=ragnatech-se.20150623.gappssmtp.com header.i=@ragnatech-se.20150623.gappssmtp.com header.b="Ss7SM1Uo"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org F308420870
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=ragnatech.se
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-media-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726684AbeLJMzh (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 10 Dec 2018 07:55:37 -0500
Received: from mail-lj1-f194.google.com ([209.85.208.194]:40858 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726602AbeLJMzg (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 10 Dec 2018 07:55:36 -0500
Received: by mail-lj1-f194.google.com with SMTP id n18-v6so9502762lji.7
        for <linux-media@vger.kernel.org>; Mon, 10 Dec 2018 04:55:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ragnatech-se.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to
         :user-agent;
        bh=PpnsTxmCgeC7qDFBrnZ1AcAbPv31ux4+e6FBlvWI6Qw=;
        b=Ss7SM1UopDhfmZa4L18u7Ql+cYtJU8srBXCR/Q1t28kkKyettz8OGoeiYvjwqBC1JA
         VPa0wBgIfxcfmiBXZ+80gmmPrHqFe8DSycIpknmD0uhmON5Ucsbs+exWNHif4ggr1mtN
         2rcThjDW5TmB7tH0XA6YuOl6Y4G5RVjG2URX8iAzBAlJ7jjmLHZYSDL8BFPOi3l9NgM7
         HVfk9u60ou4JmNj15DvHHp3z5jLCMxwDqrmQ0PIVt8B64X7i8kc9wOTYcXkVwl9NtYVI
         1rppgULc5NGNv+Knirfip3s8PVC9tKrmJgge+6ufj1BFpEO9BrMg/dX3BYEv1CHTwXNe
         jgEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        bh=PpnsTxmCgeC7qDFBrnZ1AcAbPv31ux4+e6FBlvWI6Qw=;
        b=rU6i4wqoLBQeKPA4YzOUsMtXylrET6gNlwdDxFwzDD1BJyBH2vxorYbueNRnF4Ixac
         R9g7yMos2PcymUlHcJLN0fUTrrYL7ey5KMZMiNcCPQgtP+hBlYRm+70teej121DScIA+
         E6Hp8FA3VBqk2WC8+xh1BiDlYRnMNvCvosK6kgEsO+Ir7ZyBDe6VB+H3VeS9/SeD8LZi
         LdRZVtrstI1NiAGlO70cKF0zxoCGT5zPcVw/BcjEeaL2zOFOBekq9IzzjFkFEkA9S9y8
         x15tdUQZVsmSbGKUJtchKE5t11XwejajL+c45W55+V6muypCuinfw7Bk4QlizldMA3AP
         zW8g==
X-Gm-Message-State: AA+aEWbVwbU7SN2Ei7U2x89Xv5djgwfX1QrJGlsRfAY01ODXPtBKxnYD
        E1ihsvXggJ6cpzOoIntS2z2biTq50ac=
X-Google-Smtp-Source: AFSGD/XVLpRLWOJ5f5Up/BdirU+GHCCdmtimyNIApERZHOOQBydwNe4rsLgdwqngoNGAJzwpzMFLNQ==
X-Received: by 2002:a2e:2b85:: with SMTP id r5-v6mr6818083ljr.91.1544446534499;
        Mon, 10 Dec 2018 04:55:34 -0800 (PST)
Received: from localhost (89-233-230-99.cust.bredband2.com. [89.233.230.99])
        by smtp.gmail.com with ESMTPSA id g4-v6sm2172044lji.17.2018.12.10.04.55.33
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 10 Dec 2018 04:55:33 -0800 (PST)
Date:   Mon, 10 Dec 2018 13:55:33 +0100
From:   Niklas =?iso-8859-1?Q?S=F6derlund?= 
        <niklas.soderlund@ragnatech.se>
To:     Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
Cc:     Kieran Bingham <kieran.bingham@ideasonboard.com>,
        linux-renesas-soc@vger.kernel.org, linux-media@vger.kernel.org,
        Jacopo Mondi <jacopo@jmondi.org>,
        Koji Matsuoka <koji.matsuoka.xm@renesas.com>
Subject: Re: [PATCH v2] media: i2c: adv748x: Fix video standard selection
 register setting
Message-ID: <20181210125533.GI17972@bigcity.dyn.berto.se>
References: <20181210122901.14600-1-kieran.bingham+renesas@ideasonboard.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20181210122901.14600-1-kieran.bingham+renesas@ideasonboard.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi Koji-san, Kieran(-san),

Thanks for your work.

On 2018-12-10 12:29:01 +0000, Kieran Bingham wrote:
> From: Koji Matsuoka <koji.matsuoka.xm@renesas.com>
> 
> The ADV7481 Register Control Manual states that bit 2 in the Video
> Standard Selection register is reserved with the value of 1.
> 
> The bit is otherwise undocumented, and currently cleared by the driver
> when setting the video standard selection.
> 
> Define the bit as reserved, and ensure that it is always set when
> writing to the SDP_VID_SEL register.
> 
> Reviewed-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
> Signed-off-by: Koji Matsuoka <koji.matsuoka.xm@renesas.com>
> [Kieran: Updated commit message, utilised BIT macro]
> Signed-off-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
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

Is this really needed? In practice the adv748x driver never touches the 
reserved bit and this special handling *should* not be needed :-)

  #define sdp_clrset(s, r, m, v) sdp_write(s, r, (sdp_read(s, r) & ~m) | v)

The full 'user_map_rw_reg_02' register where the upper 4 bits are 
vid_sel subregister is read and masked. Then the value is updated with 
the new vid_sel value and written back.

However if this is needed or fixes a real bug I'm not against this 
change but in such case I feel the mask should be updated to reflect 
which bits are touched.

>  }
>  
>  static int adv748x_afe_s_input(struct adv748x_afe *afe, unsigned int input)
> diff --git a/drivers/media/i2c/adv748x/adv748x.h b/drivers/media/i2c/adv748x/adv748x.h
> index b482c7fe6957..778aa55a741a 100644
> --- a/drivers/media/i2c/adv748x/adv748x.h
> +++ b/drivers/media/i2c/adv748x/adv748x.h
> @@ -265,6 +265,7 @@ struct adv748x_state {
>  #define ADV748X_SDP_INSEL		0x00	/* user_map_rw_reg_00 */
>  
>  #define ADV748X_SDP_VID_SEL		0x02	/* user_map_rw_reg_02 */
> +#define ADV748X_SDP_VID_RESERVED_BIT	BIT(2)	/* undocumented reserved bit */
>  #define ADV748X_SDP_VID_SEL_MASK	0xf0
>  #define ADV748X_SDP_VID_SEL_SHIFT	4
>  
> -- 
> 2.17.1
> 

-- 
Regards,
Niklas Söderlund
