Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud2.xs4all.net ([194.109.24.25]:41674 "EHLO
        lb2-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1754137AbdCIMI2 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 9 Mar 2017 07:08:28 -0500
Subject: Re: [PATCH 00/10] ARM: davinci: add vpif display support
To: Bartosz Golaszewski <bgolaszewski@baylibre.com>
References: <1486485683-11427-1-git-send-email-bgolaszewski@baylibre.com>
 <77ced65d-e350-02ba-6dae-b20dcb3faa32@xs4all.nl>
 <CAMpxmJUZ3KCV2zjpPWD02rVpok_XV-fGdk8PNpN7FGt3RDbMEw@mail.gmail.com>
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
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <4b8381d2-25b5-2d46-9575-2e1182cd276c@xs4all.nl>
Date: Thu, 9 Mar 2017 13:05:14 +0100
MIME-Version: 1.0
In-Reply-To: <CAMpxmJUZ3KCV2zjpPWD02rVpok_XV-fGdk8PNpN7FGt3RDbMEw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 09/03/17 12:00, Bartosz Golaszewski wrote:
> 2017-03-09 11:53 GMT+01:00 Hans Verkuil <hverkuil@xs4all.nl>:
>> On 07/02/17 17:41, Bartosz Golaszewski wrote:
>>> The following series adds support for v4l2 display on da850-evm with
>>> a UI board in device tree boot mode.
>>
>> As far as I could tell from the comments this patch series will see a
>> second version, so I am marking it as 'Changes Requested' in patchwork.
>>
>> If I'm wrong, then please let me know.
>>
>> Regards,
>>
>>         Hans
>>
> 
> Hi Hans,
> 
> this series has since been split into several smaller ones and most of
> the code is already merged into Sekhar Nori's DaVinci tree.
> 
> There are two series that still need merging with the media tree[1][2].

Merged, thanks!

Regards,

	Hans

> 
> Thanks,
> Bartosz Golaszewski
> 
> [1] https://lkml.org/lkml/2017/2/28/426
> [2] https://patchwork.kernel.org/patch/9577965/
> 
