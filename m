Return-path: <linux-media-owner@vger.kernel.org>
Received: from na3sys009aog123.obsmtp.com ([74.125.149.149]:43246 "EHLO
	na3sys009aog123.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756117Ab2K0Qvj convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 27 Nov 2012 11:51:39 -0500
From: Albert Wang <twang13@marvell.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
CC: "corbet@lwn.net" <corbet@lwn.net>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	Libin Yang <lbyang@marvell.com>
Date: Tue, 27 Nov 2012 08:50:08 -0800
Subject: RE: [PATCH 10/15] [media] marvell-ccic: split mcam core into 2
 parts for soc_camera support
Message-ID: <477F20668A386D41ADCC57781B1F70430D1367C91C@SC-VEXCH1.marvell.com>
References: <1353677652-24288-1-git-send-email-twang13@marvell.com>
 <Pine.LNX.4.64.1211271405340.22273@axis700.grange>
 <477F20668A386D41ADCC57781B1F70430D1367C905@SC-VEXCH1.marvell.com>
 <Pine.LNX.4.64.1211271735530.22273@axis700.grange>
In-Reply-To: <Pine.LNX.4.64.1211271735530.22273@axis700.grange>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi, Guennadi


>-----Original Message-----
>From: Guennadi Liakhovetski [mailto:g.liakhovetski@gmx.de]
>Sent: Wednesday, 28 November, 2012 00:39
>To: Albert Wang
>Cc: corbet@lwn.net; linux-media@vger.kernel.org; Libin Yang
>Subject: RE: [PATCH 10/15] [media] marvell-ccic: split mcam core into 2 parts for
>soc_camera support
>
>On Tue, 27 Nov 2012, Albert Wang wrote:
>
>[snip]
>
>> >you did change a couple of things - like replaced printk() with
>> >cam_err(), and actually
>> >here:
>> >
>> >> +		cam_err(cam, "marvell-cam: Cafe can't do S/G I/O," \
>> >> +			"attempting vmalloc mode instead\n");
>> >
>> >and here
>> >
>> >> +			cam_warn(cam, "Unable to alloc DMA buffers at load" \
>> >> +					"will try again later\n");
>> >
>> >the backslashes are not needed... Also in these declarations:
>> >
>> Sorry, I have to clarify it. :)
>> I replaced printk() and add backslashes just because the tool scripts/checkpatch.pl.
>> It will report error when remove the blackslash and report warning when using printk().
>> But these errors and warnings will be reported only in latest kernel
>> code. :)
>>
>> If you think we can ignore these errors and warnings, I'm OK to get
>> back to the original code. :)
>
>Replacing printk() with cam_*() is ok, just please remove the backslashes.
>Actually, there are also spaces missing in above strings - when they'll be pasted
>together. As for checkpatch, I would ignore this its warning, because this is not new
>code, this has been there also in the original driver, you're just moving the code around.
>
OK, I will follow up your suggestion. :)
Thanks a lot for pointing out so many improvements in our patches. :)


>Thanks
>Guennadi
>---
>Guennadi Liakhovetski, Ph.D.
>Freelance Open-Source Software Developer http://www.open-technology.de/
