Return-path: <linux-media-owner@vger.kernel.org>
Received: from rouge.crans.org ([138.231.136.3]:42928 "EHLO rouge.crans.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754613Ab1HJWBE (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 10 Aug 2011 18:01:04 -0400
Message-ID: <4E42FD4F.8070904@crans.ens-cachan.fr>
Date: Wed, 10 Aug 2011 23:51:11 +0200
From: DUBOST Brice <dubost@crans.ens-cachan.fr>
MIME-Version: 1.0
To: Nima Mohammadi <nima.irt@gmail.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: Structure of DiSEqC Command
References: <CAPpMX7Sw5bO8fiYq+u_Zdv8BBsS6qahQ0Rw+_CjD+ikXH5-w3g@mail.gmail.com>
In-Reply-To: <CAPpMX7Sw5bO8fiYq+u_Zdv8BBsS6qahQ0Rw+_CjD+ikXH5-w3g@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 08/08/2011 19:06, Nima Mohammadi wrote:
> Hi folks,
> I was reading the source code of various dvb related utilities and I
> was wondering about forming up the message which instructs the DiSEqC
> switch. But I found out that different programs produce the command
> differently.
> The confusing thing is that according to the DiSEqC specification
> documents that I've read, the least significant bit (lsb) must
> indicate the band (low/high), not the polarity (ver/hor), but as you
> see it only applies to some of these programs:
> 
> getstrean abd dvbstream:
> int i = 4 * switch_pos + 2 * hiband + (voltage_18 ? 1 : 0);
> 
> szap and mplayer:
> (((sat_no * 4) & 0x0f) | (hi_lo ? 1 : 0) | (polv ? 0 : 2));
> 
> scan:
> 4 * switch_pos + 2 * hiband + (voltage_18 ? 1 : 0)
> 
> gstdvbsrc:
> (((sat_no * 4) & 0x0f) | (tone == SEC_TONE_ON ? 1 : 0) | (voltage ==
> SEC_VOLTAGE_13 ? 0 : 2));
> 
> 


Hello

I'm the upstream author of MuMuDVB (http://mumudvb.braice.net)

The diseqc related code is here
http://gitweb.braice.net/gitweb?p=mumudvb;a=blob;f=src/tune.c

On the document

http://www.eutelsat.com/satellites/pdf/Diseqc/associated%20docs/applic_info_LNB_switchers.pdf

Page 7 (page 10 of the PDF) the band is the LSB and the table
is organized in increasing binary data

But in
http://www.eutelsat.com/satellites/pdf/Diseqc/associated%20docs/update_recomm_for_implim.pdf

page 33 (35 in the PDF)

The LSB SEEMS to be the polarization, but it's still the band, the table
is just organized in a strange way

If you look deeply into the code of scan
 http://www.linuxtv.org/hg/dvb-apps/file/36a084aace47/util/scan/diseqc.c

You'll see that the table is organized as in the second document and the
code addresses the table for making the message but there is no mistake
in the real data since it's f0,f2,f1 etc ...

So the difference is if the diseqc data is wrote directly (as in
MuMuDVB) or taken from a table organised as in the specification (as in
scan)

Hope it's clear and it helps

Regards

-- 
Brice

A: Yes.
>Q: Are you sure?
>>A: Because it reverses the logical flow of conversation.
>>>Q: Why is top posting annoying in email?
