Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m4S8M5jE002981
	for <video4linux-list@redhat.com>; Wed, 28 May 2008 04:22:05 -0400
Received: from vds19s01.yellis.net (ns1019.yellis.net [213.246.41.159])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m4S8LKPx026788
	for <video4linux-list@redhat.com>; Wed, 28 May 2008 04:21:20 -0400
Received: from goliath.anevia.com (cac94-10-88-170-236-224.fbx.proxad.net
	[88.170.236.224])
	by vds19s01.yellis.net (Postfix) with ESMTP id 9F6612FA88F
	for <video4linux-list@redhat.com>;
	Wed, 28 May 2008 10:21:24 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
	by goliath.anevia.com (Postfix) with ESMTP id 2EA9B1300374
	for <video4linux-list@redhat.com>;
	Wed, 28 May 2008 10:21:19 +0200 (CEST)
Received: from goliath.anevia.com ([127.0.0.1])
	by localhost (goliath.anevia.com [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id TPgitwEt3c3j for <video4linux-list@redhat.com>;
	Wed, 28 May 2008 10:21:06 +0200 (CEST)
Received: from [10.0.1.25] (fcand.anevia.com [10.0.1.25])
	by goliath.anevia.com (Postfix) with ESMTP id 8209F1300377
	for <video4linux-list@redhat.com>;
	Wed, 28 May 2008 10:21:06 +0200 (CEST)
Message-ID: <483D15DA.7020901@anevia.com>
Date: Wed, 28 May 2008 10:20:42 +0200
From: Frederic CAND <frederic.cand@anevia.com>
MIME-Version: 1.0
To: video4linux-list@redhat.com
References: <483A87CA.6070408@anevia.com>
In-Reply-To: <483A87CA.6070408@anevia.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Subject: Re: [HVR 1300] MPEG PS issues
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

Frederic CAND a �crit :
> Dear all,
> I post here cause I'm not sure everyone read my post in v4l-dvb.
> Just copy/pasting my troubles here :
> 
> anybody
> encountering picture / sound issues with VLC after some time running
> (let's say half an hour) reading the MPEG PS output ?
> I tried many different v4l-dvb tarballs, including latest repository,
> but I could not make it work more that 30 minutes (or 20, it depends).
> Stopping VLC and restarting it "solves" this issue but I'm looking for
> someone who could confirm this behaviour, and then maybe fix this.
> My VLC works fine , btw , with other MPEG PS or TS live streaming.
> 
> Other thing : I just use VLC to read the MPEG PS, not to setup the card. 
> I do this with my own (simple) code which ressembles to this :
> 
> /* open devices */
> fd1 = open("/dev/video0", 0_RDWR);
> fd2 = open("/dev/video1", 0_RDWR);
> 
> /* prepare input/format */
> int i = 1;
> int j = V4L2_STD_SECAM;
> ioctl(fd1, VIDIOC_S_INPUT, &i);
> ioctl(fd1, VIDIOC_S_STD, &j);
> struct v4l2_ext_controls mc;
> struct v4l2_ext_control ctrls[32];
> 
> /* mpeg settings */
> mc.ctrl_class = V4L2_CTRL_CLASS_MPEG;
> mc.controls = ctrls;
> i = 0;
> mc.ctrl_class = V4L2_CTRL_CLASS_MPEG;
> ctrls[i].id = V4L2_CID_MPEG_VIDEO_BITRATE_MODE;
> ctrls[i++].value = V4L2_MPEG_VIDEO_BITRATE_MODE_CBR;
> ctrls[i].id = V4L2_CID_MPEG_AUDIO_ENCODING;
> ctrls[i++].value = V4L2_MPEG_AUDIO_ENCODING_LAYER_2;
> ctrls[i].id = V4L2_CID_MPEG_AUDIO_L2_BITRATE;
> ctrls[i++].value = V4L2_MPEG_AUDIO_L2_BITRATE_256K;
> ctrls[i].id = V4L2_CID_MPEG_VIDEO_BITRATE;
> ctrls[i++].value = 4096 * 1000;
> ctrls[i].id = V4L2_CID_MPEG_VIDEO_BITRATE_PEAK;
> ctrls[i++].value = 4096 * 1000;
> ctrls[i].id = V4L2_CID_MPEG_VIDEO_ASPECT;
> ctrls[i++].value = V4L2_MPEG_VIDEO_ASPECT_4x3;
> mc.count = i;
> ioctl(fd2, VIDIOC_S_EXT_CTRLS, &mc);
> 
> Anyone having troubles with VLC after 30 minutes ?
hey all, you can forget about this
my computer had troubles

-- 
CAND Frederic
Product Manager
ANEVIA

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
