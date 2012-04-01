Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout-de.gmx.net ([213.165.64.23]:49244 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751945Ab2DAPEQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 1 Apr 2012 11:04:16 -0400
From: "Hans-Frieder Vogt" <hfvogt@gmx.net>
To: Antti Palosaari <crope@iki.fi>
Subject: Re: [GIT PULL FOR 3.5] AF9035/AF9033/TUA9001 => TerraTec Cinergy T Stick [0ccd:0093]
Date: Sun, 1 Apr 2012 17:04:09 +0200
Cc: linux-media@vger.kernel.org
References: <4F75A7FE.8090405@iki.fi> <201204011631.47333.hfvogt@gmx.net> <4F786D86.90404@iki.fi>
In-Reply-To: <4F786D86.90404@iki.fi>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201204011704.09218.hfvogt@gmx.net>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am Sonntag, 1. April 2012 schrieb Antti Palosaari:
> On 01.04.2012 17:31, Hans-Frieder Vogt wrote:
> > Antti,
> > 
> > I could provide the SNR, BER and UCB implementation (simply porting from
> > my draft driver to yours).
> > But I first need to implement the support for my AverMedia A867R device
> > so that I am able to test the implementation. Therefore it could take a
> > few hours (maybe until tomorrow).
> 
> Aaah, OK, but I was just working with SNR. I see your driver SNR was
> just register scaled to 0-0xffff whilst we nowadays prefer dBs , most
> commonly unit of 0.1 dB. So if thats OK for you I will finish that, and
> you can do BER and UCB, OK?

OK, I'll focus on these.

> 
> regards
> 
> Antti

[...]

cheers,

Hans-Frieder Vogt                       e-mail: hfvogt <at> gmx .dot. net
