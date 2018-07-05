Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yb0-f195.google.com ([209.85.213.195]:44055 "EHLO
        mail-yb0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753721AbeGEKOc (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 5 Jul 2018 06:14:32 -0400
Received: by mail-yb0-f195.google.com with SMTP id a2-v6so3002963ybe.11
        for <linux-media@vger.kernel.org>; Thu, 05 Jul 2018 03:14:32 -0700 (PDT)
Received: from mail-yb0-f171.google.com (mail-yb0-f171.google.com. [209.85.213.171])
        by smtp.gmail.com with ESMTPSA id g5-v6sm34209ywd.70.2018.07.05.03.14.30
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 05 Jul 2018 03:14:30 -0700 (PDT)
Received: by mail-yb0-f171.google.com with SMTP id r3-v6so3011723ybo.4
        for <linux-media@vger.kernel.org>; Thu, 05 Jul 2018 03:14:30 -0700 (PDT)
MIME-Version: 1.0
References: <20180515075859.17217-1-stanimir.varbanov@linaro.org>
 <20180515075859.17217-13-stanimir.varbanov@linaro.org> <CAAFQd5Bj73zyi0vsaSJ2sam2TGm7agshXg+n+sa2c7HoqLRGUw@mail.gmail.com>
 <13c7aec1-2bb9-f449-6b7d-7ec93be4ec71@linaro.org> <CAAFQd5B8UVk3n7m+MV3t68vrDhtd9Hi_CnuYS-4QFaVdByOTyA@mail.gmail.com>
 <CAAFQd5CddQBo2JRaab0uWdtkmetd=zDzVt=rM+vJZQ7DM-kLGA@mail.gmail.com>
 <30d141b6-dffa-bf6a-dae8-79595c966a23@linaro.org> <CAAFQd5Aet4Hb62Jps6QPu+0fLsB=ruxH1qFwE93c_MWygvmXBw@mail.gmail.com>
 <abc191de-de3c-4e5b-9907-5094e82ff50a@linaro.org>
In-Reply-To: <abc191de-de3c-4e5b-9907-5094e82ff50a@linaro.org>
From: Tomasz Figa <tfiga@chromium.org>
Date: Thu, 5 Jul 2018 19:14:18 +0900
Message-ID: <CAAFQd5CR8fOjKkhkyGhFNk-E-fj5pHjT9jT42+MXd8PmAk-i9g@mail.gmail.com>
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

On Thu, Jul 5, 2018 at 6:45 PM Stanimir Varbanov
<stanimir.varbanov@linaro.org> wrote:
>
> Hi Tomasz,
>
> On 07/02/2018 01:05 PM, Tomasz Figa wrote:
> > On Mon, Jul 2, 2018 at 6:59 PM Stanimir Varbanov
> > <stanimir.varbanov@linaro.org> wrote:
> >>
> >> Hi Tomasz,
> >>
> >> On 07/02/2018 12:23 PM, Tomasz Figa wrote:
> >>> On Thu, May 31, 2018 at 4:06 PM Tomasz Figa <tfiga@chromium.org> wrot=
e:
> >>>>
> >>>> On Thu, May 31, 2018 at 1:21 AM Stanimir Varbanov
> >>>> <stanimir.varbanov@linaro.org> wrote:
> >>>>>
> >>>>> Hi Tomasz,
> >>>>>
> >>>>> On 05/24/2018 05:16 PM, Tomasz Figa wrote:
> >>>>>> Hi Stanimir,
> >>>>>>
> >>>>>> On Tue, May 15, 2018 at 5:08 PM Stanimir Varbanov <
> >>> [snip]
> >>>>>>
> >>>>>>> +                       break;
> >>>>>>> +               }
> >>>>>>> +
> >>>>>>> +               word++;
> >>>>>>> +               words_count--;
> >>>>>>
> >>>>>> If data is at |word + 1|, shouldn=E2=80=99t we increment |word| by=
 |1 + |data
> >>>>>> size||?
> >>>>>
> >>>>> yes, that could be possible but the firmware packets are with varia=
ble
> >>>>> data length and don't want to make the code so complex.
> >>>>>
> >>>>> The idea is to search for HFI_PROPERTY_PARAM* key numbers. Yes it i=
s not
> >>>>> optimal but this enumeration is happen only once during driver prob=
e.
> >>>>>
> >>>>
> >>>> Hmm, do we have a guarantee that we will never find a value that
> >>>> matches HFI_PROPERTY_PARAM*, but would be actually just some data
> >>>> inside the payload?
> >>>
> >>> Ping?
> >>
> >> OK, you are right there is guarantee that we not mixing keywords and
> >
> > Did the auto-correction engine in my head got this correctly as "no
> > guarantee"? :)
> >
> >> data. I can make parse_* functions to return how words they consumed a=
nd
> >> increment 'word' pointer with consumed words.
> >
> > Yes, that or maybe just returning the pointer to the first word after
> > consumed data. Most of the looping functions already seem to have this
> > value, so it would have to be just returned. (vs having to subtract
> > from the start pointer)
>
> I made the relevant changes to satisfy you request but the results were
> fine for Venus v3 and wrong on v1. So I'd propose to postpone this
> change and fix it with follow up patches because I don't want miss the
> next merge window. So far the supported venus firmware versions are fine
> with the current parser implementation.
>
> What you think?

Fair enough. Generally with the design of those metadata, fixing this
problem seems to be quite non-trivial. Let's keep it as is for now.

Best regards,
Tomasz
