Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qc0-f177.google.com ([209.85.216.177]:45464 "EHLO
	mail-qc0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750720AbaBEHDa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 5 Feb 2014 02:03:30 -0500
Received: by mail-qc0-f177.google.com with SMTP id i8so15256871qcq.8
        for <linux-media@vger.kernel.org>; Tue, 04 Feb 2014 23:03:30 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20140204155441.438c7a3c@samsung.com>
References: <20140115173559.7e53239a@samsung.com>
	<1390246787-15616-1-git-send-email-a.seppala@gmail.com>
	<20140121122826.GA25490@pequod.mess.org>
	<CAKv9HNZzRq=0FnBH0CD0SCz9Jsa5QzY0-Y0envMBtgrxsQ+XBA@mail.gmail.com>
	<20140122162953.GA1665@pequod.mess.org>
	<CAKv9HNbVQwAcG98S3_Mj4A6zo8Ae2fLT6vn4LOYW1UMrwQku7Q@mail.gmail.com>
	<20140122210024.GA3223@pequod.mess.org>
	<20140122200142.002a39c2@samsung.com>
	<CAKv9HNY7==4H2ZDrmaX+1BcarRAJd7zUE491oQ2ZJZXezpwOAw@mail.gmail.com>
	<20140204155441.438c7a3c@samsung.com>
Date: Wed, 5 Feb 2014 09:03:29 +0200
Message-ID: <CAKv9HNbYJ5FsQas=03u8pXCyiF5VSUfsOR46McukeisqVHme+g@mail.gmail.com>
Subject: Re: [RFC PATCH 0/4] rc: Adding support for sysfs wakeup scancodes
From: =?ISO-8859-1?Q?Antti_Sepp=E4l=E4?= <a.seppala@gmail.com>
To: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Sean Young <sean@mess.org>, linux-media@vger.kernel.org,
	James Hogan <james.hogan@imgtec.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 4 February 2014 19:54, Mauro Carvalho Chehab <m.chehab@samsung.com> wrote:
> Em Thu, 23 Jan 2014 21:11:09 +0200
> Antti Seppälä <a.seppala@gmail.com> escreveu:
>
>> On 23 January 2014 00:01, Mauro Carvalho Chehab <m.chehab@samsung.com> wrote:
>> > Not sure if you saw it, but there's already another patchset proposing
>> > that, that got submitted before this changeset:
>> >         https://patchwork.linuxtv.org/patch/21625/
>>
>> I actually didn't notice that until now. Seems quite a similar kind of
>> approach with even more advanced features than what I had in mind
>> (namely the scancode filtering and masking).
>>
>> However it looks like that patchset has the same drawback about not
>> knowing which protocol to use for the wakeup scancode as was pointed
>> from my patch.
>
> Well, the protocol is important only if there are two or more active
> RCs that produce the same IR code on different protocols.
>
> Also, from the sysfs description made by James, it seems clear to me
> that the protocol to be used is the current protocol.
>
> I think is an unlikely border case to have some hardware that supports
> more than one IR protocols enabled for the wakeup to work, so James
> patch looks ok on my eyes.
>
> Also, nothing prevents to add latter a wakeup_filter_protocol sysfs node
> to allow to filter the wakeup scancode to a protocol set different than
> the one(s) currently enabled.
>
>> I think I'll try to come up with a new patch addressing the comments
>> I've seen so far.
>
> I guess I'll merge James approach, as there are a pile of other patches
> depending on it. If we need latter to distinguish between current_protocol
> and the wakeup one, as I said, a latter patch can add a
> "wakeup_filter_protocol" sysfs node to specify it.
>
> Regards,
> Mauro

Hi Mauro.

How do you want to proceed with the nuvoton wakeup I initially set out to do?

To wake up with nuvoton-cir we need to program several raw ir
pulse/space lengths to the hardware and not a scancode. James's
approach doesn't support this.

To keep things simple maybe module parameters in my first patch
(http://www.mail-archive.com/linux-media@vger.kernel.org/msg69782.html)
are then the best thing to do for nuvoton? Other drivers can probably
adapt to the suggested filter api.

-Antti
