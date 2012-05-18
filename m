Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:33471 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759488Ab2ERUlX (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 18 May 2012 16:41:23 -0400
Message-ID: <4FB6B3F1.2010300@iki.fi>
Date: Fri, 18 May 2012 23:41:21 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Niklas Brunlid <prefect47@gmail.com>
CC: linux-media <linux-media@vger.kernel.org>
Subject: Re: PCTV 290e with DVB-C on Fedora 16?
References: <CABXDEG=PgB9bYUBN8XTPipEz1QJ__t4O8xTNH8kbfnD+fqhOgg@mail.gmail.com> <4FB64833.2040206@iki.fi> <CABXDEGm4Ret0x1oWdA2Mmzhf2z8ry3CE9B8rJvg6G_HM5+h4sA@mail.gmail.com>
In-Reply-To: <CABXDEGm4Ret0x1oWdA2Mmzhf2z8ry3CE9B8rJvg6G_HM5+h4sA@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 18.05.2012 23:27, Niklas Brunlid wrote:
> On 18 May 2012 15:01, Antti Palosaari<crope@iki.fi>  wrote:
>> On 18.05.2012 11:38, Niklas Brunlid wrote:
>>
>> That whole issues is related of MFE (multi-frontend) =>  SFE
>> (single-frontend) change.
>
> Yes, that I have understood. But from the threads on the MythTV lists
> below, it seems at least one user has one or more 290e sticks running
> fine in DVB-T (or T2) mode. Although that was on Ubuntu IIRC.

>> w_scan works? At least for me.
>
> It was some time since I actually ran it. I'll have to try again
> tomorrow as the backend is currently recording, and MythTV seems to
> tie up the device even though it is not connected with any input in
> mythtvsetup...

>>> 2012-05-13 17:25:32.385665 E  FE_GET_INFO ioctl failed
>>> (/dev/dvb/adapter0/frontend0)
>>>    eno: No such device (19)
>>
>>
>> I looked frontend code and I do not see where that error is coming.
>> Maybe there is no such file at all?
>
> The file is there, as seen in the ls output I posted. And dvb-fe-tool
> complains when mythbackend is running:


> The system also has a Hauppauhe PVR350 and a Hauppage Nova-T 500, in
> case that's relevant. The Nova works fine, although the reception is
> poor (70%) which is why I got the 290e for DVB-C. :)
>
> BTW, I see firmware being loaded for the Hauppauge devices. Is the
> same needed for the PCTV 290e?

No firmware needed for that device. All used chips are firmware "free".

DVB-C is not officially supported by that device but it seems to work 
rather well. Biggest problem is hard coded LNA but I think I am going to 
resolve LNA and GPIO issues later this summer when enhancing DVB-CORE 
frontend issues. My plan is to add internal API, GPIO callbacks for the 
demod and tuner in order to allow use of LNA etc. And of course some 
param to API which sets LNA AUTO/ON/OFF, maybe numeric value for gain also?

regards
Antti
-- 
http://palosaari.fi/
