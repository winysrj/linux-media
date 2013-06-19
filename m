Return-path: <linux-media-owner@vger.kernel.org>
Received: from canardo.mork.no ([148.122.252.1]:34828 "EHLO canardo.mork.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933833Ab3FSOKa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 19 Jun 2013 10:10:30 -0400
From: =?utf-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>
To: James Board <jpboard2@yahoo.com>
Cc: Daniel =?utf-8?B?77u/R2zDtmNrbmVy?= <daniel-gl@gmx.net>,
	Steve Cookson <it@sca-uk.com>,
	"linux-media\@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: HD Capture Card (HDMI and Component) output raw pixels
References: <1371393161.46485.YahooMailNeo@web163903.mail.gq1.yahoo.com>
	<8B18C28300FE4A6595829F526C5BA94A@SACWS001>
	<1371572315.65617.YahooMailNeo@web163901.mail.gq1.yahoo.com>
	<8737EBB72A154800A3A695B49F355F07@SACWS001>
	<1371587831.30761.YahooMailNeo@web163905.mail.gq1.yahoo.com>
	<7ED70E19F5604D7CA44DC92735A6BDE0@SACWS001>
	<20130618230655.GA23989@minime.bse>
	<1371648937.52293.YahooMailNeo@web163906.mail.gq1.yahoo.com>
Date: Wed, 19 Jun 2013 16:10:01 +0200
In-Reply-To: <1371648937.52293.YahooMailNeo@web163906.mail.gq1.yahoo.com>
	(James Board's message of "Wed, 19 Jun 2013 06:35:37 -0700 (PDT)")
Message-ID: <87ip1a42fa.fsf@nemi.mork.no>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

James Board <jpboard2@yahoo.com> writes:

> You are right.  According to your numbers, this card can't work.  So
> why would BlackMagic design an HDMI capture card with only one PCIe
> lane if it can't possibly work?   It must work somehow.  I must be
> missing some crucial piece of information.
>
> The card doesn't support hardware encoding, right?  If so, raw pixels
> are the only output.  Maybe the card uses more than one PCIe lane? 
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
