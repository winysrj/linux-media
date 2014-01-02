Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.w1.samsung.com ([210.118.77.14]:26222 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751631AbaABM34 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 2 Jan 2014 07:29:56 -0500
Received: from eucpsbgm1.samsung.com (unknown [203.254.199.244])
 by mailout4.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MYR00206XDU0B40@mailout4.w1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 02 Jan 2014 12:29:54 +0000 (GMT)
From: Kamil Debski <k.debski@samsung.com>
To: 'randy' <lxr1234@hotmail.com>, linux-media@vger.kernel.org
Cc: Marek Szyprowski <m.szyprowski@samsung.com>
References: <BLU0-SMTP32889EC1B64B13894EE7C90ADCB0@phx.gbl>
In-reply-to: <BLU0-SMTP32889EC1B64B13894EE7C90ADCB0@phx.gbl>
Subject: RE: using MFC memory to memery encoder,
 start stream and queue order problem
Date: Thu, 02 Jan 2014 13:29:52 +0100
Message-id: <02c701cf07b6$565cd340$031679c0$%debski@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
Content-language: pl
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Randy,

> From: randy [mailto:lxr1234@hotmail.com]
> Sent: Thursday, January 02, 2014 12:35 PM
> 
> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA1
> 
> Hello
> 
> I have follow the README of the v4l2-mfc-encoder from the
> http://git.infradead.org/users/kmpark/public-apps
> it seems that I can use the mfc encoder in exynos4412(using 3.5 kernel
> from manufacturer).

So it is not the mainline kernel. Could you give a link to this kernel?
I have doubts that this kernel is using the open source driver. The
driver present in that kernel could be a significantly modified driver.

> But I have a problem with the contain of the README and I can't get the
> key frame(the I-frame in H.264). It said that "6. Enqueue CAPTURE
> buffers.
> 7. Enqueue OUTPUT buffer with first frame.
> 8. Start streaming (VIDIOC_STREAMON) on both ends."
> so I shall enqueue buffer before start stream, to enqueue a buffer, I
> need to dequeue first, but without start stream, it will failed in both
> side.

I think I don't understand this. You should enqueue the buffers and then
start streaming. I think dequeueing is not mentioned here. First enqueue
then dequeue.

> In this way I start OUTPUT(input raw video) stream first then dequeue
> and enqueue the first frame, then I start the CAPTURE(output encoded
> video) frame, dequeue CAPTURE to get a buffer, get the data from buffer
> then enqueue the buffer. The first frame of CAPTURE is always a
> 22 bytes
> frame(I don't know whether they are the same data all the time, but
> size is the same from m.planes[0].bytesused), but it seems not a key
> frame.
> 
> What is the problem, and how to solve it.
> 
> P.S I don't test the Linux 3.13-rc4, as the driver is not ready for
> encoder before.
> 
> 						Thank you
> -----BEGIN PGP SIGNATURE-----
> Version: GnuPG v1.4.12 (GNU/Linux)
> Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/
> 
> iQEcBAEBAgAGBQJSxU74AAoJEPb4VsMIzTzi2oEH/1JJqfeZhMwogvWSVz+M3J4Y
> 2Bnej0RBBKF0Gu508IWrHy9t+DPg3c3wJt1M0j+GtUsv2Q+Jl2vlmDTLV/Gafzo6
> xywye4raHpqHreFv4Q55SIseDbfV79eO84uv4RuV/fXEuPpo1MlZf9SOGCiAfoQI
> ozxqoOPD2l2VaSA/351gtT93lkOREF2EnmVf2Wa31WWHw0LV3aoY9/OosxOiY9Fy
> mVHHpYheDwHXdPfrxHXWKEA5GOJ7h0ozc66MPe7JInKSGdUcDrdrFxdSVwyZ/21B
> Oc2Aw9RMd85NwjXBc9hYH++3f73tcVhzMCF7Swyb+bsn4Mzyr64Bn4VsYaDqiCc=
> =HCKX
> -----END PGP SIGNATURE-----

Best wishes,
-- 
Kamil Debski
Samsung R&D Institute Poland


