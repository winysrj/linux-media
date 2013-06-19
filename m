Return-path: <linux-media-owner@vger.kernel.org>
Received: from gateway08.websitewelcome.com ([67.18.36.18]:48013 "EHLO
	gateway08.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934170Ab3FTAGs convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 19 Jun 2013 20:06:48 -0400
Received: from gator886.hostgator.com (gator886.hostgator.com [174.120.40.226])
	by gateway08.websitewelcome.com (Postfix) with ESMTP id C6A5D8A873CB3
	for <linux-media@vger.kernel.org>; Wed, 19 Jun 2013 18:46:01 -0500 (CDT)
From: "Charlie X. Liu" <charlie@sensoray.com>
To: =?UTF-8?Q?'Bj=C3=B8rn_Mork'?= <bjorn@mork.no>,
	"'James Board'" <jpboard2@yahoo.com>
Cc: =?UTF-8?Q?'Daniel_=EF=BB=BFGl=C3=B6ckner'?= <daniel-gl@gmx.net>,
	"'Steve Cookson'" <it@sca-uk.com>, <linux-media@vger.kernel.org>
References: <1371393161.46485.YahooMailNeo@web163903.mail.gq1.yahoo.com>	<8B18C28300FE4A6595829F526C5BA94A@SACWS001>	<1371572315.65617.YahooMailNeo@web163901.mail.gq1.yahoo.com>	<8737EBB72A154800A3A695B49F355F07@SACWS001>	<1371587831.30761.YahooMailNeo@web163905.mail.gq1.yahoo.com>	<7ED70E19F5604D7CA44DC92735A6BDE0@SACWS001>	<20130618230655.GA23989@minime.bse>	<1371648937.52293.YahooMailNeo@web163906.mail.gq1.yahoo.com> <87ip1a42fa.fsf@nemi.mork.no>
In-Reply-To: <87ip1a42fa.fsf@nemi.mork.no>
Subject: RE: HD Capture Card (HDMI and Component) output raw pixels
Date: Wed, 19 Jun 2013 16:46:02 -0700
Message-ID: <005201ce6d47$28a79520$79f6bf60$@com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Content-Language: en-us
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

If 1080i60 or 1080p30 as max supported, the bandwidth requirement would be 124.416MB/s (1920*1080*2*30, in YUV422 format). Make sense and it can pass through over a PCIe lane x1.


-----Original Message-----
From: linux-media-owner@vger.kernel.org [mailto:linux-media-owner@vger.kernel.org] On Behalf Of Bjørn Mork
Sent: Wednesday, June 19, 2013 7:10 AM
To: James Board
Cc: Daniel ﻿Glöckner; Steve Cookson; linux-media@vger.kernel.org
Subject: Re: HD Capture Card (HDMI and Component) output raw pixels

James Board <jpboard2@yahoo.com> writes:

> You are right.  According to your numbers, this card can't work.  So 
> why would BlackMagic design an HDMI capture card with only one PCIe 
> lane if it can't possibly work?   It must work somehow.  I must be 
> missing some crucial piece of information.
>
> The card doesn't support hardware encoding, right?  If so, raw pixels 
> are the only output.  Maybe the card uses more than one PCIe lane?
> What makes you think the card only uses a single lane?

http://www.blackmagicdesign.com/products/intensity/techspecs/ says so.
It also says

 HD Format Support: 1080i50, 1080i59.94, 1080i60, 1080p23.98, 1080p24,
                    1080p25, 1080p29.97, 1080p30, 720p50, 720p59.94 and
                    720p60.

which makes the 1080p50 calculation a bit irrelevant.

> Are they using lossless compression to get the raw pixels data rate 
> under 200-250 MB/sec, which is the PCIe speed?

None of the supported formats need more than ~180 MB/sec.


Bjørn
--
To unsubscribe from this list: send the line "unsubscribe linux-media" in the body of a message to majordomo@vger.kernel.org More majordomo info at  http://vger.kernel.org/majordomo-info.html

