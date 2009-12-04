Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:32494 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751023AbZLDOeJ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 4 Dec 2009 09:34:09 -0500
Message-ID: <4B191DD4.8030903@redhat.com>
Date: Fri, 04 Dec 2009 12:33:56 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Christoph Bartelmus <lirc@bartelmus.de>
CC: dmitry.torokhov@gmail.com, awalls@radix.net, j@jannau.net,
	jarod@redhat.com, jarod@wilsonet.com, jonsmirl@gmail.com,
	khc@pm.waw.pl, kraxel@redhat.com, linux-input@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
	superm1@ubuntu.com
Subject: Re: [RFC] What are the goals for the architecture of an in-kernel
 IR  system?
References: <BEFg1n2mqgB@lirc>
In-Reply-To: <BEFg1n2mqgB@lirc>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Christoph Bartelmus wrote:
> Hi Dmitry,
> 
> on 03 Dec 09 at 14:12, Dmitry Torokhov wrote:
> [...]
>>> Consider passing the decoded data through lirc_dev.
> [...]
>> I believe it was agreed that lirc-dev should be used mainly for decoding
>> protocols that are more conveniently decoded in userspace and the
>> results would be looped back into input layer through evdev which will
>> be the main interface for consumer applications to use.
> 
> Quoting myself:
>> Currently I would tend to an approach like this:
>> - raw interface to userspace using LIRC
> 
> For me this includes both the pulse/space data and also the scan codes  
> when hardware does the decoding.
> Consider cases like this:
> http://lirc.sourceforge.net/remotes/lg/6711A20015N
> 
> This is an air-conditioner remote.
> The entries that you see in this config file are not really separate  
> buttons. Instead the remote just sends the current settings for e.g.  
> temperature encoded in the protocol when you press some up/down key. You  
> really don't want to map all possible temperature settings to KEY_*  
> events. For such cases it would be nice to have access at the raw scan  
> codes from user space to do interpretation of the data.
> The default would still be to pass the data to the input layer, but it  
> won't hurt to have the possibility to access the raw data somehow.

Interesting. IMHO, the better would be to add an evdev ioctl to return the
scancode for such cases, instead of returning the keycode.

Cheers,
Mauro.
