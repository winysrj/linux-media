Return-path: <linux-media-owner@vger.kernel.org>
Received: from ms01.sssup.it ([193.205.80.99]:40178 "EHLO sssup.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753954AbZKWPbP (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 23 Nov 2009 10:31:15 -0500
Message-ID: <4B0AAAC4.4060605@panicking.kicks-ass.org>
Date: Mon, 23 Nov 2009 16:31:16 +0100
From: Michael Trimarchi <michael@panicking.kicks-ass.org>
MIME-Version: 1.0
To: Purushottam R S <purushottam_r_s@yahoo.com>
CC: linux-media@vger.kernel.org
Subject: Re: flicker/jumpy at the bottom of the video
References: <271292.72699.qm@web94706.mail.in2.yahoo.com>
In-Reply-To: <271292.72699.qm@web94706.mail.in2.yahoo.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

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

