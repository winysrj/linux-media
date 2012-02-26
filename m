Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-gw-out2.cc.tut.fi ([130.230.160.33]:52036 "EHLO
	mail-gw-out2.cc.tut.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752840Ab2BZWnV (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 26 Feb 2012 17:43:21 -0500
Message-ID: <4F4AB586.2030205@iki.fi>
Date: Mon, 27 Feb 2012 00:43:18 +0200
From: Anssi Hannula <anssi.hannula@iki.fi>
MIME-Version: 1.0
To: Ralph Metzler <rjkm@metzlerbros.de>
CC: Issa Gorissen <flop.m@usa.net>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	S-bastien RAILLARD <sr@coexsi.fr>,
	Oliver Endriss <o.endriss@gmx.de>
Subject: cxd2099 CI on DDBridge not working (was: Re: DVB nGene CI : TS Discontinuities
 issues)
References: <501PekNLl1856S04.1305119557@web04.cms.usa.net> <4DCC45D7.8090405@usa.net> <19917.7169.579857.44894@morden.metzler> <4F4A67AB.1070103@iki.fi> <20298.44716.921452.814171@morden.metzler>
In-Reply-To: <20298.44716.921452.814171@morden.metzler>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

27.02.2012 00:14, Ralph Metzler kirjoitti:
> Anssi Hannula writes:
>  > > I had it running for an hour and had no discontinuities (except at
>  > > restarts, might have to look into buffer flushing).
>  > > I tested it with nGene and Octopus boards on an Asus ION2 board and on a
>  > > Marvell Kirkwood based ARM board.
>  > 
>  > Should your test code (quoted below) work with e.g. Octopus DDBridge on
>  > vanilla 3.2.6 kernel, without any additional initialization needed
>  > through ca0 or so?
>  > 
>  > When I try it here like that, the reader thread simply blocks
>  > indefinitely on the first read, while the writer thread continues to
>  > write packets into the device.
>  > Am I missing something, or is this a bug?
> 
> 
> Yes, it should work as it is. 
> I assume you adjusted the adapter numbers of course.

I did. Do you have any idea on what could be the cause of the issue or
any debugging tips?

I have also tried to do actual decrypting with the CI. As expected, the
same thing happened, i.e. data was written but no data was read (CAM in
ca0 also responds properly to VDR).

-- 
Anssi Hannula
