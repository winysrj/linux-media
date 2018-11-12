Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-oi1-f193.google.com ([209.85.167.193]:46655 "EHLO
        mail-oi1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729816AbeKLRAA (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 12 Nov 2018 12:00:00 -0500
Received: by mail-oi1-f193.google.com with SMTP id e19-v6so6316424oii.13
        for <linux-media@vger.kernel.org>; Sun, 11 Nov 2018 23:08:05 -0800 (PST)
Received: from mail-oi1-f182.google.com (mail-oi1-f182.google.com. [209.85.167.182])
        by smtp.gmail.com with ESMTPSA id u128-v6sm6404613oig.21.2018.11.11.23.08.03
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 11 Nov 2018 23:08:03 -0800 (PST)
Received: by mail-oi1-f182.google.com with SMTP id u12-v6so858318oif.1
        for <linux-media@vger.kernel.org>; Sun, 11 Nov 2018 23:08:03 -0800 (PST)
MIME-Version: 1.0
References: <20181109095613.28272-1-hverkuil@xs4all.nl>
In-Reply-To: <20181109095613.28272-1-hverkuil@xs4all.nl>
From: Alexandre Courbot <acourbot@chromium.org>
Date: Mon, 12 Nov 2018 16:07:50 +0900
Message-ID: <CAPBb6MUXo4UCOSGCkjs7c9LW5BSWCBXM4LSDLN9vvZ_KVqHecg@mail.gmail.com>
Subject: Re: [RFC PATCH 0/5] vb2/cedrus: add cookie support
To: hverkuil@xs4all.nl
Cc: linux-media@vger.kernel.org, maxime.ripard@bootlin.com,
        paul.kocialkowski@bootlin.com, tfiga@chromium.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On Fri, Nov 9, 2018 at 6:56 PM Hans Verkuil <hverkuil@xs4all.nl> wrote:
>
> As was discussed here (among other places):
>
> https://lkml.org/lkml/2018/10/19/440
>
> using capture queue buffer indices to refer to reference frames is
> not a good idea. A better idea is to use 'cookies' (a better name is
> welcome!)

Maybe "tag" is more common for that kind of usage, but "cookie" is
fine as well IMHO.

I can only comment on patches 1-4, but so far it seems to me that this
would work. I will use this to base the next stateless codec API RFC.

Thanks!
Alex.
