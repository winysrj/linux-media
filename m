Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f193.google.com ([209.85.192.193]:36660 "EHLO
        mail-pf0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934050AbdCVJdm (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 22 Mar 2017 05:33:42 -0400
Received: by mail-pf0-f193.google.com with SMTP id r137so22135359pfr.3
        for <linux-media@vger.kernel.org>; Wed, 22 Mar 2017 02:33:41 -0700 (PDT)
Content-Type: text/plain; charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 10.1 \(3251\))
Subject: Re: [PATCH v2 00/15] Exynos MFC v6+ - remove the need for the
 reserved memory
From: Marian Mihailescu <mihailescu2m@gmail.com>
In-Reply-To: <04742b05-76bc-a0ec-f5e8-fe3a50115c44@samsung.com>
Date: Wed, 22 Mar 2017 20:03:36 +1030
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
        linux-media@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <E30E2706-5AAF-4235-A515-B73F80D401D4@gmail.com>
References: <CAM3PiRyZ6y5=D-O2z39qoqNAXkkEROwZ3_g9gctrVqF-Gd+Ysg@mail.gmail.com>
 <CGME20170317120635eucas1p1d13c446f1418de46a49516e95bf9075d@eucas1p1.samsung.com>
 <04742b05-76bc-a0ec-f5e8-fe3a50115c44@samsung.com>
To: Andrzej Hajda <a.hajda@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

I was testing with the linux-next kernel + the v2 patches
HW: odroid xu4
decoding (working): tested with gstreamer
encoding: tested with gstreamer && mfc-patched ffmpeg
before patches: encoding worked
after patches: encoding didn=E2=80=99t work.

I moved on from linux-next in the meantime and I cannot give you logs, =
BUT I=E2=80=99ve seen Hardkernel applied these patches (and all the =
linux-next MFC patches) on top of their 4.9 tree, and the result is very =
similar to mine on linux-next: =
https://github.com/hardkernel/linux/issues/284

Mar 21 13:04:54 odroid kernel: [   37.165153] s5p_mfc_alloc_priv_buf:78: =
Allocating private buffer of size 23243744 failed
Mar 21 13:04:54 odroid kernel: [   37.171865] =
s5p_mfc_alloc_codec_buffers_v6:244: Failed to allocate Bank1 memory
Mar 21 13:04:54 odroid kernel: [   37.179143] vidioc_reqbufs:1174: =
Failed to allocate encoding buffers


A user reported even adding s5p_mfc.mem=3D64M did not make the encoder =
work.
Any thoughts?

Thanks,
M.

(resent in plain text format)

> On 17 Mar. 2017, at 10:36 pm, Andrzej Hajda <a.hajda@samsung.com> =
wrote:
>=20
> Hi Marian,
>=20
> On 15.03.2017 12:36, Marian Mihailescu wrote:
>> Hi,
>>=20
>> After testing these patches, encoding using MFC fails when requesting
>> buffers for capture (it works for output) with ENOMEM (it complains =
it
>> cannot allocate memory on bank1).
>> Did anyone else test encoding?
>=20
> I have tested encoding and it works on my test target. Could you =
provide
> more details of your setup:
> - which kernel and patches,
> - which hw,
> - which test app.
>=20
> Regards
> Andrzej
>=20
>=20
>>=20
>> Thanks,
>> Marian
>>=20
>> Either I've been missing something or nothing has been going on. (K. =
E. Gordon)
>>=20
>=20
