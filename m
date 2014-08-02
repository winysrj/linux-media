Return-path: <linux-media-owner@vger.kernel.org>
Received: from mo4-p00-ob.smtp.rzone.de ([81.169.146.218]:27126 "EHLO
	mo4-p00-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754618AbaHBQfv (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 2 Aug 2014 12:35:51 -0400
From: Ralph Metzler <rjkm@metzlerbros.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <21469.4963.140809.65717@morden.metzler>
Date: Sat, 2 Aug 2014 18:35:47 +0200
To: Antti Palosaari <crope@iki.fi>
Cc: Bjoern <lkml@call-home.ch>, Georgi Chorbadzhiyski <gf@unixsol.org>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Rudy Zijlstra <rudy@grumpydevil.homelinux.org>,
	Thomas Kaiser <thomas@kaiser-linux.li>
Subject: Re: ddbridge -- kernel 3.15.6
In-Reply-To: <53DD023C.4030304@iki.fi>
References: <53C920FB.1040501@grumpydevil.homelinux.org>
	<53CAAF9D.6000507@kaiser-linux.li>
	<1406697205.2591.13.camel@bjoern-W35xSTQ-370ST>
	<21465.62099.786583.416351@morden.metzler>
	<1406868897.2548.15.camel@bjoern-W35xSTQ-370ST>
	<53DB20E4.7020803@unixsol.org>
	<1406977344.2504.15.camel@bjoern-W35xSTQ-370ST>
	<53DD023C.4030304@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Antti Palosaari writes:
 > Most hardest part mainlining all that stuff is absolutely API issues. 
 > Designing new APIs is a lot of work. Due to that I decided remove all 
 > the problematic stuff in order to proceed.
 > 
 > API related issues:
 > * DVB modulator API

Yes, we definitely need a general API for this.

 > * some unusual CI stuff

This is only the extra CI (formerly misused SEC) device which has
no API, just basic read/write.

 > * network streaming
 > * own device node (I left it as for now as it was there already)

Mainly for firmware updates and debugging.

 > * DVB-C2 API (it is still there, but if it looks hard to specify I will 
 > disable it too)

Needs some extending for proper scanning but is good enough for basic tuning.

 > Driver related issues:
 > * MaxLinear MxL5x, demod + tuner driver needs to be upstreamed
 > * STMicroelectronics STV0910, demod + tuner driver needed. Should be 
 > study if existing kernel drivers could be changed easily to support that 
 > chip too, if not upstream drivers.

STV090x shares many features but has many slight differences in registers
and handling. Could be worth merging but might turn out to need many 
conditionals.


Regards,
Ralph
