Return-path: <linux-media-owner@vger.kernel.org>
Received: from colin.muc.de ([193.149.48.1]:1201 "EHLO mail.muc.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932979AbZIDJBI (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 4 Sep 2009 05:01:08 -0400
Date: Fri, 4 Sep 2009 10:32:56 +0200
From: Harald Milz <hm@seneca.muc.de>
To: linux-media@vger.kernel.org
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] diseqc 2.0 on stb0899 / pctv452e (TT S2-3xxx and
	the likes)
Message-ID: <20090904083256.GC7618@seneca.muc.de>
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
>

Does anyone have an idea as far as this matter? I'd like to use 2 or 3 S2-36xx
parts with a Quad monoblock LNB which in principle contains a DiSEqC switch.
Anything to watch out for? Am I looking for an LNB that talks DiSEqC 1.0? 


-- 
If all the world's economists were laid end to end, we wouldn't reach a
conclusion.
		-- William Baumol
