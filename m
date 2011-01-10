Return-path: <mchehab@pedra>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:63691 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751565Ab1AJTt5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 10 Jan 2011 14:49:57 -0500
Received: by vws16 with SMTP id 16so8256721vws.19
        for <linux-media@vger.kernel.org>; Mon, 10 Jan 2011 11:49:56 -0800 (PST)
References: <65DE7931C559BF4DBEE42C3F8246249A0B686EB0@V-EXMAILBOX.ctg.com> <8AFBEFD7-69E3-4E71-B155-EA773C2FED43@wilsonet.com> <65DE7931C559BF4DBEE42C3F8246249A0B69B014@V-ALBEXCHANGE.ctg.com>
In-Reply-To: <65DE7931C559BF4DBEE42C3F8246249A0B69B014@V-ALBEXCHANGE.ctg.com>
Mime-Version: 1.0 (Apple Message framework v1082)
Content-Type: text/plain; charset=us-ascii
Message-Id: <EC37FC85-82B2-48AE-BB94-64ED00E7647D@wilsonet.com>
Content-Transfer-Encoding: 8BIT
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Janne Grunau <j@jannau.net>
From: Jarod Wilson <jarod@wilsonet.com>
Subject: Re: Enable IR on hdpvr
Date: Mon, 10 Jan 2011 14:50:06 -0500
To: Jason Gauthier <jgauthier@lastar.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Jan 10, 2011, at 9:25 AM, Jason Gauthier wrote:

>>> 
>>> I did simply try changing:
>>> 
>>>      /* until i2c is working properly */
>>>      retval = 0; /* hdpvr_register_i2c_ir(dev); */
>>>      if (retval < 0)
>>> 
>>> so that it would register with i2c.
>>> Doing so returns a positive registration with I2C, but the lirc_zilog 
>>> driver doesn't see the chip when it loads. (The lirc_zilog is now in 
>>> the kernel, yay)
> 
>> There's a bit more to it than just the one line change. Here's the patch we're carrying in the Fedora kernels to enable it:
> 
>> http://wilsonet.com/jarod/lirc_misc/hdpvr-ir/hdpvr-ir-enable.patch
> 
>> Janne, I've heard many success stories w/the hdpvr IR lately, and almost no reports of lockups, so I'm thinking a firmware update may have helped out >here, and thus, maybe its time we just go ahead and push this patch along upstream? We still require someone to load lirc_zilog manually, so it seems like a >fairly low-risk thing to do.
> 
> Thanks.  What source tree is this against?  I see the patch is dated 09/2009.  Manually comparing to my .37 source tree it does not appear to match up.
> I don't mind bringing in a third source tree to compare against to see if I can make this work on .37, I just don't know which one!

Bah. Yeah, sorry, that wasn't the current patch in Fedora 14. This is:

http://wilsonet.com/jarod/lirc_misc/hdpvr-ir/hdpvr-ir-enable-2.patch

Its atop the F14 2.6.35.10 kernel, which has a fairly recent v4l/dvb
backport on top of it, so it should be pretty close to matching the
current v4l/dvb code...


-- 
Jarod Wilson
jarod@wilsonet.com



