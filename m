Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-oi0-f41.google.com ([209.85.218.41]:34151 "EHLO
        mail-oi0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751012AbdA0TIt (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 27 Jan 2017 14:08:49 -0500
Received: by mail-oi0-f41.google.com with SMTP id s203so30588273oie.1
        for <linux-media@vger.kernel.org>; Fri, 27 Jan 2017 11:08:49 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <m2k2aze5xe.fsf@baylibre.com>
References: <20161207183025.20684-1-khilman@baylibre.com> <d4b0501a-f83a-c8b1-e460-1ba50f68cca7@xs4all.nl>
 <m2k2aze5xe.fsf@baylibre.com>
From: Kevin Hilman <khilman@baylibre.com>
Date: Fri, 27 Jan 2017 09:22:25 -0800
Message-ID: <CAOi56cX362PcE+dS59sGkh-=VMFNv_jaORMbCvxNr+VVUL7-mg@mail.gmail.com>
Subject: Re: [PATCH v6 0/5] davinci: VPIF: add DT support
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Sakari Ailus <sakari.ailus@iki.fi>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Sekhar Nori <nsekhar@ti.com>,
        Axel Haslam <ahaslam@baylibre.com>,
        =?UTF-8?Q?Bartosz_Go=C5=82aszewski?= <bgolaszewski@baylibre.com>,
        Alexandre Bailon <abailon@baylibre.com>,
        David Lechner <david@lechnology.com>,
        Patrick Titiano <ptitiano@baylibre.com>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Dec 16, 2016 at 4:49 PM, Kevin Hilman <khilman@baylibre.com> wrote:
> Hans Verkuil <hverkuil@xs4all.nl> writes:
>
>> On 07/12/16 19:30, Kevin Hilman wrote:
>>> Prepare the groundwork for adding DT support for davinci VPIF drivers.
>>> This series does some fixups/cleanups and then adds the DT binding and
>>> DT compatible string matching for DT probing.
>>>
>>> The controversial part from previous versions around async subdev
>>> parsing, and specifically hard-coding the input/output routing of
>>> subdevs, has been left out of this series.  That part can be done as a
>>> follow-on step after agreement has been reached on the path forward.
>>> With this version, platforms can still use the VPIF capture/display
>>> drivers, but must provide platform_data for the subdevs and subdev
>>> routing.
>>>
>>> Tested video capture to memory on da850-lcdk board using composite
>>> input.
>>
>> Other than the comment for the first patch this series looks good.
>>
>> So once that's addressed I'll queue it up for 4.11.
>
> I've fixed that issue, and sent an update for just that patch in reply
> to the original.
>
> Thanks for the review,

Gentle ping on this series.

I'm still not seeing this series yet in linux-next, so am worried it
might not make it for v4.11.

Kevin
