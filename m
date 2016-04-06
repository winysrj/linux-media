Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:57350 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932245AbcDFMJ0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 6 Apr 2016 08:09:26 -0400
Date: Wed, 6 Apr 2016 15:08:53 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Krzysztof =?utf-8?Q?Ha=C5=82asa?= <khalasa@piap.pl>
Cc: linux-media@vger.kernel.org
Subject: Re: Non-coherent (streaming) contig-dma?
Message-ID: <20160406120853.GM32125@valkosipuli.retiisi.org.uk>
References: <m3r3elh6wm.fsf@t19.piap.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <m3r3elh6wm.fsf@t19.piap.pl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Apr 04, 2016 at 02:53:29PM +0200, Krzysztof Hałasa wrote:
> Hi,
> 
> I know certain approaches had been tried to allow use of streaming DMA
> (dma_map_single() etc. - i.e., not coherent) in the media drivers, is
> there something which can be used at this point (for MMAP method)?
> 
> Coherent buffers on many systems are very slow (uncacheable), should
> i simply add/replace the necessary calls in dma-contig?
> 
> Any other options?
> 
> Is there any potential problem there?

I don't think there's a really good solution to the problem in upstream.

For what it's worth, the USERPTR buffers are allocated non-coherent, and the
cache is flushed when that's needed.

I have a patchset that makes it driver-selectable whether to request
coherent or non-coherent memory. I haven't had time to work on that for a
while, unfortunately, that work stalled in fixing a few drivers that access
the buffers using the CPU as well when they really should not do that.

I sent the set here under the subject "[RFC RESEND 00/11] vb2: Handle user
cache hints, allow drivers to choose cache coherency" last September.

If you don't need to access the buffers using the CPU, you could avoid
flushing the cache as well, but it requires patches from that set as well.

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
