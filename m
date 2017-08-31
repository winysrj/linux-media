Return-path: <linux-media-owner@vger.kernel.org>
Received: from vps-vb.mhejs.net ([37.28.154.113]:51404 "EHLO vps-vb.mhejs.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751001AbdHaW2w (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 31 Aug 2017 18:28:52 -0400
From: "Maciej S. Szmigiero" <mail@maciej.szmigiero.name>
Subject: Re: [PATCH 1/5] [media] cx25840: add pin to pad mapping and output
 format configuration
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Michael Krufky <mkrufky@linuxtv.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Andy Walls <awalls@md.metrocast.net>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-media@vger.kernel.org
References: <5732d21e-814c-0f99-4de7-7d3d269c9083@maciej.szmigiero.name>
 <1c0a89e4-d615-5d02-83de-795882be6f6b@xs4all.nl>
Message-ID: <055202bb-ee7b-c015-cb17-7c1621ced9d2@maciej.szmigiero.name>
Date: Fri, 1 Sep 2017 00:28:48 +0200
MIME-Version: 1.0
In-Reply-To: <1c0a89e4-d615-5d02-83de-795882be6f6b@xs4all.nl>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

Thanks for comments and sorry for not replying faster.

On 21.08.2017 15:15, Hans Verkuil wrote:
> Hi Maciej,
> 
> On 08/10/2017 11:50 PM, Maciej S. Szmigiero wrote:
>> This commit adds pin to pad mapping and output format configuration support
>> in CX2584x-series chips to cx25840 driver.
>>
>> This functionality is then used to allow disabling ivtv-specific hacks
>> (called a "generic mode"), so cx25840 driver can be used for other devices
>> not needing them without risking compatibility problems.
>>
>> Signed-off-by: Maciej S. Szmigiero <mail@maciej.szmigiero.name>
> 
> I'll be honest: this patch is scary! This driver is quite fragile and I don't
> want to apply this as-is.
>

All changes are hidden behind 'generic_mode' switch (which is not set by
default) so there is no change in behavior for existing users.
In fact, this switch was requested by the previous review of this change back
in 2011: https://patchwork.linuxtv.org/patch/7767/ (although the suggested
name was "is_medion95700").

> It would help if you would explain what exactly the 'ivtv-specific' hacks are
> that prevent you from using this in cxusb.

In set format callback 4 or 7 lines (depending on broadcast standard that
is currently set) are added to the requested image height.

Video output format seems to be left to power on defaults unless a sliced or
a raw VBI format is set, then it will be set to one of two hardcoded values.
None of these values are correct for Medion 95700.
This shouldn't really be called a hack, it is more of an issue of hardcoded
video output setting. 

However, currently the cxusb driver does not support audio input via
ancillary data.
It is very likely that adding this functionality will need making more
settings of the cx25840 driver either configurable or not modified by the
current code.

> You also seem to support many more io pins than cxusb needs. I would certainly
> only add support for the minimum you need to make it work.
> 
> I much prefer the way cx23885_s_io_pin_config is created: it's easier to follow
> than the maze of macros and mapping functions that this patch introduces.

You mean to add just support for configuring the 3 pins that the cxusb driver
needs instead of all of them?

> Regards,
> 
> 	Hans

Best regards,
Maciej
