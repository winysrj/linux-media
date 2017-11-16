Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ot0-f194.google.com ([74.125.82.194]:56757 "EHLO
        mail-ot0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1759344AbdKPLiV (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 16 Nov 2017 06:38:21 -0500
MIME-Version: 1.0
In-Reply-To: <1510829480-24760-1-git-send-email-geert@linux-m68k.org>
References: <1510829480-24760-1-git-send-email-geert@linux-m68k.org>
From: Arnd Bergmann <arnd@arndb.de>
Date: Thu, 16 Nov 2017 12:38:20 +0100
Message-ID: <CAK8P3a0suV4at56Uu6N9Y8urumUnqLw8ZRuLAqp9FOK_OvJw7A@mail.gmail.com>
Subject: Re: [PATCH] media: dvb_frontend: Fix uninitialized error in dvb_frontend_handle_ioctl()
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Shuah Khan <shuah@kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Nov 16, 2017 at 11:51 AM, Geert Uytterhoeven
<geert@linux-m68k.org> wrote:
> With gcc-4.1.2:
>
>     drivers/media/dvb-core/dvb_frontend.c: In function =E2=80=98dvb_front=
end_handle_ioctl=E2=80=99:
>     drivers/media/dvb-core/dvb_frontend.c:2110: warning: =E2=80=98err=E2=
=80=99 may be used uninitialized in this function
>
> Indeed, there are 13 cases where err is used initialized if one of the
> dvb_frontend_ops is not implemented.
>
> Preinitialize err to -EOPNOTSUPP like before to fix this.
>
> Fixes: d73dcf0cdb95a47f ("media: dvb_frontend: cleanup ioctl handling log=
ic")
> Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>

Good catch!

This one shows up on x86 allmdoconfig with gcc-4.5 or older but not gcc-4.6=
.

Acked-by: Arnd Bergmann <arnd@arndb.de>
