Return-path: <mchehab@pedra>
Received: from mo-p00-ob.rzone.de ([81.169.146.162]:34500 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754950Ab1CKVqZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 11 Mar 2011 16:46:25 -0500
From: Ralph Metzler <rjkm@metzlerbros.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <19834.38956.105807.55268@morden.metzler>
Date: Fri, 11 Mar 2011 22:46:20 +0100
To: linux-media@vger.kernel.org
Cc: Issa Gorissen <flop.m@usa.net>,
	Andreas Oberritter <obi@linuxtv.org>
Subject: Re: [PATCH] Ngene cam device name
In-Reply-To: <4D7A8879.5010401@linuxtv.org>
References: <419PcksGF8800S02.1299868385@web02.cms.usa.net>
	<4D7A8879.5010401@linuxtv.org>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Andreas Oberritter writes:
 > >> On 03/10/2011 04:29 PM, Issa Gorissen wrote:
 > > Now, according to Mauro comments, he has put this code into staging because of
 > > the usage of sec0 name for a cam device.
 > > 
 > > Please comment on Oliver's explanations from this thread
 > > 
 > > http://www.mail-archive.com/linux-media@vger.kernel.org/msg26901.html
 > 
 > Oliver explained that he's not going to put work into this driver,
 > because he's not using it.
 > 
 > Until now, I haven't heard any reasons for just adding another device
 > node other than it being easier than defining a proper interface. The
 > fact that a solution "just works as is" is not sufficient to move a
 > driver from staging. IMO the CI driver should not have been included at
 > all in its current shape.

Unless you want to move the writing to/reading from the CI module into
ioctls of the ci device you need another node. 
Even nicer would be having the control messages moved to ioctls and the
TS IO in read/write of ci, but this would break the old interface.

What kind of proper interface were you thinking about?


Regarding usage of dvr/demux mentioned in the linked thread above,
this would add major overhead and lots more nodes. 
You would need dvr0/demux0 for output and dvr1/demux1 for input and both
would PID-filter the stream yet again although it probably already was
when being read from the demux or dvr device belonging to the tuner.


Regards,
Ralph

