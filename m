Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.gentoo.org ([140.211.166.183]:58788 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754135AbaLVNHK (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 22 Dec 2014 08:07:10 -0500
Message-ID: <54981772.4080708@gentoo.org>
Date: Mon, 22 Dec 2014 14:06:58 +0100
From: Matthias Schwarzott <zzam@gentoo.org>
MIME-Version: 1.0
To: Steven Toth <stoth@kernellabs.com>
CC: Antti Palosaari <crope@iki.fi>,
	Linux-Media <linux-media@vger.kernel.org>
Subject: Re: [PATCH] cx23885: Split Hauppauge WinTV Starburst from HVR4400
 card entry
References: <1419191964-29833-1-git-send-email-zzam@gentoo.org> <CALzAhNVkW3spVHVi0h--1XDp+1ekR1Z+v-FBYX61wf5Bj1H7wg@mail.gmail.com>
In-Reply-To: <CALzAhNVkW3spVHVi0h--1XDp+1ekR1Z+v-FBYX61wf5Bj1H7wg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 22.12.2014 13:59, Steven Toth wrote:
> On Sun, Dec 21, 2014 at 2:59 PM, Matthias Schwarzott <zzam@gentoo.org> wrote:
>> Unconditionally attaching Si2161/Si2165 demod driver
>> breaks Hauppauge WinTV Starburst.
>> So create own card entry for this.
>>
>> Add card name comments to the subsystem ids.
>>
>> Signed-off-by: Matthias Schwarzott <zzam@gentoo.org>
> 
> Matthias,
> 
> Thank you for your work. However, nobody knows or cares what
> 'STARBURST' is. When I created the original driver I was careful to
> name the card identified to match the actual hardware names that were
> sold in retail, this eases future maintenance for people with no
> knowledge of the hardware and makes Linux support for the HVR550 much
> more obvious in google.
> 
> Please change CX23885_BOARD_HAUPPAUGE_STARBURST to
> CX23885_BOARD_HAUPPAUGE_HVR5500.
> 
> Thanks,
> 
Hi Steven,

thank you for your feedback.

I rechecked the names and this are the more or less supported devices:
* Starburst supports DVB-S2 only
* HVR-4400 supports DVB-S2 + DVB-T (Si2161)
* HVR-5500 supports DVB-S2 + DVB-C/T (Si2165)

As starburst has only one demod and HVR-4400/HVR-5500 have two, there is
one card entry for HVR-4400/HVR-5500 and a second one with different
name for the Sturburst.

Checking hauppauge homepage I directly get to the WinTV-Starburst:
http://www.hauppauge.de/site/products/data_starburst.html

So I see this is an official product name. Why not show this name?

Regards
Matthias

