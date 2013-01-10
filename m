Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ob0-f176.google.com ([209.85.214.176]:47205 "EHLO
	mail-ob0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754440Ab3AJUTT (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 10 Jan 2013 15:19:19 -0500
Received: by mail-ob0-f176.google.com with SMTP id un3so998014obb.7
        for <linux-media@vger.kernel.org>; Thu, 10 Jan 2013 12:19:18 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20130110180434.0681a7e1@redhat.com>
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
Date: Fri, 11 Jan 2013 01:49:18 +0530
Message-ID: <CAHFNz9J9azMZfQqaimPP1hJciCyUotDFno+=8d1EiPyaGu_wEA@mail.gmail.com>
Subject: Re: [RFC] Initial scan files troubles and brainstorming
From: Manu Abraham <abraham.manu@gmail.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Jiri Slaby <jirislaby@gmail.com>,
	Michael Krufky <mkrufky@linuxtv.org>,
	Oliver Schinagl <oliver+list@schinagl.nl>,
	Johannes Stezenbach <js@linuxtv.org>,
	linux-media <linux-media@vger.kernel.org>, jmccrohan@gmail.com,
	Christoph Pfister <christophpfister@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 1/11/13, Mauro Carvalho Chehab <mchehab@redhat.com> wrote:
> Em Fri, 11 Jan 2013 00:38:18 +0530
> Manu Abraham <abraham.manu@gmail.com> escreveu:
>
>> On 1/11/13, Jiri Slaby <jirislaby@gmail.com> wrote:
>> > On 01/10/2013 07:46 PM, Manu Abraham wrote:
>> >> The scan files and config files are very specific to dvb-apps, some
>> >> applications
>> >> do rely on these config files. It doesn't really make sense to have
>> >> split out config
>> >> files for these  small applications.
>> >
>> > I don't care where they are, really. However I'm strongly against
>> > duplicating them. Feel free to remove the newly created repository,
>> > I'll
>> > be fine with that.
>>
>> I haven't duplicated anything at all. It is Mauro who has duplicated
>> stuff,
>> by creating a new tree altogether.
>
> I only did it by request, and after having some consensus at the ML, and
> after people explicitly asking me to do that.
>

Having consensus implies that the people involved with it are in that loop,
rather than having a superfluous one with no one of it in that loop.

Manu
