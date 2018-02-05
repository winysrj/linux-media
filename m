Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-it0-f47.google.com ([209.85.214.47]:36033 "EHLO
        mail-it0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750962AbeBEIxi (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 5 Feb 2018 03:53:38 -0500
Received: by mail-it0-f47.google.com with SMTP id n206so15036171itg.1
        for <linux-media@vger.kernel.org>; Mon, 05 Feb 2018 00:53:38 -0800 (PST)
Received: from mail-io0-f178.google.com (mail-io0-f178.google.com. [209.85.223.178])
        by smtp.gmail.com with ESMTPSA id k75sm5043359iod.27.2018.02.05.00.53.37
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 05 Feb 2018 00:53:37 -0800 (PST)
Received: by mail-io0-f178.google.com with SMTP id f4so29471206ioh.8
        for <linux-media@vger.kernel.org>; Mon, 05 Feb 2018 00:53:37 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <fb69d8ed-6318-3970-0e2e-873749720689@xs4all.nl>
References: <fb69d8ed-6318-3970-0e2e-873749720689@xs4all.nl>
From: Alexandre Courbot <acourbot@chromium.org>
Date: Mon, 5 Feb 2018 17:53:16 +0900
Message-ID: <CAPBb6MV==Bb-1b=gJm-er6J=9vHzDTuvMykJXWFv9N2GPCxF8A@mail.gmail.com>
Subject: Re: Compliance tests for new public API features
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Gustavo Padovan <gustavo@padovan.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On Sun, Feb 4, 2018 at 10:30 PM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
> Hi Gustavo, Alexandre,
>
> As you may have seen I have been extending the v4l2-compliance utility with tests
> for v4l-subdevX and mediaX devices. In the process of doing that I promptly
> found a bunch of bugs. Mostly little things that are easy to fix, but much
> harder to find without proper tests.
>
> You are both working on new API additions and I want to give a heads-up that
> I want to have patches for v4l2-compliance that test the new additions to a
> reasonable extent.
>
> I say 'reasonable' because I suspect that e.g. in-fence support might be hard
> to test. But out-fences can definitely be tested and for in-fences you can
> at minimum test what happens when you give it an invalid file descriptor.
>
> For the request API is it obviously too early to start writing tests, but
> as the API crystallizes you may consider starting to work on it.
>
> I've decided to be more strict about this based on my experiences. I'm more
> than happy to assist and give advice, especially since this is a bit of a late
> notice, particularly for Gustavo.
>
> But every time we skip this step it bites us in the ass later on.
>
> It is also highly recommended to add fence/request support to the vivid and
> vim2m drivers. It makes it much easier to find regressions in the API due to
> future changes since you don't need 'real' hardware for these drivers.
>
> Again my apologies for the late notice, but it is better to make these tests
> now while you are working on the new feature, rather than doing it much later
> and finding all sorts of gremlins in the API.

I completely agree with your reasoning and will consider updating
v4l2-compliance as soon as we have something stable on the user-facing
side (which hopefully should be close by now).

Alex.
