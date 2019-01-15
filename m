Return-Path: <SRS0=Ztfs=PX=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8EBEFC43387
	for <linux-media@archiver.kernel.org>; Tue, 15 Jan 2019 23:59:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5F61420656
	for <linux-media@archiver.kernel.org>; Tue, 15 Jan 2019 23:59:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="nkdTtSpH"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728948AbfAOX7Y (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 15 Jan 2019 18:59:24 -0500
Received: from mail-wm1-f43.google.com ([209.85.128.43]:55103 "EHLO
        mail-wm1-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727060AbfAOX7Y (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 15 Jan 2019 18:59:24 -0500
Received: by mail-wm1-f43.google.com with SMTP id a62so196478wmh.4;
        Tue, 15 Jan 2019 15:59:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=CbAY0qMBMEaWQOh0V0R3GpUpfIkeuwVOLdh8laMwhwY=;
        b=nkdTtSpHwojfFELHx3LQwu5Yyq4xbwD3X2gL+Z+vV8es4Gkv/SzT1Iw1LwN5gvd081
         ExNhpgP85qdmplxrMv1pC6zJ8OILTPPocR4++yjlU4+Iwl/pdoiGCBsIwtjSdE/bdv6z
         FcjCWi3RTM/qJvkXDFauO83Q3QE/OETatMi2Qzlum/Vodpl+XiV1qt8gtD8QemZexVhy
         ec+STFc7r6rwhhuTTXeVBPQisCRZinEbinvboXzz+cwxwBot0RepYBkqM02O/8nLTvQU
         qHZEixD/b6JnEZ71PmJ09XYGvVjyq7+KBnJXTMAcLMjG/EC6QD4RBGhaZr9Upr7SChK+
         oAJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=CbAY0qMBMEaWQOh0V0R3GpUpfIkeuwVOLdh8laMwhwY=;
        b=omGSyMMIvS3SxHbKh+nUke/QTss7SPvUU9qIigrAJpRyyCVC6rZYOv5xWhq2fi5lEh
         Aohc1Fi/s9ARt5Df38RKcOABvh/V58hcaT4OOa8jF6skY9wMlxtVeHZGIb4oBc+GVbNR
         aa0W7QDDBJMrBecDOjEWL3R8qNumny/vE3fQvrOvxpnZkrth5HJg2O5KwWmUsxBx7idI
         Fs9ZiM/eWFBOuh6PjvSr2FxhT5k0ds9JYV8t9oRNg0JI7MGv39aRn6DD2d2XS5kxDpao
         ji4FDEJA6iIDx5qB9n8iu1Dh6qTKclQC+Xb0dTWx9SM7Vxt8ttZYVnFDg+0fJ9UwM6Aa
         ScZA==
X-Gm-Message-State: AJcUukfgAG7G7VdYi86N7Hd2AGTZP+e1hHMQ+0uwGWqo/huPKmLaIQTA
        0NNTTGKrwoCrUSj1OCDAMKEE0pMC
X-Google-Smtp-Source: ALg8bN51pdRMVzDdG59DGMvuJVvip9SlW8qclklnfk0oncHZCOcWG/6Yef4JdsgjxdmK55MjSdoRxA==
X-Received: by 2002:a1c:6e06:: with SMTP id j6mr5375959wmc.3.1547596761910;
        Tue, 15 Jan 2019 15:59:21 -0800 (PST)
Received: from [172.30.90.107] (sjewanfw1-nat.mentorg.com. [139.181.7.34])
        by smtp.gmail.com with ESMTPSA id s132sm16336793wmf.28.2019.01.15.15.59.20
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 15 Jan 2019 15:59:21 -0800 (PST)
Subject: Re: [PATCH v8 11/11] media: imx.rst: Update doc to reflect fixes to
 interlaced capture
From:   Steve Longerbeam <slongerbeam@gmail.com>
To:     Tim Harvey <tharvey@gateworks.com>
Cc:     linux-media <linux-media@vger.kernel.org>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        open list <linux-kernel@vger.kernel.org>
References: <20190109183014.20466-1-slongerbeam@gmail.com>
 <20190109183014.20466-12-slongerbeam@gmail.com>
 <CAJ+vNU1r86n1=9gKDw-bTO0sWJL7NMjZcdKMQO23a+WOR1H9tw@mail.gmail.com>
 <6b4c3fb1-929b-8894-e2f9-aca2f392f0e5@gmail.com>
Message-ID: <6e60489c-cafc-ff6d-9aa0-cd0f327967a8@gmail.com>
Date:   Tue, 15 Jan 2019 15:59:18 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.2.1
MIME-Version: 1.0
In-Reply-To: <6b4c3fb1-929b-8894-e2f9-aca2f392f0e5@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org



On 1/15/19 3:54 PM, Steve Longerbeam wrote:
>
>>
>>
>> media-ctl -V "'ipu1_csi0':0 [fmt:AYUV32/720x480]"
>
> This is the reason. The adv7180 is only allowing to configure 
> alternate field mode, and thus it reports the field height on the 
> mbus, not the full frame height. Imx deals with alternate field mode 
> by capturing a full frame, so the CSI entity sets the output pad 
> height to double the height.

gah,

"... so the CSI entity sets the output pad height to double the _input 
pad_ height."

Steve

