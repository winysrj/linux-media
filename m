Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ob0-f179.google.com ([209.85.214.179]:62616 "EHLO
	mail-ob0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753427Ab3AJVE0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 10 Jan 2013 16:04:26 -0500
Received: by mail-ob0-f179.google.com with SMTP id x4so1057385obh.38
        for <linux-media@vger.kernel.org>; Thu, 10 Jan 2013 13:04:25 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <50EF29D1.2080102@schinagl.nl>
References: <507FE752.6010409@schinagl.nl>
	<50D0E7A7.90002@schinagl.nl>
	<50EAA778.6000307@gmail.com>
	<50EAC41D.4040403@schinagl.nl>
	<20130108200149.GB408@linuxtv.org>
	<50ED3BBB.4040405@schinagl.nl>
	<20130109084143.5720a1d6@redhat.com>
	<CAOcJUbyKv-b7mC3-W-Hp62O9CBaRLVP8c=AWGcddWNJOAdRt7Q@mail.gmail.com>
	<20130109124158.50ddc834@redhat.com>
	<CAHFNz9+=awiUjve3QPgHtu5Vs2rbGqcLUMzyOojguHnY4wvnOA@mail.gmail.com>
	<50EF0A4F.1000604@gmail.com>
	<CAHFNz9LrW4GCZb-BwJ8v7b8iT-+8pe-LAy8ZRN+mBDNLsssGPg@mail.gmail.com>
	<50EF1034.7060100@gmail.com>
	<CAHFNz9KWf=EtvpJ1kDGFPKSvqwd9S51O1=wVYcjNmZE-+_7Emg@mail.gmail.com>
	<20130110180434.0681a7e1@redhat.com>
	<CAHFNz9+Jon-YSjkX5gFOTXwX+Vsmi0Rq+X_N61-m2+AEX+8tGg@mail.gmail.com>
	<50EF29D1.2080102@schinagl.nl>
Date: Fri, 11 Jan 2013 02:34:25 +0530
Message-ID: <CAHFNz9LQR6gPnO_EXygqe1-Y84wyKBjrc3cCkhd2Jugfr8wrTw@mail.gmail.com>
Subject: Re: [RFC] Initial scan files troubles and brainstorming
From: Manu Abraham <abraham.manu@gmail.com>
To: Oliver Schinagl <oliver+list@schinagl.nl>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Jiri Slaby <jirislaby@gmail.com>,
	Michael Krufky <mkrufky@linuxtv.org>,
	Johannes Stezenbach <js@linuxtv.org>,
	linux-media <linux-media@vger.kernel.org>, jmccrohan@gmail.com,
	Christoph Pfister <christophpfister@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 1/11/13, Oliver Schinagl <oliver+list@schinagl.nl> wrote:
> On 01/10/13 21:32, Manu Abraham wrote:
>> On 1/11/13, Mauro Carvalho Chehab <mchehab@redhat.com> wrote:
>>> Em Fri, 11 Jan 2013 00:38:18 +0530
>>> Manu Abraham <abraham.manu@gmail.com> escreveu:
>>>
>>>> On 1/11/13, Jiri Slaby <jirislaby@gmail.com> wrote:
>>>>> On 01/10/2013 07:46 PM, Manu Abraham wrote:
>>>>>> The scan files and config files are very specific to dvb-apps, some
>>>>>> applications
>>>>>> do rely on these config files. It doesn't really make sense to have
>>>>>> split out config
>>>>>> files for these  small applications.
>>>>>
>>>>> I don't care where they are, really. However I'm strongly against
>>>>> duplicating them. Feel free to remove the newly created repository,
>>>>> I'll
>>>>> be fine with that.
>>>>
>>>> I haven't duplicated anything at all. It is Mauro who has duplicated
>>>> stuff,
>>>> by creating a new tree altogether.
>>>
>>> I only did it by request, and after having some consensus at the ML, and
>>> after people explicitly asking me to do that.
>>>
>>> I even tried to not express my opinion to anybody. But it seems I'm
>>> forced by you to give it. So, let it be.
>>>
>>> The last patches from you there were 11 months ago, and didn't bring any
>>> new functionality there... they are just indentation fixes:
>>> 	http://www.linuxtv.org/hg/dvb-apps/
>>
>>
>> The way you do things, it all ends up like this.
>>
>> https://lkml.org/lkml/2012/12/23/75
> That's just mean and below the belt.
>
> Anyway, I've brought this issue up on the 18th of oktober 2012 on this
> mailing list. I had zero replies until early december. Jonathan
> commented a little and said it was a good idea.
>
> Also a few comments about how their patches to scanfiles (data files,
> facts) where ignored for weeks to an end.
>


There was someone who was actively maintaining the config files.
One cannot simply state something different unless that person has to say
something. In this case as soon as Christoph talked about his stand,
I did express my opinion as well.



> Mauro didn't get involved to have everybody that is a maintainer etc get
> a good chance to respond.
>

Mauro doesn't do anything wrt dvb-apps. I don't understand, what you
are trying to state here.


> The only thing that came from this, is that someone actually stopped
> maintaining it.
>
> Then after everything actually was done (for the better imo), you come
> in and say it's a bad thing, but dont' really tell us why. Other than it
> makes development hard for you, which nobody really agree's to with.

At least you should have the courtesy to talk about it with the people
who are/were working with it, rather than the people who have no
connection to it.

I don't want to let go of the efforts that you would like to put into, and
hence stated that it would be appreciated if you would maintain the
config files within the dvb-apps tree.

Just like how you think it is bad for the applications to carry it's own
configuration files, I think that it is better for any application to carry
it's own configuration files.

Manu
