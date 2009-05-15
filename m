Return-path: <linux-media-owner@vger.kernel.org>
Received: from acsinet12.oracle.com ([141.146.126.234]:55295 "EHLO
	acsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760400AbZEOD61 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 14 May 2009 23:58:27 -0400
Message-ID: <4A0CE8DF.7090608@oracle.com>
Date: Thu, 14 May 2009 21:00:31 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
MIME-Version: 1.0
To: Theodore Kilgore <kilgota@banach.math.auburn.edu>
CC: linux-media@vger.kernel.org
Subject: Re: How to interpret error codes for usb_control_msg()?
References: <alpine.LNX.2.00.0905142231110.11788@banach.math.auburn.edu>
In-Reply-To: <alpine.LNX.2.00.0905142231110.11788@banach.math.auburn.edu>
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Theodore Kilgore wrote:
> 
> Working on a driver for the Sonix SN9C2028 dual-mode cameras, I am
> confronted with the situation that certain usb_control_msg() functions
> are failing and returning -32. Does anyone know how to look up what -32
> is supposed to mean? It appears not to be in the standard errno.h file,
> so it would apparently be somewhere else. And the on-line man page for
> usb_control_msg does not seem totally helpful. It says
> 
> "If successful, it returns the number of bytes transferred; otherwise,
> it returns a negative error number."
> 
> but does not otherwise discuss the negative error numbers.
> 
> However, I am getting things like
> 
> f60a5680 1488371641 S Ci:5:022:0 s c1 00 0001 0000 0001 1 <
> f60a5680 1488373478 C Ci:5:022:0 -32 1 = 0c
> 
> using from the camera, and I do not quite know why. Incidentally, quite
> aside from the error message, the returned value is also a bit screwy.
> It ought to be 00 and for no obvious reason it is not. However, even if
> the returned value is correct, which also can sometimes happen, the
> error is still there.
> 
> Also the debug statement from dmesg consistently says (the corresponding
> function is called read1)
> 
> sn9c20: read1 error -32
> 
> But, what is essentially the same command works just fine in libgphoto2,
> giving debug output which looks like this
> 
> f14ca880 2936498715 S Ci:5:023:0 s c1 00 0001 0000 0001 1 <
> f14ca880 2936499630 C Ci:5:023:0 0 1 = 00
> 
> which shows no error and is doing what it should.
> 
> So if someone knows where the declarations of these error codes are, it
> might help me to track down what the problem is.

You'll need to look in 2 places.
Documentation/usb/error-codes.txt uses named error codes
and include/asm-generic/errno*.h converts names<->numbers.

So 32 is EPIPE (from errno-base.h) and error-codes.txt tells
what EPIPE is used for in usb-land.

-- 
~Randy
LPC 2009, Sept. 23-25, Portland, Oregon
http://linuxplumbersconf.org/2009/
