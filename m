Return-path: <linux-media-owner@vger.kernel.org>
Received: from web94706.mail.in2.yahoo.com ([203.104.17.154]:33883 "HELO
	web94706.mail.in2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755792AbZKWJgq convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 23 Nov 2009 04:36:46 -0500
Message-ID: <271292.72699.qm@web94706.mail.in2.yahoo.com>
Date: Mon, 23 Nov 2009 15:00:09 +0530 (IST)
From: Purushottam R S <purushottam_r_s@yahoo.com>
Reply-To: Purushottam R S <purushottam_r_s@yahoo.com>
Subject: flicker/jumpy at the bottom of the video
To: linux-media@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi ,

I am using latest gspca driver from dvb for camera driver. But I see bottom of the video has flickering/jumping effect.

I have "Zippys" web camera, which is from Z-Star.  I have loaded the following drivers.
1. gspca_zc3xx 44832 0 - Live 0xbf01f000
2. gspca_main 23840 1 gspca_zc3xx, Live 0xbf014000
3. videodev 36672 1 gspca_main, Live 0xbf006000
4. v4l1_compat 14788 1 videodev, Live 0xbf000000

But otherwise there is no issue with video.

I tested using gst-launch pipeline.

regards
Purush



      The INTERNET now has a personality. YOURS! See your Yahoo! Homepage. http://in.yahoo.com/
