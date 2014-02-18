Return-path: <linux-media-owner@vger.kernel.org>
Received: from blu0-omc2-s12.blu0.hotmail.com ([65.55.111.87]:27328 "EHLO
	blu0-omc2-s12.blu0.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750727AbaBRFOd (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 18 Feb 2014 00:14:33 -0500
Message-ID: <BLU0-SMTP20334D771762D60FB7889D9AD980@phx.gbl>
Date: Tue, 18 Feb 2014 13:14:27 +0800
From: randy <lxr1234@hotmail.com>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
CC: kyungmin.park@samsung.com, Kamil Debski <k.debski@samsung.com>,
	jtp.park@samsung.com, m.chehab@samsung.com
Subject: s5p-mfc: alloc consistent memory failed in driver s5p-mfc v5
Content-Type: text/plain; charset="GB2312"
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

I tried to run samsung sample program in exynos 4412, the kernel
version is 3.13.3, as I can't make a working kernel in 3.14-rc2 so I
don't tried it.
root@kagami:~/v4l2-mfc-encoder# ./mfc-encode -m /dev/video1 -c
h264,header_mode=1 -d 1
mfc codec encoding example application
Andrzej Hajda <a.hajda@samsung.com>
Copyright 2012 Samsung Electronics Co., Ltd.

64.919953112:args.c:parse_args:187: codec: H264
64.920726862:args.c:parse_args:184: opt header_mode=1
64.937011571:mfc.c:mfc_create:87: MFC device /dev/video1 opened with fd=3
64.953427779:v4l_dev.c:v4l_req_bufs:116: Succesfully requested 16
buffers for device 3:0
64.953925446:func_dev.c:func_req_bufs:42: Succesfully requested 16
buffers for device -1:1
64.954654154:func_dev.c:func_enq_buf:113: Enqueued buffer 0/16 to -1:1
64.955432987:func_dev.c:func_enq_buf:113: Enqueued buffer 1/16 to -1:1
64.956119696:func_dev.c:func_enq_buf:113: Enqueued buffer 2/16 to -1:1
64.956824362:func_dev.c:func_enq_buf:113: Enqueued buffer 3/16 to -1:1
64.957546237:func_dev.c:func_enq_buf:113: Enqueued buffer 4/16 to -1:1
64.958226196:func_dev.c:func_enq_buf:113: Enqueued buffer 5/16 to -1:1
64.958885321:func_dev.c:func_enq_buf:113: Enqueued buffer 6/16 to -1:1
64.959588529:func_dev.c:func_enq_buf:113: Enqueued buffer 7/16 to -1:1
64.960283779:func_dev.c:func_enq_buf:113: Enqueued buffer 8/16 to -1:1
64.960502029:func_dev.c:func_enq_buf:113: Enqueued buffer 9/16 to -1:1
64.960699071:func_dev.c:func_enq_buf:113: Enqueued buffer 10/16 to -1:1
64.960815487:func_dev.c:func_enq_buf:113: Enqueued buffer 11/16 to -1:1
64.960927196:func_dev.c:func_enq_buf:113: Enqueued buffer 12/16 to -1:1
64.961081112:func_dev.c:func_enq_buf:113: Enqueued buffer 13/16 to -1:1
64.961202487:func_dev.c:func_enq_buf:113: Enqueued buffer 14/16 to -1:1
64.961315196:func_dev.c:func_enq_buf:113: Enqueued buffer 15/16 to -1:1
v4l_dev.c:v4l_req_bufs:111: error: Failed to request 4 buffers for
device 3:1)
root@kagami:~/v4l2-mfc-encoder# dmesg|tail -n4
[   65.010000]  (null): dma_alloc_coherent of size 2097152 failed
[   65.010000] s5p_mfc_alloc_priv_buf:43: Allocating private buffer failed
[   65.010000] s5p_mfc_alloc_codec_buffers_v5:177: Failed to allocate
Bank1 temporary buffer
[   65.010000] vidioc_reqbufs:1117: Failed to allocate encoding buffers


I have tried to increase the CMA size as Andrzej Hajda told before and
even I have tried to decrease it. I have tried for 8MB to 128M, but no
use. Is there anything way to fix the problem?
root@kagami:~/v4l2-mfc-encoder# zcat /proc/config.gz |grep
CONFIG_CMA_SIZE_MBYTES
CONFIG_CMA_SIZE_MBYTES=128


I wonder that kernel messages were appeared in request buffers or
enqueue buffer?  Actually I wonder what is relation about DMA and CMA?

Here is the log about cma
root@kagami:~# dmesg|grep cma
[    0.000000] cma: dma_contiguous_reserve(limit 6f800000)
[    0.000000] cma: dma_contiguous_reserve: reserving 128 MiB for
global area
[    0.000000] cma: dma_contiguous_reserve_area(size 8000000, base
00000000, limit 6f800000)
[    0.000000] cma: CMA: reserved 128 MiB at 67800000
[    0.130000] cma: dma_alloc_from_contiguous(cma c056fa04, count 64,
align 6)
[    0.130000] cma: dma_alloc_from_contiguous(): returned c0ad7000
[    0.235000] cma: dma_alloc_from_contiguous(cma c056fa04, count 1,
align 0)
[    0.235000] cma: dma_alloc_from_contiguous(): returned c0ad7800
[    0.245000] cma: dma_alloc_from_contiguous(cma c056fa04, count 1,
align 0)
[    0.245000] cma: dma_alloc_from_contiguous(): returned c0ad7820
[    0.250000] cma: dma_alloc_from_contiguous(cma c056fa04, count 1,
align 0)
[    0.250000] cma: dma_alloc_from_contiguous(): returned c0ad7840
[    0.985000] cma: dma_alloc_from_contiguous(cma c056fa04, count 1,
align 0)
[    0.985000] cma: dma_alloc_from_contiguous(): returned c0ad7860
[    1.085000] cma: dma_alloc_from_contiguous(cma c056fa04, count 1,
align 0)
[    1.085000] cma: dma_alloc_from_contiguous(): returned c0ad7880
[    1.085000] cma: dma_alloc_from_contiguous(cma c056fa04, count 1,
align 0)
[    1.085000] cma: dma_alloc_from_contiguous(): returned c0ad78a0
[    1.940000] cma: dma_alloc_from_contiguous(cma c056fa04, count 1,
align 0)
[    1.940000] cma: dma_alloc_from_contiguous(): returned c0ad78c0


ayaka
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iQEcBAEBAgAGBQJTAuwtAAoJEPb4VsMIzTzi0n0H/3Qv6QkOgVb+jxwz+qDDI5Cm
yx+/bGhS83y6vYA4BF8bTkLiR3mh4kl/RFk53IuguFul1o8A8OdGmZStKeBuvFe1
W4bXmNzUWVsCebuTIV6ZG7/uct+ewIv8Y9MK7iQsuSR++h7efJKWWWIQ45+kwUoC
nB2O+Zn/wh/FmQ2Xj9CO+G3WU73HWdOI65I+CKVruyDISVDtew0wBBvY9RJ6ulKU
uTs3W+aShbJWSsZ+4B1BDQGJmJBt2JCJbojxCRRND9HyBubfn5/O2jGIHL+fTAO/
MNujQFHUqIxTQ489RxjTZcoZkyPRjlT+3hJWBiKrJsl/J2N8etVfRPc4K/wTOeQ=
=F0oI
-----END PGP SIGNATURE-----
