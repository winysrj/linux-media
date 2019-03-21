Return-Path: <SRS0=WMbR=RY=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 71380C43381
	for <linux-media@archiver.kernel.org>; Thu, 21 Mar 2019 19:59:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3B0F0218A5
	for <linux-media@archiver.kernel.org>; Thu, 21 Mar 2019 19:59:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="KufpxPjT"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728088AbfCUT7i (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 21 Mar 2019 15:59:38 -0400
Received: from mail-wm1-f53.google.com ([209.85.128.53]:35527 "EHLO
        mail-wm1-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727881AbfCUT7i (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 21 Mar 2019 15:59:38 -0400
Received: by mail-wm1-f53.google.com with SMTP id y197so41666wmd.0
        for <linux-media@vger.kernel.org>; Thu, 21 Mar 2019 12:59:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=zlU/3LohMF6TqJbuu+PAASgOeuaPwGmCivG9m5MvleA=;
        b=KufpxPjTjU0fIP1VM/zqzN+vxmDMjJb9Loy1UJabnUpCpvBN0ZOB5mQx74Mp8cEsr/
         gxHTBc9EcnOn5EF6lEs/bT9imSZHo0/eu7vo+2MtMzEB4Yj6UsrNaB+sd0shn3fjyfcb
         H7r7JC+DR8BMp6rU5VSVIO5tIaEvNzKfAuz0TdPXOTEVJwKKZPipEXzo1+4pCfhACjOK
         4arr3E+VkpLyf4cTtBsgloD3dwGRMNsAQSPYLTZCYGw5+KwFQ2eIXjsxvwJiO0NXQ4mZ
         Mxf3ilj9ZQaof3tP/h1Sa+C98P8BMMDhVGZ+T+YcZNoABFC2qCKjP9y3yOrHSeasXUYS
         guag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=zlU/3LohMF6TqJbuu+PAASgOeuaPwGmCivG9m5MvleA=;
        b=OE1aSqDhBrm1UnSk8zDb2EStD7axUYwteCbHEDiolIxFMozgRfsnT7Ycipbm8smhvX
         Azj0sNHZE6cGJ5NlWTrhN5r99BqYgyeoMPytsgndhMHS3bM+glXavuH/z6nwS4UDy1cW
         n251p4PkZI/NxY9YM5b0PaI9C+HNlFn+50gkMumCjHjgfaisUVchtI2hVpHEguRcv5BD
         6PuAGRRulcxhRpYEuECv5ETF+v+xN5AP/BTKYkcBtR/1vvso8Cc+UlKd1PHIsWaOw63o
         oS8E5k9aavvR4FNR2byuBe20AF7+kKhSoHYNQ1QM00WA1X4ZBCDhK6kpkNaubauke7LA
         nRzA==
X-Gm-Message-State: APjAAAXjG+uceQRJmndRkscrUGz8wtv7sLhiW0kuEOmw4/Cw8PnymhwW
        imxRMMbZsBy/nYzAPCGEnDI=
X-Google-Smtp-Source: APXvYqwEDqdLxUtKuXz8lyPJxj+lTf7y3DNZguJQ/Q7c4PUOThM6ouuxzOnfr5sDcL/ob1oCgPcbJA==
X-Received: by 2002:a7b:c382:: with SMTP id s2mr625302wmj.56.1553198375741;
        Thu, 21 Mar 2019 12:59:35 -0700 (PDT)
Received: from ?IPv6:2a02:810a:8340:5f04:e022:1a6f:1d80:f811? ([2a02:810a:8340:5f04:e022:1a6f:1d80:f811])
        by smtp.gmail.com with ESMTPSA id c10sm4020859wru.83.2019.03.21.12.59.34
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 21 Mar 2019 12:59:34 -0700 (PDT)
Subject: Re: [Bug report] dvbv5-zap crash dvb-tool ARMHF builds
To:     Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Sean Young <sean@mess.org>
Cc:     CHEMLA Samuel <chemla.samuel@gmail.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>
References: <f4b69417-06c3-f9ab-2973-ae23d76088b8@gmail.com>
 <29bad771-843c-1dee-906c-6e9475aed7d8@gmail.com>
 <d291e164-993f-232a-f01b-0f8c17087004@googlemail.com>
 <20190315223425.hiq3qcjhjnirsizh@gofer.mess.org>
 <20190317065242.137cb095@coco.lan> <20190319164507.7f95af89@coco.lan>
 <a1f296ba-3c27-ed2c-3912-4edbeeb21eba@googlemail.com>
 <20190321094127.ysurm4u26zugmnmv@gofer.mess.org>
 <20190321083044.621f1922@coco.lan>
From:   Gregor Jasny <gjasny@googlemail.com>
Message-ID: <35ba4e81-fc2a-87ed-8da7-43cc4543de51@googlemail.com>
Date:   Thu, 21 Mar 2019 20:59:33 +0100
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:60.0)
 Gecko/20100101 Thunderbird/60.5.3
MIME-Version: 1.0
In-Reply-To: <20190321083044.621f1922@coco.lan>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hello,

On 21.03.19 12:30, Mauro Carvalho Chehab wrote:
> I went ahead and cherry-picked the relevant patches to -1.12, -1.14 and
> -1.16, and tested both dvbv5-zap and dvbv5-scan with all versions. So, we can
> release a new minor version for all those stable branches.
> 
> After the patches, on my tests, I didn't get any memory leaks or
> double-free issues.

I issues a new 1.12, 1.14, and 1.16 release.

Thanks,
Gregor

