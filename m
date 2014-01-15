Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:56851 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750703AbaAOHI6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 15 Jan 2014 02:08:58 -0500
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
Received: from eucpsbgm2.samsung.com (unknown [203.254.199.245])
 by mailout3.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MZF008CXL6WVK60@mailout3.w1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 15 Jan 2014 07:08:56 +0000 (GMT)
Content-transfer-encoding: 8BIT
Message-id: <52D63405.9080604@samsung.com>
Date: Wed, 15 Jan 2014 08:08:53 +0100
From: Andrzej Hajda <a.hajda@samsung.com>
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
 <BLU0-SMTP1645A2349311998A104ACB8ADBF0@phx.gbl>
In-reply-to: <BLU0-SMTP1645A2349311998A104ACB8ADBF0@phx.gbl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 01/14/2014 05:50 PM, randy wrote:
> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA1
>
> 于 2014年01月14日 18:29, Andrzej Hajda 写道:
>> On 01/14/2014 06:17 AM, randy wrote:
>>> Yes, it make encoder work. But sadness ./mfc-encode -m
>>> /dev/video1 -c h264,header_mode=1 -d 1 will still output a zero
>>> demo.out without header-mode or set it to zero will works. What
>>> is the problem?
>> It seems infradead repo is not synchronized with our internal
>> repo. Please apply attached patch.
>>
> No, it has been applied in public repo.
> And my code is in applied version, but it doesn't work.
> Here is the log
> ============================
> mfc codec encoding example application
> Andrzej Hajda <a.hajda@samsung.com>
> Copyright 2012 Samsung Electronics Co., Ltd.
>
> 70.259455868:args.c:parse_args:190: codec: H264
> 70.259635952:args.c:parse_args:187: opt header_mode=1
> mfc.c:mfc_create:85: error: Cannot subscribe EOS event for MFC
This error shows that end-of-stream support is not implemented in the
MFC driver.
> 70.358070659:v4l_dev.c:v4l_enq_buf:226: EOS sent to 3:0, ret=-1
>
Ditto

Are you sure you have used kernel 3.12? Have you compiled the program with
proper kernel-headers?

Regards
Andrzej

