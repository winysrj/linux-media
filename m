Return-path: <linux-media-owner@vger.kernel.org>
Received: from ptmx.org ([178.63.28.110]:49251 "EHLO ptmx.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750758AbcAUWNp (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 21 Jan 2016 17:13:45 -0500
Received: from [192.168.178.14] (chello062178118086.5.14.vie.surfer.at [62.178.118.86])
	by ptmx.org (Postfix) with ESMTPSA id 90F47205A6
	for <linux-media@vger.kernel.org>; Thu, 21 Jan 2016 23:06:32 +0100 (CET)
To: linux-media@vger.kernel.org
From: Carlos Rafael Giani <dv@pseudoterminal.org>
Subject: i.MX6 VPU and CODA
Message-ID: <56A15668.30901@pseudoterminal.org>
Date: Thu, 21 Jan 2016 23:06:32 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

I have been following the development of Coda support for the i.MX6 
every now and then.
Lately I was told that the current support still has a few problems with 
some corner cases in h.264 and other formats.
I thought perhaps my code in libimxvpuapi can help a bit: 
https://github.com/Freescale/libimxvpuapi/blob/master/imxvpuapi/imxvpuapi_vpulib.c

This is a wrapper around the low-level imx-vpu library, similar to 
Freescale's libfslvpuwrap. The important part is that using imx-vpu 
alone is not easy, and sometimes, encoded frames need additional 
metadata in order for the VPU to be able to work with them. I figured 
out several of these (partially undocumented) necessary extras and put 
them in the library.

So, if you see something in the code that might be carried over to Coda, 
I'd be interested to know.
