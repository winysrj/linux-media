Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.19]:50982 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757652AbaGAIjo (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 1 Jul 2014 04:39:44 -0400
Received: from minime.bse ([77.20.176.42]) by mail.gmx.com (mrgmx001) with
 ESMTPSA (Nemesis) id 0Mg3Vt-1XGO3H2A0z-00NU3d for
 <linux-media@vger.kernel.org>; Tue, 01 Jul 2014 10:39:42 +0200
Date: Tue, 1 Jul 2014 10:39:41 +0200
From: Daniel =?iso-8859-1?Q?Gl=F6ckner?= <daniel-gl@gmx.net>
To: =?utf-8?B?VmzEg2R1xaMgRnLEg8WjaW1hbg==?=
	<fratiman.vladut@gmail.com>
Cc: linux-media@vger.kernel.org
Subject: Re: bt878A card with 16 inputs
Message-ID: <20140701083941.GA14914@minime.bse>
References: <CANtDUYzhibHAis3Qg=nj=nbYf+NeUqS8GJ7kMm4nYZHOSBOBxA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CANtDUYzhibHAis3Qg=nj=nbYf+NeUqS8GJ7kMm4nYZHOSBOBxA@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On Tue, Jul 01, 2014 at 01:30:55AM +0300, Vlăduţ Frăţiman wrote:
> I have an capture card with two bt878A fusion chip and 16 imputs.
> Linux don't recognize and cannot get to work. How can do to resolve that?

> With regspy on indows i have this:
> BT878 Card [0]:
> 
> Vendor ID:           0x109e
> Device ID:           0x036e
> Subsystem ID:        0x00000000

No Subsystem ID => no automatic recognition possible.


> I try't all card numbers when load bttv module but in the best case
> only one camera i can see per device on channel 0 (using zoneminder).
> Because is a tunerless card, probably my problem is to make tuner on
> chip to work.

What we need is most likely the GPIO output enable and data values
reported by regspy and btspy. They should differ for each input.

It also helps if you make a high resolution scan of both sides of the
card and put it online somewhere (don't send it to the list!).

  Daniel
