Return-path: <linux-media-owner@vger.kernel.org>
Received: from blu0-omc3-s20.blu0.hotmail.com ([65.55.116.95]:7613 "EHLO
	blu0-omc3-s20.blu0.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751424AbaC2MbS (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 29 Mar 2014 08:31:18 -0400
Message-ID: <BLU0-SMTP14E64BE129EF85BAAA10D1AD610@phx.gbl>
Date: Sat, 29 Mar 2014 20:26:20 +0800
From: ayaka <lxr1234@hotmail.com>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
CC: ayaka@mail.soulik.info, Kamil Debski <k.debski@samsung.com>,
	kgene.kim@samsung.com, sebastian.droege@collabora.co.uk
Subject: mfc: fixed the request buffer but failed in enqueue a dequeued OUTPUT(input)
Content-Type: text/plain; charset="GB2312"
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

My kernel is 3.13.7, as I have reported before, mfc encoder can't
request buffer, I increase the mfc size in dts file from 0x800000
to 0x4000000, then it can request buffer now, but it can't enqueue
the input(OUTPUT in v4l2 side) buffer which is just dequeued after
stream has start.
Here is the log of samsung demo, I don't get any information in dmesg
root@kagami:~# ./mfc-encode -m /dev/video1 -c h264
mfc codec encoding example application
Andrzej Hajda <a.hajda@samsung.com>
Copyright 2012 Samsung Electronics Co., Ltd.

50.370398146:args.c:parse_args:187: codec: H264
50.386230729:mfc.c:mfc_create:87: MFC device /dev/video1 opened with fd=3
50.402226771:v4l_dev.c:v4l_req_bufs:116: Succesfully requested 16
buffers for device 3:0
50.402356979:func_dev.c:func_req_bufs:42: Succesfully requested 16
buffers for device -1:1
50.402523896:func_dev.c:func_enq_buf:113: Enqueued buffer 0/16 to -1:1
50.402677896:func_dev.c:func_enq_buf:113: Enqueued buffer 1/16 to -1:1
50.402819771:func_dev.c:func_enq_buf:113: Enqueued buffer 2/16 to -1:1
50.403051729:func_dev.c:func_enq_buf:113: Enqueued buffer 3/16 to -1:1
50.403199646:func_dev.c:func_enq_buf:113: Enqueued buffer 4/16 to -1:1
50.403604562:func_dev.c:func_enq_buf:113: Enqueued buffer 5/16 to -1:1
50.403880187:func_dev.c:func_enq_buf:113: Enqueued buffer 6/16 to -1:1
50.404194396:func_dev.c:func_enq_buf:113: Enqueued buffer 7/16 to -1:1
50.404580146:func_dev.c:func_enq_buf:113: Enqueued buffer 8/16 to -1:1
50.404951021:func_dev.c:func_enq_buf:113: Enqueued buffer 9/16 to -1:1
50.405400896:func_dev.c:func_enq_buf:113: Enqueued buffer 10/16 to -1:1
50.405554729:func_dev.c:func_enq_buf:113: Enqueued buffer 11/16 to -1:1
50.405721271:func_dev.c:func_enq_buf:113: Enqueued buffer 12/16 to -1:1
50.405791896:func_dev.c:func_enq_buf:113: Enqueued buffer 13/16 to -1:1
50.405933604:func_dev.c:func_enq_buf:113: Enqueued buffer 14/16 to -1:1
50.406003646:func_dev.c:func_enq_buf:113: Enqueued buffer 15/16 to -1:1
50.473507729:v4l_dev.c:v4l_req_bufs:116: Succesfully requested 4
buffers for device 3:1
50.473621146:func_dev.c:func_req_bufs:42: Succesfully requested 4
buffers for device 4:0
50.473815312:v4l_dev.c:v4l_enq_buf:211: Enqueued buffer 0/4 to 3:1
50.474005771:v4l_dev.c:v4l_enq_buf:211: Enqueued buffer 1/4 to 3:1
50.474252854:v4l_dev.c:v4l_enq_buf:211: Enqueued buffer 2/4 to 3:1
50.474754854:v4l_dev.c:v4l_enq_buf:211: Enqueued buffer 3/4 to 3:1
State [enq cnt/max]: [Off 0 0/0|Rdy 16 0/250] [Off 0 0/0|Off 4 0/0]
[Off 0 0/0|Off 0 0/0]
State [enq cnt/max]: [Off 0 0/0|Rdy 16 0/250] [Off 0 0/0|Off 4 0/0]
[Off 0 0/0|Off 0 0/0]
50.476985521:func_dev.c:func_deq_buf:79: Dequeued buffer 0/16 from
- -1:1 ret=25344
v4l_dev.c:v4l_enq_buf:207: error: Error 22 enq buffer 0/16 to 3:0
50.477464521:io_dev.c:process_chain:165: pair 0:1 ret=-1

I have tried [Linaro-mm-sig] [PATCH][RFC] mm: Don't put CMA pages on
per-cpu lists
but it doesn't have any effect and if I don't modify the size in dts
it will failed in request buffer either.


In the program wroten by myself(I have tested work in manufacturer's
3.5 kernel), it can't dequeue the OUPUT at all neither the second
frame in CAPTURE(with V4L2_CID_MPEG_VIDEO_HEADER_MODE in 0), of
course, there is not any frame in OUTPUT, it is impossible to get the
the second frame in CAPTURE.

Thank you


ayaka
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iQEcBAEBAgAGBQJTNrvoAAoJEPb4VsMIzTziUtwH/RBoyPSLUieV+fJ0+/KkvBxN
WlkFATzPJD+AuiF0co2ggWrx0DnA1M8qFGHecNJW6mf+oL9+kz+2ASFBT+g224Pa
q5m1ykAGGnfo1sVtcMOf+HcDxq2dYMG9AD8Cjo39oPZXxgeJLRl2Wd/uePIBIj/H
IBGHX7I94XCAgU9OzMq8TviqwE9pyXVMNCa9DX0XBGYKuJDkeKVgXZXt/loGa1BZ
IV74aS0jKN8iO7npWSgpTvWG4nSDtw7arDfPTR1N6CsqgJvY+z9K0sr3LFIzu/UW
gPUW+eK08qyeemZr5W39akf56x/B+pua8npB+H3NKSxVysTgVvBZ5YieupEfXrE=
=gquq
-----END PGP SIGNATURE-----
