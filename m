Return-Path: <SRS0=ZIWa=RP=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D9332C43381
	for <linux-media@archiver.kernel.org>; Tue, 12 Mar 2019 15:07:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A383420693
	for <linux-media@archiver.kernel.org>; Tue, 12 Mar 2019 15:07:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="F8RP38PI"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726831AbfCLPH1 (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 12 Mar 2019 11:07:27 -0400
Received: from mail-wr1-f53.google.com ([209.85.221.53]:40298 "EHLO
        mail-wr1-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726284AbfCLPH0 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 12 Mar 2019 11:07:26 -0400
Received: by mail-wr1-f53.google.com with SMTP id t5so1919664wri.7
        for <linux-media@vger.kernel.org>; Tue, 12 Mar 2019 08:07:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20161025;
        h=subject:to:references:cc:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=1F2xFQMujc+gtie4VOZzovbcPm7pWVjsYcl+W3vGvnA=;
        b=F8RP38PI+eusz7hKvXwNROzbr0bZlvGRg022KppnNfJawoGl3a3c8XFhiyL6Ew3HaJ
         pFJ6iJi7QlQNZ+rDjI3FDuPM/FxP95kH363r2kCh4oP82+meyypqNK2stc/ahNApBsBm
         Ky+eteUKBch767ybthkKAwS0RizgSJPuVIA8lJDGi67B+y1biFmF6uHSqJufktRSjFm+
         fZWQTEWfSsKC0BSPOYm+5Vk3meDyk0JPA88MKPisgampeqZffok0vMRKQhP0r24+4s8b
         1hRNnENUCMuw+XBhCxdsqMaL32JHJ3+BgJpGhphbtdLgXXEWOJKE8wNN7YeR0rtAddzg
         hBZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:cc:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=1F2xFQMujc+gtie4VOZzovbcPm7pWVjsYcl+W3vGvnA=;
        b=ZFPVYDUlDfhHihoCU+fmNzACbKENmRNyIHLLbmoG51khnEYlkLmUvMoZGl8r69y+r7
         LesM8e7IfDFAx4pFOeeUOO7xgY/iLE06Up1aRyqEfcdrN0Lf+OeLK/i81HB66TfC61UR
         j/iK9g4BZyOqld1BbBTOZGsF2gitooKbrmHFc9RAaIkoFAFKxOaQkfXAlYLo+/l7Cr1y
         oIexcbaMwkCalcDU122Oq6Gsakl1KcLJapzrf686IWY3W7Ujt1g4vYEUa4uzty6MHd4B
         Kbya/aUsCW10zGkeYOmoeT4U2rpisaipter/W+n9YMB8F9CCClFSP/Tolw6bTO7IkKEn
         N8Mg==
X-Gm-Message-State: APjAAAURToDlgGbTXr3KHfmfGiuJ94SGgwotkD4/y0KKeqOikuMReuig
        SV8+zj2mSvObXNRyIPih8Ig=
X-Google-Smtp-Source: APXvYqwzhd1Ig2KN5AlGa/EOdZN3v+7YZ+OmWb2Hn/EbwJGeIO1CzgzYaobrnD2aMJAiUiIV86RqSQ==
X-Received: by 2002:adf:b591:: with SMTP id c17mr25708417wre.195.1552403245080;
        Tue, 12 Mar 2019 08:07:25 -0700 (PDT)
Received: from drswgregorj02.drs.expertcity.com (ent-nat3.drs.expertcity.com. [78.108.113.8])
        by smtp.gmail.com with ESMTPSA id t133sm3815765wmf.3.2019.03.12.08.07.24
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 12 Mar 2019 08:07:24 -0700 (PDT)
Subject: Re: [Bug report] dvbv5-zap crash dvb-tool ARMHF builds
To:     Linux Media Mailing List <linux-media@vger.kernel.org>
References: <f4b69417-06c3-f9ab-2973-ae23d76088b8@gmail.com>
 <29bad771-843c-1dee-906c-6e9475aed7d8@gmail.com>
Cc:     CHEMLA Samuel <chemla.samuel@gmail.com>,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>
From:   Gregor Jasny <gjasny@googlemail.com>
Message-ID: <d291e164-993f-232a-f01b-0f8c17087004@googlemail.com>
Date:   Tue, 12 Mar 2019 16:07:23 +0100
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:60.0)
 Gecko/20100101 Thunderbird/60.5.3
MIME-Version: 1.0
In-Reply-To: <29bad771-843c-1dee-906c-6e9475aed7d8@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hello Mauro,

below you find a bug report about an use-after-free in dvbv5-zap.

On 12.03.19 13:37, CHEMLA Samuel wrote:
> please find a bug report that seems to concern ARMHF builds of dvbv5-zap 
> (dvb-tool package) : https://bugs.launchpad.net/raspbian/+bug/1819650
> I filed it against raspbian because I thought it was a raspbian problem, 
> but don't think they re-build their own package, but use debian ones 
> instead...

Thanks,
Gregor
