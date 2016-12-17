Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pg0-f53.google.com ([74.125.83.53]:33852 "EHLO
        mail-pg0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932929AbcLQAtI (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 16 Dec 2016 19:49:08 -0500
Received: by mail-pg0-f53.google.com with SMTP id a1so14654090pgf.1
        for <linux-media@vger.kernel.org>; Fri, 16 Dec 2016 16:49:07 -0800 (PST)
From: Kevin Hilman <khilman@baylibre.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Sakari Ailus <sakari.ailus@iki.fi>,
        linux-media@vger.kernel.org, Sekhar Nori <nsekhar@ti.com>,
        Axel Haslam <ahaslam@baylibre.com>,
        Bartosz =?utf-8?Q?Go=C5=82aszewski?= <bgolaszewski@baylibre.com>,
        Alexandre Bailon <abailon@baylibre.com>,
        David Lechner <david@lechnology.com>,
        Patrick Titiano <ptitiano@baylibre.com>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v6 0/5] davinci: VPIF: add DT support
References: <20161207183025.20684-1-khilman@baylibre.com>
        <d4b0501a-f83a-c8b1-e460-1ba50f68cca7@xs4all.nl>
Date: Fri, 16 Dec 2016 16:49:01 -0800
In-Reply-To: <d4b0501a-f83a-c8b1-e460-1ba50f68cca7@xs4all.nl> (Hans Verkuil's
        message of "Fri, 16 Dec 2016 10:47:09 +0100")
Message-ID: <m2k2aze5xe.fsf@baylibre.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hans Verkuil <hverkuil@xs4all.nl> writes:

> On 07/12/16 19:30, Kevin Hilman wrote:
>> Prepare the groundwork for adding DT support for davinci VPIF drivers.
>> This series does some fixups/cleanups and then adds the DT binding and
>> DT compatible string matching for DT probing.
>>
>> The controversial part from previous versions around async subdev
>> parsing, and specifically hard-coding the input/output routing of
>> subdevs, has been left out of this series.  That part can be done as a
>> follow-on step after agreement has been reached on the path forward.
>> With this version, platforms can still use the VPIF capture/display
>> drivers, but must provide platform_data for the subdevs and subdev
>> routing.
>>
>> Tested video capture to memory on da850-lcdk board using composite
>> input.
>
> Other than the comment for the first patch this series looks good.
>
> So once that's addressed I'll queue it up for 4.11.

I've fixed that issue, and sent an update for just that patch in reply
to the original.

Thanks for the review,

Kevin
