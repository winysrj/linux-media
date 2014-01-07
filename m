Return-path: <linux-media-owner@vger.kernel.org>
Received: from blu0-omc2-s35.blu0.hotmail.com ([65.55.111.110]:42656 "EHLO
	blu0-omc2-s35.blu0.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751595AbaAGPqH (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 7 Jan 2014 10:46:07 -0500
Message-ID: <BLU0-SMTP16701F268FC849BF9937149ADB60@phx.gbl>
Date: Tue, 7 Jan 2014 23:45:59 +0800
From: randy <lxr1234@hotmail.com>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
CC: a.hajda@samsung.com
Subject: How to get the key frame when using mfc encoder
Content-Type: text/plain; charset="GB2312"
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Hello
  Well, in this time, I think I have wroten a program to use mfc
encoder of exynos4412 correctly. But how to get a I-frame in H.264, I
think the first dequeue frame in CAPTURE after I start streams in both
in is the key frame which is always 22 bytes long, but it can't be
used to create sdp in libav. When I use the v4l2-mfc-encoder to encode
H.264 with only one frame from demo source, the output file's size is
always 155 bytes.
The furture encoded size got by my program is about 140000 to 16000
bytes (the raw image is 640*480 in nv12, that size is from bytesused
in dequeued v4l2_buffer)
Is it my program using mfc encoder correct?

Is there any way to force mfc encoder to encode a I-frame?

And I have a problem with the data transporting way in v4l2-mfc-encoder,
it use m.userptr, I think it is not need, as it has been mmap  to
bufs->addr before, just fill the bufs->addr is enough, and for mfc,
the buffer type V4L2_MEMORY_MMAP,  I think that it had better use
m.mem_offset from v4l2 document, why it use userptr?


Thank you
							ayaka
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iQEcBAEBAgAGBQJSzCEzAAoJEPb4VsMIzTziVqkH/3O9DQhG0+/r+FN2Z+O3f7Oe
6n3mO+qTl0kwEMgUWfNWNMLfsRtCDC+OYsBRIcJohOv5jx5t4Rm98zz7vXndIR/w
Y0PpLO5Dx3s2VHFNEU/VSQONgKWOwqbXgsNSks2VW05uhaB/S4cxrYHUREBvsqeo
g6D2qsAICe+htdYuOdMYKkeXuIV6xY4ltQ4Cf1dXFWy4Wk70T6fDZuKSIOMhOZyW
FPRMZ3Eogmr7LegV7HuC8+jhh9yexWKzqLJUy4zvxuQKN0IZBGJ9ystTzxCwdJJb
DUJ2imGwkRvyIAILEWukV8w5sEgM9J/PgHqDyFrTYU1zvzShnPutDUS4zb/kPsM=
=NCxg
-----END PGP SIGNATURE-----
