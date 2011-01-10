Return-path: <mchehab@pedra>
Received: from proofpoint-cluster.metrocast.net ([65.175.128.136]:59240 "EHLO
	proofpoint-cluster.metrocast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752349Ab1AJMHK (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 10 Jan 2011 07:07:10 -0500
Subject: Re: Enable IR on hdpvr
From: Andy Walls <awalls@md.metrocast.net>
To: Jarod Wilson <jarod@wilsonet.com>
Cc: Jason Gauthier <jgauthier@lastar.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Janne Grunau <j@jannau.net>
In-Reply-To: <8AFBEFD7-69E3-4E71-B155-EA773C2FED43@wilsonet.com>
References: <65DE7931C559BF4DBEE42C3F8246249A0B686EB0@V-EXMAILBOX.ctg.com>
	 <8AFBEFD7-69E3-4E71-B155-EA773C2FED43@wilsonet.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 10 Jan 2011 07:07:52 -0500
Message-ID: <1294661272.2084.10.camel@morgan.silverblock.net>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Mon, 2011-01-10 at 01:05 -0500, Jarod Wilson wrote:
> On Jan 9, 2011, at 7:36 PM, Jason Gauthier wrote:

> Janne, I've heard many success stories w/the hdpvr IR lately, and almost no reports
> of lockups, so I'm thinking a firmware update may have helped out here, and thus,
> maybe its time we just go ahead and push this patch along upstream? We still
> require someone to load lirc_zilog manually, so it seems like a fairly low-risk
> thing to do.

FYI, the code I added to hdpvr-i2c.c will perform 2 accesses to the chip
to check for existence, by virtue of a call to i2c_new_probed_device()
(or whatever it is called).  The I2C subsystem tries to talk the chip to
see if it exists.

If you are really concerned about corner cases that may hang, add a
module option to hdpvr to disable I2C and/or IR in the hdpvr driver.
With that users in the field can work-around the problem without
rebuilding modules.

Regards,
Andy

