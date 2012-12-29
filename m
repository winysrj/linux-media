Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ia0-f171.google.com ([209.85.210.171]:40769 "EHLO
	mail-ia0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752108Ab2L2Prq (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 29 Dec 2012 10:47:46 -0500
Received: by mail-ia0-f171.google.com with SMTP id k27so9547708iad.16
        for <linux-media@vger.kernel.org>; Sat, 29 Dec 2012 07:47:46 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <201212291610.59679.hverkuil@xs4all.nl>
References: <CALF0-+U_am2qBv=ifRgeocP_OehyRZCUpdfd+y1Uqnf7B7cKJQ@mail.gmail.com>
	<CALF0-+W4azszmaMs9QVGt9GLcFq1=Nd_ZDcqi_OShXfRfo1f4Q@mail.gmail.com>
	<201212291610.59679.hverkuil@xs4all.nl>
Date: Sat, 29 Dec 2012 12:39:54 -0300
Message-ID: <CALF0-+VtTan4tqoO9TNTvn6YWSuN5FLgcsbU6259snpDsRUgoQ@mail.gmail.com>
Subject: Re: saa711x doesn't match in easycap devices (stk1160 bridged)
From: Ezequiel Garcia <elezegarcia@gmail.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On Sat, Dec 29, 2012 at 12:10 PM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
> On Sat December 29 2012 15:25:08 Ezequiel Garcia wrote:
>> Ccing a few more people to get some feedback.
>>
>> Toughts anyone? Have you ever seen this before?
>>
>> On Fri, Dec 28, 2012 at 11:13 AM, Ezequiel Garcia <elezegarcia@gmail.com> wrote:
>> > Hi everyone,
>> >
>> > Some stk1160 users (a lot acually) are reporting that stk1160 is broken.
>> > The reports come in the out of tree driver [1], but probably the issue
>> > is in mainline too.
>> >
>> > Now, it seems to me the problem is the saa711x decoder can't get matched,
>> > see a portion of dmesg.
>> >
>> > [89947.448813] usb 1-2.4: New device Syntek Semiconductor USB 2.0
>> > Video Capture Controller @ 480 Mbps (05e1:0408, interface 0, class 0)
>> > [89947.448827] usb 1-2.4: video interface 0 found
>> > [89948.200366] saa7115 21-0025: chip found @ 0x4a (ID 000000000000000)
>> > does not match a known saa711x chip.
>> > [89948.200555] stk1160: driver ver 0.9.3 successfully loaded
>> > [...]
>> >
>> > I'm working on this right now, but would like to know, given the ID
>> > seems to be NULL,
>> > what would be the right thing to do here.
>> > Perhaps, replacing the -ENODEV error by a just warning and keep going?
>> >
>> > Further debugging [2] shows the chip doesn't seem to have a proper
>> > chipid (as expected):
>
> From what I understand these devices use a GM7113C device, not a SAA7113.
> It sounds like a chinese clone of the SAA7113 to me that works *almost* the
> same, but not quite.
>

Yes, that seems to be the case.

> In that case the saa711x_id table should be extended with a gm7113c entry
> and, if chosen, the chip ID check should be skipped.
>
> This means that the stk1160 driver can try probing for saa7115_auto, and if
> that fails it should try probing for gm7113c explicitly.
>
> Note that this probing technique works for all saa711x devices from saa7111
> onwards, but it is only described explicitly in the datasheet for the saa7115.
> So if they cloned the saa7113 based on the saa7113 datasheet, then this useful
> but undocumented feature would not be included in their clone.
>

I understand. I'll work with the users that are reporting this
to get the best way to "probe" for this crappy chip.

Strangely, according to translated chinese GM7113c datasheet, the chip
should return ID just as saa7113 does.

It can't be **that** different, since legacy easycap driver has
been reported to work fine (which is understandable since
easycap driver does it's own saa7113 handling).

This represents a regression for many users,
thus my desire to obtain a fix soon.

Thanks,

-- 
    Ezequiel
