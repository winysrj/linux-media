Return-path: <mchehab@pedra>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:14967 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753508Ab1DLH5Z (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 12 Apr 2011 03:57:25 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: text/plain; charset=ISO-8859-1
Received: from eu_spt1 ([210.118.77.13]) by mailout3.w1.samsung.com
 (Sun Java(tm) System Messaging Server 6.3-8.04 (built Jul 29 2009; 32bit))
 with ESMTP id <0LJJ00M494RNLI70@mailout3.w1.samsung.com> for
 linux-media@vger.kernel.org; Tue, 12 Apr 2011 08:57:23 +0100 (BST)
Received: from linux.samsung.com ([106.116.38.10])
 by spt1.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0LJJ00K674RMK7@spt1.w1.samsung.com> for
 linux-media@vger.kernel.org; Tue, 12 Apr 2011 08:57:23 +0100 (BST)
Date: Tue, 12 Apr 2011 09:57:22 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: Re: [PATCH 2.6.39] soc_camera: OMAP1: fix missing bytesperline and
	sizeimage initialization
In-reply-to: <Pine.LNX.4.64.1104120820020.23770@axis700.grange>
To: Kassey Lee <kassey1216@gmail.com>
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Message-id: <4DA405E2.3080708@samsung.com>
References: <201104090158.04827.jkrzyszt@tis.icnet.pl>
 <Pine.LNX.4.64.1104101751380.12697@axis700.grange>
 <BANLkTimut-G1YXFU+4gqiCij-RLu-Vn4-Q@mail.gmail.com>
 <Pine.LNX.4.64.1104120820020.23770@axis700.grange>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi,

On 04/12/2011 08:28 AM, Guennadi Liakhovetski wrote:
> Hi
> 
> On Tue, 12 Apr 2011, Kassey Lee wrote:
> 
>> hi, Guennadi:
>>     a lot of sensors support JPEG output.
>>     1) bytesperline is defined by sensor timing.

Im not sure whether this is the case. Doesn't bytesperline refer only 
to the data layout in memory buffer written by the DMA? 
i.e. does padding really makes sens for JPEG files?

>>     2) and sizeimage is unknow for jpeg.
>>
>>   how about for JPEG
>>    1) host driver gets bytesperline from sensor driver.
>>    2) sizeimage refilled by host driver after dma transfer done( a
>> frame is received)

You might want to use v4l2_buffer::bytesused to inform user space about
the actual size of the captured frame, which would be set before a buffer
is dequeued from the driver. The size of JPEG file will depend on the content,
so IMHO you could not use v4l2_pix_fmt::sizeimage in such way.


>>   thanks.
> 
> How is this done currently on other V4L2 drivers? To transfer a frame you
> usually first do at least one of S_FMT and G_FMT, at which time you 
> already have to report sizeimage to the user - before any transfer has 
> taken place. Currently with soc-camera it is already possible to override 
> sizeimage and bytesperline from the host driver. Just set them to whatever 
> you need in your try_fmt and they will be kept. Not sure how you want to 
> do that, if you need to first read in a frame - do you want to perform 
> some dummy frame transfer? You might not even have any buffers queued yet, 
> so, it has to be a read without writing to RAM. Don't such compressed 
> formats just put a value in sizeimage, that is a calculated maximum size?

I the S5P FIMC driver I used to set sizeimage to some arbitrary value,
(it's not yet in mainline kernel), e.g.
sizeimage = width * height * C,  where C = 1
bytesperline = width.

However it would be useful to make the C coefficient dependent on JPEG
compression quality, not to make the image buffer unnecessary large.
I thought about creating a separate control class for JPEG but the quality
control was so far everything I would need to put in this class. It's on my
to do list to figure out what controls set would cover the standard.


Regards,
-- 
Sylwester Nawrocki
Samsung Poland R&D Center
