Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:64050 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757954Ab1LGVsv (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 7 Dec 2011 16:48:51 -0500
Message-ID: <4EDFDF3F.8020202@gmail.com>
Date: Wed, 07 Dec 2011 15:48:47 -0600
From: Patrick Dickey <pdickeybeta@gmail.com>
MIME-Version: 1.0
To: Andreas Oberritter <obi@linuxtv.org>
CC: Mark Brown <broonie@opensource.wolfsonmicro.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	HoP <jpetrous@gmail.com>,
	Florian Fainelli <f.fainelli@gmail.com>,
	Alan Cox <alan@lxorguk.ukuu.org.uk>,
	linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC] vtunerc: virtual DVB device - is it ok to NACK driver because
 of worrying about possible misusage?
References: <20111202231909.1ca311e2@lxorguk.ukuu.org.uk> <CAJbz7-0Xnd30nJsb7SfT+j6uki+6PJpD77DY4zARgh_29Z=-+g@mail.gmail.com> <4EDC9B17.2080701@gmail.com> <CAJbz7-2maWS6mx9WHUWLiW8gC-2PxLD3nc-3y7o9hMtYxN6ZwQ@mail.gmail.com> <4EDD01BA.40208@redhat.com> <4EDD2C82.7040804@linuxtv.org> <20111206112153.GC17194@sirena.org.uk> <4EDE0427.2050307@linuxtv.org> <20111206141929.GE17731@opensource.wolfsonmicro.com> <4EDE2B3B.2080905@linuxtv.org> <20111207134848.GB18837@opensource.wolfsonmicro.com> <4EDF71AE.5070509@linuxtv.org>
In-Reply-To: <4EDF71AE.5070509@linuxtv.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 12/07/2011 08:01 AM, Andreas Oberritter wrote:
> On 07.12.2011 14:49, Mark Brown wrote:
>> On Tue, Dec 06, 2011 at 03:48:27PM +0100, Andreas Oberritter wrote:
>>> On 06.12.2011 15:19, Mark Brown wrote:
>>
>>>> Your assertatation that applications should ignore the underlying
>>>> transport (which seems to be a big part of what you're saying) isn't
>>>> entirely in line with reality.
>>
>>> Did you notice that we're talking about a very particular application?
>>
>> *sigh*
>>
>>> VoIP really is totally off-topic. The B in DVB stands for broadcast.
>>> There's only one direction in which MPEG payload is to be sent (using
>>> RTP for example). You can't just re-encode the data on the fly without
>>> loss of information.
>>
>> This is pretty much exactly the case for VoIP some of the time (though
>> obviously bidirectional use cases are rather common there's things like
>> conferencing).  I would really expect similar considerations to apply
>> for video content as they certainly do in videoconferencing VoIP
>> applications - if the application knows about the network it can tailor
>> what it's doing to that network.  
>>
>> For example, if it is using a network with a guaranteed bandwidth it can
>> assume that bandwidth.  If it knows something about the structure of the
>> network it may be able to arrange to work around choke points.
>> Depending on the situation even something lossy may be the answer - if
>> it's the difference between working at all and not working then the cost
>> may be worth it.
> 
> Once and for all: We have *not* discussed a generic video streaming
> application. It's only, I repeat, only about accessing a remote DVB API
> tuner *as if it was local*. No data received from a satellite, cable or
> terrestrial DVB network shall be modified by this application!
> 
> Virtually *every* user of it will use it in a LAN.
> 
> It can't be so hard to understand.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

I tend to stay out of these discussions, since like a couple of others,
I'm not a kernel developer (or hacker). However, I wanted to chime in
with my two cents here.

1.  I agree that it's not acceptable to "NACK" purely for philosophical
reasons (except when it's a clear violation of a license--be that open
source or closed source (since we don't want to open ourselves up to
lawsuits).

2.  In this case, there have been technical reasons provided. Granted
the developers (and people who are pro-inclusion) don't feel those are
justified, but they have been cited.

3.  You'll catch more flies with honey than vinegar (in other words,
fighting with the person(s) who maintain the project will most
definitely *not* get your code included).

4 (and the reason I decided to chime in here).  This email sums
everything up. Mark is pointing out that someone may want to use this in
a non LAN setting, and they may/will have problems due to the Internet
(and their specific way of accessing it). Andreas is arguing that it's
not the case.

I have to side with Mark on this one, solely because if I knew that it
would work, I'd use it to watch television when I'm traveling (as some
places don't carry the same channels that I have at home). So, I would
prove Mark's point.

Andreas, you said that "virtually EVERY (emphasis mine) user of it will
use it on a LAN". "Virtually" implies almost all-- NOT ALL. So, unless
there's some restriction in the application, which prevents it from
being used over the Internet, you can't guarantee that Mark's issues
aren't valid.

If as HoP pointed out in another reply on this thread, there's no kernel
patching required, then I suggest that you keep on developing it as a
userspace application. There's no law/rule/anything that says you can't
install your own driver in the kernel. It just won't be supported
upstream.  That just means more work for you, if you want the
application to continue working in the future. Truthfully, that has it's
upsides also. If you find out about a way to improve the transmission,
you don't have to wait (and hope) that it gets included in the kernel.
You can include it in your driver.

Sorry for butting into this. You're free to flame or ignore me, as you
choose.

Have a great day:)
Patrick.
