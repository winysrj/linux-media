Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtpd4.aruba.it ([62.149.128.209]:54277 "HELO smtp3.aruba.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1753444AbZBVL3e (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 22 Feb 2009 06:29:34 -0500
Message-ID: <49A13718.9050504@avalpa.com>
Date: Sun, 22 Feb 2009 12:29:28 +0100
From: Andrea Venturi <a.venturi@avalpa.com>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: Re: RFCv1: v4l-dvb development models & old kernel support
References: <200902211200.45373.hverkuil@xs4all.nl> <200902212347.47109.linux@baker-net.org.uk> <200902221105.26785.hverkuil@xs4all.nl>
In-Reply-To: <200902221105.26785.hverkuil@xs4all.nl>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hans Verkuil wrote:
> ...
> This would basically mean making a snapshot of the v4l-dvb repository, 
> calling it v4l-dvb-old and relying on people to update it with fixes. I did 
> think about this myself but I thought it unlikely that the old tree would 
> see much work, if at all. It's what they are admitting to on the wireless 
> site as well. This could be an option if we are faced with an incompatible 
> kernel change, but in this particular case it is my gut-feeling that 2.6.22 
> is old enough that people can just upgrade to that release.
>   

hi,
i know of some platforms where the linux kernel is stuck on a way older 
release as the HW producer is a bit picky (to say the least..).

i think about the embedded multimedia SOCs where linux is already 
winning hands down with regard to coverage and support BUT the industry 
still doesn't get really the idea behind the free software environment 
[*] and still gives away lots of binary blobs for the "proprietary HW" 
(so end users can tweak something but not really move over to modern 
kernels..).

here there are three examples i know of quite a bit:

- ST Microelectronics STi710x, DVB SOC, SH4 CPU based stuck on kernel 
2.6.17..

- Sigma Design SMP8634,  MIPS  based stuck on 2.6.15

- IBM Stb25xx  DVB SOC  PowerPc based stuck on 2.6.17

i'm sure there are really more like these and as they are targeting the 
multimedia environment (media center?), the large part of end users 
would like to add some gadget running on v4l-dvb drivers..

this is in my point of view at least a good reason to keep a snapshot of 
the latest v4l-dvb tree who has a bit of support for older kernel 
versions; the so called v4l-dvb-old idea already written about.

of course, the newer development should focus only on newer kernel to 
keep as low as possible the compatibility burden.

just my 2 cents. bye

Andrea Venturi



[*] it's of course the slow and painful path to consciousness of the 
limits of closed development model  when the open source and free (as 
freedom) scenario starts to reveal all the win-win convenience for all 
the parties involved, but it's same ol story and we are all well 
involved here in this kind of mindset, so don't want to repeat..

