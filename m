Return-path: <mchehab@pedra>
Received: from cain.gsoft.com.au ([203.31.81.10]:40752 "EHLO cain.gsoft.com.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754356Ab1BGEKn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 6 Feb 2011 23:10:43 -0500
Subject: Re: Tuning channels with DViCO FusionHDTV7 Dual Express
Mime-Version: 1.0 (Apple Message framework v1082)
Content-Type: text/plain; charset=us-ascii
From: "Daniel O'Connor" <darius@dons.net.au>
In-Reply-To: <AANLkTinMCTh-u-JgcNB3SsZ2yf+9DgNFGA6thF7S0K15@mail.gmail.com>
Date: Mon, 7 Feb 2011 14:40:22 +1030
Cc: v4l-dvb Mailing List <linux-media@vger.kernel.org>
Content-Transfer-Encoding: 8BIT
Message-Id: <6C78EB6E-7722-447F-833D-637DBB64CF61@dons.net.au>
References: <AANLkTin8Rjch6o7aU-9S9m8f5aBYVeSwxSaVhyEfM5q9@mail.gmail.com> <20110206232800.GA83692@io.frii.com> <AANLkTinMCTh-u-JgcNB3SsZ2yf+9DgNFGA6thF7S0K15@mail.gmail.com>
To: Dave Johansen <davejohansen@gmail.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>


On 07/02/2011, at 13:34, Dave Johansen wrote:
>> However the drivers in Ubuntu at least work for 1 tuner, if I try and use both in mythtv one tends to lock up after a while :-/
> 
> I actually had the card working and tuning channels about 2 years ago
> with Ubuntu 08.10 and 09.04. From what I recall 08.10 required updated

Yes that's my recollection.

> drivers but 09.04 didn't, so I'd imagine that it should at least be
> possible for it to work and possibly just out of the box. But do you
> think that has a high likelihood of success now?

I would expect at least a single channel and the remote to work since your card seems very similar to mine..

However I don't see any timeouts using mine, at least for 1 channel. Have you looked in dmesg for related parameters?

> 
> On Sun, Feb 6, 2011 at 4:28 PM, Mark Zimmerman <markzimm@frii.com> wrote:
>> On Sun, Feb 06, 2011 at 03:46:59PM -0700, Dave Johansen wrote:
>>> I am trying to resurrect my MythBuntu system with a DViCO FusionHDTV7
>>> Dual Express. I had previously had some issues with trying to get
>>> channels working in MythTV (
>>> http://www.mail-archive.com/linux-media@vger.kernel.org/msg03846.html
>>> ), but now it locks up with MythBuntu 10.10 when I scan for channels
>>> in MythTV and also with the scan command line utility.
>>> 
>>> Here's the output from scan:
>>> 
>>> scan /usr/share/dvb/atsc/us-ATSC-
>>> center-frequencies-8VSB
>>> scanning us-ATSC-center-frequencies-8VSB
>>> using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'
>>>>>> tune to: 189028615:8VSB
>>> WARNING: filter timeout pid 0x0000
>>> WARNING: filter timeout pid 0x1ffb
>>> 
>>> Any ideas/suggestions on how I can get this to work?
>> 
>> Check your dmesg to see if yout firmware loads.
>> 
>> 
>> 
> 
> I checked dmesg and the firmware loads. It doesn't appear to report
> any errors either.
> 
> Thanks,
> Dave
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

--
Daniel O'Connor software and network engineer
for Genesis Software - http://www.gsoft.com.au
"The nice thing about standards is that there
are so many of them to choose from."
  -- Andrew Tanenbaum
GPG Fingerprint - 5596 B766 97C0 0E94 4347 295E E593 DC20 7B3F CE8C






