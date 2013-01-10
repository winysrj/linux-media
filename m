Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-oa0-f47.google.com ([209.85.219.47]:61469 "EHLO
	mail-oa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755020Ab3AJUiL (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 10 Jan 2013 15:38:11 -0500
Received: by mail-oa0-f47.google.com with SMTP id h1so1060496oag.20
        for <linux-media@vger.kernel.org>; Thu, 10 Jan 2013 12:38:10 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <50EF256B.8030308@gmail.com>
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
	<CAOcJUbwya++5nW_MKvGOGbeXCbxFgahu_AWEGBb6TLNx0Pz53A@mail.gmail.com>
	<CAHFNz9JTGZ1MmFCGqyyP0F4oa6t4048O+EYX50zH2J-axpkGVA@mail.gmail.com>
	<50EF2155.5060905@schinagl.nl>
	<CAHFNz9KxaShq=F1ePVbcz1j8jTv3ourn=xHM8kMFE_wiAU5JRA@mail.gmail.com>
	<50EF256B.8030308@gmail.com>
Date: Fri, 11 Jan 2013 02:08:10 +0530
Message-ID: <CAHFNz9KbwzYV_YLY-9StTn0DRV+vvFFhiG6FGcbjQ-EYV5S4wA@mail.gmail.com>
Subject: Re: [RFC] Initial scan files troubles and brainstorming
From: Manu Abraham <abraham.manu@gmail.com>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: Oliver Schinagl <oliver+list@schinagl.nl>,
	Michael Krufky <mkrufky@linuxtv.org>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Johannes Stezenbach <js@linuxtv.org>,
	linux-media <linux-media@vger.kernel.org>, jmccrohan@gmail.com,
	Christoph Pfister <christophpfister@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 1/11/13, Jiri Slaby <jirislaby@gmail.com> wrote:
> On 01/10/2013 09:25 PM, Manu Abraham wrote:
>>> Also, purely out of curiousity, how are the scanfiles used during
>>> development?
>>
>> The scanfiles what you call them are the configuration files for
>> dvb-apps,
>> rather than purely data files.
>
> But you cannot change their format, so what's the point? You can use
> them from a different directory or system ones...

The format can be definitely changed. There's no issue to it.

Manu
