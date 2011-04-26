Return-path: <mchehab@pedra>
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:54526 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754510Ab1DZLLb (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 26 Apr 2011 07:11:31 -0400
Message-ID: <4DB6A6F0.3080604@ladisch.de>
Date: Tue, 26 Apr 2011 13:05:20 +0200
From: Clemens Ladisch <clemens@ladisch.de>
MIME-Version: 1.0
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
CC: linux1394-devel@lists.sourceforge.net, alsa-devel@alsa-project.org,
	linux-media@vger.kernel.org
Subject: Re: [PATCH] firewire: octlet AT payloads can be stack-allocated
References: <4DA2B3DC.7010104@ladisch.de>	<4DA2B482.4060701@ladisch.de>	<20110411142651.638311e0@stein> <20110422151354.59c7ca77@stein>
In-Reply-To: <20110422151354.59c7ca77@stein>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Stefan Richter wrote:
> ...provided that the allocation persists until the packet was sent out
> to the bus.  But we do not need slab allocations anymore in order to
> satisfy streaming DMA mapping constraints, thanks to commit da28947e7e36
> "firewire: ohci: avoid separate DMA mapping for small AT payloads".
> 
> (Besides, the slab-allocated buffers that firewire-core, firewire-sbp2,
> and firedtv used to provide for 8-byte write and lock requests were
> still not fully portable since they crossed cacheline boundaries or
> shared a cacheline with unrelated CPU-accessed data.  snd-firewire-lib
> got this aspect right by using an extra kmalloc/ kfree just for the
> 8-byte transaction buffer.)
> 
> This change replaces kmalloc'ed lock transaction scratch buffers in
> firewire-core, firedtv, and snd-firewire-lib by local stack allocations.
> The lifetime requirement of these allocations is fulfilled because the
> call sites use the blocking fw_run_transaction API.
> 
> Perhaps the most notable result of the change is simpler locking because
> there is no need to serialize usages of preallocated per-device buffers
> anymore.  Also, allocations and deallocations are simpler.
> 
> firewire-sbp2's struct sbp2_orb.pointer buffer for 8-byte block write
> requests on the other hand needs to remain slab-allocated in order to
> keep the allocation around until end of AT DMA.
> 
> Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>

Acked-by: Clemens Ladisch <clemens@ladisch.de>
