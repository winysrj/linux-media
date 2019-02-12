Return-Path: <SRS0=4gUs=QT=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A268FC282CA
	for <linux-media@archiver.kernel.org>; Tue, 12 Feb 2019 17:50:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 58B6420842
	for <linux-media@archiver.kernel.org>; Tue, 12 Feb 2019 17:50:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="roQ8qICH"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728413AbfBLRuZ (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 12 Feb 2019 12:50:25 -0500
Received: from mail-wr1-f68.google.com ([209.85.221.68]:36311 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729301AbfBLRuZ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 12 Feb 2019 12:50:25 -0500
Received: by mail-wr1-f68.google.com with SMTP id o17so3716318wrw.3;
        Tue, 12 Feb 2019 09:50:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=mKdfhntET8a5sT57ulQMfz5WyVQhI6miZqMkI7Tm3BE=;
        b=roQ8qICHJWpWnRzaWI8kfTKFElWb5/E8NxngacLdC8EjVg67tgHypucttlnrCz3DYt
         ObCLJ7dBzref+Y7neaa5+IelLXpMOAb8h/iDA6ltd1orHU9NWLFqXJRzLspg8n9H1cNl
         fbtcl3gxN2yrYgBPvRHJml0jlzlI0vl9L6kIGVgRLyCGdN/mNZ+pumIkI5ZCbJbEl8hg
         hWbXINMmtHjrjpTpE1G4dnSwwe3a6Nye097mn/6bIrKDq6sb1HuPEinD7pnnoHJHCcDo
         brYs0ZPvx9a+FhHKcHK4SAOV2I5lS3dhrTt12Pqz3oKD/YflkPMNVKaTgrpRSPd8HXIN
         V33A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=mKdfhntET8a5sT57ulQMfz5WyVQhI6miZqMkI7Tm3BE=;
        b=P9jzVzaNbIZlCIzQiPwZIeOkl+3o3AFPKcuea+HyIsYFCI5iJMHc1NgEWiGxZXX8n7
         Oggu5spQ7WBbTFHh1xyO0YlWwsQZY9bb19p8CJijMcSI6ssXlH/v3P6wJwEsm7+zNP7U
         4YruJjzAuXSBnZeWp38TqMbalNus3jlTDKzBeNgUwpqPWtG17dYQEY8P6V7oMvFG4o+A
         D2Q+KDyeEDo1/QDLmvNP5AQjD2dtrhx1MPEi2jei41wIq8WHQwQM04E+vW1gSuUN0iU4
         V5s9rGo4xOCex6UPWoj0aG1DweG7nSA9HrvjuQyJaV0ytdHnv1woK/TY4lfgwzw0+z7H
         vPjg==
X-Gm-Message-State: AHQUAua0P0Xcl4o3INC65fZAifER2p4tLbEPAS+04WZZoKFPjvnwWym+
        4yAJ/g4ycWmp9V9MBkzfwdavYOoL
X-Google-Smtp-Source: AHgI3IauLN2agTLnXw2hakJ3BMjzcmp+Lr6AbEqzaQt8Jvh2c99Hkpg0WtBY4HtxybYgkV29t4cL8A==
X-Received: by 2002:a5d:65d2:: with SMTP id e18mr3977943wrw.117.1549993822969;
        Tue, 12 Feb 2019 09:50:22 -0800 (PST)
Received: from [172.30.88.209] (sjewanfw1-nat.mentorg.com. [139.181.7.34])
        by smtp.gmail.com with ESMTPSA id c18sm20704546wre.32.2019.02.12.09.50.20
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 12 Feb 2019 09:50:22 -0800 (PST)
Subject: Re: [PATCH v4 3/4] gpu: ipu-v3: ipu-ic: Add support for BT.709
 encoding
To:     Philipp Zabel <p.zabel@pengutronix.de>, linux-media@vger.kernel.org
Cc:     Tim Harvey <tharvey@gateworks.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        "open list:DRM DRIVERS FOR FREESCALE IMX" 
        <dri-devel@lists.freedesktop.org>,
        open list <linux-kernel@vger.kernel.org>,
        "open list:STAGING SUBSYSTEM" <devel@driverdev.osuosl.org>,
        "open list:FRAMEBUFFER LAYER" <linux-fbdev@vger.kernel.org>
References: <20190209014748.10427-1-slongerbeam@gmail.com>
 <20190209014748.10427-4-slongerbeam@gmail.com>
 <1549879951.7687.6.camel@pengutronix.de>
 <440e12af-33ea-5eac-e570-8afa74e3133c@gmail.com>
 <1549971262.4800.5.camel@pengutronix.de>
From:   Steve Longerbeam <slongerbeam@gmail.com>
Message-ID: <4403ed99-1949-a3fa-e567-c8a886d9366f@gmail.com>
Date:   Tue, 12 Feb 2019 09:50:17 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <1549971262.4800.5.camel@pengutronix.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org



On 2/12/19 3:34 AM, Philipp Zabel wrote:
> Hi Steve,
>
> On Mon, 2019-02-11 at 17:20 -0800, Steve Longerbeam wrote:
> [...]
>>> Should we support YUV BT.601 <-> YUV REC.709 conversions? That would
>>> require separate encodings for input and output.
>> How about if we pass the input and output encodings to the init ic task
>> functions, but for now require they be the same? We can support
>> transcoding in a later series.
> [...]
>> Again, I think for now, just include input/output quantization but
>> require full range for RGB and limited range for YUV.
> Yes, that is fine. I'd just like to avoid unnecessary interface changes
> between ipu-v3 and imx-media. So if we have to change it right now, why
> not plan ahead.

Agreed!

>
>> But that really balloons the arguments to ipu_ic_task_init_*(). Should
>> we create an ipu_ic_task_init structure?
> I wonder if we should just expose struct ic_csc_params

I had basically the same idea. I wasn't thinking of creating a helper to 
fill in the params but sure, I'll add that.

Steve


>   and provide a
> helper to fill it given colorspace and V4L2 encoding/quantization
> parameters. Something like:
>
> 	struct ipu_ic_csc_params csc;
>
> 	imx_media_init_ic_csc_params(&csc,
> 			in_cs, in_encoding, in_quantization,
> 			out_cs, out_encoding, out_quantization);
>
> 	ipu_ic_task_init(ic,
> 			in_width, in_height,
> 			out_width, out_height, &csc);
> 	// or
> 	ipu_ic_task_init_rsc(ic, rsc, &csc);
>
> regards
> Philipp

