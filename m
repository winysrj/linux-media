Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-gx0-f160.google.com ([209.85.217.160]:63700 "EHLO
	mail-gx0-f160.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751032AbZCQWNl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 17 Mar 2009 18:13:41 -0400
Received: by gxk4 with SMTP id 4so243665gxk.13
        for <linux-media@vger.kernel.org>; Tue, 17 Mar 2009 15:13:38 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1237327082.5040.174.camel@pete-desktop>
References: <c785bba30903031051k292a95aeq68d91e5c2bc31fd6@mail.gmail.com>
	 <1237327082.5040.174.camel@pete-desktop>
Date: Tue, 17 Mar 2009 18:13:38 -0400
Message-ID: <412bdbff0903171513k161f32dfkc37e5b46c0b527e0@mail.gmail.com>
Subject: Re: 4vl + usb + arm
From: Devin Heitmueller <devin.heitmueller@gmail.com>
To: Pete Eberlein <pete@sensoray.com>
Cc: Paul Thomas <pthomas8589@gmail.com>, linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Mar 17, 2009 at 5:58 PM, Pete Eberlein <pete@sensoray.com> wrote:
> The v4l/Makefile.media uses the host strip binary on the ARM .ko files,
> which doesn't work.  It could use $(CROSS_COMPILE)strip instead.  I
> worked around the problem using a strip soft-link to arm-eabi-strip in
> my cross tools bin directory.

I ran into the issue with strip, and just worked around it by putting
the cross compiler's bin directory into the path.  If you have a patch
though that fixes it the "right" way, feel free to submit a patch.

> I'd like to know if modules built this way work on actual hardware.

Generally speaking, yes they do work.  I did some work with a couple
of different devices under ARM, and although there are bugs (which I
am preparing patches for), the drivers basically worked as expected.

Regards,

Devin

-- 
Devin J. Heitmueller
http://www.devinheitmueller.com
AIM: devinheitmueller
