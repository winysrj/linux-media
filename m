Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:41568 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751689Ab1KKLg4 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 11 Nov 2011 06:36:56 -0500
Message-ID: <4EBD08D0.6030701@iki.fi>
Date: Fri, 11 Nov 2011 13:36:48 +0200
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Patrick Boettcher <pboettcher@kernellabs.com>
CC: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Manu Abraham <abraham.manu@gmail.com>,
	Andreas Oberritter <obi@linuxtv.org>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Steven Toth <stoth@kernellabs.com>
Subject: Re: FE_CAN-bits
References: <CAHFNz9Lf8CXb2pqmO0669VV2HAqxCpM9mmL9kU=jM19oNp0dbg@mail.gmail.com> <CAHFNz9JNLAFnjd14dviJJDKcN3cxgB+MFrZ72c1MVXPLDsuT0Q@mail.gmail.com> <4EBC402E.20208@redhat.com> <201111111055.12496.pboettcher@kernellabs.com>
In-Reply-To: <201111111055.12496.pboettcher@kernellabs.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 11/11/2011 11:55 AM, Patrick Boettcher wrote:
> On Thursday, November 10, 2011 10:20:46 PM Mauro Carvalho Chehab wrote:
>>
>> We should also think on a way to enumerate the supported values for each
>> DVB properties, the enum fe_caps is not enough anymore to store
>> everything. It currently has 30 bits filled (of a total of 32 bits), and
>> we currently have:
>> 	12 code rates (including AUTO/NONE);
>> 	13 modulation types;
>> 	7 transmission modes;
>> 	7 bandwidths;
>> 	8 guard intervals (including AUTO);
>> 	5 hierarchy names;
>> 	4 rolloff's (probably, we'll need to add 2 more, to distinguish between
>> DVB-C Annex A and Annex C).
>>
>> So, if we would need to add one CAN_foo for each of the above, we would
>> need 56 to 58 bits, plus 5-6 bits to the other capabilities that
>> currently exists there. So, even 64 bits won't be enough for the current
>> needs (even having the delivery system caps addressed by something
>> else).
>
> IMHO, we don't need such a fine FE_CAN_-bit distinguishing for most
> standards. A well defined sub-standard definition is sufficient, which can be
> handled with a delivery-system-like query as proposed in the original patch.
> This also will be much simpler for most user-space applications and users.

I agree that. Those are totally useless in general. Let driver return 
error to userspace if it cannot handle.

> DVB-T means:
> - 8K or 2K,
> - 1/4-1/32 Guard,
> - 1/2, 2/3, 3/4, 5/6 and 7/8 coderate,
> - QPSK, 64QAM or 16QAM
>
> DVB-H (RIP as Remi wrote somewhere) would have meant:
> - DVB-T + 4K + in-depth-interleaver mode
>
> The same applies to ISDB-T and ISDB-T 1seg. And for CMMB, CTTB, DVB-SH.
>
> If there are demods which can't do one particular thing, we should forget
> about them. At least this is what almost all applications I have seen so far
> are doing implicitly.

I know only one case where device cannot support all standard 
parameters. It is one TDA10023 device and looks like stream goes too 
wide when QAM256 is used.

> Though, I see at least one inconvenience is if someone is using linux-dvb
> for developping dsp-software and wants to deliver things which aren't done.
> But is this a case we want to "support" within the official API.


regards
Antti


-- 
http://palosaari.fi/
