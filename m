Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-io0-f175.google.com ([209.85.223.175]:33553 "EHLO
        mail-io0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751021AbdCOMZY (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 15 Mar 2017 08:25:24 -0400
Received: by mail-io0-f175.google.com with SMTP id f84so18708545ioj.0
        for <linux-media@vger.kernel.org>; Wed, 15 Mar 2017 05:25:23 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <BD887BB3-53F1-4CBF-ACFF-0B6F271ABFE5@gmail.com>
References: <CAM3PiRyZ6y5=D-O2z39qoqNAXkkEROwZ3_g9gctrVqF-Gd+Ysg@mail.gmail.com>
 <CABxcv=n6GxpcLN6CR2mL+SZX95M9Vj6gg5iK3U3ggYTCK20KXg@mail.gmail.com> <BD887BB3-53F1-4CBF-ACFF-0B6F271ABFE5@gmail.com>
From: Javier Martinez Canillas <javier@dowhile0.org>
Date: Wed, 15 Mar 2017 09:25:22 -0300
Message-ID: <CABxcv=kGM7RaLazr3_rG9JHfZgt65mw-xaSfuae_NFxB5yACVw@mail.gmail.com>
Subject: Re: [PATCH v2 00/15] Exynos MFC v6+ - remove the need for the
 reserved memory
To: Marian Mihailescu <mihailescu2m@gmail.com>
Cc: Shuah Khan <shuahkh@osg.samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Marian,

On Wed, Mar 15, 2017 at 9:00 AM, Marian Mihailescu
<mihailescu2m@gmail.com> wrote:
> Thanks for the quick reply.
>
> Decoding works without issues for me too.
> I did not change the CMA size or used s5p_mfc.mem parameter. However, acc=
ording to the Marek, the default 8M should be enough for 3 instances of H26=
4 encoders/decoders. My test was encoding a 30 seconds 720p clip, so I thou=
ght memory should not be a big issue; also it=E2=80=99s working w/o these p=
atches applied, so I think CMA size is enough.
> Nevertheless, I will try setting them, but I would feel better if someone=
 else would try encoding too.
>

Ok, I thought it may be that because Shuah and I needed to increase
the CMA size in order to decode a H.264 1080p video.

But if decoding is working correctly for you and only fails on
encoding, then I'm afraid that I won't be able to help you since as
mentioned I didn't test that.

> Cheers,
> Marian
>

Best regards,
Javier
