Return-path: <mchehab@pedra>
Received: from mail.nagios.lastar.com ([64.129.117.10]:36403 "EHLO
	mail.lastar.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754728Ab1AMCQk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 12 Jan 2011 21:16:40 -0500
From: Jason Gauthier <jgauthier@lastar.com>
To: Andy Walls <awalls@md.metrocast.net>
CC: Jarod Wilson <jarod@wilsonet.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Janne Grunau <j@jannau.net>
Subject: RE: Enable IR on hdpvr
Date: Thu, 13 Jan 2011 02:16:35 +0000
Message-ID: <65DE7931C559BF4DBEE42C3F8246249A0B6A9B4A@V-ALBEXCHANGE.ctg.com>
References: <65DE7931C559BF4DBEE42C3F8246249A0B686EB0@V-EXMAILBOX.ctg.com>
	 <8AFBEFD7-69E3-4E71-B155-EA773C2FED43@wilsonet.com>
	 <65DE7931C559BF4DBEE42C3F8246249A0B69B014@V-ALBEXCHANGE.ctg.com>
	 <EC37FC85-82B2-48AE-BB94-64ED00E7647D@wilsonet.com>
	 <93CE8497-D6AB-43BA-A239-EE32D51582FC@wilsonet.com>
	 <65DE7931C559BF4DBEE42C3F8246249A0B6A54C7@V-ALBEXCHANGE.ctg.com>,<1294875902.2485.19.camel@morgan.silverblock.net>
In-Reply-To: <1294875902.2485.19.camel@morgan.silverblock.net>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>


>> I've got two hdpvrs.  Whenever you're ready to extend your testing,
>> I'm happy to extend that functional testing.  I didn't get a chance to
>> look at the FC14 patch yet (busy couple of days), but I will hold off
>> now, anyway!

>If all goes well, with Jarrod's change, you should be able to test the
>hdpvr module with the ir-kbd-i2c module and test IR Rx.

>Strictly speaking, lirc_zilog needs some rework to use the kernel
>internal interfaces properly.  It might still work, but don't be
>surprised if it doesn't.

>I might get to working on lirc_zilog tonight, but otherwise not until
>this weekend.

Sounds good. Will give any feedback I can!  Is Tx completely a no show at this point?  From my circle of friends that use the hdpvr, they all use the Tx for channel changing to cable boxes.  This small sample might not be indicative of the larger hdpvr user base, though! :)

