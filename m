Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp5-g21.free.fr ([212.27.42.5]:36564 "EHLO smtp5-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751012AbZDZKWN (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 26 Apr 2009 06:22:13 -0400
Date: Sun, 26 Apr 2009 12:05:12 +0200
From: Jean-Francois Moine <moinejf@free.fr>
To: kirin_e@users.sourceforge.net
Cc: linux-media@vger.kernel.org
Subject: Re: TV-8532A/ICM532B compression and modes
Message-ID: <20090426120512.6404e900@free.fr>
In-Reply-To: <Pine.GSO.4.58.0904242256500.7228@zvygba.sbkg.pbz>
References: <Pine.GSO.4.58.0904242256500.7228@zvygba.sbkg.pbz>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, 24 Apr 2009 23:16:12 +0200 (CEST)
kirin_e@users.sourceforge.net wrote:

> Hi,

Hi Kirin,

> a couple of months ago i did some hacking on the tv8532 gspca driver
> for my TV-8532A/ICM532B based webcam, to the point where i got
> decompression and most modes working. But i've kind of lost interest
> at this point, so haven't bothered to clean everything up for a real
> patch(also noticed it doesn't apply cleanly on 2.6.29 anymore).
> 
> In case it could be of help to someone else i've attached my two
> patches against the 2.6.28 kernel driver. First one fixes packet
> handling so it works with the different modes, the second add the
> actual modes i've been using + some misc changes i've been playing
> around with. Feel free to use or ignore as you will.
> 
> And probably the more useful part of my hacking, here's my notes on
> the compression used(got working decompression code, but not in a
> state i'd like to release):
	[snip]

Your patches seem very interesting! I would have merge it by myself,
but I have too much work. May you do patches for my test repository
(http://linuxtv.org/hg/~jfrancois/gspca)?

Cheers.

-- 
Ken ar c'hentañ	|	      ** Breizh ha Linux atav! **
Jef		|		http://moinejf.free.fr/
