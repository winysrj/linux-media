Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f52.google.com ([74.125.83.52]:39511 "EHLO
	mail-ee0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754513Ab3AJUlV (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 10 Jan 2013 15:41:21 -0500
Received: by mail-ee0-f52.google.com with SMTP id b15so116668eek.25
        for <linux-media@vger.kernel.org>; Thu, 10 Jan 2013 12:41:19 -0800 (PST)
Message-ID: <50EF276C.1080101@gmail.com>
Date: Thu, 10 Jan 2013 21:41:16 +0100
From: Jiri Slaby <jirislaby@gmail.com>
MIME-Version: 1.0
To: Manu Abraham <abraham.manu@gmail.com>
CC: Oliver Schinagl <oliver+list@schinagl.nl>,
	Michael Krufky <mkrufky@linuxtv.org>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Johannes Stezenbach <js@linuxtv.org>,
	linux-media <linux-media@vger.kernel.org>, jmccrohan@gmail.com,
	Christoph Pfister <christophpfister@gmail.com>
Subject: Re: [RFC] Initial scan files troubles and brainstorming
References: <507FE752.6010409@schinagl.nl> <50D0E7A7.90002@schinagl.nl> <50EAA778.6000307@gmail.com> <50EAC41D.4040403@schinagl.nl> <20130108200149.GB408@linuxtv.org> <50ED3BBB.4040405@schinagl.nl> <20130109084143.5720a1d6@redhat.com> <CAOcJUbyKv-b7mC3-W-Hp62O9CBaRLVP8c=AWGcddWNJOAdRt7Q@mail.gmail.com> <20130109124158.50ddc834@redhat.com> <CAHFNz9+=awiUjve3QPgHtu5Vs2rbGqcLUMzyOojguHnY4wvnOA@mail.gmail.com> <50EF0A4F.1000604@gmail.com> <CAHFNz9LrW4GCZb-BwJ8v7b8iT-+8pe-LAy8ZRN+mBDNLsssGPg@mail.gmail.com> <CAOcJUbwya++5nW_MKvGOGbeXCbxFgahu_AWEGBb6TLNx0Pz53A@mail.gmail.com> <CAHFNz9JTGZ1MmFCGqyyP0F4oa6t4048O+EYX50zH2J-axpkGVA@mail.gmail.com> <50EF2155.5060905@schinagl.nl> <CAHFNz9KxaShq=F1ePVbcz1j8jTv3ourn=xHM8kMFE_wiAU5JRA@mail.gmail.com> <50EF256B.8030308@gmail.com> <CAHFNz9KbwzYV_YLY-9StTn0DRV+vvFFhiG6FGcbjQ-EYV5S4wA@mail.gmail.com>
In-Reply-To: <CAHFNz9KbwzYV_YLY-9StTn0DRV+vvFFhiG6FGcbjQ-EYV5S4wA@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 01/10/2013 09:38 PM, Manu Abraham wrote:
> The format can be definitely changed. There's no issue to it.

No you cannot. Applications depend on that, it's part of the dvb ABI. If
you changed that, you would do the same mistake as Mauro let it flowing
through his tree and it was pointed out by Linus in the link you sent...

-- 
js
