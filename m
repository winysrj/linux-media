Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ig0-f172.google.com ([209.85.213.172]:38764 "EHLO
	mail-ig0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751370AbbL0Pbh (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 27 Dec 2015 10:31:37 -0500
Received: by mail-ig0-f172.google.com with SMTP id mw1so10657195igb.1
        for <linux-media@vger.kernel.org>; Sun, 27 Dec 2015 07:31:37 -0800 (PST)
MIME-Version: 1.0
Date: Sun, 27 Dec 2015 17:31:36 +0200
Message-ID: <CAJ2oMh+0-2nmbWxeEHV-V6hkXFYXm-2L5mzHT3+v0WSUMpRd1g@mail.gmail.com>
Subject: PCIe sg dma device used as dma-contig
From: Ran Shalit <ranshalit@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

The following question is not totally in the scope of v4l2, but more
about your advise concering dma alternatives for non-expreciened v4l2
device writer.
We intend to use the fpga for concurrent 3xHD and 3xSD.

We have some dillema regadring the fpga to choose from:
ALTERA fpga which use contiguous dma memory, or Xilinx fpga which is
using scatter-gather architecture.

With xilinx, it seems that the sg architecture can also be used as
contiguous according to the following:
"... While these descriptors are not required to be contiguous, they
should be contained within an 8 megabyte region which corresponds to
the width of the AXI_PCIe_SG port"
it seems according to the above description that sg-list can be used
as single contiguous descriptor (with dma-cotig), though the 8MBytes
seems like a problematic constrain. This constrain make it difficult
to be used with dma-contig solution in v4l2.

Our current direction is try to imeplement it as simple as possible.
Therefore we prefer the dma contiguous solution (I think that together
with CMA and a strong cpu like 64-bit i7 it can handle contigious
memory for 3xHD and 3xSD allocation).

Any feedback is appreciated,
Ran
