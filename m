Return-path: <linux-media-owner@vger.kernel.org>
Received: from web94702.mail.in2.yahoo.com ([203.104.17.138]:27535 "HELO
	web94702.mail.in2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S932300AbZKXIxp convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 24 Nov 2009 03:53:45 -0500
Message-ID: <947768.69880.qm@web94702.mail.in2.yahoo.com>
Date: Tue, 24 Nov 2009 14:23:47 +0530 (IST)
From: Purushottam R S <purushottam_r_s@yahoo.com>
Reply-To: Purushottam R S <purushottam_r_s@yahoo.com>
Subject: v4l2src output in YUV I420..possible ..?
To: linux-media@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi All,

Is it possible to get the camera output (v4l2src) in YUV I420 format. Older version of gspca (v4lsrc) was giving in this format.

But Now Output of camera (v4l2src) is in jpeg format. My pipeline to record video looks like this:
(I have to convert twice before encoding),
     camera gives jpeg  ==> Decode Jpeg ==>YUV Y42B ==>  Convert to YUV I420 ==> Then encode....

gst-launch-0.10 v4l2src ! image/jpeg,width=320,height=240,framerate=15/1 !  ffdec_mjpeg ! ffmpegcolorspace ! 
video/x-raw-yuv,width=320,height=240,format='(fourcc)I420' !  ffenc_h263p ! .... and so on...

regards
Purush



      The INTERNET now has a personality. YOURS! See your Yahoo! Homepage. http://in.yahoo.com/
