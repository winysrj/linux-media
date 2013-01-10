Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ob0-f176.google.com ([209.85.214.176]:39903 "EHLO
	mail-ob0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755969Ab3AJUnG (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 10 Jan 2013 15:43:06 -0500
Received: by mail-ob0-f176.google.com with SMTP id un3so1038741obb.35
        for <linux-media@vger.kernel.org>; Thu, 10 Jan 2013 12:43:06 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20130110183718.735fe71d@redhat.com>
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
	<20130110183718.735fe71d@redhat.com>
Date: Fri, 11 Jan 2013 02:13:06 +0530
Message-ID: <CAHFNz9JcH+J_RASnc9Rj1cZ9Ly_yk32UhTLga=ZCyi7EhXtvyw@mail.gmail.com>
Subject: Re: [RFC] Initial scan files troubles and brainstorming
From: Manu Abraham <abraham.manu@gmail.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Oliver Schinagl <oliver+list@schinagl.nl>,
	Michael Krufky <mkrufky@linuxtv.org>,
	Jiri Slaby <jirislaby@gmail.com>,
	Johannes Stezenbach <js@linuxtv.org>,
	linux-media <linux-media@vger.kernel.org>, jmccrohan@gmail.com,
	Christoph Pfister <christophpfister@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 1/11/13, Mauro Carvalho Chehab <mchehab@redhat.com> wrote:
> Em Fri, 11 Jan 2013 01:55:34 +0530
> Manu Abraham <abraham.manu@gmail.com> escreveu:
>
>> On 1/11/13, Oliver Schinagl <oliver+list@schinagl.nl> wrote:
>> >> they can say anything what they want, which makes no sense at all.
>> > Well there are a few apps that do use the initial scanfile tree, but do
>> > not use any of the dvb-apps.
>> >
>> > (tvheadend, kaffeine appearantly, i'm guessing VDR and MythTV aswell?)
>>
>> Only tvheadend and kaffeine AFAIK. VDR and MythTV have their own formats.
>
> Both mplayer and vlc work with the channels-conf files.

True. they depend upon the output from dvbscan. So when scan changes format,
they will also need to "update formats to acquire new functionality", else they
will be stuck with old functionality.

Manu
