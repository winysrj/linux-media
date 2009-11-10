Return-path: <linux-media-owner@vger.kernel.org>
Received: from static-88-194-224-77.ipcom.comunitel.net ([77.224.194.88]:44809
	"EHLO panicking.kicks-ass.org" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1757165AbZKJQzN (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 10 Nov 2009 11:55:13 -0500
Message-ID: <4AF99A03.7070303@panicking.kicks-ass.org>
Date: Tue, 10 Nov 2009 17:51:15 +0100
From: Michael Trimarchi <michael@panicking.kicks-ass.org>
MIME-Version: 1.0
To: Randy Dunlap <rdunlap@xenotime.net>
CC: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: ov538-ov7690
References: <4AF89498.3000103@panicking.kicks-ass.org>	<4AF93DE5.6060901@panicking.kicks-ass.org> <20091110081000.9e7c7717.rdunlap@xenotime.net>
In-Reply-To: <20091110081000.9e7c7717.rdunlap@xenotime.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

Randy Dunlap wrote:
> On Tue, 10 Nov 2009 11:18:13 +0100 Michael Trimarchi wrote:
> 
>> Hi,
>>
>> Michael Trimarchi wrote:
>>> Hi all
>>>
>>> I'm working on the ov538 bridge with the ov7690 camera connected. 
>>> Somentimes I receive
>>>
>>> [ 1268.146705] gspca: ISOC data error: [110] len=1020, status=-71
>>> [ 1270.946739] gspca: ISOC data error: [114] len=1020, status=-71
>>> [ 1271.426689] gspca: ISOC data error: [82] len=1020, status=-71
>>> [ 1273.314640] gspca: ISOC data error: [1] len=1020, status=-71
>>> [ 1274.114661] gspca: ISOC data error: [17] len=1020, status=-71
>>> [ 1274.658718] gspca: ISOC data error: [125] len=1020, status=-71
>>> [ 1274.834666] gspca: ISOC data error: [21] len=1020, status=-71
>>> [ 1275.666684] gspca: ISOC data error: [94] len=1020, status=-71
>>> [ 1275.826645] gspca: ISOC data error: [40] len=1020, status=-71
>>> [ 1276.226721] gspca: ISOC data error: [100] len=1020, status=-71
>>>
>>> This error from the usb, how are they related to the camera?
> 
> -71 = -EPROTO (from include/asm-generic/errno.h).
> 
> -EPROTO in USB drivers means (from Documentation/usb/error-codes.txt):
> 
> -EPROTO (*, **)		a) bitstuff error
> 			b) no response packet received within the
> 			   prescribed bus turn-around time
> 			c) unknown USB error
> 
> footnotes:
> (*) Error codes like -EPROTO, -EILSEQ and -EOVERFLOW normally indicate
> hardware problems such as bad devices (including firmware) or cables.
> 

OK, but it's a failure of the ehci transaction on my laptop and seems that is
not so frequent. I think that can be a cable problem.

> (**) This is also one of several codes that different kinds of host
> controller use to indicate a transfer has failed because of device
> disconnect.  In the interval before the hub driver starts disconnect
> processing, devices may receive such fault reports for every request.
> 
> 
>> Ok, this is not a big issue because I can use vlc to test the camera. But anybody
>> knows why camorama, camstream, cheese crash during test. is it driver depend? or not?
> 
> Could be driver.  Easily could be a device problem too.

I think that it can be a vl2 vl1 problem. Because now I can manage in skype too using
the v4l1-compat library. Maybe my 2.6.32-rc5 is too new :(

Michael

> 
> ---
> ~Randy
> 

