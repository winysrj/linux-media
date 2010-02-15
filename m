Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail1.radix.net ([207.192.128.31]:61589 "EHLO mail1.radix.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753279Ab0BOMyK (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 15 Feb 2010 07:54:10 -0500
Subject: Re: cx23885
From: Andy Walls <awalls@radix.net>
To: Michael <auslands-kv@gmx.de>
Cc: linux-media@vger.kernel.org
In-Reply-To: <hlbe6t$kc4$1@ger.gmane.org>
References: <hlbe6t$kc4$1@ger.gmane.org>
Content-Type: text/plain
Date: Mon, 15 Feb 2010 07:54:06 -0500
Message-Id: <1266238446.3075.13.camel@palomino.walls.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, 2010-02-15 at 13:20 +0100, Michael wrote:
> Hello
> 
> Does anybody know whether this card is currently supported 

Likely no.  I have not checked the source to be sure.


> and if yes, is it 
> by cx88 or by cx23885?
> 
> http://www.commell.com.tw/Product/Surveillance/MPX-885.htm
> 
> It is based on the Connexant 23885 chip but uses an Mini-PCIe interface.

cx88 handles PCI bridge chips: CX2388[0123]

cx23885 handles PCIe bridge chips: CX2388[578]

>From the picture of the card from the datasheet it has a CX23885 chip.

Regards,
Andy

> Thanks
> 
> Michael


