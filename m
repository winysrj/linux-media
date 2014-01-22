Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-oa0-f47.google.com ([209.85.219.47]:42153 "EHLO
	mail-oa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752662AbaAVTK7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 22 Jan 2014 14:10:59 -0500
Received: by mail-oa0-f47.google.com with SMTP id m1so958049oag.34
        for <linux-media@vger.kernel.org>; Wed, 22 Jan 2014 11:10:59 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20140122162953.GA1665@pequod.mess.org>
References: <20140115173559.7e53239a@samsung.com>
	<1390246787-15616-1-git-send-email-a.seppala@gmail.com>
	<20140121122826.GA25490@pequod.mess.org>
	<CAKv9HNZzRq=0FnBH0CD0SCz9Jsa5QzY0-Y0envMBtgrxsQ+XBA@mail.gmail.com>
	<20140122162953.GA1665@pequod.mess.org>
Date: Wed, 22 Jan 2014 21:10:58 +0200
Message-ID: <CAKv9HNbVQwAcG98S3_Mj4A6zo8Ae2fLT6vn4LOYW1UMrwQku7Q@mail.gmail.com>
Subject: Re: [RFC PATCH 0/4] rc: Adding support for sysfs wakeup scancodes
From: =?ISO-8859-1?Q?Antti_Sepp=E4l=E4?= <a.seppala@gmail.com>
To: Sean Young <sean@mess.org>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 22 January 2014 18:29, Sean Young <sean@mess.org> wrote:
> On Wed, Jan 22, 2014 at 05:46:28PM +0200, Antti Sepp�l� wrote:
>> On 21 January 2014 14:28, Sean Young <sean@mess.org> wrote:
>> > On Mon, Jan 20, 2014 at 09:39:43PM +0200, Antti Sepp�l� wrote:
>> >> This patch series introduces a simple sysfs file interface for reading
>> >> and writing wakeup scancodes to rc drivers.
>> >>
>> >> This is an improved version of my previous patch for nuvoton-cir which
>> >> did the same thing via module parameters. This is a more generic
>> >> approach allowing other drivers to utilize the interface as well.
>> >>
>> >> I did not port winbond-cir to this method of wakeup scancode setting yet
>> >> because I don't have the hardware to test it and I wanted first to get
>> >> some comments about how the patch series looks. I did however write a
>> >> simple support to read and write scancodes to rc-loopback module.
>> >
>> > Doesn't the nuvoton-cir driver need to know the IR protocol for wakeup?
>> >
>> > This is needed for winbond-cir; I guess this should be another sysfs
>> > file, something like "wakeup_protocol". Even if the nuvoton can only
>> > handle one IR protocol, maybe it should be exported (readonly) via
>> > sysfs?
>> >
>> > I'm happy to help with a winbond-cir implementation; I have the hardware.
>> >
>> >
>> > Sean
>>
>> Nuvoton-cir doesn't care about the IR protocol because the hardware
>> compares raw IR pulse lengths and wakes the system if received pulse
>> is within certain tolerance of the one pre-programmed to the HW. This
>> approach is agnostic to the used IR protocol.
>
> Your patch talks about scancodes which is something entirely different.
> This should be renamed to something better.
>

I agree that for the nuvoton my choice of wording (scancode) was a
poor one. Perhaps wakeup_code would suit both drivers?

> So with the nuvoton you program a set of pulses and spaces; with the
> winbond you set the protocol and the scancode. I don't think there is
> any shared code here. Maybe it's better to implement the wakeup
> sysfs files in the drivers themselves rather than in rcdev, I guess that
> depends on whether there are other devices that implement similar
> functionality.
>

The code to be shared is the logic of creating, parsing and formatting
the sysfs file. In the end the drivers are only interested in getting
a bunch of values to write to the hardware.

I was thinking about adding another file (wakeup_protocol sounds good)
which would tell what semantics are used to interpret the contents of
wakeup_code file (rc6, rc5, nec or raw). Would this be a decent
solution?

The other alternative is to push the sysfs handling to individual
drivers. I'm ok with either way. Which one should I pursue?

-Antti
