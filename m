Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:27965 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753165AbaAJLNk (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 10 Jan 2014 06:13:40 -0500
Received: from eucpsbgm2.samsung.com (unknown [203.254.199.245])
 by mailout2.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MZ6005NUN6O5M10@mailout2.w1.samsung.com> for
 linux-media@vger.kernel.org; Fri, 10 Jan 2014 11:13:36 +0000 (GMT)
Message-id: <52CFD5DF.6050801@samsung.com>
Date: Fri, 10 Jan 2014 12:13:35 +0100
From: Andrzej Hajda <a.hajda@samsung.com>
MIME-version: 1.0
To: randy <lxr1234@hotmail.com>, linux-media@vger.kernel.org
Cc: Kamil Debski <k.debski@samsung.com>, kyungmin.park@samsung.com
Subject: Re: using MFC memory to memery encoder,
 start stream and queue order problem
References: <BLU0-SMTP32889EC1B64B13894EE7C90ADCB0@phx.gbl>
 <02c701cf07b6$565cd340$031679c0$%debski@samsung.com>
 <BLU0-SMTP266BE9BC66B254061740251ADCB0@phx.gbl>
 <02c801cf07ba$8518f2f0$8f4ad8d0$%debski@samsung.com>
 <BLU0-SMTP150C8C0DB0E9A3A9F4104F8ADCA0@phx.gbl>
 <04b601cf0c7f$d9e531d0$8daf9570$%debski@samsung.com>
 <52CD725E.5060903@hotmail.com> <BLU0-SMTP6650E76A95FA2BB39C6325ADB30@phx.gbl>
In-reply-to: <BLU0-SMTP6650E76A95FA2BB39C6325ADB30@phx.gbl>
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Randy,

On 01/10/2014 10:15 AM, randy wrote:

<snip>

>> It won't work, if I do that, after step 7, neither OUPUT nor
>> CAPTURE will poll return in my program. but ./mfc-encode -m
>> /dev/video1 -c h264,header_mode=1 work normally,
> I am sorry, I didn't well test it, if I use ./mfc-encode -m
> /dev/video1 -c h264,header_mode=1 -d 1
> then the size of demo.out is zero,
> but ./mfc-encode -d 1 -m /dev/video1 -c h264 will out a 158 bytes files.
> When duration is 2, with header_mode=1, the output file size is 228
> bytes.Without it, the size is 228 too.
> I wonder whether it is the driver's problem, as I see this in dmesg
> [    0.210000] Failed to declare coherent memory for MFC device (0
> bytes at 0x43000000)
> As the driver is not ready to use in 3.13-rc6 as I reported before, I
> still use the 3.5 from manufacturer.

I am the author of mfc-encode application, it was written for the
mainline kernel 3.8 and later, it should be mentioned in the README.txt
- I will update it.
App will not work correctly with earlier kernels, mainly (but not only)
due to lack of end of stream handling in MFC encoder driver.
If you use vendor kernel I suggest to look at the vendor's capture
apps/libs to check how it uses MFC driver.

Regards
Andrzej


