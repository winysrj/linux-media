Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.20]:53695 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751130AbaAZMz4 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 26 Jan 2014 07:55:56 -0500
Received: from minime.bse ([77.20.120.199]) by mail.gmx.com (mrgmx102) with
 ESMTPSA (Nemesis) id 0Mc8Pz-1Vp31Q1rQl-00JbNU for
 <linux-media@vger.kernel.org>; Sun, 26 Jan 2014 13:55:55 +0100
Date: Sun, 26 Jan 2014 13:55:53 +0100
From: Daniel =?iso-8859-1?Q?Gl=F6ckner?= <daniel-gl@gmx.net>
To: Robert Longbottom <rongblor@googlemail.com>
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: Conexant PCI-8604PW 4 channel BNC Video capture card (bttv)
Message-ID: <20140126125552.GA26918@minime.bse>
References: <52DECF44.1070609@googlemail.com>
 <52DEDFCB.6010802@googlemail.com>
 <20140122115334.GA14710@minime.bse>
 <52DFC300.8010508@googlemail.com>
 <20140122135036.GA14871@minime.bse>
 <52E00AD0.2020402@googlemail.com>
 <20140123132741.GA15756@minime.bse>
 <52E1273F.90207@googlemail.com>
 <20140125152339.GA18168@minime.bse>
 <52E4EFBB.7070504@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52E4EFBB.7070504@googlemail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, Jan 26, 2014 at 11:21:31AM +0000, Robert Longbottom wrote:
> 0F0 000000F9 PLL_F_LO
> 0F4 000000DC PLL_F_HI
> 0F8 0000008E PLL_XCI

The PLL is enabled and configured for a 28.63636MHz input clock.
With the default board config these registers are not touched
at all, so this must be a remnant of testing with another board
number. Please repeat with pll=35,35,35,35 .

  Daniel
