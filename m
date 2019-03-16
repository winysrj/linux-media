Return-Path: <SRS0=HTTW=RT=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 88E76C10F03
	for <linux-media@archiver.kernel.org>; Sat, 16 Mar 2019 16:20:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 56E1021900
	for <linux-media@archiver.kernel.org>; Sat, 16 Mar 2019 16:20:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=cogentembedded-com.20150623.gappssmtp.com header.i=@cogentembedded-com.20150623.gappssmtp.com header.b="QHJ8+OCf"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726547AbfCPQUc (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Sat, 16 Mar 2019 12:20:32 -0400
Received: from mail-lf1-f66.google.com ([209.85.167.66]:46372 "EHLO
        mail-lf1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726435AbfCPQUc (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 16 Mar 2019 12:20:32 -0400
Received: by mail-lf1-f66.google.com with SMTP id y62so856651lfc.13
        for <linux-media@vger.kernel.org>; Sat, 16 Mar 2019 09:20:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cogentembedded-com.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:organization:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Owt4aYW2zD2Vd6wLV8Vs4/1YdAdZCWs5zxz8CFAmerE=;
        b=QHJ8+OCfjd9KYCpdlwWg2OdPPvACxP+k4SXbAi0eQwOVbMKQzLvUPN1Z0mKNSurvnl
         mXQ10dyDjjs7gqqXNrw1DP5BVY881pqUXKiq+d8k1sN/cUyL4VLX6sDRQuUVineZW6Qk
         A0tdY5Zsk54l4i+ekeFqr59bLbreedKKOQJQ3Z8y6S19Ix8aAGGpR+cp/++Fak21Zv0F
         8Ornv5Z82u55eHO64ERgNyGDZ7P+mlFfLTuyqjEUVjAY5yR4v9j0fKaCJRzm8UQCwgjD
         2onzxd7w61X93nR0zqxYbDaSHeh0jdHRE1HUmVMA/62hRD+XQQdtVFs/wrkl03vWpSE5
         9vQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:organization
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=Owt4aYW2zD2Vd6wLV8Vs4/1YdAdZCWs5zxz8CFAmerE=;
        b=WKUWlr+5wUNRIZ3rmUrOcNSa3NMoSwt2lXX9W3+02+uJmuVCxZxizgP2UueghMxLNS
         wTMBoHBodUARc09NI3iGpabpcf54I2wC/aPXmjMcMNaqM4RYEHC4Nft/40Fuw/X+qlEs
         YLGz7wctTUuYBPsez3wQ/X0/nzm8OWqohG4jVT7LbLLP4GZnAYAWDJE9BeGoA1BU1mSU
         otz2doUhYhNdy56YezoSHHLWRiPKRBH76bJakeqhKc/TI0TmoFQlwNZ2SXljlek/7EnS
         j7ZQYnipqOPK1SSF50TdSkgb7DMFeiOxR6PIBRhdsv0DWN2obvLgkZqotfFLd1Gi4gde
         h5QA==
X-Gm-Message-State: APjAAAXR82ua/qVRqnZaovGJS1x6EEEguMH3wjrw56t3dfd7kLHixh16
        GRBm3ewoiV6Ls644W6Y6+6OQb+F6bb8=
X-Google-Smtp-Source: APXvYqyv5938t0aghdjuTsf5v70kw+A14gt7kHqfscWi85BZUs7cwf6QEsW2Tv3i6mZlmCizMFfugg==
X-Received: by 2002:a19:6b0f:: with SMTP id d15mr5596323lfa.116.1552753230194;
        Sat, 16 Mar 2019 09:20:30 -0700 (PDT)
Received: from wasted.cogentembedded.com ([31.173.80.77])
        by smtp.gmail.com with ESMTPSA id h125sm1031515lfh.67.2019.03.16.09.20.28
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 16 Mar 2019 09:20:29 -0700 (PDT)
Subject: Re: [RFC 1/5] v4l: subdev: Add MIPI CSI-2 PHY to frame desc
To:     Jacopo Mondi <jacopo+renesas@jmondi.org>,
        sakari.ailus@linux.intel.com, laurent.pinchart@ideasonboard.com,
        niklas.soderlund+renesas@ragnatech.se,
        kieran.bingham@ideasonboard.com
Cc:     linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        dave.stevenson@raspberrypi.org
References: <20190316154801.20460-1-jacopo+renesas@jmondi.org>
 <20190316154801.20460-2-jacopo+renesas@jmondi.org>
From:   Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Organization: Cogent Embedded
Message-ID: <356313ee-2370-e5dc-4c19-2f2c900a410f@cogentembedded.com>
Date:   Sat, 16 Mar 2019 19:20:28 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.2.1
MIME-Version: 1.0
In-Reply-To: <20190316154801.20460-2-jacopo+renesas@jmondi.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-MW
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On 03/16/2019 06:47 PM, Jacopo Mondi wrote:

> Add PHY-specific parameters to MIPI CSI-2 frame descriptor.
> 
> Signed-off-by: Jacopo Mondi <jacopo+renesas@jmondi.org>
> ---
>  include/media/v4l2-subdev.h | 42 +++++++++++++++++++++++++++++++------
>  1 file changed, 36 insertions(+), 6 deletions(-)
> 
> diff --git a/include/media/v4l2-subdev.h b/include/media/v4l2-subdev.h
> index 6311f670de3c..eca9633c83bf 100644
> --- a/include/media/v4l2-subdev.h
> +++ b/include/media/v4l2-subdev.h
[...]
> @@ -371,18 +393,26 @@ enum v4l2_mbus_frame_desc_type {
>  	V4L2_MBUS_FRAME_DESC_TYPE_PLATFORM,
>  	V4L2_MBUS_FRAME_DESC_TYPE_PARALLEL,
>  	V4L2_MBUS_FRAME_DESC_TYPE_CCP2,
> -	V4L2_MBUS_FRAME_DESC_TYPE_CSI2,
> +	V4L2_MBUS_FRAME_DESC_TYPE_CSI2_DPHY,
> +	V4L2_MBUS_FRAME_DESC_TYPE_CSI2_CPHY,
>  };
>  
>  /**
>   * struct v4l2_mbus_frame_desc - media bus data frame description
> - * @type: type of the bus (enum v4l2_mbus_frame_desc_type)
> - * @entry: frame descriptors array
> - * @num_entries: number of entries in @entry array
> + * @type:		type of the bus (enum v4l2_mbus_frame_desc_type)
> + * @entry:		frame descriptors array
> + * @phy:		PHY specific parameters
> + * @phy.dphy:		MIPI D-PHY specific bus configurations
> + * @phy.cphy:		MIPI C-PHY specific bus configurations

   The union members have csi2_ prefix in their names, no? 

> + * @num_entries:	number of entries in @entry array
>   */
>  struct v4l2_mbus_frame_desc {
>  	enum v4l2_mbus_frame_desc_type type;
>  	struct v4l2_mbus_frame_desc_entry entry[V4L2_FRAME_DESC_ENTRY_MAX];
> +	union {
> +		struct v4l2_mbus_frame_desc_entry_csi2_dphy csi2_dphy;
> +		struct v4l2_mbus_frame_desc_entry_csi2_cphy csi2_cphy;
> +	} phy;
>  	unsigned short num_entries;
>  };
>  

