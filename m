Return-Path: <SRS0=A0HE=OJ=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 80EFAC64EB4
	for <linux-media@archiver.kernel.org>; Fri, 30 Nov 2018 20:33:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 38D8B20660
	for <linux-media@archiver.kernel.org>; Fri, 30 Nov 2018 20:33:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="MEvQVGzP"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 38D8B20660
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-media-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726748AbeLAHoA (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Sat, 1 Dec 2018 02:44:00 -0500
Received: from mail-ed1-f67.google.com ([209.85.208.67]:35932 "EHLO
        mail-ed1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725847AbeLAHn7 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Sat, 1 Dec 2018 02:43:59 -0500
Received: by mail-ed1-f67.google.com with SMTP id f23so5893401edb.3;
        Fri, 30 Nov 2018 12:33:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:openpgp:autocrypt:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=sjYPzvTZq2AiQ0mNVk5ZjXI7kYp1qnRsFQ21YkcKqQE=;
        b=MEvQVGzPIb1HQHcIyqBOoL7GLe7KBZHf7dA8fOiTcs8vPaH+MJ6ER0rDv64Ai8OgY/
         BETyz16+jH0k0YfNXbggFaY4pQjY/OhPaBm6SyxAjnlmqzHMxw46NCKf5I2clvtrxbpG
         Vsn1ty5jljr6w2fEZa/ntJNTnrQfST58P2db5b78NruK0mxBWc4yRE6vJ+A6OViVoENI
         8I0ldHpFIJxaBdMTFI6IJGSBORDnveH4Z0Rl+EuOxqtX8qGdvd4D9DvBuoLv8/qzwAPO
         vFQjJ8JTErc+ES7vxSToj4R++LzvcvyXg/zR15zE/HzYGxcYExABPSsXSl62ksvC54kq
         Jfaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=sjYPzvTZq2AiQ0mNVk5ZjXI7kYp1qnRsFQ21YkcKqQE=;
        b=qwCeE1E6DRQ1AdnmeNYzztziOxShLv66X3CTIzaDeW8IV4tmcVm5J7rhORurhEWmXP
         rLbt0m/IarsSENpXKPJRwhazSVaGD6D/g3m8hJ++FO6HjSh/SbtK8lO4+TYHn5d8vP5F
         gSLntrSjwfF0sGOs0NPB0AvvKLfgTl3k6wivdqzqLj68Ua4I1u9e4+YGjs2BvYdWjYlj
         EC8Ae766pTU2jsO+kpp3QpcwN0JNoMcx25HnscuhQEwv+kWvOjLwtrT3gqjlcgSqQw1n
         N7fnMV9+zoMWSP0cN8WsiFcvaQ6sKdTOmqMpbEwKzjVLEaay/ibW37ywByVMPzBH+ua5
         IjGg==
X-Gm-Message-State: AA+aEWZh1uzzszmSxc8i65O0uPtnuYW2cniLm89+ow810yi0qrcarLzH
        QlCKEjs4v11H/oVvYKa2F6g=
X-Google-Smtp-Source: AFSGD/Vc8ST9g/LPkfIEdA8kSuDiuzpL3wZWWaBxfUHae4BNWiY5Opnl0iXErbRnIjWu1FVm0Z9uHQ==
X-Received: by 2002:a17:906:4003:: with SMTP id v3-v6mr5734841ejj.240.1543610007754;
        Fri, 30 Nov 2018 12:33:27 -0800 (PST)
Received: from ziggy.stardust ([93.176.147.153])
        by smtp.gmail.com with ESMTPSA id n10sm1255104edq.33.2018.11.30.12.33.24
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 30 Nov 2018 12:33:26 -0800 (PST)
Subject: Re: [PATCH RFC 00/15] Zero ****s, hugload of hugs <3
To:     Kees Cook <keescook@chromium.org>,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc:     LKML <linux-kernel@vger.kernel.org>,
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
        linux-scsi@vger.kernel.org,
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
From:   Matthias Brugger <matthias.bgg@gmail.com>
Openpgp: preference=signencrypt
Autocrypt: addr=matthias.bgg@gmail.com; prefer-encrypt=mutual; keydata=
 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
 UXI+r2JwH1CJjrHWeQEI2ucSKsNa8FllDmG/fQ==
Message-ID: <f9c2db3b-2c9a-5e8c-e899-59bb5f554d19@gmail.com>
Date:   Fri, 30 Nov 2018 21:31:13 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.3.0
MIME-Version: 1.0
In-Reply-To: <CAGXu5j+jBNBsD3pvUSfEh6Lc5T1YMpbM0HeG1c6BHiJe+cKVOQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org
Message-ID: <20181130203113.QwXoQc-85Z71SVNRmM7U1Ns_GYKrtctCfdcX3WPtMuk@z>



On 30/11/2018 20:40, Kees Cook wrote:
> On Fri, Nov 30, 2018 at 11:27 AM Jarkko Sakkinen
> <jarkko.sakkinen@linux.intel.com> wrote:
>>
>> In order to comply with the CoC, replace **** with a hug.
> 
> Heh. I support the replacement of the stronger language, but I find
> "hug", "hugged", and "hugging" to be very weird replacements. Can we
> bikeshed this to "heck", "hecked", and "hecking" (or "heckin" to
> follow true Doggo meme style).
> 
> "This API is hugged" doesn't make any sense to me. "This API is
> hecked" is better, or at least funnier (to me). "Hug this interface"
> similarly makes no sense, but "Heck this interface" seems better.
> "Don't touch my hecking code", "What the heck were they thinking?"
> etc... "hug" is odd.
> 

Like John I don't think that the word "fuck" is something we have to ban from
the source code, but I don't care too much. Anyway, please don't change it to
something like heck as it might be difficult for non-english speaker to understand.

Regards,
Matthias

> Better yet, since it's only 17 files, how about doing context-specific
> changes? "This API is terrible", "Hateful interface", "Don't touch my
> freakin' code", "What in the world were they thinking?" etc?
> 
> -Kees
> 
>>
>> Jarkko Sakkinen (15):
>>   MIPS: replace **** with a hug
>>   Documentation: replace **** with a hug
>>   drm/nouveau: replace **** with a hug
>>   m68k: replace **** with a hug
>>   parisc: replace **** with a hug
>>   cpufreq: replace **** with a hug
>>   ide: replace **** with a hug
>>   media: replace **** with a hug
>>   mtd: replace **** with a hug
>>   net/sunhme: replace **** with a hug
>>   scsi: replace **** with a hug
>>   inotify: replace **** with a hug
>>   irq: replace **** with a hug
>>   lib: replace **** with a hug
>>   net: replace **** with a hug
>>
>>  Documentation/kernel-hacking/locking.rst      |  2 +-
>>  arch/m68k/include/asm/sun3ints.h              |  2 +-
>>  arch/mips/pci/ops-bridge.c                    | 24 +++++++++----------
>>  arch/mips/sgi-ip22/ip22-setup.c               |  2 +-
>>  arch/parisc/kernel/sys_parisc.c               |  2 +-
>>  drivers/cpufreq/powernow-k7.c                 |  2 +-
>>  .../gpu/drm/nouveau/nvkm/subdev/bios/init.c   |  2 +-
>>  .../nouveau/nvkm/subdev/pmu/fuc/macros.fuc    |  2 +-
>>  drivers/ide/cmd640.c                          |  2 +-
>>  drivers/media/i2c/bt819.c                     |  8 ++++---
>>  drivers/mtd/mtd_blkdevs.c                     |  2 +-
>>  drivers/net/ethernet/sun/sunhme.c             |  4 ++--
>>  drivers/scsi/qlogicpti.h                      |  2 +-
>>  fs/notify/inotify/inotify_user.c              |  2 +-
>>  kernel/irq/timings.c                          |  2 +-
>>  lib/vsprintf.c                                |  2 +-
>>  net/core/skbuff.c                             |  2 +-
>>  17 files changed, 33 insertions(+), 31 deletions(-)
>>
>> --
>> 2.19.1
>>
> 
> 
