Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ea0-f170.google.com ([209.85.215.170]:44539 "EHLO
	mail-ea0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754796Ab3AJTL4 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 10 Jan 2013 14:11:56 -0500
Received: by mail-ea0-f170.google.com with SMTP id d11so391042eaa.29
        for <linux-media@vger.kernel.org>; Thu, 10 Jan 2013 11:11:54 -0800 (PST)
Message-ID: <50EF1277.4060507@gmail.com>
Date: Thu, 10 Jan 2013 20:11:51 +0100
From: Jiri Slaby <jirislaby@gmail.com>
MIME-Version: 1.0
To: Manu Abraham <abraham.manu@gmail.com>
CC: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Michael Krufky <mkrufky@linuxtv.org>,
	Oliver Schinagl <oliver+list@schinagl.nl>,
	Johannes Stezenbach <js@linuxtv.org>,
	linux-media <linux-media@vger.kernel.org>, jmccrohan@gmail.com,
	Christoph Pfister <christophpfister@gmail.com>
Subject: Re: [RFC] Initial scan files troubles and brainstorming
References: <507FE752.6010409@schinagl.nl> <50D0E7A7.90002@schinagl.nl> <50EAA778.6000307@gmail.com> <50EAC41D.4040403@schinagl.nl> <20130108200149.GB408@linuxtv.org> <50ED3BBB.4040405@schinagl.nl> <20130109084143.5720a1d6@redhat.com> <CAOcJUbyKv-b7mC3-W-Hp62O9CBaRLVP8c=AWGcddWNJOAdRt7Q@mail.gmail.com> <20130109124158.50ddc834@redhat.com> <CAHFNz9+=awiUjve3QPgHtu5Vs2rbGqcLUMzyOojguHnY4wvnOA@mail.gmail.com> <50EF0A4F.1000604@gmail.com> <CAHFNz9LrW4GCZb-BwJ8v7b8iT-+8pe-LAy8ZRN+mBDNLsssGPg@mail.gmail.com> <50EF1034.7060100@gmail.com> <CAHFNz9KWf=EtvpJ1kDGFPKSvqwd9S51O1=wVYcjNmZE-+_7Emg@mail.gmail.com>
In-Reply-To: <CAHFNz9KWf=EtvpJ1kDGFPKSvqwd9S51O1=wVYcjNmZE-+_7Emg@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 01/10/2013 08:08 PM, Manu Abraham wrote:
> On 1/11/13, Jiri Slaby <jirislaby@gmail.com> wrote:
>> On 01/10/2013 07:46 PM, Manu Abraham wrote:
>>> The scan files and config files are very specific to dvb-apps, some
>>> applications
>>> do rely on these config files. It doesn't really make sense to have
>>> split out config
>>> files for these  small applications.
>>
>> I don't care where they are, really. However I'm strongly against
>> duplicating them. Feel free to remove the newly created repository, I'll
>> be fine with that.
> 
> I haven't duplicated anything at all. It is Mauro who has duplicated stuff,
> by creating a new tree altogether.

I didn't accuse you. This was a general comment to everybody. Whatever
the consensus is at the end, do not duplicate the data.

> if you need the scan files to be properly maintained then you need to
> handle it in the same repository altogether. Not by separating out the
> configuration files of a few applications.

That's up to you guys to decide. I don't mind either option.

-- 
js
