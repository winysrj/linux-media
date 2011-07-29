Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ey0-f171.google.com ([209.85.215.171]:57262 "EHLO
	mail-ey0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752468Ab1G2SK1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 29 Jul 2011 14:10:27 -0400
Received: by eye22 with SMTP id 22so3678424eye.2
        for <linux-media@vger.kernel.org>; Fri, 29 Jul 2011 11:10:26 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAKdnbx6O8JgMM37e28q1g9dt=AdJpAAjWHqxBnTXHZrcyBMKyQ@mail.gmail.com>
References: <CAKdnbx5DQe+c1+ZD6tEJqgSfv6CRV18s2YGv=Z3cOT=wEOyF7g@mail.gmail.com>
	<4E31526F.3060608@southpole.se>
	<CAKdnbx6O8JgMM37e28q1g9dt=AdJpAAjWHqxBnTXHZrcyBMKyQ@mail.gmail.com>
Date: Fri, 29 Jul 2011 14:10:25 -0400
Message-ID: <CAGoCfiyoh1QSBgqFU6ym-co1QFdHanK3WJ_ese7Cv4ACRfDhrg@mail.gmail.com>
Subject: Re: Trying to support for HAUPPAUGE HVR-930C
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Eddi De Pieri <eddi@depieri.net>
Cc: linux-media@vger.kernel.org,
	Benjamin Larsson <benjamin@southpole.se>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Jul 29, 2011 at 7:15 AM, Eddi De Pieri <eddi@depieri.net> wrote:
> 2011/7/28 Benjamin Larsson <benjamin@southpole.se>:
>> 0x82 is the address of the chip handling the analog signals(?) Micronas
>> AVF 4910BA1 maybe.
>
> I don't have the schematic of hauppauge card, so I can't say you if
> 082 is the AVF 4910

Yes, it's an avf4910b.  I did a Linux driver for the AVFA for the
Viewcast boards, but there isn't a driver for the AFVB at this time.
Should be pretty easy for you to whip one up though just by capturing
the register sets under Windows and then replaying them for each of
the three inputs.

Devin

>> So change the names so it is clear that this part
>> sends commands to that chip.
>
> As I already told my patch is a derivate work of Terratec H5 Patch.
> Mauro's patch should have the same issue
>
>> I'm not sure I understand the I2C addressing but my tuner is at 0xc2 and
>> the demod at 0x52.

Correct: the xc5000 is at 0xc2, the avf4910b is at 0x82 and the drx-k
is at 0x52.

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
