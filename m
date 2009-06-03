Return-path: <linux-media-owner@vger.kernel.org>
Received: from mk-outboundfilter-6-a-2.mail.uk.tiscali.com ([212.74.114.16]:1759
	"EHLO mk-outboundfilter-6-a-2.mail.uk.tiscali.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753054AbZFCOPE (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 3 Jun 2009 10:15:04 -0400
Message-ID: <4A26832B.5060508@nildram.co.uk>
Date: Wed, 03 Jun 2009 15:05:31 +0100
From: Lou Otway <lotway@nildram.co.uk>
Reply-To: lotway@nildram.co.uk
MIME-Version: 1.0
To: David Lister <foceni@gmail.com>
CC: linux-media@vger.kernel.org
Subject: Re: Digital Everywhere FloppyDTV / FireDTV (incl. CI)
References: <4A197CE8.9040404@gmail.com>
In-Reply-To: <4A197CE8.9040404@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

David Lister wrote:
> Hi all,
> 
> just found out that these cards have finally some preliminary Linux
> support. They seem quite versatile and even customizable -- a true gift
> for dedicated hobbyists. :) PCI/PCIe/AGP or floppy drive mounting and
> firewire /connection/ chaining look especially interesting. Even
> FloppyDTV is apparently half internal, half external - sort of. Anybody
> with hands-on access? Any updates? Share your experience! :o)

I have been evaluating the Floppy DTV DVB-S2, DVB-T and DVB-C variants.

So far I have managed to get fairly good results from the DVB-S2 and 
DVB-T adapters but I can't get the DVB-C device to tune under linux. I 
tested it with a windows PC to be sure it wasn't faulty and it worked fine.

I've had them all working (i.e. appearing as devices) while chained one 
to the next and when individually connected to a 1394 adapter card.

Now I need to spend some more time to see if they will give the 
performance I need, but so far so good.

If anyone has been able to tune the cable adapter under linux I'd like 
to hear more.

I had to make a small modification to the driver to enable some frontend 
settings required by my applications, but apart from that the latest v4l 
  drivers have been sufficient.

Cheers,

Lou
