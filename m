Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mAEFc9kH026876
	for <video4linux-list@redhat.com>; Fri, 14 Nov 2008 10:38:09 -0500
Received: from d1.scratchtelecom.com (69.42.52.179.scratchtelecom.com
	[69.42.52.179])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mAEFbtqq004363
	for <video4linux-list@redhat.com>; Fri, 14 Nov 2008 10:37:55 -0500
Received: from vegas (CPE00a02477ff82-CM001225d885d8.cpe.net.cable.rogers.com
	[99.249.154.65])
	by d1.scratchtelecom.com (8.13.8/8.13.8/Debian-3) with ESMTP id
	mAEFbt6H013628
	for <video4linux-list@redhat.com>; Fri, 14 Nov 2008 10:37:55 -0500
Received: from lawsonk (helo=localhost)
	by vegas with local-esmtp (Exim 3.36 #1 (Debian)) id 1L10k4-00066n-00
	for <video4linux-list@redhat.com>; Fri, 14 Nov 2008 10:37:52 -0500
Date: Fri, 14 Nov 2008 10:37:52 -0500 (EST)
From: Keith Lawson <lawsonk@lawson-tech.com>
To: video4linux-list@redhat.com
In-Reply-To: <d9def9db0811130440t17b05c58q603a14e446e417e5@mail.gmail.com>
Message-ID: <alpine.DEB.1.10.0811141033000.23321@vegas>
References: <491339D9.2010504@personnelware.com>
	<30353c3d0811061553h4c1a77e0t597bd394fa0ebdf1@mail.gmail.com>
	<4913E9DB.8040801@hhs.nl> <200811071050.25149.hverkuil@xs4all.nl>
	<20081107161956.c096dd03.ospite@studenti.unina.it>
	<alpine.DEB.1.10.0811071416380.25756@vegas>
	<alpine.DEB.1.10.0811130651170.2643@vegas>
	<d9def9db0811130440t17b05c58q603a14e446e417e5@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Subject: Re: USB Capture device
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



On Thu, 13 Nov 2008, Markus Rechberger wrote:
<snip>
> are you sure this device is tm6000 based? I just remember the same
> product package used for em2820 based devices.
>
> http://mcentral.de/wiki/index.php5/Em2880#Devices

It's a TM5600 device. I've been able to capture video from it 
using the tm5600/tm6000/tm6010 module from Mauro's mercurial repository
but I'm having an issue with green flickering a the top of the video, I'm 
not sure if that's a driver issue or an mplayer issue.

Are you aware of a em2820 based USB "dongle" device? I don't require a 
tuner, I'm just trying to capture input from S-video and composite (RCA).

>
> br,
> Markus
>
>> Thanks,
>> Keith.
>>
>> On Fri, 7 Nov 2008, Keith Lawson wrote:
>>
>>> Hello,
>>>
>>> Can anyone suggest a good USB catpure device that has S-Video input and a
>>> stable kernel driver? I've been playing with this device:
>>>
>>> http://www.diamondmm.com/VC500.php
>>>
>>> using the development drivers from http://linuxtv.org/hg/~mchehab/tm6010/
>>> but I haven't had any luck with S-Video (only composite).
>>>
>>> Can anyone suggest a device with stable drivers in 2.6.27.5?
>>>
>>> Thanks, Keith.
>>>
>>> --
>>> video4linux-list mailing list
>>> Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
>>> https://www.redhat.com/mailman/listinfo/video4linux-list
>>>
>>
>> --
>> video4linux-list mailing list
>> Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
>> https://www.redhat.com/mailman/listinfo/video4linux-list
>>
>

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
