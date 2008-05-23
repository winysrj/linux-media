Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m4N9BfqY024028
	for <video4linux-list@redhat.com>; Fri, 23 May 2008 05:11:41 -0400
Received: from ciao.gmane.org (main.gmane.org [80.91.229.2])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m4N9BCSC023590
	for <video4linux-list@redhat.com>; Fri, 23 May 2008 05:11:20 -0400
Received: from list by ciao.gmane.org with local (Exim 4.43)
	id 1JzTIp-0004Nb-Dm
	for video4linux-list@redhat.com; Fri, 23 May 2008 09:11:07 +0000
Received: from 82-135-208-232.static.zebra.lt ([82.135.208.232])
	by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
	id 1AlnuQ-0007hv-00
	for <video4linux-list@redhat.com>; Fri, 23 May 2008 09:11:07 +0000
Received: from augulis.darius by 82-135-208-232.static.zebra.lt with local
	(Gmexim 0.1 (Debian)) id 1AlnuQ-0007hv-00
	for <video4linux-list@redhat.com>; Fri, 23 May 2008 09:11:07 +0000
To: video4linux-list@redhat.com
From: Darius <augulis.darius@gmail.com>
Date: Fri, 23 May 2008 12:05:33 +0300
Message-ID: <g161n1$vmf$1@ger.gmane.org>
References: <g09j17$3m9$1@ger.gmane.org>	<Pine.LNX.4.64.0805122030310.5526@axis700.grange>	<g0bjtj$b0d$1@ger.gmane.org>	<Pine.LNX.4.64.0805132212530.4988@axis700.grange>	<g0hhpt$jfp$1@ger.gmane.org>	<Pine.LNX.4.64.0805152121210.14292@axis700.grange>	<g13s6k$a2c$1@ger.gmane.org>
	<Pine.LNX.4.64.0805222105360.8800@axis700.grange>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-13; format=flowed
Content-Transfer-Encoding: 7bit
In-Reply-To: <Pine.LNX.4.64.0805222105360.8800@axis700.grange>
Subject: Re: question about SoC Camera driver (Micron)
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


> Please, tell me exactly where you suspect bugs. soc_camera.c, 
> pxa_camera.c, mt9?0??.c all have *try_fmt_cap().

I see, but try_fmt_cap does not return camera capabilities, it only tries pixel format, without driver state changing.
Maybe it is good idea to implement additional g_fmt_cap ioctl handler in soc_camera? Or instead try_fmt_cap?
Because s_fmt_cap is for fmt setting, g_fmt_cap for getting camera fmt capabilities, and try_fmt_cap is for what? For getting fmt too?
v4l2 documentation recommends not implement this ioctl in the driver.

> 
>> btw, can you tell something about frame rate setting? how to implement that?
>> for example, I want from user space adjust frame rate (4, 15, 25, 30fps...).
>> Should I pass these setting to sensor driver via *_set_fmt_cap()?
> 
> This is not supported.
> 

I think should be not hard to implement vidioc_g_parm and vidioc_s_parm in soc_camera to support frame rate setting?
Now I'm writing driver for OV7670, and I plan to add these features (frame rate setting and g_fmt_cap) to soc_camera driver.
What is your opinion?

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
