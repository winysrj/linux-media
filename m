Return-path: <linux-media-owner@vger.kernel.org>
Received: from acsinet11.oracle.com ([141.146.126.233]:44810 "EHLO
	acsinet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753398AbZEOF2z (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 15 May 2009 01:28:55 -0400
Message-ID: <4A0CFE15.4060608@oracle.com>
Date: Thu, 14 May 2009 22:31:01 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
MIME-Version: 1.0
To: Theodore Kilgore <kilgota@banach.math.auburn.edu>
CC: Randy Dunlap <randy.dunlap@oracle.com>, linux-media@vger.kernel.org
Subject: Re: How to interpret error codes for usb_control_msg()?
References: <alpine.LNX.2.00.0905142231110.11788@banach.math.auburn.edu> <4A0CE8DF.7090608@oracle.com> <alpine.LNX.2.00.0905142350290.11882@banach.math.auburn.edu>
In-Reply-To: <alpine.LNX.2.00.0905142350290.11882@banach.math.auburn.edu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Theodore Kilgore wrote:
> 
> 
> On Thu, 14 May 2009, Randy Dunlap wrote:
> 
>> Theodore Kilgore wrote:
>>>
>>> Working on a driver for the Sonix SN9C2028 dual-mode cameras, I am
>>> confronted with the situation that certain usb_control_msg() functions
>>> are failing and returning -32. Does anyone know how to look up what -32
>>> is supposed to mean? It appears not to be in the standard errno.h file,
>>> so it would apparently be somewhere else. And the on-line man page for
>>> usb_control_msg does not seem totally helpful. It says
>>>
>>> "If successful, it returns the number of bytes transferred; otherwise,
>>> it returns a negative error number."
>>>
>>> but does not otherwise discuss the negative error numbers.
>>>
>>> However, I am getting things like
>>>
>>> f60a5680 1488371641 S Ci:5:022:0 s c1 00 0001 0000 0001 1 <
>>> f60a5680 1488373478 C Ci:5:022:0 -32 1 = 0c
>>>
>>> using from the camera, and I do not quite know why. Incidentally, quite
>>> aside from the error message, the returned value is also a bit screwy.
>>> It ought to be 00 and for no obvious reason it is not. However, even if
>>> the returned value is correct, which also can sometimes happen, the
>>> error is still there.
>>>
>>> Also the debug statement from dmesg consistently says (the corresponding
>>> function is called read1)
>>>
>>> sn9c20: read1 error -32
>>>
>>> But, what is essentially the same command works just fine in libgphoto2,
>>> giving debug output which looks like this
>>>
>>> f14ca880 2936498715 S Ci:5:023:0 s c1 00 0001 0000 0001 1 <
>>> f14ca880 2936499630 C Ci:5:023:0 0 1 = 00
>>>
>>> which shows no error and is doing what it should.
>>>
>>> So if someone knows where the declarations of these error codes are, it
>>> might help me to track down what the problem is.
>>
>> You'll need to look in 2 places.
>> Documentation/usb/error-codes.txt uses named error codes
>> and include/asm-generic/errno*.h converts names<->numbers.
>>
>> So 32 is EPIPE (from errno-base.h) and error-codes.txt tells
>> what EPIPE is used for in usb-land.
> 
> Thanks. I looked it up now in error-codes.txt and I am still mystfied,
> unfortunately. It says there
> 
> -EPIPE (**)             Endpoint stalled.  For non-control endpoints,
>                         reset this status with usb_clear_halt().
> 
> Well, it *is* a control pipe, so now what?

It's still Endpoint stalled.  The other sentence (For ...) just
does not apply to your case.

> The (**) refers to
> 
> (**) This is also one of several codes that different kinds of host
> controller use to indicate a transfer has failed because of device
> disconnect.  In the interval before the hub driver starts disconnect
> processing, devices may receive such fault reports for every request.
> 
> Well, the device did not otherwise appear to get disconnected. The
> command sent is, basically, one of those "ping the camera" commands. As
> pointed out, it works just fine if called (more indirectly, of course)
> from libgphoto2, through libusb.
> 
> 
> Of course, I could get something syntactically wrong when constructing
> the commands. However, comparing
> 
>>> f60a5680 1488371641 S Ci:5:022:0 s c1 00 0001 0000 0001 1 <
>>> f60a5680 1488373478 C Ci:5:022:0 -32 1 = 0c
> (from the embryonic sn9c2028 module)
> 
> with
> 
>>> f14ca880 2936498715 S Ci:5:023:0 s c1 00 0001 0000 0001 1 <
>>> f14ca880 2936499630 C Ci:5:023:0 0 1 = 00
> (originating from libgphoto2/camlibs/sonix, with the same camera plugged
> in)
> 
> would surely indicate that the command was given the same way in both
> cases.
> 
> So, thanks, Randy,  for pointing my nose in the right direction to
> decipher the -32 error.
> 
> But now, I am more puzzled than ever because I still can not figure out
> how *that* could happen.
> 
> Anyone have any good and clever ideas?


I suggest that you ask on the USB mailing list (linux-usb@vger.kernel.org).

-- 
~Randy
LPC 2009, Sept. 23-25, Portland, Oregon
http://linuxplumbersconf.org/2009/
