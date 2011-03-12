Return-path: <mchehab@pedra>
Received: from ffm.saftware.de ([83.141.3.46]:44703 "EHLO ffm.saftware.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752140Ab1CLO6T (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 12 Mar 2011 09:58:19 -0500
Message-ID: <4D7B8A07.70602@linuxtv.org>
Date: Sat, 12 Mar 2011 15:58:15 +0100
From: Andreas Oberritter <obi@linuxtv.org>
MIME-Version: 1.0
To: Issa Gorissen <flop.m@usa.net>
CC: Ralph Metzler <rjkm@metzlerbros.de>, linux-media@vger.kernel.org
Subject: Re: [PATCH] Ngene cam device name
References: <777PcLohh6368S03.1299940473@web03.cms.usa.net>
In-Reply-To: <777PcLohh6368S03.1299940473@web03.cms.usa.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On 03/12/2011 03:34 PM, Issa Gorissen wrote:
> From: Ralph Metzler <rjkm@metzlerbros.de>
>> Andreas Oberritter writes:
>>  > > Unless you want to move the writing to/reading from the CI module into
>>  > > ioctls of the ci device you need another node. 
>>  > > Even nicer would be having the control messages moved to ioctls and
> the
>>  > > TS IO in read/write of ci, but this would break the old interface.
>>  > 
>>  > It's possible to keep compatibility. Just add ioctls to get and set the
>>  > interface version. Default to the current version, not supporting TS
>>  > I/O. If the version is set to e.g. 1, switch from the current interface
>>  > to the new one, using ioctls for control messages.
>>
>> A possibility, but also requires rewrites in existing software like
> libdvben50221.
>> Right now you can e.g. tune with /dev/dvb/adapter0/frontend0, point an
> unchanged
>> libdvben50221 to /dev/dvb/adapter1/ci0 (separate adapter since it can even
>> be on a different card) and pipe all PIDs of cam_pmt of the program
>> you are watching through /dev/dvb/adapter1/sec0(cam0) and it is decoded.

Obviously, adapting libdvben50221 would be the first thing to do for an
enhanced CI API. Probably not a big deal.

> This is KISS compliant by the way.
> 
> Andreas, please explain what *really* bothers you with this architecture
> choice of having a new node, leaving the current API as is.

I'm not against adding a new node if its behaviour is well defined and
documented and if it integrates well into the existing API.

> You might find that adding a new node is lazy, but there are advantages:
> - current API isn't broken, namely, ca devices are still used for the control
> messages, nothing more;

"nothing more" is wrong, as ca devices are used for descramblers, too.

> - for applications using the DVB API, it is also easier to debug while reading
> the code, in my opinion, because of the usage of two distinct devices (ca /
> cam) instead of one (ca / ioctls);

That's just a matter of taste.

Regards,
Andreas
