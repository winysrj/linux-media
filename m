Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:43237 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751413AbZFOU6V (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 15 Jun 2009 16:58:21 -0400
Message-ID: <4A36B654.7020306@redhat.com>
Date: Mon, 15 Jun 2009 23:00:04 +0200
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: Erik de Castro Lopo <erik@bcode.com>
CC: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: GPL code for Omnivision USB video camera available.
References: <20090612110228.3f7e42ab.erik@bcode.com>	<4A31FB0A.8030104@redhat.com>	<20090613104524.781027d8.erik@bcode.com>	<4A335F5A.1010305@redhat.com> <20090615110152.4c577be7.erik@bcode.com>
In-Reply-To: <20090615110152.4c577be7.erik@bcode.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On 06/15/2009 03:01 AM, Erik de Castro Lopo wrote:
> On Sat, 13 Jun 2009 18:12:10 +1000
> Hans de Goede<hdegoede@redhat.com>  wrote:
>
>> Getting ovfx2 support into the mainline kernel sounds like a good idea!
>>
>> I'm not such a big fan of merging the driver as is though, as it does
>> its own buffer management (and ioctl handling, usb interrupt handling,
>> locking, etc).
>
> I understand completely.
>

Good!

>> For adding the ovfx2 driver, you could start by copying ov519.c, which
>> already has setup and control code fro most ov sensors and then rewrite
>> the bridge part to be ovfx2 code, then later we can try to move the
>> sensor code to a shared c file for the ov519 and ovfx2 driver, depending
>> on how much you needed to change the sensor code. Or you could add
>> support for the ovfx2 to the ov519 driver.
>>
>> Note I've recently being doing quite a bit of work on the ov519 driver,
>> adding support for the ov511 and ov518 and adding more controls. I'll
>> make a mercurial tree available with my latest code in it asap.
>
> Ok, there's the rub. I am simply way too busy at the moment to push this
> through myself.
>
> I was hoping I could contract someone to take the existing code and
> massage it into shape ready for merging. I would prefer it if that
> someone was already a V4L hacker, but if I can't find anyone with
> pre-existing V4L experience I'll find someone local with general
> Linux kernel/driver experience.
>

Well I can't offer you contracting, as I simply do not have the spare time
to make such promises, but as any good hacker: "will work for hardware"
on a I'll do my best but no promises made basis.

I'm actually spending quite a bit of time lately on v4l stuff again,
and I'm sure willing to spend some time on this. I can even promise you
I'll bump it to the top of the list of my v4l projects.

For a general idea how deep I'm involved in v4l webcam support see:
https://fedoraproject.org/wiki/Features/BetterWebcamSupport

Regards,

Hans
