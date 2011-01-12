Return-path: <mchehab@pedra>
Received: from mail3.lastar.com ([74.84.105.102]:22394 "EHLO mail.lastar.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932356Ab1ALNt4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 12 Jan 2011 08:49:56 -0500
From: Jason Gauthier <jgauthier@lastar.com>
To: Jarod Wilson <jarod@wilsonet.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
CC: Janne Grunau <j@jannau.net>
Subject: RE: Enable IR on hdpvr
Date: Wed, 12 Jan 2011 13:49:52 +0000
Message-ID: <65DE7931C559BF4DBEE42C3F8246249A0B6A54C7@V-ALBEXCHANGE.ctg.com>
References: <65DE7931C559BF4DBEE42C3F8246249A0B686EB0@V-EXMAILBOX.ctg.com>
 <8AFBEFD7-69E3-4E71-B155-EA773C2FED43@wilsonet.com>
 <65DE7931C559BF4DBEE42C3F8246249A0B69B014@V-ALBEXCHANGE.ctg.com>
 <EC37FC85-82B2-48AE-BB94-64ED00E7647D@wilsonet.com>
 <93CE8497-D6AB-43BA-A239-EE32D51582FC@wilsonet.com>
In-Reply-To: <93CE8497-D6AB-43BA-A239-EE32D51582FC@wilsonet.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

>> 
>> Bah. Yeah, sorry, that wasn't the current patch in Fedora 14. This is:
>> 
>> http://wilsonet.com/jarod/lirc_misc/hdpvr-ir/hdpvr-ir-enable-2.patch
>> 
>> Its atop the F14 2.6.35.10 kernel, which has a fairly recent v4l/dvb 
>> backport on top of it, so it should be pretty close to matching the 
>> current v4l/dvb code...

>With the help of Andy Walls and Jean Delvare, I think we've hashed out an updated patch that will work sitting atop the current v4l/dvb hdpvr code, but I'm only just now getting around to compile->testing it, and its past my bedtime, so it'll be tomorrow before I can do any sort of functional testing (but hey, due to the snow, I'll be working from home tomorrow, where my hdpvr happens to be...).

I've got two hdpvrs.  Whenever you're ready to extend your testing, I'm happy to extend that functional testing.  I didn't get a chance to look at the FC14 patch yet (busy couple of days), but I will hold off now, anyway!
