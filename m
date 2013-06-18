Return-path: <linux-media-owner@vger.kernel.org>
Received: from outmail148134.authsmtp.com ([62.13.148.134]:52833 "EHLO
	outmail148134.authsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933060Ab3FRTzu convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 18 Jun 2013 15:55:50 -0400
From: "Steve Cookson" <it@sca-uk.com>
To: "'James Board'" <jpboard2@yahoo.com>
Cc: <linux-media@vger.kernel.org>
References: <1371393161.46485.YahooMailNeo@web163903.mail.gq1.yahoo.com> <8B18C28300FE4A6595829F526C5BA94A@SACWS001> <1371572315.65617.YahooMailNeo@web163901.mail.gq1.yahoo.com>
Subject: RE: HD Capture Card (HDMI and Component) output raw pixels
Date: Tue, 18 Jun 2013 16:38:08 -0300
Message-ID: <8737EBB72A154800A3A695B49F355F07@SACWS001>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
In-Reply-To: <1371572315.65617.YahooMailNeo@web163901.mail.gq1.yahoo.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Jim,

The Balckmagic Card does not seem to have any hardware compression, for me
that's a drawback, but if that's what you want it may be the right thing.

I want to avoid RAID 0 disks if I can.

It appears to be supported by Linux in the GStreamer bad pluggins, it's
called decklinksrc.  There is another allied one called the DeckLink mini
recorder also from Blackmagic PCIe for $145  it's on the same site, so you
might like to have a look at that too.

Blackmagic also provide a Linux SDK and some linux tools.  If you can't find
them I'll send you a link.

I'm going to buy one for testing over the next month or so, so if you want
to keep in touch, I'll let you know how it goes.

Regards

Steve

-----Original Message-----
From: James Board [mailto:jpboard2@yahoo.com] 
Sent: 18 June 2013 13:19
To: Steve Cookson
Subject: Re: HD Capture Card (HDMI and Component) output raw pixels

Hi Steve,

I haven't found a Capture card yet.  The KernelLabs drivers are only
available to commercial buyers, not for personal use.

The Blackmagic card you mentioned looks good.  Do you know if that card
captures in a raw uncompressed format?  Also, do you know if it's supported
by Linux?

Jim





----- Original Message -----
From: Steve Cookson <it@sca-uk.com>
To: 'James Board' <jpboard2@yahoo.com>; linux-media@vger.kernel.org
Cc: 
Sent: Sunday, June 16, 2013 3:15 PM
Subject: RE: HD Capture Card (HDMI and Component) output raw pixels

Hi Guys,

> I'm looking for a capture card for a Linux 
> system.  I'd like to be able to capture Component 
> as well as HDMI (from non-encrypted non-HDCP) 
> sources.  I'd also like to capture the raw pixels, 
> and not use real-time MPEG encoding.  A lossless 
> output format like huffyuv is okay too.  Are any 
> such cards available for Linux systems?

I have the same question.  I'm about to try the Blackmagic 
Design Intensity Pro for a bit under $200.  

http://www.amazon.com/dp/B001CN9GEA

Any othe hints welcomed.

> Also, if this isn't the best place to ask for this 
> kind of thing, can someone then point me to a better place/website?

Ditto,

Regards

Steve

