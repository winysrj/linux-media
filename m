Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail14.opentransfer.com ([76.162.254.14])
	by www.linuxtv.org with smtp (Exim 4.63)
	(envelope-from <dcoates@systemoverload.net>) id 1KkQCo-0000fm-RC
	for linux-dvb@linuxtv.org; Mon, 29 Sep 2008 23:23:00 +0200
Message-ID: <48E1470F.6000207@systemoverload.net>
Date: Mon, 29 Sep 2008 16:22:23 -0500
From: Dustin Coates <dcoates@systemoverload.net>
MIME-Version: 1.0
To: Steven Toth <stoth@linuxtv.org>
References: <000001c91f6f$e23ab920$a6b02b60$@net>
	<000001c921f0$7d4aede0$77e0c9a0$@net>
	<48E11A2F.5030901@linuxtv.org> <48E130EB.20006@systemoverload.net>
	<48E135F0.60808@systemoverload.net> <48E14224.6090309@linuxtv.org>
In-Reply-To: <48E14224.6090309@linuxtv.org>
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

Steven Toth wrote:
> Dustin Coates wrote:
>> Dustin Coates wrote:
>>> Steven Toth wrote:
>>>  =

>>>> Dustin Coates wrote:
>>>>   =

>>>>>  =

>>>>>
>>>>>  =

>>>>>
>>>>> *From:* linux-dvb-bounces@linuxtv.org =

>>>>> [mailto:linux-dvb-bounces@linuxtv.org] *On Behalf Of *Dustin Coates
>>>>> *Sent:* Thursday, September 25, 2008 7:36 PM
>>>>> *To:* linux-dvb@linuxtv.org
>>>>> *Subject:* [linux-dvb] HVR-1800 Analouge Issues
>>>>>
>>>>>  =

>>>>>
>>>>> Hi Everyone,
>>>>>
>>>>>  =

>>>>>
>>>>>                 Ok I=92ve recently decided to start seeing if I can =

>>>>> figure out the issue with the Analouge, on this card, first my =

>>>>> normal dmesg.
>>>>>       =

>>>> The analog encoder works fine for me.
>>>>
>>>> In my case the basic analog tuner is usually /dev/video0 and the =

>>>> encoder is video1.
>>>>
>>>> Launch tvtime (which opens video0) tune and everything is fine, =

>>>> then cat /dev/video1 >test.mpg is working as expected.
>>>>
>>>> - Steve
>>>>
>>>>
>>>>     =

>>> Ok, TVTime works, still some static on a mostly the lower, and higher
>>> channels.
>>>
>>> Mythtv is only showing a green screen.
>>>
>>>
>>> _______________________________________________
>>> linux-dvb mailing list
>>> linux-dvb@linuxtv.org
>>> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
>>>   =

>> Mythbackend.log is showing these errors.
>>
>> VIDIOCGCHAN: Invalid argument
>> VIDIOCMCAPTUREi0: Invalid argument
>> VIDIOCMCAPTUREi1: Invalid argument
>> VIDIOCMCAPTURE0: Invalid argument
>> VIDIOCMCAPTURE1: Invalid argument
>>
>>
>> I think if i can get past these errors it might just work...
>
> When tvtime was running can you try cat /dev/video1 >test.mpg as I =

> suggested?
>
> - Steve
OK, when i load tvtime as tvtime --device=3D/dev/video1

I get the an error.

Videoinput: Driver refuses to set norm: Invalid argument

When i load tvtime as /dev/video0

I get a picture, but it's interlaced with a lot of static

Then when i try to cat /dev/video0 i get a Device or resource busy

cat /dev/video1, no errors . I play the file, and i get static, barley =

see picture, i can hear audio though.

Uploaded the video file to: (only 14MB) http://systemoverload.net/test.mpg

When  i set it up in mythtv i set it up as an analogue card.

Setting it to /dev/video1 gives me these errors in mythbackend.log.

2008-09-29 16:15:40.761 Channel(/dev/video1) Error: SetInputAndFormat(2, =

NTSC)
            while setting format (v4l v2)
            eno: Invalid argument (22)
2008-09-29 16:15:40.763 Channel(/dev/video1) Error: SetInputAndFormat(2, =

NTSC)
            while setting format (v4l v2)
            eno: Invalid argument (22)
2008-09-29 16:15:40.764 Channel(/dev/video1) Error: SetInputAndFormat(2, =

ATSC)
            while setting format (v4l v2)
            eno: Invalid argument (22)
2008-09-29 16:15:40.765 Channel(/dev/video1): SetInputAndFormat() failed
2008-09-29 16:15:40.765 TVRec(2) Error: Failed to set channel to 2.
2008-09-29 16:15:40.787 TVRec(2) Error: GetProgramRingBufferForLiveTV()
            ProgramInfo is invalid.
ProgramInfo: channame() startts(Mon Sep 29 16:15:40 2008) endts(Mon Sep =

29 16:15:40 2008)
             recstartts(Mon Sep 29 16:15:40 2008) recendts(Mon Sep 29 =

16:15:40 2008)
             title()
VIDIOCGMBUF:: Invalid argument
2008-09-29 16:15:41.849 AutoExpire: CalcParams(): Max required Free =

Space: 2.0 GB w/freq: 15 min
2008-09-29 16:16:21.869 TVRec(2): Changing from WatchingLiveTV to None
2008-09-29 16:16:21.888 Finished recording : channel 4294967295
2008-09-29 16:16:21.892 scheduler: Finished recording: : channel 4294967295

Setting it to /dev/video0 gives me the errors posted in my last email.


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
