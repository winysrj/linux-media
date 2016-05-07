Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:43659 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752282AbcEGN0M (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 7 May 2016 09:26:12 -0400
Date: Sat, 7 May 2016 10:26:06 -0300
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Soeren Moch <smoch@web.de>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
	Antti Palosaari <crope@iki.fi>
Subject: Re: [PATCH] media: dvb_ringbuffer: Add memory barriers
Message-ID: <20160507102606.73e86c0d@recife.lan>
In-Reply-To: <20160507102235.22e096d8@recife.lan>
References: <1451248920-4935-1-git-send-email-smoch@web.de>
	<56B7997C.1070503@web.de>
	<20160507102235.22e096d8@recife.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Sat, 7 May 2016 10:22:35 -0300
Mauro Carvalho Chehab <mchehab@osg.samsung.com> escreveu:

> Hi Soeren,
> 
> Em Sun, 7 Feb 2016 20:22:36 +0100
> Soeren Moch <smoch@web.de> escreveu:
> 
> > On 27.12.2015 21:41, Soeren Moch wrote:
> > > Implement memory barriers according to Documentation/circular-buffers.txt:
> > > - use smp_store_release() to update ringbuffer read/write pointers
> > > - use smp_load_acquire() to load write pointer on reader side
> > > - use ACCESS_ONCE() to load read pointer on writer side
> > >
> > > This fixes data stream corruptions observed e.g. on an ARM Cortex-A9
> > > quad core system with different types (PCI, USB) of DVB tuners.
> > >
> > > Signed-off-by: Soeren Moch <smoch@web.de>
> > > Cc: stable@vger.kernel.org # 3.14+  
> > 
> > Mauro,
> > 
> > any news or comments on this?
> > Since this is a real fix for broken behaviour, can you pick this up, please?
> 
> The problem here is that I'm very reluctant to touch at the DVB core
> without doing some tests myself, as things like locking can be
> very sensible.

In addition, it is good if other DVB developers could also test it.
Even being sent for some time, until now, nobody else tested it.

> 
> I'll try to find some time to take a look on it for Kernel 4.8,
> but I'd like to reproduce the bug locally.
> 
> Could you please provide me enough info to reproduce it (and
> eventually some test MPEG-TS where you know this would happen)?
> 
> I have two DekTek RF generators here, so I should be able to
> play such TS and see what happens with and without the patch
> on x86, arm32 and arm64.

Ah,  forgot to mention, but checkpatch.pl wants comments for the memory
barriers:

WARNING: memory barrier without comment
#52: FILE: drivers/media/dvb-core/dvb_ringbuffer.c:58:
+	return (rbuf->pread == smp_load_acquire(&rbuf->pwrite));

WARNING: memory barrier without comment
#70: FILE: drivers/media/dvb-core/dvb_ringbuffer.c:79:
+	avail = smp_load_acquire(&rbuf->pwrite) - rbuf->pread;

WARNING: memory barrier without comment
#79: FILE: drivers/media/dvb-core/dvb_ringbuffer.c:89:
+	smp_store_release(&rbuf->pread, smp_load_acquire(&rbuf->pwrite));

WARNING: memory barrier without comment
#87: FILE: drivers/media/dvb-core/dvb_ringbuffer.c:96:
+	smp_store_release(&rbuf->pread, 0);

WARNING: memory barrier without comment
#88: FILE: drivers/media/dvb-core/dvb_ringbuffer.c:97:
+	smp_store_release(&rbuf->pwrite, 0);

WARNING: memory barrier without comment
#97: FILE: drivers/media/dvb-core/dvb_ringbuffer.c:123:
+		smp_store_release(&rbuf->pread, 0);

WARNING: memory barrier without comment
#103: FILE: drivers/media/dvb-core/dvb_ringbuffer.c:128:
+	smp_store_release(&rbuf->pread, (rbuf->pread + todo) % rbuf->size);

WARNING: memory barrier without comment
#112: FILE: drivers/media/dvb-core/dvb_ringbuffer.c:143:
+		smp_store_release(&rbuf->pread, 0);

WARNING: memory barrier without comment
#117: FILE: drivers/media/dvb-core/dvb_ringbuffer.c:147:
+	smp_store_release(&rbuf->pread, (rbuf->pread + todo) % rbuf->size);

WARNING: memory barrier without comment
#126: FILE: drivers/media/dvb-core/dvb_ringbuffer.c:162:
+		smp_store_release(&rbuf->pwrite, 0);

WARNING: memory barrier without comment
#130: FILE: drivers/media/dvb-core/dvb_ringbuffer.c:165:
+	smp_store_release(&rbuf->pwrite, (rbuf->pwrite + todo) % rbuf->size);

WARNING: memory barrier without comment
#139: FILE: drivers/media/dvb-core/dvb_ringbuffer.c:185:
+		smp_store_release(&rbuf->pwrite, 0);

WARNING: memory barrier without comment
#145: FILE: drivers/media/dvb-core/dvb_ringbuffer.c:190:
+	smp_store_release(&rbuf->pwrite, (rbuf->pwrite + todo) % rbuf->size);

Thanks,
Mauro
