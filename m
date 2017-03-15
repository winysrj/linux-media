Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f182.google.com ([209.85.192.182]:34650 "EHLO
        mail-pf0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750780AbdCOMBG (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 15 Mar 2017 08:01:06 -0400
Received: by mail-pf0-f182.google.com with SMTP id v190so8122424pfb.1
        for <linux-media@vger.kernel.org>; Wed, 15 Mar 2017 05:01:05 -0700 (PDT)
Content-Type: text/plain; charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 10.1 \(3251\))
Subject: Re: [PATCH v2 00/15] Exynos MFC v6+ - remove the need for the
 reserved memory
From: Marian Mihailescu <mihailescu2m@gmail.com>
In-Reply-To: <CABxcv=n6GxpcLN6CR2mL+SZX95M9Vj6gg5iK3U3ggYTCK20KXg@mail.gmail.com>
Date: Wed, 15 Mar 2017 22:30:58 +1030
Cc: Shuah Khan <shuahkh@osg.samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Transfer-Encoding: quoted-printable
Message-Id: <BD887BB3-53F1-4CBF-ACFF-0B6F271ABFE5@gmail.com>
References: <CAM3PiRyZ6y5=D-O2z39qoqNAXkkEROwZ3_g9gctrVqF-Gd+Ysg@mail.gmail.com>
 <CABxcv=n6GxpcLN6CR2mL+SZX95M9Vj6gg5iK3U3ggYTCK20KXg@mail.gmail.com>
To: Javier Martinez Canillas <javier@dowhile0.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Thanks for the quick reply.

Decoding works without issues for me too.
I did not change the CMA size or used s5p_mfc.mem parameter. However, =
according to the Marek, the default 8M should be enough for 3 instances =
of H264 encoders/decoders. My test was encoding a 30 seconds 720p clip, =
so I thought memory should not be a big issue; also it=E2=80=99s working =
w/o these patches applied, so I think CMA size is enough.
Nevertheless, I will try setting them, but I would feel better if =
someone else would try encoding too.

Cheers,
Marian

> On 15 Mar. 2017, at 10:19 pm, Javier Martinez Canillas =
<javier@dowhile0.org> wrote:
>=20
> Hello Marian,
>=20
> On Wed, Mar 15, 2017 at 8:36 AM, Marian Mihailescu
> <mihailescu2m@gmail.com> wrote:
>> Hi,
>>=20
>> After testing these patches, encoding using MFC fails when requesting
>> buffers for capture (it works for output) with ENOMEM (it complains =
it
>> cannot allocate memory on bank1).
>> Did anyone else test encoding?
>>=20
>=20
> I've not tested encoding, but I did test decoding and it works for me
> with Shuah's patch to increase the CMA memory [0]. Did you test with
> that one as well?
>=20
> Also you could try using the 5p_mfc.mem kernel param as explained in
> the commit message of "media: s5p-mfc: Add support for probe-time
> preallocated block based allocator".
>=20
> [0]: https://patchwork.kernel.org/patch/9596737/
>=20
>> Thanks,
>> Marian
>>=20
>=20
> Best regards,
> Javier
