Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qy0-f192.google.com ([209.85.221.192]:51002 "EHLO
	mail-qy0-f192.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752216AbZLDI3G convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 4 Dec 2009 03:29:06 -0500
Received: by qyk30 with SMTP id 30so968270qyk.33
        for <linux-media@vger.kernel.org>; Fri, 04 Dec 2009 00:29:12 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1259889036.12423.9.camel@pc07.localdom.local>
References: <200912031656.20893.herton@mandriva.com.br>
	 <1259877269.10943.3.camel@pc07.localdom.local>
	 <200912032104.10785.herton@mandriva.com.br>
	 <1259889036.12423.9.camel@pc07.localdom.local>
Date: Fri, 4 Dec 2009 03:29:11 -0500
Message-ID: <303a8ee30912040029s1fc48eebs203dfceefdaae012@mail.gmail.com>
Subject: Re: V4L1 compatibility broken for VIDIOCGTUNER with radio
From: Michael Krufky <mkrufky@kernellabs.com>
To: hermann pitton <hermann-pitton@arcor.de>
Cc: Herton Ronaldo Krzesinski <herton@mandriva.com.br>,
	linux-media@vger.kernel.org, Hans Verkuil <hverkuil@xs4all.nl>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Dec 3, 2009 at 8:10 PM, hermann pitton <hermann-pitton@arcor.de> wrote:
>
> Am Donnerstag, den 03.12.2009, 21:04 -0200 schrieb Herton Ronaldo
> Krzesinski:
>> Em Qui 03 Dez 2009, às 19:54:29, hermann pitton escreveu:
>> > Hi,
>> >
>> > Am Donnerstag, den 03.12.2009, 16:56 -0200 schrieb Herton Ronaldo
>> > Krzesinski:
>> > > Hi,
>> > >
>> > > After commit 9bedc7f ("V4L/DVB (12429): v4l2-ioctl: fix G_STD and G_PARM
>> > > default handlers"), radio software using V4L1 stopped to work on a saa7134
>> > > card, a git bisect pointed to this commit introducing the regression. All
>> > > VIDIOCGTUNER calls on a v4l1 application are returning -EINVAL after this
>> > > commit.
>> > >
>> > > Investigating the issue, it turns out that v4l1_compat_get_tuner calls
>> > > VIDIOC_G_STD ioctl, but as it is a radio device (saa7134-radio) it now is
>> > > returning -EINVAL to user space applications which are being confused about
>> > > this.
>> > >
>> > > May be VIDIOC_G_STD change in the commit above should be reverted, or
>> > > v4l1_compat_get_tuner changed to not return error with G_STD, or not call
>> > > G_STD ioctl for a radio device?
>> > >
>> > > --
>> > > []'s
>> > > Herton
>> >
>> > it was fixed here.
>> >
>> > http://linuxtv.org/hg/v4l-dvb/rev/58ecda742a70
>>
>> Indeed, thanks for the pointer. I forgot to check latest v4l1-compat.c /o\
>>
>> >
>> > Maybe it was not ported to stable?
>>
>> Not on latest stable (2.6.31.6), perhaps it should be forwarded.
>>
>
> Yes, for sure. It's our fault.
>
> Seems we had an "internal server error" :(
>
> I came across it by accident.
>
>> The only other issue I'm aware of is that radio is broken since guessed
>> 8 weeks on my tuners, only realized when testing on enabling external
>> active antenna voltage for DVB-T on a/some 310i.
>
> I did the bisect with some delay and Hans marked the fix with priority
> "high", but we missed to point Mike at it for stable explicitly.
>
> Mike, please review and forward.
>
> Sorry,
> Hermann

Already done.  It's queued for 2.6.31.7  The delay was due to the
standard bureaucracy ...  nothing we haven't seen before -- hopefully
the distros will take in in once it's merged to stable, which should
probably be within the next week or two.

Thanks,

Mike
