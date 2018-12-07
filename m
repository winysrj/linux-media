Return-Path: <SRS0=1NWX=OQ=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5F5FFC64EB1
	for <linux-media@archiver.kernel.org>; Fri,  7 Dec 2018 13:53:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 241E9208E7
	for <linux-media@archiver.kernel.org>; Fri,  7 Dec 2018 13:53:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=linaro.org header.i=@linaro.org header.b="WL2uq4ra"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 241E9208E7
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linaro.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-media-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726094AbeLGNxF (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Fri, 7 Dec 2018 08:53:05 -0500
Received: from mail-wm1-f66.google.com ([209.85.128.66]:40410 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726039AbeLGNxF (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 7 Dec 2018 08:53:05 -0500
Received: by mail-wm1-f66.google.com with SMTP id q26so4576664wmf.5
        for <linux-media@vger.kernel.org>; Fri, 07 Dec 2018 05:53:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=references:user-agent:from:to:cc:subject:in-reply-to:date
         :message-id:mime-version;
        bh=WqahI3jvbTPYSV6LUSuJFDIy9D16y0xHiT8VG/mqj6s=;
        b=WL2uq4raU8w0XMIbsNLjecweYMXr3PEgbW8EtEElQ+FZesbNGk5/KreYMOiROSD+Xw
         jrVb5bQZcrNPu642zOVlkK+6CEOygdltx2Klb+ahWzsae/uGdgepA1M5UcOPzy29OFpi
         vvPii9uHlVx0sZ+NbgZmFj+mqRPKpSiGTarFs=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:references:user-agent:from:to:cc:subject
         :in-reply-to:date:message-id:mime-version;
        bh=WqahI3jvbTPYSV6LUSuJFDIy9D16y0xHiT8VG/mqj6s=;
        b=YxIfaQXNaQSU8RMj4eO7ahHUlejSB3/+e/s8dFV/vOYSWvjfHCptD/RxjOmNjSlQIq
         sWim3uRgeutRVJ+BXrgdeoz22DA5tfIXIMrAWDN55gC2+W2/J93Z+uW09wUVVCipLstJ
         0iUseXLXfTO9fl1vJJzMOgQ1zeSj3u05PIGRLMk47wlwnPISrHbSX0UnZLojCAFmttZh
         UGznpn/ab57y48GKrqjbJWFL40w08jichLODW5sCu1IsX2jXgMqTFAQm0JEzGZ6Lbepa
         AB2cGQh41phmucsMUJ8A4p76NtueMh4QCtXjYl6VRp/eTvxQNawXwmg+Ed7JglJa8TMw
         LG4A==
X-Gm-Message-State: AA+aEWb9txZP0l1P3T8syEivdZFKojo8+UYr5z7V/+UURHO0mwIx8RtZ
        edLPXggS4v2lmyQ1f9hFj4gs4Q==
X-Google-Smtp-Source: AFSGD/X88fNcOiW1dQ3d67WzURlBS3bDzDhFxDwEQ88WN+FPEDWDwNJPbs3PWo1bVslGeUgqmM1W9g==
X-Received: by 2002:a1c:9dcc:: with SMTP id g195mr2230068wme.153.1544190783498;
        Fri, 07 Dec 2018 05:53:03 -0800 (PST)
Received: from arch-late (a109-49-46-234.cpe.netcabo.pt. [109.49.46.234])
        by smtp.gmail.com with ESMTPSA id f66sm4225670wmd.28.2018.12.07.05.53.02
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 07 Dec 2018 05:53:02 -0800 (PST)
References: <20181122151834.6194-1-rui.silva@linaro.org> <20181122151834.6194-2-rui.silva@linaro.org> <b0fffeef-439b-e3a7-67d1-900a7ea1664f@xs4all.nl>
User-agent: mu4e 1.0; emacs 27.0.50
From:   Rui Miguel Silva <rui.silva@linaro.org>
To:     Hans Verkuil <hverkuil@xs4all.nl>
Cc:     sakari.ailus@linux.intel.com,
        Steve Longerbeam <slongerbeam@gmail.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
        devicetree@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH v9 01/13] media: staging/imx: refactor imx media device probe
In-reply-to: <b0fffeef-439b-e3a7-67d1-900a7ea1664f@xs4all.nl>
Date:   Fri, 07 Dec 2018 13:53:01 +0000
Message-ID: <m37egl30le.fsf@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; format=flowed
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi Hans,
Thanks for the review.

On Fri 07 Dec 2018 at 12:38, Hans Verkuil wrote:
> On 11/22/2018 04:18 PM, Rui Miguel Silva wrote:
>> Refactor and move media device initialization code to a new 
>> common
>> module, so it can be used by other devices, this will allow for 
>> example
>> a near to introduce imx7 CSI driver, to use this media device.
>> 
>> Signed-off-by: Rui Miguel Silva <rui.silva@linaro.org>
>> ---
>>  drivers/staging/media/imx/Makefile            |   1 +
>>  .../staging/media/imx/imx-media-dev-common.c  | 102 
>>  ++++++++++++++++++
>>  drivers/staging/media/imx/imx-media-dev.c     |  88 
>>  ++++-----------
>>  drivers/staging/media/imx/imx-media-of.c      |   6 +-
>>  drivers/staging/media/imx/imx-media.h         |  15 +++
>>  5 files changed, 141 insertions(+), 71 deletions(-)
>>  create mode 100644 
>>  drivers/staging/media/imx/imx-media-dev-common.c
>> 
>> diff --git a/drivers/staging/media/imx/Makefile 
>> b/drivers/staging/media/imx/Makefile
>> index 698a4210316e..a30b3033f9a3 100644
>> --- a/drivers/staging/media/imx/Makefile
>> +++ b/drivers/staging/media/imx/Makefile
>> @@ -1,5 +1,6 @@
>>  # SPDX-License-Identifier: GPL-2.0
>>  imx-media-objs := imx-media-dev.o imx-media-internal-sd.o 
>>  imx-media-of.o
>> +imx-media-objs += imx-media-dev-common.o
>>  imx-media-common-objs := imx-media-utils.o imx-media-fim.o
>>  imx-media-ic-objs := imx-ic-common.o imx-ic-prp.o 
>>  imx-ic-prpencvf.o
>>  
>> diff --git a/drivers/staging/media/imx/imx-media-dev-common.c 
>> b/drivers/staging/media/imx/imx-media-dev-common.c
>> new file mode 100644
>> index 000000000000..55fe94fb72f2
>> --- /dev/null
>> +++ b/drivers/staging/media/imx/imx-media-dev-common.c
>> @@ -0,0 +1,102 @@
>> +// SPDX-License-Identifier: GPL
>
> This is an invalid SPDX license identifier. You probably want to 
> use GPL-2.0.

hrr... you are right, I will update it here and others.

---
Cheers,
	Rui

