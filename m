Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-auth.no-ip.com ([8.23.224.61]:7437 "EHLO
	out.smtp-auth.no-ip.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753741Ab3F0VAc (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 27 Jun 2013 17:00:32 -0400
From: "Carl-Fredrik Sundstrom" <cf@blueflowamericas.com>
To: "'Steven Toth'" <stoth@kernellabs.com>
Cc: <linux-media@vger.kernel.org>
References: <010c01ce7365$9181ff30$b485fd90$@blueflowamericas.com> <CALzAhNW3A-EZ0-bXeno2-Zd-bxOM_D=TU7F+cN63CwmUTA7JDg@mail.gmail.com>
In-Reply-To: <CALzAhNW3A-EZ0-bXeno2-Zd-bxOM_D=TU7F+cN63CwmUTA7JDg@mail.gmail.com>
Subject: RE: lgdt3304
Date: Thu, 27 Jun 2013 16:00:12 -0500
Message-ID: <011201ce7379$51032240$f30966c0$@blueflowamericas.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Language: en-us
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


I found a datasheet for lgdt3305 it does indeed have a reset pin at pin 37
active low with internal pull up.
I will try to attach a probe to that pin and walk through all of the GPIO
until I find the right one.

I hope that lgdt3304 and lgdt3305 are pin compatible otherwise I might not
have much success.



-----Original Message-----
From: linux-media-owner@vger.kernel.org
[mailto:linux-media-owner@vger.kernel.org] On Behalf Of Steven Toth
Sent: Thursday, June 27, 2013 1:59 PM
To: Carl-Fredrik Sundstrom
Cc: linux-media@vger.kernel.org
Subject: Re: lgdt3304

> I get so far that I can load a basic driver by modifying the existing 
> saa716x driver, I can detect the TDA18271HD/C2, but I fail to detect 
> the
> LGDT3304 when attaching it using the 3305 driver.

A GPIO holding the 3304 in reset?

--
Steven Toth - Kernel Labs
http://www.kernellabs.com
--
To unsubscribe from this list: send the line "unsubscribe linux-media" in
the body of a message to majordomo@vger.kernel.org More majordomo info at
http://vger.kernel.org/majordomo-info.html

