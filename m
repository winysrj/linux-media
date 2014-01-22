Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.15]:55269 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755168AbaAVLxi (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 22 Jan 2014 06:53:38 -0500
Received: from minime.bse ([77.20.120.199]) by mail.gmx.com (mrgmx102) with
 ESMTPSA (Nemesis) id 0MbJTE-1VnJal3xQa-00In1z for
 <linux-media@vger.kernel.org>; Wed, 22 Jan 2014 12:53:36 +0100
Date: Wed, 22 Jan 2014 12:53:34 +0100
From: Daniel =?iso-8859-1?Q?Gl=F6ckner?= <daniel-gl@gmx.net>
To: Robert Longbottom <rongblor@googlemail.com>
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: Conexant PCI-8604PW 4 channel BNC Video capture card (bttv)
Message-ID: <20140122115334.GA14710@minime.bse>
References: <52DD977E.3000907@googlemail.com>
 <1c25db0a-f11f-4bc0-b544-692140799b2a@email.android.com>
 <7D00B0B1-8873-4CB2-903F-8B98749C75FF@googlemail.com>
 <20140121101950.GA13818@minime.bse>
 <52DECF44.1070609@googlemail.com>
 <52DEDFCB.6010802@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52DEDFCB.6010802@googlemail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Jan 21, 2014 at 08:59:55PM +0000, Robert Longbottom wrote:
> On 21/01/2014 19:49, Robert Longbottom wrote:
> >Here are some high-res pictures of both sides of the card.  Scanned at
> >600dpi (300dpi the tracks were very close).  Good idea to scan it by the
> >way, I like that, much better result than with a digital camera.
> >
> >http://www.flickr.com/photos/astrofraggle/12073752546/sizes/l/
> >http://www.flickr.com/photos/astrofraggle/12073651306/sizes/l/


ok:
 - The Atmel chip is an AT24C02 EEPROM. Does one of the 878As have a PCI
   subsystem ID?

 - The 74HCT04 is used to drive the clock from the oscillator to the
   878As.

 - The 74HCT245 is a bus driver for four pins of the connector CN3.

 - The unlabled chip is probably a CPLD/FGPA. It filters the PCI REQ#
   lines from the 878As and has access to the GNT# and INT# lines,
   as well as to the GPIOs you mentioned. The bypass caps have a layout
   that fits to the Lattice ispMACH 4A.

 - There is no mux or gate between the BNC connectors and the 878As.
   The BNCs are on MUX0. MUX1 is connected to the two unpopulated 2x5
   Headers.

So the UNKNOWN/GENERIC card entry should have the BNC connectors on its
first V4L input.

Have you tried passing pll=35,35,35,35 as module parameter?

  Daniel
