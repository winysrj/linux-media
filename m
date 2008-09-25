Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Message-ID: <48DB99C5.3090704@gmail.com>
Date: Thu, 25 Sep 2008 18:01:41 +0400
From: Manu Abraham <abraham.manu@gmail.com>
MIME-Version: 1.0
To: VDR Mailing List <vdr@linuxtv.org>
References: <200809241922.16748@orion.escape-edv.de>	<1222306125.3323.80.camel@pc10.localdom.local>	<200809251254.59680@orion.escape-edv.de>
	<20080925122857.GA7282@halim.local>
In-Reply-To: <20080925122857.GA7282@halim.local>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] [vdr] [v4l-dvb-maintainer] [Wanted]
	dvb-ttpci	maintainer
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

Halim Sahin wrote:
> Hi,
> On Do, Sep 25, 2008 at 12:54:58 +0200, Oliver Endriss wrote:
>> There are basic democratic rules which must be followed in a community:
>>
>> (1) Make a proposal
> 
> Yes We have multiproto, since 2006.
> 
> 
>> (2) Discuss the proposal
> 
> Was done since 2006
> 
>> (3) Finally, _after_ the discussion: A poll to find a decision.
> 
> Great thing. Why was multiproto not merged after your code review
> november 2007????
> 
> I thing Manu wanted to do the s2 stuff himself and did not  accept 
> any community help.

http://lwn.net/Articles/297301/

API and core related patches: 31 + 1 patches, total 32 in all.

http://www.kernel.org/pub/linux/kernel/people/manu/dvb_patches/

The people who contributed some way or the other (in the final stages):
on the API changes alone. (Not mentioning about the people who initially
provided many comments.)

Marco Schluessler <marco@lordzodiac.de>
Arvo Jarve <arvo@softshark.ee>
Reinhard Nissl <rnissl@gmx.de>
Oliver Endriss <o.endriss@gmx.de>
Anssi Hannula <anssi.hannula@gmail.com>

These folks on a whole, contributed to ~14 of the patches.

> Yes I read most of the old mails from last year.
> In most cases Manu wrote that multiproto is not ready.
> The fact is, that many people are using (not ready multiproto stuff) 
> since two years.

After the code review, it was left for testing. Thanks to the VDR
community/Klaus for providing support for the same, so it could be
tested in real life.

As you can see quite some of the changes came during the test phase, as
you can see from the timestamps in the multiproto tree.


Regards,
Manu


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
