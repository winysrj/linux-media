Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:12152 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751465AbZLCPcM (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 3 Dec 2009 10:32:12 -0500
Received: from eu_spt2 (mailout1.w1.samsung.com [210.118.77.11])
 by mailout1.w1.samsung.com
 (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTP id <0KU300AY41TTJY@mailout1.w1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 03 Dec 2009 15:32:17 +0000 (GMT)
Received: from linux.samsung.com ([106.116.38.10])
 by spt2.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0KU3008S21TSQG@spt2.w1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 03 Dec 2009 15:32:16 +0000 (GMT)
Date: Thu, 03 Dec 2009 16:31:57 +0100
From: Pawel Osciak <p.osciak@samsung.com>
Subject: Syncing videobuf buffers before an operation
To: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
	Pawel Osciak <p.osciak@samsung.com>,
	"kyungmin.park@samsung.com" <kyungmin.park@samsung.com>
Message-id: <E4D3F24EA6C9E54F817833EAE0D912AC09C3031E06@bssrvexch01.BS.local>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-language: en-US
Content-transfer-encoding: 7BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello!

We have been facing the problem of sync()ing buffers before performing
operations on them.

This is the current buffer life cycle in videobuf (for streaming, slightly
simplified):

- qbuf:
  buf_prepare, from which drivers call videobuf_iolock() if the state is
  VIDEOBUF_NEEDS_INIT (i.e. once per streamon)

- dqbuf:
  where per-memory method sync() is called

- streamoff:
  where buffers are released (i.e. iolock is "released")


We are working with devices that have a non-coherent cache (ARM-based).
For them sync()ing means flushing CPU cache for the physical memory to
contain valid data. We require syncing buffers not only after, but before
running the operation as well.

For CAPTURE devices this prevents corruption in case a flush occurs after
the operation has finished and overwrites the results with old data (from
before the operation).

For OUTPUT-type devices sync()ing is even more important, as the source
data may be completely invalid before the operation - before DMA can
be started, CPU cache has to be flushed.


We have divided sync operations into the following types:
- sync CAPTURE buffers before the operation
- sync CAPTURE buffers after the operation
- sync OUTPUT buffers before the operation

Our idea is to add an additional sync() call to videobuf_qbuf and
a parameter that would allow differentiating between syncs before and
after the operation. Alternatively, an additional function for that
could be added, if we don't want to change the API.

Please note that this is different from iolock(). Iolock is performed
once per streamon and what we need is a sync (which should also be
more lightweight than a full iolock) per each qbuf.

I would be grateful for your opinions on this topic. We'd like to
propose a patch if we come to an agreement on this as well.
Thank you!


Best regards
--
Pawel Osciak
Linux Platform Group
Samsung Poland R&D Center

