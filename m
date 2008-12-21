Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mBL1undO007068
	for <video4linux-list@redhat.com>; Sat, 20 Dec 2008 20:56:49 -0500
Received: from mail-ew0-f21.google.com (mail-ew0-f21.google.com
	[209.85.219.21])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mBL1tk2b011153
	for <video4linux-list@redhat.com>; Sat, 20 Dec 2008 20:55:46 -0500
Received: by ewy14 with SMTP id 14so1614725ewy.3
	for <video4linux-list@redhat.com>; Sat, 20 Dec 2008 17:55:46 -0800 (PST)
Message-ID: <de8cad4d0812201755v846c5dcn536736a6f56fd008@mail.gmail.com>
Date: Sat, 20 Dec 2008 20:55:45 -0500
From: "Brandon Jenkins" <bcjenkins@tvwhere.com>
To: "Hans Verkuil" <hverkuil@xs4all.nl>
In-Reply-To: <200812181009.09836.hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <15114.62.70.2.252.1228832086.squirrel@webmail.xs4all.nl>
	<200812161655.39431.hverkuil@xs4all.nl>
	<de8cad4d0812170904x474a5503ve5fcef84ebfeba65@mail.gmail.com>
	<200812181009.09836.hverkuil@xs4all.nl>
Cc: video4linux-list@redhat.com
Subject: Re: v4l2-compat-ioctl32 update?
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

On Thu, Dec 18, 2008 at 4:09 AM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
>
> Hi Brandon,
>
> This can't be right. Are you sure that you are using the right
> v4l2_compat_ioctl32 module? Check that you do not accidentally have the old
> compat_ioctl32 module instead. VIDIOC_S_EXT_CTRLS works fine here, and in
> any case, these compat_ioctl32 messages you get should have a newline at
> the end as well.
>
> Regards,
>
>        Hans
>
>>
>> Brandon
>
>
>
> --
> Hans Verkuil - video4linux developer - sponsored by TANDBERG
>

Hi Hans,

I have verified the time stamp of the module is from today and the
source file includes your copyright which is part of the patch. My
method of building the driver is to clone from Janne's hdpvr source
tree and pull in the changes from yours. (Please note that I also
pulled a clone from just your repo and the same/similar item popped
up: [ 1784.808655] compat_ioctl32:
VIDIOC_S_EXT_CTRLS<7>compat_ioctl32:
VIDIOC_S_EXT_CTRLS<7>compat_ioctl32:
VIDIOC_S_EXT_CTRLS<7>compat_ioctl32:
VIDIOC_S_EXT_CTRLS<7>compat_ioctl32:
VIDIOC_S_EXT_CTRLS<7>compat_ioctl32: VIDIOC_S_EXT_CTRLS<6>cx18-2 info:
Start encoder stream encoder MPEG)

Rest of the note below, thanks!

Brandon

I am still seeing:

[  876.565494] compat_ioctl32: VIDIOC_S_AUDIOioctl32(java:4706):
Unknown cmd fd(54) cmd(40345622){t:'V';sz:52} arg(aea69b34) on
/dev/v4l/video3

[ 1001.370070] compat_ioctl32: VIDIOC_S_EXT_CTRLSioctl32(java:7144):
Unknown cmd fd(47) cmd(c0185648){t:'V';sz:24} arg(ac0ad720) on
/dev/v4l/video1
[ 1001.370114] compat_ioctl32: VIDIOC_S_EXT_CTRLSioctl32(java:7144):
Unknown cmd fd(47) cmd(c0185648){t:'V';sz:24} arg(ac0ad720) on
/dev/v4l/video1
[ 1001.370172] compat_ioctl32: VIDIOC_S_EXT_CTRLSioctl32(java:7144):
Unknown cmd fd(47) cmd(c0185648){t:'V';sz:24} arg(ac0ad720) on
/dev/v4l/video1
[ 1001.370244] compat_ioctl32: VIDIOC_S_EXT_CTRLSioctl32(java:7144):
Unknown cmd fd(47) cmd(c0185648){t:'V';sz:24} arg(ac0ad720) on
/dev/v4l/video1
[ 1001.370285] compat_ioctl32: VIDIOC_S_EXT_CTRLSioctl32(java:7144):
Unknown cmd fd(47) cmd(c0185648){t:'V';sz:24} arg(ac0ad720) on
/dev/v4l/video1
[ 1001.370325] compat_ioctl32: VIDIOC_S_EXT_CTRLSioctl32(java:7144):
Unknown cmd fd(47) cmd(c0185648){t:'V';sz:24} arg(ac0ad720) on
/dev/v4l/video1

[ 2308.076933] compat_ioctl32: VIDIOC_S_AUDIOioctl32(java:26646):
Unknown cmd fd(54) cmd(40345622){t:'V';sz:52} arg(ac65cd44) on
/dev/v4l/video3

[ 2312.841316] compat_ioctl32: VIDIOC_S_EXT_CTRLSioctl32(java:26646):
Unknown cmd fd(54) cmd(c0185648){t:'V';sz:24} arg(ac65c920) on
/dev/v4l/video3
[ 2312.841363] compat_ioctl32: VIDIOC_S_EXT_CTRLSioctl32(java:26646):
Unknown cmd fd(54) cmd(c0185648){t:'V';sz:24} arg(ac65c920) on
/dev/v4l/video3
[ 2312.841400] compat_ioctl32: VIDIOC_S_EXT_CTRLSioctl32(java:26646):
Unknown cmd fd(54) cmd(c0185648){t:'V';sz:24} arg(ac65c920) on
/dev/v4l/video3

compat_ioctl32: VIDIOC_ENCODER_CMDioctl32(java:26727): Unknown cmd
fd(101) cmd(c028564d){t:'V';sz:40} arg(ac05cce4) on /dev/v4l/video3

video3 is a HDPVR
video1 is a cx18

The java process is SageTV.

I ran through my script again and it produced errors in:

[ 3335.252229] compat_ioctl : unexpected VIDIOC_FMT type 8
[ 3335.253804] compat_ioctl32:
VIDIOC_G_SLICED_VBI_CAP<7>compat_ioctl32:
VIDIOC_G_SLICED_VBI_CAPcompat_ioctl : unexpected VIDIOC_FMT type 6
[ 3335.258891] compat_ioctl : unexpected VIDIOC_FMT type 7
[ 3335.262139] compat_ioctl : unexpected VIDIOC_FMT type 5
[ 3335.267127] compat_ioctl32: VIDIOC_G_CROP<7>compat_ioctl32:
VIDIOC_G_CROP<7>compat_ioctl32: VIDIOC_G_CROP<7>compat_ioctl32:
VIDIOC_G_CROP<7>compat_ioctl32: VIDIOC_G_AUDIO<7>compat_ioctl32:
VIDIOC_G_AUDOUT<7>compat_ioctl32: VIDIOC_ENUMAUDOUT<7>compat_ioctl32:
VIDIOC_ENUMAUDIOcompat_ioctl : unexpected VIDIOC_FMT type 2
[ 3363.895405] compat_ioctl : unexpected VIDIOC_FMT type 8
[ 3363.895408] compat_ioctl : unexpected VIDIOC_FMT type 6
[ 3363.895410] compat_ioctl : unexpected VIDIOC_FMT type 7
[ 3363.895430] compat_ioctl : unexpected VIDIOC_FMT type 5
[ 3363.895438] compat_ioctl32: VIDIOC_G_CROP<7>compat_ioctl32:
VIDIOC_G_OUTPUT<7>compat_ioctl32: VIDIOC_G_AUDIO<7>compat_ioctl32:
VIDIOC_G_AUDOUT<7>compat_ioctl32: VIDIOC_G_EXT_CTRLS<7>compat_ioctl32:
VIDIOC_G_EXT_CTRLS<7>compat_ioctl32:
VIDIOC_G_EXT_CTRLS<7>compat_ioctl32:
VIDIOC_G_EXT_CTRLS<7>compat_ioctl32:
VIDIOC_G_EXT_CTRLS<7>compat_ioctl32:
VIDIOC_G_EXT_CTRLS<7>compat_ioctl32:
VIDIOC_G_EXT_CTRLS<7>compat_ioctl32:
VIDIOC_G_EXT_CTRLS<7>compat_ioctl32:
VIDIOC_G_EXT_CTRLS<7>compat_ioctl32:
VIDIOC_G_EXT_CTRLS<7>compat_ioctl32:
VIDIOC_G_EXT_CTRLS<7>compat_ioctl32:
VIDIOC_G_EXT_CTRLS<7>compat_ioctl32:
VIDIOC_G_EXT_CTRLS<7>compat_ioctl32:
VIDIOC_G_EXT_CTRLS<7>compat_ioctl32:
VIDIOC_G_EXT_CTRLS<7>compat_ioctl32:
VIDIOC_G_EXT_CTRLS<7>compat_ioctl32:
VIDIOC_G_EXT_CTRLS<7>compat_ioctl32:
VIDIOC_G_EXT_CTRLS<7>compat_ioctl32:
VIDIOC_G_EXT_CTRLS<7>compat_ioctl32:
VIDIOC_G_EXT_CTRLS<7>compat_ioctl32:
VIDIOC_G_EXT_CTRLS<7>compat_ioctl32:
VIDIOC_G_EXT_CTRLS<7>compat_ioctl32:
VIDIOC_G_EXT_CTRLS<7>compat_ioctl32:
VIDIOC_G_EXT_CTRLS<7>compat_ioctl32:
VIDIOC_G_EXT_CTRLS<7>compat_ioctl32:
VIDIOC_G_EXT_CTRLS<7>compat_ioctl32:
VIDIOC_G_EXT_CTRLS<7>compat_ioctl32:
VIDIOC_G_EXT_CTRLS<7>compat_ioctl32:
VIDIOC_G_EXT_CTRLS<7>compat_ioctl32:
VIDIOC_G_EXT_CTRLS<7>compat_ioctl32:
VIDIOC_G_EXT_CTRLS<7>compat_ioctl32:
VIDIOC_G_EXT_CTRLS<7>compat_ioctl32:
VIDIOC_G_EXT_CTRLS<7>compat_ioctl32:
VIDIOC_G_EXT_CTRLS<7>compat_ioctl32:
VIDIOC_G_EXT_CTRLS<7>compat_ioctl32:
VIDIOC_G_EXT_CTRLS<7>compat_ioctl32:
VIDIOC_G_EXT_CTRLS<7>compat_ioctl32:
VIDIOC_G_EXT_CTRLS<7>compat_ioctl32:
VIDIOC_G_EXT_CTRLS<7>compat_ioctl32:
VIDIOC_G_EXT_CTRLS<7>compat_ioctl32:
VIDIOC_G_EXT_CTRLS<7>compat_ioctl32:
VIDIOC_G_EXT_CTRLS<7>compat_ioctl32:
VIDIOC_G_EXT_CTRLS<7>compat_ioctl32:
VIDIOC_G_EXT_CTRLS<7>compat_ioctl32:
VIDIOC_G_EXT_CTRLS<7>compat_ioctl32:
VIDIOC_G_EXT_CTRLS<7>compat_ioctl32:
VIDIOC_G_EXT_CTRLS<7>compat_ioctl32:
VIDIOC_G_EXT_CTRLS<7>compat_ioctl32:
VIDIOC_G_EXT_CTRLS<7>compat_ioctl32:
VIDIOC_G_EXT_CTRLS<7>compat_ioctl32:
VIDIOC_G_EXT_CTRLS<7>compat_ioctl32:
VIDIOC_G_EXT_CTRLS<7>compat_ioctl32:
VIDIOC_G_EXT_CTRLS<7>compat_ioctl32:
VIDIOC_G_EXT_CTRLS<7>compat_ioctl32:
VIDIOC_G_EXT_CTRLS<7>compat_ioctl32:
VIDIOC_G_EXT_CTRLS<7>compat_ioctl32:
VIDIOC_G_EXT_CTRLS<7>compat_ioctl32:
VIDIOC_G_EXT_CTRLS<7>compat_ioctl32:
VIDIOC_G_EXT_CTRLS<7>compat_ioctl32:
VIDIOC_G_EXT_CTRLS<7>compat_ioctl32:
VIDIOC_G_EXT_CTRLS<7>compat_ioctl32:
VIDIOC_G_EXT_CTRLS<7>compat_ioctl32:
VIDIOC_G_EXT_CTRLS<7>compat_ioctl32:
VIDIOC_G_EXT_CTRLS<7>compat_ioctl32:
VIDIOC_G_EXT_CTRLS<7>compat_ioctl32:
VIDIOC_G_EXT_CTRLS<7>compat_ioctl32:
VIDIOC_ENUMOUTPUT<7>compat_ioctl32: VIDIOC_G_OUTPUTcompat_ioctl :
unexpected VIDIOC_FMT type 2
[ 3363.922264] compat_ioctl : unexpected VIDIOC_FMT type 8
[ 3363.923846] compat_ioctl32:
VIDIOC_G_SLICED_VBI_CAP<7>compat_ioctl32:
VIDIOC_G_SLICED_VBI_CAPcompat_ioctl : unexpected VIDIOC_FMT type 6
[ 3363.928925] compat_ioctl : unexpected VIDIOC_FMT type 7
[ 3363.932176] compat_ioctl : unexpected VIDIOC_FMT type 5
[ 3363.937120] compat_ioctl32: VIDIOC_G_CROP<7>compat_ioctl32:
VIDIOC_G_CROP<7>compat_ioctl32: VIDIOC_G_CROP<7>compat_ioctl32:
VIDIOC_G_CROP<7>compat_ioctl32: VIDIOC_G_AUDIO<7>compat_ioctl32:
VIDIOC_G_AUDOUT<7>compat_ioctl32: VIDIOC_ENUMAUDOUT<7>compat_ioctl32:
VIDIOC_ENUMAUDIO

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
