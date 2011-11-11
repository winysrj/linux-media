Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:47124 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754007Ab1KKTEk (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 11 Nov 2011 14:04:40 -0500
Message-ID: <4EBD6B61.7020605@redhat.com>
Date: Fri, 11 Nov 2011 16:37:21 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: BOUWSMA Barry <freebeer.bouwsma@gmail.com>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: PATCH: Query DVB frontend capabilities
References: <CAHFNz9Lf8CXb2pqmO0669VV2HAqxCpM9mmL9kU=jM19oNp0dbg@mail.gmail.com> <4EBBE336.8050501@linuxtv.org> <CAHFNz9JNLAFnjd14dviJJDKcN3cxgB+MFrZ72c1MVXPLDsuT0Q@mail.gmail.com> <4EBC402E.20208@redhat.com> <alpine.DEB.2.01.1111111759060.6676@localhost.localdomain>
In-Reply-To: <alpine.DEB.2.01.1111111759060.6676@localhost.localdomain>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 11-11-2011 15:43, BOUWSMA Barry escreveu:
> 
> On Do (Donnerstag) 10.Nov (November) 2011, 22:20,  Mauro Carvalho Chehab wrote:
> 
>> We should also think on a way to enumerate the supported values for each DVB $
>> the enum fe_caps is not enough anymore to store everything. It currently has $
>> filled (of a total of 32 bits), and we currently have:
>> 	12 code rates (including AUTO/NONE);
> 
> I'm probably not looking at the correct source, but the numbers
> seem to match, so I'll just note that in what I'm looking at,
> there are missing the values  1/3  and  2/5 .

Those were not added yet, as no driver currently uses it.

> 
> But I have to apologise in that I've also not been paying
> attention to this conversation, and haven't even been trying
> to follow recent developments.
> 
> 
>> 	13 modulation types;
> 
> Here I see missing  QAM1024  and  QAM4096 .

Same here.

> 
> 
>> 	7 transmission modes;
>> 	7 bandwidths;
> 
> Apparently DVB-C2 allows us any bandwidth from 8MHz to 450MHz,
> rather than the discrete values used by the other systems.
> If this is also applicable to other countries with 6MHz rasters,
> would it be necessary in addition to specify carrier spacing,
> either 2,232kHz or 1,674kHz as opposed to getting this from the
> channel bandwidth?

There are 3 parameters for Satellite and Cable systems:
	- Roll off factor;
	- Symbol Rate;
	- Bandwidth.

Only two of the tree are independent, as the spec defines:
	Bandwidth = symbol rate * (1  + roll off).

For DVB-C Annex A and C, roll off is fixed (0.15 and 0.13, respectively).

ITU-T J 83 Annex B doesn't say anything about it, but the ANSI SCTE07 spec
says that the roll-off is approx. 0.18 for 256-QAM and approx. 0.12 for
256-QAM.

DVB-S also has a fixed roll-off of 0.35, while DVB-S2 allows configuring it.

Not 100% sure, but ISDB-S also seems to use a per-modulation roll-off factor.

Anyway, when the roll-off is known, only symbol rate is needed, in order
to know the needed bandwidth.

IMHO, we should add some function inside the DVB core to calculate the
bandwidth for DVB-C (and DVB-C2), as the tuner saw filters require it,
in order to filter spurious frequencies from adjacent channels. Some
demods may also need such info.

The DVBv5 API doesn't impose any step for the carrier value, as it is
specified in Hz. So, I don't think that any change would be needed at 
the userspace API, in order to support DVB-C2 "continuous" carrier spacing.

> 
> 
>> 	8 guard intervals (including AUTO);
> 
> Here I observe the absence of  1/64 .

Same here: currently, no driver implements it.

> 
> 
>> 	5 hierarchy names;
>> 	4 rolloff's (probably, we'll need to add 2 more, to distinguish between$
> 
> 
> Of course, I'm just pointing out what I find, as I really don't
> know anything about the transport systems, and someone who 
> actually does might be able to say more, and correct my errors.
> 
> So just ignore me -- I'd rather see these values added sooner
> than later if needed.  Apparently the broadcasts from Borups
> Allé scheduled to start sometime around now will be switching
> over to use those mentioned to test their increased robustness.

Implementing those parameters is not a matter of just adding new stuff at
the core. Developers need DVB-C2 capable hardware, and access to a broadcaster
using it (or access to some testing facility where DVB-C2 could be
simulated).

Regards,
Mauro
