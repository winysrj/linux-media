Return-path: <linux-media-owner@vger.kernel.org>
Received: from 7of9.schinagl.nl ([88.159.158.68]:38664 "EHLO 7of9.schinagl.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753354Ab3AXORm (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 24 Jan 2013 09:17:42 -0500
Message-ID: <51014243.70901@schinagl.nl>
Date: Thu, 24 Jan 2013 15:16:35 +0100
From: Oliver Schinagl <oliver+list@schinagl.nl>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@redhat.com>
CC: Jonathan McCrohan <jmccrohan@gmail.com>,
	Jiri Slaby <jirislaby@gmail.com>,
	Manu Abraham <abraham.manu@gmail.com>,
	Michael Krufky <mkrufky@linuxtv.org>,
	Johannes Stezenbach <js@linuxtv.org>,
	linux-media <linux-media@vger.kernel.org>,
	Christoph Pfister <christophpfister@gmail.com>
Subject: Re: [RFC] Initial scan files troubles and brainstorming
References: <50EF0A4F.1000604@gmail.com> <CAHFNz9LrW4GCZb-BwJ8v7b8iT-+8pe-LAy8ZRN+mBDNLsssGPg@mail.gmail.com> <CAOcJUbwya++5nW_MKvGOGbeXCbxFgahu_AWEGBb6TLNx0Pz53A@mail.gmail.com> <CAHFNz9JTGZ1MmFCGqyyP0F4oa6t4048O+EYX50zH2J-axpkGVA@mail.gmail.com> <50EF2155.5060905@schinagl.nl> <CAHFNz9KxaShq=F1ePVbcz1j8jTv3ourn=xHM8kMFE_wiAU5JRA@mail.gmail.com> <50EF256B.8030308@gmail.com> <CAHFNz9KbwzYV_YLY-9StTn0DRV+vvFFhiG6FGcbjQ-EYV5S4wA@mail.gmail.com> <50EF276C.1080101@gmail.com> <50EF2AC0.20206@schinagl.nl> <20130111011232.GA3255@lambda.dereenigne.org> <20130111102317.63b26248@redhat.com>
In-Reply-To: <20130111102317.63b26248@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 11-01-13 13:23, Mauro Carvalho Chehab wrote:
> Em Fri, 11 Jan 2013 01:12:33 +0000
> Jonathan McCrohan <jmccrohan@gmail.com> escreveu:
>
>> On Thu, 10 Jan 2013 21:55:28 +0100, Oliver Schinagl wrote:
>>> Actually, there's plenty of apps etc that depend on it. I know some
>>> distro's install it into /usr/share/dvb for all to use. I think actually
>>> only a very small handfull use their own scanfiles. Very small handfull
>>> I belive ;)
>> Indeed. I have just gone to file an Intent To Package bug for the
>> dtv-scan-tables package in Debian, but I noticed that the COPYING and
>> README files were not split out from the dvb-apps tree.
>>
>> Logically it would follow that dtv-scan-tables is also licenced under
>> LGPL, the same as dvb-apps, but this needs to be stated explicitly.
>> This is especially true for distributions which be redistributing
>> dtv-scan-tables.
> As this is currently a copy of the dvb-apps, and the other patches added
> there are sent meant to be merged at dvb-apps, the license that applies
> on it should be inherited.
>
> That's said, this is just database entries where the values were obtained
> from a public service. Anyone else with access to the same
> transponders/carriers would be obtaining the very same data. So, I don't
> think that copyright law applies here. IANAL, but it sounds to me
> that such info would be public domain.
>
> Yet, to avoid legal issues, I suggest to copy the COPYING from
> the dvb-apps tree. Also, sooner or later a Makefile will likely be added
> there, and maybe some ancillary scripts. So, it makes sense to state
> the license there anyway.
License has been merged from dvb-apps (keeping history) and pushed to 
the repo.

> Regards,
> Mauro
