Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:36912 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933161Ab2KEW0J (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 5 Nov 2012 17:26:09 -0500
Message-ID: <50983CFD.2030104@gmail.com>
Date: Mon, 05 Nov 2012 23:26:05 +0100
From: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
MIME-Version: 1.0
To: Andrey Gusakov <dron0gus@gmail.com>
CC: Tomasz Figa <tomasz.figa@gmail.com>,
	In-Bae Jeong <kukyakya@gmail.com>,
	=?ISO-8859-1?Q?Heiko_St=FCbner?= <heiko@sntech.de>,
	LMML <linux-media@vger.kernel.org>,
	linux-samsung-soc <linux-samsung-soc@vger.kernel.org>
Subject: Re: S3C244X/S3C64XX SoC camera host interface driver questions
References: <CAA11ShCpH7Z8eLok=MEh4bcSb6XjtVFfLQEYh2icUtYc-j5hEQ@mail.gmail.com> <5096C561.5000108@gmail.com> <CAA11ShCKFfdmd_ydxxCYo9Sv0VhgZW9kCk_F7LAQDg3mr5prrw@mail.gmail.com> <5096E8D7.4070304@gmail.com> <CAA11ShDinm7oU4azQYPMrNDsqWPqw+vJNFPpBDNzV=dTeUdZzw@mail.gmail.com> <50979998.8090809@gmail.com> <CAA11ShD6Qug_=t8vGE5LwSpfXW2FsceTonxnF8aO6i2b=inibw@mail.gmail.com>
In-Reply-To: <CAA11ShD6Qug_=t8vGE5LwSpfXW2FsceTonxnF8aO6i2b=inibw@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Andrey,

On 11/05/2012 12:11 PM, Andrey Gusakov wrote:
> Hi.
>
> Thanks all!
> I make it work! Have to comment out write { REG_GRCOM, 0x3f },	/*

Great news!

Does the sensor still hang after 0x2f is written to REG_GRCOM instead ?

> Analog BLC&  regulator */ and have to enable gate clock for fimc at
> probe.

Do you have CONFIG_PM_RUNTIME enabled ? Can you try and see it works
if you enable it, without additional changes to the clock handling ?

I hope to eventually prepare the ov9650 sensor driver for mainline. Your
help in making it ready for VER=0x52 would be very much appreciated. :-)

>> Hmm, in my case VER was 0x50. PID, VER = 0x96, 0x50. And this a default
>> value
>> after reset according to the datasheet, ver. 1.3. For ver. 1.91 it is
>> PID, VER = 0x96, 0x52. Perhaps it just indicates ov9652 sensor ov9652.
>> Obviously I didn't test the driver with this one. Possibly the differences
>> can be resolved by comparing the documentation. Not sure if those are
>> significant and how much it makes sense to have single driver for both
>> sensor versions. I'll try to have a look at that.
> Ok. I also try to compate init sequenses from different sources on web.
>
> Next step is to make ov2460 work.

For now I can only recommend you to make the ov2460 driver more similar
to the ov9650 one.

--
Regards,
Sylwester
