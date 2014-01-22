Return-path: <linux-media-owner@vger.kernel.org>
Received: from blu0-omc2-s37.blu0.hotmail.com ([65.55.111.112]:7254 "EHLO
	blu0-omc2-s37.blu0.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752564AbaAVRis (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 22 Jan 2014 12:38:48 -0500
Message-ID: <BLU0-SMTP208BA84FC1E9E2BBCFA57EAADA70@phx.gbl>
Date: Thu, 23 Jan 2014 01:37:05 +0800
From: randy <lxr1234@hotmail.com>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
CC: jtp.park@samsung.com, m.chehab@samsung.com,
	linux-arm-kernel@lists.infradead.org
Subject: alloc priv buffer for s5p-mfc
Content-Type: text/plain; charset="GB2312"
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Hello
When I was try v4l2-mfc-encoder from samsung, I got the problem below

In my kernel config, mfc buffer is in
                samsung,mfc-r = <0x43000000 0x800000>;
                samsung,mfc-l = <0x51000000 0x800000>;

Shall I change CONFIG_CMA_SIZE_MBYTES to bigger size?
Or I shall alloc mfc's buffer in the other place, which area of ram
can be used as a replacement?
======================logs begin==============================
root@kagami:~/v4l2-mfc-encoder# ./mfc-encode -m /dev/video1 -c h264
mfc codec encoding example application
Andrzej Hajda <a.hajda@samsung.com>
Copyright 2012 Samsung Electronics Co., Ltd.

195.444284217:args.c:parse_args:187: codec: H264
195.459693300:mfc.c:mfc_create:87: MFC device /dev/video1 opened with fd=3
195.475634300:v4l_dev.c:v4l_req_bufs:116: Succesfully requested 16
buffers for device 3:0
195.475773925:func_dev.c:func_req_bufs:42: Succesfully requested 16
buffers for device -1:1
195.475943092:func_dev.c:func_enq_buf:113: Enqueued buffer 0/16 to -1:1
195.476096592:func_dev.c:func_enq_buf:113: Enqueued buffer 1/16 to -1:1
195.476259925:func_dev.c:func_enq_buf:113: Enqueued buffer 2/16 to -1:1
195.476402425:func_dev.c:func_enq_buf:113: Enqueued buffer 3/16 to -1:1
195.476548800:func_dev.c:func_enq_buf:113: Enqueued buffer 4/16 to -1:1
195.476736300:func_dev.c:func_enq_buf:113: Enqueued buffer 5/16 to -1:1
195.476903508:func_dev.c:func_enq_buf:113: Enqueued buffer 6/16 to -1:1
195.477073675:func_dev.c:func_enq_buf:113: Enqueued buffer 7/16 to -1:1
195.477238675:func_dev.c:func_enq_buf:113: Enqueued buffer 8/16 to -1:1
195.477391550:func_dev.c:func_enq_buf:113: Enqueued buffer 9/16 to -1:1
195.477559758:func_dev.c:func_enq_buf:113: Enqueued buffer 10/16 to -1:1
195.477722842:func_dev.c:func_enq_buf:113: Enqueued buffer 11/16 to -1:1
195.477901092:func_dev.c:func_enq_buf:113: Enqueued buffer 12/16 to -1:1
195.478065717:func_dev.c:func_enq_buf:113: Enqueued buffer 13/16 to -1:1
195.478253383:func_dev.c:func_enq_buf:113: Enqueued buffer 14/16 to -1:1
195.478427675:func_dev.c:func_enq_buf:113: Enqueued buffer 15/16 to -1:1
v4l_dev.c:v4l_req_bufs:111: error: Failed to request 4 buffers for
device 3:1)

the dmesg show
[  195.525000]  (null): dma_alloc_coherent of size 2097152 failed
[  195.525000] s5p_mfc_alloc_priv_buf:43: Allocating private buffer failed
[  195.525000] s5p_mfc_alloc_codec_buffers_v5:177: Failed to allocate
Bank1 temporary buffer
[  195.525000] vidioc_reqbufs:1117: Failed to allocate encoding buffers

When I tried program which is written by me(request 16 buffers, but
eacho on is for 640*480, much bigger than mfc-encode)
I got the below in dmesg
[  230.245000]  (null): dma_alloc_coherent of size 155648 failed
[  230.245000] vidioc_querybuf:1178: error in vb2_querybuf() for E(S)
[  230.280000]  (null): dma_alloc_coherent of size 2097152 failed
[  230.285000] s5p_mfc_alloc_priv_buf:43: Allocating private buffer failed
[  230.285000] s5p_mfc_alloc_codec_buffers_v5:186: Failed to allocate
Bank2 temporary buffer
[  230.285000] vidioc_reqbufs:1117: Failed to allocate encoding buffers

Then when I was trying mfc-encode again, I got
root@kagami:~/v4l2-mfc-encoder# ./mfc-encode -m /dev/video1 -c h264
mfc codec encoding example application
Andrzej Hajda <a.hajda@samsung.com>
Copyright 2012 Samsung Electronics Co., Ltd.

265.245904000:args.c:parse_args:187: codec: H264
265.260920417:mfc.c:mfc_create:87: MFC device /dev/video1 opened with fd=3
265.276771750:v4l_dev.c:v4l_req_bufs:116: Succesfully requested 16
buffers for device 3:0
265.276913708:func_dev.c:func_req_bufs:42: Succesfully requested 16
buffers for device -1:1
265.277080750:func_dev.c:func_enq_buf:113: Enqueued buffer 0/16 to -1:1
265.277237833:func_dev.c:func_enq_buf:113: Enqueued buffer 1/16 to -1:1
265.277381833:func_dev.c:func_enq_buf:113: Enqueued buffer 2/16 to -1:1
265.277526708:func_dev.c:func_enq_buf:113: Enqueued buffer 3/16 to -1:1
265.277673000:func_dev.c:func_enq_buf:113: Enqueued buffer 4/16 to -1:1
265.277816542:func_dev.c:func_enq_buf:113: Enqueued buffer 5/16 to -1:1
265.277962375:func_dev.c:func_enq_buf:113: Enqueued buffer 6/16 to -1:1
265.278109792:func_dev.c:func_enq_buf:113: Enqueued buffer 7/16 to -1:1
265.278253917:func_dev.c:func_enq_buf:113: Enqueued buffer 8/16 to -1:1
265.278404958:func_dev.c:func_enq_buf:113: Enqueued buffer 9/16 to -1:1
265.278548417:func_dev.c:func_enq_buf:113: Enqueued buffer 10/16 to -1:1
265.278701792:func_dev.c:func_enq_buf:113: Enqueued buffer 11/16 to -1:1
265.278846542:func_dev.c:func_enq_buf:113: Enqueued buffer 12/16 to -1:1
265.278993708:func_dev.c:func_enq_buf:113: Enqueued buffer 13/16 to -1:1
265.279142042:func_dev.c:func_enq_buf:113: Enqueued buffer 14/16 to -1:1
265.279294542:func_dev.c:func_enq_buf:113: Enqueued buffer 15/16 to -1:1
265.315370875:v4l_dev.c:v4l_req_bufs:116: Succesfully requested 4
buffers for device 3:1
265.315490750:func_dev.c:func_req_bufs:42: Succesfully requested 2
buffers for device 4:0
265.315692417:v4l_dev.c:v4l_enq_buf:211: Enqueued buffer 0/2 to 3:1
265.315892667:v4l_dev.c:v4l_enq_buf:211: Enqueued buffer 1/2 to 3:1
State [enq cnt/max]: [Off 0 0/0|Rdy 16 0/250] [Off 0 0/0|Off 2 0/0]
[Off 0 0/0|Off 0 0/0]
State [enq cnt/max]: [Off 0 0/0|Rdy 16 0/250] [Off 0 0/0|Off 2 0/0]
[Off 0 0/0|Off 0 0/0]
265.316897875:func_dev.c:func_deq_buf:79: Dequeued buffer 0/16 from
- -1:1 ret=25344
v4l_dev.c:v4l_enq_buf:207: error: Error 22 enq buffer 0/16 to 3:0
265.317128125:io_dev.c:process_chain:165: pair 0:1 ret=-1

Then dmesg show that

[  265.310000]  (null): dma_alloc_coherent of size 2097152 failed
====================logs end======================================

Thank you
ayaka
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iQEcBAEBAgAGBQJS4AHBAAoJEPb4VsMIzTziGbMIAMYuuY4SNIczIn4PmmbjRjcQ
NhaeOqjtbSaeLJWfpKiPBe8yDKgSklCEuddhIcJh1Y9v1GsjpUD5BmTerObGNHWM
jWUvfMpxD7hrbjvqqrwAEWZ7U9lgyAPip2SdPLsEThkIaj0l1IreNvPzYKlXzr59
JGyP155QjIWlZiOoR5yH79s60ZOZoiQnO5d7z0ECyPyIgt3GBAXEBkqksO333O1C
PeeGxDYnZc8zB60tbP+nWIJ0NRH9fxp7J8/9ULt9OwCFcZPDLuEMXMucfszicxXo
TK/C47JdUPnBWmZ5Dz+v2siyL8ubWAzkgk89WB4qtWDejndVcRy9r264va5Z0Ng=
=odW8
-----END PGP SIGNATURE-----
