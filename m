Return-path: <mchehab@pedra>
Received: from proofpoint-cluster.metrocast.net ([65.175.128.136]:23440 "EHLO
	proofpoint-cluster.metrocast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750771Ab1AMFbd (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 13 Jan 2011 00:31:33 -0500
Subject: RE: Enable IR on hdpvr
From: Andy Walls <awalls@md.metrocast.net>
To: Jason Gauthier <jgauthier@lastar.com>
Cc: Jarod Wilson <jarod@wilsonet.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Janne Grunau <j@jannau.net>
In-Reply-To: <65DE7931C559BF4DBEE42C3F8246249A0B6A9B4A@V-ALBEXCHANGE.ctg.com>
References: <65DE7931C559BF4DBEE42C3F8246249A0B686EB0@V-EXMAILBOX.ctg.com>
	 <8AFBEFD7-69E3-4E71-B155-EA773C2FED43@wilsonet.com>
	 <65DE7931C559BF4DBEE42C3F8246249A0B69B014@V-ALBEXCHANGE.ctg.com>
	 <EC37FC85-82B2-48AE-BB94-64ED00E7647D@wilsonet.com>
	 <93CE8497-D6AB-43BA-A239-EE32D51582FC@wilsonet.com>
	 <65DE7931C559BF4DBEE42C3F8246249A0B6A54C7@V-ALBEXCHANGE.ctg.com>
	 ,<1294875902.2485.19.camel@morgan.silverblock.net>
	 <65DE7931C559BF4DBEE42C3F8246249A0B6A9B4A@V-ALBEXCHANGE.ctg.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 13 Jan 2011 00:31:30 -0500
Message-ID: <1294896690.7921.21.camel@localhost>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Thu, 2011-01-13 at 02:16 +0000, Jason Gauthier wrote:
> >> I've got two hdpvrs.  Whenever you're ready to extend your testing,
> >> I'm happy to extend that functional testing.  I didn't get a chance to
> >> look at the FC14 patch yet (busy couple of days), but I will hold off
> >> now, anyway!
> 
> >If all goes well, with Jarrod's change, you should be able to test the
> >hdpvr module with the ir-kbd-i2c module and test IR Rx.
> 
> >Strictly speaking, lirc_zilog needs some rework to use the kernel
> >internal interfaces properly.  It might still work, but don't be
> >surprised if it doesn't.
> 
> >I might get to working on lirc_zilog tonight, but otherwise not until
> >this weekend.
> 
> Sounds good. Will give any feedback I can!  Is Tx completely a no show
> at this point?  

No, it might work.  It's hard to tell, but you best course of action is
to load the hdpvr driver and then load the lirc_zilog module and *do
not* unload it.

The major lirc_zilog problem is *double* registration of the Tx and Rx
interfaces due to an old design in lirc_zilog.c:ir_probe().  Other
subtle problems I noticed were pointer use after kfree() and not
deallocating everything properly on module unload.

How will those affect you?  I don't know...

Regards,
Andy

