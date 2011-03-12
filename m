Return-path: <mchehab@pedra>
Received: from mo-p00-ob.rzone.de ([81.169.146.160]:41933 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751044Ab1CLNzt (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 12 Mar 2011 08:55:49 -0500
From: Ralph Metzler <rjkm@metzlerbros.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <19835.31584.958529.96578@morden.metzler>
Date: Sat, 12 Mar 2011 14:55:44 +0100
To: Andreas Oberritter <obi@linuxtv.org>
Cc: Ralph Metzler <rjkm@metzlerbros.de>, linux-media@vger.kernel.org,
	Issa Gorissen <flop.m@usa.net>
Subject: Re: [PATCH] Ngene cam device name
In-Reply-To: <4D7B7434.4050404@linuxtv.org>
References: <419PcksGF8800S02.1299868385@web02.cms.usa.net>
	<4D7A8879.5010401@linuxtv.org>
	<19834.38956.105807.55268@morden.metzler>
	<4D7B7434.4050404@linuxtv.org>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Andreas Oberritter writes:
 > > Unless you want to move the writing to/reading from the CI module into
 > > ioctls of the ci device you need another node. 
 > > Even nicer would be having the control messages moved to ioctls and the
 > > TS IO in read/write of ci, but this would break the old interface.
 > 
 > It's possible to keep compatibility. Just add ioctls to get and set the
 > interface version. Default to the current version, not supporting TS
 > I/O. If the version is set to e.g. 1, switch from the current interface
 > to the new one, using ioctls for control messages.

A possibility, but also requires rewrites in existing software like libdvben50221.
Right now you can e.g. tune with /dev/dvb/adapter0/frontend0, point an unchanged
libdvben50221 to /dev/dvb/adapter1/ci0 (separate adapter since it can even
be on a different card) and pipe all PIDs of cam_pmt of the program
you are watching through /dev/dvb/adapter1/sec0(cam0) and it is decoded.



Regards,
Ralph

