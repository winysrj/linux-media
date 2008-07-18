Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m6INIMDw005810
	for <video4linux-list@redhat.com>; Fri, 18 Jul 2008 19:18:22 -0400
Received: from nlpi025.prodigy.net (nlpi025.sbcis.sbc.com [207.115.36.54])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m6INI9Du002902
	for <video4linux-list@redhat.com>; Fri, 18 Jul 2008 19:18:09 -0400
Message-ID: <48812475.1040507@xnet.com>
Date: Fri, 18 Jul 2008 18:17:09 -0500
From: stuart <stuart@xnet.com>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
References: <4880694A.3060002@iinet.net.au>	<200807181201.22000.hverkuil@xs4all.nl>
	<48806AA6.8050700@hhs.nl> <200807181210.22731.hverkuil@xs4all.nl>
In-Reply-To: <200807181210.22731.hverkuil@xs4all.nl>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: video4linux-list@redhat.com, linux-dvb@linuxtv.org, mchehab@infradead.org
Subject: Re: problem with latest v4l-dvb hg - videodev
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>



Hans Verkuil wrote:
> On Friday 18 July 2008 12:04:22 Hans de Goede wrote:
>> Hans Verkuil wrote:
>>> On Friday 18 July 2008 11:58:34 Tim Farrington wrote:
>>>> Hi Mauro, Hans,
>>>>
>>>> I've just attempted a new install of ubuntu, then downloaded via
>>>> hg the current v4l-dvb,
>>>> and installed it.
>>>>
>>>> Upon reboot, the boot stalled just after loading the firmware at
>>>> something about incorrect
>>>> videodev count.
>>>>
>>>> It would not boot any further, and I was unable to save the dmesg
>>>> to a file (read only access)
>>>>
>>>> I've had to reinstall ubuntu to be able to send this message.
>>>>
>>>> Regards,
>>>> Timf
>>> Hi Tim,
>>>
>>> Yes, I discovered the same. A fix is in my tree
>>> (www.linuxtv.org/hg/~hverkuil/v4l-dvb) waiting for Mauro to merge.
>>>
>>> Regards,
>>>
>>> 	Hans
>> Erm,
>>
>> It would have been nice if you would have sent an announcement of
>> that fix and/or atleast CC-ed v4l-dvb-maintainer@linuxtv.org, so that
>> other v4l-dvb developers knew about this, I just spend an hour
>> figuring out what was hapening and fixing this.
>>
>> Regards,
>>
>> Hans
> 
> Well, I did. The pull request on the v4l-dvb-maintainers list was posted 
> 2 1/2 hours before yours. But I probably should have made the subject 
> more clear, it was just my normal PULL request subject instead of 
> marking it as especially important.
> 
> My apologies for that.
> 
> Regards,
> 
> 	Hans
> 

Just wanted to say thanks...

I just noticed the problem yesterday (my mythtv box would boot) and just 
did an Hg update/make/install and found the problem fixed.

...thanks

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
