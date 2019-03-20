Return-Path: <SRS0=I/aX=RX=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 35946C43381
	for <linux-media@archiver.kernel.org>; Wed, 20 Mar 2019 19:38:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 06FCE21873
	for <linux-media@archiver.kernel.org>; Wed, 20 Mar 2019 19:38:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="nbnaVj+9"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726487AbfCTTi4 (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 20 Mar 2019 15:38:56 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:50239 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725988AbfCTTi4 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 20 Mar 2019 15:38:56 -0400
Received: by mail-wm1-f67.google.com with SMTP id z11so458215wmi.0
        for <linux-media@vger.kernel.org>; Wed, 20 Mar 2019 12:38:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=h1MNkVkhOP/8z0azoNcdyKm33IFYxRP1XToc+as0W2E=;
        b=nbnaVj+9DMxWS9dIadRik655Hx8Ennj8KeX7O9wFsycvO8s+rpBOX8HqPEvBoj3KLk
         lQUMsTjMmYbNal9dkgYU/5QvkdknikP6Em1/4WRxaTp0+jQr5n+mNrWrBVuIo2a3kZJQ
         hdmQQeXilOm0lsUXAJYSP18gx1I9hMC32Wr6mEpxGAY3n7SmJNXlOhgO5c06zIZZFptT
         cgeN/XWO7EAHpPzM9LSzKAwiF4yoJVvr9sJuFXS9RCBbUFep69DemLcJVhswLhQTC5GV
         BQFZEyKl0+D0WhQljKqpm25HRtHzba/ON9mUaAtWYPtwqbrAiRPWlPCPLvQMGBPiFDKG
         pOag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=h1MNkVkhOP/8z0azoNcdyKm33IFYxRP1XToc+as0W2E=;
        b=bPOVkpUIRvGMKigIzRWIEwCILnjgSR3IVpNnfDXAvaTM7PsBeTyF9QdUxJYg/sy6xm
         j7iekrhBSTdjTf1dicAix1yKBLTYPRJamgot60v1yTAqHz6P0pxIJ5EwWTNrG4wjOcfl
         rvFO19q9vL85BpnCh1GdU6ljSot7S+3EHzFI/ZX+aDeOs5bHELkinPUW0gI4xXq6yRhh
         Gii+bK/sNVob/ooMO2arG6O9fE5iDGz641ckjNV80TRmi6ouX74gShbyXXekwA2HXNnU
         1fo1fRRLkRH+/SeQeNH1zqx2x2hBvUNa5yW8wQMICnUKW4z5PWMTSkSblhVKXNpKAzKH
         Z5jA==
X-Gm-Message-State: APjAAAU77OnMyZ1lrgl8TsMiMbueTC1yqnjM0qSKKVu122jdrlFORs28
        QlvWd66FI1j4SIjeYSBJgbU=
X-Google-Smtp-Source: APXvYqzEIMFxkb7pYhAqK/BOogG7oTs3UhNwUEw2vtgxIipXWHSwQvW8Z3SyasbUMja4fnf9hfOzeQ==
X-Received: by 2002:a1c:658a:: with SMTP id z132mr28311wmb.92.1553110734628;
        Wed, 20 Mar 2019 12:38:54 -0700 (PDT)
Received: from ?IPv6:2a02:810a:8340:5f04:c835:1921:38fd:9c69? ([2a02:810a:8340:5f04:c835:1921:38fd:9c69])
        by smtp.gmail.com with ESMTPSA id r6sm4079323wrx.48.2019.03.20.12.38.53
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 20 Mar 2019 12:38:53 -0700 (PDT)
Subject: Re: [Bug report] dvbv5-zap crash dvb-tool ARMHF builds
To:     Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Cc:     Sean Young <sean@mess.org>,
        CHEMLA Samuel <chemla.samuel@gmail.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>
References: <f4b69417-06c3-f9ab-2973-ae23d76088b8@gmail.com>
 <29bad771-843c-1dee-906c-6e9475aed7d8@gmail.com>
 <d291e164-993f-232a-f01b-0f8c17087004@googlemail.com>
 <20190315223425.hiq3qcjhjnirsizh@gofer.mess.org>
 <20190317065242.137cb095@coco.lan> <20190319164507.7f95af89@coco.lan>
From:   Gregor Jasny <gjasny@googlemail.com>
Message-ID: <a1f296ba-3c27-ed2c-3912-4edbeeb21eba@googlemail.com>
Date:   Wed, 20 Mar 2019 20:38:52 +0100
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:60.0)
 Gecko/20100101 Thunderbird/60.5.3
MIME-Version: 1.0
In-Reply-To: <20190319164507.7f95af89@coco.lan>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hello Mauro,

On 19.03.19 20:45, Mauro Carvalho Chehab wrote:
> Hi Gregor,
> 
> Samuel reported in priv that the issues he had with user after free were
> solved by the patchsets merged at 1.12 and 1.16 stable branches.
> 
> Could you please generate a new staging release for them?

Sure, I can create a new 1.12 and 1.16 stable release. But when 
reviewing the patches for approval by debian release managers I noticed 
an additional double-free that Sean addressed with the following patch:

> https://git.linuxtv.org/v4l-utils.git/commit/?id=ebd890019ba7383b8b486d829f6683c8f49fdbda

Could you please give that patch a thorough review, some testing, and 
cherry-pick it to stable-1.12 and -1.16 as well?

Thanks,
Gregor
