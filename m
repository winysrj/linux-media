Return-path: <linux-media-owner@vger.kernel.org>
Received: from blu0-omc2-s31.blu0.hotmail.com ([65.55.111.106]:20260 "EHLO
	blu0-omc2-s31.blu0.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751450AbaAPUKj (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 16 Jan 2014 15:10:39 -0500
Message-ID: <BLU0-SMTP1088EA2459775CE15B7545BADB90@phx.gbl>
Date: Fri, 17 Jan 2014 04:10:31 +0800
From: randy <lxr1234@hotmail.com>
MIME-Version: 1.0
To: Andrzej Hajda <a.hajda@samsung.com>, linux-media@vger.kernel.org
Subject: Re: using MFC memory to memery encoder, start stream and queue order
 problem
References: <BLU0-SMTP32889EC1B64B13894EE7C90ADCB0@phx.gbl> <02c701cf07b6$565cd340$031679c0$%debski@samsung.com> <BLU0-SMTP266BE9BC66B254061740251ADCB0@phx.gbl> <02c801cf07ba$8518f2f0$8f4ad8d0$%debski@samsung.com> <BLU0-SMTP150C8C0DB0E9A3A9F4104F8ADCA0@phx.gbl> <04b601cf0c7f$d9e531d0$8daf9570$%debski@samsung.com> <52CD725E.5060903@hotmail.com> <BLU0-SMTP6650E76A95FA2BB39C6325ADB30@phx.gbl> <52CFD5DF.6050801@samsung.com> <BLU0-SMTP37B0A51F0A2D2F1E79A730ADB30@phx.gbl> <52D3BCB7.1060309@samsung.com> <52D3CB84.6090406@samsung.com> <BLU0-SMTP3546CDA7E88F73435A3A876ADBC0@phx.gbl> <001701cf107b$0927aa50$1b76fef0$%debski@samsung.com> <BLU0-SMTP183F0EEECCB365900DE2315ADBF0@phx.gbl> <52D51179.8030102@samsung.com> <BLU0-SMTP1645A2349311998A104ACB8ADBF0@phx.gbl> <52D63405.9080604@samsung.com> <BLU0-SMTP184B0B9737C458456530152ADBE0@phx.gbl> <52D7D284.1080700@samsung.com>
In-Reply-To: <52D7D284.1080700@samsung.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

>> [  100.645000] s5p_mfc_alloc_codec_buffers_v5:177: Failed to 
>> allocate Bank1 temporary buffer [  107.065000] 
>> s5p_mfc_alloc_priv_buf:43: Allocating private buffer failed [ 
>> 107.065000] s5p_mfc_alloc_codec_buffers_v5:177: Failed to 
>> allocate Bank1 temporary buffer
> Try to increase CMA size in kernel config - CONFIG_CMA_SIZE_MBYTES,
> by default it is set to 16MB, try for example 64MB.
I am very sorry, I don't test it carefully, the mfc-encode can't work
on 3.13-rc8, with or without header_mode=1 it will got
v4l_dev.c:v4l_req_bufs:111: error: Failed to request 4 buffers for
device 3:1)
and
[ 1706.540000] s5p_mfc_alloc_codec_buffers_v5:177: Failed to allocate
Bank1 temporary buffer

In the old 3.5 kernel, it has this kind of problem too,
[    0.210000] Failed to declare coherent memory for MFC device (0
bytes at 0x43000000)

I wonder is there some problem of the board or core board. But it
seems that result of 3.5 is better(but without the I-frame, the
encoded data is useless as I know)

Thank you
ayaka
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iQEcBAEBAgAGBQJS2Dy3AAoJEPb4VsMIzTziYooH/3GxuPn2bt74QQF0fy8yZH+T
kE4K9F9JUValDfdQc0GBnFDRBb4CIbL4ncWoRhj4mjH3Iu3OOxWjRgEl/aZ+TzZg
3BJSTI9Wnaxt4sFCVJKHtYY9Ei7nv2548/hC2UzkrzmtPYIiUBmEarbI4rcrX3/Y
II1Oe8GoCvyyD7/BJ37ENKX1Y3O1ZvwZJvKaTRamAJQmJKpR5/wFvrRBqp1kLG5l
1LHJOM2qfWAB7HWlALDXpgYS8UhovHWPqWZj7tLKzLEibvRKqqD6+ZRY29nJTkED
KcvNY6pGv5vdoQoP6cHAWARg8WwGCR3brOXiPaNCp3GtsFfATEDHLhOIIc12vOg=
=fa3t
-----END PGP SIGNATURE-----
