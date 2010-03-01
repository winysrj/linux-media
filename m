Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail1.radix.net ([207.192.128.31]:44085 "EHLO mail1.radix.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752550Ab0CAA7k (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 28 Feb 2010 19:59:40 -0500
Subject: Re: Mantis not in modules.pcimap
From: Andy Walls <awalls@radix.net>
To: Helmut Auer <vdr@helmutauer.de>
Cc: Manu Abraham <abraham.manu@gmail.com>, linux-media@vger.kernel.org
In-Reply-To: <4B8AF722.8000105@helmutauer.de>
References: <4B8AF722.8000105@helmutauer.de>
Content-Type: text/plain
Date: Sun, 28 Feb 2010 19:58:06 -0500
Message-Id: <1267405086.3109.48.camel@palomino.walls.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, 2010-03-01 at 00:07 +0100, Helmut Auer wrote:
> Hello,
> 
> The mantis module is build and working fine with the Skystar2 HD, but it I cannot autodetect it,
> because modules.pcimap is not filled with the vendor id of the card using this module.
> What's to do  to get these ID's ?
> In my case its a:
> 
> 01:08.0 0480: 1822:4e35 (rev 01)
> 	Subsystem: 1ae4:0003
> 	Flags: bus master, medium devsel, latency 32, IRQ 16
> 	Memory at fddff000 (32-bit, prefetchable) [size=4K]

Running 

 # depmod -a

as root should have added it.  The mantis driver is likely missing a
MODULE_DEVICE_TABLE() macro invocation.

Cc:-ing Manu.

Regards,
Andy

