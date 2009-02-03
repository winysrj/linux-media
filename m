Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp2-g21.free.fr ([212.27.42.2]:34176 "EHLO smtp2-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752132AbZBCSSx (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 3 Feb 2009 13:18:53 -0500
Date: Tue, 3 Feb 2009 19:13:11 +0100
From: Jean-Francois Moine <moinejf@free.fr>
To: kilgota@banach.math.auburn.edu
Cc: Adam Baker <linux@baker-net.org.uk>, linux-media@vger.kernel.org,
	Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH] Add support for sq905 based cameras to gspca
Message-ID: <20090203191311.2c1695b7@free.fr>
In-Reply-To: <alpine.LNX.2.00.0902031210320.1792@banach.math.auburn.edu>
References: <200901192322.33362.linux@baker-net.org.uk>
	<200901272101.27451.linux@baker-net.org.uk>
	<alpine.LNX.2.00.0901271543560.21122@banach.math.auburn.edu>
	<200901272228.42610.linux@baker-net.org.uk>
	<20090128113540.25536301@free.fr>
	<alpine.LNX.2.00.0901281554500.22748@banach.math.auburn.edu>
	<20090131203650.36369153@free.fr>
	<alpine.LNX.2.00.0902022032230.1080@banach.math.auburn.edu>
	<20090203103925.25703074@free.fr>
	<alpine.LNX.2.00.0902031115190.1706@banach.math.auburn.edu>
	<alpine.LNX.2.00.0902031210320.1792@banach.math.auburn.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, 3 Feb 2009 12:21:55 -0600 (CST)
kilgota@banach.math.auburn.edu wrote:

> I should add to the above that now I have tested, and indeed this
> change does not solve the problem of kernel oops after disconnect
> while streaming. It does make one change. The xterm does not go wild
> with error messages. But it is still not possible to close the svv
> window. Moreover, ps ax reveals that [svv] is running as an
> unkillable process, with [sq905/0] and [sq905/1], equally unkillable,
> in supporting roles. And dmesg reveals an oops. The problem is after
> all notorious by now, so I do not see much need for yet another log
> of debug output unless specifically asked for such.

Why is there 2 sq905 processes?

What is the oops? (Your last trace was good, because it gave the last
gspca/sq905 messages and the full oops)

> Perhaps we also need to do what Adam suggested yesterday, and add a
> call to destroy_urbs() in gspca_disconnect()?

Surely not! The destroy_urbs() must be called at the right time, i.e.
on close().

-- 
Ken ar c'hentan	|	      ** Breizh ha Linux atav! **
Jef		|		http://moinejf.free.fr/
