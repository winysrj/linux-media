Return-Path: <SRS0=A0HE=OJ=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BC863C04EB8
	for <linux-media@archiver.kernel.org>; Fri, 30 Nov 2018 20:12:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 82C8F20863
	for <linux-media@archiver.kernel.org>; Fri, 30 Nov 2018 20:12:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20150623.gappssmtp.com header.i=@kernel-dk.20150623.gappssmtp.com header.b="tdDiomT7"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 82C8F20863
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-media-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726772AbeLAHW5 (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Sat, 1 Dec 2018 02:22:57 -0500
Received: from mail-it1-f194.google.com ([209.85.166.194]:38590 "EHLO
        mail-it1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725993AbeLAHW4 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Sat, 1 Dec 2018 02:22:56 -0500
Received: by mail-it1-f194.google.com with SMTP id h65so287909ith.3
        for <linux-media@vger.kernel.org>; Fri, 30 Nov 2018 12:12:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=ObRXf9mLyt/NuESAeifDaKyQ68nJIRiXxB5ZAt6h7kw=;
        b=tdDiomT7AQykxyaYTpRPUaiKHfc9JsfZdgs8+T2Bl10Fwcc2JDzZy7U4/u8ubsMHhr
         UfR/asNtDTCRlUN3ukA5qDI7BWVdvHCUyKEohLCp+OA6ut80JT/DZoiXHsLJJej/alpE
         gL9Bp8KYnFCLSihEgl8Zora8Wt2UycjXu4qFS+elzEwZlisg2N8YlfeOvi7aLlvAtMD8
         +WDc/z/8NLxGVTcUHQwPxvRG2A7EORXysxbR5dR+TSY9Dakqh9gH2SbFp1PLRO+gEYc7
         SFKrmgCdPkfRa4Uz9s24ISiPcJ/tvT0oaKF/LIQohia5NzfdKvrRmACnBvoDQW3rXmFv
         uT6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ObRXf9mLyt/NuESAeifDaKyQ68nJIRiXxB5ZAt6h7kw=;
        b=n5wQeybA5U9EjRF26GT2CGXLJECo0LF3obZuF34LDC/aaC/OS/9gWhISTcoThI55/t
         tYerBHMr85U9oXXGPaMvdGTPsKzhCeG1MkKkwmluvrZ0KLYfKQBAFzxbIN0//l3ExMRT
         FZWM5JFFnfNP3jY8VCd/t6rhjfu9AtjWRSSSoOfve2PtLNOXRT9MsPNXGr/BQdnefaT8
         WDSKhjucKyr39kuwC5m2dhmNCKDehhjywxXUH9qOq7/kym0KvgeahWLVtA0WtTfY5UvX
         6Jr2CRcjudNQuW6S6qYHQXfEtW5GbYNWVASEJd0+hFyGgt085mkpxj/WCELbE3CI1x0C
         t2qQ==
X-Gm-Message-State: AA+aEWYZgOR1TFQdzClLbQAF12hU2sEgmhf1BBArK8DoGLMbv51/3lvS
        +GB4JxoFsR9Z7pG4ZYci1uUvrg==
X-Google-Smtp-Source: AFSGD/V8lt2aypKwunPc9JsTJIRbycqRD7gHDtKE1g8rGDLqQBHdo93H+xwp6c/t3PypNID6lvgBcQ==
X-Received: by 2002:a02:6c90:: with SMTP id w138mr6303762jab.60.1543608750409;
        Fri, 30 Nov 2018 12:12:30 -0800 (PST)
Received: from [192.168.1.56] ([216.160.245.98])
        by smtp.gmail.com with ESMTPSA id t124sm101335ita.3.2018.11.30.12.12.27
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 30 Nov 2018 12:12:29 -0800 (PST)
Subject: Re: [PATCH RFC 00/15] Zero ****s, hugload of hugs <3
To:     Davidlohr Bueso <dave@stgolabs.net>,
        Kees Cook <keescook@chromium.org>
Cc:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Amir Goldstein <amir73il@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Daniel Axtens <dja@axtens.net>,
        "David S. Miller" <davem@davemloft.net>,
        Dominik Brodowski <linux@dominikbrodowski.net>,
        Maling list - DRI developers 
        <dri-devel@lists.freedesktop.org>,
        Eric Dumazet <edumazet@google.com>, federico.vaga@vaga.pv.it,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Helge Deller <deller@gmx.de>, Jonathan Corbet <corbet@lwn.net>,
        Joshua Kinard <kumba@gentoo.org>,
        "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        linux-ide@vger.kernel.org, linux-m68k@lists.linux-m68k.org,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux MIPS Mailing List <linux-mips@linux-mips.org>,
        Linux mtd <linux-mtd@lists.infradead.org>,
        linux-parisc <linux-parisc@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        linux-scsi@vger.kernel.org, matthias.bgg@gmail.com,
        Network Development <netdev@vger.kernel.org>,
        nouveau <nouveau@lists.freedesktop.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Paul Burton <paul.burton@mips.com>,
        Petr Mladek <pmladek@suse.com>, Rob Herring <robh@kernel.org>,
        sean.wang@mediatek.com,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        shannon.nelson@oracle.com, Stefano Brivio <sbrivio@redhat.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        "Tobin C. Harding" <me@tobin.cc>, makita.toshiaki@lab.ntt.co.jp,
        Willem de Bruijn <willemb@google.com>,
        Yonghong Song <yhs@fb.com>, yanjun.zhu@oracle.com
References: <20181130192737.15053-1-jarkko.sakkinen@linux.intel.com>
 <CAGXu5j+jBNBsD3pvUSfEh6Lc5T1YMpbM0HeG1c6BHiJe+cKVOQ@mail.gmail.com>
 <20181130195652.7syqys76646kpaph@linux-r8p5>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <d7c34289-f03a-b641-cc9c-00395306511d@kernel.dk>
Date:   Fri, 30 Nov 2018 13:12:26 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.2.1
MIME-Version: 1.0
In-Reply-To: <20181130195652.7syqys76646kpaph@linux-r8p5>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org
Message-ID: <20181130201226.4oHoGhV9iAH1amKa5oxJN7Anma5BMWu_Q2pbOtEuaV0@z>

On 11/30/18 12:56 PM, Davidlohr Bueso wrote:
> On Fri, 30 Nov 2018, Kees Cook wrote:
> 
>> On Fri, Nov 30, 2018 at 11:27 AM Jarkko Sakkinen
>> <jarkko.sakkinen@linux.intel.com> wrote:
>>>
>>> In order to comply with the CoC, replace **** with a hug.
> 
> I hope this is some kind of joke. How would anyone get offended by reading
> technical comments? This is all beyond me...

Agree, this is insanity.

-- 
Jens Axboe

