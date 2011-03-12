Return-path: <mchehab@pedra>
Received: from cmsout01.mbox.net ([165.212.64.31]:44023 "EHLO
	cmsout01.mbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752147Ab1CLPj0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 12 Mar 2011 10:39:26 -0500
Date: Sat, 12 Mar 2011 16:39:23 +0100
From: "Issa Gorissen" <flop.m@usa.net>
To: Andreas Oberritter <obi@linuxtv.org>
Subject: Re: [PATCH] Ngene cam device name
CC: <linux-media@vger.kernel.org>
Mime-Version: 1.0
Message-ID: <042PcLPMX5776S02.1299944363@web02.cms.usa.net>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

From: Andreas Oberritter <obi@linuxtv.org>
> 
> I'm not against adding a new node if its behaviour is well defined and
> documented and if it integrates well into the existing API.


Integration is okay; current API is left untouched.
The behaviour is defined as a write encrypted stream / read decrypted stream
device.


> 
> > You might find that adding a new node is lazy, but there are advantages:
> > - current API isn't broken, namely, ca devices are still used for the
control
> > messages, nothing more;
> 
> "nothing more" is wrong, as ca devices are used for descramblers, too.


I don't understand your point here, do you mean these DVB descramblers
currently use ca device for more than the control messages ?


> 
> > - for applications using the DVB API, it is also easier to debug while
reading
> > the code, in my opinion, because of the usage of two distinct devices (ca
/
> > cam) instead of one (ca / ioctls);
> 
> That's just a matter of taste.

Okay, so you agree that choosing ca/ioctls over ca/cam is just a matter of
taste.

