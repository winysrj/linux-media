Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mAJFmfdQ004678
	for <video4linux-list@redhat.com>; Wed, 19 Nov 2008 10:48:41 -0500
Received: from yw-out-2324.google.com (yw-out-2324.google.com [74.125.46.28])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mAJFmRBP005966
	for <video4linux-list@redhat.com>; Wed, 19 Nov 2008 10:48:27 -0500
Received: by yw-out-2324.google.com with SMTP id 5so3790ywb.81
	for <video4linux-list@redhat.com>; Wed, 19 Nov 2008 07:48:27 -0800 (PST)
Message-ID: <ea3b75ed0811190748o44a26a45kb38b9bca24e6bda5@mail.gmail.com>
Date: Wed, 19 Nov 2008 10:48:26 -0500
From: "Brian Phelps" <lm317t@gmail.com>
To: "David Ellingsworth" <david@identd.dyndns.org>, video4linux-list@redhat.com
In-Reply-To: <ea3b75ed0811181343k48a7e4f1n2a32015c09ad5677@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <ea3b75ed0811180953g4846fc80lf9d0018703486838@mail.gmail.com>
	<ea3b75ed0811181010k3287581ew612a98ddf7a53ef6@mail.gmail.com>
	<ea3b75ed0811181244p713c7246ga06d91eceb7c56ad@mail.gmail.com>
	<30353c3d0811181327h58e76eafl5237754284f96843@mail.gmail.com>
	<ea3b75ed0811181343k48a7e4f1n2a32015c09ad5677@mail.gmail.com>
Cc: 
Subject: Re: Pre-crash log
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

V4L2_PIX_FMT_YUV420 seems to be the culprit!

The bug that I am running into is on an intel quad core machine, 2x4
input chip bt878 based pci capture cards with /dev/video0-7

All you have to do is change "count" from 100 to something large like
10million or so and change:
fmt.fmt.pix.pixelformat = V4L2_PIX_FMT_YUYV;

to:
fmt.fmt.pix.pixelformat = V4L2_PIX_FMT_YUV420;

then gcc capture.c -o capture and run:
capture   -d /dev/video0 -m &  capture   -d /dev/video1 -m  &
...<repeat> ......capture   -d /dev/video7 -m

It takes 1-2 minutes for me to get:
[ 1177.822768] bttv7: OCERR @ 1c9b1000,bits: HSYNC FDSR OCERR*
[ 1177.862730] bttv7: OCERR @ 1c9b1000,bits: HSYNC FDSR OCERR*
[ 1177.902699] bttv7: OCERR @ 1c9b1000,bits: HSYNC FDSR OCERR*
[ 1177.942667] bttv7: OCERR @ 1c9b1000,bits: HSYNC FDSR OCERR*
[ 1177.982627] bttv7: OCERR @ 1c9b1000,bits: HSYNC FDSR OCERR*
[ 1178.022594] bttv7: OCERR @ 1c9b1000,bits: HSYNC FDSR OCERR*
[ 1178.062559] bttv7: OCERR @ 1c9b1000,bits: HSYNC FDSR OCERR*
[ 1178.102526] bttv7: OCERR @ 1c9b1000,bits: HSYNC FDSR OCERR*
[ 1178.142490] bttv7: OCERR @ 1c9b1000,bits: HSYNC FDSR OCERR*
[ 1178.182454] bttv7: OCERR @ 1c9b1000,bits: HSYNC FDSR OCERR*
[ 1178.222425] bttv7: OCERR @ 1c9b1000,bits: HSYNC FDSR OCERR*
[ 1178.262387] bttv7: OCERR @ 1c9b1000,bits: HSYNC FDSR OCERR*
[ 1178.300027] bttv7: timeout: drop=12 irq=53332/105941,
risc=1c9b103c, bits: HSYNC

using:

fmt.fmt.pix.pixelformat = V4L2_PIX_FMT_YUYV;

does not cause this.
Weird!

Does anyone have any suggestions?  Do you guys think this is a kernel
bug or v4l bug?

On Tue, Nov 18, 2008 at 4:43 PM, Brian Phelps <lm317t@gmail.com> wrote:
> Thanks for replying David, please see my responses below.
>
> On Tue, Nov 18, 2008 at 4:27 PM, David Ellingsworth
> <david@identd.dyndns.org> wrote:
>> On Tue, Nov 18, 2008 at 3:44 PM, Brian Phelps <lm317t@gmail.com> wrote:
>>> Anyone know what this means?
>>> [  768.998408] swap_dup: Bad swap file entry 4080000000101010
>>> [  768.998418] VM: killing process monitor
>>> [  768.998730] swap_free: Bad swap file entry 4080000000101010
>>
>> Brian,
>>
>> As Alexey Klimov suggested earlier, your logs seem to indicate a bug
>> in the memory management subsystem of the kernel. I suggest you post
>> this information to the linux-kernel mailing list since it more than
>> likely affects every other kernel subsystem. I don't know the
>> particulars of the above message, but it appears to be coming from the
>> part of the memory management subsystem that deals with virtual memory
>> and swap space. You might want to try turning off all available swap
>> space to see if the bug persists.
> I will try posting this to the kernel list.
>
> BTW Swap is off, I never turned it on, don't even have a swap partition/file.
>>
>> Since you keep hitting this bug while using the bttv driver it is
>> possible that there is a memory leak in the bttv driver which helps to
>> induce the bug. It is also possible and more likely that there is a
>> memory leak in the application you are using to stream video. In
>> either case, watching memory usage while stream should reveal if a
>> leak exists and if it's driver related or software related.
>
> According to top, no leaks exist, not even a drip.  I am using
> multiple instances of capture.c BTW.  One for each of eight video card
> inputs.
>>
>> Regards,
>>
>> David Ellingsworth
>>
>
>
>
> --
> Brian Phelps
> Got e- ?
> http://electronjunkie.wordpress.com
>

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
