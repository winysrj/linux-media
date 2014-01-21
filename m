Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.22]:63923 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754457AbaAUKTy (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 21 Jan 2014 05:19:54 -0500
Received: from minime.bse ([77.20.120.199]) by mail.gmx.com (mrgmx103) with
 ESMTPSA (Nemesis) id 0MNZVG-1VyPpl3vkg-007G5X for
 <linux-media@vger.kernel.org>; Tue, 21 Jan 2014 11:19:52 +0100
Date: Tue, 21 Jan 2014 11:19:50 +0100
From: Daniel =?iso-8859-1?Q?Gl=F6ckner?= <daniel-gl@gmx.net>
To: Robert Longbottom <rongblor@googlemail.com>
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: Conexant PCI-8604PW 4 channel BNC Video capture card (bttv)
Message-ID: <20140121101950.GA13818@minime.bse>
References: <52DD977E.3000907@googlemail.com>
 <1c25db0a-f11f-4bc0-b544-692140799b2a@email.android.com>
 <7D00B0B1-8873-4CB2-903F-8B98749C75FF@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7D00B0B1-8873-4CB2-903F-8B98749C75FF@googlemail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Jan 21, 2014 at 09:27:38AM +0000, Robert Longbottom wrote:
> On 20 Jan 2014, at 10:55 PM, Andy Walls <awalls@md.metrocast.net> wrote:
> > Robert Longbottom <rongblor@googlemail.com> wrote:
> >> Chips on card:

> >> 1x SMD IC with no markings at all
> >> Couple of 74HCTnnn chips
> >> 1x Atmel 520

Can you upload high resolution pictures of both sides of the card
somewhere? Something where we can follow the tracks to these chips.
Scanning the card with 300dpi should be enough.

> >> 1x 35.46895M Crystal

Few cards use an 8x PAL Fsc crystal. Most have an NTSC crystal
(28.6363 MHz) and rely on the PLL for PAL. Maybe this helps to rule
out some card numbers.

  Daniel
