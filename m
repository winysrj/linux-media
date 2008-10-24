Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m9ONi4R6007930
	for <video4linux-list@redhat.com>; Fri, 24 Oct 2008 19:44:04 -0400
Received: from mail11b.verio-web.com (mail11b.verio-web.com [204.202.242.87])
	by mx3.redhat.com (8.13.8/8.13.8) with SMTP id m9ONhnqp026001
	for <video4linux-list@redhat.com>; Fri, 24 Oct 2008 19:43:49 -0400
Received: from mx17.stngva01.us.mxservers.net (204.202.242.70)
	by mail11b.verio-web.com (RS ver 1.0.95vs) with SMTP id 3-0281881828
	for <video4linux-list@redhat.com>; Fri, 24 Oct 2008 19:43:48 -0400 (EDT)
From: Pete Eberlein <pete@sensoray.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
In-Reply-To: <200810171736.53826.hverkuil@xs4all.nl>
References: <1224256911.6327.11.camel@pete-desktop>
	<200810171736.53826.hverkuil@xs4all.nl>
Content-Type: text/plain
Date: Fri, 24 Oct 2008 16:43:47 -0700
Message-Id: <1224891827.19159.17.camel@pete-desktop>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Cc: video4linux-list@redhat.com, Dean Anderson <dean@sensoray.com>
Subject: [PATCH] Add MPEG4 and Elementary streams (was Re: go7007
	development)
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

Hello Hans,

On Fri, 2008-10-17 at 17:36 +0200, Hans Verkuil wrote:
> All MPEG streams use V4L2_PIX_FMT_MPEG and set the exact stream type 
> through V4L2_CID_MPEG_STREAM_TYPE. You probably need to add a few new 
> stream types to this control for the elementary streams. I think 
> something like TYPE_MPEG_ELEM might do the trick, and then you can use 
> the audio and video encoding controls to select the precise audio/video 
> encoding.

Here is a patch that adds the two defines we need for the go7007 driver
extended MPEG controls.  Please consider it for inclusion in the v4l-dvb
tree.

V4L2_MPEG_STREAM_TYPE_MPEG_ELEM will be used for elementary MPEG
streams, whose type and encoding will be determined by examining a
header in the stream.  For more information, see
http://en.wikipedia.org/wiki/Elementary_stream

V4L2_MPEG_VIDEO_ENCODING_MPEG_4 will be used for MPEG-4 Part 2 (Simple
Profile, Advanced Simple Profile, etc) encoding.  This is not the same
as MPEG-4 AVC (Part 10, Advanced Video Coding).

Thanks.
-- 
Pete Eberlein
Sensoray Co., Inc.
Email: pete@sensoray.com
http://www.sensoray.com


Signed-off-by: Pete Eberlein <pete@sensoray.com>
---

diff -r fe810917c6ca linux/include/linux/videodev2.h
--- a/linux/include/linux/videodev2.h	Fri Oct 24 13:19:14 2008 -0200
+++ b/linux/include/linux/videodev2.h	Fri Oct 24 09:57:46 2008 -0700
@@ -892,6 +892,7 @@ enum v4l2_mpeg_stream_type {
 	V4L2_MPEG_STREAM_TYPE_MPEG2_DVD  = 3, /* MPEG-2 DVD-compatible stream */
 	V4L2_MPEG_STREAM_TYPE_MPEG1_VCD  = 4, /* MPEG-1 VCD-compatible stream */
 	V4L2_MPEG_STREAM_TYPE_MPEG2_SVCD = 5, /* MPEG-2 SVCD-compatible stream */
+	V4L2_MPEG_STREAM_TYPE_MPEG_ELEM  = 6, /* MPEG elementary stream */
 };
 #define V4L2_CID_MPEG_STREAM_PID_PMT 		(V4L2_CID_MPEG_BASE+1)
 #define V4L2_CID_MPEG_STREAM_PID_AUDIO 		(V4L2_CID_MPEG_BASE+2)
@@ -1027,6 +1028,7 @@ enum v4l2_mpeg_video_encoding {
 	V4L2_MPEG_VIDEO_ENCODING_MPEG_1     = 0,
 	V4L2_MPEG_VIDEO_ENCODING_MPEG_2     = 1,
 	V4L2_MPEG_VIDEO_ENCODING_MPEG_4_AVC = 2,
+	V4L2_MPEG_VIDEO_ENCODING_MPEG_4     = 3,
 };
 #define V4L2_CID_MPEG_VIDEO_ASPECT 		(V4L2_CID_MPEG_BASE+201)
 enum v4l2_mpeg_video_aspect {

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
