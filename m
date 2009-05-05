Return-path: <linux-media-owner@vger.kernel.org>
Received: from co203.xi-lite.net ([149.6.83.203]:53233 "EHLO co203.xi-lite.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753915AbZEEICe (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 5 May 2009 04:02:34 -0400
Message-ID: <49FFEA86.5080508@parrot.com>
Date: Tue, 5 May 2009 09:28:06 +0200
From: Matthieu CASTET <matthieu.castet@parrot.com>
MIME-Version: 1.0
To: Paul Mundt <lethal@linux-sh.org>,
	Magnus Damm <magnus.damm@gmail.com>,
	<linux-media@vger.kernel.org>, <paulius.zaleckas@teltonika.lt>,
	<g.liakhovetski@gmx.de>, <matthieu.castet@parrot.com>
Subject: Re: [PATCH] videobuf-dma-contig: remove sync operation
References: <20090428084539.16911.79893.sendpatchset@rx1.opensource.se> <20090428085120.GC15695@linux-sh.org>
In-Reply-To: <20090428085120.GC15695@linux-sh.org>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Paul Mundt a écrit :
> On Tue, Apr 28, 2009 at 05:45:39PM +0900, Magnus Damm wrote:
>> From: Magnus Damm <damm@igel.co.jp>
>>
>> Remove the videobuf-dma-contig sync operation. Sync is only needed
>> for noncoherent buffers, and since videobuf-dma-contig is built on
>> coherent memory allocators the memory is by definition always in sync.
>>
> Note that this also fixes a bogus oops, which is what caused this to be
> brought up in the first place..
> 
>> Reported-by: Matthieu CASTET <matthieu.castet@parrot.com>
>> Signed-off-by: Magnus Damm <damm@igel.co.jp>
>> ---
>>
>>  Thanks to Mattieu, Paul and Paulius for all the help!
>>  Tested on SH7722 Migo-R with CEU and ov7725.
>>
>>  drivers/media/video/videobuf-dma-contig.c |   14 --------------
>>  1 file changed, 14 deletions(-)
>>
> Reviewed-by: Paul Mundt <lethal@linux-sh.org>
Test-by : Matthieu CASTET <matthieu.castet@parrot.com>

Well I backport it on a older kernel (2.6.27), but the result should be
the same.
