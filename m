Return-path: <linux-media-owner@vger.kernel.org>
Received: from gateway12.websitewelcome.com ([67.18.21.19]:38975 "EHLO
	gateway12.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934375Ab3FSX4j convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 19 Jun 2013 19:56:39 -0400
Received: from gator886.hostgator.com (gator886.hostgator.com [174.120.40.226])
	by gateway12.websitewelcome.com (Postfix) with ESMTP id B71AF58AB3B5E
	for <linux-media@vger.kernel.org>; Wed, 19 Jun 2013 18:35:04 -0500 (CDT)
From: "Charlie X. Liu" <charlie@sensoray.com>
To: "'James Board'" <jpboard2@yahoo.com>,
	=?UTF-8?Q?'Daniel_=EF=BB=BFGl=C3=B6ckner'?= <daniel-gl@gmx.net>,
	"'Steve Cookson'" <it@sca-uk.com>
Cc: <linux-media@vger.kernel.org>
References: <1371393161.46485.YahooMailNeo@web163903.mail.gq1.yahoo.com> <8B18C28300FE4A6595829F526C5BA94A@SACWS001> <1371572315.65617.YahooMailNeo@web163901.mail.gq1.yahoo.com> <8737EBB72A154800A3A695B49F355F07@SACWS001> <1371587831.30761.YahooMailNeo@web163905.mail.gq1.yahoo.com> <7ED70E19F5604D7CA44DC92735A6BDE0@SACWS001> <20130618230655.GA23989@minime.bse> <1371648937.52293.YahooMailNeo@web163906.mail.gq1.yahoo.com>
In-Reply-To: <1371648937.52293.YahooMailNeo@web163906.mail.gq1.yahoo.com>
Subject: RE: HD Capture Card (HDMI and Component) output raw pixels
Date: Wed, 19 Jun 2013 16:35:04 -0700
Message-ID: <004c01ce6d45$a0e73100$e2b59300$@com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Content-Language: en-us
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Refer to the discussion at: http://www.amazon.com/Blackmagic-Design-Intensity-Pro-Editing/product-reviews/B001CN9GEA ,
1) It does not support 1080p/60 or 1080p/50;
2) It uses YUV (4:2:2).

Charlie X. Liu


-----Original Message-----
From: linux-media-owner@vger.kernel.org [mailto:linux-media-owner@vger.kernel.org] On Behalf Of James Board
Sent: Wednesday, June 19, 2013 6:36 AM
To: Daniel ﻿Glöckner; Steve Cookson
Cc: linux-media@vger.kernel.org
Subject: Re: HD Capture Card (HDMI and Component) output raw pixels

You are right.  According to your numbers, this card can't work.  So why would BlackMagic design an HDMI capture card with only one PCIe lane if it can't possibly work?   It must work somehow.  I must be missing some crucial piece of information.

The card doesn't support hardware encoding, right?  If so, raw pixels are the only output.  Maybe the card uses more than one PCIe lane?  What makes you think the card only uses a single lane?  Are they using lossless compression to get the raw pixels data rate under 200-250 MB/sec, which is the PCIe speed?
 
Jim


----- Original Message -----
From: Daniel ﻿Glöckner <daniel-gl@gmx.net>
To: Steve Cookson <it@sca-uk.com>
Cc: 'James Board' <jpboard2@yahoo.com>; linux-media@vger.kernel.org
Sent: Tuesday, June 18, 2013 7:06 PM
Subject: Re: HD Capture Card (HDMI and Component) output raw pixels

On Tue, Jun 18, 2013 at 05:55:15PM -0300, Steve Cookson wrote:
> > I don't want to configure a RAID either, but if I purchase one SSD 
> > with
> 400 MB/sec write speeds, that might be good.
> 
> Hmm... nice idea.  Did you have any particular model in mind?  If you 
> had a link, I might be interested. I wouldn't know about sizing.  I 
> don't know how much space HD raw video takes up per hour, say.

That's easy. My current video mode is 24 bit 1920x1080 at 50 fps.
So there are 3*1920*1080*50 bytes per second or about 1.1TB per hour.
But you won't be able to capture all frames with that card. The single lane PCIe 1.x bus will max out at 200~250MB/s.

  Daniel

--
To unsubscribe from this list: send the line "unsubscribe linux-media" in the body of a message to majordomo@vger.kernel.org More majordomo info at  http://vger.kernel.org/majordomo-info.html

