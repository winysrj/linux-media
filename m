Return-path: <linux-media-owner@vger.kernel.org>
Received: from mo-p00-ob.rzone.de ([81.169.146.162]:20234 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752390Ab2BZWOa (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 26 Feb 2012 17:14:30 -0500
From: Ralph Metzler <rjkm@metzlerbros.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <20298.44716.921452.814171@morden.metzler>
Date: Sun, 26 Feb 2012 23:14:04 +0100
To: Anssi Hannula <anssi.hannula@iki.fi>
Cc: Issa Gorissen <flop.m@usa.net>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	S-bastien RAILLARD <sr@coexsi.fr>,
	Oliver Endriss <o.endriss@gmx.de>
Subject: Re: DVB nGene CI : TS Discontinuities issues
In-Reply-To: <4F4A67AB.1070103@iki.fi>
References: <501PekNLl1856S04.1305119557@web04.cms.usa.net>
	<4DCC45D7.8090405@usa.net>
	<19917.7169.579857.44894@morden.metzler>
	<4F4A67AB.1070103@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Anssi Hannula writes:
 > > I had it running for an hour and had no discontinuities (except at
 > > restarts, might have to look into buffer flushing).
 > > I tested it with nGene and Octopus boards on an Asus ION2 board and on a
 > > Marvell Kirkwood based ARM board.
 > 
 > Should your test code (quoted below) work with e.g. Octopus DDBridge on
 > vanilla 3.2.6 kernel, without any additional initialization needed
 > through ca0 or so?
 > 
 > When I try it here like that, the reader thread simply blocks
 > indefinitely on the first read, while the writer thread continues to
 > write packets into the device.
 > Am I missing something, or is this a bug?


Yes, it should work as it is. 
I assume you adjusted the adapter numbers of course.



Regards,
Ralph
