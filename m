Return-path: <linux-media-owner@vger.kernel.org>
Received: from 7of9.schinagl.nl ([88.159.158.68]:56974 "EHLO 7of9.schinagl.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753832Ab3AKIKs (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 11 Jan 2013 03:10:48 -0500
Message-ID: <50EFC8EC.7000609@schinagl.nl>
Date: Fri, 11 Jan 2013 09:10:20 +0100
From: Oliver Schinagl <oliver+list@schinagl.nl>
MIME-Version: 1.0
To: Jonathan McCrohan <jmccrohan@gmail.com>
CC: Jiri Slaby <jirislaby@gmail.com>,
	Manu Abraham <abraham.manu@gmail.com>,
	Michael Krufky <mkrufky@linuxtv.org>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Johannes Stezenbach <js@linuxtv.org>,
	linux-media <linux-media@vger.kernel.org>,
	Christoph Pfister <christophpfister@gmail.com>
Subject: Legallity of dtv-scan-tables Was: [RFC] Initial scan files troubles
 and brainstorming
References: <50EF0A4F.1000604@gmail.com> <CAHFNz9LrW4GCZb-BwJ8v7b8iT-+8pe-LAy8ZRN+mBDNLsssGPg@mail.gmail.com> <CAOcJUbwya++5nW_MKvGOGbeXCbxFgahu_AWEGBb6TLNx0Pz53A@mail.gmail.com> <CAHFNz9JTGZ1MmFCGqyyP0F4oa6t4048O+EYX50zH2J-axpkGVA@mail.gmail.com> <50EF2155.5060905@schinagl.nl> <CAHFNz9KxaShq=F1ePVbcz1j8jTv3ourn=xHM8kMFE_wiAU5JRA@mail.gmail.com> <50EF256B.8030308@gmail.com> <CAHFNz9KbwzYV_YLY-9StTn0DRV+vvFFhiG6FGcbjQ-EYV5S4wA@mail.gmail.com> <50EF276C.1080101@gmail.com> <50EF2AC0.20206@schinagl.nl> <20130111011232.GA3255@lambda.dereenigne.org>
In-Reply-To: <20130111011232.GA3255@lambda.dereenigne.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 11-01-13 02:12, Jonathan McCrohan wrote:
> On Thu, 10 Jan 2013 21:55:28 +0100, Oliver Schinagl wrote:
>> Actually, there's plenty of apps etc that depend on it. I know some
>> distro's install it into /usr/share/dvb for all to use. I think actually
>> only a very small handfull use their own scanfiles. Very small handfull
>> I belive ;)
> Indeed. I have just gone to file an Intent To Package bug for the
> dtv-scan-tables package in Debian, but I noticed that the COPYING and
> README files were not split out from the dvb-apps tree.
If some have any pointers in what would be logical in the readme, i'll 
whip one up this afternoon.

but copying is an interesting point.
>
> Logically it would follow that dtv-scan-tables is also licenced under
> LGPL, the same as dvb-apps, but this needs to be stated explicitly.
> This is especially true for distributions which be redistributing
> dtv-scan-tables.
I don't think it is that logical actually. Remember the ntpd fiasco a 
few months back? Where some company claimed they had copyright on 
factual data?

This is as far as I can tell, factual data. A Satellite or Antenna is 
configured to broadcast in a certain way, the scan tables are a 
collection of this data. They get to us from volunteers who either scan 
for them or find 'official' docs from the broadcaster and re-arrange it 
to something useful to us.....

So who owns this data? Can it be licensed as GPL? Falls it under the 
Public Domain by default?

Personally, I think that the copyright license applied to the actual 
source code, but not the scan tables.

>
> Thanks,
> Jon
Oliver
