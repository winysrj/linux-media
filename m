Return-path: <mchehab@pedra>
Received: from proofpoint-cluster.metrocast.net ([65.175.128.136]:59175 "EHLO
	proofpoint-cluster.metrocast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754698Ab1ALXoZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 12 Jan 2011 18:44:25 -0500
Subject: RE: Enable IR on hdpvr
From: Andy Walls <awalls@md.metrocast.net>
To: Jason Gauthier <jgauthier@lastar.com>
Cc: Jarod Wilson <jarod@wilsonet.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Janne Grunau <j@jannau.net>
In-Reply-To: <65DE7931C559BF4DBEE42C3F8246249A0B6A54C7@V-ALBEXCHANGE.ctg.com>
References: <65DE7931C559BF4DBEE42C3F8246249A0B686EB0@V-EXMAILBOX.ctg.com>
	 <8AFBEFD7-69E3-4E71-B155-EA773C2FED43@wilsonet.com>
	 <65DE7931C559BF4DBEE42C3F8246249A0B69B014@V-ALBEXCHANGE.ctg.com>
	 <EC37FC85-82B2-48AE-BB94-64ED00E7647D@wilsonet.com>
	 <93CE8497-D6AB-43BA-A239-EE32D51582FC@wilsonet.com>
	 <65DE7931C559BF4DBEE42C3F8246249A0B6A54C7@V-ALBEXCHANGE.ctg.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 12 Jan 2011 18:45:02 -0500
Message-ID: <1294875902.2485.19.camel@morgan.silverblock.net>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Wed, 2011-01-12 at 13:49 +0000, Jason Gauthier wrote:
> >> 
> >> Bah. Yeah, sorry, that wasn't the current patch in Fedora 14. This is:
> >> 
> >> http://wilsonet.com/jarod/lirc_misc/hdpvr-ir/hdpvr-ir-enable-2.patch
> >> 
> >> Its atop the F14 2.6.35.10 kernel, which has a fairly recent v4l/dvb 
> >> backport on top of it, so it should be pretty close to matching the 
> >> current v4l/dvb code...
> 
> >With the help of Andy Walls and Jean Delvare, I think we've hashed
> out an updated patch that will work sitting atop the current v4l/dvb
> hdpvr code, but I'm only just now getting around to compile->testing
> it, and its past my bedtime, so it'll be tomorrow before I can do any
> sort of functional testing (but hey, due to the snow, I'll be working
> from home tomorrow, where my hdpvr happens to be...).
> 
> I've got two hdpvrs.  Whenever you're ready to extend your testing,
> I'm happy to extend that functional testing.  I didn't get a chance to
> look at the FC14 patch yet (busy couple of days), but I will hold off
> now, anyway!

If all goes well, with Jarrod's change, you should be able to test the
hdpvr module with the ir-kbd-i2c module and test IR Rx.

Strictly speaking, lirc_zilog needs some rework to use the kernel
internal interfaces properly.  It might still work, but don't be
surprised if it doesn't.

I might get to working on lirc_zilog tonight, but otherwise not until
this weekend.

Regards,
Andy

