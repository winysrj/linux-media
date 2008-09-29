Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mta4.srv.hcvlny.cv.net ([167.206.4.199])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <stoth@linuxtv.org>) id 1KkPsX-0007rk-9w
	for linux-dvb@linuxtv.org; Mon, 29 Sep 2008 23:02:02 +0200
Received: from steven-toths-macbook-pro.local
	(ool-18bfe594.dyn.optonline.net [24.191.229.148]) by
	mta4.srv.hcvlny.cv.net
	(Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
	with ESMTP id <0K7Z005C36EDR8N0@mta4.srv.hcvlny.cv.net> for
	linux-dvb@linuxtv.org; Mon, 29 Sep 2008 17:01:27 -0400 (EDT)
Date: Mon, 29 Sep 2008 17:01:24 -0400
From: Steven Toth <stoth@linuxtv.org>
In-reply-to: <48E135F0.60808@systemoverload.net>
To: Dustin Coates <dcoates@systemoverload.net>
Message-id: <48E14224.6090309@linuxtv.org>
MIME-version: 1.0
References: <000001c91f6f$e23ab920$a6b02b60$@net>
	<000001c921f0$7d4aede0$77e0c9a0$@net> <48E11A2F.5030901@linuxtv.org>
	<48E130EB.20006@systemoverload.net> <48E135F0.60808@systemoverload.net>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] HVR-1800 Analouge Issues
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: quoted-printable
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

Dustin Coates wrote:
> Dustin Coates wrote:
>> Steven Toth wrote:
>>  =

>>> Dustin Coates wrote:
>>>    =

>>>>  =

>>>>
>>>>  =

>>>>
>>>> *From:* linux-dvb-bounces@linuxtv.org =

>>>> [mailto:linux-dvb-bounces@linuxtv.org] *On Behalf Of *Dustin Coates
>>>> *Sent:* Thursday, September 25, 2008 7:36 PM
>>>> *To:* linux-dvb@linuxtv.org
>>>> *Subject:* [linux-dvb] HVR-1800 Analouge Issues
>>>>
>>>>  =

>>>>
>>>> Hi Everyone,
>>>>
>>>>  =

>>>>
>>>>                 Ok I=92ve recently decided to start seeing if I can =

>>>> figure out the issue with the Analouge, on this card, first my =

>>>> normal dmesg.
>>>>       =

>>> The analog encoder works fine for me.
>>>
>>> In my case the basic analog tuner is usually /dev/video0 and the =

>>> encoder is video1.
>>>
>>> Launch tvtime (which opens video0) tune and everything is fine, then =

>>> cat /dev/video1 >test.mpg is working as expected.
>>>
>>> - Steve
>>>
>>>
>>>     =

>> Ok, TVTime works, still some static on a mostly the lower, and higher
>> channels.
>>
>> Mythtv is only showing a green screen.
>>
>>
>> _______________________________________________
>> linux-dvb mailing list
>> linux-dvb@linuxtv.org
>> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
>>   =

> Mythbackend.log is showing these errors.
> =

> VIDIOCGCHAN: Invalid argument
> VIDIOCMCAPTUREi0: Invalid argument
> VIDIOCMCAPTUREi1: Invalid argument
> VIDIOCMCAPTURE0: Invalid argument
> VIDIOCMCAPTURE1: Invalid argument
> =

> =

> I think if i can get past these errors it might just work...

When tvtime was running can you try cat /dev/video1 >test.mpg as I =

suggested?

- Steve


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
