Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m4RLFifH001724
	for <video4linux-list@redhat.com>; Tue, 27 May 2008 17:15:44 -0400
Received: from smtp-vbr7.xs4all.nl (smtp-vbr7.xs4all.nl [194.109.24.27])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m4RLFKpk014173
	for <video4linux-list@redhat.com>; Tue, 27 May 2008 17:15:20 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Linux and Kernel Video <video4linux-list@redhat.com>
Date: Tue, 27 May 2008 23:13:18 +0200
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200805272313.18651.hverkuil@xs4all.nl>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Handling of VIDIOC_G_STD and ENUMSTD in __video_do_ioctl
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

Hi Mauro,

While converting ivtv I noticed that VIDIOC_G_STD is now handled inside 
__video_do_ioctl and is implemented by returning a field from the 
video_device struct (which is set in turn when S_STD is called).

This is not correct: this assumes that each device has its own 
independent tvnorm setting, but devices like /dev/video0 and /dev/vbi0 
are linked: setting the standard to NTSC for one should set it to NTSC 
for the other as well. And this is even more important for ivtv with 
its additional raw video and audio devices.

The way it is done now means that this happens:

v4l2-ctl -s ntsc -d /dev/vbi0
v4l2-ctl -s pal -d /dev/video0
v4l2-ctl -S -d /dev/video0
Video Standard = 0x000000ff
        PAL-B/B1/G/H/I/D/D1/K
v4l2-ctl -S -d /dev/vbi0
Video Standard = 0x0000b000
        NTSC-M/M-JP/M-KR

That's not right. I suggest adding a proper vidioc_g_std callback 
instead and let the driver handle it. The driver knows which devices 
are linked.

In addition, the VIDIOC_ENUMSTD is now also handled inside 
__video_do_ioctl. I don't think that is correct. The purpose of this 
ioctl is for applications to setup a list of standards that the input 
supports and more importantly that the input will handle differently. 
The way it is implemented now means that v4l2-ctl --list-standards 
returns this:

        index       : 0
        ID          : 0x00000000000000FF
        Name        : PAL
        Frame period: 1/25
        Frame lines : 625

        index       : 1
        ID          : 0x0000000000000100
        Name        : PAL-M
        Frame period: 1001/30000
        Frame lines : 525

        index       : 2
        ID          : 0x0000000000000200
        Name        : PAL-N
        Frame period: 1/25
        Frame lines : 625

        index       : 3
        ID          : 0x0000000000000400
        Name        : PAL-Nc
        Frame period: 1/25
        Frame lines : 625

        index       : 4
        ID          : 0x0000000000000800
        Name        : PAL-60
        Frame period: 1001/30000
        Frame lines : 525

        index       : 5
        ID          : 0x000000000000B000
        Name        : NTSC
        Frame period: 1001/30000
        Frame lines : 525

        index       : 6
        ID          : 0x0000000000004000
        Name        : NTSC-443
        Frame period: 1001/30000
        Frame lines : 525

        index       : 7
        ID          : 0x0000000000FF0000
        Name        : SECAM
        Frame period: 1/25
        Frame lines : 625

Compare that to what ivtv used to return:

        index       : 0
        ID          : 0x000000000000000F
        Name        : PAL-BGH
        Frame period: 1/25
        Frame lines : 625

        index       : 1
        ID          : 0x00000000000000E0
        Name        : PAL-DK
        Frame period: 1/25
        Frame lines : 625

        index       : 2
        ID          : 0x0000000000000010
        Name        : PAL-I
        Frame period: 1/25
        Frame lines : 625

        index       : 3
        ID          : 0x0000000000000100
        Name        : PAL-M
        Frame period: 1001/30000
        Frame lines : 525

        index       : 4
        ID          : 0x0000000000000200
        Name        : PAL-N
        Frame period: 1/25
        Frame lines : 625

        index       : 5
        ID          : 0x0000000000000400
        Name        : PAL-Nc
        Frame period: 1/25
        Frame lines : 625

        index       : 6
        ID          : 0x00000000000D0000
        Name        : SECAM-BGH
        Frame period: 1/25
        Frame lines : 625

        index       : 7
        ID          : 0x0000000000320000
        Name        : SECAM-DK
        Frame period: 1/25
        Frame lines : 625

        index       : 8
        ID          : 0x0000000000400000
        Name        : SECAM-L
        Frame period: 1/25
        Frame lines : 625

        index       : 9
        ID          : 0x0000000000800000
        Name        : SECAM-L'
        Frame period: 1/25
        Frame lines : 625

        index       : 10
        ID          : 0x0000000000001000
        Name        : NTSC-M
        Frame period: 1001/30000
        Frame lines : 525

        index       : 11
        ID          : 0x0000000000002000
        Name        : NTSC-J
        Frame period: 1001/30000
        Frame lines : 525

        index       : 12
        ID          : 0x0000000000008000
        Name        : NTSC-K
        Frame period: 1001/30000
        Frame lines : 525

All these standards might be explicitly selected by the user. Which 
substandards can be combined into one ENUMSTD entry is really dependent 
on the hardware and the input. E.g. standards like PAL-60 and NTSC-443 
are never used in broadcasts, but can be used when capturing from 
composite/S-Video inputs.

Again, I think that it might be better to leave this to the driver, 
although perhaps the driver might supply a table instead and let 
__video_do_ioctl do the actual job.

I found a few other bugs as well in __video_do_ioctl, but the two that I 
found are easy to fix and I'll make a pull request for them. But I will 
need to do a closer review of __video_do_ioctl, in case there are more 
surprises.

Regards,

	Hans

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
