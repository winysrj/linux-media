Return-path: <linux-media-owner@vger.kernel.org>
Received: from vps-vb.mhejs.net ([37.28.154.113]:51573 "EHLO vps-vb.mhejs.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751793AbdHaW3H (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 31 Aug 2017 18:29:07 -0400
From: "Maciej S. Szmigiero" <mail@maciej.szmigiero.name>
Subject: Re: [PATCH 5/5] [media] cxusb: add analog mode support for Medion
 MD95700
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Michael Krufky <mkrufky@linuxtv.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Andy Walls <awalls@md.metrocast.net>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-media@vger.kernel.org
References: <6a74971c-171f-7336-065c-59cede29f624@maciej.szmigiero.name>
 <ea6ab30f-85d4-9afb-d545-d8743e7dd195@xs4all.nl>
Message-ID: <ed5f3e5f-a57d-6ee6-33f5-187ba49b9aa6@maciej.szmigiero.name>
Date: Fri, 1 Sep 2017 00:29:04 +0200
MIME-Version: 1.0
In-Reply-To: <ea6ab30f-85d4-9afb-d545-d8743e7dd195@xs4all.nl>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On 21.08.2017 15:23, Hans Verkuil wrote:
> Hi Maciej,
> 
> On 08/10/2017 11:53 PM, Maciej S. Szmigiero wrote:
>> This patch adds support for analog part of Medion 95700 in the cxusb
>> driver.
>>
>> What works:
>> * Video capture at various sizes with sequential fields,
>> * Input switching (TV Tuner, Composite, S-Video),
>> * TV and radio tuning,
>> * Video standard switching and auto detection,
>> * Radio mode switching (stereo / mono),
>> * Unplugging while capturing,
>> * DVB / analog coexistence,
>> * Raw BT.656 stream support.
> 
> Another scary patch :-)

Although this isn't a single-liner, most of the code in cxusb-analog.c are
simple implementations of v4l2 and videobuf2 callbacks - only the buffer
management code is a bit more complicated.

> A high-level question first: is any of the code in cxusb-analog medion
> specific? There are a lot of cxusb_medion_ prefixes, but I wonder if that
> shouldn't be cxusb_analog_.

>From all the devices cxusb driver supports it looks like only Medion 95700
and FusionHDTV5 USB have an analog part.

However, FusionHDTV5 USB has a different tuner and a different digital
frontend, doesn't support power off command, has a different USB interface
number for digital mode than Medion and requires upload of a firmware upon
plugging in (while Medion doesn't), so it's unlikely the current code for
Medion would work for it without significant changes.

> There are some obvious code cleanups that need to take place first, such
> as the huge functions with too many indentations. I would also split off
> cxusb-analog.c as a separate patch.

For example like splitting this part into two:
1) one that adds required analog support to cxusb with functions that are
provided by cxusb-analog.c (analog init, register, unregister) replaced
with stubs,

2) the second one that actually provides correct implementations via
cxusb-analog.c?

> 
> Regards,
> 
> 	Hans

Best regards,
Maciej
