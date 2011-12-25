Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ww0-f42.google.com ([74.125.82.42]:42818 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752096Ab1LYMh5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 25 Dec 2011 07:37:57 -0500
Received: by wgbds13 with SMTP id ds13so15269621wgb.1
        for <linux-media@vger.kernel.org>; Sun, 25 Dec 2011 04:37:56 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <4EF7066C.4070806@redhat.com>
References: <4EF67721.9050102@unixsol.org>
	<4EF6DD91.2030800@iki.fi>
	<4EF6F84C.3000307@redhat.com>
	<CAF0Ff2kkFJYLUjVdmV9d9aWTsi-2ZHHEEjLrVSTCUnP+VTyxRg@mail.gmail.com>
	<4EF7066C.4070806@redhat.com>
Date: Sun, 25 Dec 2011 14:37:56 +0200
Message-ID: <CAF0Ff2k4ceAR=1zeewYd79Qct_f0X3PCjaR=oEt3F_xvm2upyg@mail.gmail.com>
Subject: Re: DVB-S2 multistream support
From: Konstantin Dimitrov <kosio.dimitrov@gmail.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Antti Palosaari <crope@iki.fi>,
	Georgi Chorbadzhiyski <gf@unixsol.org>,
	linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, Dec 25, 2011 at 1:18 PM, Mauro Carvalho Chehab
<mchehab@redhat.com> wrote:
> On 25-12-2011 08:55, Konstantin Dimitrov wrote:
>> On Sun, Dec 25, 2011 at 12:17 PM, Mauro Carvalho Chehab
>> <mchehab@redhat.com> wrote:
>>
>>> That's said, the approach there assumes that just one mis can be filtered. I'm wandering
>>> if it wouldn't be better to use the same approach taken inside dvb-core for PIP filtering.
>>
>> i'm not sure that i understand correctly what you mean, but i can't
>> see way how to filter more that one mis stream at the same time,
>> because their id is stored in the bbheader. so, even if we assume it's
>> possible to send two ids for filtering to the hardware and then it
>> outputs ts packets from both of them there is still no way to know
>> which ts packet to which mis stream belongs, because the bbheader is
>> stripped inside the demodulator before the data are outputted. in fact
>> if you don't set any id for filtering to mis capable hardware then
>> usually it outputs the ts packets from all of the streams and that's
>> why the outputted stream looks corrupted, because it contains ts
>> packets from all mis streams and that's why you what to set id for
>> filtering to the hardware in the first place - to make it output ts
>> packets just from one selected stream. however, if dvb-core has
>> support for bbframes like the following unfortunately lost work:
>>
>> http://www.linuxtv.org/pipermail/linux-dvb/2007-December/022217.html
>
> Yes, I'm meaning something like what it was described there. I think
> that the code written by Christian were never submitted upstream.
>

no doubt, a lot of work could be saved if the repository of
Christian's project wasn't dead or his work was upstream, but it is
how it is. BTW, Christian is also co-author of an article called "A
Second Generation Architecture for Linux DVB Networking" :

http://202.194.20.8/proc/ASMS2008/DATA/B-14-03.PDF

which in my opinion could be used as source of both ideas and general
information.

>> then instead setting mis filtering in the hardware you can force it to
>> output bbframes (at least currently all mis capable hardware is
>> supposed to be able to output bbframes) and then filter all streams in
>> the software, which would be significantly more flexible, because that
>> way all streams can be filtered and used in the same time.
>
> While your hardware supports filtering only one MIS, other hardware may
> support more.

i agree, that's of course true in theory, but in my opinion in
practice it entirely depends on how you're going to treat hardware
having more than one data output at the same time - currently such
hardware is treated as creating as many /dev/dvb/adapterX for it as
there are data outputs. so, if that way is assumed, thinking about it,
there are only few possible cases:

1) the hardware has one data output:

1.1) which is set to output bbframes - then if there is bbframe
support in dvb-core, that's the best case, because all streams can be
used at the same time with software filtering, otherwise we're stuck
with setting the output to either ts mode (case 1.2) or some
custom/proprietary mode (case 1.3)

1.2) it is set to output ts (or dvb-core doesn't have bbframe support)
then we're limited to only one ts stream and that's what actually is
even currently possible, i.e. this case is the closest to the current
status of dvb-core no matter of any existing or future hardware

1.3) it can be set to filter and output more than one ts stream : then
to do it via one data output the hardware must use some
custom/proprietary output format to preserve the ids. so, in such case
the driver must be responsible to deal with that custom/proprietary
output format and output the different streams as separate ts streams,
but then my point is we're in case 2, which is the initial assumption

2) the hardware has 2 or more data outputs: then for each of them
there is separate adapterX created to handle the data for each output

3) something else, i'm missing to think about it

if we're talking for real and existing hardware only, what i've seen so far is:

- no mis filtering is set: then all streams are outputted by the
hardware, but the data are useless, because it's not possible to tell
which ts packet to which stream belongs, i.e. it's not possible to
reconstruct the different ts streams

- no mis filtering is set: then the hardware sets as default id for
the filter the id of the first bbheader that is received and only ts
packets of that steam are outputted, i.e. one ts output

- mis filter is set: one id is selected and one ts stream of that
selected id is outputted

in any case at least from my point of view case 1 and 2 cover all options.

> Anyway, it makes sense to add a software filter, and to
> add a way to deliver the mis information to userspace, if more than one
> mis is filtered.
>
> Regards,
> Mauro
