Return-path: <linux-media-owner@vger.kernel.org>
Received: from colin.muc.de ([193.149.48.1]:2179 "EHLO mail.muc.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751558AbZLTOHv (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 20 Dec 2009 09:07:51 -0500
Date: Sun, 20 Dec 2009 14:40:33 +0100
From: Harald Milz <hm@seneca.muc.de>
To: linux-media@vger.kernel.org, linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] diseqc 2.0 on stb0899 / pctv452e (TT S2-3xxx and
	the likes)
Message-ID: <20091220134033.GA1167@seneca.muc.de>
References: <4A7F3EE9.3080506@gangkast.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A7F3EE9.3080506@gangkast.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, Aug 09, 2009 at 11:26:01PM +0200, Martijn wrote:
> When I go through the s2-liplianin dvb drivers I noticed the DiSEqC 2.0 
> freq marker in the stb0899_priv.h header file. Also according to the 
> STB0899 datasheet DiSEqC 2.0 is supported. Does this mean that the pctv452e 
> driver does not implement the 2.0 specifications? I have seen the S2-3650 
> work through a DiSEqC 1.0 switch without any problems.

Does anyone have an idea as far as this matter? I'd like to use 2 or 3 S2-36xx
parts with a Quad monoblock LNB (Lemon-Inverto) which in principle contains a
DiSEqC switch.

I tried an earlier HG pull from September but my LNB seems to receive only
Hotbird channels, and not all of them to begin with. No Astra channels so far.

I see no mentions of a newer DiSEqC code in pctv452e.c in the changelog - was
there any progress on this? 

TIA!

-- 
We really don't have any enemies.  It's just that some of our best
friends are trying to kill us.
