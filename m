Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:18486 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754434Ab0EJM6f (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 10 May 2010 08:58:35 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: text/plain; charset=UTF-8
Received: from eu_spt2 ([210.118.77.13]) by mailout3.w1.samsung.com
 (Sun Java(tm) System Messaging Server 6.3-8.04 (built Jul 29 2009; 32bit))
 with ESMTP id <0L27006YBG1LZH90@mailout3.w1.samsung.com> for
 linux-media@vger.kernel.org; Mon, 10 May 2010 13:58:33 +0100 (BST)
Received: from linux.samsung.com ([106.116.38.10])
 by spt2.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0L270089SG1KPJ@spt2.w1.samsung.com> for
 linux-media@vger.kernel.org; Mon, 10 May 2010 13:58:33 +0100 (BST)
Date: Mon, 10 May 2010 14:58:03 +0200
From: Pawel Osciak <p.osciak@samsung.com>
Subject: RE: Status of the patches under review (85 patches) and some misc
 notes about the devel procedures
In-reply-to: <20100507093916.2e2ef8e3@pedra>
To: 'LMML' <linux-media@vger.kernel.org>
Cc: =?UTF-8?B?J+uwleqyveuvvCc=?= <kyungmin.park@samsung.com>
Message-id: <001d01caf040$6d3fee80$47bfcb80$%osciak@samsung.com>
Content-language: pl
References: <20100507093916.2e2ef8e3@pedra>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

>Mauro Carvalho Chehab <mchehab@redhat.com> wrote:
>		== Videobuf patches - Need more tests before committing it - Volunteers? ==
>
>Apr,21 2010: [v1, 1/2] v4l: videobuf: Add support for out-of-order buffer dequeuing
> http://patchwork.kernel.org/patch/93901
>Apr,21 2010: [v1, 2/2] v4l: vivi: adapt to out-of-order buffer dequeuing in
>videobu http://patchwork.kernel.org/patch/93903
>

it'd be great if there was a driver/device that would be benefiting from this,
i.e. that may want to:
- return buffers in a different order than queued,
- process them in parallel,
- process them in a different order,

or anybody interested in those features. Is anybody aware of any such devices
in the V4L tree?

This is also the first step to simplifying videobuf and making it lighter by
removing superficial (to my best knowledge) waitqueues in every videobuf_buffer
structure, as discussed at the Oslo meeting.

Best regards
--
Pawel Osciak
Linux Platform Group
Samsung Poland R&D Center



