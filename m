Return-path: <linux-media-owner@vger.kernel.org>
Received: from nm3-vm6.bullet.mail.gq1.yahoo.com ([98.136.218.149]:46175 "EHLO
	nm3-vm6.bullet.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756551Ab3FSNlP convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 19 Jun 2013 09:41:15 -0400
References: <1371393161.46485.YahooMailNeo@web163903.mail.gq1.yahoo.com>
 <8B18C28300FE4A6595829F526C5BA94A@SACWS001>
 <1371572315.65617.YahooMailNeo@web163901.mail.gq1.yahoo.com>
 <8737EBB72A154800A3A695B49F355F07@SACWS001>
 <1371587831.30761.YahooMailNeo@web163905.mail.gq1.yahoo.com>
 <7ED70E19F5604D7CA44DC92735A6BDE0@SACWS001> <20130618230655.GA23989@minime.bse>
Message-ID: <1371648937.52293.YahooMailNeo@web163906.mail.gq1.yahoo.com>
Date: Wed, 19 Jun 2013 06:35:37 -0700 (PDT)
From: James Board <jpboard2@yahoo.com>
Reply-To: James Board <jpboard2@yahoo.com>
Subject: Re: HD Capture Card (HDMI and Component) output raw pixels
To: =?utf-8?B?RGFuaWVsIO+7v0dsw7Zja25lcg==?= <daniel-gl@gmx.net>,
	Steve Cookson <it@sca-uk.com>
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
In-Reply-To: <20130618230655.GA23989@minime.bse>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

You are right.  According to your numbers, this card can't work.  So why would BlackMagic design an HDMI capture card with only one PCIe lane if it can't possibly work?   It must work somehow.  I must be missing some crucial piece of information.

The card doesn't support hardware encoding, right?  If so, raw pixels are the only output.  Maybe the card uses more than one PCIe lane?  What makes you think the card only uses a single lane?  Are they using lossless compression to get the raw pixels data rate under 200-250 MB/sec, which is the PCIe speed?
 
Jim




----- Original Message -----
From: Daniel ﻿Glöckner <daniel-gl@gmx.net>
To: Steve Cookson <it@sca-uk.com>
Cc: 'James Board' <jpboard2@yahoo.com>; linux-media@vger.kernel.org
Sent: Tuesday, June 18, 2013 7:06 PM
Subject: Re: HD Capture Card (HDMI and Component) output raw pixels

On Tue, Jun 18, 2013 at 05:55:15PM -0300, Steve Cookson wrote:
> > I don't want to configure a RAID either, but if I purchase one SSD with
> 400 MB/sec write speeds, that might be good.
> 
> Hmm... nice idea.  Did you have any particular model in mind?  If you had a
> link, I might be interested. I wouldn't know about sizing.  I don't know how
> much space HD raw video takes up per hour, say.

That's easy. My current video mode is 24 bit 1920x1080 at 50 fps.
So there are 3*1920*1080*50 bytes per second or about 1.1TB per hour.
But you won't be able to capture all frames with that card. The single
lane PCIe 1.x bus will max out at 200~250MB/s.

  Daniel

