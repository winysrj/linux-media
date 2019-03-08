Return-Path: <SRS0=k2dg=RL=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D0C4EC43381
	for <linux-media@archiver.kernel.org>; Fri,  8 Mar 2019 02:40:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A98042081B
	for <linux-media@archiver.kernel.org>; Fri,  8 Mar 2019 02:40:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726305AbfCHCka (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 7 Mar 2019 21:40:30 -0500
Received: from smtprelay0078.hostedemail.com ([216.40.44.78]:52549 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726242AbfCHCk3 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 7 Mar 2019 21:40:29 -0500
X-Greylist: delayed 403 seconds by postgrey-1.27 at vger.kernel.org; Thu, 07 Mar 2019 21:40:29 EST
Received: from smtprelay.hostedemail.com (10.5.19.251.rfc1918.com [10.5.19.251])
        by smtpgrave03.hostedemail.com (Postfix) with ESMTP id 77ADD181C9BBA
        for <linux-media@vger.kernel.org>; Fri,  8 Mar 2019 02:33:47 +0000 (UTC)
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay07.hostedemail.com (Postfix) with ESMTP id AEB07181D3403;
        Fri,  8 Mar 2019 02:33:45 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-HE-Tag: voice01_3d2bd574b284c
X-Filterd-Recvd-Size: 2623
Received: from XPS-9350 (unknown [149.142.244.224])
        (Authenticated sender: joe@perches.com)
        by omf15.hostedemail.com (Postfix) with ESMTPA;
        Fri,  8 Mar 2019 02:33:39 +0000 (UTC)
Message-ID: <58d834c0b0aeeb7e551e101a696ab8faf9d41b61.camel@perches.com>
Subject: Re: [PATCH v2 2/6] staging: video: rockchip: add v4l2 decoder
From:   Joe Perches <joe@perches.com>
To:     Randy Li <randy.li@rock-chips.com>, linux-media@vger.kernel.org
Cc:     Randy Li <ayaka@soulik.info>, hverkuil@xs4all.nl,
        maxime.ripard@bootlin.com, joro@8bytes.org,
        linux-kernel@vger.kernel.org, jernej.skrabec@gmail.com,
        nicolas@ndufresne.ca, paul.kocialkowski@bootlin.com,
        linux-rockchip@lists.infradead.org, thomas.petazzoni@bootlin.com,
        mchehab@kernel.org, ezequiel@collabora.com,
        linux-arm-kernel@lists.infradead.org, posciak@chromium.org,
        groeck@chromium.org
Date:   Thu, 07 Mar 2019 18:33:37 -0800
In-Reply-To: <20190307100316.925-3-randy.li@rock-chips.com>
References: <20190307100316.925-1-randy.li@rock-chips.com>
         <20190307100316.925-3-randy.li@rock-chips.com>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.30.1-1build1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On Thu, 2019-03-07 at 18:03 +0800, Randy Li wrote:
> It is based on the vendor driver sent to mail list before.

trivial notes:

> diff --git a/drivers/staging/rockchip-mpp/mpp_debug.h b/drivers/staging/rockchip-mpp/mpp_debug.h
[]
> +#define mpp_debug_func(type, fmt, args...)			\
> +	do {							\
> +		if (unlikely(debug & type)) {			\
> +			pr_info("%s:%d: " fmt,			\
> +				 __func__, __LINE__, ##args);	\
> +		}						\
> +	} while (0)
> +#define mpp_debug(type, fmt, args...)				\
> +	do {							\
> +		if (unlikely(debug & type)) {			\
> +			pr_info(fmt, ##args);			\
> +		}						\
> +	} while (0)
> +

It's generally better to emit debug messages at KERN_DEBUG

> +#define mpp_debug_enter()					\
> +	do {							\
> +		if (unlikely(debug & DEBUG_FUNCTION)) {		\
> +			pr_info("%s:%d: enter\n",		\
> +				 __func__, __LINE__);		\
> +		}						\
> +	} while (0)
> +
> +#define mpp_debug_leave()					\
> +	do {							\
> +		if (unlikely(debug & DEBUG_FUNCTION)) {		\
> +			pr_info("%s:%d: leave\n",		\
> +				 __func__, __LINE__);		\
> +		}						\
> +	} while (0)

I suggest removal of these macros and uses.

There's not much value in enter/leave markings as
the generic ftrace facility does this already.

> +
> +#define mpp_err(fmt, args...)					\
> +		pr_err("%s:%d: " fmt, __func__, __LINE__, ##args)

__func__, __LINE__ markings generally have little value.


