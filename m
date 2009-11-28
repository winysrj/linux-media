Return-path: <linux-media-owner@vger.kernel.org>
Received: from khc.piap.pl ([195.187.100.11]:46356 "EHLO khc.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752839AbZK1RVj (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 28 Nov 2009 12:21:39 -0500
From: Krzysztof Halasa <khc@pm.waw.pl>
To: lirc@bartelmus.de (Christoph Bartelmus)
Cc: awalls@radix.net, dmitry.torokhov@gmail.com, j@jannau.net,
	jarod@redhat.com, jarod@wilsonet.com, jonsmirl@gmail.com,
	linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-media@vger.kernel.org, maximlevitsky@gmail.com,
	mchehab@redhat.com, stefanr@s5r6.in-berlin.de, superm1@ubuntu.com
Subject: Re: [RFC] What are the goals for the architecture of an in-kernel IR 	system?
References: <BDkdITRHqgB@lirc>
Date: Sat, 28 Nov 2009 18:21:42 +0100
In-Reply-To: <BDkdITRHqgB@lirc> (Christoph Bartelmus's message of "28 Nov 2009
	17:47:00 +0100")
Message-ID: <m3einiy389.fsf@intrepid.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

lirc@bartelmus.de (Christoph Bartelmus) writes:

> Nobody here doubts that you can implement a working RC-5 decoder. It's  
> really easy. I'll give you an example why Maxim thinks that the generic  
> LIRC approach has advantages:

But surely not when compared to an in-kernel decoder _and_ the one in
lircd? :-)

> Look at the Streamzap remote (I think Jarod submitted the lirc_streamzap  
> driver in his patchset):
> http://lirc.sourceforge.net/remotes/streamzap/PC_Remote
>
> This remote uses RC-5. But some of the developers must have thought that  
> it may be a smart idea to use 14 bits instead the standard 13 bits for  
> this remote. In LIRC you won't care, because this is configurable and  
> irrecord will figure it out automatically for you. In the proposed kernel  
> decoders I have seen until now, you will have to treat this case specially  
> in the decoder because you expect 13 bits for RC-5, not 14.

Well, the 14-bit RC5 is de-facto standard for some time now. One of the
start bits, inverted, now functions as the MSB of the command code.
13-bit receiver implementations (at least these aimed at "foreign"
remotes) are obsolete.

> Well, it can be done. But you'll have to add another IR protocol define  
> for RC-5_14, which will become very ugly with many non-standard protocol  
> variations.

No, the 14-bit version is designed to be backward compatible.
-- 
Krzysztof Halasa
