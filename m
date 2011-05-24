Return-path: <mchehab@pedra>
Received: from mail.kapsi.fi ([217.30.184.167]:58843 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756138Ab1EXNAW (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 24 May 2011 09:00:22 -0400
Message-ID: <4DDBABDE.5010908@iki.fi>
Date: Tue, 24 May 2011 16:00:14 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Devin Heitmueller <dheitmueller@kernellabs.com>
CC: Steve Kerrison <steve@stevekerrison.com>,
	=?ISO-8859-1?Q?R=E9mi_Den?= =?ISO-8859-1?Q?is-Courmont?=
	<remi@remlab.net>, linux-media@vger.kernel.org,
	vlc-devel@videolan.org
Subject: Re: dvb: one demux per tuner or one demux per demod?
References: <719f9c4d1bd57d5b2711bc24a9d5c3b1@chewa.net>	<1306238734.7397.102.camel@ares> <BANLkTinN1YWpEpxxMgoZ2hMTGt3eEv=peA@mail.gmail.com>
In-Reply-To: <BANLkTinN1YWpEpxxMgoZ2hMTGt3eEv=peA@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On 05/24/2011 03:28 PM, Devin Heitmueller wrote:
> 2011/5/24 Steve Kerrison<steve@stevekerrison.com>:
>> Hi Rémi,
>>
>> The cxd2820r supports DVB-T/T2 and also DVB-C. As such antti coded up a
>> multiple front end (MFE) implementation for em28xx then attaches the
>> cxd2820r in both modes.
>>
>> I believe you can only use one frontend at once per adapter (this is
>> certainly enforced in the cxd2820r module), so I don't see how it would
>> cause a problem for mappings. I think a dual tuner device would register
>> itself as two adapters, wouldn't it?
>>
>> But I'm new at this, so forgive me if I've overlooked something or
>> misunderstood the issue you've raised.
>
> Oh wow, is that what Antti did?  I didn't really give much thought but
> I can appreciate why he did it (the DVB 3.x API won't allow a single
> frontend to advertise support for DVB-C and DVB-T).

Yes I did, since I didn't know there is better way. Is there any other 
driver which implements it differently? I think all current MFE drivers 
does it like I did. For example look NetUP cx23885 + stv0367.

/dev/dvb/adapter0/
crw-rw----+ 1 root video 212, 2 May 24 15:51 demux0
crw-rw----+ 1 root video 212, 3 May 24 15:51 dvr0
crw-rw----+ 1 root video 212, 0 May 24 15:51 frontend0
crw-rw----+ 1 root video 212, 1 May 24 15:51 frontend1
crw-rw----+ 1 root video 212, 4 May 24 15:51 net0

> This is one of the big things that S2API fixes (through S2API you can
> specify the modulation that you want).  Do we really want to be
> advertising two frontends that point to the same demod, when they
> cannot be used in parallel?  This seems doomed to create problems with
> applications not knowing that they are in fact the same frontend.

I was in understanding it is MFE when there is multiple frontends in 
same adapter. In that case only one adapter can be used at time. I added 
lock to cxd2820r driver, which probably is in wrong place (I think it 
should be interface-driver or core which locks).

> I'm tempted to say that this patch should be scapped and we should
> simply say that you cannot use DVB-C on this device unless you are
> using S2API.  That would certainly be cleaner but it comes at the cost
> of DVB-C not working with tools that haven't been converted over to
> S2API yet.

reagrds,
Antti
-- 
http://palosaari.fi/
