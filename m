Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yk0-f172.google.com ([209.85.160.172]:60420 "EHLO
	mail-yk0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754593AbaLVNMF (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 22 Dec 2014 08:12:05 -0500
Received: by mail-yk0-f172.google.com with SMTP id 131so2214809ykp.17
        for <linux-media@vger.kernel.org>; Mon, 22 Dec 2014 05:12:04 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <54981772.4080708@gentoo.org>
References: <1419191964-29833-1-git-send-email-zzam@gentoo.org>
	<CALzAhNVkW3spVHVi0h--1XDp+1ekR1Z+v-FBYX61wf5Bj1H7wg@mail.gmail.com>
	<54981772.4080708@gentoo.org>
Date: Mon, 22 Dec 2014 08:12:04 -0500
Message-ID: <CALzAhNUxuAddth38C9dvnYQZx+4CNa6_6jHFEpyRG7o5zw=h0w@mail.gmail.com>
Subject: Re: [PATCH] cx23885: Split Hauppauge WinTV Starburst from HVR4400
 card entry
From: Steven Toth <stoth@kernellabs.com>
To: Matthias Schwarzott <zzam@gentoo.org>
Cc: Antti Palosaari <crope@iki.fi>,
	Linux-Media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

>> Please change CX23885_BOARD_HAUPPAUGE_STARBURST to
>> CX23885_BOARD_HAUPPAUGE_HVR5500.
>>
>> Thanks,
>>
> Hi Steven,
>
> thank you for your feedback.
>
> I rechecked the names and this are the more or less supported devices:
> * Starburst supports DVB-S2 only
> * HVR-4400 supports DVB-S2 + DVB-T (Si2161)
> * HVR-5500 supports DVB-S2 + DVB-C/T (Si2165)
>
> As starburst has only one demod and HVR-4400/HVR-5500 have two, there is
> one card entry for HVR-4400/HVR-5500 and a second one with different
> name for the Sturburst.
>
> Checking hauppauge homepage I directly get to the WinTV-Starburst:
> http://www.hauppauge.de/site/products/data_starburst.html
>
> So I see this is an official product name. Why not show this name?

You are correct. I was assuming you were attempting to add HVR5500 support.

Please disregard my previous request, CX23885_BOARD_HAUPPAUGE_STARBURST is fine.

- Steve

-- 
Steven Toth - Kernel Labs
http://www.kernellabs.com
