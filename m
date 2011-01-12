Return-path: <mchehab@pedra>
Received: from mail-qy0-f174.google.com ([209.85.216.174]:36622 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932791Ab1ALEk0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 11 Jan 2011 23:40:26 -0500
Received: by qyj19 with SMTP id 19so3733780qyj.19
        for <linux-media@vger.kernel.org>; Tue, 11 Jan 2011 20:40:25 -0800 (PST)
Subject: Re: Enable IR on hdpvr
Mime-Version: 1.0 (Apple Message framework v1082)
Content-Type: text/plain; charset=us-ascii
From: Jarod Wilson <jarod@wilsonet.com>
In-Reply-To: <EC37FC85-82B2-48AE-BB94-64ED00E7647D@wilsonet.com>
Date: Tue, 11 Jan 2011 23:40:28 -0500
Cc: Jason Gauthier <jgauthier@lastar.com>, Janne Grunau <j@jannau.net>
Content-Transfer-Encoding: 8BIT
Message-Id: <93CE8497-D6AB-43BA-A239-EE32D51582FC@wilsonet.com>
References: <65DE7931C559BF4DBEE42C3F8246249A0B686EB0@V-EXMAILBOX.ctg.com> <8AFBEFD7-69E3-4E71-B155-EA773C2FED43@wilsonet.com> <65DE7931C559BF4DBEE42C3F8246249A0B69B014@V-ALBEXCHANGE.ctg.com> <EC37FC85-82B2-48AE-BB94-64ED00E7647D@wilsonet.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Jan 10, 2011, at 2:50 PM, Jarod Wilson wrote:

> On Jan 10, 2011, at 9:25 AM, Jason Gauthier wrote:
> 
>>>> 
>>>> I did simply try changing:
>>>> 
>>>>     /* until i2c is working properly */
>>>>     retval = 0; /* hdpvr_register_i2c_ir(dev); */
>>>>     if (retval < 0)
>>>> 
>>>> so that it would register with i2c.
>>>> Doing so returns a positive registration with I2C, but the lirc_zilog 
>>>> driver doesn't see the chip when it loads. (The lirc_zilog is now in 
>>>> the kernel, yay)
>> 
>>> There's a bit more to it than just the one line change. Here's the patch we're carrying in the Fedora kernels to enable it:
>> 
>>> http://wilsonet.com/jarod/lirc_misc/hdpvr-ir/hdpvr-ir-enable.patch
>> 
>>> Janne, I've heard many success stories w/the hdpvr IR lately, and almost no reports of lockups, so I'm thinking a firmware update may have helped out >here, and thus, maybe its time we just go ahead and push this patch along upstream? We still require someone to load lirc_zilog manually, so it seems like a >fairly low-risk thing to do.
>> 
>> Thanks.  What source tree is this against?  I see the patch is dated 09/2009.  Manually comparing to my .37 source tree it does not appear to match up.
>> I don't mind bringing in a third source tree to compare against to see if I can make this work on .37, I just don't know which one!
> 
> Bah. Yeah, sorry, that wasn't the current patch in Fedora 14. This is:
> 
> http://wilsonet.com/jarod/lirc_misc/hdpvr-ir/hdpvr-ir-enable-2.patch
> 
> Its atop the F14 2.6.35.10 kernel, which has a fairly recent v4l/dvb
> backport on top of it, so it should be pretty close to matching the
> current v4l/dvb code...

With the help of Andy Walls and Jean Delvare, I think we've hashed out
an updated patch that will work sitting atop the current v4l/dvb hdpvr
code, but I'm only just now getting around to compile-testing it, and
its past my bedtime, so it'll be tomorrow before I can do any sort of
functional testing (but hey, due to the snow, I'll be working from
home tomorrow, where my hdpvr happens to be...).

-- 
Jarod Wilson
jarod@wilsonet.com



