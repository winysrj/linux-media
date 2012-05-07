Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:50585 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755872Ab2EGPLf (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 7 May 2012 11:11:35 -0400
Date: Mon, 07 May 2012 17:11:31 +0200
From: Tomasz Stanislawski <t.stanislaws@samsung.com>
Subject: Re: [PATCHv5 08/13] v4l: vb2-dma-contig: add support for scatterlist
 in userptr mode
In-reply-to: <4FA7DE61.7000705@gmail.com>
To: Subash Patel <subashrp@gmail.com>
Cc: linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
	airlied@redhat.com, m.szyprowski@samsung.com,
	kyungmin.park@samsung.com, laurent.pinchart@ideasonboard.com,
	sumit.semwal@ti.com, daeinki@gmail.com, daniel.vetter@ffwll.ch,
	robdclark@gmail.com, pawel@osciak.com,
	linaro-mm-sig@lists.linaro.org, hverkuil@xs4all.nl,
	remi@remlab.net, mchehab@redhat.com, linux-doc@vger.kernel.org,
	g.liakhovetski@gmx.de,
	Andrzej Pietrasiewicz <andrzej.p@samsung.com>,
	Kamil Debski <k.debski@samsung.com>
Message-id: <4FA7E623.2060500@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7BIT
References: <1334933134-4688-1-git-send-email-t.stanislaws@samsung.com>
 <1334933134-4688-9-git-send-email-t.stanislaws@samsung.com>
 <4FA7DE61.7000705@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Subash,
Could you provide a detailed description of a test case
that causes a failure of vb2_dc_pages_to_sgt?

Regards,
Tomasz Stanislawski
