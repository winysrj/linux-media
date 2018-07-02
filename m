Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yw0-f196.google.com ([209.85.161.196]:41642 "EHLO
        mail-yw0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933910AbeGBJXm (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 2 Jul 2018 05:23:42 -0400
Received: by mail-yw0-f196.google.com with SMTP id j5-v6so6427265ywe.8
        for <linux-media@vger.kernel.org>; Mon, 02 Jul 2018 02:23:42 -0700 (PDT)
Received: from mail-yb0-f177.google.com (mail-yb0-f177.google.com. [209.85.213.177])
        by smtp.gmail.com with ESMTPSA id o11-v6sm3186641ywm.107.2018.07.02.02.23.40
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 02 Jul 2018 02:23:40 -0700 (PDT)
Received: by mail-yb0-f177.google.com with SMTP id x15-v6so4849308ybm.2
        for <linux-media@vger.kernel.org>; Mon, 02 Jul 2018 02:23:40 -0700 (PDT)
MIME-Version: 1.0
References: <20180515075859.17217-1-stanimir.varbanov@linaro.org>
 <20180515075859.17217-13-stanimir.varbanov@linaro.org> <CAAFQd5Bj73zyi0vsaSJ2sam2TGm7agshXg+n+sa2c7HoqLRGUw@mail.gmail.com>
 <13c7aec1-2bb9-f449-6b7d-7ec93be4ec71@linaro.org> <CAAFQd5B8UVk3n7m+MV3t68vrDhtd9Hi_CnuYS-4QFaVdByOTyA@mail.gmail.com>
In-Reply-To: <CAAFQd5B8UVk3n7m+MV3t68vrDhtd9Hi_CnuYS-4QFaVdByOTyA@mail.gmail.com>
From: Tomasz Figa <tfiga@chromium.org>
Date: Mon, 2 Jul 2018 18:23:28 +0900
Message-ID: <CAAFQd5CddQBo2JRaab0uWdtkmetd=zDzVt=rM+vJZQ7DM-kLGA@mail.gmail.com>
Subject: Re: [PATCH v2 12/29] venus: add common capability parser
To: Stanimir Varbanov <stanimir.varbanov@linaro.org>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-arm-msm <linux-arm-msm@vger.kernel.org>,
        vgarodia@codeaurora.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, May 31, 2018 at 4:06 PM Tomasz Figa <tfiga@chromium.org> wrote:
>
> On Thu, May 31, 2018 at 1:21 AM Stanimir Varbanov
> <stanimir.varbanov@linaro.org> wrote:
> >
> > Hi Tomasz,
> >
> > On 05/24/2018 05:16 PM, Tomasz Figa wrote:
> > > Hi Stanimir,
> > >
> > > On Tue, May 15, 2018 at 5:08 PM Stanimir Varbanov <
[snip]
> > >
> > >> +                       break;
> > >> +               }
> > >> +
> > >> +               word++;
> > >> +               words_count--;
> > >
> > > If data is at |word + 1|, shouldn=E2=80=99t we increment |word| by |1=
 + |data
> > > size||?
> >
> > yes, that could be possible but the firmware packets are with variable
> > data length and don't want to make the code so complex.
> >
> > The idea is to search for HFI_PROPERTY_PARAM* key numbers. Yes it is no=
t
> > optimal but this enumeration is happen only once during driver probe.
> >
>
> Hmm, do we have a guarantee that we will never find a value that
> matches HFI_PROPERTY_PARAM*, but would be actually just some data
> inside the payload?

Ping?

Best regards,
Tomasz
