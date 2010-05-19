Return-path: <linux-media-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.153]:37296 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751041Ab0ESN0K convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 19 May 2010 09:26:10 -0400
Received: by fg-out-1718.google.com with SMTP id 22so1595341fge.1
        for <linux-media@vger.kernel.org>; Wed, 19 May 2010 06:26:08 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.01.1005181606440.29367@ureoreg>
References: <4BF290A2.1020904@free.fr>
	 <alpine.DEB.2.01.1005181606440.29367@ureoreg>
Date: Wed, 19 May 2010 15:21:04 +0200
Message-ID: <AANLkTik5wlOKoeXBQvMBF3bJ1exvTwenU5KE58seUzHz@mail.gmail.com>
Subject: Re: [linux-dvb] new DVB-T initial tuning for fr-nantes
From: Christoph Pfister <christophpfister@gmail.com>
To: linux-media@vger.kernel.org
Cc: matpic <matpic@free.fr>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

2010/5/18 BOUWSMA Barry <freebeer.bouwsma@gmail.com>:
> On wto (wtorek) 18.maj (maj) 2010, 15:05:00, matpic wrote:
>
> Salut!
>
>> hello
>> As from today (18/05/2010) there is new frequency since analogic signal
>> is stopped and is now only numeric.
>> guard-interval has to be set to AUTO or scan find anything
>>  (1/32, 1/16, 1/8 ,1/4 doesn't work)

Strange. Maybe a different parameter is wrong? (AUTO for one parameter
may cause that other parameters are implicitly set to AUTO as well).

> I do not have the CSA data at hand, but I understand that
> presently use is made of single transmitter sites, in a MFN
> (Multi-Frequency Network) and thus a guard interval of 1/32 should
> be correct.
>
> (I understand though that some filler transmitters may be in
> planning so that a small SFN may be put in service, but I am
> not clear as to these details...  I must research this.)

Ok, I've committed it with 1/32 (for now) :-)

>> #same frequency + offset 167000000 for some hardware DVB-T tuner
<snip>

answered by hftom.

> Merci, for reporting this change!
>
> barry bouwsma

Thanks,

Christoph
