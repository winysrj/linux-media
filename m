Return-path: <linux-media-owner@vger.kernel.org>
Received: from proofpoint-cluster.metrocast.net ([65.175.128.136]:33769 "EHLO
	proofpoint-cluster.metrocast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751267AbaJZLKH (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 26 Oct 2014 07:10:07 -0400
In-Reply-To: <544C8BAC.1070001@xs4all.nl>
References: <201410252315.s9PNF6eB002672@cneufeld.ca> <544C8BAC.1070001@xs4all.nl>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain;
 charset=UTF-8
Subject: Re: VBI on PVR-500 stopped working between kernels 3.6 and 3.13
From: Andy Walls <awalls@md.metrocast.net>
Date: Sun, 26 Oct 2014 06:55:28 -0400
To: Hans Verkuil <hverkuil@xs4all.nl>, media-alias@cneufeld.ca,
	linux-media@vger.kernel.org
Message-ID: <CB3EF26B-C433-410C-B429-A25B3268516C@md.metrocast.net>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On October 26, 2014 1:50:36 AM EDT, Hans Verkuil <hverkuil@xs4all.nl> wrote:
>Hi Christopher,
>
>On 10/26/2014 01:15 AM, Christopher Neufeld wrote:
>> I've been using a PVR-500 to record shows in MythTV, and to capture
>the VBI
>> part of the stream from the standard-definition output of my STB when
>it
>> records high definition.  This has worked for about 7 years now.
>> 
>> I recently updated my LinHES MythTV distribution, and part of the
>update
>> involved moving to a new kernel.  The old kernel went by the code
>> 3.6.7-1-ARCH, while the new one is 3.13.7-2-ARCH.
>> 
>> With the updated kernel, my VBI captures no longer function.
>> Standard-definition recordings made from MythTV using the PVR-500
>before
>> the update have caption data in the stream, those made after do not.
>> 
>> The retrieval of caption data for high-definition shows involves some
>> manual scripting to set the modes for the PVR-500, after which I run
>> ccextractor on the V4L device node and just pull out the captions
>data (the
>> audio and video being output separately on high-definition outputs of
>the
>> STB, and captured by a HD-PVR).
>> 
>> The script that I use to set up captions invokes this command:
>> v4l2-ctl -d <DEV> --set-fmt-sliced-vbi=cc
>--set-ctrl=stream_vbi_format=1
>> 
>> This now errors out.  Part of that is a parsing bug in v4l2-ctl, it
>wants
>> to see more text after the 'cc'.  I can change it to 
>> v4l2-ctl -d <DEV> --set-fmt-sliced-vbi=cc=1
>--set-ctrl=stream_vbi_format=1
>
>This is a v4l2-ctl bug. I'll fix that asap. But using cc=1 is a valid
>workaround.
>
>> 
>> with this change, it no longer complains about the command line, but
>it
>> errors out in the ioctls.  This behaviour is seen with three versions
>of
>> v4l2-ctl: the old one packaged with the old kernel, the new one
>packaged
>> with the newer kernel, and the git-head, compiled against the headers
>of
>> the new kernel.
>
>Are you calling this when MythTV is already running? If nobody else is
>using
>the PVR-500, does it work?
>
>> 
>> I strace-d the v4l2-ctl command.  The relevant output is:
>> open("/dev/pvr_500_1", O_RDWR)          = 3
>> ioctl(3, VIDIOC_QUERYCAP or VT_OPENQRY, 0x7fff836aac10) = 0
>> ioctl(3, VIDIOC_QUERYCTRL, 0x7fff836aaa70) = 0
>> ioctl(3, VIDIOC_QUERYCTRL, 0x7fff836aaa70) = 0
>> brk(0)                                  = 0x12ca000
>> brk(0x12eb000)                          = 0x12eb000
>> ioctl(3, VIDIOC_QUERYCTRL, 0x7fff836aaa70) = 0
>> 			<<<PREVIOUS LINE REPEATS 41 TIMES>>>
>> ioctl(3, VIDIOC_QUERYCTRL, 0x7fff836aaa70) = 0
>> ioctl(3, VIDIOC_QUERYCTRL, 0x7fff836aaa70) = -1 EINVAL (Invalid
>argument)
>> ioctl(3, VIDIOC_S_FMT or VT_RELDISP, 0x62eae0) = -1 EINVAL (Invalid
>argument)
>> fstat(1, {st_mode=S_IFCHR|0600, st_rdev=makedev(136, 0), ...}) = 0
>> mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1,
>0) = 0x7fe8233bf000
>> write(1, "VIDIOC_S_FMT: failed: Invalid ar"..., 39VIDIOC_S_FMT:
>failed: Invalid argument
>> ) = 39
>> close(3)                                = 0
>> exit_group(-1)                          = ?
>> 
>> I did once see VBI data arriving from one of the paired devices in
>the
>> PVR-500, and not from the other.  I would guess that to be because it
>> started up in that state.  When this happened, I ran v4l2-ctl --all
>on both
>> devices, captured the output, and stored it to files.  I did not see
>any
>> relevent differences in these outputs, but I present the diff here:
>> 
>> --- file1       2014-10-25 13:40:36.698703171 -0400
>> +++ file2       2014-10-25 13:40:41.248614481 -0400
>> @@ -1,15 +1,14 @@
>>  Driver Info (not using libv4l2):
>>         Driver name   : ivtv
>> -       Card type     : WinTV PVR 500 (unit #1)
>> -       Bus info      : PCI:0000:06:08.0
>> +       Card type     : WinTV PVR 500 (unit #2)
>> +       Bus info      : PCI:0000:06:09.0
>>         Driver version: 3.13.7
>> -       Capabilities  : 0x81070051
>> +       Capabilities  : 0x81030051
>>                 Video Capture
>>                 VBI Capture
>>                 Sliced VBI Capture
>>                 Tuner
>>                 Audio
>> -               Radio
>>                 Read/Write
>>                 Device Capabilities
>>         Device Caps   : 0x01030001
>> @@ -18,7 +17,7 @@
>>                 Audio
>>                 Read/Write
>>  Priority: 2
>> -Frequency for tuner 0: 4148 (259.250000 MHz)
>> +Frequency for tuner 0: 884 (55.250000 MHz)
>>  Tuner 0:
>>         Name                 : ivtv TV Tuner
>>         Capabilities         : 62.5 kHz multi-standard stereo lang1
>lang2 freq-bands 
>> 
>> 
>> The fact that I once saw valid VBI data suggests that the driver is
>still
>> capable of the feature, but something about the ioctl invocations in
>> v4l2-ctl and in MythTV 0.27.4 is wrong for getting the driver
>reliably into
>> the state where VBI data is present in the stream coming from the
>device.
>
>I won't be able to test this myself until next weekend at the earliest.
>Andy, are you able to look at this?
>
>Regards,
>
>	Hans
>--
>To unsubscribe from this list: send the line "unsubscribe linux-media"
>in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html

I have time from 1 pm to about 10 pm EDT today; the rest of my week is booked.  If I dont have an answer by 10 pm, next Sunday would be the earliest.

Regards,
Andy
