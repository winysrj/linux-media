Return-path: <linux-media-owner@vger.kernel.org>
Received: from 124x34x33x190.ap124.ftth.ucom.ne.jp ([124.34.33.190]:36732 "EHLO
	master.linux-sh.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752444AbZD1I4h (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 28 Apr 2009 04:56:37 -0400
Date: Tue, 28 Apr 2009 17:51:20 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Magnus Damm <magnus.damm@gmail.com>
Cc: linux-media@vger.kernel.org, paulius.zaleckas@teltonika.lt,
	g.liakhovetski@gmx.de, matthieu.castet@parrot.com
Subject: Re: [PATCH] videobuf-dma-contig: remove sync operation
Message-ID: <20090428085120.GC15695@linux-sh.org>
References: <20090428084539.16911.79893.sendpatchset@rx1.opensource.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090428084539.16911.79893.sendpatchset@rx1.opensource.se>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Apr 28, 2009 at 05:45:39PM +0900, Magnus Damm wrote:
> From: Magnus Damm <damm@igel.co.jp>
> 
> Remove the videobuf-dma-contig sync operation. Sync is only needed
> for noncoherent buffers, and since videobuf-dma-contig is built on
> coherent memory allocators the memory is by definition always in sync.
> 
Note that this also fixes a bogus oops, which is what caused this to be
brought up in the first place..

> Reported-by: Matthieu CASTET <matthieu.castet@parrot.com>
> Signed-off-by: Magnus Damm <damm@igel.co.jp>
> ---
> 
>  Thanks to Mattieu, Paul and Paulius for all the help!
>  Tested on SH7722 Migo-R with CEU and ov7725.
> 
>  drivers/media/video/videobuf-dma-contig.c |   14 --------------
>  1 file changed, 14 deletions(-)
> 
Reviewed-by: Paul Mundt <lethal@linux-sh.org>
