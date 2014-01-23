Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.18]:49908 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752717AbaAWN1q (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 23 Jan 2014 08:27:46 -0500
Received: from minime.bse ([77.20.120.199]) by mail.gmx.com (mrgmx002) with
 ESMTPSA (Nemesis) id 0MGSDw-1W1wbg3T3Q-00DFJw for
 <linux-media@vger.kernel.org>; Thu, 23 Jan 2014 14:27:44 +0100
Date: Thu, 23 Jan 2014 14:27:41 +0100
From: Daniel =?iso-8859-1?Q?Gl=F6ckner?= <daniel-gl@gmx.net>
To: Robert Longbottom <rongblor@googlemail.com>
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: Conexant PCI-8604PW 4 channel BNC Video capture card (bttv)
Message-ID: <20140123132741.GA15756@minime.bse>
References: <52DD977E.3000907@googlemail.com>
 <1c25db0a-f11f-4bc0-b544-692140799b2a@email.android.com>
 <7D00B0B1-8873-4CB2-903F-8B98749C75FF@googlemail.com>
 <20140121101950.GA13818@minime.bse>
 <52DECF44.1070609@googlemail.com>
 <52DEDFCB.6010802@googlemail.com>
 <20140122115334.GA14710@minime.bse>
 <52DFC300.8010508@googlemail.com>
 <20140122135036.GA14871@minime.bse>
 <52E00AD0.2020402@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <52E00AD0.2020402@googlemail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Jan 22, 2014 at 06:15:44PM +0000, Robert Longbottom wrote:
> On 22/01/14 13:50, Daniel Glöckner wrote:
> >This is strange. There are 7 different IRQs assigned to that card but
> >PCI slots only have 4. According to the pictures each 878A gets one of
> >these. The .0 and .1 functions of a 878A must always share the same IRQ.

It seems the .1 functions still show the IRQ assigned by the BIOS, while
the .0 functions had their IRQ reassigned when a driver was bound.
The .1 IRQ would probably have been reassigned as well if you tried
to use the audio driver. I don't think this is the problem.

Can you try to load bttv with irq_debug=1? 
This should generate a lot of output.

  Daniel
