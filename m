Return-path: <mchehab@pedra>
Received: from proofpoint-cluster.metrocast.net ([65.175.128.136]:30280 "EHLO
	proofpoint-cluster.metrocast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750771Ab1AMFYD (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 13 Jan 2011 00:24:03 -0500
Subject: RE: Enable IR on hdpvr
From: Andy Walls <awalls@md.metrocast.net>
To: Jason Gauthier <jgauthier@lastar.com>
Cc: Jarod Wilson <jarod@wilsonet.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Janne Grunau <j@jannau.net>
In-Reply-To: <1294875902.2485.19.camel@morgan.silverblock.net>
References: <65DE7931C559BF4DBEE42C3F8246249A0B686EB0@V-EXMAILBOX.ctg.com>
	 <8AFBEFD7-69E3-4E71-B155-EA773C2FED43@wilsonet.com>
	 <65DE7931C559BF4DBEE42C3F8246249A0B69B014@V-ALBEXCHANGE.ctg.com>
	 <EC37FC85-82B2-48AE-BB94-64ED00E7647D@wilsonet.com>
	 <93CE8497-D6AB-43BA-A239-EE32D51582FC@wilsonet.com>
	 <65DE7931C559BF4DBEE42C3F8246249A0B6A54C7@V-ALBEXCHANGE.ctg.com>
	 <1294875902.2485.19.camel@morgan.silverblock.net>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 13 Jan 2011 00:23:55 -0500
Message-ID: <1294896235.7921.14.camel@localhost>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Wed, 2011-01-12 at 18:45 -0500, Andy Walls wrote:


> If all goes well, with Jarrod's change, you should be able to test the
> hdpvr module with the ir-kbd-i2c module and test IR Rx.

FYI, I have (re)confirmed that ir-kbd-i2c and cx18, in a bleeding-edge
development kernel, still work with the Zilog Z8 IR Rx on the
HVR-1600.  

It's nice to have a known working baseline.


> Strictly speaking, lirc_zilog needs some rework to use the kernel
> internal interfaces properly.  It might still work, but don't be
> surprised if it doesn't.
> 
> I might get to working on lirc_zilog tonight, but otherwise not until
> this weekend.

lirc_zilog got a little work tonight:

http://git.linuxtv.org/awalls/media_tree.git?a=shortlog;h=refs/heads/z8

My changes make it slightly *more* broken in some respects. :D

At least what needs to be reworked is now becoming easier to see and
address.

Regards,
Andy

