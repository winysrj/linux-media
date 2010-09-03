Return-path: <mchehab@pedra>
Received: from proofpoint-cluster.metrocast.net ([65.175.128.136]:33859 "EHLO
	proofpoint-cluster.metrocast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752566Ab0ICBce (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 2 Sep 2010 21:32:34 -0400
Subject: Re: cx23885: Support for IR-Remote on boad TBV-6920
From: Andy Walls <awalls@md.metrocast.net>
To: Simon Waid <simon_waid@gmx.net>
Cc: "Igor M. Liplianin" <liplianin@me.by>, maximlevitsky@gmail.com,
	linux-media@vger.kernel.org
In-Reply-To: <1283203565.5457.34.camel@simon>
References: <1283203565.5457.34.camel@simon>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 02 Sep 2010 21:32:21 -0400
Message-ID: <1283477541.17527.14.camel@morgan.silverblock.net>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@pedra>

On Mon, 2010-08-30 at 23:26 +0200, Simon Waid wrote:
> Hello!
> 
> I am trying to get the remote control of my DVB 6920 (cx23885) to work. 
> 
> I found out that the wiring of the sensor is the same as on the TiVii
> S470, so there is little work to be done. Unfortunately, the IR part of
> cx23885 driver inside the kernel is buggy. You fixed that, right? Could
> you please give me access to your current cx23885 driver? 

I wrote the CX2388[58] integrated IR controller portion of the cx23885
IR driver changes.

They are in media_tree.git on the staging/v2.6.36 branch:

http://git.linuxtv.org/media_tree.git?a=shortlog;h=refs/heads/staging/v2.6.36

Note that Igor experienced continual interrupts with the IR on the TeVii
S470, but I didn't have a problem with the HVR-1250.  So the IR for the
TeVii S470 is disabled by default and can be re-enabled with a module
option. /sbin/modinfo cx23885

You can use the code snippets for the S470 and build IR support for your
card, provided it has a CX23885 chip, and see what happens.  If your
card has a CX23888 chip, you'll have to use some IR setup code similar
to what the Hauppauge cards used.


I still have more work to do on the cx23885 integrated IR, but it should
be good enough for now.  If you have a CX23885 chip, be prepared for
continual interrupts to make your system unusable: blacklist the cx23885
module in /etc/modprobe.conf before testing.

Regards,
Andy

> Best regards,
> Simon Waid


