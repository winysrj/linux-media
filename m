Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f180.google.com ([209.85.192.180]:34702 "EHLO
        mail-pf0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750932AbdFWOwa (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 23 Jun 2017 10:52:30 -0400
Received: by mail-pf0-f180.google.com with SMTP id s66so24446350pfs.1
        for <linux-media@vger.kernel.org>; Fri, 23 Jun 2017 07:52:30 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <m34lv715hy.fsf@t19.piap.pl>
References: <590ADAB1.1040501@suntec.net> <m3h90thwjt.fsf@t19.piap.pl>
 <m3d1bhhwf3.fsf_-_@t19.piap.pl> <CAAEAJfBVOKBcZBg91EKHBXKMOkM6eRafe8=XnW8E=6vtn2dBmQ@mail.gmail.com>
 <m38tm3j0wr.fsf@t19.piap.pl> <CAAEAJfAo8-efB-ZopydXFdRZDKsTKcSzx1vkaJwcpDQQ1Eiivw@mail.gmail.com>
 <m3zieiheng.fsf@t19.piap.pl> <b088a7cd-7585-5235-224d-a90ea9042c24@xs4all.nl> <m34lv715hy.fsf@t19.piap.pl>
From: Ezequiel Garcia <ezequiel@vanguardiasur.com.ar>
Date: Fri, 23 Jun 2017 11:52:29 -0300
Message-ID: <CAAEAJfBrx-YBjMSfs_YwxuY=iaSYOxWKRYz+FjGUL_CwN6YD+w@mail.gmail.com>
Subject: Re: [PATCH] TW686x: Fix OOPS on buffer alloc failure
To: =?UTF-8?Q?Krzysztof_Ha=C5=82asa?= <khalasa@piap.pl>
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
        linux-media <linux-media@vger.kernel.org>,
        zhaoxuegang <zhaoxuegang@suntec.net>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 23 June 2017 at 05:18, Krzysztof Ha=C5=82asa <khalasa@piap.pl> wrote:
> Hans Verkuil <hverkuil@xs4all.nl> writes:
>
>> Any progress on this? I gather I can expect a new patch from someone?
>
> Well, the issue is trivial and very easy to test, though not present
> on common x86 hw. That patch I've sent fixes it, but I'm not the one who
> decides.

If you can re-submit your patch addressing all the comments, I'd be happy
to Ack it.

As it stands, with the wrong subject style and without a commit log,
it's a NAK on my side.
--=20
Ezequiel Garc=C3=ADa, VanguardiaSur
www.vanguardiasur.com.ar
