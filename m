Return-path: <linux-media-owner@vger.kernel.org>
Received: from vader.hardeman.nu ([95.142.160.32]:34437 "EHLO hardeman.nu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753510AbbC3U0v (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 30 Mar 2015 16:26:51 -0400
To: Stefan Lippers-Hollmann <s.l-h@gmx.de>
Subject: Re: mceusb: sysfs: cannot create duplicate filename '/class/rc/rc0'  (race condition between multiple =?UTF-8?Q?RC=5FCORE=20devices=29?=
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 8bit
Date: Mon, 30 Mar 2015 22:26:49 +0200
From: =?UTF-8?Q?David_H=C3=A4rdeman?= <david@hardeman.nu>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
	m.chehab@samsung.com, James Hogan <james.hogan@imgtec.com>,
	=?UTF-8?Q?Antti_Sepp=C3=A4l=C3=A4?= <a.seppala@gmail.com>,
	Tomas Melin <tomas.melin@iki.fi>
In-Reply-To: <20150330222119.16ee359e@mir>
References: <201412181916.18051.s.L-H@gmx.de>
 <201412302211.40801.s.L-H@gmx.de> <20150330173031.1fb46443@mir>
 <61aca9029bf06b2a3f322018aee00dda@hardeman.nu> <20150330222119.16ee359e@mir>
Message-ID: <8addd45044293abdf0a223a1c6155154@hardeman.nu>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 2015-03-30 22:21, Stefan Lippers-Hollmann wrote:
> On 2015-03-30, David Härdeman wrote:
>> On 2015-03-30 17:30, Stefan Lippers-Hollmann wrote:
>> > This is a follow-up for:
>> > 	http://lkml.kernel.org/r/<201412181916.18051.s.L-H@gmx.de>
>> > 	http://lkml.kernel.org/r/<201412302211.40801.s.L-H@gmx.de>
>> 
>> I can't swear that it's the case but I'm guessing this might be fixed 
>> by
>> the patches I posted earlier (in particular the one that converted
>> rc-core to use the IDA infrastructure for keeping track of registered
>> minor device numbers).
> 
> Do you have a pointer to that patch (-queue) or a tree containing it?
> So far I've only found https://patchwork.linuxtv.org/patch/23370/
> with those keywords, respectively the thread at
> http://comments.gmane.org/gmane.linux.drivers.video-input-infrastructure/76514
> which seems to be partially applied, anything I could test (reproducing
> the problem takes its time, probably 4-10 weeks to be really sure, but
> I'd be happy to try or forward port the required parts).

Hi,

I can try providing you with an updated version of the patch when I have 
time...otherwise I think you've found all that can be found :)

//David

