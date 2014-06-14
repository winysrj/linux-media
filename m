Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:43469 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750852AbaFNXUG (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 14 Jun 2014 19:20:06 -0400
Message-ID: <539CD8A1.7020307@iki.fi>
Date: Sun, 15 Jun 2014 02:20:01 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <m.chehab@samsung.com>
CC: =?ISO-8859-1?Q?Frank_Sch=E4fer?= <fschaefer.oss@googlemail.com>,
	LMML <linux-media@vger.kernel.org>
Subject: Re: em28xx submit of urb 0 failed (error=-27)
References: <5398F2ED.4080309@iki.fi> <5398F646.70102@iki.fi> <20140614094504.6b5695f4.m.chehab@samsung.com>
In-Reply-To: <20140614094504.6b5695f4.m.chehab@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 06/14/2014 03:45 PM, Mauro Carvalho Chehab wrote:
> Em Thu, 12 Jun 2014 03:37:26 +0300
> Antti Palosaari <crope@iki.fi> escreveu:
>
>> I just ran blind scan using w_scan and it interrupted scanning, with
>> following error (ioctl DMX_SET_FILTER failed: 27 File too large).
>>
>> 602000: (time: 00:58.973)
>>           (0.308sec): SCL (0x1F)
>>           (0.308sec) signal
>>           (0.308sec) lock
>>           signal ok:	QAM_AUTO f = 602000 kHz I999B8C999D999T999G999Y999
>> (0:0:0)
>>           initial PAT lookup..
>> start_filter:1644: ERROR: ioctl DMX_SET_FILTER failed: 27 File too large
>>
>> regards
>> Antti
>>
>>
>> On 06/12/2014 03:23 AM, Antti Palosaari wrote:
>>> Do you have any idea about that bug?
>>> kernel: submit of urb 0 failed (error=-27)
>>>
>>> https://bugzilla.kernel.org/show_bug.cgi?id=72891
>>>
>>> I have seen it recently very often when I try start streaming DVB. When
>>> it happens, device is unusable. I have feeling that it could be coming
>>> from recent 28xx big changes where it was modularised. IIRC I reported
>>> that at the time and Mauro added error number printing to log entry.
>>> Anyhow, it is very annoying and occurs very often. And people have
>>> started pinging me as I have added very many DVB devices to em28xx.
>
> Well, according with USB documentation (Documentation/usb/URB.txt),
> EFBIG means:
> - Too many requested ISO frames
>
> Perhaps the logic that calculates the number of URBs has a bug. In
> the past, the URB size was hardcoded. Nowadays, em28xx dynamically
> calculate it based on the USB descriptors, and the endpoints found.
>
>  From what I know, different versions of em28xx chips have different
> max limits. We need to identify on what chip version this error is
> occurring, and reduce the number of ISOC frames there (with will
> reduce the max bandwidth supported by such chip).

I tested these as having that issue:
em28178 PCTV tripleStick (292e)
em2874 MaxMedia UB425-TC
em2884 PCTV QuatroStick nano (520e)

Bug report mentions also:
em28174 PCTV nanoStick T2 (290e)
em28178 PCTV DVB-S2 Stick (461e)

So it must effect huge amount (if not all) of different em28xx chips 
used for DTV.


regards
Antti

-- 
http://palosaari.fi/
