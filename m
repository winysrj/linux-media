Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m4Q9ol9W007276
	for <video4linux-list@redhat.com>; Mon, 26 May 2008 05:50:47 -0400
Received: from vds19s01.yellis.net (ns1019.yellis.net [213.246.41.159])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m4Q9oY0g016395
	for <video4linux-list@redhat.com>; Mon, 26 May 2008 05:50:35 -0400
Received: from goliath.anevia.com (cac94-10-88-170-236-224.fbx.proxad.net
	[88.170.236.224])
	by vds19s01.yellis.net (Postfix) with ESMTP id 8CBC02FA825
	for <video4linux-list@redhat.com>;
	Mon, 26 May 2008 11:50:39 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
	by goliath.anevia.com (Postfix) with ESMTP id 5AC9E1300272
	for <video4linux-list@redhat.com>;
	Mon, 26 May 2008 11:50:32 +0200 (CEST)
Received: from goliath.anevia.com ([127.0.0.1])
	by localhost (goliath.anevia.com [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id CBSFdMDLKPcc for <video4linux-list@redhat.com>;
	Mon, 26 May 2008 11:50:23 +0200 (CEST)
Received: from [10.0.1.25] (fcand.anevia.com [10.0.1.25])
	by goliath.anevia.com (Postfix) with ESMTP id E5263130026A
	for <video4linux-list@redhat.com>;
	Mon, 26 May 2008 11:50:23 +0200 (CEST)
Message-ID: <483A87CA.6070408@anevia.com>
Date: Mon, 26 May 2008 11:50:02 +0200
From: Frederic CAND <frederic.cand@anevia.com>
MIME-Version: 1.0
To: video4linux-list@redhat.com
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Subject: [HVR 1300] MPEG PS issues
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

Dear all,
I post here cause I'm not sure everyone read my post in v4l-dvb.
Just copy/pasting my troubles here :

anybody
encountering picture / sound issues with VLC after some time running
(let's say half an hour) reading the MPEG PS output ?
I tried many different v4l-dvb tarballs, including latest repository,
but I could not make it work more that 30 minutes (or 20, it depends).
Stopping VLC and restarting it "solves" this issue but I'm looking for
someone who could confirm this behaviour, and then maybe fix this.
My VLC works fine , btw , with other MPEG PS or TS live streaming.

Other thing : I just use VLC to read the MPEG PS, not to setup the card. 
I do this with my own (simple) code which ressembles to this :

/* open devices */
fd1 = open("/dev/video0", 0_RDWR);
fd2 = open("/dev/video1", 0_RDWR);

/* prepare input/format */
int i = 1;
int j = V4L2_STD_SECAM;
ioctl(fd1, VIDIOC_S_INPUT, &i);
ioctl(fd1, VIDIOC_S_STD, &j);
struct v4l2_ext_controls mc;
struct v4l2_ext_control ctrls[32];

/* mpeg settings */
mc.ctrl_class = V4L2_CTRL_CLASS_MPEG;
mc.controls = ctrls;
i = 0;
mc.ctrl_class = V4L2_CTRL_CLASS_MPEG;
ctrls[i].id = V4L2_CID_MPEG_VIDEO_BITRATE_MODE;
ctrls[i++].value = V4L2_MPEG_VIDEO_BITRATE_MODE_CBR;
ctrls[i].id = V4L2_CID_MPEG_AUDIO_ENCODING;
ctrls[i++].value = V4L2_MPEG_AUDIO_ENCODING_LAYER_2;
ctrls[i].id = V4L2_CID_MPEG_AUDIO_L2_BITRATE;
ctrls[i++].value = V4L2_MPEG_AUDIO_L2_BITRATE_256K;
ctrls[i].id = V4L2_CID_MPEG_VIDEO_BITRATE;
ctrls[i++].value = 4096 * 1000;
ctrls[i].id = V4L2_CID_MPEG_VIDEO_BITRATE_PEAK;
ctrls[i++].value = 4096 * 1000;
ctrls[i].id = V4L2_CID_MPEG_VIDEO_ASPECT;
ctrls[i++].value = V4L2_MPEG_VIDEO_ASPECT_4x3;
mc.count = i;
ioctl(fd2, VIDIOC_S_EXT_CTRLS, &mc);

Anyone having troubles with VLC after 30 minutes ?
-- 
CAND Frederic
Product Manager
ANEVIA

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
