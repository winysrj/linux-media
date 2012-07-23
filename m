Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:39497 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752672Ab2GWMdY (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 23 Jul 2012 08:33:24 -0400
Received: from eusync4.samsung.com (mailout2.w1.samsung.com [210.118.77.12])
 by mailout2.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0M7M00CVZ5KEJH50@mailout2.w1.samsung.com> for
 linux-media@vger.kernel.org; Mon, 23 Jul 2012 13:33:50 +0100 (BST)
Received: from [106.116.147.32] by eusync4.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTPA id <0M7M00HJ45JMAF90@eusync4.samsung.com> for
 linux-media@vger.kernel.org; Mon, 23 Jul 2012 13:33:22 +0100 (BST)
Message-id: <500D4407.9060701@samsung.com>
Date: Mon, 23 Jul 2012 14:31:03 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
MIME-version: 1.0
To: Javier Martin <javier.martin@vista-silicon.com>
Cc: linux-media@vger.kernel.org,
	sakari.ailus@maxwell.research.nokia.com, kyungmin.park@samsung.com,
	laurent.pinchart@ideasonboard.com, mchehab@infradead.org,
	s.hauer@pengutronix.de, p.zabel@pengutronix.de, hverkuil@xs4all.nl
Subject: Re: [PATCH v7] media: coda: Add driver for Coda video codec.
References: <1343043061-24327-1-git-send-email-javier.martin@vista-silicon.com>
In-reply-to: <1343043061-24327-1-git-send-email-javier.martin@vista-silicon.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 07/23/2012 01:31 PM, Javier Martin wrote:
> Coda is a range of video codecs from Chips&Media that
> support H.264, H.263, MPEG4 and other video standards.
> 
> Currently only support for the codadx6 included in the
> i.MX27 SoC is added. H.264 and MPEG4 video encoding
> are the only supported capabilities by now.
> 
> Signed-off-by: Javier Martin <javier.martin@vista-silicon.com>

Reviewed-by: Sylwester Nawrocki <s.nawrocki@samsung.com>

--

Regards,
Sylwester
