Return-path: <linux-media-owner@vger.kernel.org>
Received: from vps-vb.mhejs.net ([37.28.154.113]:50090 "EHLO vps-vb.mhejs.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752392AbdLQSnR (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sun, 17 Dec 2017 13:43:17 -0500
Subject: Re: [PATCH v3 6/6] [media] cxusb: add analog mode support for Medion
 MD95700
To: Philippe Ombredanne <pombredanne@nexb.com>
Cc: Michael Krufky <mkrufky@linuxtv.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Andy Walls <awalls@md.metrocast.net>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Hans Verkuil <hverkuil@xs4all.nl>
References: <cover.1513530138.git.mail@maciej.szmigiero.name>
 <de9db343-f2f2-d705-344b-d4cd53029c87@maciej.szmigiero.name>
 <CAOFm3uGgwR-XR8Np9Pw43Tm44C6mp0-pi9iNRR-csX7T3e4D2A@mail.gmail.com>
From: "Maciej S. Szmigiero" <mail@maciej.szmigiero.name>
Message-ID: <fccefec2-31ac-9664-ba71-65ae6a9b1c16@maciej.szmigiero.name>
Date: Sun, 17 Dec 2017 19:43:14 +0100
MIME-Version: 1.0
In-Reply-To: <CAOFm3uGgwR-XR8Np9Pw43Tm44C6mp0-pi9iNRR-csX7T3e4D2A@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 17.12.2017 19:24, Philippe Ombredanne wrote:
> Maciej,
> 
> On Sun, Dec 17, 2017 at 6:37 PM, Maciej S. Szmigiero
> <mail@maciej.szmigiero.name> wrote:
>> This patch adds support for analog part of Medion 95700 in the cxusb
>> driver.
> <snip>
> 
>> --- /dev/null
>> +++ b/drivers/media/usb/dvb-usb/cxusb-analog.c
>> @@ -0,0 +1,1927 @@
>> +/* DVB USB compliant linux driver for Conexant USB reference design -
>> + * (analog part).
>> + *
>> + * Copyright (C) 2011, 2017 Maciej S. Szmigiero (mail@maciej.szmigiero.name)
>> + *
>> + * TODO:
>> + *  * audio support,
>> + *  * finish radio support (requires audio of course),
>> + *  * VBI support,
>> + *  * controls support
>> + *
>> + * This program is free software; you can redistribute it and/or
>> + * modify it under the terms of the GNU General Public License
>> + * as published by the Free Software Foundation; either version 2
>> + * of the License, or (at your option) any later version.
>> + */
> 
> Would you mind using the new SPDX tags here. See Thomas patches [1]. Thanks!
> 
> [1] https://lkml.org/lkml/2017/12/4/934
> 

Will add this tag in a moment, thanks for pointing this out.

Best regards,
Maciej Szmigiero
