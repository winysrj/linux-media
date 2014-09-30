Return-path: <linux-media-owner@vger.kernel.org>
Received: from bhuna.collabora.co.uk ([93.93.135.160]:48184 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751547AbaI3NMH (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 30 Sep 2014 09:12:07 -0400
Message-ID: <542AAC21.70804@collabora.com>
Date: Tue, 30 Sep 2014 09:12:01 -0400
From: Nicolas Dufresne <nicolas.dufresne@collabora.com>
MIME-Version: 1.0
To: Paulo Assis <pj.assis@gmail.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: uvcvideo fails on 3.16 and 3.17 kernels
References: <CAPueXH4puHLAPWpBS9gjGHd5AGb1gAxZqSggXDaGEJ3WYC_nMA@mail.gmail.com>
In-Reply-To: <CAPueXH4puHLAPWpBS9gjGHd5AGb1gAxZqSggXDaGEJ3WYC_nMA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


Le 2014-09-30 04:50, Paulo Assis a écrit :
> https://bugs.launchpad.net/ubuntu/+source/linux/+bug/1362358
>
> I've run some tests and after increasing verbosity for uvcvideo, I get:
> EOF on empty payload
>
> this seems consistent with the zero size frames returned by the driver.
> After VIDIOC_DQBUF | VIDIOC_QBUF, I get buf.bytesused=0
>
> Testing with an eye toy 2 (gspca), everything works fine, so this is
> definitly related to uvcvideo.
> This happens on all available formats (YUYV and MJPEG)
Might be related to the libv4l2 bug I reported yesterday, are you using 
libv4l2 in these tests ?

Nicolas
