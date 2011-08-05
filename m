Return-path: <linux-media-owner@vger.kernel.org>
Received: from hqemgate04.nvidia.com ([216.228.121.35]:8902 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751501Ab1HEX5s convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 5 Aug 2011 19:57:48 -0400
From: Andrew Chew <AChew@nvidia.com>
To: 'Mauro Carvalho Chehab' <mchehab@redhat.com>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>
CC: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	'Doug Anderson' <dianders@google.com>
Date: Fri, 5 Aug 2011 16:57:43 -0700
Subject: RE: Guidance regarding deferred I2C transactions
Message-ID: <643E69AA4436674C8F39DCC2C05F76383CF0DD22D8@HQMAIL03.nvidia.com>
References: <643E69AA4436674C8F39DCC2C05F76383CF0DD22D0@HQMAIL03.nvidia.com>
 <4E3C557A.2060103@redhat.com>
 <643E69AA4436674C8F39DCC2C05F76383CF0DD22D5@HQMAIL03.nvidia.com>
 <Pine.LNX.4.64.1108060108580.26715@axis700.grange>
 <4E3C7CD8.5060200@redhat.com>
In-Reply-To: <4E3C7CD8.5060200@redhat.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

> > A simpler approach seems to be to only load the driver, 
> when streaming is 
> > required. Yes, it would add a (considerable) delay to 
> streaming begin, but 
> > you'd be completely honest to your user and privacy would 
> be guaranteed.
> 
> The delay will likely be close to the one introduced by 
> flushing the shadow
> registers: it will basically be the needed time to transfer 
> all registers data
> via I2C.

I would think the delay is potentially a lot worse, as the module has to be read from the filesystem (if the image sensor driver was built as a module).


> > Another less secure approach would be to tie your LED to a 
> different 
> > function, to one, that only activates, when actual data is 
> transferred. 
> > Maybe you can tie it to one of sync or clock signals? Look 
> whether your 
> > sensor has any pins, that only get activated, when video data is 
> > transferred.
> 
> I agree. If the hardware design is not finished, this is the 
> best way of
> doing that.
> 
> It is safer and more honest than attaching the led to the I2C bus, as
> it will be monitoring the actual data transfer, an not the 
> control bus.

I completely agree on this as well.  Sadly, that doesn't seem to be an option at this point.
-----------------------------------------------------------------------------------
This email message is for the sole use of the intended recipient(s) and may contain
confidential information.  Any unauthorized review, use, disclosure or distribution
is prohibited.  If you are not the intended recipient, please contact the sender by
reply email and destroy all copies of the original message.
-----------------------------------------------------------------------------------
