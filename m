Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yw0-f194.google.com ([209.85.161.194]:33954 "EHLO
        mail-yw0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756497AbcKKPuU (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 11 Nov 2016 10:50:20 -0500
Received: by mail-yw0-f194.google.com with SMTP id a10so1443557ywa.1
        for <linux-media@vger.kernel.org>; Fri, 11 Nov 2016 07:50:20 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <dad6e38b-093b-bd36-3e0d-a0c10bddea58@xs4all.nl>
References: <20161025235536.7342-1-khilman@baylibre.com> <20161025235536.7342-7-khilman@baylibre.com>
 <dad6e38b-093b-bd36-3e0d-a0c10bddea58@xs4all.nl>
From: Javier Martinez Canillas <javier@dowhile0.org>
Date: Fri, 11 Nov 2016 12:50:19 -0300
Message-ID: <CABxcv==ZR0=4GhXECiKtFJZ3WEY_5h-Egvs3hjBK56FiQeF6Jg@mail.gmail.com>
Subject: Re: [RFC PATCH 6/6] [media] davinci: vpif_capture: get subdevs from DT
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Kevin Hilman <khilman@baylibre.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Sekhar Nori <nsekhar@ti.com>,
        Axel Haslam <ahaslam@baylibre.com>,
        =?UTF-8?Q?Bartosz_Go=C5=82aszewski?= <bgolaszewski@baylibre.com>,
        Alexandre Bailon <abailon@baylibre.com>,
        David Lechner <david@lechnology.com>,
        "linux-arm-kernel@lists.infradead.org"
        <linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

On Fri, Nov 11, 2016 at 12:36 PM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
> On 10/26/2016 01:55 AM, Kevin Hilman wrote:
>> First pass at getting subdevs from DT ports and endpoints.
>>
>> The _get_pdata() function was larely inspired by (i.e. stolen from)
>> am437x-vpfe.c
>>
>> Questions:
>> - Legacy board file passes subdev input & output routes via pdata
>>   (e.g. tvp514x svideo or composite selection.)  How is this supposed
>>   to be done via DT?
>
> We have plans to model connectors as well in the device tree, but no
> implementation exists yet. I think Laurent has some code in progress for this,
> but I may be mistaken.
>

I posted a RFC series [0] some time ago, that proposed a DT binding
for input connectors [1] using OF graphs.

I never re-spin the series because Laurent had some comments on the DT
bindings and I was waiting for a response on to my latest email [2].
So if you can comment on this and see if the DT bindings fits your,
would be very useful.

> Anyway, hard-coding it like you do now is for now the only way.
>
>         Hans
>
>>

[0]: https://www.mail-archive.com/linux-media@vger.kernel.org/msg96393.html
[1]: http://www.spinics.net/lists/linux-media/msg99421.html
[2]: http://www.spinics.net/lists/linux-media/msg99987.html

Best regards,
Javier
