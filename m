Return-path: <linux-media-owner@vger.kernel.org>
Received: from dangerbird.closetothewind.net ([82.134.87.117]:60003 "EHLO
	dangerbird.closetothewind.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756883AbZKUWTm (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 21 Nov 2009 17:19:42 -0500
Message-ID: <4B086770.5090201@closetothewind.net>
Date: Sat, 21 Nov 2009 23:19:28 +0100
From: Jonas Kvinge <linuxtv@closetothewind.net>
MIME-Version: 1.0
To: Andy Walls <awalls@radix.net>,
	Matthias Fechner <idefix@fechner.net>
CC: linux-media@vger.kernel.org
Subject: Re: IR Receiver on an Tevii S470
References: <4B0459B1.50600@fechner.net>  <4B081F0B.1060204@fechner.net> <1258836102.1794.7.camel@localhost>
In-Reply-To: <1258836102.1794.7.camel@localhost>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Andy Walls wrote:
> On Sat, 2009-11-21 at 18:10 +0100, Matthias Fechner wrote:
>> Hi,
>>
>> Matthias Fechner schrieb:
>>> I bought some days ago a Tevii S470 DVB-S2 (PCI-E) card and got it 
>>> running with the driver from:
>>> http://mercurial.intuxication.org/hg/s2-liplianin
>>>
>>> But I was not successfull in got the IR receiver working.
>>> It seems that it is not supported yet by the driver.
>>>
>>> Is there maybe some code available to get the IR receiver with evdev 
>>> running?
> 
> What bridge chip does the TeVii S470 use: a CX23885, CX23887, or
> CX23888?
> 
> Does the TeVii S470 have a separate microcontroller chip for IR
> somewhere on the board, or does it not have one?  (If you can't tell,
> just provide a list of the chip markings on the board.)
> 
> 
> If the card is using the built in IR controller of the CX23888 than that
> should be pretty easy to get working, we'll just need you to do some
> experimentation with a patch.
> 
> If the card is using the built in IR controller in the CX23885, then
> you'll have to wait until I port my CX23888 IR controller changes to
> work with the IR controller in the CX23885.  That should be somewhat
> straightforward, but will take time.  Then we'll still need you to
> experiment with a patch.
> 
> If the card is using a separate IR microcontroller, I'm not sure where
> to begin.... :P
> 
> Regards,
> Andy
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

According to the Wiki it's a cx23885. Looks like the IR is on the chip.
It's in the Wiki: http://linuxtv.org/wiki/index.php/TeVii_S470

Tevii is listing the card as supported in Linux with ti's own s2api
driver download, its here: http://www.tevii.com/Support.asp

Jonas
