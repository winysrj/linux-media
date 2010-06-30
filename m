Return-path: <linux-media-owner@vger.kernel.org>
Received: from emh03.mail.saunalahti.fi ([62.142.5.109]:50721 "EHLO
	emh03.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753170Ab0F3Smq (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 30 Jun 2010 14:42:46 -0400
Message-ID: <4C2B9020.9030905@kolumbus.fi>
Date: Wed, 30 Jun 2010 21:42:40 +0300
From: Marko Ristola <marko.ristola@kolumbus.fi>
MIME-Version: 1.0
To: Steven Toth <stoth@kernellabs.com>
CC: Manu Abraham <abraham.manu@gmail.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: buffer management
References: <AANLkTikuPBKre8wjkGZ-fXhQc5ad_OmNtERvFslpPXvR@mail.gmail.com> <4C220165.50809@kernellabs.com>
In-Reply-To: <4C220165.50809@kernellabs.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

23.06.2010 15:43, Steven Toth kirjoitti:
>> Now, on each video interrupt, I know which SG list i need to read
>> from. At this stage i do need to copy the
>> buffers associated with each of the SG lists at once. In this
>> scenario, I don't see how videobuf could be used,
>> while I keep getting this feeling that a simple copy_to_user of the
>> entire buffer could do the whole job in a
>> better way, since the buffers themselves are already managed and
>> initialized already. Am I correct in thinking
>> so, or is it that I am overlooking something ?

I've thought this a bit. I didn't find any good easy solution for
copying directly into users pace.


Here are the easiest trivial speed improvements I found:
dvb_core: dvb_dmx_swfilter(_204) functions:
- avoid unnecessary packet copying.
- I emailed those patches. You can see the difference with "perf top"
easilly
  (Fedora at least has perf).
  So with this the copying into ringbuffer remains as an unnecessary thing.
Mantis: Don't do busy looping on mantis_i2c.c


Harder algorithm that does only copy_to_user(), but avoids ring buffer
copying too:

Here is an algorithm that how you could do just the copy_to_user() from
the DMA buffer directly rather safely.
The algorithm is for 204 sized packets, but is
trivial to convert for 188 sized packets too.

I don't know if this is worth it though.

I found with Mantis that packets from DMA aren't always sized as 204
bytes (random sized garbage).
Even with this, you could do 204 -> 188 conversion, without moving data:
1. Reserve first 256 bytes of each 4K DMA buffer page outside of the DMA
transfer.
2. DMA of &buf[0][256 - 4095].
3. Do 204 -> 188 conversion for &buf[0][256 - 4095].
4. Copy remaining overflowed 45 bytes into &buf[1][256 - 45], just
before second DMA start.
5. Deliver an array of pointers for 188 sized packets for
dvb_dmx_swfilter_nocopy_packets().
6. DMA of &buf[1][256 - 4095].
7. Do 204 -> 188 conversion for &buf[1][(256 - 45) - 4095].
8. Copy remaining overflowed 25 bytes into &buf[2][256 - 25], just
before third DMA start.
9. Deliver a second array of pointers for 188 sized packets for
dvb_dmx_swfilter_nocopy_packets().

dvb_dmx_swfilter_nocopy_packets would then have to deliver just the
pointers with sizes
into a new style ring buffer.

Then you would wake up the waiting ringbuffer reader, and it would
do the copy_to_user() as is done now.

Some or most of the DMA buffer management could be in dvb_core/ side,
because it is so generic.
On Mantis side, you must grab DMA interrupt and call a function like
"dvb_dmabuf_set_busy_buf(bufno)".
Other thing is, that you must traverse DMA buffers for RISC programming,
like:
for (i=0; i < dvb_dmabuf_count(dmabuf); i++) {
    RISC_DMA(dvb_dmabuf_dma_pos(dmabuf, i) | MAKE_IRQ);
}
RISC_JUMP(risc_dma);
   
Other buffer management code isn't driver specific.

One possible problem that remains with this approach, is that what if
the DMA buffer gets overwritten?
Then the pointers in the ringbuffer might become garbage.

Another possible (cache coherency) problem is, that in this scenario
you both read and write to the DMA buffer.
Maybe with x86 computers this isn't a problem:
you never have to modify the same cache line
from both the DMA side and tasklet side at the same time.

Best regards,
Marko Ristola

