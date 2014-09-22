Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.15]:55368 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753440AbaIVI00 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 22 Sep 2014 04:26:26 -0400
Received: from [192.168.1.21] ([79.215.163.37]) by mail.gmx.com (mrgmx001)
 with ESMTPSA (Nemesis) id 0MD9q8-1XX5P22E8a-00GXXp for
 <linux-media@vger.kernel.org>; Mon, 22 Sep 2014 10:26:24 +0200
Message-ID: <541FDD2C.9060108@gmx.de>
Date: Mon, 22 Sep 2014 10:26:20 +0200
From: Jan Tisje <jan.tisje@gmx.de>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: Re: Running Technisat DVB-S2 on ARM-NAS
References: <541EE016.9030504@gmx.net> <541EE2EB.4000802@iki.fi> <541EEA74.2000909@gmx.net> <541EEEAB.10106@iki.fi> <541F0AC7.4010004@gmx.net> <541F38F0.2010904@kripserver.net>
In-Reply-To: <541F38F0.2010904@kripserver.net>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



Am 21.09.2014 um 22:45 schrieb Jannis:
> Am 21.09.2014 um 19:28 schrieb JPT:
>> Tommorrow I'll swap the sat cable just to make sure this isn't the cause.
> 
> Hi Jan,
> 
> Are we talking about this device:
> http://www.linuxtv.org/wiki/index.php/Technisat_SkyStar_USB_HD

Yes, exactly.

> (You never mentioned the actual model AFAIK)?

No, I didn't. I'm sorry.

> If so, it has two LEDs. A red one for "power" and a green one for
> "tuned"/"locked". So if the green one lights up, the sat cable should be
> okay.

Swapped cables: now it works. :)
I have to check why this cable is bad :(

Recording works fine, too.

> I remember having tested my one with the RaspberryPi and it worked. So
> it is not a general problem of the DVB-S2 device and ARM but rather the
> specific board you are working with.
> Just found the link where I reported success:
> https://github.com/raspberrypi/linux/issues/82#issuecomment-27253775

That's great to hear. Thanks!
I didn't expect anyone tried DVB on ARM yet. The Linux community is
great. I'm so glad I don't need Win any more (in general).


Thank you very much to both of you, and to all that people who wrote the
code!

Jan
