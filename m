Return-Path: <SRS0=uYg5=QR=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6E4A2C4151A
	for <linux-media@archiver.kernel.org>; Sun, 10 Feb 2019 10:57:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3C34F2177B
	for <linux-media@archiver.kernel.org>; Sun, 10 Feb 2019 10:57:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=baylibre-com.20150623.gappssmtp.com header.i=@baylibre-com.20150623.gappssmtp.com header.b="U8m/duy0"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726134AbfBJK5n (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Sun, 10 Feb 2019 05:57:43 -0500
Received: from mail-wm1-f68.google.com ([209.85.128.68]:35181 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726009AbfBJK5m (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 10 Feb 2019 05:57:42 -0500
Received: by mail-wm1-f68.google.com with SMTP id t200so11431634wmt.0
        for <linux-media@vger.kernel.org>; Sun, 10 Feb 2019 02:57:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-transfer-encoding;
        bh=bL53ccFYg2o18JIG+H4Z3TItp8QKfCnm04mqw0DTumM=;
        b=U8m/duy06hjnME/XCippTTlf0nljfERLpKebyze+sgKrwWJ4oGJ59C8lDG+3HtERH+
         ko3NVWHS1HUsRkeak3Wwk+WpysX4ITHIVPkqvg/DAC4iiKTYV+26br9lRVj9/F1rJ+3W
         lEe9fcPcige3WU+bd2aHlpcbSTtnZJ3jxy5fvWn1zRZeE9NjPlA2lSmGWUPD2xLBpV4K
         KtbfRwWJBoBYcNNEAYxO9vnzUY03FvgwlNKgHREq/qrtgrx931MSEOYuU0qzEhbbFW5L
         s6gS1R8NjDlE7S8vjwf9/Nr1Kh1FlPW+nMXxk6g379HqYWvkqoF2y9czcpKkaQuTkcwN
         O7AQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:from:user-agent:mime-version:to
         :cc:subject:references:in-reply-to:content-transfer-encoding;
        bh=bL53ccFYg2o18JIG+H4Z3TItp8QKfCnm04mqw0DTumM=;
        b=ZgAfO5X3aiczpzSHuAJgJlze1smkEFQf9hrtxFooflHsgvCphR+iOMChPcLgt78pQ9
         SW7Z8DpL6GJZ/EXr+Jjye5smBfZy/L4hw9qu/LIMzpRXohWRctlcaNGjJd6C6/rYXjJR
         EwWayoI2g+8+c0CEZDhLkPr7iAkPDiYhAAW3wi81U5mmyyssBRLOLOzUA1eTKgPrpqiR
         wGX/mN01GR5A9YoHiz2CKu8llxp1Jfc21QfgztCdFUOFXGKlhHqvM7jjJNtyd0IlJJTW
         j7JaEtqoveEPTQu2lUZssjOHPScptzurkZTllf8/4/dvo10PoOkYl6wsZ0YLJr24KZzM
         dcXQ==
X-Gm-Message-State: AHQUAuZW33xxbyYLREWyjJUT1EVg1iqx4XpbClCKThOrvvkB/2hmfQy+
        sQzp/b3Mfd1nd1+XWudETHMRNQ==
X-Google-Smtp-Source: AHgI3IZxTUlkCnrreqKuPXdGZy7tBs/HyH/At9cCxqjpL3Oe2U+QuKdJTj/yyjEdl+FIfA6vF2M8Bg==
X-Received: by 2002:a05:6000:8b:: with SMTP id m11mr1384922wrx.243.1549796260348;
        Sun, 10 Feb 2019 02:57:40 -0800 (PST)
Received: from Armstrongs-MacBook-Pro.local (176-150-251-154.abo.bbox.fr. [176.150.251.154])
        by smtp.gmail.com with ESMTPSA id s3sm7595606wmj.23.2019.02.10.02.57.39
        (version=TLS1 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Sun, 10 Feb 2019 02:57:39 -0800 (PST)
Message-ID: <5C6003A2.1000301@baylibre.com>
Date:   Sun, 10 Feb 2019 11:57:38 +0100
From:   Neil Armstrong <narmstrong@baylibre.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.13; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To:     Wen Yang <yellowriver2010@hotmail.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Kevin Hilman <khilman@baylibre.com>
CC:     "linux-media@lists.freedesktop.org" 
        <linux-media@lists.freedesktop.org>,
        "linux-amlogic@lists.infradead.org" 
        <linux-amlogic@lists.infradead.org>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/4] media: platform: meson-ao-cec: fix possible object
 reference leak
References: <HK0PR02MB3634925866F426F86DD213BDB26A0@HK0PR02MB3634.apcprd02.prod.outlook.com>
In-Reply-To: <HK0PR02MB3634925866F426F86DD213BDB26A0@HK0PR02MB3634.apcprd02.prod.outlook.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org



Le 09/02/2019 03:52, Wen Yang a écrit :
> The call to of_parse_phandle() returns a node pointer with refcount
> incremented thus it must be explicitly decremented here after the last
> usage.
> The of_find_device_by_node() takes a reference to the underlying device
> structure, we also should release that reference.
> This patch fixes those two issues.
> 
> Fixes: 7ec2c0f72cb1 ("media: platform: Add Amlogic Meson AO CEC Controller driver")
> Signed-off-by: Wen Yang <yellowriver2010@hotmail.com>
> ---
>  drivers/media/platform/meson/ao-cec.c | 13 ++++++++++---
>  1 file changed, 10 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/media/platform/meson/ao-cec.c b/drivers/media/platform/meson/ao-cec.c
> index cd4be38..8ba8b46 100644
> --- a/drivers/media/platform/meson/ao-cec.c
> +++ b/drivers/media/platform/meson/ao-cec.c
> @@ -613,18 +613,25 @@ static int meson_ao_cec_probe(struct platform_device *pdev)
>  	}
>  
>  	hdmi_dev = of_find_device_by_node(np);
> -	if (hdmi_dev == NULL)
> +	if (hdmi_dev == NULL) {
> +		of_node_put(np);
>  		return -EPROBE_DEFER;
> +	}
>  
> +	of_node_put(np);
>  	ao_cec = devm_kzalloc(&pdev->dev, sizeof(*ao_cec), GFP_KERNEL);
> -	if (!ao_cec)
> +	if (!ao_cec) {
> +		put_device(&hdmi_dev->dev);
>  		return -ENOMEM;
> +	}
>  
>  	spin_lock_init(&ao_cec->cec_reg_lock);
>  
>  	ao_cec->notify = cec_notifier_get(&hdmi_dev->dev);
> -	if (!ao_cec->notify)
> +	if (!ao_cec->notify) {
> +		put_device(&hdmi_dev->dev);
>  		return -ENOMEM;
> +	}
>  
>  	ao_cec->adap = cec_allocate_adapter(&meson_ao_cec_ops, ao_cec,
>  					    "meson_ao_cec",
> 

Acked-by: Neil Armstrong <narmstrong@baylibre.com>

Thanks for the fix !

Neil
