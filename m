Return-path: <linux-media-owner@vger.kernel.org>
Received: from web94703.mail.in2.yahoo.com ([203.104.17.142]:32953 "HELO
	web94703.mail.in2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750930AbZKXHje convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 24 Nov 2009 02:39:34 -0500
Message-ID: <644170.21342.qm@web94703.mail.in2.yahoo.com>
References: <271292.72699.qm@web94706.mail.in2.yahoo.com> <4B0AAAC4.4060605@panicking.kicks-ass.org>
Date: Tue, 24 Nov 2009 13:09:38 +0530 (IST)
From: Purushottam R S <purushottam_r_s@yahoo.com>
Reply-To: Purushottam R S <purushottam_r_s@yahoo.com>
Subject: Re: flicker/jumpy at the bottom of the video
To: Michael Trimarchi <michael@panicking.kicks-ass.org>
Cc: linux-media@vger.kernel.org
In-Reply-To: <4B0AAAC4.4060605@panicking.kicks-ass.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Added following property to pipeline, now it is better,

v4l2src always-copy=0 queue-size=4

regards
Purush

----- Original Message ----
From: Michael Trimarchi <michael@panicking.kicks-ass.org>
To: Purushottam R S <purushottam_r_s@yahoo.com>
Cc: linux-media@vger.kernel.org
Sent: Mon, 23 November, 2009 9:01:16 PM
Subject: Re: flicker/jumpy at the bottom of the video

Purushottam R S wrote:
> Hi ,
> 
> I am using latest gspca driver from dvb for camera driver. But I see bottom of the video has flickering/jumping effect.
> 
> I have "Zippys" web camera, which is from Z-Star.  I have loaded the following drivers.
> 1. gspca_zc3xx 44832 0 - Live 0xbf01f000
> 2. gspca_main 23840 1 gspca_zc3xx, Live 0xbf014000
> 3. videodev 36672 1 gspca_main, Live 0xbf006000
> 4. v4l1_compat 14788 1 videodev, Live 0xbf000000
> 
> But otherwise there is no issue with video.
> 
> I tested using gst-launch pipeline.

Can you try using vlc application. I have the same effect using v4l1 compat api

Michael

> 
> regards
> Purush
> 
> 
> 
>       The INTERNET now has a personality. YOURS! See your Yahoo! Homepage. http://in.yahoo.com/
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 


      The INTERNET now has a personality. YOURS! See your Yahoo! Homepage. http://in.yahoo.com/
