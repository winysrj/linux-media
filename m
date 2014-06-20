Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yh0-f52.google.com ([209.85.213.52]:55893 "EHLO
	mail-yh0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934916AbaFTPzs (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 20 Jun 2014 11:55:48 -0400
Received: by mail-yh0-f52.google.com with SMTP id a41so2987552yho.11
        for <linux-media@vger.kernel.org>; Fri, 20 Jun 2014 08:55:47 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <08c06a97-d24b-4eeb-9c3e-d7a923ec1ea1@email.android.com>
References: <53A3CB23.2000209@gentoo.org>
	<CALzAhNUb_J+tcqaaRLm_x=pAVDNWZp6EFuPBGKiS4VMiVtRwag@mail.gmail.com>
	<08c06a97-d24b-4eeb-9c3e-d7a923ec1ea1@email.android.com>
Date: Fri, 20 Jun 2014 11:55:47 -0400
Message-ID: <CALzAhNWzndgGCptiaZXAsVw4jyG5ANngO6m9BsL7te0sHDGqCg@mail.gmail.com>
Subject: Re: pvrusb2 has a new device (wintv-hvr-1955)
From: Steven Toth <stoth@kernellabs.com>
To: Matthew Thode <prometheanfire@gentoo.org>
Cc: Linux-Media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

>>> Just bought a wintv-hvr-1955 (sold as a wintv-hvr-1950)
>>> 160111 LF
>>> Rev B1|7
>>
>>Talk to Hauppauge, they've already announced that they have a working
>>Linux driver.
>
> I talked to them and they did say that the driver hasn't been upstreamed, also gave me some hardware info.  They wouldn't give me a driver/firmware that worked though and offered to RMA for an older device.

They'd previously announced publicly that the driver was available
under NDA for a superset product (HVR-1975):

Slashgear picked up the PR.

http://www.slashgear.com/hauppauge-wintv-hvr-1975-usb-tv-receiver-offers-multi-format-support-27318809/

"There are both 32-bit and 64-bit drivers for wider computer support,
and for Linux users, driver support is provided under an NDA."

^^^ I suggest you ask them, they do have a solution.

>
> The demodulator is a Si2177, can't find anything about it in the kernel though.

Correct.

>
> They also mentioned a LG3306a, wasn't able to find anything on it (might have misheard a character).

LGDT3306

- Steve

-- 
Steven Toth - Kernel Labs
http://www.kernellabs.com
+1.646.355.8490
