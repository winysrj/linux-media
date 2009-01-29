Return-path: <linux-media-owner@vger.kernel.org>
Received: from uucp.cirr.com ([192.67.63.5]:55313 "EHLO killer.cirr.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752494AbZA2Eru (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 28 Jan 2009 23:47:50 -0500
Received: from afc by tashi.lonestar.org with local (Exim 4.69)
	(envelope-from <afc@shibaya.lonestar.org>)
	id 1LSOJh-0002lO-KG
	for linux-media@vger.kernel.org; Wed, 28 Jan 2009 23:15:49 -0500
Date: Wed, 28 Jan 2009 23:15:49 -0500
From: "A. F. Cano" <afc@shibaya.lonestar.org>
To: linux-media@vger.kernel.org
Subject: Re: [linux-dvb] Tuning a pvrusb2 device.  Every attempt has failed.
Message-ID: <20090129041549.GC5361@shibaya.lonestar.org>
References: <20090123015815.GA22113@shibaya.lonestar.org> <497CB355.3030408@rogers.com> <20090125214637.GA11948@shibaya.lonestar.org> <497CE87A.3090605@rogers.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <497CE87A.3090605@rogers.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, Jan 25, 2009 at 05:32:26PM -0500, CityK wrote:
> ...
> Okay. One suggestion I have here is taking the pre-amp out of the chain
> right now, and just test with as basic a setup as possible.

This is how I started.  I got nothing at all.  I just posted some of the
latest details in another sub-thread.  My problem is too little signal.

> ... [ thanks for the details ]
> 
> I'd step back from testing with Myth right now -- it adds to much of
> extra layer of complexity and sources for further error. In terms of
> just testing to make sure that the device is working correctly, just
> stick with the basic apps for the time being (scan, azap, mplayer,
> femon....)

I will proceed with these tools.

> ... [ about kaffeine ]
> Reviewing your prior message, I'd suspect that dvbtune just doesn't have
> support for ATSC. As you note, the other stuff is for analog.
> 
> The fact that you have the device node created and the populated by the
> character devices, along with the femon result is encouraging.
> Similarly, that scan is detecting something on several frequencies (just
> not enough to capture any info for it) is also encouraging. I suspect
> that it comes down to a case of the antenna/cable configuration ... as

It looks like you are correct.  I'm going to have to install it on the
roof.

> noted before, take the amp out of the chain and retry ... also, if
> possible, can you obtain a signal under Windows?

Unfortunately (or should I say fortunately?) I've been windows-free
essentially forever (I got started in Unix) and I only deal with windows
when I have to.  I suppose that's a disadvantage in some cases, like right
now...

Anyway, Thanks a bunch for taking the time to answer.

A.


