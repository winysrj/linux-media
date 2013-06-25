Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:50186 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752163Ab3FYLYR (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 25 Jun 2013 07:24:17 -0400
Received: by mail-ob0-f174.google.com with SMTP id wd20so11987325obb.33
        for <linux-media@vger.kernel.org>; Tue, 25 Jun 2013 04:24:17 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1372157835-27663-5-git-send-email-arun.kk@samsung.com>
References: <1372157835-27663-1-git-send-email-arun.kk@samsung.com>
	<1372157835-27663-5-git-send-email-arun.kk@samsung.com>
Date: Tue, 25 Jun 2013 16:54:17 +0530
Message-ID: <CAK9yfHy3uzCn0GhU6d5CcFLw=VXeHVZukJAK_cmgFkJG6iiGeA@mail.gmail.com>
Subject: Re: [PATCH v3 4/8] [media] s5p-mfc: Core support for MFC v7
From: Sachin Kamat <sachin.kamat@linaro.org>
To: Arun Kumar K <arun.kk@samsung.com>
Cc: linux-media@vger.kernel.org, k.debski@samsung.com,
	jtp.park@samsung.com, s.nawrocki@samsung.com, hverkuil@xs4all.nl,
	avnd.kiran@samsung.com, arunkk.samsung@gmail.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Arun,

> @@ -684,5 +685,6 @@ void set_work_bit_irqsave(struct s5p_mfc_ctx *ctx);
>                                 (dev->variant->port_num ? 1 : 0) : 0) : 0)
>  #define IS_TWOPORT(dev)                (dev->variant->port_num == 2 ? 1 : 0)
>  #define IS_MFCV6_PLUS(dev)     (dev->variant->version >= 0x60 ? 1 : 0)
> +#define IS_MFCV7(dev)          (dev->variant->version >= 0x70 ? 1 : 0)

Considering the definition and pattern, wouldn't it be appropriate to
call this  IS_MFCV7_PLUS?

---
With warm regards,
Sachin
