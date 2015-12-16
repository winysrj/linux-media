Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.4.pengutronix.de ([92.198.50.35]:47715 "EHLO
	metis.ext.4.pengutronix.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751938AbbLPOtu (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 16 Dec 2015 09:49:50 -0500
Message-ID: <1450277389.3421.53.camel@pengutronix.de>
Subject: Re: problem with coda when running qt-gstreamer and video reaches
 its end (resending in plain text)
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Piotr Lewicki <piotr.lewicki@elfin.de>
Cc: linux-media@vger.kernel.org
Date: Wed, 16 Dec 2015 15:49:49 +0100
In-Reply-To: <5671627C.8020205@elfin.de>
References: <5671618A.5000300@elfin.de> <5671627C.8020205@elfin.de>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Piotr,

thank you for the report.

Am Mittwoch, den 16.12.2015, 14:09 +0100 schrieb Piotr Lewicki:
> Hello,
> I'm running an application that plays video on an embedded device. It 
> uses Qt5.4 and qt-gstreamer plugin and it runs on imx6q processor with 
> yocto based linux (kernel version 3.19.5).

First, could you repeat this using current versions of the coda driver
and GStreamer? There are about 60 coda patches in mainline between v3.19
and v4.3, and some of them are quite relevant for the end-of-stream and
buffer handling. I think the relevant GStreamer EOS change went into
1.5.2.

> When I built a sample from this qt-gstreamer package called qmlplayer2 
> and used it to play video I came across following problem:
> 
> 1. When video reaches it's end I start receiving kernel ringbuffer message:
> # [ 1371.618854] coda 2040000.vpu: CODA PIC_RUN timeout
> # [ 1372.618713] coda 2040000.vpu: CODA PIC_RUN timeout
> # [ 1373.618653] coda 2040000.vpu: CODA PIC_RUN timeout
> # [ 1374.618872] coda 2040000.vpu: CODA PIC_RUN timeout
> # [ 1375.618712] coda 2040000.vpu: CODA PIC_RUN timeout
> # [ 1376.618707] coda 2040000.vpu: CODA PIC_RUN timeout
> # [ 1377.618860] coda 2040000.vpu: CODA PIC_RUN timeout
> # [ 1378.738700] coda 2040000.vpu: CODA PIC_RUN timeout
> # [ 1379.738632] coda 2040000.vpu: CODA PIC_RUN timeout
> # [ 1380.828872] coda 2040000.vpu: CODA PIC_RUN timeout
> # [ 1381.828697] coda 2040000.vpu: CODA PIC_RUN timeout
> # [ 1382.828875] coda 2040000.vpu: CODA PIC_RUN timeout
> # [ 1383.938704] coda 2040000.vpu: CODA PIC_RUN timeout
> 
> The video is stopped but I can see last frame on the screen although in 
> qt application it should receive end-of-stream message and stop the 
> video (resulting with black screen).

Looks like the coda driver is constantly fed empty buffers, which don't
increase the bitstream payload level, and the PIC_RUN times out with a
bitstream buffer underflow. What GStreamer version is this?

> 2. If I don't terminate the application and several times press "stop" 
> and "play" video I get message:
> 
> # [ 3041.650483] coda 2040000.vpu: dma_alloc_coherent of size 3133440 failed
> # [ 3044.205362] coda 2040000.vpu: dma_alloc_coherent of size 3133440 failed
> # [ 3044.214711] coda 2040000.vpu: dma_alloc_coherent of size 3133440 failed
> # [ 3047.189317] coda 2040000.vpu: dma_alloc_coherent of size 3133440 failed
> # [ 3047.196056] coda 2040000.vpu: dma_alloc_coherent of size 3133440 failed
> 
> and finally
> 
> # [ 3049.161708] coda 2040000.vpu: dma_alloc_coherent of size 3133440 failed
> # "Failed to allocate required memory."

That shouldn't happen anymore in recent kernels. In the past, repeated
reqbufs calls would leak buffers because the cleanup was only done on
close.

Please let me know if you can reproduce any of the issues with more
recent kernels and GStreamer 1.6.

regards
Philipp

