Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yb1-f195.google.com ([209.85.219.195]:34144 "EHLO
        mail-yb1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726596AbeJCNtb (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 3 Oct 2018 09:49:31 -0400
Received: by mail-yb1-f195.google.com with SMTP id 184-v6so1949343ybg.1
        for <linux-media@vger.kernel.org>; Wed, 03 Oct 2018 00:02:27 -0700 (PDT)
Received: from mail-yb1-f178.google.com (mail-yb1-f178.google.com. [209.85.219.178])
        by smtp.gmail.com with ESMTPSA id v34-v6sm233978ywh.45.2018.10.03.00.02.24
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 03 Oct 2018 00:02:25 -0700 (PDT)
Received: by mail-yb1-f178.google.com with SMTP id e190-v6so1940344ybb.5
        for <linux-media@vger.kernel.org>; Wed, 03 Oct 2018 00:02:24 -0700 (PDT)
MIME-Version: 1.0
References: <20181002113148.14897-1-mjourdan@baylibre.com> <f681dac8-0698-e0b3-eb15-94a46797a0ea@xs4all.nl>
In-Reply-To: <f681dac8-0698-e0b3-eb15-94a46797a0ea@xs4all.nl>
From: Tomasz Figa <tfiga@chromium.org>
Date: Wed, 3 Oct 2018 16:02:13 +0900
Message-ID: <CAAFQd5AFmiLpjbdCskqfN7hTfKM_2U+4d0Tmtw+8BPJtaRRJ=w@mail.gmail.com>
Subject: Re: [RFC PATCH] media: v4l2-ctrl: Add control for specific
 V4L2_EVENT_SRC_CH_RESOLUTION support
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: mjourdan@baylibre.com,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Oct 2, 2018 at 8:44 PM Hans Verkuil <hverkuil@xs4all.nl> wrote:
>
> On 10/02/18 13:31, Maxime Jourdan wrote:
> > For drivers that expose both an OUTPUT queue and
> > V4L2_EVENT_SRC_CH_RESOLUTION such as video decoders, it is
> > possible that support for this event is limited to a subset
> > of the enumerated OUTPUT formats.
> >
> > This adds V4L2_CID_SUPPORTS_CH_RESOLUTION that allows such a driver to
> > notify userspace of per-format support for this event.
>
> An alternative is a flag returned by ENUMFMT.
>
> I would definitely invert the flag/control since the default should be
> that this event is supported for these types of devices. Instead you
> want to signal the exception (not supported).
>
> I think a format flag is better since this is really tied to the format
> for this particular driver.

+1 for format flag. It will also make it easier for userspace to
enumerate the capabilities. For example, userspace that doesn't want
to handle resolution changes on its own (e.g. Chromium), could just
discard the formats for which the hardware/firmware doesn't handle
them.

Best regards,
Tomasz
