Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qk0-f195.google.com ([209.85.220.195]:35233 "EHLO
        mail-qk0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751344AbdEFGxE (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Sat, 6 May 2017 02:53:04 -0400
Received: by mail-qk0-f195.google.com with SMTP id k74so3674615qke.2
        for <linux-media@vger.kernel.org>; Fri, 05 May 2017 23:53:04 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20170505195054.GA29473@googlemail.com>
References: <20170504222115.GA26659@googlemail.com> <CA+O4pCJqqSqE_YFDM6unU8pvuVoRJijkNOv64AWD6CPdbxD5qA@mail.gmail.com>
 <20170505154435.GA18161@googlemail.com> <CA+O4pCKDyADH+Bx8Mxd01jCzU3vefRK6JLLYFDMuXdbZxToDtw@mail.gmail.com>
 <20170505195054.GA29473@googlemail.com>
From: Markus Rechberger <mrechberger@gmail.com>
Date: Sat, 6 May 2017 14:53:03 +0800
Message-ID: <CA+O4pC+0oeqepXf5dVLxxDQRswXGjAq50GVrmepzUJwoa8pR=w@mail.gmail.com>
Subject: Re: [PATCH] [media] em28xx: support for Sundtek MediaTV Digital Home
To: Markus Rechberger <mrechberger@gmail.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, May 6, 2017 at 3:50 AM, Thomas Hollstegge
<thomas.hollstegge@gmail.com> wrote:
> Hi Markus,
>
> Markus Rechberger <mrechberger@gmail.com> schrieb am Sat, 06. May 00:33:
>> We had different HW designs based on Empia until 2012 using this USB
>> ID it will not work with many units out there, also with different
>> standby behaviours, chipsets etc.
>
> Well, after this patch there's one more device that works with an
> open-source driver, which I consider a good thing. What about
> open-sourcing support for the other devices you're talking about?
>

As mentioned you can use the sysfs approach for you.
Don't buy a device which you intend to use with unintended software afterwards.
Your device is from 2010 as far as I see, you can ship the unit back
for changing the USB ID for it so you can mess around with it and
break it completely.
The USB ID in question is used for all kind of devices, even analog or
radio only units which are very far from being supported by this
crappy opensource driver which is able to crash the entire kernel.
Our work is pretty much isolated.

You might match your unit also based on your serialnumber if you want
to apply such a patch to the crappy opensource driver.


>> If you want to get a device with kernel support I recommend buying a
>> different one and let that one go back to our community (since our
>> tuners and support are still quite popular).
>
> Thanks, but I'd rather stick with the device I have than spending more
> money to have a device that only works with a closed-source driver.
>

then sell it get a good price and buy another unit or ship it back for
getting another USB ID (the EEPROM needs to be removed for rewriting
it).

> Anyway, I just saw that the patch doesn't apply cleanly against
> linux-media master. I'll submit a new version of the patch in a
> minute.
>
> Cheers
> Thomas
