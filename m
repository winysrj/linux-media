Return-path: <mchehab@pedra>
Received: from proofpoint-cluster.metrocast.net ([65.175.128.136]:63983 "EHLO
	proofpoint-cluster.metrocast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753389Ab1ASNYW (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 19 Jan 2011 08:24:22 -0500
Subject: Re: [GIT PATCHES for 2.6.38] Zilog Z8 IR unit fixes
From: Andy Walls <awalls@md.metrocast.net>
To: Jean Delvare <khali@linux-fr.org>
Cc: Jarod Wilson <jarod@wilsonet.com>, linux-media@vger.kernel.org,
	Mike Isely <isely@isely.net>, Janne Grunau <j@jannau.net>,
	Mauro Carvalho Chehab <mchehab@redhat.com>
In-Reply-To: <20110119134009.1d473320@endymion.delvare>
References: <1295205650.2400.27.camel@localhost>
	 <1295234982.2407.38.camel@localhost>
	 <848D2317-613E-42B1-950D-A227CFF15C5B@wilsonet.com>
	 <1295439718.2093.17.camel@morgan.silverblock.net>
	 <20110119134009.1d473320@endymion.delvare>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 19 Jan 2011 08:24:14 -0500
Message-ID: <1295443454.4317.6.camel@morgan.silverblock.net>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Wed, 2011-01-19 at 13:40 +0100, Jean Delvare wrote:
> On Wed, 19 Jan 2011 07:21:58 -0500, Andy Walls wrote:
> > For debugging, you might want to hack in a probe of address 0x70 for
> > your HVR-1950, to ensure the Tx side responds in the bridge driver. 
> 
> ... keeping in mind that the Z8 doesn't seem to like quick writes, so
> short reads should be used for probing purpose.
> 

Noted.  Thanks.

Actually, I think that might be due to the controller in the USB
connected devices (hdpvr and pvrusb2).  The PCI connected devices, like
cx18 cards, don't have a problem with the Z8, the default I2C probe
method, and i2c-algo-bit.
(A good example of why only bridge drivers should do any required
probing.)


Looking at the code in pvrusb2, it appears to already use a 0 length
read for a probe:

http://git.linuxtv.org/media_tree.git?a=blob;f=drivers/media/video/pvrusb2/pvrusb2-i2c-core.c;h=ccc884948f34b385563ccbf548c5f80b33cd4f08;hb=refs/heads/staging/for_2.6.38-rc1#l542

Regards,
Andy

