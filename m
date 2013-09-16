Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailex.mailcore.me ([94.136.40.61]:38324 "EHLO
	mailex.mailcore.me" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750983Ab3IPRd0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 16 Sep 2013 13:33:26 -0400
Received: from [177.102.42.224] (helo=[192.168.1.143])
	by mail10.atlas.pipex.net with esmtpa (Exim 4.71)
	(envelope-from <it@sca-uk.com>)
	id 1VLcfp-0003le-Bl
	for linux-media@vger.kernel.org; Mon, 16 Sep 2013 18:33:21 +0100
Message-ID: <523740DA.2000107@sca-uk.com>
Date: Mon, 16 Sep 2013 14:33:14 -0300
From: Steve Cookson <it@sca-uk.com>
MIME-Version: 1.0
CC: linux-media@vger.kernel.org
Subject: Re: Hauppauge ImpactVCB-e 01381 PCIe driver resolution.
References: <5235CED8.3080804@sca-uk.com> <CAGoCfiyuvXAhBS=n=_3bZKnCSTZYMrHFJ73MfRnoiuW44Y=zKg@mail.gmail.com>
In-Reply-To: <CAGoCfiyuvXAhBS=n=_3bZKnCSTZYMrHFJ73MfRnoiuW44Y=zKg@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


Hi Devin,

Thanks for responding.

So my question would be then, is it worth fixing?

I can't find any PCIe cards that give me a reasonable quality.

If I use an external card like the Dazzle it seems quite fast and better 
quality than many s-video cards.

Could the ImpactVCB-e be better than the Dazzle?

Regards

Steve.



On 15/09/2013 17:26, Devin Heitmueller wrote:
 >
 >
 > On Sep 15, 2013 11:35 AM, "Steve Cookson" <it@sca-uk.com> wrote:
 > >
 > > Hi Guys,
 > >
 > > I seem to be having immense difficulty getting the Hauppauge 
ImpactVCB-e 01381 PCIe card working on Linux (I'm using Kubuntu 13.04) 
with greater than 320x240 resolution.
 > >
 > > This is what I've done:
 > >
 > > lspci recognises the card but only as a Conexant card (Vendor ID = 
14f1:8852), not Hauppauge card (Vendor ID = 0070). Hauppauge is shown as 
the subsystem (0070:7133).  I don't really know what this means.
 > >
 > > lsmod returns nothing related to the card.
 > >
 > > dmesg  | grep cx23885 suggested card=<n> insmod option (full output 
from dmesg below).  So I did:
 > >
 > > echo cx23885 card=5 | sudo tee -a /etc/modules
 > >
 > > So I tried a few version numbers, but they all give me 320x240 in 
s-video or composite mode.
 > >
 > > If I use a Pinnacle Dazzle, I get perfect 640x480 for about the 
same price.  But I need an internal PCIe card, rather than a external 
card/box.
 > >
 > > How can I add the card to video4Linux?
 > >
 > > Any help much appreciated.
 > >
 > > Regards
 > >
 > l believe the scaler is broken in the cx23885 driver.  I did a bunch 
of work on the driver last year to fix a variety of bugs, but didn't get 
around to making the scaler work properly.  Most likely the card only 
works right at it's max resolution (720x480 for NTSC or 720x576 for PAL).
 >
 > It can probably be made to work with a few hour's worth of debugging, 
but I didn't have a commercial customer at the time who needed it and as 
far as I know nobody else is working on it.
 >
 > Devin

