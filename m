Return-path: <mchehab@pedra>
Received: from mailout1.samsung.com ([203.254.224.24]:61839 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751202Ab1AMIjb (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 13 Jan 2011 03:39:31 -0500
Date: Thu, 13 Jan 2011 17:39:24 +0900
From: Jonghun Han <jonghun.han@samsung.com>
Subject: RE: Memory sharing issue by application on V4L2 based device driver
 with system mmu.
In-reply-to: <20110111173509.GB14017@dumpdata.com>
To: 'Konrad Rzeszutek Wilk' <konrad.wilk@oracle.com>
Cc: 'InKi Dae' <daeinki@gmail.com>, linux-media@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	'linux-fbdev' <linux-fbdev@vger.kernel.org>,
	kyungmin.park@samsung.com
Message-id: <007b01cbb2fd$64a0f050$2de2d0f0$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-language: ko
Content-transfer-encoding: 7BIT
References: <4D25BC22.6080803@samsung.com>
 <AANLkTi=P8qY22saY9a_-rze1wsr-DLMgc6Lfa6qnfM7u@mail.gmail.com>
 <002201cbadfd$6d59e490$480dadb0$%han@samsung.com>
 <AANLkTinsduJkynwwEeM5K9f3D7C6jtBgkAyZ0-_0z2X-@mail.gmail.com>
 <003201cbae19$bda3dfc0$38eb9f40$%han@samsung.com>
 <20110111173509.GB14017@dumpdata.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>


Sorry for late reply.

Samsung SoC C210 has many multimedia IPs.
Each IP has its own MMU named SYSTEM MMU like CPU's MMU.
So it can handle discontiguous memory using device own virtual address.

What Inki Dae wants to discuss is how to allocate the memory and how to
share it with other multimedia IPs. 

Thank you for interesting.

Best regards,

> -----Original Message-----
> From: linux-fbdev-owner@vger.kernel.org [mailto:linux-fbdev-
> owner@vger.kernel.org] On Behalf Of Konrad Rzeszutek Wilk
> Sent: Wednesday, January 12, 2011 2:35 AM
> To: Jonghun Han
> Cc: 'InKi Dae'; linux-media@vger.kernel.org;
linux-arm-kernel@lists.infradead.org;
> 'linux-fbdev'; kyungmin.park@samsung.com
> Subject: Re: Memory sharing issue by application on V4L2 based device
driver
> with system mmu.
> 
> 
>  .. snip..
> > But 64KB or 1MB physically contiguous memory is better than 4KB page
> > in the point of performance.
> 
> Could you explain that in more details please? I presume you are talking
about a
> CPU that has a MMU unit, right?
> --
> To unsubscribe from this list: send the line "unsubscribe linux-fbdev" in
the body
> of a message to majordomo@vger.kernel.org More majordomo info at
> http://vger.kernel.org/majordomo-info.html

