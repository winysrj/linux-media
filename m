Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-io0-f178.google.com ([209.85.223.178]:35384 "EHLO
        mail-io0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753158AbdCILJF (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 9 Mar 2017 06:09:05 -0500
Received: by mail-io0-f178.google.com with SMTP id z13so26111293iof.2
        for <linux-media@vger.kernel.org>; Thu, 09 Mar 2017 03:09:04 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <77ced65d-e350-02ba-6dae-b20dcb3faa32@xs4all.nl>
References: <1486485683-11427-1-git-send-email-bgolaszewski@baylibre.com> <77ced65d-e350-02ba-6dae-b20dcb3faa32@xs4all.nl>
From: Bartosz Golaszewski <bgolaszewski@baylibre.com>
Date: Thu, 9 Mar 2017 12:00:01 +0100
Message-ID: <CAMpxmJUZ3KCV2zjpPWD02rVpok_XV-fGdk8PNpN7FGt3RDbMEw@mail.gmail.com>
Subject: Re: [PATCH 00/10] ARM: davinci: add vpif display support
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Kevin Hilman <khilman@kernel.org>, Sekhar Nori <nsekhar@ti.com>,
        Patrick Titiano <ptitiano@baylibre.com>,
        Michael Turquette <mturquette@baylibre.com>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Russell King <linux@armlinux.org.uk>,
        Alexandre Bailon <abailon@baylibre.com>,
        David Lechner <david@lechnology.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Lad Prabhakar <prabhakar.csengg@gmail.com>,
        linux-devicetree <devicetree@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        arm-soc <linux-arm-kernel@lists.infradead.org>,
        linux-media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

2017-03-09 11:53 GMT+01:00 Hans Verkuil <hverkuil@xs4all.nl>:
> On 07/02/17 17:41, Bartosz Golaszewski wrote:
>> The following series adds support for v4l2 display on da850-evm with
>> a UI board in device tree boot mode.
>
> As far as I could tell from the comments this patch series will see a
> second version, so I am marking it as 'Changes Requested' in patchwork.
>
> If I'm wrong, then please let me know.
>
> Regards,
>
>         Hans
>

Hi Hans,

this series has since been split into several smaller ones and most of
the code is already merged into Sekhar Nori's DaVinci tree.

There are two series that still need merging with the media tree[1][2].

Thanks,
Bartosz Golaszewski

[1] https://lkml.org/lkml/2017/2/28/426
[2] https://patchwork.kernel.org/patch/9577965/
