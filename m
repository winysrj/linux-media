Return-path: <mchehab@pedra>
Received: from ffm.saftware.de ([83.141.3.46]:38067 "EHLO ffm.saftware.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752839Ab1CLNZM (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 12 Mar 2011 08:25:12 -0500
Message-ID: <4D7B7434.4050404@linuxtv.org>
Date: Sat, 12 Mar 2011 14:25:08 +0100
From: Andreas Oberritter <obi@linuxtv.org>
MIME-Version: 1.0
To: Ralph Metzler <rjkm@metzlerbros.de>
CC: linux-media@vger.kernel.org, Issa Gorissen <flop.m@usa.net>
Subject: Re: [PATCH] Ngene cam device name
References: <419PcksGF8800S02.1299868385@web02.cms.usa.net>	<4D7A8879.5010401@linuxtv.org> <19834.38956.105807.55268@morden.metzler>
In-Reply-To: <19834.38956.105807.55268@morden.metzler>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On 03/11/2011 10:46 PM, Ralph Metzler wrote:
> Andreas Oberritter writes:
>  > >> On 03/10/2011 04:29 PM, Issa Gorissen wrote:
>  > > Now, according to Mauro comments, he has put this code into staging because of
>  > > the usage of sec0 name for a cam device.
>  > > 
>  > > Please comment on Oliver's explanations from this thread
>  > > 
>  > > http://www.mail-archive.com/linux-media@vger.kernel.org/msg26901.html
>  > 
>  > Oliver explained that he's not going to put work into this driver,
>  > because he's not using it.
>  > 
>  > Until now, I haven't heard any reasons for just adding another device
>  > node other than it being easier than defining a proper interface. The
>  > fact that a solution "just works as is" is not sufficient to move a
>  > driver from staging. IMO the CI driver should not have been included at
>  > all in its current shape.
> 
> Unless you want to move the writing to/reading from the CI module into
> ioctls of the ci device you need another node. 
> Even nicer would be having the control messages moved to ioctls and the
> TS IO in read/write of ci, but this would break the old interface.

It's possible to keep compatibility. Just add ioctls to get and set the
interface version. Default to the current version, not supporting TS
I/O. If the version is set to e.g. 1, switch from the current interface
to the new one, using ioctls for control messages.

> What kind of proper interface were you thinking about?

At least something that's documented and has a defined behaviour.

Regards,
Andreas
