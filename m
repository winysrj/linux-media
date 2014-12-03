Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:10731 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751076AbaLCPHa (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 3 Dec 2014 10:07:30 -0500
Received: from eucpsbgm1.samsung.com (unknown [203.254.199.244])
 by mailout2.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0NG000L0VI52SJ70@mailout2.w1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 03 Dec 2014 15:10:14 +0000 (GMT)
Message-id: <547F2723.5070907@samsung.com>
Date: Wed, 03 Dec 2014 16:07:15 +0100
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
MIME-version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	linux-media@vger.kernel.org
Cc: Michal Simek <michal.simek@xilinx.com>,
	Chris Kohn <christian.kohn@xilinx.com>,
	Hyun Kwon <hyun.kwon@xilinx.com>
Subject: Re: [PATCH v4 07/10] v4l: vb2: Fix race condition in _vb2_fop_release
References: <1417464820-6718-1-git-send-email-laurent.pinchart@ideasonboard.com>
 <1417464820-6718-8-git-send-email-laurent.pinchart@ideasonboard.com>
In-reply-to: <1417464820-6718-8-git-send-email-laurent.pinchart@ideasonboard.com>
Content-type: text/plain; charset=windows-1252
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 01/12/14 21:13, Laurent Pinchart wrote:
> The function releases the queue if the file being released is the queue
> owner. The check reads the queue->owner field without taking the queue
> lock, creating a race condition with functions that set the queue owner,
> such as vb2_ioctl_reqbufs() for instance.
> 
> Fix this by moving the queue->owner check within the mutex protected
> section.
> 
> Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> Acked-by: Hans Verkuil <hans.verkuil@cisco.com>

Acked-by: Sylwester Nawrocki <s.nawrocki@samsung.com>

