Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail11d.verio-web.com ([204.202.242.86]:6559 "HELO
	mail11d.verio-web.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751280AbZCQWEv (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 17 Mar 2009 18:04:51 -0400
Received: from mx91.stngva01.us.mxservers.net (198.173.112.8)
	by mail11d.verio-web.com (RS ver 1.0.95vs) with SMTP id 2-0542687087
	for <linux-media@vger.kernel.org>; Tue, 17 Mar 2009 17:58:09 -0400 (EDT)
Subject: Re: 4vl + usb + arm
From: Pete Eberlein <pete@sensoray.com>
To: Paul Thomas <pthomas8589@gmail.com>
Cc: linux-media@vger.kernel.org
In-Reply-To: <c785bba30903031051k292a95aeq68d91e5c2bc31fd6@mail.gmail.com>
References: <c785bba30903031051k292a95aeq68d91e5c2bc31fd6@mail.gmail.com>
Content-Type: text/plain
Date: Tue, 17 Mar 2009 14:58:02 -0700
Message-Id: <1237327082.5040.174.camel@pete-desktop>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, 2009-03-03 at 11:51 -0700, Paul Thomas wrote:
> Hello, is anyone using a USB v4l device on an arm processor?

While I haven't used a USB video device on an ARM board, I have tried
cross compiling the v4l sources for ARM.  Here's what I found:

The v4l/Makefile.media uses the host strip binary on the ARM .ko files,
which doesn't work.  It could use $(CROSS_COMPILE)strip instead.  I
worked around the problem using a strip soft-link to arm-eabi-strip in
my cross tools bin directory.

The v4l/firmware/Makefile assumes /lib/firmware, this could be
$(DESTDIR)/lib/firmware instead.

Here are the make commands I used to build the v4l tree:

PATH=/path/to/devkitARM/bin:$PATH make ARCH=arm CROSS_COMPILE=arm-eabi-
SRCDIR=/path/to/arm/kernel-src

PATH=/path/to/devkitARM/bin:$PATH make ARCH=arm CROSS_COMPILE=arm-eabi-
DESTDIR=/path/to/arm/sysroot install

I'd like to know if modules built this way work on actual hardware.

Regards.
-- 
Pete Eberlein
Sensoray Co., Inc.
Email: pete@sensoray.com
http://www.sensoray.com

