Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:60171 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751264Ab0EFHN5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 6 May 2010 03:13:57 -0400
Received: from eu_spt1 (mailout2.w1.samsung.com [210.118.77.12])
 by mailout2.w1.samsung.com
 (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTP id <0L1Z00FWELF6SL@mailout2.w1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 06 May 2010 08:13:54 +0100 (BST)
Received: from linux.samsung.com ([106.116.38.10])
 by spt1.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0L1Z00EHZLF62S@spt1.w1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 06 May 2010 08:13:54 +0100 (BST)
Date: Thu, 06 May 2010 09:13:27 +0200
From: Pawel Osciak <p.osciak@samsung.com>
Subject: RE: [videobuf] Query: Condition bytesize limit in videobuf_reqbufs ->
 buf_setup() call?
In-reply-to: <A24693684029E5489D1D202277BE894455257D13@dlee02.ent.ti.com>
To: "'Aguirre, Sergio'" <saaguirre@ti.com>, linux-media@vger.kernel.org
Cc: 'Mauro Carvalho Chehab' <mchehab@redhat.com>,
	kyungmin.park@samsung.com
Message-id: <000901caeceb$9ff6c5e0$dfe451a0$%osciak@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-language: pl
Content-transfer-encoding: 7BIT
References: <A24693684029E5489D1D202277BE894455257D13@dlee02.ent.ti.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

>Aguirre, Sergio wrote:
>Basically, when calling VIDIOC_REQBUFS with a certain buffer
>Count, we had a software limit for total size, calculated depending on:
>
>  Total bytesize = bytesperline x height x count
>
>So, we had an arbitrary limit to, say 32 MB, which was generic.
>
>Now, we want to condition it ONLY when MMAP buffers will be used.
>Meaning, we don't want to keep that policy when the kernel is not
>allocating the space
>
>But the thing is that, according to videobuf documentation, buf_setup is
>the one who should put a RAM usage limit. BUT the memory type passed to
>reqbufs is not propagated to buf_setup, therefore forcing me to go to a
>non-standard memory limitation in my reqbufs callback function, instead
>of doing it properly inside buf_setup.

buf_setup is called during REQBUFS and is indeed the place to limit the
size and actually allocate the buffers as well, or at least try to do so,
as V4L2 API requires. This is not currently the case with videobuf, but
right now we are working to change it. buf_prepare() is called on QBUF
and it is definitely too late to do things like that then. It is the
REQBUFS that should be failing if the requested number of buffers is too
high.

You could also (although it's very hacky) just take one of the buffers
from vq passed to buf_setup and check its memory field.

>Is this scenario a good consideration to change buf_setup API, and
>propagate buffers memory type aswell?

I agree with Mauro that there should not be a restriction for MMAP only,
for the same reasons he already pointed out.

As I mentioned, an intensive work is underway to change the buf_* API in
videobuf at the moment, so if you have any recommendation/requirements
that you feel would be useful, please let us know.


Best regards
--
Pawel Osciak
Linux Platform Group
Samsung Poland R&D Center



