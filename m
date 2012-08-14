Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:52938 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752013Ab2HNQh0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 14 Aug 2012 12:37:26 -0400
Received: from eusync4.samsung.com (mailout2.w1.samsung.com [210.118.77.12])
 by mailout2.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0M8R006Y07J2TP20@mailout2.w1.samsung.com> for
 linux-media@vger.kernel.org; Tue, 14 Aug 2012 17:37:50 +0100 (BST)
Received: from [106.116.147.32] by eusync4.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTPA id <0M8R00IJT7IC3C00@eusync4.samsung.com> for
 linux-media@vger.kernel.org; Tue, 14 Aug 2012 17:37:24 +0100 (BST)
Message-id: <502A7EC3.7030803@samsung.com>
Date: Tue, 14 Aug 2012 18:37:23 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
MIME-version: 1.0
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: LMML <linux-media@vger.kernel.org>,
	Manu Abraham <abraham.manu@gmail.com>,
	=?UTF-8?B?RGF2aWQgSMOkcmRlbWFu?= <david@hardeman.nu>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Prabhakar Lad <prabhakar.lad@ti.com>
Subject: Re: Patches submitted via linux-media ML that are at
 patchwork.linuxtv.org
References: <502A4CD1.1020108@redhat.com>
In-reply-to: <502A4CD1.1020108@redhat.com>
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 08/14/2012 03:04 PM, Mauro Carvalho Chehab wrote:
> This one requires more testing:
> 
> May,15 2012: [GIT,PULL,FOR,3.5] DMABUF importer feature in V4L2 API                 http://patchwork.linuxtv.org/patch/11268  Sylwester Nawrocki <s.nawrocki@samsung.com>

Hmm, this is not valid any more. Tomasz just posted a new patch series
that adds DMABUF importer and exporter feature altogether.

[PATCHv8 00/26] Integration of videobuf2 with DMABUF

I guess we need someone else to submit test patches for other H/W
than just Samsung SoCs. I'm not sure if we've got enough resources
to port this to other hardware. We have been using these features
internally for some time already. It's been 2 kernel releases and
I can see only Ack tags from Laurent on Tomasz's patch series, hence
it seems there is no wide interest in DMABUF support in V4L2 and
this patch series is probably going to stay in a fridge for another
few kernel releases.

--

Regards,
Sylwester

