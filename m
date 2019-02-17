Return-Path: <SRS0=7VZ/=QY=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 71A20C43381
	for <linux-media@archiver.kernel.org>; Sun, 17 Feb 2019 23:52:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3A1E52177B
	for <linux-media@archiver.kernel.org>; Sun, 17 Feb 2019 23:52:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="WVcj7g00"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727504AbfBQXwi (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Sun, 17 Feb 2019 18:52:38 -0500
Received: from mail-pg1-f177.google.com ([209.85.215.177]:38941 "EHLO
        mail-pg1-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726304AbfBQXwi (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 17 Feb 2019 18:52:38 -0500
Received: by mail-pg1-f177.google.com with SMTP id r11so7485938pgp.6
        for <linux-media@vger.kernel.org>; Sun, 17 Feb 2019 15:52:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=vUNWOi5bgZTXtl+i2HI4e2k/PvJ7pk5pen1qWO27/tg=;
        b=WVcj7g006M/7lq2XDRl/ry0aniNlxQtt9lujGOEevKTQ/de/c0/skiAOBqOhF+z9SF
         1KoM9VWEjKx+Glvu2QJoHoVKre4rTNAWrsoCMyl0C5eJw/eFhoTlRBTPRJ39D4aXLocZ
         UtRiUL1w4sJD2bbTAP+G92HnRpH+SqcJaUqngJrPSKPalyeT693XiQcXG5wSUmxWXn5p
         luYjwnciDpUogYYte6yhuz4GHVKB85Qw4VYC2hAY82k5c3++kMTXnhKds2DAOCsfYoP2
         UBrqEVkVFunrorQchLANCoQ1LTbWYbHB6HphCUMN62R1i78kQ0FIU3F4VseayZoJp0Fh
         VGxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=vUNWOi5bgZTXtl+i2HI4e2k/PvJ7pk5pen1qWO27/tg=;
        b=kzIbzpCYFtSk1lpZ0UodyUrQFItxAEh3Cm2giSmHuvX6wNTLwqKfVyNTbRzbcemc26
         1dUYC5jsphmy5OWcQMTN6WwghHFSscjA2Mng9Ic8Dcx0SltLhvkopce88qxk6WDPN7jo
         dnqMx9HY80mkIeTsd5NCXjnsI80rC9FX/1RNVfSPVYasA3Ul56CCSm3TDbXuxIxyzrw2
         7g5URr3GasqIR7NO+6M/+t/eDQ4HMLoN23/7RWZ5eyxF5CgdtMkaysB6ef4Towl40Shk
         cllcxDzgHQUXpbeb3Q4WzgmQm+3k51WzUbSRwLiOKakQW0b0tIIJJAY0GygPHr4FyNB3
         P84A==
X-Gm-Message-State: AHQUAub3y2nNpm4tPnRzalKfGH9Eoab+a4szwqbmSopWnNAwm2+8aUKD
        QjAWik3GEipZ4GPSwNd7l1A=
X-Google-Smtp-Source: AHgI3IZlK8ey3JhGwrj/ZS7F6NBx5eA3PhoWozRYfcA0PECbSNNJDlzp2VKqGeMB2WZ30j8jNrdQAw==
X-Received: by 2002:a63:d453:: with SMTP id i19mr1158223pgj.237.1550447557640;
        Sun, 17 Feb 2019 15:52:37 -0800 (PST)
Received: from [192.168.1.59] (c-73-202-231-77.hsd1.ca.comcast.net. [73.202.231.77])
        by smtp.gmail.com with ESMTPSA id p7sm17585481pfa.22.2019.02.17.15.52.36
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 17 Feb 2019 15:52:36 -0800 (PST)
Subject: Re: imx: smatch errors
To:     Hans Verkuil <hverkuil@xs4all.nl>
Cc:     Linux Media Mailing List <linux-media@vger.kernel.org>,
        Philipp Zabel <p.zabel@pengutronix.de>
References: <4015d912-2368-6c59-9ab9-5ad5117ff605@xs4all.nl>
 <bcde0f8e-1e0d-38cf-6c57-06c3a324145c@xs4all.nl>
From:   Steve Longerbeam <slongerbeam@gmail.com>
Message-ID: <22589fb0-8739-621e-1c17-31f4fb47d82e@gmail.com>
Date:   Sun, 17 Feb 2019 15:52:34 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <bcde0f8e-1e0d-38cf-6c57-06c3a324145c@xs4all.nl>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi Hans, pardon the delay, I will post a patch for this tomorrow.

Steve


On 2/16/19 1:27 AM, Hans Verkuil wrote:
> On 2/7/19 3:33 PM, Hans Verkuil wrote:
>> Hi Steve,
>>
>> It turns out that the daily build never compiled the staging media drivers,
>> which included imx. Now that I enabled it I get these three errors:
>>
>> drivers/staging/media/imx/imx-media-vdic.c:236 prepare_vdi_in_buffers() error: uninitialized symbol 'prev_phys'.
>> drivers/staging/media/imx/imx-media-vdic.c:237 prepare_vdi_in_buffers() error: uninitialized symbol 'curr_phys'.
>> drivers/staging/media/imx/imx-media-vdic.c:238 prepare_vdi_in_buffers() error: uninitialized symbol 'next_phys'.
>>
>> Can you take a look? The root cause is that the switch doesn't have
>> a default case.
>>
>> I expect that this is easy to fix, but I'm not sure what the fix should be,
>> otherwise I would have made a patch for you.
> Ping!
>
> Regards,
>
> 	Hans
>
>

