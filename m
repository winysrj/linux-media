Return-path: <linux-media-owner@vger.kernel.org>
Received: from 7of9.schinagl.nl ([88.159.158.68]:53659 "EHLO 7of9.schinagl.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752431Ab3AJXS5 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 10 Jan 2013 18:18:57 -0500
Message-ID: <50EF4C83.9070506@schinagl.nl>
Date: Fri, 11 Jan 2013 00:19:31 +0100
From: Oliver Schinagl <oliver+list@schinagl.nl>
MIME-Version: 1.0
To: Jiri Slaby <jirislaby@gmail.com>
CC: Manu Abraham <abraham.manu@gmail.com>,
	Michael Krufky <mkrufky@linuxtv.org>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Johannes Stezenbach <js@linuxtv.org>,
	linux-media <linux-media@vger.kernel.org>, jmccrohan@gmail.com,
	Christoph Pfister <christophpfister@gmail.com>
Subject: Re: [RFC] Initial scan files troubles and brainstorming
References: <507FE752.6010409@schinagl.nl> <50D0E7A7.90002@schinagl.nl> <50EAA778.6000307@gmail.com> <50EAC41D.4040403@schinagl.nl> <20130108200149.GB408@linuxtv.org> <50ED3BBB.4040405@schinagl.nl> <20130109084143.5720a1d6@redhat.com> <CAOcJUbyKv-b7mC3-W-Hp62O9CBaRLVP8c=AWGcddWNJOAdRt7Q@mail.gmail.com> <20130109124158.50ddc834@redhat.com> <CAHFNz9+=awiUjve3QPgHtu5Vs2rbGqcLUMzyOojguHnY4wvnOA@mail.gmail.com> <50EF0A4F.1000604@gmail.com> <CAHFNz9LrW4GCZb-BwJ8v7b8iT-+8pe-LAy8ZRN+mBDNLsssGPg@mail.gmail.com> <CAOcJUbwya++5nW_MKvGOGbeXCbxFgahu_AWEGBb6TLNx0Pz53A@mail.gmail.com> <CAHFNz9JTGZ1MmFCGqyyP0F4oa6t4048O+EYX50zH2J-axpkGVA@mail.gmail.com> <50EF2155.5060905@schinagl.nl> <CAHFNz9KxaShq=F1ePVbcz1j8jTv3ourn=xHM8kMFE_wiAU5JRA@mail.gmail.com> <50EF256B.8030308@gmail.com> <CAHFNz9KbwzYV_YLY-9StTn0DRV+vvFFhiG6FGcbjQ-EYV5S4wA@mail.gmail.com> <50EF276C.1080101@gmail.com> <50EF27CE.1030206@gmail.com>
In-Reply-To: <50EF27CE.1030206@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 01/10/13 21:42, Jiri Slaby wrote:
> On 01/10/2013 09:41 PM, Jiri Slaby wrote:
>> On 01/10/2013 09:38 PM, Manu Abraham wrote:
>>> The format can be definitely changed. There's no issue to it.
>>
>> No you cannot. Applications depend on that, it's part of the dvb ABI. If
>> you changed that, you would do the same mistake as Mauro let it flowing
>> through his tree and it was pointed out by Linus in the link you sent...
>
> Id you provide an abstraction library, convert all applications to use
> that instead of the files, you can change them then. Not any time before.
>

Well isn't the scan tables list a database of sorts? It contains the 
transponder settings for all public accessible transponders. Or should 
anyway.

The format, for now, suffices I'd think. Also, you already convert it 
sort of. You use dvbscan or whatever scan, to take those files and 
create channels.conf or what not from it (and search for extra 
transponders, but having _all_ transponders in the repository would be 
overkill though I think we do that for dvb-T?

So in a sense, it exists as that already :)
