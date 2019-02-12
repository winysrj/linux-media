Return-Path: <SRS0=4gUs=QT=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7BA81C282CA
	for <linux-media@archiver.kernel.org>; Tue, 12 Feb 2019 17:42:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4E5B02082F
	for <linux-media@archiver.kernel.org>; Tue, 12 Feb 2019 17:42:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Z5ZP1vs4"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728683AbfBLRmP (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 12 Feb 2019 12:42:15 -0500
Received: from mail-wr1-f53.google.com ([209.85.221.53]:44151 "EHLO
        mail-wr1-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726480AbfBLRmP (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 12 Feb 2019 12:42:15 -0500
Received: by mail-wr1-f53.google.com with SMTP id v16so3628857wrn.11;
        Tue, 12 Feb 2019 09:42:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=uUVYm93LgF/Sk4xNuxnQR8tyKEtxENVP8ZdDJLghm44=;
        b=Z5ZP1vs4S0XCPu4fgL2YI/nS4ryIZkpQ/PK/tgQF8r7n9+M0an1x2hfaimPZp3uFi3
         kcBGJJ38uIZT5yCSzQWGCMI2/H7klfF652yKPRgF2pxHVFCM+2z0lkk6CJq1ziXOin0W
         6AoSDOmT0lMdyXF2dGjSzUP8gil5Z/dPXChl+AtNmPUvMH0jbF8ItN0+bjlvIfPCfAbd
         DZiiKY08U36vGN4aX/CAMRDY0kI2ysEE00+cp5VJlNrBZSqvTiNE4fQzTAtMsym6FmyR
         fULPLJgOHOnokLT8JyxpeeXUJINpZNz3hydG9NIgcBBtvKPTQ0d/NMOu9rw6WGGBxagL
         8ssw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=uUVYm93LgF/Sk4xNuxnQR8tyKEtxENVP8ZdDJLghm44=;
        b=sMiqFFTHedFoWmR88NcpJrtH3nk1gd3Zf+GCDenlEJ7Z1bBCRUmqf+hiL/a5FO48Sm
         qtya09P/mhgA61S9zCkWhGsiYaVo/uZv/2FnSw703eKOOg90Ew6nLYWcNjfpTm1POSvJ
         sQZ2DCoV5HDKhpotd67f96BfkhLgJ9b9yGc0NZqGwJQ0elQjR2nQUQU0CY1Mc43pLF8a
         06aT6pw90d1dO3tIRjS5mwQMUmRoVeYMppiIsZdKZlXwphzB4sJ8CmnlIIX+Dyj6/MaU
         UxiZUynXK77zjwXxfOigJdBIgvl0OuuRQbyO0Jt3KyfxiXJTBS8En1Uw2TZY7Jo6HZa5
         xRwA==
X-Gm-Message-State: AHQUAuZn9ZSS198nGQT4qhzT40TfuBjKM49uPqEv1pqgl0huEJqTu7f5
        yliaOLT0uALBW+ajiGjsZtuNvNa1
X-Google-Smtp-Source: AHgI3IbkAnn5eybH4Kg5jWdakVoxWZaQ0YaN8kOZ70UjEmCKSg8mcM7OWubYQLQRVTqr0pZPGA9ljA==
X-Received: by 2002:a5d:43c9:: with SMTP id v9mr3683891wrr.202.1549993332926;
        Tue, 12 Feb 2019 09:42:12 -0800 (PST)
Received: from [172.30.88.209] (sjewanfw1-nat.mentorg.com. [139.181.7.34])
        by smtp.gmail.com with ESMTPSA id v4sm4470905wme.6.2019.02.12.09.42.11
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 12 Feb 2019 09:42:12 -0800 (PST)
Subject: Re: [PATCH v4 1/4] gpu: ipu-v3: ipu-ic: Rename yuv2rgb encoding
 matrices
To:     Philipp Zabel <p.zabel@pengutronix.de>, linux-media@vger.kernel.org
Cc:     Tim Harvey <tharvey@gateworks.com>,
        "open list:DRM DRIVERS FOR FREESCALE IMX" 
        <dri-devel@lists.freedesktop.org>,
        open list <linux-kernel@vger.kernel.org>
References: <20190209014748.10427-1-slongerbeam@gmail.com>
 <20190209014748.10427-2-slongerbeam@gmail.com>
 <1549879117.7687.2.camel@pengutronix.de>
 <0f987e19-e6e9-a56e-00ec-61e7e300a92e@gmail.com>
 <1549966666.4800.3.camel@pengutronix.de>
From:   Steve Longerbeam <slongerbeam@gmail.com>
Message-ID: <7d4c5935-ffa1-2320-1632-136e1ce89350@gmail.com>
Date:   Tue, 12 Feb 2019 09:42:08 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <1549966666.4800.3.camel@pengutronix.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org



On 2/12/19 2:17 AM, Philipp Zabel wrote:
> Hi Steve,
>
> On Mon, 2019-02-11 at 10:24 -0800, Steve Longerbeam wrote:
> [...]
>> Looking more closely at these coefficients now, I see you are right,
>> they are the BT.601 YUV full-range coefficients (Y range 0 to 1, U and V
>> range -0.5 to 0.5). Well, not even that -- the coefficients are not
>> being scaled to the limited ranges, but the 0.5 offset (128) _is_ being
>> added to U/V, but no offset for Y. So it is even more messed up.
>>
>> Your corrected coefficients and offsets look correct to me: Y
>> coefficients scaled to (235 - 16) / 255 and U/V coefficients scaled to
>> (240 - 16)  / 255, and add the offsets for both Y and U/V.
>>
>> But what about this "SAT_MODE" field in the IC task parameter memory?
> That just controls the saturation. The result after the matrix
> multiplication is either saturated to [0..255] or to [16..235]/[16..240]
> when converting from the internal representation to the 8 bit output.

By saturation I think you mean clipped to those ranges?

>
>> According to the manual the hardware will automatically convert the
>> written coefficients to the correct limited ranges.
> Where did you get that from? "The final calculation result is limited
> according to the SAT_MODE parameter and rounded to 8 bits." I see no
> mention of coefficients being modified.

Well, as is often the case with this manual, I was interpreting based on 
poorly written information. By "final calculation result is limited 
according to the SAT_MODE parameter" I interpreted that to mean the 
hardware enables scaling from full range to limited range. But I concede 
that it more likely means it clips the output to those ranges.

>
>> I see there is a "sat" field defined in the struct but is not being
>> set in the tables.
>>
>> So what should we do, define the full range coefficients, and make use
>> of SAT_MODE h/w feature, or scale/offset the coefficients ourselves and
>> not use SAT_MODE? I'm inclined to do the former.
> SAT_MODE should be set for conversions to YUV limited range so that the
> coefficients can be rounded to the closest value.

Well, we have already rounded the coefficients to the nearest int in the 
tables. Do you mean the final result (coeff * color component + offset) 
is rounded?

>   Otherwise we'd have to
> round towards zero, possibly with a larger error, to make sure the
> results are inside the valid ranges.

Makes sense, I will turn on that bit for limited range YUV output for 
v5, so that the final color component result is clipped to limited range 
and rounded.


Steve


