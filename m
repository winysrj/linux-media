Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf1-f193.google.com ([209.85.210.193]:37878 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726862AbeKIDkH (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 8 Nov 2018 22:40:07 -0500
Received: by mail-pf1-f193.google.com with SMTP id u13-v6so9646033pfm.4
        for <linux-media@vger.kernel.org>; Thu, 08 Nov 2018 10:03:28 -0800 (PST)
MIME-Version: 1.0
References: <cover.1541451484.git.dafna3@gmail.com> <CAAEAJfC=R3U9Pz0K5MkYT1Y0FM=PA2e6uUfbYL3sfDuobCWMDA@mail.gmail.com>
 <CAJ1myNSJ5RtaJgAubNyxmH-JrZdVpZtjHL6-jDhW65oStqX-Ow@mail.gmail.com> <20181108175422.GA14882@sasha-vm>
In-Reply-To: <20181108175422.GA14882@sasha-vm>
From: Ezequiel Garcia <ezequiel@vanguardiasur.com.ar>
Date: Thu, 8 Nov 2018 15:03:16 -0300
Message-ID: <CAAEAJfDCkavy-32xR_jCUQfu3jofKQdjrMHMikaTND=TUxJhiw@mail.gmail.com>
Subject: Re: [Outreachy kernel] [PATCH vicodec v4 0/3] Add support to more
 pixel formats in vicodec
To: sashal@kernel.org
Cc: Dafna Hirschfeld <dafna3@gmail.com>, helen.koike@collabora.com,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        outreachy-kernel@googlegroups.com,
        linux-media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, 8 Nov 2018 at 14:54, Sasha Levin <sashal@kernel.org> wrote:
>
> On Thu, Nov 08, 2018 at 10:10:10AM +0200, Dafna Hirschfeld wrote:
> >On Thu, Nov 8, 2018 at 2:51 AM Ezequiel Garcia <
> >ezequiel@vanguardiasur.com.ar> wrote:
> >
> >> Hello Dafna,
> >>
> >> Thanks for the patches.
> >>
> >> Just out of curiosity.  Why these patches havent't been submitted to
> >> the media mailing list?
> >>
> >> Hi,
> >I wasn't sure if I should send it to the media mailing list, since this
> >part of outreachy application.
>
> In general, for any patch you send to any subsystem please Cc all the
> relevant mailing lists and maintainers. For Outreachy application you
> already did that (by Cc'ing Greg), you just need to keep doing the same
> as you continue your work on other parts of the kernel.
>

Let's Cc the mailing list now, as these patches look good, and the
test scripts look pretty decent too ;-)

> >Also, how are you testing these changes?
> >>
> >
> >Based on Helen's decoder:
> >https://gitlab.collabora.com/koike/v4l2-codec
> >
> >I extended it to include encoders and decoders for the new supported
> >formats.
> >
> >testing formats with alpha plane:
> >https://github.com/kamomil/outreachy/blob/master/argb-and-abgr-full-exam=
ple.sh
> >
> >testing greyscale:
> >https://github.com/kamomil/outreachy/blob/master/greyscale-full-example.=
sh
>
> It's awesome seeing these testsuites, it gives reviewers confidence that
> your patch is well tested and they can focus on other parts of the
> review process rather than check for the basic correctness of the patch.
>
> Please include links such as these and indicate how you tested your code
> in your future patches.
>

+1

Thanks!
--=20
Ezequiel Garc=C3=ADa, VanguardiaSur
www.vanguardiasur.com.ar
