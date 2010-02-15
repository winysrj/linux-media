Return-path: <linux-media-owner@vger.kernel.org>
Received: from lo.gmane.org ([80.91.229.12]:57823 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751014Ab0BONPj (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 15 Feb 2010 08:15:39 -0500
Received: from list by lo.gmane.org with local (Exim 4.69)
	(envelope-from <gldv-linux-media@m.gmane.org>)
	id 1Nh0nT-0002ZM-BC
	for linux-media@vger.kernel.org; Mon, 15 Feb 2010 14:15:31 +0100
Received: from 80-218-69-65.dclient.hispeed.ch ([80.218.69.65])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Mon, 15 Feb 2010 14:15:31 +0100
Received: from auslands-kv by 80-218-69-65.dclient.hispeed.ch with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Mon, 15 Feb 2010 14:15:31 +0100
To: linux-media@vger.kernel.org
From: Michael <auslands-kv@gmx.de>
Subject: Re: cx23885
Date: Mon, 15 Feb 2010 14:15:01 +0100
Message-ID: <hlbhck$uh9$1@ger.gmane.org>
References: <hlbe6t$kc4$1@ger.gmane.org> <1266238446.3075.13.camel@palomino.walls.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7Bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Andy

>> Does anybody know whether this card is currently supported
> 
> Likely no.  I have not checked the source to be sure.
> 
Is this because the driver does not have the right capabilities or is it 
"just" a PCI-id missing in the driver?

The latter would be quite easy to add, I guess.
> 
>> and if yes, is it
>> by cx88 or by cx23885?
>> 
>> http://www.commell.com.tw/Product/Surveillance/MPX-885.htm
>> 
>> It is based on the Connexant 23885 chip but uses an Mini-PCIe interface.
> 
> cx88 handles PCI bridge chips: CX2388[0123]
> 
> cx23885 handles PCIe bridge chips: CX2388[578]
> 
>>From the picture of the card from the datasheet it has a CX23885 chip.
> 

That means, if a driver might support it, then the cx23885 driver not the 
cx88, correct?

Thanks

Michael

> Regards,
> Andy
> 
>> Thanks
>> 
>> Michael


