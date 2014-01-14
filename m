Return-path: <linux-media-owner@vger.kernel.org>
Received: from blu0-omc2-s9.blu0.hotmail.com ([65.55.111.84]:14596 "EHLO
	blu0-omc2-s9.blu0.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750751AbaANQt7 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 14 Jan 2014 11:49:59 -0500
Message-ID: <BLU0-SMTP1645A2349311998A104ACB8ADBF0@phx.gbl>
Date: Wed, 15 Jan 2014 00:50:03 +0800
From: randy <lxr1234@hotmail.com>
MIME-Version: 1.0
To: Andrzej Hajda <a.hajda@samsung.com>,
	Kamil Debski <k.debski@samsung.com>,
	linux-media@vger.kernel.org
CC: kyungmin.park@samsung.com
Subject: Re: using MFC memory to memery encoder, start stream and queue order
 problem
References: <BLU0-SMTP32889EC1B64B13894EE7C90ADCB0@phx.gbl> <02c701cf07b6$565cd340$031679c0$%debski@samsung.com> <BLU0-SMTP266BE9BC66B254061740251ADCB0@phx.gbl> <02c801cf07ba$8518f2f0$8f4ad8d0$%debski@samsung.com> <BLU0-SMTP150C8C0DB0E9A3A9F4104F8ADCA0@phx.gbl> <04b601cf0c7f$d9e531d0$8daf9570$%debski@samsung.com> <52CD725E.5060903@hotmail.com> <BLU0-SMTP6650E76A95FA2BB39C6325ADB30@phx.gbl> <52CFD5DF.6050801@samsung.com> <BLU0-SMTP37B0A51F0A2D2F1E79A730ADB30@phx.gbl> <52D3BCB7.1060309@samsung.com> <52D3CB84.6090406@samsung.com> <BLU0-SMTP3546CDA7E88F73435A3A876ADBC0@phx.gbl> <001701cf107b$0927aa50$1b76fef0$%debski@samsung.com> <BLU0-SMTP183F0EEECCB365900DE2315ADBF0@phx.gbl> <52D51179.8030102@samsung.com>
In-Reply-To: <52D51179.8030102@samsung.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

于 2014年01月14日 18:29, Andrzej Hajda 写道:
> On 01/14/2014 06:17 AM, randy wrote:
>> Yes, it make encoder work. But sadness ./mfc-encode -m
>> /dev/video1 -c h264,header_mode=1 -d 1 will still output a zero
>> demo.out without header-mode or set it to zero will works. What
>> is the problem?
> 
> It seems infradead repo is not synchronized with our internal
> repo. Please apply attached patch.
> 
No, it has been applied in public repo.
And my code is in applied version, but it doesn't work.
Here is the log
============================
mfc codec encoding example application
Andrzej Hajda <a.hajda@samsung.com>
Copyright 2012 Samsung Electronics Co., Ltd.

70.259455868:args.c:parse_args:190: codec: H264
70.259635952:args.c:parse_args:187: opt header_mode=1
mfc.c:mfc_create:85: error: Cannot subscribe EOS event for MFC
70.286725493:mfc.c:mfc_create:87: MFC device /dev/video1 opened with fd=3
70.294186576:v4l_dev.c:v4l_req_bufs:116: Succesfully requested 16
buffers for device 3:0
70.294508201:func_dev.c:func_req_bufs:42: Succesfully requested 16
buffers for device -1:1
70.294936410:func_dev.c:func_enq_buf:113: Enqueued buffer 0/16 to -1:1
70.295440952:func_dev.c:func_enq_buf:113: Enqueued buffer 1/16 to -1:1
70.295692535:func_dev.c:func_enq_buf:113: Enqueued buffer 2/16 to -1:1
70.295912035:func_dev.c:func_enq_buf:113: Enqueued buffer 3/16 to -1:1
70.296122285:func_dev.c:func_enq_buf:113: Enqueued buffer 4/16 to -1:1
70.296310368:func_dev.c:func_enq_buf:113: Enqueued buffer 5/16 to -1:1
70.296477410:func_dev.c:func_enq_buf:113: Enqueued buffer 6/16 to -1:1
70.296626993:func_dev.c:func_enq_buf:113: Enqueued buffer 7/16 to -1:1
70.296788618:func_dev.c:func_enq_buf:113: Enqueued buffer 8/16 to -1:1
70.296949910:func_dev.c:func_enq_buf:113: Enqueued buffer 9/16 to -1:1
70.297115327:func_dev.c:func_enq_buf:113: Enqueued buffer 10/16 to -1:1
70.297277993:func_dev.c:func_enq_buf:113: Enqueued buffer 11/16 to -1:1
70.297435618:func_dev.c:func_enq_buf:113: Enqueued buffer 12/16 to -1:1
70.297591993:func_dev.c:func_enq_buf:113: Enqueued buffer 13/16 to -1:1
70.297760868:func_dev.c:func_enq_buf:113: Enqueued buffer 14/16 to -1:1
70.297917910:func_dev.c:func_enq_buf:113: Enqueued buffer 15/16 to -1:1
70.336368993:v4l_dev.c:v4l_req_bufs:116: Succesfully requested 4
buffers for device 3:1
70.336587368:func_dev.c:func_req_bufs:42: Succesfully requested 4
buffers for device 4:0
70.342405784:v4l_dev.c:v4l_enq_buf:211: Enqueued buffer 0/4 to 3:1
70.348009117:v4l_dev.c:v4l_enq_buf:211: Enqueued buffer 1/4 to 3:1
70.352857159:v4l_dev.c:v4l_enq_buf:211: Enqueued buffer 2/4 to 3:1
70.357489076:v4l_dev.c:v4l_enq_buf:211: Enqueued buffer 3/4 to 3:1
State [enq cnt/max]: [Off 0 0/0|Rdy 16 0/1] [Off 0 0/0|Off 4 0/0] [Off
0 0/0|Off 0 0/0]
State [enq cnt/max]: [Off 0 0/0|Rdy 16 0/1] [Off 0 0/0|Off 4 0/0] [Off
0 0/0|Off 0 0/0]
70.357812534:func_dev.c:func_deq_buf:79: Dequeued buffer 0/16 from
- -1:1 ret=25344
70.357841701:func_dev.c:func_deq_buf:88: End on -1:1
70.357882201:v4l_dev.c:v4l_enq_buf:211: Enqueued buffer 0/16 to 3:0
70.357961534:v4l_dev.c:v4l_stream_set:76: Stream started on fd=3:0
70.358038117:v4l_dev.c:v4l_stream_set:92: Stream started on fd=3:1
70.358070659:v4l_dev.c:v4l_enq_buf:226: EOS sent to 3:0, ret=-1
State [enq cnt/max]: [Off 0 0/0|End 15 1/1] [Bus 1 0/1|Bus 4 0/0] [Off
0 0/0|Off 0 0/0]
70.358163367:io_dev.c:wait_for_ready_devs:64: Will poll fd=3 events=7
root@kagami:~/v4l2-mfc-encoder# ls -l demo.out
- -rw-r--r-- 1 root root 0 Jan 14 16:48 demo.out
> Regards Andrzej
> 

Thank you


						ayaka
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iQEcBAEBAgAGBQJS1Wq7AAoJEPb4VsMIzTziM/UH/0LSC7xRC35nzPhAPue8yFw+
/OMpCcM1OArsqKIGqrGNaDTnkePSkQ22/W1CbtbrJatpDmI1zLZOfJIK4w4PCd0E
LV/NoVqdr8N5aLsmrC5Ao7zXViCiSDVMxqyAGPXObXA+2IJDxf34yWAxTGIVYlo6
Q2B5EMWyF4GHBvF1shk/So0YF6RBpI8s6on54QoSaNon95dupsk1QQ0ceXmPj/6c
X/fI5M6etToml0txKpXD4auafLxb8ebZAn4ZHx2F69WFIJFozLL9FkYl6MizORkN
ke34+xhQUZ6NF4ykBtbCUHVacDegsbiW/ISKtpjxDoWLRcIZPy0BvuUE8guY/Uk=
=0BWS
-----END PGP SIGNATURE-----
