Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from fg-out-1718.google.com ([72.14.220.159])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <mrechberger@gmail.com>) id 1KipoM-0000BG-HQ
	for linux-dvb@linuxtv.org; Thu, 25 Sep 2008 14:19:12 +0200
Received: by fg-out-1718.google.com with SMTP id e21so293482fga.25
	for <linux-dvb@linuxtv.org>; Thu, 25 Sep 2008 05:19:07 -0700 (PDT)
Message-ID: <d9def9db0809250519m7b21f947o7bb84147d5e70dfe@mail.gmail.com>
Date: Thu, 25 Sep 2008 14:19:07 +0200
From: "Markus Rechberger" <mrechberger@gmail.com>
To: "Thierry Lelegard" <thierry.lelegard@tv-numeric.com>
In-Reply-To: <!~!UENERkVCMDkAAQACAAAAAAAAAAAAAAAAABgAAAAAAAAAJf2pBr8u1U+Z+cArRcz8PAKHAAAQAAAAFWGD+9r2SkGGhLj/rwn00AEAAAAA@tv-numeric.com>
MIME-Version: 1.0
Content-Disposition: inline
References: <200809251248.20557.janne-dvb@grunau.be>
	<!~!UENERkVCMDkAAQACAAAAAAAAAAAAAAAAABgAAAAAAAAAJf2pBr8u1U+Z+cArRcz8PAKHAAAQAAAAFWGD+9r2SkGGhLj/rwn00AEAAAAA@tv-numeric.com>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] RE : [RFC] Let the future decide between the two.
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

On Thu, Sep 25, 2008 at 2:10 PM, Thierry Lelegard
<thierry.lelegard@tv-numeric.com> wrote:
>> De : linux-dvb-bounces@linuxtv.org
>> [mailto:linux-dvb-bounces@linuxtv.org] De la part de Janne Grunau
>> Envoy=E9 : jeudi 25 septembre 2008 12:48
>> =C0 : linux-dvb@linuxtv.org
>> Objet : Re: [linux-dvb] [RFC] Let the future decide between the two.
>>
>>
>> On Thursday 25 September 2008 08:45:28 Michel Verbraak wrote:
>> [...]
>> > I would like to propose the following:
>> >
>> > - Keep the two different DVB API sets next to one another. Both
>> > having a space on Linuxtv.org to explain their knowledge and how to
>> > use them. - Each with their own respective maintainers to get stuff
>> > into the kernel. I mean V4L had two versions.
>> > - Let driver developers decide which API they will follow. Or even
>> > develop for both.
>> > - Let application developers decide which API they will support.
>> > - Let distribution packagers decide which API they will have
>> > activated by default in their distribution.
>> > - Let the end users decide which one will be used most. (Probably
>> > they will decide on: Is my hardware supported or not).
>> > - If democracy is that strong one of them will win or maybey the two
>> > will get merged and we, the end users, get best of both worlds.
>> >
>> > As the subject says: This is a Request For Comment.
>>
>> This is complete nonsense, distrobution packagers shouldn't
>> decide which
>> API should be used, the API and all drivers should be in the kernel.
>> Having two tree is at best fragmentation and at worst a whole lot of
>> duplicated work.
>
> Having the two coexisting API is a COMPLETE SOFTWARE DESIGN NONSENSE.
>
> This would not be a "cathedral to bazaar" transition, as someone wrote
> on the subject, it would be a "bazaat to mess" transition.
>
> I have no technical opinion on Multiproto vs. S2API since I have been
> using only DVT-T device for the last two years. But I have more than
> 20 years of experience in software design and that would be for sure
> the worst decision ever.
>
> On a user point of view, Janne's point is the most important one:
>> That should a user do if he has two devices which are only
>> supported by one of the trees? That's bad luck?
>
> And this is not only a Multiproto vs. S2API issue. As I mentioned,
> I use only DVT-T devices. I have 4 of them, all working on Linux
> for months or years and there is no one single repository supporting
> all of them at the same time. Most are supported by
> http://linuxtv.org/hg/v4l-dvb, another one needs
> http://linuxtv.org/hg/~anttip/af9015 plus other patches.
> And this is not a transitional situation, it lasts for months.
>
> This is an endemic but unacceptable situation. And, again, this is
> not only Multiproto vs. S2API. IMHO, linux DVB has a real leadership
> problem. There are just too many different forks which could be accepted
> during transition periods (development and validation of a driver)
> but which cannot survive that long.
>
> All these various trees contains technically good code. So, this
> is not a technical problem. Failing to merge them is a leadership
> problem ("cathedral companies" would say a "management problem").
>
> Imagine what would be the kernel today with that kind of methods?
> But for the kernel, there is Linus, a leader that you may like or
> not but that everyone respect (and respect the decisions of). The
> situation in Linux DVB is not like that, unfortunately.
>
> Since Linux DVB is a subsystem of the kernel and since there is
> no undisputed leader in Linux DVB, why not asking for Linus'
> arbitration? He started to get involved AFAIK.
>

look at the wireless framework, sound framework all went through some evolu=
tion.

There are around 18 devices supported by multiproto and a few ones
supported by Stevens proposal.
Steven is pulling against the multiproto path which has been available
for years.

searching google for multiproto dvb returns >40.000 hits

for s2api dvb returns  277 hits
or "s2 api" dvb returns 288 hits

Markus

> Currently, all arguments are like:
> - "This API is technically better" (not a technical problem we told you)
> - "Give me technical reasons" (same)
> - "This was voted" (validity of this vote is disputed -> leadership pb)
> - "You don't like me" (personal problems)
>
> One way to get out of this loop is to call for Linus.
>
> -Thierry
>
>
> _______________________________________________
> linux-dvb mailing list
> linux-dvb@linuxtv.org
> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
>

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
