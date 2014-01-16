Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:58791 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752066AbaAPMh2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 16 Jan 2014 07:37:28 -0500
Received: from eucpsbgm2.samsung.com (unknown [203.254.199.245])
 by mailout3.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MZH004QFV2E8L90@mailout3.w1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 16 Jan 2014 12:37:26 +0000 (GMT)
Message-id: <52D7D284.1080700@samsung.com>
Date: Thu, 16 Jan 2014 13:37:24 +0100
From: Andrzej Hajda <a.hajda@samsung.com>
MIME-version: 1.0
To: randy <lxr1234@hotmail.com>, Kamil Debski <k.debski@samsung.com>,
	linux-media@vger.kernel.org
Cc: kyungmin.park@samsung.com
Subject: Re: using MFC memory to memery encoder,
 start stream and queue order problem
References: <BLU0-SMTP32889EC1B64B13894EE7C90ADCB0@phx.gbl>
 <02c701cf07b6$565cd340$031679c0$%debski@samsung.com>
 <BLU0-SMTP266BE9BC66B254061740251ADCB0@phx.gbl>
 <02c801cf07ba$8518f2f0$8f4ad8d0$%debski@samsung.com>
 <BLU0-SMTP150C8C0DB0E9A3A9F4104F8ADCA0@phx.gbl>
 <04b601cf0c7f$d9e531d0$8daf9570$%debski@samsung.com>
 <52CD725E.5060903@hotmail.com> <BLU0-SMTP6650E76A95FA2BB39C6325ADB30@phx.gbl>
 <52CFD5DF.6050801@samsung.com> <BLU0-SMTP37B0A51F0A2D2F1E79A730ADB30@phx.gbl>
 <52D3BCB7.1060309@samsung.com> <52D3CB84.6090406@samsung.com>
 <BLU0-SMTP3546CDA7E88F73435A3A876ADBC0@phx.gbl>
 <001701cf107b$0927aa50$1b76fef0$%debski@samsung.com>
 <BLU0-SMTP183F0EEECCB365900DE2315ADBF0@phx.gbl> <52D51179.8030102@samsung.com>
 <BLU0-SMTP1645A2349311998A104ACB8ADBF0@phx.gbl> <52D63405.9080604@samsung.com>
 <BLU0-SMTP184B0B9737C458456530152ADBE0@phx.gbl>
In-reply-to: <BLU0-SMTP184B0B9737C458456530152ADBE0@phx.gbl>
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 01/15/2014 04:50 PM, randy wrote:
>
> Sorry, I forget to switch to new kernel,
> but in new kernel it doesn't work too.
> root@kagami:~/v4l2-mfc-encoder# ./mfc-encode -m /dev/video1 -c
> h264,header_mode=1 -d 1
> mfc codec encoding example application
> Andrzej Hajda <a.hajda@samsung.com>
> Copyright 2012 Samsung Electronics Co., Ltd.
>
> 106.984340799:args.c:parse_args:190: codec: H264
> 106.984870424:args.c:parse_args:187: opt header_mode=1
> 106.999434841:mfc.c:mfc_create:87: MFC device /dev/video1 opened with fd=3
> 107.15356632:v4l_dev.c:v4l_req_bufs:116: Succesfully requested 16
> buffers for device 3:0
> 107.15534549:func_dev.c:func_req_bufs:42: Succesfully requested 16
> buffers for device -1:1
> 107.15708424:func_dev.c:func_enq_buf:113: Enqueued buffer 0/16 to -1:1
> 107.15862049:func_dev.c:func_enq_buf:113: Enqueued buffer 1/16 to -1:1
> 107.16004132:func_dev.c:func_enq_buf:113: Enqueued buffer 2/16 to -1:1
> 107.16146841:func_dev.c:func_enq_buf:113: Enqueued buffer 3/16 to -1:1
> 107.16284799:func_dev.c:func_enq_buf:113: Enqueued buffer 4/16 to -1:1
> 107.16429049:func_dev.c:func_enq_buf:113: Enqueued buffer 5/16 to -1:1
> 107.16569382:func_dev.c:func_enq_buf:113: Enqueued buffer 6/16 to -1:1
> 107.16715257:func_dev.c:func_enq_buf:113: Enqueued buffer 7/16 to -1:1
> 107.16859924:func_dev.c:func_enq_buf:113: Enqueued buffer 8/16 to -1:1
> 107.17006674:func_dev.c:func_enq_buf:113: Enqueued buffer 9/16 to -1:1
> 107.17158466:func_dev.c:func_enq_buf:113: Enqueued buffer 10/16 to -1:1
> 107.17307132:func_dev.c:func_enq_buf:113: Enqueued buffer 11/16 to -1:1
> 107.17455632:func_dev.c:func_enq_buf:113: Enqueued buffer 12/16 to -1:1
> 107.17599216:func_dev.c:func_enq_buf:113: Enqueued buffer 13/16 to -1:1
> 107.17748299:func_dev.c:func_enq_buf:113: Enqueued buffer 14/16 to -1:1
> 107.17897341:func_dev.c:func_enq_buf:113: Enqueued buffer 15/16 to -1:1
> v4l_dev.c:v4l_req_bufs:111: error: Failed to request 4 buffers for
> device 3:1)
> root@kagami:~/v4l2-mfc-encoder# ls -l demo.out
> -rw-r--r-- 1 root root 0 Jan 15 15:49 demo.out
> root@kagami:~/v4l2-mfc-encoder# uname -a
> Linux kagami 3.13.0-rc8-00018-g8f39393-dirty #17 SMP PREEMPT Wed Jan 15
> 18:40:53 CST 2014 armv7l GNU/Linux
> root@kagami:~/v4l2-mfc-encoder# dmesg|grep mfc
> [    1.295000] s5p-mfc 13400000.codec: decoder registered as /dev/video0
> [    1.295000] s5p-mfc 13400000.codec: encoder registered as /dev/video1
> [  100.645000] s5p_mfc_alloc_priv_buf:43: Allocating private buffer failed
> [  100.645000] s5p_mfc_alloc_codec_buffers_v5:177: Failed to allocate
> Bank1 temporary buffer
> [  107.065000] s5p_mfc_alloc_priv_buf:43: Allocating private buffer failed
> [  107.065000] s5p_mfc_alloc_codec_buffers_v5:177: Failed to allocate
> Bank1 temporary buffer
Try to increase CMA size in kernel config - CONFIG_CMA_SIZE_MBYTES,
by default it is set to 16MB, try for example 64MB.

Regards
Andrzej

