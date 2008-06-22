Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m5MHLmCF013822
	for <video4linux-list@redhat.com>; Sun, 22 Jun 2008 13:21:48 -0400
Received: from smtp2-g19.free.fr (smtp2-g19.free.fr [212.27.42.28])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m5MHLaoK031601
	for <video4linux-list@redhat.com>; Sun, 22 Jun 2008 13:21:36 -0400
Received: from smtp2-g19.free.fr (localhost.localdomain [127.0.0.1])
	by smtp2-g19.free.fr (Postfix) with ESMTP id 4ECCD12B6B4
	for <video4linux-list@redhat.com>;
	Sun, 22 Jun 2008 19:21:36 +0200 (CEST)
Received: from [192.168.0.50] (cac94-1-81-57-151-96.fbx.proxad.net
	[81.57.151.96])
	by smtp2-g19.free.fr (Postfix) with ESMTP id 244AF12B6B9
	for <video4linux-list@redhat.com>;
	Sun, 22 Jun 2008 19:21:36 +0200 (CEST)
Message-ID: <485E8A2C.5030905@free.fr>
Date: Sun, 22 Jun 2008 19:21:48 +0200
From: matthieu castet <castet.matthieu@free.fr>
MIME-Version: 1.0
To: Video 4 Linux <video4linux-list@redhat.com>
References: <485D4972.2070801@free.fr>
In-Reply-To: <485D4972.2070801@free.fr>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Subject: Re: application hanging with 2.6.25 and bttv
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

matthieu castet wrote:
> Hi,
> 
> I have got a tv application that doesn't work anymore with 2.6.25 : it 
> hangs.
> 
using mplayer with v4l backed produce the same lockup :

[ 5702.024629] mplayer       D 00000000     0 16181  16110
[ 5702.024629]        e76a5910 00200082 e76a5b60 00000000 e76a5a90 
c180b920 00000000 001368be
[ 5702.024629]        00318ee4 f77179a4 000000ff 00000000 00000000 
00000000 e776b810 e776b818
[ 5702.024629]        e776b814 e76a5910 c02b47e9 e776b818 e776b818 
e76a5910 e776b810 00208000
[ 5702.024629] Call Trace:
[ 5702.024629]  [<c02b47e9>] __mutex_lock_slowpath+0x50/0x7b
[ 5702.024629]  [<c02b467f>] mutex_lock+0xa/0xb
[ 5702.024629]  [<f8d26e8d>] videobuf_mmap_setup+0xe/0x2d [videobuf_core]
[ 5702.024629]  [<f8de3d6b>] vidiocgmbuf+0x24/0x83 [bttv]
[ 5702.024629]  [<f8de3d47>] vidiocgmbuf+0x0/0x83 [bttv]
[ 5702.024629]  [<f8d797fd>] __video_do_ioctl+0x93/0x2cca [videodev]
[ 5702.024629]  [<c0158558>] __lock_page+0x4e/0x54
[ 5702.024629]  [<c0133a21>] wake_bit_function+0x0/0x3c
[ 5702.024629]  [<c01586a1>] find_lock_page+0x19/0x7f
[ 5702.024629]  [<c015a57f>] filemap_fault+0x1ff/0x36d
[ 5702.024629]  [<c01635f0>] __do_fault+0x34d/0x38e
[ 5702.024629]  [<f8de217b>] set_tvnorm+0x205/0x20f [bttv]
[ 5702.024629]  [<f8d7c69d>] video_ioctl2+0x16d/0x233 [videodev]
[ 5702.024629]  [<c0137c03>] getnstimeofday+0x30/0xb6
[ 5702.024629]  [<c013659d>] ktime_get_ts+0x16/0x44
[ 5702.024629]  [<c01365d8>] ktime_get+0xd/0x21
[ 5702.024629]  [<c011b720>] hrtick_start_fair+0xeb/0x12c
[ 5702.024629]  [<c0106970>] __switch_to+0xa3/0x12f
[ 5702.024629]  [<c017f70b>] vfs_ioctl+0x47/0x5d
[ 5702.024629]  [<c017f966>] do_vfs_ioctl+0x245/0x258
[ 5702.024629]  [<c017f9ba>] sys_ioctl+0x41/0x5b
[ 5702.024629]  [<c01077e8>] sysenter_past_esp+0x6d/0xa5
[ 5702.024629]  =======================

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
