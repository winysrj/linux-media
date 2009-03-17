Return-path: <linux-media-owner@vger.kernel.org>
Received: from yw-out-2324.google.com ([74.125.46.30]:21138 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754811AbZCQWPd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 17 Mar 2009 18:15:33 -0400
Received: by yw-out-2324.google.com with SMTP id 3so202733ywj.1
        for <linux-media@vger.kernel.org>; Tue, 17 Mar 2009 15:15:31 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1237327082.5040.174.camel@pete-desktop>
References: <c785bba30903031051k292a95aeq68d91e5c2bc31fd6@mail.gmail.com>
	 <1237327082.5040.174.camel@pete-desktop>
Date: Tue, 17 Mar 2009 15:10:07 -0700
Message-ID: <c785bba30903171510j5c1025f5hf238630612cf8662@mail.gmail.com>
Subject: Re: 4vl + usb + arm
From: Paul Thomas <pthomas8589@gmail.com>
To: Pete Eberlein <pete@sensoray.com>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Mar 17, 2009 at 2:58 PM, Pete Eberlein <pete@sensoray.com> wrote:
> On Tue, 2009-03-03 at 11:51 -0700, Paul Thomas wrote:
>> Hello, is anyone using a USB v4l device on an arm processor?
>
> While I haven't used a USB video device on an ARM board, I have tried
> cross compiling the v4l sources for ARM.  Here's what I found:
>
> The v4l/Makefile.media uses the host strip binary on the ARM .ko files,
> which doesn't work.  It could use $(CROSS_COMPILE)strip instead.  I
> worked around the problem using a strip soft-link to arm-eabi-strip in
> my cross tools bin directory.
>
> The v4l/firmware/Makefile assumes /lib/firmware, this could be
> $(DESTDIR)/lib/firmware instead.
>
> Here are the make commands I used to build the v4l tree:
>
> PATH=/path/to/devkitARM/bin:$PATH make ARCH=arm CROSS_COMPILE=arm-eabi-
> SRCDIR=/path/to/arm/kernel-src
>
> PATH=/path/to/devkitARM/bin:$PATH make ARCH=arm CROSS_COMPILE=arm-eabi-
> DESTDIR=/path/to/arm/sysroot install
>
> I'd like to know if modules built this way work on actual hardware.
>
> Regards.
> --
> Pete Eberlein
> Sensoray Co., Inc.
> Email: pete@sensoray.com
> http://www.sensoray.com
>
>

Pete,

I've been able to get the v4l tree to compile fine. I use the "make
release DIR=" to set the kernel DIR then make with the normal ARCH=
and CROSS_COMPILE=, and this seems to work correctly. Since I posted
we've had some limited success getting v4l devices working with arm.
The main problem now seems to be that the processor we're using
(at91rm9200) doesn't have a high-speed USB host.

I've been talking with some of the folks at sensoray (Danil &
Konstantin) about getting the 2251 or 2255 to work on our arm board.

thanks,
Paul
