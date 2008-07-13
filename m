Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m6D9fhe4015017
	for <video4linux-list@redhat.com>; Sun, 13 Jul 2008 05:41:43 -0400
Received: from wf-out-1314.google.com (wf-out-1314.google.com [209.85.200.170])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m6D9fXTV008754
	for <video4linux-list@redhat.com>; Sun, 13 Jul 2008 05:41:33 -0400
Received: by wf-out-1314.google.com with SMTP id 25so3945873wfc.6
	for <video4linux-list@redhat.com>; Sun, 13 Jul 2008 02:41:32 -0700 (PDT)
Message-ID: <ac7667650807130241r74851795ia935cc86d21c81cc@mail.gmail.com>
Date: Sun, 13 Jul 2008 11:41:32 +0200
From: "asdffdsa4 asdffdsa4" <asdffdsa4@gmail.com>
To: video4linux-list@redhat.com
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Subject: Please, help me getting mp1e working
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

Don't know if this is the correct list for my problem, if not please
tell me where to go.

I'm trying to use the analogtv plugin for VDR, but can't get a mpeg
software decoder working :(

Have tried several versions of mp1e and one of ffmpeg, the most of the
versions just hangs as an "uninterruptible sleep" process.

I got one mp1e version from 2004 (from the analogtv README) which
doesn't hangs, but when running it:
(command line copied from what analogtv try to execute, but the -vv)

#mp1e -vv -m 3 -g I -p /dev/dsp -c /dev/video0 -x /dev/mixer -a 3 -b
5000000 -B 80 -r 14,91 -s 352x288 -S 44,1 -F 8 -o ./analogtv.avi
Using SSE optimized routines.
Opened OSS PCM device /dev/dsp
Opened V4L2 (new) /dev/video0 ('BT878 video (AVerMedia TVCaptur')
Video standard is 'PAL' (25.00 Hz)
Audio unmuted
Filter 'YUV 4:2:0 w/vertical decimation'
Image format 'YU12' 352 x 576 granted
mp1e:v4l25.c:453: Failed to request capture buffers (2, No such file
or directory)


Mi analog TV card works fine with some other tv applications. (xawtv
-c /dev/video0 works)

I'm using 2.6.25.4 original kernel:
- v4l2 compiled in kernel as support for v4l.
- sound system: alsa, right now in kernel too.
- bttv as module and working fine

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
