Return-path: <linux-media-owner@vger.kernel.org>
Received: from blu0-omc2-s17.blu0.hotmail.com ([65.55.111.92]:59350 "EHLO
	blu0-omc2-s17.blu0.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750807AbaABLfO (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 2 Jan 2014 06:35:14 -0500
Message-ID: <BLU0-SMTP32889EC1B64B13894EE7C90ADCB0@phx.gbl>
Date: Thu, 2 Jan 2014 19:35:21 +0800
From: randy <lxr1234@hotmail.com>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
CC: Kamil Debski <k.debski@samsung.com>, m.szyprowski@samsung.com
Subject: using MFC memory to memery encoder, start stream and queue order
 problem
Content-Type: text/plain; charset="GB2312"
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Hello

I have follow the README of the v4l2-mfc-encoder from the
http://git.infradead.org/users/kmpark/public-apps
it seems that I can use the mfc encoder in exynos4412(using 3.5 kernel
from manufacturer).
But I have a problem with the contain of the README and I can't get the
key frame(the I-frame in H.264). It said that
"6. Enqueue CAPTURE buffers.
7. Enqueue OUTPUT buffer with first frame.
8. Start streaming (VIDIOC_STREAMON) on both ends."
so I shall enqueue buffer before start stream, to enqueue a buffer, I
need to dequeue first, but without start stream, it will failed in both
side.
In this way I start OUTPUT(input raw video) stream first then dequeue
and enqueue the first frame, then I start the CAPTURE(output encoded
video) frame, dequeue CAPTURE to get a buffer, get the data from
buffer then enqueue the buffer. The first frame of CAPTURE is always a
22 bytes
frame(I don't know whether they are the same data all the time, but
size is the same from m.planes[0].bytesused), but it seems not a key
frame.

What is the problem, and how to solve it.

P.S I don't test the Linux 3.13-rc4, as the driver is not ready for
encoder before.

						Thank you
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iQEcBAEBAgAGBQJSxU74AAoJEPb4VsMIzTzi2oEH/1JJqfeZhMwogvWSVz+M3J4Y
2Bnej0RBBKF0Gu508IWrHy9t+DPg3c3wJt1M0j+GtUsv2Q+Jl2vlmDTLV/Gafzo6
xywye4raHpqHreFv4Q55SIseDbfV79eO84uv4RuV/fXEuPpo1MlZf9SOGCiAfoQI
ozxqoOPD2l2VaSA/351gtT93lkOREF2EnmVf2Wa31WWHw0LV3aoY9/OosxOiY9Fy
mVHHpYheDwHXdPfrxHXWKEA5GOJ7h0ozc66MPe7JInKSGdUcDrdrFxdSVwyZ/21B
Oc2Aw9RMd85NwjXBc9hYH++3f73tcVhzMCF7Swyb+bsn4Mzyr64Bn4VsYaDqiCc=
=HCKX
-----END PGP SIGNATURE-----
