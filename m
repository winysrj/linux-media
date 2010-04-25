Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:45572 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753291Ab0DYQ4K (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 25 Apr 2010 12:56:10 -0400
Message-ID: <4BD47410.9000006@redhat.com>
Date: Sun, 25 Apr 2010 13:55:44 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Guy Martin <gmsoft@tuxicoman.be>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: Xawtv sparc 64bit fix
References: <20100423170316.12e01bfc@borg.bxl.tuxicoman.be>
In-Reply-To: <20100423170316.12e01bfc@borg.bxl.tuxicoman.be>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Guy Martin wrote:
> 
> Hi,
> 
> Here is an old patch of mine which I tried to submit in 2006 but never
> got it. I didn't really know who was xawtv's maintainer at that time.
> 
> 
> 
> The calculation to compute the 64bit alignement in struct-dump.c is
> plain wrong. The alignment has to be computed with a structure
> containing a char and then a 64bit integer and then substract the
> pointer of the 64bit int to the one of the char.
> 
> This fix v4l-info doing a Bus Error on sparc with structs containing
> 64 bit integer following a non 64bit field aligned on a 8 byte boundary
> like v4l2_standard.
> 
> 
> Signed-off-by: Guy Martin <gmsoft@tuxicoman.be>

I tried to compile it (x86_64 arch) and your patch produced two warnings:

../structs/struct-dump.c: In function ‘print_struct’:
../structs/struct-dump.c:48: warning: cast from pointer to integer of different size
../structs/struct-dump.c:48: warning: cast from pointer to integer of different size

Could you please fix it?

> 
> 
> Regards,
>   Guy
> 


-- 

Cheers,
Mauro
