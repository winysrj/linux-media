Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-io0-f181.google.com ([209.85.223.181]:33967 "EHLO
        mail-io0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751773AbdCOLtR (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 15 Mar 2017 07:49:17 -0400
Received: by mail-io0-f181.google.com with SMTP id b140so18180678iof.1
        for <linux-media@vger.kernel.org>; Wed, 15 Mar 2017 04:49:16 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAM3PiRyZ6y5=D-O2z39qoqNAXkkEROwZ3_g9gctrVqF-Gd+Ysg@mail.gmail.com>
References: <CAM3PiRyZ6y5=D-O2z39qoqNAXkkEROwZ3_g9gctrVqF-Gd+Ysg@mail.gmail.com>
From: Javier Martinez Canillas <javier@dowhile0.org>
Date: Wed, 15 Mar 2017 08:49:15 -0300
Message-ID: <CABxcv=n6GxpcLN6CR2mL+SZX95M9Vj6gg5iK3U3ggYTCK20KXg@mail.gmail.com>
Subject: Re: [PATCH v2 00/15] Exynos MFC v6+ - remove the need for the
 reserved memory
To: Marian Mihailescu <mihailescu2m@gmail.com>,
        Shuah Khan <shuahkh@osg.samsung.com>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Marian,

On Wed, Mar 15, 2017 at 8:36 AM, Marian Mihailescu
<mihailescu2m@gmail.com> wrote:
> Hi,
>
> After testing these patches, encoding using MFC fails when requesting
> buffers for capture (it works for output) with ENOMEM (it complains it
> cannot allocate memory on bank1).
> Did anyone else test encoding?
>

I've not tested encoding, but I did test decoding and it works for me
with Shuah's patch to increase the CMA memory [0]. Did you test with
that one as well?

Also you could try using the 5p_mfc.mem kernel param as explained in
the commit message of "media: s5p-mfc: Add support for probe-time
preallocated block based allocator".

[0]: https://patchwork.kernel.org/patch/9596737/

> Thanks,
> Marian
>

Best regards,
Javier
