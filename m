Return-path: <linux-media-owner@vger.kernel.org>
Received: from static-72-93-233-3.bstnma.fios.verizon.net ([72.93.233.3]:54154
	"EHLO mail.wilsonet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752147AbZHMN6f (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 13 Aug 2009 09:58:35 -0400
Cc: linux-media@vger.kernel.org
Message-Id: <88086BD2-53BB-4095-A927-0DFB25F8BD59@wilsonet.com>
From: Jarod Wilson <jarod@wilsonet.com>
To: tfjellstrom@shaw.ca
In-Reply-To: <200908122253.12021.tfjellstrom@shaw.ca>
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0 (Apple Message framework v936)
Subject: Re: KWorld UB435-Q support?
Date: Thu, 13 Aug 2009 09:50:18 -0400
References: <200908122253.12021.tfjellstrom@shaw.ca>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Aug 13, 2009, at 12:53 AM, Thomas Fjellstrom wrote:

> I stupidly bought the KWorld UB435-Q usb ATSC tuner thinking it was  
> supported
> under linux, and it turns out it isn't. I'm wondering what it would  
> take to
> get it supported. It seems like all of the main chips it uses are  
> supported,
> but the glue code is missing.
>
> I have some C (10 years) programming experience, and have wanted to  
> contribute
> to the linux kernel for quite a while, now I have a good excuse ;)
>
> Would anyone be willing to point me in the right direction?

The UB435-Q is a rebadge of the revision B 340U, which is an em2870  
bridge, lgdt3304 demodulator and an nxp tda18271hd/c2 tuner. Its got  
the same device ID and everything. I've got a rev A 340U, the only  
difference being that it has an nxp tda18271hd/c1 tuner (also same  
device ID). I *had* it working just fine until the stick up and died  
on me, before I could push the code for merge, but its still floating  
about. It wasn't quite working with a c2 device, but that could have  
been a device problem (these are quite franky, cheap and poorly made  
devices, imo). It could also be that the code ate both sticks and will  
pickle yours as well.

With that caveat emptor, here's where the tree that should at least  
get you 95% of the way there with that stick resides:

http://www.kernellabs.com/hg/~mkrufky/lgdt3304-3/

The last two patches are the relevant ones. They add lgdt3304 demod  
support to the lgdt3305 driver (because the current lgdt3304 driver  
is, um, lacking) and then add the bits to wire up the stick.

-- 
Jarod Wilson
jarod@wilsonet.com



