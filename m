Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m6IA5J5g020278
	for <video4linux-list@redhat.com>; Fri, 18 Jul 2008 06:05:19 -0400
Received: from frosty.hhs.nl (frosty.hhs.nl [145.52.2.15])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m6IA56uG011779
	for <video4linux-list@redhat.com>; Fri, 18 Jul 2008 06:05:06 -0400
Received: from exim (helo=frosty) by frosty.hhs.nl with local-smtp (Exim 4.62)
	(envelope-from <j.w.r.degoede@hhs.nl>) id 1KJmpl-0001KJ-D3
	for video4linux-list@redhat.com; Fri, 18 Jul 2008 12:05:05 +0200
Message-ID: <48806AA6.8050700@hhs.nl>
Date: Fri, 18 Jul 2008 12:04:22 +0200
From: Hans de Goede <j.w.r.degoede@hhs.nl>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
References: <4880694A.3060002@iinet.net.au>
	<200807181201.22000.hverkuil@xs4all.nl>
In-Reply-To: <200807181201.22000.hverkuil@xs4all.nl>
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
> On Friday 18 July 2008 11:58:34 Tim Farrington wrote:
>> Hi Mauro, Hans,
>>
>> I've just attempted a new install of ubuntu, then downloaded via hg
>> the current v4l-dvb,
>> and installed it.
>>
>> Upon reboot, the boot stalled just after loading the firmware at
>> something about incorrect
>> videodev count.
>>
>> It would not boot any further, and I was unable to save the dmesg to
>> a file (read only access)
>>
>> I've had to reinstall ubuntu to be able to send this message.
>>
>> Regards,
>> Timf
> 
> 
> Hi Tim,
> 
> Yes, I discovered the same. A fix is in my tree 
> (www.linuxtv.org/hg/~hverkuil/v4l-dvb) waiting for Mauro to merge.
> 
> Regards,
> 
> 	Hans
> 

Erm,

It would have been nice if you would have sent an announcement of that fix 
and/or atleast CC-ed v4l-dvb-maintainer@linuxtv.org, so that other v4l-dvb 
developers knew about this, I just spend an hour figuring out what was hapening 
and fixing this.

Regards,

Hans

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
