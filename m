Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f180.google.com ([209.85.192.180]:33433 "EHLO
        mail-pf0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755503AbcKKSCn (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 11 Nov 2016 13:02:43 -0500
Received: by mail-pf0-f180.google.com with SMTP id d2so12708276pfd.0
        for <linux-media@vger.kernel.org>; Fri, 11 Nov 2016 10:02:43 -0800 (PST)
From: Kevin Hilman <khilman@baylibre.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        linux-media@vger.kernel.org, Sekhar Nori <nsekhar@ti.com>,
        Axel Haslam <ahaslam@baylibre.com>,
        Bartosz =?utf-8?Q?Go=C5=82aszewski?= <bgolaszewski@baylibre.com>,
        Alexandre Bailon <abailon@baylibre.com>,
        David Lechner <david@lechnology.com>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [RFC PATCH 0/6] media: davinci: VPIF: add DT support
References: <20161025235536.7342-1-khilman@baylibre.com>
        <6058d790-5409-01c0-1d3f-b1bb45f8f85c@xs4all.nl>
Date: Fri, 11 Nov 2016 09:55:54 -0800
In-Reply-To: <6058d790-5409-01c0-1d3f-b1bb45f8f85c@xs4all.nl> (Hans Verkuil's
        message of "Fri, 11 Nov 2016 16:36:31 +0100")
Message-ID: <m2bmxllx3p.fsf@baylibre.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hans Verkuil <hverkuil@xs4all.nl> writes:

> Hi Kevin,
>
> On 10/26/2016 01:55 AM, Kevin Hilman wrote:
>> This series attempts to add DT support to the davinci VPIF capture
>> driver.
>> 
>> I'm not sure I've completely grasped the proper use of the ports and
>> endpoints stuff, so this RFC is primarily to get input on whether I'm
>> on the right track.
>> 
>> The last patch is the one where all my questions are, the rest are
>> just prep work to ge there.
>> 
>> Tested on da850-lcdk and was able to do basic frame capture from the
>> composite input.
>> 
>> Series applies on v4.9-rc1
>> 
>> Kevin Hilman (6):
>>   [media] davinci: add support for DT init
>>   ARM: davinci: da8xx: VPIF: enable DT init
>>   ARM: dts: davinci: da850: add VPIF
>>   ARM: dts: davinci: da850-lcdk: enable VPIF capture
>>   [media] davinci: vpif_capture: don't lock over s_stream
>>   [media] davinci: vpif_capture: get subdevs from DT
>
> Looks good, but wouldn't it be better to do the dts changes last when all the
> supporting code is in?

I guess it doesn't really matter in this case, because the DT nodes will
be nops until the driver changes are in.

Either way, next week I'll repost a non-RFC version and separate out the
arch and DT patches, since those will go through Sekhar's davinci tree,
and then via arm-soc.

Thanks for the review,

Kevin

