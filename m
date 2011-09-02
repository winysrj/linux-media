Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:24435 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932970Ab1IBJdi (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 2 Sep 2011 05:33:38 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: text/plain; charset=UTF-8
Received: from euspt2 ([210.118.77.13]) by mailout3.w1.samsung.com
 (Sun Java(tm) System Messaging Server 6.3-8.04 (built Jul 29 2009; 32bit))
 with ESMTP id <0LQW00L4G2K050B0@mailout3.w1.samsung.com> for
 linux-media@vger.kernel.org; Fri, 02 Sep 2011 10:33:36 +0100 (BST)
Received: from linux.samsung.com ([106.116.38.10])
 by spt2.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0LQW00J4O2JZY1@spt2.w1.samsung.com> for
 linux-media@vger.kernel.org; Fri, 02 Sep 2011 10:33:36 +0100 (BST)
Date: Fri, 02 Sep 2011 11:33:35 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: Re: Using atmel-isi for direct output on framebuffer ?
In-reply-to: <20110902111853.292d7f26@skate>
To: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
Cc: "Wu, Josh" <Josh.wu@atmel.com>, linux-media@vger.kernel.org
Message-id: <4E60A2EF.10105@samsung.com>
References: <20110901170555.568af6ea@skate>
 <4C79549CB6F772498162A641D92D532802A09156@penmb01.corp.atmel.com>
 <20110902111853.292d7f26@skate>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On 09/02/2011 11:18 AM, Thomas Petazzoni wrote:
> Doing the YUV -> RGB within the V4L2 driver is something I understand
> quite well. The part I miss is how the V4L2 driver interacts with the
> framebuffer driver to output the camera image into the framebuffer.
> 
>> For V4L2_CAP_VIDEO_OVERLAY type driver, I don't know much about that.
> 
> Hum, ok, found http://v4l2spec.bytesex.org/spec/x6570.htm which seems
> to explain a bit the userspace interface for this.

Most up to date documentation is hosted at linuxtv.org:

http://linuxtv.org/downloads/v4l-dvb-apis/overlay.html
