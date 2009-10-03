Return-path: <linux-media-owner@vger.kernel.org>
Received: from poutre.nerim.net ([62.4.16.124]:62314 "EHLO poutre.nerim.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750750AbZJCMEt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 3 Oct 2009 08:04:49 -0400
Date: Sat, 3 Oct 2009 14:04:47 +0200
From: Jean Delvare <khali@linux-fr.org>
To: =?UTF-8?B?UGF3ZcWC?= Sikora <pluto@agmk.net>
Cc: Andy Walls <awalls@radix.net>, linux-kernel@vger.kernel.org,
	LMML <linux-media@vger.kernel.org>
Subject: Re: [2.6.31] ir-kbd-i2c oops.
Message-ID: <20091003140447.6486ed82@hyperion.delvare>
In-Reply-To: <200910031208.36524.pluto@agmk.net>
References: <200909160300.28382.pluto@agmk.net>
	<1254354727.4771.13.camel@palomino.walls.org>
	<20091001134343.30e7cd98@hyperion.delvare>
	<200910031208.36524.pluto@agmk.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Pawel,

On Sat, 3 Oct 2009 12:08:36 +0200, Paweł Sikora wrote:
> On Thursday 01 October 2009 13:43:43 Jean Delvare wrote:
> 
> > Pawel, please give a try to the following patch. Please keep the debug
> > patches apply too, in case we need additional info.
> 
> the second patch helps. here's a dmesg log.

OK. So the bug is exactly what I said on my very first reply. And the
patch I pointed you to back then should have fixed it:
http://patchwork.kernel.org/patch/45707/
You said it didn't, which makes me wonder if you really tested it
properly...

Anyway this is already fixed upstream, and the fix should be backported
to 2.6.31-stable quickly. I'll make sure it happens.

-- 
Jean Delvare
http://khali.linux-fr.org/wishlist.html
