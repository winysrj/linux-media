Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm1-f68.google.com ([209.85.128.68]:33725 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725746AbeKHFR0 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 8 Nov 2018 00:17:26 -0500
Received: by mail-wm1-f68.google.com with SMTP id f19-v6so12111470wmb.0
        for <linux-media@vger.kernel.org>; Wed, 07 Nov 2018 11:45:36 -0800 (PST)
Subject: Re: [PATCH] keytable: fix BPF protocol compilation on mips
To: Sean Young <sean@mess.org>, linux-media@vger.kernel.org
References: <20181107153631.15908-1-sean@mess.org>
From: Gregor Jasny <gjasny@googlemail.com>
Message-ID: <b8b83176-5c5b-7c80-f347-b660356edce0@googlemail.com>
Date: Wed, 7 Nov 2018 20:45:34 +0100
MIME-Version: 1.0
In-Reply-To: <20181107153631.15908-1-sean@mess.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 11/7/18 4:36 PM, Sean Young wrote:
> clang -idirafter /usr/local/include -idirafter
> +/usr/lib/llvm-6.0/lib/clang/6.0.1/include -idirafter
> +/usr/include/mips64el-linux-gnuabi64 -idirafter /usr/include
> +-I../../../include -target bpf -O2 -c grundig.c
>> In file included from grundig.c:5:
>> In file included from ../../../include/linux/lirc.h:10:
>> In file included from /usr/include/linux/types.h:9:
>> In file included from /usr/include/linux/posix_types.h:36:
>> In file included from
> +/usr/include/mips64el-linux-gnuabi64/asm/posix_types.h:13:
>> /usr/include/mips64el-linux-gnuabi64/asm/sgidefs.h:19:2: error: Use a Linux
> +compiler or give up.
>> #error Use a Linux compiler or give up.
> 
> This requires __linux__ to be defined.

Thanks! I uploaded a new Debian package. Let's see how it goes:
https://buildd.debian.org/status/package.php?p=v4l-utils

I'll pick up your other patches soon.

-Gregor
