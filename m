Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from fg-out-1718.google.com ([72.14.220.159])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <mrechberger@gmail.com>) id 1Kiuk7-000446-Oq
	for linux-dvb@linuxtv.org; Thu, 25 Sep 2008 19:35:08 +0200
Received: by fg-out-1718.google.com with SMTP id e21so374565fga.25
	for <linux-dvb@linuxtv.org>; Thu, 25 Sep 2008 10:35:04 -0700 (PDT)
Message-ID: <d9def9db0809251035p404c1feaq8491ead805d8b811@mail.gmail.com>
Date: Thu, 25 Sep 2008 19:35:03 +0200
From: "Markus Rechberger" <mrechberger@gmail.com>
To: "Thierry Lelegard" <thierry.lelegard@tv-numeric.com>
In-Reply-To: <!~!UENERkVCMDkAAQACAAAAAAAAAAAAAAAAABgAAAAAAAAAJf2pBr8u1U+Z+cArRcz8PAKHAAAQAAAAMMIN1j3+okaNUJt73+hyGgEAAAAA@tv-numeric.com>
MIME-Version: 1.0
Content-Disposition: inline
References: <alpine.LFD.1.10.0809250942251.21990@areia.chehab.org>
	<!~!UENERkVCMDkAAQACAAAAAAAAAAAAAAAAABgAAAAAAAAAJf2pBr8u1U+Z+cArRcz8PAKHAAAQAAAAMMIN1j3+okaNUJt73+hyGgEAAAAA@tv-numeric.com>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] RE : RE : [RFC] Let the future decide between the
	two.
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

On Thu, Sep 25, 2008 at 3:55 PM, Thierry Lelegard
<thierry.lelegard@tv-numeric.com> wrote:
>> De : Mauro Carvalho Chehab [mailto:mchehab@infradead.org]
>> Envoy=E9 : jeudi 25 septembre 2008 14:46
>>
>> On Thu, 25 Sep 2008, Thierry Lelegard wrote:
>>
>> > I use only DVT-T devices. I have 4 of them, all working on Linux
>> > for months or years and there is no one single repository supporting
>> > all of them at the same time. Most are supported by
>> > http://linuxtv.org/hg/v4l-dvb, another one needs
>> > http://linuxtv.org/hg/~anttip/af9015 plus other patches.
>> > And this is not a transitional situation, it lasts for months.
>>
>> Patches are merged upstream when their authors think they're
>> ready and
>> sends a pull request.
>>
>> In the case of af9015, Antti sent us a pull request those
>> days and were
>> merged this week at the development tree. It should be available for
>> 2.6.28.
>
> Thank you for the update. This is good news indeed.
>
> However, this was only an example to illustrate the main point:
> the leadership problem in linux dvb.
>
> The fact that, after years of parallel and uncoordinated development,
> everyone (Manu, now Antti) suddenly feel the urgent need to merge
> everything is another illustration of this lack of leadership.
> "Bazaar" development has never been a synonym for "uncoordinated"
> development. Call it leadership or "coordinatorship", we just need it.
>

Thierry, I think uncoordinated development is more or less a side effect
and will happen from time to time (this has nothing to do with
maintainership as far
as I would say).
I think something like that will solve itself automatically when the
code is mature enough
of the parties.
Let the people do their own job wherever they want, the final enduser
has the advantage
of a higher quality of the driver in the end (see the broken intel
driver and the discussion
about a staging directory on the lkml just in order to avoid to break
hardware in future).

btw. this thread got again hijacked from the initial wanted discussion
of Michel.
"Let the future decide between the two."

Markus

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
