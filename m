Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx1.redhat.com (ext-mx05.extmail.prod.ext.phx2.redhat.com
	[10.5.110.9])
	by int-mx01.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id o2SEvE58008685
	for <video4linux-list@redhat.com>; Sun, 28 Mar 2010 10:57:14 -0400
Received: from mail-pv0-f174.google.com (mail-pv0-f174.google.com
	[74.125.83.174])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id o2SEv4uM022614
	for <video4linux-list@redhat.com>; Sun, 28 Mar 2010 10:57:05 -0400
Received: by pva18 with SMTP id 18so2321122pva.33
	for <video4linux-list@redhat.com>; Sun, 28 Mar 2010 07:57:03 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <6eeb4a0a1003270802r3db5fb27v82aa079d28f225b6@mail.gmail.com>
References: <55fab5731003270620g6d597530k94106150e4722e0a@mail.gmail.com>
	<6eeb4a0a1003270802r3db5fb27v82aa079d28f225b6@mail.gmail.com>
From: Yves Glodt <yg@mind.lu>
Date: Sun, 28 Mar 2010 16:56:48 +0200
Message-ID: <55fab5731003280756x5fd10da6n33bd1c78eaec514@mail.gmail.com>
Subject: Re: Problem runnning webcam on a sheevaplug with using pwc
To: Raul Fajardo <rfajardo@gmail.com>
Cc: video4linux-list@redhat.com
List-Unsubscribe: <https://www.redhat.com/mailman/options/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

Hi Raul,

I have tried rebooting with the camera plugged, it does not make a
difference.

Option 2 I have not tried yet, will probably be able to do so later today.

Yves


On 27 March 2010 17:02, Raul Fajardo <rfajardo@gmail.com> wrote:

> Hi Yves,
>
> this is a bug related to the hotplug system or something.
> https://bugs.launchpad.net/ubuntu/+source/linux/+bug/443278
>
> The driver works in two cases:
> 1) the camera was connected on power up.
> 2) you remove the module rmmod pwc, connect the camera and let the hotplug
> system load the module
>
> I suppose that's your problem.
>
> Best regards,
> Raul
>
> On Sat, Mar 27, 2010 at 2:20 PM, Yves Glodt <yg@mind.lu> wrote:
>
>>  Hi,
>>
>> I have a problem when I run webcam on my sheevaplug, it seems to hang.
>>
>> I use the 2.6.33-1 kernel from
>> http://sheeva.with-linux.com/sheeva/index.php?dir=2.6.33.1/
>> The pwc module was missing so I cross-compiled it on my laptop and
>> installed
>> it.
>> The modules loads and detects the camera without a problem. /dev/video0 is
>> there as well.
>>
>>
>> This is all what happens:
>>
>> root@sheevaplug:~# webcam
>> reading config file: /root/.webcamrc
>> video4linux webcam v1.5 - (c) 1998-2002 Gerd Knorr
>> grabber config:
>>  size 640x480 [none]
>>  input usb, norm (null), jpeg quality 100
>>  rotate=0, top=0, left=0, bottom=480, right=640
>>
>> and then it hangs forever.
>>
>> When I use the same webcam with the same .webcamrc on my laptop, it works.
>> I attach an strace of the webcam run.
>>
>> Somebody knows what goes wrong here? Or what other debug possibilities I
>> have? :-)
>>
>> best regards,
>> Yves
>>
>>
--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
