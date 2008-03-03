Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m232rF4V003783
	for <video4linux-list@redhat.com>; Sun, 2 Mar 2008 21:53:15 -0500
Received: from QMTA10.emeryville.ca.mail.comcast.net
	(qmta10.emeryville.ca.mail.comcast.net [76.96.30.17])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m232qgx2017094
	for <video4linux-list@redhat.com>; Sun, 2 Mar 2008 21:52:42 -0500
Message-ID: <47CB6801.4060503@personnelware.com>
Date: Sun, 02 Mar 2008 20:52:49 -0600
From: Carl Karsten <carl@personnelware.com>
MIME-Version: 1.0
To: video4linux-list@redhat.com
References: <47CB2689.3010707@personnelware.com>
In-Reply-To: <47CB2689.3010707@personnelware.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Subject: Re: vivi.c stuck my CPU
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

Carl Karsten wrote:
> [2950.237132] BUG: soft lockup - CPU#0 stuck for 11s! [vivi:9709]
> any chance that is an application problem ?
> 

CPU#0 stuck came from using transcode:
++ transcode -i /dev/video0 -x v4l2,null -g 640x480 --dv_yuy2_mode -V yuv422p -k 
--encode_fields p

I rebooted, loaded vivi and tried xawtv. Didn't crash as hard, but none the 
less, things aren't right.

juser@vaio:~$ sudo modprobe vivi
[  184.053222] Linux video capture interface: v2.00
[  184.070413] vivi: V4L2 device registered as /dev/video0
[  184.070424] Video Technology Magazine Virtual Video Capture Board ver 0.5.0 
successfully loaded.

juser@vaio:~$ xawtv
This is xawtv-3.95.dfsg.1, running on Linux/i686 (2.6.24-10-generic)
/dev/video0 [v4l2]: no overlay support
v4l-conf had some trouble, trying to continue anyway
Warning: Cannot convert string "-*-ledfixed-medium-r-*--39-*-*-*-c-*-*-*" to 
type FontStruct
ioctl: VIDIOC_REQBUFS(count=2;type=VIDEO_CAPTURE;memory=MMAP): Success
ioctl: VIDIOC_DQBUF(index=0;type=VIDEO_CAPTURE;bytesused=0;flags=0x0 
[];field=ANY;;timecode.type=0;timecode.flags=0;timecode.frames=0;timecode.seconds=0;timecode.minutes=0;timecode.hours=0;timecode.userbits="";sequence=0;memory=MMAP): 
Input/output error


[  251.821907] vivi: open called (minor=0)
[  251.823664] vivi: open called (minor=0)
[  251.824152] vivi: open called (minor=0)
[  314.810130] vivi/0: [d7491a00/0] timeout
[  314.810141] vivi/0: [d7491280/1] timeout
[  251.821907] vivi: open called (minor=0)
[  251.823664] vivi: open called (minor=0)
[  251.824152] vivi: open called (minor=0)
[  314.810130] vivi/0: [d7491a00/0] timeout
[  314.810141] vivi/0: [d7491280/1] timeout
[  586.440266] vivi: open called (minor=0)
[  586.480991] vivi: open called (minor=0)
[  650.181535] vivi/0: [d64dfd80/1] timeout
[  650.181546] vivi/0: [d64dfe80/2] timeout
[  650.181551] vivi/0: [d64df980/3] timeout
[  650.181555] vivi/0: [d64dfe00/4] timeout
[  650.181559] vivi/0: [d64df100/5] timeout
[  650.181563] vivi/0: [d64df800/6] timeout
[  650.181567] vivi/0: [d64dfd00/7] timeout
[  650.181571] vivi/0: [d64dff80/8] timeout
[  650.181575] vivi/0: [d64df680/9] timeout
[  650.181579] vivi/0: [d791d380/10] timeout
[  650.181583] vivi/0: [d7996d80/11] timeout
[  650.181587] vivi/0: [d7996380/12] timeout
[  650.181592] vivi/0: [d6d25e00/13] timeout
[  650.181596] vivi/0: [d6d25e80/14] timeout
[  650.181600] vivi/0: [d6d25f80/15] timeout
[  650.181604] vivi/0: [d6d25f00/16] timeout
[  650.181608] vivi/0: [d6d25300/17] timeout
[  650.181612] vivi/0: [d6d25080/18] timeout
[  650.181616] vivi/0: [d6d25400/19] timeout
[  650.181620] vivi/0: [d6d25580/20] timeout
[  650.181624] vivi/0: [d6d25d80/21] timeout
[  650.181628] vivi/0: [d6d25d00/22] timeout
[  650.181632] vivi/0: [d6d25c80/23] timeout
[  650.181636] vivi/0: [d6d25b80/24] timeout
[  650.181640] vivi/0: [d6d25700/25] timeout
[  650.181644] vivi/0: [d6d25a00/26] timeout
[  650.181648] vivi/0: [d6d25200/27] timeout
[  650.181652] vivi/0: [d6d25800/28] timeout
[  650.181656] vivi/0: [d6d25000/29] timeout
[  650.181660] vivi/0: [d7491280/30] timeout
[  650.181665] vivi/0: [d7491a00/31] timeout
[  650.181671] vivi/0: [d64dfc80/0] timeout


If someone will point me in the right direction, I'll write a test app to 
reproduce this.

And where is the right place to report bugs?

Carl K

ps hope ya'll don't get tired of my test quest.)


--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
