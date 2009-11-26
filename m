Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail1.radix.net ([207.192.128.31]:44448 "EHLO mail1.radix.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751350AbZKZNXR (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 26 Nov 2009 08:23:17 -0500
Subject: Re: [RFC] Should we create a raw input interface for IR's ? - Was:
 Re: [PATCH 1/3 v2] lirc core device driver infrastructure
From: Andy Walls <awalls@radix.net>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Krzysztof Halasa <khc@pm.waw.pl>, Jarod Wilson <jarod@redhat.com>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	linux-kernel@vger.kernel.org,
	Mario Limonciello <superm1@ubuntu.com>,
	linux-input@vger.kernel.org, linux-media@vger.kernel.org,
	Janne Grunau <j@jannau.net>,
	Christoph Bartelmus <lirc@bartelmus.de>
In-Reply-To: <4B0E765C.2080806@redhat.com>
References: <200910200956.33391.jarod@redhat.com>
	 <200910200958.50574.jarod@redhat.com> <4B0A765F.7010204@redhat.com>
	 <4B0A81BF.4090203@redhat.com> <m36391tjj3.fsf@intrepid.localdomain>
	 <4B0AC65C.806@redhat.com> <m3zl6dq8ig.fsf@intrepid.localdomain>
	 <4B0E765C.2080806@redhat.com>
Content-Type: text/plain
Date: Thu, 26 Nov 2009 08:22:13 -0500
Message-Id: <1259241733.3062.44.camel@palomino.walls.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, 2009-11-26 at 10:36 -0200, Mauro Carvalho Chehab wrote:
> Krzysztof Halasa wrote:
> > Mauro Carvalho Chehab <mchehab@redhat.com> writes:


> PS.: For those following those discussions that want to know more about
> IR protocols, a good reference is at:
> 	http://www.sbprojects.com/knowledge/ir/ir.htm
> 
> Unfortunately, it doesn't describe RC6 mode 6.

RC-6 Mode 0 and Mode 6A is briefly describe here:

http://www.picbasic.nl/frameload_uk.htm?http://www.picbasic.nl/rc5-rc6_transceiver_uk.htm

That page is slightly wrong, as there is some data coded in the header
such as the RC-6 Mode.

This page is an older version of the sbprojects.com RC-6 page, before
the information on RC-6 Mode 6A was removed:

http://slycontrol.ru/scr/kb/rc6.htm


My personal opinion is that, for non-technical reasons, RC-6 Mode 6A
decoding should not be included in the kernel.  That's why I didn't do
it for the HVR-1850/CX23888.


Regards,
Andy


