Return-path: <mchehab@pedra>
Received: from mail.projectit.net ([64.129.117.10]:48737 "EHLO mail.lastar.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752350Ab1AJOZU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 10 Jan 2011 09:25:20 -0500
From: Jason Gauthier <jgauthier@lastar.com>
To: Jarod Wilson <jarod@wilsonet.com>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Janne Grunau <j@jannau.net>
Subject: RE: Enable IR on hdpvr
Date: Mon, 10 Jan 2011 14:25:17 +0000
Message-ID: <65DE7931C559BF4DBEE42C3F8246249A0B69B014@V-ALBEXCHANGE.ctg.com>
References: <65DE7931C559BF4DBEE42C3F8246249A0B686EB0@V-EXMAILBOX.ctg.com>
 <8AFBEFD7-69E3-4E71-B155-EA773C2FED43@wilsonet.com>
In-Reply-To: <8AFBEFD7-69E3-4E71-B155-EA773C2FED43@wilsonet.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

>> 
>> I did simply try changing:
>> 
>>       /* until i2c is working properly */
>>       retval = 0; /* hdpvr_register_i2c_ir(dev); */
>>       if (retval < 0)
>> 
>> so that it would register with i2c.
>> Doing so returns a positive registration with I2C, but the lirc_zilog 
>> driver doesn't see the chip when it loads. (The lirc_zilog is now in 
>> the kernel, yay)

>There's a bit more to it than just the one line change. Here's the patch we're carrying in the Fedora kernels to enable it:

>http://wilsonet.com/jarod/lirc_misc/hdpvr-ir/hdpvr-ir-enable.patch

>Janne, I've heard many success stories w/the hdpvr IR lately, and almost no reports of lockups, so I'm thinking a firmware update may have helped out >here, and thus, maybe its time we just go ahead and push this patch along upstream? We still require someone to load lirc_zilog manually, so it seems like a >fairly low-risk thing to do.

Thanks.  What source tree is this against?  I see the patch is dated 09/2009.  Manually comparing to my .37 source tree it does not appear to match up.
I don't mind bringing in a third source tree to compare against to see if I can make this work on .37, I just don't know which one!

