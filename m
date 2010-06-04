Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ew0-f223.google.com ([209.85.219.223]:45033 "EHLO
	mail-ew0-f223.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752032Ab0FDPiR (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 4 Jun 2010 11:38:17 -0400
Date: Fri, 4 Jun 2010 17:37:58 +0200
From: Dan Carpenter <error27@gmail.com>
To: walter harms <wharms@bfs.de>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
	Frederic Weisbecker <fweisbec@gmail.com>,
	Arnd Bergmann <arnd@arndb.de>, linux-media@vger.kernel.org,
	kernel-janitors@vger.kernel.org
Subject: Re: [patch] V4L/DVB: dvb_ca_en50221: return -EFAULT on
	copy_to_user errors
Message-ID: <20100604153758.GG5483@bicker>
References: <20100604103629.GC5483@bicker> <4C08F0DD.50702@bfs.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C08F0DD.50702@bfs.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Jun 04, 2010 at 02:26:05PM +0200, walter harms wrote:
> 
> Doint to many things at once is bad. IMHO it is more readable to do so:
> 
> +status = copy_to_user(buf, hdr, 2);
> +if ( status  != 0) {
> 
> Maybe the maintainer has different ideas but especialy lines like will gain.
> 
> -if ((status = copy_from_user(fragbuf + 2, buf + fragpos, fraglen)) != 0)
> +status = copy_from_user(fragbuf + 2, buf + fragpos, fraglen):
> +if ( status  != 0) {
> 
> just my 2 cents,

You're right of course as always and checkpatch warns about these as
well.

I figured if it was in the original code, it was probably OK to leave it.
But I now recognize this as pure laziness on my part and I appologize.  
Twenty lashes for me and all that.  Fixed patch coming up.  ;)

regards,
dan carpenter


