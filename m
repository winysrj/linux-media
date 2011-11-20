Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:65505 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750993Ab1KTPD1 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 20 Nov 2011 10:03:27 -0500
Message-ID: <4EC916BB.9000200@redhat.com>
Date: Sun, 20 Nov 2011 13:03:23 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Eddi De Pieri <eddi@depieri.net>
CC: linux-media@vger.kernel.org
Subject: Re: [PATCH] initial support for HAUPPAUGE HVR-930C again...
References: <CAKdnbx5_qfotsKh0-s+DN7skx-J2=1HRw-qZOw=3mUHCQFHo2g@mail.gmail.com> <4EC8F94F.8090800@redhat.com> <CAKdnbx6Leux7+6h5FFRiay709ogwH6v34BCq=U7Qve8YwfA=VQ@mail.gmail.com>
In-Reply-To: <CAKdnbx6Leux7+6h5FFRiay709ogwH6v34BCq=U7Qve8YwfA=VQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 20-11-2011 13:00, Eddi De Pieri escreveu:
> Attached the patch for for get_firmware

Thanks!

Could you please sign it?

> 
> Regards,
> 
> Eddi
> 
> On Sun, Nov 20, 2011 at 1:57 PM, Mauro Carvalho Chehab
> <mchehab@redhat.com> wrote:
>> Em 19-11-2011 13:37, Eddi De Pieri escreveu:
>>> With this patch I try again to add initial support for HVR930C.
>>>
>>> Tested only DVB-T, since in Italy Analog service is stopped.
>>>
>>> Actually "scan -a0 -f1", find only about 50 channel while 400 should
>>> be available.
>>>
>>> Signed-off-by: Eddi De Pieri <eddi@depieri.net>
>>
>> Tested here with DVB-C, using the Terratec firmware. It worked as expected:
>> 213 channels scanned, tested a few non-encrypted ones, and it seems to be
>> working as expected.
>>
>> It didn't work with the firmware used by ddbrigde driver (the one that get_dvb_firmware
>> script is capable of retrieving).
>>
>>>
>>> Regards
>>>
>>> Eddi
>>
>>

