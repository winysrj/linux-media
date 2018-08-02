Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp13.smtpout.orange.fr ([80.12.242.135]:48185 "EHLO
        smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1732110AbeHBOra (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 2 Aug 2018 10:47:30 -0400
Received: by mail-qt0-f179.google.com with SMTP id n6-v6so2119929qtl.4
        for <linux-media@vger.kernel.org>; Thu, 02 Aug 2018 05:56:23 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <80eb63eee4ad1927a617ce526e7aba2342ac66f8.camel@baylibre.com>
References: <20180801193320.25313-1-maxi.jourdan@wanadoo.fr> <80eb63eee4ad1927a617ce526e7aba2342ac66f8.camel@baylibre.com>
From: Maxime Jourdan <maxi.jourdan@wanadoo.fr>
Date: Thu, 2 Aug 2018 14:56:22 +0200
Message-ID: <CAHStOZ4pt4ECYcLkv8mXZkB5JvUm0NVp9sD6mfQofDLgpUHMiA@mail.gmail.com>
Subject: Re: [RFC 0/4] media: meson: add video decoder driver
To: Jerome Brunet <jbrunet@baylibre.com>,
        Neil <narmstrong@baylibre.com>, Hans Verkuil <hverkuil@xs4all.nl>
Cc: Maxime Jourdan <maxi.jourdan@wanadoo.fr>,
        linux-media@vger.kernel.org,
        linux-amlogic <linux-amlogic@lists.infradead.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Jerome, Neil, Hans,

Thanks a lot for all the insights.

2018-08-02 8:59 GMT+02:00 Hans Verkuil <hverkuil@xs4all.nl>:
>>       fail: ../../../v4l-utils-1.12.3/utils/v4l2-compliance/v4l2-test-buffers.cpp(571): q.has_expbuf(node)
>>       test VIDIOC_EXPBUF: FAIL
>
> Not sure, might well be a knock-on result of the 'one open' problem.
>
> BTW, always get the latest code from the v4l-utils git repo, don't use a released
> version for v4l2-compliance: it's always evolving and you don't want to use an
> old version. Also for the next version of this patch series add the output of
> v4l2-compliance to this cover letter, I want to see it.

Will do.

> Finally, are you aware of the work Tomasz Figa on specifying the codec behavior?
>
> https://lkml.org/lkml/2018/7/24/539
>
> The final version will be close to what was posted there.

I wasn't, thanks for pointing it out.
