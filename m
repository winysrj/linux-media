Return-path: <linux-media-owner@vger.kernel.org>
Received: from 12.mo1.mail-out.ovh.net ([87.98.162.229]:42990 "EHLO
	mo1.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751317Ab3FDPuf (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 4 Jun 2013 11:50:35 -0400
Received: from mail405.ha.ovh.net (b6.ovh.net [213.186.33.56])
	by mo1.mail-out.ovh.net (Postfix) with SMTP id 85817FF9952
	for <linux-media@vger.kernel.org>; Tue,  4 Jun 2013 16:34:15 +0200 (CEST)
Message-ID: <51ADFACB.9080504@ventoso.org>
Date: Tue, 04 Jun 2013 16:33:47 +0200
From: Luca Olivetti <luca@ventoso.org>
MIME-Version: 1.0
To: Patrick Boettcher <pboettcher@kernellabs.com>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: Diversity support?
References: <507EE702.2010103@ventoso.org> <5091691A.4070903@ventoso.org> <51ACB2CA.6060503@ventoso.org> <4964507.arsPbG4Yym@dibcom294>
In-Reply-To: <4964507.arsPbG4Yym@dibcom294>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Al 04/06/13 13:23, En/na Patrick Boettcher ha escrit:
> On Monday 03 June 2013 17:14:18 Luca Olivetti wrote:
>>>> So, what's the real status of diversity support?
>>>
>>> Nobody knows?
>>
>> I'm not easily discouraged :-) so here's the question again: is there
>> some dvb-t usb stick (possibly available on the EU market) with
>> diversity support under Linux?
> 
> There is some diversity support hidden in the dib8000-driver and in some 
> board-drivers which use it. Basically it creates several instances of the 
> dib8000-driver (one for each demod) but it exposes only one dvb-frontend to 
> userspace via the API. When the user is tuning the frontend he is, in fact, 
> tuning all of them in diversity.

Mmmh, but, according to the comment, the dib8000 is isdb-t, I'm looking
for a dvb-t device.
My idea is to do something like this

http://www.youtube.com/watch?v=STjQBE3BIYM

but using a raspberry pi instead of a windows pc.
Unfortunately, the terratec uses the dib0070 (as do most other usb
sticks with diversity), I see some fields for diversity in dib0070.[hc],
but every report I see it says that it just exposes two frontends and it
doesn't support diversity.
Of course I can buy a ready-made car tuner, but what's the fun in that? ;-)


Bye
-- 
Luca
