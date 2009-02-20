Return-path: <linux-media-owner@vger.kernel.org>
Received: from yw-out-2324.google.com ([74.125.46.29]:49855 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753292AbZBTS6L (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 20 Feb 2009 13:58:11 -0500
Received: by yw-out-2324.google.com with SMTP id 5so409365ywh.1
        for <linux-media@vger.kernel.org>; Fri, 20 Feb 2009 10:58:10 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <499EF291.8070906@messagenetsystems.com>
References: <412bdbff0902200317h26f4d42fh4327b3ff08c79d5c@mail.gmail.com>
	 <499EC9CC.3040703@linuxtv.org>
	 <b24e53350902200910p1f5745b6s864490400f50b9@mail.gmail.com>
	 <b24e53350902200911udfb9717t5429dd2b9fc81355@mail.gmail.com>
	 <b24e53350902200913h3760ccbdqc9f14217afe5fdb1@mail.gmail.com>
	 <412bdbff0902200918g328b8541v5414ad98ead688a2@mail.gmail.com>
	 <499EF291.8070906@messagenetsystems.com>
Date: Fri, 20 Feb 2009 13:58:10 -0500
Message-ID: <412bdbff0902201058m380a798egbbc9f9792e55569f@mail.gmail.com>
Subject: Re: HVR-950q analog support - testers wanted
From: Devin Heitmueller <devin.heitmueller@gmail.com>
To: Robert Vincent Krakora <rob.krakora@messagenetsystems.com>
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Feb 20, 2009 at 1:12 PM, Robert Vincent Krakora
<rob.krakora@messagenetsystems.com> wrote:
> I tried one HVR950Q device on one my mediaports and I got a lock up once and
> then a lockup with a kernel oops a few minutes later.  It seems to load the
> firmware and tune correctly but has trouble playing video and audio.

Ok, let's try a couple of things:

Can you get an full stack trace of the oops, using perhaps a serial console?

Can you identify how reproducible the issue is?  Does it happen every
time?  Does it occur when the device is plugged in, or when you start
your application?

What application were you using when the problem occurred?

It looks like the device was connected when the system was booted.
Could you please boot up the system without the device connected and
see if the issue still occurs?

Thanks,

-- 
Devin J. Heitmueller
http://www.devinheitmueller.com
AIM: devinheitmueller
