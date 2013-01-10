Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-oa0-f52.google.com ([209.85.219.52]:50799 "EHLO
	mail-oa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754056Ab3AJUZf (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 10 Jan 2013 15:25:35 -0500
Received: by mail-oa0-f52.google.com with SMTP id o6so1077724oag.11
        for <linux-media@vger.kernel.org>; Thu, 10 Jan 2013 12:25:34 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <50EF2155.5060905@schinagl.nl>
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
Date: Fri, 11 Jan 2013 01:55:34 +0530
Message-ID: <CAHFNz9KxaShq=F1ePVbcz1j8jTv3ourn=xHM8kMFE_wiAU5JRA@mail.gmail.com>
Subject: Re: [RFC] Initial scan files troubles and brainstorming
From: Manu Abraham <abraham.manu@gmail.com>
To: Oliver Schinagl <oliver+list@schinagl.nl>
Cc: Michael Krufky <mkrufky@linuxtv.org>,
	Jiri Slaby <jirislaby@gmail.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Johannes Stezenbach <js@linuxtv.org>,
	linux-media <linux-media@vger.kernel.org>, jmccrohan@gmail.com,
	Christoph Pfister <christophpfister@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 1/11/13, Oliver Schinagl <oliver+list@schinagl.nl> wrote:
>> they can say anything what they want, which makes no sense at all.
> Well there are a few apps that do use the initial scanfile tree, but do
> not use any of the dvb-apps.
>
> (tvheadend, kaffeine appearantly, i'm guessing VDR and MythTV aswell?)

Only tvheadend and kaffeine AFAIK. VDR and MythTV have their own formats.


>>
>>
>>> Meanwhile, your argument is for developers.  Developers can handle
>>> pulling from a separated tree for data files who shouldn't be clouding
>>> the history of source code development, anyway.  Developers are indeed
>>> used to dealing with multiple repositories, and if any developer
>>> isn't, then now is the time to get with the program!
>>
>>
>> It isn't that way. Users have to deal with 2 repositories as well.
>> Anyway,
>> the repository is not having that many developers to state that
>> developers
>> can handle all the burden. It is just but the reverse.
> Well one of the biggest issues was, that the scanfiles where ill
> maintained and projects where working around those shortcommings.
>
> The scanfiles are technically unrelated. They are data files, facts and
> can very logically live seperated :) Having commit messages pure for
> data files in a source tree just looks off.


The configuration files/data for dvb-apps.

>
> They simply have become a seperate entity as people (not developers)
> depend on them. (Yes there is wscan of course).
>
> Also, purely out of curiousity, how are the scanfiles used during
> development?

The scanfiles what you call them are the configuration files for dvb-apps,
rather than purely data files.

Manu
